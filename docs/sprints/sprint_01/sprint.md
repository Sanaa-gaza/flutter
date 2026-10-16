# Sprint 1 — Onboarding & Authentication

Goal: a new user sees the splash and onboarding, chooses to register, log in or
continue as a guest, creates an account of any role, verifies the email with a code,
logs in, resets a forgotten password, and lands on the home screen of their role.
Everything is connected to the **live API** in `docs/web_reference.md`.

## Before you start
1. Read `CLAUDE.md` and `docs/web_reference.md`.
2. The images in `screenshots/` are the **mobile app design from Figma** and the
   **UI source of truth**. Each Figma frame has a label (e.g. "5 logint", "مقاول 11").
   Give me a table in Arabic: image → screen, and wait for my confirmation.
3. Read the "Open questions" section at the end. Do not build anything that depends
   on an open question until I give you the answer.

## Screens (from the app design)

| Figma frame | Screen | Notes |
|---|---|---|
| 1 Splash Screen-1 | Splash | Logo centered, light patterned background |
| 2, 3, 4 SCREAN | Onboarding (3 pages) | Image area, page dots, title, text. "تخطي" (skip) on each page. Page 1: Next. Page 2: Back + Next. Page 3: "ابدأ معنا". Shown only on first launch |
| 5 choos acount | Welcome / auth choice | Logo, text, "إنشاء حساب", "تسجيل الدخول", link "الدخول الآن والتسجيل لاحقاً" (guest) |
| شاشة الهدف | Goal selection (**updated design**, replaces the old 4-card screen) | Title "أنشئ حسابك". 2 cards: "بدي أطلب خدمة" (request a service) and "بدي أقدم خدمة" (provide a service). Guest link at the bottom |
| نوع طالب الخدمة - عميل مؤسسة | Account type: service requesters | 2 cards: عميل (`customer`), مؤسسة (`institution`). Guest link |
| نوع طالب الخدمة - حرفي مقاول | Account type: service providers | 2 cards: حرفي (`craftsman`), مقاول (`contractor`). Guest link |
| 5 logint | Login | Email, password, "نسيت كلمة المرور؟", submit, social buttons, terms text |
| 8 claint | Customer signup (1 step) | Name, email, phone, password + confirm, governorate, area, terms |
| 6, 7 harife | Craftsman signup (2 steps) | Step 1: personal info. Step 2: personal photo, craft, bio, ID selfie upload, terms |
| مؤسسة 9, 10 | Institution signup (2 steps) | Step 1: name, phone, email, password + confirm, governorate, area, activity type. Step 2: commercial registration number, license upload, bio, terms |
| مقاول 11, 12, 13 | Contractor signup (3 steps) | Step 1: full name (4 parts), email, ID number, phone, password + confirm, governorate, area, activity type. Step 2: workers count, main specialization, bio. Step 3: license upload, terms |
| 17 forget p | Forgot password | Email → send code |
| 18 forget | Verification code (OTP) | 6 boxes, confirm, resend. **Reuse the same screen after signup** (purpose `register`) |
| 19 change | Reset password | New password + confirm → save |

> **Design update:** image `02_welcome_role_craftsman_step1.png` still shows the OLD
> 4-card "5 creat acount" screen. Ignore it. Use `07_goal_and_account_type_UPDATED.png`.

Shared UI seen in the design:
- Top bar: back arrow + centered title.
- Step indicator for multi-step signups (done = check mark, current = filled number).
- Fields with an icon and a light blue border, labels above fields.
- Password and confirm side by side, with a hint text under them.
- Governorate and area side by side.
- Dashed upload box (icon + "file up to 10MB").
- Primary button with blue gradient, secondary outlined button.
- Light background with faint craft-tool pattern.

## Data rules
Field names, request bodies and validation come from `web_reference.md`, not from the
design. The design only decides layout and which step a field appears in.
Example: in the design, the institution "commercial registration number" is in step 2;
it is still sent as `commercial_registration_number` in the same final register request.

## Tasks (in this order, one at a time)

### Task 1 — Assets & theme check
Add the logo (SVG) and the background pattern to `assets/`. Confirm theme colors,
gradient and Cairo font match the design. Ask me for any asset file you need.

### Task 2 — Shared widgets
`core/widgets/`: top bar with back arrow, text field with icon, password field,
phone field, dropdown field, multiline bio field, upload box, step indicator,
primary gradient button (with loading), outlined button, terms checkbox,
OTP input, error alert.
Done when: a temporary demo screen shows all widgets on my phone (remove it after).

