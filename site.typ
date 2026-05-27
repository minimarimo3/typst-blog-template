#import "/typst/core/site-impl.typ": _site

// ─── サイト設定 ───────────────────────────────────────────────────────────────
#let site = _site(
  title: "My Typst Blog",
  description: "Typstで書く小さなブログです。",
  base_url: "https://minimarimo3.github.io/typst-blog-template",
  language: "ja",
  theme: "dark",
  fonts: (
    main: (
      pdf: "Noto Serif CJK JP",
      web: "Noto Serif JP",
      weights: "400;700",
      fallback: "serif",
    ),
    // heading フォント（省略すれば main フォントが使われる）
    // heading: (
    //   pdf: "Noto Sans CJK JP",
    //   web: "Noto Sans JP",
    //   weights: "400;700",
    //   fallback: "sans-serif",
    // ),
    code: (
      pdf: ("Fira Code", "Consolas", "monospace"),
      web: "Fira Code",
      weights: "300..700",
      fallback: "monospace",
    ),
    // 数式フォントは PDF のみ有効。web は SVG にベイクされるため web: none にする。
    // math: (
    //   pdf: "STIX Two Math",
    //   web: none,
    //   weights: none,
    //   fallback: none,
    // ),
    // 任意の名前でフォントを追加できる。--font-{key} という CSS 変数になる。
    // accent: (
    //   pdf: "Zen Antique",
    //   web: "Zen Antique",
    //   weights: "400",
    //   fallback: "serif",
    // ),
  ),
  author: (
    name: "Your Name",
    bio: "Typstでブログを書いています。",
    socials: (
      x: "",
      misskey: "https://misskey.io/@yourname",
      github: "https://github.com/yourname",
    ),
  ),
  analytics: (
    cloudflare_token: none,
  ),
  feedback: (
    google_form_url: none,
    entry_id: none,
  ),
  share: (
    x: true,
    misskey: true,
    copy: true,
  ),
)

#metadata(site) <site-meta>
