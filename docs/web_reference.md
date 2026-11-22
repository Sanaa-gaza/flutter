# Web Reference — extracted from the web app source

Source: https://github.com/Sanaa-gaza/Front-End (React + Vite)
Last synced with the web code: commit `8e97f69` (2026-11-19).
Purpose: the Flutter app must follow the same API, fields, rules and flows.
If anything here conflicts with the SRS or the backend dev, **ask before coding**.

---

## 1. User roles

| role (API)   | Arabic UI name | Has signup | Signup steps |
|--------------|----------------|-----------|--------------|
| `customer`   | زبون            | yes       | 1            |
| `craftsman`  | حرفي            | yes       | 2            |
| `institution`| مؤسسة           | yes       | 2            |
| `contractor` | مقاول           | yes       | 3            |
| `admin`      | مشرف            | no        | —            |

After login the app routes by `user.role` **returned by the server**,
not by which login screen the user used.

---

## 2. Backend

- Backend: Laravel
- Base URL (production, Railway): `https://back-end-production-9aa3.up.railway.app/api`
- Uploaded files are served from: `https://back-end-production-9aa3.up.railway.app/storage/<path>`
  (if a path already starts with `http`, use it as is)
- Timeout: 30s

### Headers on every request
```
Accept: application/json
Accept-Language: ar | en
Authorization: Bearer <token>   (when logged in)
```

### Response shape
```json
{ "success": true, "data": { ... }, "message": "..." }
```

### Error shape (Laravel)
```json
{ "message": "general message", "errors": { "email": ["first error", "..."] }, "data": { ... } }
```
- Show `errors[field][0]` under the matching form field.
  The value can also be a plain string instead of a list: handle both.
- Field errors whose key is not on the current screen: show them in the general alert.
- Show `message` as a general alert. No response at all = network error.
- `401` while logged in → clear the saved session and go to login.

---

## 3. Sprint 1 endpoints (live)

### Auth
| Method | Endpoint | Body |
|---|---|---|
| POST | `/auth/register/customer` | see 4.1 |
| POST | `/auth/register/craftsman` | see 4.2 |
| POST | `/auth/register/institution` | see 4.3 |
| POST | `/auth/register/contractor` | see 4.4 |
| POST | `/auth/verify-email` | `{ email, code, purpose }` purpose = `register` or `reset` |
| POST | `/auth/resend-code` | `{ email, purpose }` |
| POST | `/auth/login` | `{ email, password, remember }` |
| GET  | `/auth/me` | — |
| POST | `/auth/logout` | — |
| POST | `/auth/forgot-password` | `{ email }` |
| POST | `/auth/reset-password` | `{ reset_token, password, password_confirmation }` |

### Reference data
| Method | Endpoint | Returns (`data`) |
|---|---|---|
| GET | `/governorates` | `[{ id, name }]` |
| GET | `/governorates/{id}/areas` | `[{ id, name }]` |
| GET | `/services` | `[{ id, name }]` |

Cache these lists in memory; they rarely change.

### File upload
| Method | Endpoint | Body | Returns |
|---|---|---|---|
| POST | `/uploads` | multipart, field `file` (JPG/PNG/PDF, max 10MB) | `data.path` |

Upload files **first**, then send their paths inside the register body.

### Not confirmed yet (ask the backend dev before using)
`POST /auth/change-password`, `GET/PUT/DELETE /profile`

---

## 4. Register bodies

### 4.1 Customer (one screen)
```json
{
  "full_name": "", "email": "", "phone": "+970599123456",
  "password": "", "password_confirmation": "",
  "governorate_id": 1, "area_id": 3, "terms_accepted": true
}
```

### 4.2 Craftsman (step 1: personal info, step 2: craft + photos)
```json
{
  "full_name": "", "email": "", "phone": "",
  "password": "", "password_confirmation": "",
  "governorate_id": 1, "area_id": 3,
  "personal_photo_path": "<from /uploads>",
  "id_selfie_path": "<from /uploads>",
  "craft_id": 2,
  "bio": "", "terms_accepted": true
}
```
If the user picks "Other" craft: send `custom_craft_name` **instead of** `craft_id`.
The craft list comes from `GET /services`, plus an "Other" option added by the app.
`bio` is required, at least 10 characters.

### 4.3 Institution (step 1: info, step 2: license + description)
```json
{
  "institution_name": "", "commercial_registration_number": "",
  "email": "", "phone": "",
  "password": "", "password_confirmation": "",
  "governorate_id": 1, "area_id": 3,
  "activity_type": "",
  "license_file_path": "<from /uploads>",
  "description": "", "terms_accepted": true
}
```
`activity_type` is free text (the web uses a text input, not a list). `description` is required.