### Task 3 — Validators
`core/utils/validators.dart`, exact rules from `web_reference.md` section 6, with unit tests.

### Task 4 — Network + session
Dio client, error parsing, 401 handling, secure session storage
(see `web_reference.md` section 2).

### Task 5 — Splash + onboarding + welcome
Splash → (first launch) onboarding → welcome screen.
Onboarding is **app-only** (not in the web). The empty area at the top of each page
holds a **Lottie animation** (I will give you the files):
- `assets/animations/onboarding_1.json` → page 1 "أهلاً بك في صنعة" (house + crafts)
- `assets/animations/onboarding_2.json` → page 2 "ثقة بلا سؤال" (review card + stars)
- `assets/animations/onboarding_3.json` → page 3 "ابدأ رحلتك الآن" (chat + booking confirmed)
Each is 3 seconds, 360x360, transparent background, brand colors.
Play once when the page becomes visible (`repeat: false`), replay when the user
swipes back to that page. Build the area as one reusable widget.
Ask me before adding the `lottie` package.
Remember that onboarding was seen (ask me before adding a package for this).
Splash checks the saved session: valid → role home, otherwise → welcome.

### Task 6 — Reference data
Governorates, areas by governorate, services. Cached in memory.
Done when: governorate and area dropdowns load real data.

### Task 7 — Login
`/auth/login` → save session → route by `user.role`.
403 + `requires_verification` → OTP screen (purpose `register`).
Field errors under fields, general errors in the alert.

### Task 8 — Goal + account type selection (updated design)
Flow: Welcome → "إنشاء حساب" → **Goal screen**
- "بدي أطلب خدمة" → account type screen with عميل / مؤسسة
- "بدي أقدم خدمة" → account type screen with حرفي / مقاول
Each account type card opens its signup flow (customer / institution / craftsman / contractor).
Build ONE reusable account-type screen that receives its two options,
not two copies of the same screen. Each card: icon, title, description (same card widget as the goal screen).
The goal is UI only: it is **not sent to the API**. The API only needs the role.
Back arrow returns to the previous screen. Guest link works on all three screens.

### Task 9 — Customer signup → OTP
Body from `web_reference.md` 4.1 → OTP screen.

### Task 10 — OTP screen
6 boxes, auto-move, paste support, 3-minute timer, resend cooldown.
`register` → save session → role home. `reset` → keep `reset_token` in memory → reset screen.

### Task 11 — Forgot + reset password
17 → 18 (purpose `reset`) → 19 → login.

### Task 12 — Craftsman signup (2 steps)
Step data in a provider (memory only, never save the password to disk).
Upload photos first via `/uploads`, then register (`web_reference.md` 4.2).

### Task 13 — Institution signup (2 steps)
`web_reference.md` 4.3.

### Task 14 — Contractor signup (3 steps)
`web_reference.md` 4.4.

### Task 15 — Role homes + guest + logout
Simple placeholder home per role (role name + logout via `/auth/logout`).
Guest home placeholder (no API calls that need a token).

## Definition of done
- Every screen matches the app design and works RTL in Arabic.
- All flows tested on my real phone with the live API.
- Loading, error and network-error states on every form.
- `flutter analyze` clean, tests pass, one commit per task.
- Short Arabic summary of what I learned.

## Open questions (wait for answers before building these parts)
1. **Social login (Facebook / Google / Apple)** on the login screen: the API has no
   social login endpoint. Hide the buttons for now, or show them disabled?
2. **Login button text** says "ارسال الكود" (send code). It is probably a design
   mistake and should be "تسجيل الدخول". Confirm.
3. **Remember me**: the web has it, the app design does not. Default for the app:
   always keep the user logged in until logout?
4. **"عنوان السكن" (address) field** with placeholder "الشارع، المنطقة": the API needs
   `area_id` (a choice from a list), not free text. Build it as an area dropdown?
5. **Contractor "طبيعة النشاط" (activity type)** in step 1: the contractor register API
   has no such field. Remove it, or ask the backend dev to add it?
6. **Guest mode** ("الدخول الآن والتسجيل لاحقاً"): in this sprint, just open a guest
   placeholder home?
7. **Activity type** for institution and **workers count** for contractor are dropdowns
   in the design. What are the options, and does the API have a list for them?
