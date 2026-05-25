#let site = (
  title: "My Typst Blog",
  description: "Typstで書く小さなブログです。",
  base_url: "https://example.com",
  language: "en",
  fonts: (
    main: (
      pdf: "Noto Serif CJK JP",
      web: "Noto Serif JP",
      weights: "400;700",
    ),
    code: (
      pdf: ("Fira Code", "Consolas", "monospace"),
      web: "Fira Code",
      weights: "300..700",
    ),
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
