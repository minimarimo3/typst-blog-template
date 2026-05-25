#let _calver-year(year) = if year < 100 { 2000 + year } else { year }

#let calver(year, month, day, ..rest) = {
  let positional = rest.pos()
  let named = rest.named()
  assert(positional.len() <= 1, message: "CalVer accepts at most one patch number")
  assert(positional.len() == 0 or named.len() == 0, message: "CalVer patch must be passed either positionally or by name")
  assert(named.len() == 0 or named.keys() == ("patch",), message: "CalVer only accepts patch as a named argument")

  let patch = if positional.len() > 0 {
    positional.first()
  } else {
    named.at("patch", default: 0)
  }
  let full-year = _calver-year(year)
  assert(year >= 0, message: "CalVer year must be 0 or greater")
  assert(month >= 1 and month <= 12, message: "CalVer month must be between 1 and 12")
  assert(day >= 1 and day <= 31, message: "CalVer day must be between 1 and 31")
  assert(patch >= 0, message: "CalVer patch must be 0 or greater")
  let date-check = datetime(year: full-year, month: month, day: day)

  (year: full-year, month: month, day: day, patch: patch)
}

#let _parse-calver-string(value) = {
  let parts = value.split(".")
  assert(parts.len() == 3 or parts.len() == 4, message: "CalVer must be YYYY.MM.DD or YYYY.MM.DD.PATCH")

  calver(
    int(parts.at(0)),
    int(parts.at(1)),
    int(parts.at(2)),
    patch: if parts.len() == 4 { int(parts.at(3)) } else { 0 },
  )
}

#let normalize-calver(value) = {
  if type(value) == str {
    _parse-calver-string(value)
  } else if type(value) == dictionary {
    assert("year" in value and "month" in value and "day" in value, message: "CalVer must include year, month, and day")
    calver(value.year, value.month, value.day, patch: value.at("patch", default: 0))
  } else {
    panic("CalVer must be a calver(...) value or YYYY.MM.DD[.PATCH] string")
  }
}

#let _two-digits(value) = if value < 10 { "0" + str(value) } else { str(value) }

#let calver-display(value) = {
  let version = normalize-calver(value)
  let base = str(version.year) + "." + _two-digits(version.month) + "." + _two-digits(version.day)
  if version.patch == 0 { base } else { base + "." + str(version.patch) }
}

#let calver-key(value) = {
  let version = normalize-calver(value)
  (version.year, version.month, version.day, version.patch)
}

#import "/site.typ": site
#let main-font    = site.fonts.main.pdf
#let code-font    = site.fonts.code.pdf
#let heading-font = site.fonts.at("heading", default: site.fonts.main).at("pdf", default: site.fonts.main.pdf)
#let math-font    = if "math" in site.fonts { site.fonts.math.at("pdf", default: none) } else { none }
