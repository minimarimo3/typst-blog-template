# ブログ拡張を作る

ブログ拡張は、記事で使う Typst 関数と、その表示に必要な CSS・JavaScript をひとまとまりにする仕組みです。標準の alert（`note`、`warning` など）と YouTube 埋め込みも、この仕組みで読み込まれています。

独自拡張は次の3か所に置きます。

```text
extensions/
└── marker.typ
static/extensions/marker/
├── style.css
└── main.js
extensions.typ
```

## 1. Typst 関数と必要なファイルを宣言する

`extensions/marker.typ` を作ります。

```typst
#import "/extensions/api.typ": extension, export-target

#let marker-extension = extension(
  "marker",
  styles: ("extensions/marker/style.css",),
  scripts: ("extensions/marker/main.js",),
)

#let marker(body) = context {
  if export-target() == "paged" {
    return body
  }

  html.div(class: "marker-extension", body)
}
```

`extension(...)` の `styles` と `scripts` は、`static/` からの相対パスです。HTTPS URL も指定できます。ローカル JavaScript は ES module として読み込まれます。

PDF などの paged 出力では HTML・CSS・JavaScript が使えません。上の例のように `export-target()` を確認し、意味の通る代替表示を返してください。

## 2. CSS と JavaScript を置く

`static/extensions/marker/style.css`:

```css
.marker-extension {
  padding: 1rem;
  border-inline-start: 4px solid var(--accent-color);
  background: var(--card-bg);
}
```

`static/extensions/marker/main.js`:

```js
document.querySelectorAll(".marker-extension").forEach((element) => {
  element.dataset.enhanced = "true";
});
```

ビルドは `static/` の中身をそのまま公開先へコピーします。拡張ごとにサブディレクトリを分けると、名前の衝突を避けられます。

## 3. 拡張を有効にする

ルートの `extensions.typ` に import と登録を追加します。標準拡張もまったく同じ配列に登録されています。

```typst
#import "/extensions/alerts.typ": alert-extension
#import "/extensions/youtube.typ": youtube-extension
#import "/extensions/marker.typ": marker-extension

#let extensions = (
  alert-extension,
  youtube-extension,
  marker-extension,
)
```

同じ名前の拡張を2回登録すると、ビルドはエラーになります。配列の順序が CSS と JavaScript の読み込み順です。

## 4. 記事から使う

記事側では、必要な関数だけを拡張モジュールから import します。

```typst
#import "/template.typ": post, calver
#import "/extensions/marker.typ": marker

// 記事メタデータなど

#marker[
  独自拡張で表示する内容です。
]
```
