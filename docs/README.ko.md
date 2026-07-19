# Typst Blog Template

문서 버전: 2026.07.19.5

언어: [日本語](../README.md) | [English](README.en.md) | 한국어 | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

Typst 로 글을 쓰고 정적 블로그로 공개하기 위한 템플릿입니다.
글을 작성하고 빌드하면 블로그 홈, 글 페이지, 태그 페이지, RSS, sitemap, 검색 인덱스를 함께 생성할 수 있습니다.

이 README 는 이 템플릿을 자신의 블로그로 사용하려는 사람을 위한 설명입니다.
내부 구현이 궁금하다면 `vendor/typst-blog-core` 쪽 README 를 읽어 주세요.

이 README 를 업데이트할 때는 `docs/` 아래의 각 언어 파일도 업데이트하고 문서 버전을 맞춰 주세요.

## 할 수 있는 일

- Typst 문법으로 블로그 글을 쓸 수 있습니다.
- 글마다 제목, 작성일, 수정일, 설명, 태그, 초안 상태를 설정할 수 있습니다.
- 홈 페이지, 글 페이지, 태그별 페이지, 태그 목록 페이지를 생성합니다.
- RSS 와 sitemap 을 생성합니다.
- Pagefind 를 사용한 사이트 내 검색을 추가할 수 있습니다.
- GitHub Pages 에 바로 공개할 수 있습니다.
- 색상 테마, favicon, 이미지, CSS, 커스텀 도메인용 `CNAME` 을 추가할 수 있습니다.
- 블로그 엔진 부분만 나중에 업데이트할 수 있습니다.

## 필요한 것

- Git
- Typst 0.15.0 이상
- Python 3.10 이상
- Node.js 20 이상

Node.js 는 검색 인덱스를 만드는 `pagefind` 실행에 사용됩니다.
로컬에서 검색 기능을 쓰지 않더라도 기본 GitHub Pages workflow 는 Node.js 를 사용합니다.

## 처음 만지는 파일

평소 자주 수정하는 파일은 다음과 같습니다.

- `site.typ`: 블로그 이름, 설명, 공개 URL, 작성자 정보, 테마 등 사이트 설정
- `example-post/index.typ`: 글 작성 예시
- `글 디렉터리/index.typ`: 직접 작성하는 글
- `static/`: 이미지, favicon, 추가 CSS, 커스텀 테마, `CNAME` 등

대부분 직접 수정하지 않아도 되는 파일도 있습니다.

- `vendor/typst-blog-core`: 블로그를 생성하는 본체입니다. 보통 직접 수정하지 않고 업데이트 절차로 버전을 올립니다.
- `typst/generated/posts.typ`: 빌드할 때 생성되는 글 목록 데이터입니다. 손으로 수정하지 않습니다.
- `public/`: 빌드 결과입니다. 손으로 수정하지 않습니다.

## 시작하기

GitHub 의 템플릿 기능으로 이 저장소에서 자신의 저장소를 만듭니다.
그 다음 로컬에 clone 합니다.

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

이미 clone 했고 `vendor/typst-blog-core` 가 비어 있다면 다음을 실행하세요.

```sh
git submodule update --init --recursive
```

다음으로 `site.typ` 을 열어 자신의 블로그에 맞게 수정합니다.
먼저 이 항목들을 바꾸면 됩니다.

- `title`: 블로그 이름
- `description`: 블로그 설명
- `base_url`: 공개 후 URL
- `github_repo`: 이 블로그의 GitHub 저장소 URL
- `language`: 주로 사용할 언어
- `theme`: `dark` 또는 `light`
- `posts_dir`: 글을 둘 디렉터리. 루트는 `"."`, `posts/`에 모으려면 `"posts"`
- `update_policy`: 수정일을 정하는 방식입니다. 기본값 `"git"`은 각 글 디렉터리의 Git 기록에서 자동 계산하고, `"manual"`은 글의 `update` 값을 사용합니다.
- `author.name`: 작성자 이름
- `author.bio`: 프로필 문장
- `author.socials`: X, Misskey, GitHub 등의 링크

GitHub Pages 에 공개한다면 `base_url` 은 보통 다음과 같은 형태입니다.

```typst
base_url: "https://USER.github.io/REPO"
```

커스텀 도메인을 사용한다면 그 도메인의 URL 을 지정하세요.

