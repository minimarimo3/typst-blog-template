/// 標準theme固有の設定を構築する。
#let theme-config(color_scheme: "dark") = {
  assert(type(color_scheme) == str and color_scheme != "", message: "theme.color_scheme: 空でない文字列が必要です")
  assert(
    color_scheme.clusters().all(character =>
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-".contains(character)
    ),
    message: "theme.color_scheme: 英数字・アンダースコア・ハイフンのみ使用可能です",
  )
  let _stylesheet = read("/theme/static/color-schemes/" + color_scheme + ".css")
  (color_scheme: color_scheme)
}
