# ビルドパイプラインを拡張する

ルートの`blog.py`から、`vendor/typst-blog-core`を変更せずにPython処理を登録できます。
coreは公開ビルドとpreview再ビルドのたびに`configure(pipeline)`を読み直します。

拡張点は次の4種類です。

| 登録 | 実行時点 | 主な用途 |
| --- | --- | --- |
| `post_output` | HTMLより前に、対象記事ごとに1回 | 記事PDF、記事単位のEPUB |
| `site_output` | HTMLより前に1回 | ブログ全体のEPUB、JSON、アーカイブ |
| `after_html` | サイト構築後、HTMLファイルごとに1回 | minify、HTMLの書き換え |
| `post_build` | 全ファイルと`after_html`の完了後 | Pagefind、checksum、成果物一覧 |

hookは登録順に実行されます。例外、subprocessの0以外の終了、宣言したファイルを
生成しなかった出力処理は、いずれもビルド失敗になります。出力先は`public/`を
変更する前に検証され、出力ディレクトリの外へ出るパスや、記事・static asset・
別の生成URLとの衝突は拒否されます。

## 各記事のPDFを生成してリンクする

ルートの`blog.py`を次のようにします。

```python
def build_pdf(task):
    task.run_typst(
        "compile",
        "--root",
        ".",
        task.relative(task.post.source_file),
        task.relative(task.destination),
    )


def configure(pipeline):
    pipeline.post_output(
        id="pdf",
        filename="article.pdf",
        label="PDF",
        media_type="application/pdf",
        build=build_pdf,
        modes={"build", "preview"},
    )
```

`hello`という記事なら`public/hello/article.pdf`が生成されます。rendererには、
正規化された次の情報が`data.post.outputs`として渡されます。

```typst
(
  id: "pdf",
  label: "PDF",
  media-type: "application/pdf",
  path: "/hello/article.pdf",
  url: "/hello/article.pdf",
)
```

`path`はpreview用base pathを含まない公開パス、`url`は現在のbase pathを含む
theme向けリンクです。標準themeは編集履歴の横に追加出力を表示します。独自themeでは
`data.post.outputs`を列挙し、好きな位置へ配置できます。

標準テンプレートは出力ID `og-image`を、OGP・Twitter Card・JSON-LD共通の
生成画像として予約しています。記事側で`og-image`が明示されていない場合、標準themeは
既存の`data.post.outputs`契約からこの出力を見つけて使います。このsocial imageは
記事のダウンロードリンクには表示されません。

追加出力の既定モードは`{"build"}`です。preview再ビルドのたびに生成してもよい場合だけ、
明示的に`"preview"`を追加してください。

## ブログ全体の成果物を生成する

ブログ全体に一つの成果物を作る場合は`site_output`を使います。

```python
def build_epub(task):
    task.run(["python3", "tools/build_epub.py", task.relative(task.destination)])


def configure(pipeline):
    pipeline.site_output(
        id="epub",
        filename="downloads/blog.epub",
        label="EPUB",
        media_type="application/epub+zip",
        build=build_epub,
    )
```

サイト単位の出力情報は、home rendererの`data.outputs`へ渡されます。

## HTMLを後処理する

`after_html`は`public/`以下のすべての`.html`を受け取ります。`static/`からコピーされた
HTMLも対象です。`modes`を省略すると、buildとpreviewの両方で実行されます。

```python
def add_marker(task):
    source = task.path.read_text(encoding="utf-8")
    task.path.write_text(source.replace("</body>", "<!-- built --></body>"), encoding="utf-8")


def configure(pipeline):
    pipeline.after_html(id="build-marker", run=add_marker)
```

`task.output_path`はトップページなら`/`、それ以外は`/hello/index.html`のような
`public/`以下のパスです。

## ローカル成果物の完成後に処理する

`post_build`は、完成したローカル成果物を処理するためのhookです。

```python
def build_search(task):
    task.run(["npx", "-y", "pagefind@1.5.2", "--site", "public"])


def configure(pipeline):
    pipeline.post_build(id="pagefind", run=build_search)
```

既定モードは`{"build"}`なので、preview中に繰り返し実行されません。

`post_build`が表すのは「ローカルの`public/`が完成した」であり、GitHub Pagesへの
デプロイ成功ではありません。Discord通知は`actions/deploy-pages`より後のworkflow stepに
置いてください。その位置なら、実際の公開URLと保護されたWebhook secretを利用できます。

## callbackへ渡される情報

すべてのcallbackは、絶対パスの`root_dir`、`build_dir`、`output_dir`、モード
（`"build"`または`"preview"`）、読み取り専用として扱うサイト設定、対象記事一覧を
受け取ります。`post_output`には`task.post`と`task.destination`も渡されます。
任意の投稿メタデータは`task.post.extra`から参照できます。coreはこのJSON互換辞書の
キーに意味を持たせず、そのまま保持します。

subprocessには`task.run([...])`、Typstには`task.run_typst(...)`を使えます。どちらも
ブログルートで実行され、0以外で終了するとビルドを失敗させます。coreはPythonやNodeの
依存パッケージを自動インストールしません。追加依存はブログ側のworkflowでバージョンを
固定してインストールしてください。

`blog.py`はビルドコマンドと同じファイル・ネットワーク権限を持つ信頼済みコードです。
第三者のhookは内容を確認し、pull requestビルドへデプロイ用secretを渡さないでください。
