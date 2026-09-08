# Create a Blog Extension

A blog extension groups a Typst authoring function with the CSS and JavaScript needed to render it. The built-in alerts (`note`, `warning`, and so on) and YouTube embed use this same mechanism.

A custom extension uses these locations:

```text
extensions/
└── marker.typ
static/extensions/marker/
├── style.css
└── main.js
extensions.typ
```

## 1. Declare the Typst API and assets

Create `extensions/marker.typ`:

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

Paths in `styles` and `scripts` are relative to `static/`. HTTPS URLs are also accepted. Local JavaScript is loaded as an ES module.

HTML, CSS, and JavaScript are unavailable in paged output such as PDF. Use `export-target()` to return a meaningful fallback, as the example does.

## 2. Add CSS and JavaScript

Create `static/extensions/marker/style.css`:

```css
.marker-extension {
  padding: 1rem;
  border-inline-start: 4px solid var(--accent-color);
  background: var(--card-bg);
}
```

Create `static/extensions/marker/main.js`:

```js
document.querySelectorAll(".marker-extension").forEach((element) => {
  element.dataset.enhanced = "true";
});
```

The build copies everything below `static/` to the published site. Giving each extension its own directory avoids name collisions.

## 3. Enable the extension

Add the import and registration to the root `extensions.typ`. Built-in extensions are entries in this same array.

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

Registering the same extension name twice is a build error. Array order determines CSS and JavaScript loading order.

## 4. Use it from a post

Import only the authoring function needed by the post:

```typst
#import "/template.typ": post, calver
#import "/extensions/marker.typ": marker

// Post metadata, then content...

#marker[
  Content rendered by the custom extension.
]
```

A Bluesky embed follows the same structure: generate its markup in `extensions/bluesky.typ`, keep its presentation and initialization in `static/extensions/bluesky/`, and register `bluesky-extension` in `extensions.typ`. Like the built-in extensions, it lives entirely on the template side and requires no core change.

## Security

Extension JavaScript runs in the blog page and can access its content and browser storage. Register only code you control or have reviewed and trust. An external HTTPS script can change independently whenever its provider updates it.
