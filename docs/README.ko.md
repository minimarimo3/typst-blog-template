# Typst Blog Template

Typst로 간편하게 정적 블로그를 만들고 공개할 수 있는 템플릿입니다. 복잡한 사이트 제작이나 SSG 도구 구축 없이 글쓰기에 집중할 수 있습니다.

글을 작성하고 빌드하기만 하면 홈, 글 본문, 태그 목록, RSS, Sitemap, 사이트 내 검색 인덱스(Pagefind)가 자동으로 생성됩니다.

- 데모 사이트(샘플 글): <https://minimarimo3.github.io/typst-blog-template/example-post/>
- 사용 예시(작성자 블로그): <https://www.minimarimo3.jp>

[日本語](README.ja.md) | [English](../README.md) | 한국어 | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

## 주요 특징

- Typst로 완결되는 집필 환경
글 본문뿐 아니라 사이트 전체 설정도 모두 Typst 문법으로 작성할 수 있습니다.
- 번거로운 설정 없는 자동 생성
홈, OGP 및 Meta 태그가 포함된 글 페이지, 태그 목록, RSS, Sitemap을 자동으로 생성합니다. Pagefind 기반 사이트 내 검색과 GitHub Pages 자동 배포(포함된 GitHub Actions)도 지원합니다.
- Git 연동 자동 수정일 설정 및 GitHub 스타일 Alerts 지원
Git 커밋 기록에서 수정일을 자동으로 반영합니다. `warning`, `note` 등의 GitHub 스타일 Alerts 문법이 기본으로 제공됩니다.
- 유지보수하기 쉬운 코어 분리 구조
블로그 엔진 본체(`vendor/typst-blog-core`)가 Git 서브모듈로 분리되어 있습니다. 향후 Typst의 HTML 출력 사양에 호환되지 않는 변경이 생겨도 글 데이터를 손상시키지 않고 코어만 업데이트해 대응할 수 있습니다.
- 유연한 사용자 정의
설정 파일(`site.typ`)의 간단한 설정부터 CSS 및 색상표 변경, HTML 구조(`theme/`) 변경, 사용자 정의 컴포넌트 추가까지 용도에 맞게 조정할 수 있습니다.

---

## 빠른 시작

### 1. 저장소 생성 및 가져오기

GitHub의 “Use this template” 버튼으로 자신만의 저장소를 만든 뒤 로컬에 클론합니다.

```sh
git clone --recurse-submodules https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

> Note
> 이미 클론했지만 `vendor/typst-blog-core` 디렉터리가 비어 있다면 다음 명령을 실행하세요.
> `git submodule update --init --recursive`

### 2. 사이트 설정 편집

`site.typ`을 열고 블로그 정보를 설정합니다.

```typst
#let site-config = (
  title: "내 블로그",
  description: "블로그 설명",
  base_url: "https://YOUR_USER.github.io/YOUR_REPO", // 사용자 정의 도메인이 있다면 해당 URL
  github_repo: "[https://github.com/YOUR_USER/YOUR_REPO](https://github.com/YOUR_USER/YOUR_REPO)",
  posts_dir: "posts", // 글 저장 위치("posts" 등의 디렉터리 이름 또는 ".")
  language: (
    lang: "zh",
    region: "TW",
    script: "hani",
  ),
  // 또는 줄여서 language: "ko"

  author: (
    name: "관리자 이름",
    bio: "프로필",
    links: (
      (id: "github", label: "GitHub", url: "https://github.com/YOUR_USER"),
    ),
  ),
  ... // 다른 설정도 있지만 필수 항목은 이 정도입니다
)
```

### 3. 새 글 작성

CLI 명령으로 글의 기본 틀을 생성합니다.

```sh
python3 command.py new post my-first-post --title "첫 번째 글" --tag "Typst"
```

실행하면 `{posts_dir}/my-first-post/index.typ`이 생성됩니다.

### 4. 로컬 미리보기

```sh
python3 command.py preview
```

`http://localhost:8000`에서 미리보기 서버가 시작됩니다.
파일을 저장하면 자동으로 다시 빌드되고 브라우저가 새로고침됩니다.

### 5. GitHub Pages에 공개

1. GitHub 저장소의 Settings → Pages를 엽니다
2. Build and deployment의 Source를 GitHub Actions로 변경합니다
3. `main` 브랜치에 `push`하면 자동으로 빌드 및 배포됩니다

---

## 글 작성 방법

글은 “글 하나 = 디렉터리 하나”로 관리합니다. 이미지와 관련 파일은 `index.typ`과 같은 디렉터리에 배치하세요.

### 글 파일의 기본 구조(`index.typ`)

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "첫 번째 글",
  create: calver(2026, 1, 1, 3),
  description: "글의 요약입니다.",
  tags: ("Typst", "일기"),
  draft: true, // 공개하려면 false로 변경
)

= 들어가며

여기에 본문을 작성합니다.

