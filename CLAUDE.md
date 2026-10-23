# Sanaa (صنعة) — Flutter App

## About the project
Sanaa is a platform that connects craftsmen (حرفي), contractors (مقاول),
institutions (مؤسسة) and customers/visitors (زبون/زائر).
API roles: `customer`, `craftsman`, `institution`, `contractor`, `admin`.
The product has a web app (React, built by our frontend dev) and this mobile app (Flutter).
Both apps use the SAME backend, the SAME API and the SAME business logic.

What comes from where:
- **UI (screens, layout, components, flow between screens)** → the mobile app design
  images in each sprint folder. The app design is NOT a copy of the web; follow the app design.
- **Logic, data, API, field names, validation rules** → same as the web (`docs/web_reference.md`).
- The app can have **app-only** screens and features that the web does not have
  (e.g. onboarding with motion animations). Build them when the sprint includes them.
  Same goal and same data as the web, a different mobile experience.

Team: 1 backend, 1 web frontend, 3 UX/UI, 1 systems analyst (SRS), 1 Flutter dev (me).

## Who you are working with
- I am a beginner in Flutter. I am building this app and learning at the same time.
- Talk to me in **Arabic** (simple, clear). Keep code, file names, identifiers,
  commits and technical terms in **English**.
- Teach while you build: explain the "why", not only the "what".

## Stay on track (most important rule)
- Follow the current sprint file **exactly**. Do not decide things on your own.
- Do not add features, screens, packages or "improvements" that are not in the sprint.
  If you think something is missing or could be better, **suggest it and ask me first**.
- Before executing **anything** (creating a file, running a command, adding a package),
  ask me and explain why. No silent actions.

## How we work (mandatory)
1. Work **one sprint at a time**, and inside a sprint **one task at a time**.
2. Before each step, tell me in Arabic:
   - what you are about to do,
   - which file(s) you will create or change and where they live,
   - why we need it.
   Then **wait for my approval** before writing code.
3. Work **file by file**. Never create or change many files in one go
   without telling me first.
4. After writing a file, explain the important parts briefly in Arabic,
   then ask me if I understood or have questions before moving on.
5. After each step:
   - run `flutter analyze` and fix every issue,
   - tell me how to test it on my phone,
   - when it works, suggest a git commit with a clear message.
6. Never modify or delete working code without asking me first.
7. If something in the docs is unclear or missing, **ask me**.
   Never invent API endpoints, fields or business rules.
8. At the end of each task, give me a short Arabic summary:
   what we built + the Flutter concepts I learned.

## Source of truth
Read these before working on a sprint:
- `docs/web_reference.md` — roles, API, request bodies, flows, validation, colors (from the web code)
- `docs/sprints/sprint_XX/` — the sprint text, screenshots and notes
- `docs/srs/` — SRS document (business rules)
- `docs/api/` — API documentation (when available)
- `docs/designs/` — Flutter UI/UX designs

If the app design needs data or an action the API does not have, or shows a field
the API does not accept, stop and ask me. Never invent backend behavior to fit a design.

## Environment
- Flutter + VS Code, testing on a **real Android phone** over USB (no emulator).
- The phone cannot reach `localhost`. When we connect a local backend,
  use the computer's LAN IP or the deployed server URL.

## Tech decisions
- State management: **Riverpod** (`flutter_riverpod`)
- Networking: **Dio**
- Routing: **go_router**
- Secure token storage: `flutter_secure_storage`
- Localization: Arabic first (RTL), English ready via `flutter_localizations` + ARB files
- Only add well-maintained packages from pub.dev. Tell me before adding any package and why.

## Architecture
Feature-first, simple Clean Architecture:

```
lib/
├── main.dart
├── app/                 # App widget, router, theme
├── core/                # constants, network (dio client), errors, utils, shared widgets
└── features/
    └── <feature>/
        ├── data/        # models (fromJson/toJson), data sources, repository impl
        ├── domain/      # entities, repository contracts
        └── presentation/# screens, widgets, providers
```

### API strategy
- The backend is **live** (Laravel on Railway). Base URL, endpoints, request bodies,
  response and error shapes are in `docs/web_reference.md`. Use them exactly.
- Every feature talks to a **repository interface**, so the data source can change
  without touching the UI.
- For endpoints marked "not confirmed" or not built yet, use a **mock data source**
  with the same JSON shape, and remind me to confirm with the backend dev.
- Keep the Base URL in one config place, never inside features.

## Images (two different kinds, never mix them)
1. **App images** (logo, background pattern, onboarding animations, empty-state art):
   - Live in `assets/` and ship inside the app. I provide these files.
   - Prefer SVG for logo/icons, Lottie JSON for animations.
