#let site = (
  title: "My Typst Blog",
  description: "Typstで書く小さなブログです。",
  base_url: "https://example.com",
  language: "en",
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
