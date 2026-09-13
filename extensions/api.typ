// template 側の拡張が共有する公開 API。
// core の配置を各拡張へ漏らさず、このファイルで境界を吸収する。
#import "/theme/api.typ": core

#let extension = core.extension
#let export-target = core.export-target
