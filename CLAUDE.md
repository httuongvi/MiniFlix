# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`MiniFlix` is a **learning project**, not a production app. It follows a structured 15-day
iOS curriculum in [`docs/iOS_developement_starter.md`](docs/iOS_developement_starter.md) that
incrementally builds a TMDB-backed movie browser (list, search, detail, favorites). **Read the
roadmap doc before adding features** — each day has defined goals, and the roadmap is the source
of truth for what to build and which APIs to use.

The project language is **Vietnamese**: UI strings, code comments, and commit messages are all in
Vietnamese. Keep new user-facing text and comments in Vietnamese unless asked otherwise (bilingual
VI/EN localization is a Day 9 task).

**Current progress: through Day 4** (Swift basics, SwiftUI state, debug & performance). Networking,
MVVM, persistence, localization, push, and tests are all still ahead.

## Build & run

There is no test target yet (tests arrive at Day 12), and no lint tooling is configured.

```sh
# Build for simulator
xcodebuild -project MiniFlix.xcodeproj -scheme MiniFlix \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

# Once a test target exists (Day 12+): run all tests
xcodebuild -project MiniFlix.xcodeproj -scheme MiniFlix \
  -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test (Day 12+), Swift Testing or XCTest:
#   ...test -only-testing:MiniFlixTests/<Suite>/<testName>
```

Day-to-day, the intended workflow is Xcode: **⌘R** to run, **⌘U** to test, `#Preview` for UI
iteration without launching the simulator. Project settings: iOS deployment target 26.5,
Swift version 5.0, bundle id `com.tuongvi.MiniFlix`.

## Hard conventions (from the roadmap)

These are explicit rules from `docs/iOS_developement_starter.md` — follow them even where existing
project settings differ:

- **Never hand-edit `MiniFlix.xcodeproj/project.pbxproj`.** Add files through Xcode so the project
  file stays consistent. (This constrains how new source files can be introduced.)
- **Modern SwiftUI only:** use `@Observable` macro (not `ObservableObject`/`@Published`),
  `NavigationStack` (not `NavigationView`), and `async/await` + `@MainActor` for concurrency.
- Target **iOS 17+** semantics and Swift Concurrency, even though the project's build settings
  currently read Swift 5.0 / iOS 26.5.

## Code layout & architecture

All source lives in `MiniFlix/`. Two categories of code coexist:

1. **The actual app** — the SwiftUI app being built toward the roadmap:
   - `MiniFlixApp.swift` — `@main` entry, `WindowGroup { ContentView() }`.
   - `ContentView.swift` — root view; also currently defines `MovieCardView`.
   - `Movie.swift` — the core model, `struct Movie: Identifiable, Codable`. This is the shared
     domain type the whole app is built around.

2. **Daily drill exercises** — throwaway practice code, *not* wired into the app's view tree:
   - `DrillDay1.playground/`, `DrillDay2.playground/` — Swift-language playgrounds (FizzBuzz,
     collections, optionals, enums, closures). Playgrounds are standalone and are **not compiled
     into the app target**; `DrillDay2.playground` even redefines its own `Movie` struct.
   - `DrillDay3.swift`, `DrillDay4.swift` — SwiftUI/debug drills compiled *into* the app target
     but not reachable from `ContentView`. Note `DrillDay4.swift` declares a file-scope global
     `var movies: [Movie]` used by its sample views — be aware of this when adding top-level names.

The intended target architecture (from Day 7 onward) is **MVVM**: `View → ViewModel (@Observable)
→ Service/Model`, with a `TMDBService` (async/throws) fetching from the TMDB API, and a
`LoadState` enum (`idle / loading / loaded / empty / error`) driving view rendering. None of this
exists yet — it's the direction to build in.

## External dependencies

The app will call the **TMDB API** starting Day 6 (`/movie/popular`, `/search/movie`). A TMDB API
key is required for any networking work and is not committed to the repo.

## Git workflow

Development proceeds one branch per curriculum day (`day-01`, `day-02`, …), each merged to `main`
via a pull request (see git history). Match this pattern: branch per day/feature, PR into `main`.
Commit messages so far are in Vietnamese/English per-day summaries (e.g. "Complete day 04 exercises").
