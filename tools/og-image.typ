#import "/vendor/typst-blog-core/typst/api.typ": main-font, heading-font

#let title = sys.inputs.at("title")
#let description = sys.inputs.at("description")
#let site-title = sys.inputs.at("site-title")
#let title-length = title.clusters().len()
#let title-size = if title-length <= 18 {
  64pt
} else if title-length <= 32 {
  54pt
} else if title-length <= 50 {
  44pt
} else {
  36pt
}

#set page(width: 1200pt, height: 630pt, margin: 0pt, fill: rgb("#111827"))
#set text(font: main-font, fill: rgb("#e5e7eb"))

#place(top + left, dx: 76pt, dy: 64pt, rect(width: 112pt, height: 8pt, radius: 4pt, fill: rgb("#64b5f6")))

#place(
  top + left,
  dx: 76pt,
  dy: 112pt,
  block(width: 1048pt, height: 250pt, clip: true)[
    #set text(font: heading-font, size: title-size, weight: "bold", fill: white)
    #set par(leading: 0.14em)
    #title
  ],
)

#place(
  top + left,
  dx: 80pt,
  dy: 402pt,
  block(width: 1038pt, height: 92pt, clip: true)[
    #set text(size: 25pt, fill: rgb("#b8c2d1"))
    #set par(leading: 0.25em)
    #description
  ],
)

#place(
  bottom + left,
  dx: 80pt,
  dy: -60pt,
  text(font: heading-font, size: 22pt, weight: "bold", fill: rgb("#64b5f6"), site-title),
)
