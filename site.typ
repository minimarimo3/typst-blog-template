#import "/vendor/typst-blog-core/typst/site-api.typ" as core-site-api
#import "/theme/config.typ": theme-config

// ─── サイト設定 ───────────────────────────────────────────────────────────────
#let site = core-site-api.site(
  title: "My Typst Blog",
  description: "Typstで書く小さなブログです。",
  base_url: "https://minimarimo3.github.io/typst-blog-template",
  github_repo: "https://github.com/minimarimo3/typst-blog-template",
  // "ja" の短縮形、または (lang: "zh", region: "TW", script: "hani") を指定できる。
  // region は省略可、script の既定値は auto。
  language: "ja",
  theme: theme-config(
    color_scheme: "dark",
    // 任意。空のままならナビゲーションは表示されない。
    navigation: (),
    article_actions: (
      share: (
        x: true,
        misskey: true,
        copy: true,
      ),
      feedback: (
        google_form_url: none,
        entry_id: none,
      ),
    ),
  ),
  // 記事を posts/ 配下にまとめる場合は "posts" にする。
  posts_dir: ".",
  // "git" は記事ディレクトリの最終コミット日を更新日として自動表示する。
  update_policy: "git",
  // 記事・固定ページのディレクトリから、HTML と同じ出力先へコピーするファイル拡張子。
  asset_extensions: (
    ".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".avif",
    ".mp4", ".webm", ".ogv", ".mov",
    ".mp3", ".m4a", ".ogg", ".oga", ".wav", ".flac", ".aac",
    ".woff", ".woff2", ".ttf", ".otf",
    ".pdf", ".js", ".yaml", ".yml", ".bib", ".txt",
  ),
  fonts: (
    main: (
      pdf: ("Noto Serif", "Noto Serif CJK JP"),
      web: ("Noto Serif", "Noto Serif JP"),
      weights: "400;700",
      fallback: "serif",
    ),
    // heading フォント（省略すれば main フォントが使われる）
    // heading: (
    //   pdf: "Noto Sans CJK JP",
    //   web: ("Noto Sans", "Noto Sans JP"),
    //   weights: "400;700",
    //   fallback: "sans-serif",
    // ),
    code: (
      pdf: ("Fira Code", "Consolas", "monospace"),
      web: ("Fira Code",),
      weights: "300..700",
      fallback: "monospace",
    ),
    // math: (
    //   pdf: "STIX Two Math",
    //   web: none,
    //   weights: none,
    //   fallback: none,
    // ),
    // 任意の名前でフォントを追加できる。--font-{key} という CSS 変数になる。
    // accent: (
    //   pdf: "Zen Antique",
    //   web: ("Zen Antique",),
    //   weights: "400",
    //   fallback: "serif",
    // ),
  ),
  author: (
    name: "Your Name",
    bio: "Typstでブログを書いています。",
    links: (
      (id: "misskey", label: "Misskey", url: "https://misskey.io/@yourname"),
      (id: "github", label: "GitHub", url: "https://github.com/yourname"),
    ),
  ),
  analytics: (
    cloudflare_token: none,
  ),
)

#metadata(site) <site-meta>
