/// 標準theme固有の設定を構築する。
#let theme-config(
  color_scheme: "dark",
  cloudflare_token: none,
  navigation: (),
  article_actions: (
    share: (x: true, misskey: true, copy: true),
    feedback: (google_form_url: none, entry_id: none),
  ),
) = {
  assert(type(color_scheme) == str and color_scheme != "", message: "theme.color_scheme: 空でない文字列が必要です")
  assert(
    color_scheme.clusters().all(character =>
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-".contains(character)
    ),
    message: "theme.color_scheme: 英数字・アンダースコア・ハイフンのみ使用可能です",
  )
  let _stylesheet = read("/theme/static/color-schemes/" + color_scheme + ".css")

  assert(
    cloudflare_token == none or type(cloudflare_token) == str,
    message: "theme.cloudflare_token: none か文字列が必要です",
  )

  assert(type(navigation) == array, message: "theme.navigation: 配列が必要です")
  for (index, item) in navigation.enumerate() {
    assert(type(item) == dictionary, message: "theme.navigation.at(" + str(index) + "): 辞書が必要です")
    assert(
      item.keys().all(key => key in ("label", "path", "url")),
      message: "theme.navigation.at(" + str(index) + "): label, path, url 以外のキーは使用できません",
    )
    assert(
      type(item.at("label", default: none)) == str and item.label.trim() != "",
      message: "theme.navigation.at(" + str(index) + ").label: 空でない文字列が必要です",
    )
    let has-path = "path" in item
    let has-url = "url" in item
    assert(has-path != has-url, message: "theme.navigation.at(" + str(index) + "): path か url のどちらか一方が必要です")
    if has-path {
      assert(
        type(item.path) == str and item.path.starts-with("/") and not item.path.starts-with("//"),
        message: "theme.navigation.at(" + str(index) + ").path: / で始まるサイト内パスが必要です",
      )
    } else {
      assert(
        type(item.url) == str and (item.url.starts-with("https://") or item.url.starts-with("http://")),
        message: "theme.navigation.at(" + str(index) + ").url: http:// か https:// で始まるURLが必要です",
      )
    }
  }

  assert(type(article_actions) == dictionary, message: "theme.article_actions: 辞書が必要です")
  assert(
    article_actions.keys().all(key => key in ("share", "feedback")),
    message: "theme.article_actions: share, feedback 以外のキーは使用できません",
  )
  let share = article_actions.at("share", default: (:))
  assert(type(share) == dictionary, message: "theme.article_actions.share: 辞書が必要です")
  for service in ("x", "misskey", "copy") {
    assert(
      type(share.at(service, default: false)) == bool,
      message: "theme.article_actions.share." + service + ": true/false が必要です",
    )
  }
  let feedback = article_actions.at("feedback", default: (:))
  assert(type(feedback) == dictionary, message: "theme.article_actions.feedback: 辞書が必要です")
  let feedback-url = feedback.at("google_form_url", default: none)
  let feedback-entry-id = feedback.at("entry_id", default: none)
  assert(
    feedback-url == none or (type(feedback-url) == str and (feedback-url.starts-with("https://") or feedback-url.starts-with("http://"))),
    message: "theme.article_actions.feedback.google_form_url: none か http(s) URL が必要です",
  )
  assert(
    feedback-entry-id == none or type(feedback-entry-id) == str,
    message: "theme.article_actions.feedback.entry_id: none か文字列が必要です",
  )

  (
    color_scheme: color_scheme,
    cloudflare_token: cloudflare_token,
    navigation: navigation,
    article_actions: (
      share: (
        x: share.at("x", default: false),
        misskey: share.at("misskey", default: false),
        copy: share.at("copy", default: false),
      ),
      feedback: (
        google_form_url: feedback-url,
        entry_id: feedback-entry-id,
      ),
    ),
  )
}
