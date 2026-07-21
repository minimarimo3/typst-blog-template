# Typst Blog Template

Typst 로 글을 쓰고 정적 블로그로 공개하기 위한 템플릿입니다.
글을 쓰고 빌드하기만 하면 홈, 글 페이지, 태그 페이지, RSS, sitemap, 사이트 내 검색 인덱스가 한꺼번에 생성됩니다.

다양한 문법이 담긴 샘플 페이지: <https://minimarimo3.github.io/typst-blog-template/example-post/>
이 템플릿을 사용한 저장소 작성자의 블로그: <https://www.minimarimo3.jp>

언어: [日本語](README.ja.md) | [English](../README.md) | 한국어 | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

## 특징

- 글도 사이트 설정도 모두 Typst 로 작성할 수 있습니다
- 글마다 제목·작성일·수정일·설명·태그·초안 상태를 설정할 수 있습니다
- 홈, 글 페이지, 태그별 페이지, 태그 목록 페이지를 자동 생성합니다
- RSS 와 sitemap 도 자동 생성합니다
- [Pagefind](https://pagefind.app/) 기반 사이트 내 검색을 지원합니다
- GitHub Pages 에 그대로 공개할 수 있습니다 (워크플로 포함)
- 색상 테마 전환, favicon·이미지·추가 CSS·커스텀 도메인 설정이 가능합니다
- 블로그 엔진 부분(`vendor/typst-blog-core`)만 나중에 업데이트할 수 있습니다

## 요구 사항

| 도구 | 버전 |
| --- | --- |
| Git | - |
| Typst | 0.15.0 이상 |
| Python | 3.10 이상 |
| Node.js | 20 이상 |

Node.js 는 검색 인덱스를 만드는 Pagefind 실행에 사용합니다. 검색 기능을 사용하지 않더라도 GitHub Pages 기본 워크플로에서는 Node.js 를 사용합니다.

## 빠른 시작

### 1. 저장소를 만들고 clone 하기

GitHub 의 "Use this template" 버튼으로 자신의 저장소를 만들고 로컬에 clone 합니다.

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

> [!NOTE]
> 이미 clone 했는데 `vendor/typst-blog-core` 가 비어 있다면 `git submodule update --init --recursive` 를 실행하세요.

### 2. 사이트 설정 수정하기

`site.typ` 를 열어 자신의 블로그에 맞게 수정합니다. 먼저 살펴볼 항목은 다음과 같습니다.

| 항목 | 내용 |
| --- | --- |
| `title` | 블로그 이름 |
| `description` | 블로그 설명 |
| `base_url` | 공개 후 URL (끝에 `/` 를 붙이지 않음) |
| `github_repo` | 이 블로그의 GitHub 저장소 URL |
| `language` | 주로 사용하는 언어 |
| `theme` | `"dark"` 또는 `"light"` |
| `posts_dir` | 글을 두는 위치. 루트 바로 아래면 `"."`, `posts/` 에 모으려면 `"posts"` |
| `update_policy` | 수정일 결정 방식. `"git"`(기본값, Git 이력에서 자동 산출) 또는 `"manual"`(글의 `update` 사용) |
| `author.name` | 작성자 이름 |
| `author.bio` | 프로필 문구 |
| `author.socials` | X, Misskey, GitHub 등의 링크 |

GitHub Pages 로 공개하는 경우 `base_url` 은 다음 형태가 됩니다.

```typst
base_url: "https://USER.github.io/REPO"
```

커스텀 도메인을 사용하는 경우 해당 도메인의 URL 을 지정하세요.

### 3. 글 만들기

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "글의 짧은 설명입니다." \
  --tag Typst
```

글 디렉터리와 메타 정보가 채워진 `index.typ` 가 한 번에 생성됩니다.

### 4. 로컬에서 확인하기

```sh
python3 command.py preview
```

첫 빌드 후 `http://localhost:8000` 에서 미리보기 서버가 시작됩니다. 파일을 저장하면 자동으로 다시 빌드되고 브라우저도 새로고침됩니다.

### 5. 공개하기

`main` 브랜치에 push 하면 GitHub Actions 가 자동으로 빌드해 GitHub Pages 에 공개합니다. 자세한 내용은 [GitHub Pages로 공개하기](#github-pages로-공개하기)를 참고하세요.

## 글 작성하기

글은 "1 글 = 1 디렉터리" 구조이며, 각 디렉터리의 `index.typ` 가 본문입니다. 이미지나 참고 문헌도 같은 디렉터리에 둡니다.

### 새 글 만들기

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "글의 짧은 설명입니다." \
  --tag Typst
```

- 작성일은 실행한 날이 되고, 안전을 위해 초안 상태로 생성됩니다
- 태그를 여러 개 붙이려면 `--tag` 를 반복합니다
- 처음부터 공개 상태로 만들려면 `--publish` 를 붙입니다
- 작성일을 지정하려면 `--date 2026-07-19` 형식으로 지정합니다
- 같은 이름의 디렉터리, 기존 글과 같은 slug, 예약된 URL 이 있으면 에러가 발생합니다

### 글 파일 형식

생성되는 `index.typ` 의 첫 부분은 다음과 같습니다.

```typst
#import "/template.typ": post, calver

#show: post.with(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "글의 짧은 설명입니다.",
  tags: ("Typst",),
  draft: true,
)

= 시작하며

본문을 작성합니다.
```

`post` show 규칙은 이 값들을 빌드용 메타데이터로 등록하고 이후의 본문을 글 레이아웃으로 렌더링합니다.

| 항목 | 내용 |
| --- | --- |
| `slug` | 글의 URL. 공백, 대문자, 문장 부호와 기호가 포함된 자연스러운 Unicode 텍스트를 사용할 수 있으며 생성 URL에서는 퍼센트 인코딩됨. 경로 구분자, 제어 문자와 이식성이 없는 파일 이름은 거부됨. 위 예시는 `/my-first-post/` 로 공개됨 |
| `title` | 글 제목 |
| `create` | 작성일 |
| `update` | 수정일. `update_policy: "manual"` 일 때만 사용됨 |
| `description` | 글 목록이나 검색 결과에 사용되는 짧은 설명 |
| `tags` | 태그. 표시 이름에 한국어·공백·기호를 사용해도 안전하고 중복되지 않는 URL 의 태그 페이지가 자동 생성됨 |
| `draft` | `true` 면 초안, `false` 면 공개 대상. 생략하면 초안으로 처리됨 |

### 초안과 공개

`draft` 값으로 전환합니다. 공개하려는 글에는 `draft: false` 를 적어 주세요.

- **`preview` 에서는**: 초안도 표시되며, 목록과 글 페이지에 "초안" 배지가 붙습니다. 초안에는 `noindex` 가 설정되고 검색 대상에서도 제외됩니다.
- **`build`(공개 빌드)에서는**: 초안의 글 페이지는 생성되지 않으며, 목록·태그 페이지·RSS·sitemap 에도 포함되지 않습니다.

### 수정일이 정해지는 방식

수정일은 기본값(`update_policy: "git"`)으로 자동 관리됩니다.

- 글의 `index.typ` 나 같은 글 디렉터리 안의 이미지·참고 문헌 등을 커밋하면, 그 최신 커밋 날짜가 수정일이 됩니다
- 글을 처음 추가한 커밋밖에 없는 경우 수정일은 표시되지 않습니다
- Git 이력을 가져올 수 없는 환경에서는 경고를 표시하고, 글에 `update` 가 적혀 있으면 그 값을 사용합니다

수동으로 관리하려면 `site.typ` 에서 `update_policy: "manual"` 을 지정하고 글의 `update` 에 날짜를 적습니다.

### 글을 posts/ 에 모으기

글 디렉터리를 루트 바로 아래가 아니라 `posts/` 아래에 모으고 싶다면 `site.typ` 에서 `posts_dir: "posts"` 를 지정합니다. `new` 명령의 생성 위치와 빌드 시 글 탐색 범위가 모두 `posts/` 가 됩니다.

## 로컬에서 확인하기

```sh
python3 command.py preview
```

- 첫 빌드 후 `http://localhost:8000` 에서 미리보기 서버가 시작됩니다
- Typst 파일·CSS·JavaScript·이미지 등을 저장하면 자동으로 다시 빌드되고 브라우저도 새로고침됩니다
- 8000 번 포트가 사용 중이면 다른 빈 포트가 선택되므로, 터미널에 표시된 URL 을 여세요
- 종료하려면 `Ctrl+C` 를 누릅니다

`site.typ` 의 `base_url` 은 공개 URL 그대로 두어도 됩니다. `preview` 는 CSS 나 글 링크 등의 기준 경로만 로컬 서버용 `/` 로 전환하며, canonical URL·RSS·sitemap 에는 계속 `base_url` 이 사용됩니다.

검색 기능도 확인하려면 다른 터미널에서 검색 인덱스를 만듭니다.

```sh
npx -y pagefind --site public
```

글을 수정해 자동으로 다시 빌드된 후에는 이 명령을 다시 실행하세요.

공개용 생성 결과를 그대로 확인하고 싶다면 `python3 command.py build` 를 실행합니다.

## GitHub Pages로 공개하기

이 템플릿에는 GitHub Pages 용 워크플로가 들어 있습니다. 설정은 처음 한 번뿐입니다.

1. `site.typ` 의 `base_url` 과 블로그 정보를 자신에 맞게 변경한다
2. GitHub 의 `Settings` → `Pages` 를 연다
3. `Build and deployment` 의 `Source` 를 `GitHub Actions` 로 설정한다
4. 변경 사항을 `main` 브랜치에 push 한다

이후에는 push 할 때마다 GitHub Actions 가 자동으로 빌드해 `public/` 의 내용을 GitHub Pages 에 배포합니다.

### 커스텀 도메인 사용하기

1. `static/CNAME`(또는 저장소 루트의 `CNAME`)에 도메인 이름을 적는다
2. `site.typ` 의 `base_url` 도 커스텀 도메인에 맞춘다

## 모양 바꾸기

### 테마 전환하기

`site.typ` 의 `theme` 로 전환합니다. 처음부터 사용할 수 있는 것은 `dark` 와 `light` 입니다.

```typst
theme: "light"
```

### 나만의 테마 만들기

`static/themes/` 에 CSS 를 추가하고, 파일 이름(확장자 제외)을 `theme` 에 지정합니다.

```typst
// static/themes/my-theme.css 를 만든 경우
theme: "my-theme"
```

### 이미지·favicon·추가 CSS

`static/` 에 둔 파일은 빌드 시 그대로 `public/` 으로 복사됩니다.

## 파일 구성

자주 수정하는 파일:

| 경로 | 내용 |
| --- | --- |
| `site.typ` | 블로그 이름, 공개 URL, 작성자 정보, 테마 등 사이트 설정 |
| `글 디렉터리/index.typ` | 자신의 글 |
| `example-post/index.typ` | 글 작성 방법 샘플 |
| `static/` | 이미지, favicon, 추가 CSS, 커스텀 테마, `CNAME` 등 |

기본적으로 건드리지 않는 파일:

| 경로 | 내용 |
| --- | --- |
| `vendor/typst-blog-core` | 블로그를 생성하는 본체. 직접 수정하지 않고 [업데이트 절차](#블로그-엔진-업데이트하기)로 버전을 올림 |
| `typst/generated/posts.typ` | 빌드 시 자동 갱신되는 글 목록 데이터 |
| `public/` | 빌드 결과. 공개용으로 생성됨 |

## 블로그 엔진 업데이트하기

블로그를 생성하는 본체는 `vendor/typst-blog-core` submodule 로 포함되어 있습니다. 글과 `site.typ` 는 자신의 저장소에 남겨 둔 채, 생성 부분만 나중에 업데이트할 수 있습니다.

업데이트는 release tag 로 전환하는 방식을 추천합니다.

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname   # 사용 가능한 버전 목록 확인
git checkout vYYYY.MM.DD          # 사용할 버전으로 전환
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`git add vendor/typst-blog-core` 는 core 의 내용을 복사하는 작업이 아니라, "이 블로그에서 사용할 core 버전"을 기록하는 작업입니다.

업데이트 후에는 로컬에서 표시를 확인한 뒤 push 하세요.

## 문제가 생겼을 때

| 증상 | 대처 |
| --- | --- |
| `typst-blog-core submodule is missing` 이 표시됨 / `vendor/typst-blog-core` 가 비어 있음 | `git submodule update --init --recursive` 를 실행 |
| `site.theme '...' does not exist` 가 표시됨 | `site.typ` 의 `theme` 와 `static/themes/` 의 파일 이름이 일치하는지 확인 |
| 공개 빌드에 글이 나오지 않음 | 글의 `draft` 가 `false` 인지 확인 (`preview` 에서는 초안도 표시됨) |
| 공개 URL 이 이상함 | `site.typ` 의 `base_url` 을 확인. 끝의 `/` 는 불필요 |
| GitHub Pages 에서 core 를 찾지 못함 | `.github/workflows/deploy.yml` 의 checkout 설정에 `submodules: recursive` 가 있는지 확인 |
| 검색이 동작하지 않음 | `npx -y pagefind --site public` 을 실행한 뒤 확인 |

## Misskey 아이콘에 대해

Misskey 공유 버튼과 사이드바의 Misskey 아이콘은 기본으로 활성화되어 있습니다. core 에 포함된 Misskey 아이콘은 Simple Icons 에서 유래했으며, Misskey project 가 CC-BY-NC-SA-4.0 으로 제공합니다. 상업적 이용 등 이 조건이 맞지 않는 경우 `site.typ` 의 `share.misskey` 를 `false` 로 설정하세요.

## 라이선스

이 템플릿의 코드는 MIT License 로 제공합니다.

---

문서 버전: 2026.07.19.7
(이 README 를 업데이트할 때는 루트의 README.md 와 `docs/` 아래 다른 언어 파일도 함께 업데이트하고, 문서 버전을 맞춰 주세요)
