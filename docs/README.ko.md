# Typst Blog Template

문서 버전: 2026.05.25.1

언어: [日本語](../README.md) | [English](README.en.md) | 한국어 | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

Typst의 HTML 출력을 사용해 블로그를 작성하기 위한 작은 정적 사이트 템플릿입니다.
글 본문, 글 메타데이터, 사이트 설정은 Typst에서 관리하고, `build.py`가 HTML, RSS, sitemap을 생성합니다.

이 README를 업데이트할 때는 `docs/` 안의 번역 파일도 함께 업데이트하고 문서 버전을 맞춰 주세요.

## 요구 사항

- Typst 0.14.2 이상
- Python 3.10 이상

## 빠른 시작

```sh
python3 build.py
```

생성된 파일은 `public/`에 출력됩니다.
로컬에서 확인하려면 원하는 정적 파일 서버로 `public/`을 제공하세요.

```sh
python3 -m http.server 8000 -d public
```

## 사이트 설정

사이트 전체 설정의 원본은 `site.typ`입니다.
먼저 다음 값을 수정하세요.

- `title`: 블로그 이름
- `description`: 블로그 설명
- `base_url`: 공개 URL
- `author`: 작성자 이름, 프로필, 소셜 링크
- `analytics.cloudflare_token`: Cloudflare Web Analytics를 사용할 때만 설정
- `feedback.google_form_url` 및 `feedback.entry_id`: Google Forms를 사용할 때만 설정
- `share`: X, Misskey, 복사 공유 버튼의 표시 설정

## 폰트 설정

`site.typ`의 `fonts` 블록에서 본문·제목·코드·수식·커스텀 폰트를 통합 관리합니다.
`web` 필드를 가진 모든 항목은 Google Fonts에서 자동으로 불러오고, `--font-{키}` 라는 CSS 변수로 사용할 수 있습니다.

| 키 | 설명 |
|----|------|
| `main` | 본문 폰트（필수） |
| `heading` | 제목 폰트（생략하면 `main`을 상속） |
| `code` | 코드 블록 폰트（필수） |
| `math` | 수식 폰트. PDF 전용 — 웹에서 수식은 SVG로 베이크되므로 `web: none`으로 설정 |
| 임의의 이름 | `accent` 등 원하는 키로 추가 가능. CSS 변수 `--font-{키}`가 자동 생성됨 |

각 항목의 필드:

- `pdf`: PDF 출력에 사용할 폰트 이름（문자열 또는 폴백 체인 배열）
- `web`: Google Fonts 폰트 이름（`none`으로 설정하면 웹에서 불러오지 않음）
- `weights`: Google Fonts에 요청할 굵기（예: `"400;700"`, `"300..700"`）
- `fallback`: CSS 일반 폰트 패밀리（예: `"serif"`, `"sans-serif"`, `"monospace"`）

글 안에서 특정 단어의 폰트만 바꾸려면 `text` 함수를 사용합니다:

```typst
#text(font: "Zen Antique")[특별한 단어]
```

해당 폰트를 `site.fonts`에 등록해 두면 웹에서도 확실히 불러옵니다.

## 글 작성

글마다 디렉터리를 만들고 그 안에 `index.typ` 파일을 둡니다.
`example-post/index.typ`를 복사해서 시작하는 것이 가장 쉽습니다.

```typst
#import "../template.typ": article, calver

#let meta = (
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "글에 대한 짧은 설명입니다.",
  tags: ("Typst",),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Introduction

Write your post here.
```

`slug`는 공개 URL이 됩니다. 위 예시는 `/my-first-post/`로 출력됩니다.
`create`는 CalVer 형식입니다. `calver(26, 1, 1)`처럼 연도를 두 자리로 쓸 수 있습니다. 연월일은 생략할 수 없고 패치 번호만 생략할 수 있으며, 생략하면 `0`으로 처리됩니다.
메타데이터에 `draft: true`를 추가하면 글 목록, RSS, sitemap, HTML 출력에서 제외됩니다.

## GitHub Pages로 게시

이 템플릿에는 GitHub Pages용 워크플로가 포함되어 있습니다.

1. 이 템플릿으로 저장소를 만듭니다.
2. 자신의 사이트에 맞게 `site.typ`를 수정합니다.
3. GitHub에서 `Settings` -> `Pages` -> `Build and deployment`를 열고 `Source`를 `GitHub Actions`로 설정합니다.
4. `main` 브랜치에 push합니다.

워크플로는 `python3 build.py`를 실행하고 `public/`을 GitHub Pages에 배포합니다.

## Misskey 아이콘 안내

Misskey 공유 버튼과 사이드바의 Misskey 아이콘은 기본적으로 활성화되어 있습니다.
포함된 Misskey 아이콘은 Simple Icons에서 가져온 것이며 Misskey project가 CC-BY-NC-SA-4.0으로 제공합니다.
상업적 이용 등 이 조건이 사용 목적에 맞지 않는 경우 `typst/components/widgets.typ`의 Misskey 아이콘을 삭제하거나 교체하고, `site.typ`의 `share.misskey`를 `false`로 설정하세요.

## 라이선스

이 템플릿의 코드는 MIT License로 제공됩니다.
