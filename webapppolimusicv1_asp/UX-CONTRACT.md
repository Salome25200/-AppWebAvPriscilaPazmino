# UX Contract — PoliMusic

## Product context

- Audience: authenticated music-library users and the administrator seeded by `BDD_PoliMusic.sql`.
- Primary jobs: browse and play songs; for an admin, maintain songs, artists and albums.
- Active locale: Spanish (`es-EC` content convention); WCAG 2.2 AA baseline.
- Permission and data lifecycle evidence: `BDD_PoliMusic.sql`, reviewed 2026-10-23. `USER_TYPE = 1` is admin; CRUD is explicitly requested. Deletion is hard delete because the supplied schema has no archive state.

## Visual contract

- `DESIGN.md` is the visual authority; `assets/styles.css` is its direct runtime token mapping.
- One dark theme, studio-console register, CSS custom properties used by all pages.

## Canonical UI Map

| Capability | Canonical owner | Source of truth | Allowed variants | Verification |
|---|---|---|---|---|
| Select/Listbox | Native select | Admin form | platform popup accepted | keyboard native behavior |
| Form | Classic ASP form + `assets/app.js` | this contract | create/edit | inline required errors |
| Scrollbar | `assets/styles.css` | DESIGN.md | table overflow geometry | CSS inspection |
| Toast | `assets/app.js` | this contract | success/error/info | aria-live region |
| CRUD | `admin.asp` | SQL schema + this contract | entity tabs | server-side role check |

## Flow ledger

| Operation | Success | Failure recovery |
|---|---|---|
| Create/update | return to the active entity list; show a success banner | preserve data and show form error |
| Delete | explicit app dialog, then return to entity list | dialog remains available; show error banner |
| Play | start audio and update listening counter best-effort | show unobtrusive playback error |
| Login | store ID, username, photo and role in session; go to Song List | generic inline message; preserve username |
| Logout | abandon session and return to login | n/a |

## Navigation and resilience

- A normal user sees Song List only; direct `admin.asp` access reaches `forbidden.asp`.
- CRUD mutations are server-confirmed and forms disable duplicate submissions with the browser enhancement.
- Browser `beforeunload` is not used because entity forms are short. Server errors keep fields visible for correction.
- Every route writes a scoped document title; list rows reserve image dimensions and the audio dock preserves its height.

## Verification

- Static source checks plus Classic ASP syntax/manual-IIS verification are required because the project has no local test runner.
- Browser matrix: login error/success, admin/normal role boundary, playback, CRUD valid/invalid/delete confirmation, narrow layout and keyboard focus.
