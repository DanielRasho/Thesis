#!/usr/bin/env python3
"""
Render the Firefox dependency graph (Appendix5) from the SPDX 2.3 SBOM
in ../mozilla-firefox_dependencies.json.

The SBOM lists 21,295 packages and 37,926 DEPENDS_ON relationships
(`spdxElementId` DEPENDS_ON `relatedSpdxElement`, i.e. source -> target
means "source depends on target"). That is too dense to lay out with
readable labels, so this script produces two complementary figures:

  1. full graph   - every package, unlabeled, colored by ecosystem
                     (npm/cargo/pypi/other, from each package's purl).
                     Illustrates the *scale* argument made in the thesis
                     text next to Appendix5.
  2. hub subgraph  - the N most-connected packages, labeled. Built from a
                     name-aggregated version of the graph, because the
                     monorepo resolves the same package name to many
                     distinct SPDXIDs (unpinned duplicate versions across
                     nested node_modules trees) - aggregating avoids
                     drawing e.g. "babel-runtime" as six separate nodes.

Usage:
    python3 generate_dependency_graphs.py

Requires the Graphviz `sfdp` binary on PATH (no Python graph libraries
needed - stdlib json/subprocess only). Output goes to
../../../media/figures/Figure3.png (full graph) and Figure4.svg (hubs).
"""
import json
import re
import subprocess
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
SBOM_PATH = HERE / "../mozilla-firefox_dependencies.json"
FIGURES_DIR = HERE / "../../../media/figures"
FULL_OUT = FIGURES_DIR / "Figure3.png"
HUBS_OUT = FIGURES_DIR / "Figure4.svg"

HUB_COUNT = 120  # size of the labeled hub subgraph

# Categorical color assignment (dataviz skill's validated palette, CVD-safe
# under --pairs all for 3 hues): npm/cargo/pypi get the first three
# categorical slots; everything else (gem, github, githubactions - together
# <0.5% of packages) folds into a neutral "other" gray rather than adding
# more competing hues.
COLORS = {
    "npm": "#2a78d6",
    "cargo": "#eb6834",
    "pypi": "#1baf7a",
    "other": "#898781",
}


def parse_sbom(path):
    """Load the SPDX packages/relationships into plain dicts keyed by SPDXID."""
    with open(path) as f:
        data = json.load(f)

    pkgs = {}
    for p in data["packages"]:
        spdxid = p["SPDXID"]
        purl = next(
            (r["referenceLocator"] for r in p.get("externalRefs", [])
             if r.get("referenceType") == "purl"),
            None,
        )
        eco = "unknown"
        if purl:
            m = re.match(r"pkg:([^/]+)/", purl)
            eco = m.group(1) if m else "unknown"
        pkgs[spdxid] = {
            "name": p.get("name", spdxid),
            "eco": eco,
            "slot": eco if eco in ("npm", "cargo", "pypi") else "other",
        }

    edges, seen = [], set()
    for r in data["relationships"]:
        if r["relationshipType"] != "DEPENDS_ON":
            continue
        s, t = r["spdxElementId"], r["relatedSpdxElement"]
        if s not in pkgs or t not in pkgs or (s, t) in seen:
            continue
        seen.add((s, t))
        edges.append((s, t))

    return pkgs, edges


def aggregate_by_name(pkgs, edges):
    """Collapse (name, ecosystem) duplicates into single logical nodes."""
    key_of = {spdxid: (p["name"], p["eco"]) for spdxid, p in pkgs.items()}
    slot_of = {key_of[spdxid]: p["slot"] for spdxid, p in pkgs.items()}
    agg_edges = {(key_of[s], key_of[t]) for s, t in edges if key_of[s] != key_of[t]}
    return slot_of, list(agg_edges)


def degrees(edges, nodes):
    indeg, outdeg = Counter(), Counter()
    for s, t in edges:
        outdeg[s] += 1
        indeg[t] += 1
    return indeg, outdeg


def print_stats(pkgs, edges, agg_slot, agg_edges, agg_indeg, agg_outdeg):
    eco_counts = Counter(p["eco"] for p in pkgs.values())
    print(f"packages: {len(pkgs)}  |  DEPENDS_ON edges: {len(edges)}")
    print(f"ecosystems: {eco_counts.most_common()}")
    print(f"aggregated by name: {len(agg_slot)} nodes, {len(agg_edges)} edges")
    total_deg = {k: agg_indeg[k] + agg_outdeg[k] for k in agg_slot}
    print(f"\ntop 10 most-shared packages (aggregated in-degree):")
    for k, d in agg_indeg.most_common(10):
        print(f"  {k[0]:30s} eco={k[1]:6s} in={d:4d} out={agg_outdeg[k]}")