### 4.4 Contractor (step 1: info, step 2: work info, step 3: license)
```json
{
  "full_name": "", "national_id": "123456789",
  "email": "", "phone": "",
  "password": "", "password_confirmation": "",
  "governorate_id": 1, "area_id": 3,
  "workers_count": 5, "main_specialization": "",
  "description": "(optional)",
  "license_file_path": "<from /uploads>",
  "terms_accepted": true
}
```
`full_name` is the full four-part name in one field. `workers_count` is a typed number
(a whole number above zero), not a list. `description` is optional: omit it when empty.
There is no activity type field for the contractor.

### Multi-step rules
- Keep step data in memory (a provider), not on disk.
- **Never** store the password on disk between steps.
- If the user lands on step 2/3 without step 1 data, send them back to step 1.

---

## 5. Flows

### Register
Register → server sends a 6-digit code by email → **Verification screen**
→ `verify-email` with `purpose: "register"` → response has `token` + `user`
→ save session → go to the home of `user.role`.

### Login
`login` → success: response has `token` + `user` → save session → home of `user.role`.
If status **403** and `data.requires_verification == true`
→ go to the Verification screen with `purpose: "register"`.
"Remember me" ON → keep the token after closing the app; OFF → clear it on app close.

### Forgot password
Forgot password (email) → Verification screen with `purpose: "reset"`
→ response has `reset_token` (valid 10 minutes, NOT a login token)
→ Reset password screen → `reset-password` → back to login.

### Verification screen
- 6 digit boxes (OTP), masked email shown (e.g. `a•••@gmail.com`).
- Code timer: 3 minutes. Resend has a cooldown (longer lockout: 10 minutes).
- Wrong code: clear the boxes, focus the first one, show the server message.

---

## 6. Validation (same as web)

| Field | Rule | Error key |
|---|---|---|
| Email | required, `^[^\s@]+@[^\s@]+\.[^\s@]+$` | emailRequired / emailInvalid |
| Phone | remove spaces, must match `^(59\|56)\d{7}$` (9 digits) | phoneRequired / phoneInvalid |
| Country code | default `+970`, sent as `+970599123456` | — |
| Password | 8+ chars, a letter, an uppercase, a number, a special char `!@#$%^&*(),.?":{}\|<>_-` | passwordRequired / passwordWeak |
| Confirm password | must match | confirmPasswordRequired / passwordMismatch |
| National ID (contractor) | required, `^\d{9}$` | idNumberRequired / idNumberInvalid |
| Workers count (contractor) | required, `^[1-9]\d*$` | teamSizeRequired / teamSizeInvalid |
| Craftsman bio | required, at least 10 characters after trim | bioRequired / bioMinLength |
| Institution description | required | bioRequired |
| Contractor description | optional | — |
| Craft (craftsman) | required; if "Other", the custom name is required | craftRequired / craftOtherRequired |
| Personal photo, ID selfie (craftsman) | required | avatarRequired / idPhotoRequired |
| Governorate, area | required | cityRequired / areaRequired |
| Other text fields | required, checked after trim | nameRequired, regNumberRequired, activityTypeRequired, quadNameRequired, mainSpecialtyRequired, fieldRequired |
| Terms | must be checked | termsRequired |
| Files | JPG/PNG/PDF, max 10MB | — |

Show a live checklist of password requirements while typing.
Arabic and English error texts live in the web file `src/i18n/locales/<lang>/signupCommon.json`;
reuse the same wording.

---

## 7. Look & feel

- Font: **Cairo**
- Primary: `#4B9AD2` · Primary light: `#8EC0E4` · Primary surface: `#EAF3FB`
- Dark navy: `#22455E` · Text dark: `#141415` / `#414141` · Text secondary: `#575757` / `#89949D`
- Error: `#D64545` · Success: `#2EAF4E`
- Arabic first (RTL), English supported.
- Web Arabic texts live in `src/i18n/locales/ar/*.json` — reuse the same wording in Flutter ARB files.

---

## 8. Web screens (for later sprints)
Public: Home, About, Contact, Craftsmen list, Craftsman profile, Role selection.
Dashboards: customer, craftsman (home, search, requests, current jobs),
institution (home, tenders, tender details, offers, projects, providers, messages, settings),
contractor, admin.
Sprint 2 endpoints already used by the web: `/craftsmen`, `/craftsmen/featured`,
`/service-requests` (+ accept / reject / complete / review), `/contact`.

---

## 9. Sprint 1 open questions answered by the web code (2026-11-19)
- Contractor activity type: the web has no such field and the API does not accept one. Do not build it.
- Institution activity type and contractor workers count: the web uses text/number inputs,
  not lists. The app design shows dropdowns; until the backend provides option lists, follow the web.
- "Remember me": the web has it on login. The app design does not show it (still an open question).
