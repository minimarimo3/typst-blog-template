// templateが利用するcore APIのfacade。
// moduleを名前空間のまま転送するため、coreに公開APIが追加されても更新は不要。
#import "/vendor/typst-blog-core/typst/api.typ" as core-api

#let core = core-api