```

### 글 메타데이터 목록

| 항목 | 형식 | 설명 |
| --- | --- | --- |
| `title` | String | 필수. 글 제목 |
| `create` | `calver()` | 필수. 작성일(예: `calver(2026, 1, 1)`) |
| `description` | String | 글 목록, SEO, OGP에 사용되는 설명 |
| `tags` | Array | 태그 지정(한국어 또는 공백이 포함되어도 안전한 URL로 자동 변환) |
| `draft` | Boolean | `true`는 초안, `false`는 공개. 생략하면 `true` |
| `permalink` | String | 사용자 정의 URL(예: `"/notes/hello/"`) |
| `aliases` | Array | 리디렉션에 사용할 이전 URL 목록(예: `("/old-path/",)`) |
| `update` | `calver()` | 수동 수정일(`update_policy: "manual"` 설정 시에만 사용) |
| `extra` | Dictionary | 테마와 사용자 정의 확장에 전달할 임의의 사용자 정의 데이터 |

---

## 일반 페이지 만들기(About / FAQ 등)

블로그 글 목록이나 RSS에 포함되지 않는 고정 페이지(About 페이지나 개인정보 처리방침 등)를 만들 수 있습니다.

```sh
python3 command.py new page about --title "이 사이트에 대하여" --publish
```

`pages/about/index.typ`이 생성됩니다.

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "이 사이트에 대하여",
  description: "프로필과 사이트 소개",
  draft: false,
  index: true, // 검색 엔진과 사이트 내 검색의 인덱싱 여부
)

= About 페이지
```

---

## 운영 및 사양 상세

### 초안과 공개 동작

- `preview` 명령: 초안(`draft: true`)도 표시됩니다. “초안” 배지가 붙고 검색 인덱스에서는 제외됩니다.
- `build` 명령: 공개 빌드에서는 초안 글의 HTML을 생성하지 않으며 목록, RSS, Sitemap에서도 제외합니다.

### 수정일(`update`) 자동 반영

기본값(`update_policy: "git"`)에서는 글 디렉터리 안 파일의 최신 커밋 날짜를 수정일로 자동 사용합니다. 최초 커밋만 있다면 수정일을 표시하지 않습니다.

### 테마와 색상표 변경

`site.typ`에서 색상표를 변경할 수 있습니다.

```typst
theme: theme-config(color_scheme: "light") // "dark" 또는 "light"
```

사용자 정의 CSS를 추가하려면 `theme/static/color-schemes/my-theme.css`를 만들고 `color_scheme: "my-theme"`을 지정합니다.

---

## 디렉터리 구조

```text
.
├── site.typ                # 제목, URL, 작성자 등 사이트 전체 설정
├── posts/                  # posts_dir에 지정한 경우의 글 디렉터리
├── pages/                  # About 등의 일반 페이지
├── theme/                  # HTML 구조 및 디자인 테마
│   ├── pages/              # article, home, tag 등 각 페이지 렌더러
│   ├── components/         # head, header, widget 등 공통 부품
│   └── static/             # 테마용 CSS / JS
├── extensions/             # 사용자 정의 컴포넌트 및 확장 기능
├── static/                 # 이미지, favicon, CNAME 등의 정적 파일
├── command.py              # 글 작성 및 미리보기용 CLI 도구
├── blog.py                 # 빌드 처리 확장 스크립트
└── vendor/typst-blog-core/ # 【서브모듈】블로그 엔진 본체(직접 편집 권장하지 않음)
```

---

## 요구 사항

| 도구 | 요구 버전 | 비고 |
| --- | --- | --- |
| Git | - | 서브모듈 관리에 사용 |
| Typst | `0.15.0` 이상 | 최신 버전에 맞춰 수시로 업데이트 |
| Python | `3.10` 이상 | 빌드, RSS/Sitemap 생성, CLI 명령에 사용 |
| Node.js | `20` 이상 | 선택 사항(Pagefind 검색 인덱스 생성 시 사용) |

---

## 문제 해결

| 증상 | 원인과 해결 방법 |
| --- | --- |
| `typst-blog-core submodule is missing`이 표시됨 | `git submodule update --init --recursive`를 실행해 코어 엔진을 가져오세요. |
| 프로덕션 빌드 후 글이 표시되지 않음 | 글 메타데이터가 `draft: false`인지 확인하세요. |
| 공개 후 링크나 CSS가 깨짐 | `site.typ`의 `base_url` 설정이 올바른지 확인하세요(끝에 `/`를 붙이지 않음). |
| 사이트 내 검색(Pagefind)이 작동하지 않음 | Node.js와 `npx`를 사용할 수 있는지 확인한 뒤 `preview`를 다시 시작하거나 `build`를 다시 실행하세요. |

---

## 서드파티 라이선스 표시

- 이 템플릿의 코드는 MIT License로 제공됩니다.
- 포함된 Misskey 브랜드 아이콘은 CC BY-SA 4.0에 따라 사용됩니다. 상업적 이용을 포함해 필요한 저작자 표시는 빌드 시 `/third-party-licenses.txt`에 자동으로 출력됩니다. 자세한 내용은 `THIRD_PARTY_NOTICES.md`를 확인하세요.

---

문서 버전: 2026.09.13.1
