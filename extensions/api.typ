// template 側の拡張が共有する公開 API。
// core の配置を各拡張へ漏らさず、このファイルで境界を吸収する。
#import "/vendor/typst-blog-core/typst/core/extensions.typ": extension as core-extension
#import "/vendor/typst-blog-core/typst/core/shared.typ": export-target as core-export-target

#let extension = core-extension
#let export-target = core-export-target