## 글 작성

글마다 디렉터리를 만들고 그 안에 `index.typ` 을 둡니다.
다음 명령으로 디렉터리와 메타 정보가 포함된 `index.typ` 을 한 번에 만들 수 있습니다.

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "짧은 설명입니다." \
  --tag Typst
```

작성일은 실행일로 설정되고 안전을 위해 기본 상태는 초안입니다. 태그를 여러 개 추가하려면 `--tag` 를 반복하고, 바로 공개할 때만 `--publish` 를 추가합니다. 다른 작성일은 `--date 2026-07-19` 형식으로 지정할 수 있습니다. 같은 이름의 디렉터리, 중복 slug, 예약된 URL이 있으면 파일을 덮어쓰지 않고 오류가 발생합니다.

글을 `posts/` 아래에 모으려면 `site.typ`에서 `posts_dir: "posts"`를 지정하세요. `new`의 생성 위치와 빌드 시 글 탐색 범위가 모두 `posts/`로 설정됩니다. 생략하거나 `"."`로 설정하면 기존처럼 블로그 루트를 사용합니다.

생성되는 글 파일은 다음 형식의 메타 정보로 시작합니다.

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "짧은 설명입니다.",
  tags: ("Typst",),
  draft: true,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Hello

본문을 씁니다.
```

자주 쓰는 항목은 다음과 같습니다.

- `slug`: 글 URL 이 됩니다. 소문자 ASCII 영숫자를 하나의 하이픈으로 구분한 형식을 사용합니다. 위 예시는 `/my-first-post/` 로 공개됩니다.
- `title`: 글 제목입니다.
- `create`: 작성일입니다.
- `update`: `update_policy: "manual"`일 때 사용하는 수정일입니다.
- `description`: 글 목록과 검색 결과 등에 쓰이는 짧은 설명입니다.
- `tags`: 태그입니다. 표시 이름에 일본어, 공백, 기호를 사용해도 안전하고 충돌하지 않는 태그 페이지 URL이 자동으로 생성됩니다.
- `draft`: `true` 는 초안, `false` 는 공개 대상입니다.

`draft` 를 생략하면 초안으로 취급됩니다.
공개할 글에는 `draft: false` 를 넣어 주세요.

수정일은 기본적으로 자동 관리됩니다. 글의 `index.typ`이나 같은 글 디렉터리의 이미지, 참고 문헌 등을 커밋하면 최신 커밋 날짜가 수정일이 됩니다. 글을 처음 추가한 커밋만 있으면 수정일을 표시하지 않습니다. Git 기록을 가져올 수 없는 환경에서는 경고를 표시하고, 글에 작성된 `update` 값이 있으면 그 값을 사용합니다.

## 로컬에서 확인

다음 명령을 실행합니다.

```sh
python3 command.py preview
```

`preview`에서는 `draft: true`인 초안도 표시하며 목록과 글 페이지에 "초안" 배지를 붙입니다. 초안에는 `noindex`가 설정되고 Pagefind 검색에서도 제외됩니다. 일반 `build`와 GitHub Pages 배포에서는 초안 글 페이지, 목록, 태그 페이지, RSS 및 sitemap 항목을 생성하지 않습니다.

첫 빌드가 끝나면 `http://localhost:8000`에서 미리보기 서버가 시작됩니다. Typst 파일, CSS, JavaScript, 이미지 등의 사이트 소스를 저장하면 자동으로 다시 빌드되고 열려 있는 브라우저 페이지도 새로고침됩니다. 8000번 포트가 사용 중이면 다른 빈 포트가 선택되므로 터미널에 표시된 URL을 열어 주세요. 종료하려면 `Ctrl+C`를 누릅니다.

`site.typ`의 `base_url`은 공개 URL로 유지해도 됩니다. `preview`는 CSS, 글 링크 등 사이트 리소스의 기준 경로만 로컬 서버용 `/`로 바꿉니다. canonical URL, RSS, sitemap에는 계속 `base_url`이 사용됩니다.

검색 기능도 확인하려면 다른 터미널에서 검색 인덱스를 만듭니다. 글 변경으로 자동 재빌드된 뒤에는 다시 실행해 주세요.

```sh
npx -y pagefind --site public
```

