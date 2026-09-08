#import "i18n.typ": i18n

/// 標準themeの記事で使用する執筆環境表。
#let env(..items) = context {
  heading(outlined: false, numbering: none, i18n.writing_env)
  table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    align: horizon,
    stroke: (x, y) => if y == 0 { (bottom: 1pt + black) } else { (bottom: 0.5pt + gray) },
    table.header(i18n.env_software, i18n.env_version, i18n.env_notes),
    ..items
      .pos()
      .map(item => (
        item.at(0),
        item.at(1),
        item.at(2, default: [---]),
      ))
      .flatten(),
  )
}