2. **Content images** (craftsman photos, work portfolio, ID photos, licenses,
   anything added by users or the admin):
   - NEVER in `assets/`. They live on the backend server.
   - Upload: pick (camera/gallery) → compress/resize on the phone → `POST /uploads`
     → get `path` → send the path with the related request.
     Show upload progress and errors. Limits: JPG/PNG/PDF, max 10MB.
   - Display: build the full URL from the path (see `web_reference.md`), load with
     caching, show a placeholder while loading and a fallback on error.
   - People photos in the design screenshots are **sample content**, not assets.
     Use them only to understand the layout.
- Ask me before adding image packages (picker, compression, caching) and explain each one.
- For any feature that adds, changes or deletes images (e.g. admin dashboard),
  confirm the endpoints with me first. Do not guess them.

## Security (mandatory in every task)
Treat security as part of "done", not an extra. When a task touches any item below,
tell me in Arabic what you did to keep it safe.

Secrets & storage
- Token and user session only in `flutter_secure_storage` (Keystore on Android).
  Never in SharedPreferences, plain files, logs or global variables that outlive the session.
- Never store passwords anywhere on the device, not even between signup steps
  (keep them in memory only, clear them after the request).
- No API keys, secrets or passwords hardcoded in the code. The app is public:
  anything inside the APK can be extracted.
- On logout or 401: delete the token and all cached user data.

Network
- HTTPS only. Never allow cleartext HTTP in release (`usesCleartextTraffic=false`).
  If a local HTTP backend is needed for testing, allow it in debug only.
- Never disable certificate checks (no `badCertificateCallback => true`).
- Send the token only to our backend base URL, never to other hosts
  (e.g. image URLs from other domains get no Authorization header).
- Never log tokens, passwords, OTP codes, full request bodies or responses with
  personal data. Use a logger that is disabled in release builds.

Input & data
- Validate every input on the client (format, length), but remember the backend is the
  real protection. Never rely on the app to enforce rules or permissions.
- Never trust data from the API blindly: parse safely, handle missing fields, no crashes.
- Role-based screens: hide what the user cannot do, but always let the backend decide.
  Never build a feature where the app sends a role or permission the user picks.
- Files: check type and size before upload (JPG/PNG/PDF, max 10MB).
  Remove image metadata (EXIF/GPS) when compressing.
- Never put user input into URLs or paths without encoding.
- Use the system WebView only if really needed, with JavaScript off unless required.

App & build
- Release builds: enable code shrinking + obfuscation
  (`flutter build apk --obfuscate --split-debug-info=...`). Explain it to me when we reach release.
- Hide sensitive screens from the recent-apps preview only if I ask (discuss first).
- `debugPrint`/`print` with sensitive data is forbidden. Remove debug code before commit.
- Keep packages updated; only well-known packages from pub.dev.
- Never commit secrets, keystores (`*.jks`, `key.properties`) or `.env` files. Check `.gitignore`.

Report, don't hide
- If you notice a security weakness in the backend or API behavior
  (e.g. it accepts something it should not), stop and tell me so I can report it
  to the backend dev. Do not try to work around it in the app.

## Code style
Write code like an experienced Flutter developer on a real team:
- Clear, specific names. Small widgets and small files.
- Comments only where the reason is not obvious. No comments that repeat the code.
- No emojis, no placeholder or TODO-filled code, no dead code.
- Use `const` constructors wherever possible.
- Colors, text styles and spacing come from the theme / constants, never hardcoded in screens.
- All user-facing strings go through localization, never hardcoded.
- Handle loading, empty and error states on every screen that loads data.
- Keep it fast: avoid unnecessary rebuilds, use `ListView.builder` for lists,
  cache network images.

## Git
- Small commits after each working step.
- Message format: `feat(auth): add login screen UI`, `fix(...)`, `refactor(...)`.

## Sprint 0 — Project setup (before Sprint 1)
Build the project foundation step by step, asking before each step:
1. Check the Flutter project exists and runs on my phone (`flutter devices`, `flutter run`).
2. Create the folder structure from the Architecture section (empty folders get a `.gitkeep`).
3. Add the base packages (tell me each one and why).
4. `core/`: app constants, theme (colors, text styles, spacing), Dio client skeleton,
   error/failure classes.
5. `app/`: app widget with RTL + Arabic localization, and go_router with a placeholder home.
6. Initialize git and make the first commit.
Explain every folder's purpose to me in Arabic as we create it.

## Current status
- Web: Sprint 1 (login + register) is done and connected to the API.
- Flutter: Sprint 0 (project setup) is done. Sprint 1 Task 1 (assets & theme) is done.
  Next: Sprint 1 Task 2 (shared widgets).
- Not pushed to GitHub yet: waiting for a private `Mobile-App` repo in the team org.
