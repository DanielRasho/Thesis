// ──────────────────────────────────────────────
// Semantic Differential / Likert Table
// ──────────────────────────────────────────────
//
// Usage:
//   #likert-table(
//     pairs: (("Fácil", "Difícil"), ("Claro", "Confuso")),
//     grades: 5,       // number of grade columns (odd number recommended)
//     show-numbers: true,  // show grade numbers above columns
//   )
// ──────────────────────────────────────────────

#let likert-table(
  pairs: (),
  grades: 5,
  show-numbers: true,
) = {
  // Build header row
  let header = (
    table.cell(align: right)[*Concepto*],
  )
  if show-numbers {
    for i in range(1, grades + 1) {
      header.push(table.cell(align: center)[#i])
    }
  } else {
    for i in range(grades) {
      header.push(table.cell(align: center)[])
    }
  }
  header.push(table.cell(align: left)[*Concepto*])

  // Build data rows
  let rows = ()
  for pair in pairs {
    let (left, right) = pair
    rows.push(table.cell(align: center)[#left])
    for i in range(grades) {
      rows.push(table.cell(align: center)[
        box(width: 0.45cm, height: 0.45cm, stroke: 0.7pt + black, radius: 1pt)
      ])
    }
    rows.push(table.cell(align: center)[#right])
  }

  // Column widths: word | grade cols | word
  let col-widths = (auto,) + (1fr,) * grades + (auto,)

  table(
    columns: col-widths,
    stroke: 0.5pt + luma(180),
    inset: 6pt,
    fill: (x, y) => if y == 0 { luma(220) } else if calc.odd(y) { luma(245) } else { white },
    ..header,
    ..rows,
  )
}

// ──────────────────────────────────────────────
// Example
// ──────────────────────────────────────────────

#likert-table(
  pairs: (
    ("Fácil",     "Difícil"),
    ("Claro",     "Confuso"),
    ("Natural",   "Forzado"),
    ("Conciso",   "Verboso"),
    ("Intuitivo", "Críptico"),
  ),
  grades: 3,
  show-numbers: true,
)