배포용 결과를 생성하거나 공개 경로를 확인할 때는 `python3 command.py build`를 실행합니다.

## GitHub Pages 에 공개

이 템플릿에는 GitHub Pages 용 workflow 가 포함되어 있습니다.

1. `site.typ` 의 `base_url` 과 블로그 정보를 자신에게 맞게 수정합니다.
2. GitHub 에서 `Settings` -> `Pages` 를 엽니다.
3. `Build and deployment` 의 `Source` 를 `GitHub Actions` 로 설정합니다.
4. 변경사항을 `main` 브랜치에 push 합니다.

push 하면 GitHub Actions 가 자동으로 빌드하고 `public/` 내용을 GitHub Pages 에 배포합니다.

커스텀 도메인을 사용한다면 `static/CNAME` 또는 저장소 루트의 `CNAME` 에 도메인명을 적습니다.
그 경우 `site.typ` 의 `base_url` 도 커스텀 도메인에 맞춰 주세요.

## 외형 바꾸기

테마는 `site.typ` 의 `theme` 으로 전환합니다.

```typst
theme: "light"
```

처음부터 사용할 수 있는 테마는 `dark` 와 `light` 입니다.

이미지, favicon, 추가 CSS, 커스텀 테마 등은 `static/` 에 둡니다.
빌드할 때 `static/` 의 내용이 `public/` 으로 복사됩니다.

커스텀 테마를 만들려면 예를 들어 `static/themes/my-theme.css` 를 추가하고 `site.typ` 에서 지정합니다.

```typst
theme: "my-theme"
```

## 블로그 엔진 업데이트

이 템플릿은 블로그를 생성하는 본체를 `vendor/typst-blog-core` 로 포함합니다.
글과 `site.typ` 은 자신의 저장소에 남아 있으므로 생성 부분만 나중에 업데이트할 수 있습니다.

업데이트할 때는 release tag 로 전환하는 방식을 권장합니다.

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname
git checkout vYYYY.MM.DD
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`vYYYY.MM.DD` 는 실제로 사용할 release tag 로 바꾸세요.

`git add vendor/typst-blog-core` 는 core 전체를 부모 저장소에 복사하는 작업이 아닙니다.
이 블로그가 어떤 core 버전을 사용할지 기록하는 작업입니다.

업데이트 후에는 push 하기 전에 로컬에서 표시를 확인하세요.

## 자주 하는 작업

새 글 추가:

```sh
python3 command.py new new-post \
  --title "New Post" \
  --description "짧은 설명입니다."
```

글을 다시 초안으로 돌리기:

```typst
draft: true
```

글 공개하기:

```typst
draft: false
```

검색 인덱스 다시 만들기:

```sh
npx -y pagefind --site public
```

submodule 다시 가져오기:

```sh
git submodule update --init --recursive
```

## 문제 해결

- `typst-blog-core submodule is missing`: `git submodule update --init --recursive` 를 실행하세요.
- `vendor/typst-blog-core` 가 비어 있음: submodule 이 아직 받아지지 않은 상태입니다. `git submodule update --init --recursive` 를 실행하세요.
- `site.theme '...' does not exist`: `site.typ` 의 `theme` 과 `static/themes/` 의 파일 이름을 확인하세요.
- 공개 빌드에 글이 보이지 않음: 글의 `draft` 가 `false` 인지 확인하세요. `preview`에서는 초안도 확인할 수 있습니다.
- 공개 URL 이 이상함: `site.typ` 의 `base_url` 을 확인하세요. 끝의 `/` 는 필요 없습니다.
- GitHub Pages 에서 core 를 찾지 못함: `.github/workflows/deploy.yml` 의 checkout 설정에 `submodules: recursive` 가 있는지 확인하세요.
- 검색이 동작하지 않음: `npx -y pagefind --site public` 를 실행한 뒤 다시 확인하세요.

## Misskey 아이콘

Misskey 공유 버튼과 사이드바 아이콘은 기본적으로 활성화되어 있습니다.
core 에 포함된 Misskey 아이콘은 Simple Icons 기반이며 Misskey project 가 CC-BY-NC-SA-4.0 으로 제공합니다.
이 라이선스가 사용 목적에 맞지 않으면 `site.typ` 에서 `share.misskey` 를 `false` 로 설정하세요.

## 라이선스

MIT License.