def dot_escape(s):
    return s.replace('"', "'")


def write_full_dot(pkgs, edges, out_path):
    root_id = next(
        (k for k, p in pkgs.items() if p["name"] == "com.github.mozilla-firefox/firefox"),
        None,
    )
    lines = [
        "graph full {",
        "  outputorder=edgesfirst;",
        '  bgcolor="transparent";',
        "  node [shape=point, style=filled, peripheries=0, width=0.045, height=0.045];",
        '  edge [color="#89878128", penwidth=0.4];',
    ]
    for spdxid, p in pkgs.items():
        if spdxid == root_id:
            lines.append(f'  "{spdxid}" [width=0.22, height=0.22, color="#0b0b0b"];')
        else:
            lines.append(f'  "{spdxid}" [color="{COLORS[p["slot"]]}"];')
    for s, t in edges:
        lines.append(f'  "{s}" -- "{t}";')
    lines.append("}")
    out_path.write_text("\n".join(lines))


def write_hubs_dot(agg_slot, agg_edges, agg_indeg, agg_outdeg, out_path, n):
    total_deg = {k: agg_indeg[k] + agg_outdeg[k] for k in agg_slot}
    top = set(sorted(total_deg, key=total_deg.get, reverse=True)[:n])
    sub_edges = [(s, t) for s, t in agg_edges if s in top and t in top]
    max_deg = max(total_deg[k] for k in top)

    def node_id(key):
        return dot_escape(key[0] + "|" + key[1])

    lines = [
        "digraph hubs {",
        "  layout=sfdp;",
        '  overlap="scale";',
        "  splines=true;",
        '  bgcolor="transparent";',
        "  outputorder=edgesfirst;",
        '  node [shape=ellipse, style=filled, fontname="Helvetica", '
        'fontcolor="#0b0b0b", color="#00000000"];',
        '  edge [color="#89878180", penwidth=0.6, arrowsize=0.5];',
    ]
    for key in top:
        frac = total_deg[key] / max_deg
        size = 0.28 + 0.55 * frac  # inches, capped ~0.83
        fontsize = 7 + round(6 * frac)
        lines.append(
            f'  "{node_id(key)}" [label="{dot_escape(key[0])}", '
            f'fillcolor="{COLORS[agg_slot[key]]}", '
            f'width={size:.2f}, height={size * 0.55:.2f}, fontsize={fontsize}];'
        )
    for s, t in sub_edges:
        lines.append(f'  "{node_id(s)}" -> "{node_id(t)}";')
    lines.append("}")
    out_path.write_text("\n".join(lines))
    print(f"hub subgraph: {len(top)} nodes, {len(sub_edges)} edges")


def render(dot_path, out_path, fmt, extra_args=()):
    out_path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["sfdp", f"-T{fmt}", *extra_args, str(dot_path), "-o", str(out_path)],
        check=True,
    )
    print(f"rendered {out_path}")


def main():
    pkgs, edges = parse_sbom(SBOM_PATH)
    agg_slot, agg_edges = aggregate_by_name(pkgs, edges)
    agg_indeg, agg_outdeg = degrees(agg_edges, agg_slot)
    print_stats(pkgs, edges, agg_slot, agg_edges, agg_indeg, agg_outdeg)

    full_dot = HERE / "full.dot"
    hubs_dot = HERE / "hubs.dot"
    write_full_dot(pkgs, edges, full_dot)
    write_hubs_dot(agg_slot, agg_edges, agg_indeg, agg_outdeg, hubs_dot, HUB_COUNT)

    # Full graph: rasterized (an SVG with ~38k edges is impractically large),
    # moderate DPI - it's a dense scatter, not something readers zoom into.
    render(full_dot, FULL_OUT, "png",
           ["-Goverlap=false", "-Gsize=13,13!", "-Gdpi=220"])
    # Hub subgraph: vector, since labels must stay crisp at any zoom.
    render(hubs_dot, HUBS_OUT, "svg", ["-Gsize=10,8"])


if __name__ == "__main__":
    main()
