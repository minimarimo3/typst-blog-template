// templateが利用するcore APIのfacade。
// moduleを名前空間のまま転送するため、coreに公開APIが追加されても更新は不要。
#import "/vendor/typst-blog-core/typst/api.typ" as core-api

#let supported-core-api-version = 1
#assert(
  core-api.api-version == supported-core-api-version,
  message: "core API version mismatch: this theme requires version "
    + str(supported-core-api-version)
    + ", but vendor/typst-blog-core provides version "
    + str(core-api.api-version)
    + ". Update the core and theme together.",
)

#let core = core-api
