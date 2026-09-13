// サイトで有効にする拡張を登録する。
// 独自拡張は、そのモジュールが公開する extension をこの配列へ追加する。
#import "/extensions/alerts.typ": alert-extension
#import "/extensions/youtube.typ": youtube-extension

#let extensions = (
  alert-extension,
  youtube-extension,
)

#metadata(extensions) <extensions-meta>
