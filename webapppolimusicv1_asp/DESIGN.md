---
version: alpha
colors:
  midnight: "#07172d"
  surface: "#0c2344"
  cobalt: "#2563eb"
  cyan: "#4cc9f0"
  ink: "#e9f2ff"
  muted: "#96aeca"
  danger: "#f87171"
typography:
  display:
    fontFamily: "Bahnschrift, 'Arial Narrow', Arial, sans-serif"
    fontSize: "2.5rem"
    lineHeight: "1"
  body:
    fontFamily: "Inter, Aptos, Arial, sans-serif"
    fontSize: "1rem"
    lineHeight: "1.5"
rounded:
  control: "0.75rem"
  panel: "1.25rem"
spacing:
  unit: "0.5rem"
components:
  button:
    radius: "0.75rem"
  panel:
    radius: "1.25rem"
---

## Overview

PoliMusic is a Spanish-language listening desk for students and administrators. Its North Star is a midnight-blue studio console: quiet, technical and tactile rather than a generic streaming clone. The signature is the cyan equalizer/wave motif beside playback controls. Product routes prioritize legibility and compact task flow; the login page allows a little more atmosphere.

## Colors

`midnight` is the page field, `surface` groups content, and `cobalt` is the safe primary action. Cyan is reserved for playback, focus rings and the equalizer. Ink/muted create hierarchy without gray-on-black fatigue. Danger red is reserved for irreversible deletes. Runtime ownership is `assets/styles.css`; the CSS custom properties are the direct mapping from this document.

## Typography

Use the condensed display stack only for page titles, wordmarks and song identity. Use the body stack for tables, forms and explanatory copy. Uppercase micro-labels have expanded tracking; paragraphs remain sentence case.

## Layout

Desktop uses a 232px listening-library rail and a flexible document-scrolling content area. Mobile collapses the rail into an overlay. Tables retain horizontal scrolling on small widths; song discovery uses Bootstrap's responsive 1/2/3-column row utilities, with each card keeping its own play control.

## Elevation & Depth

Surfaces use a thin blue border and restrained shadow, never floating white cards. Gradient light is confined to the playback surface and login background.

## Shapes

Controls use the `control` radius. Panels use `panel`; never turn all elements into pills. Audio bars are square-ended to look like a console meter.

## Components

Buttons pair intent with emphasis: cobalt solid for safe commits, outline/ghost for secondary work, and red only inside an explicit permanent-delete confirmation. Bootstrap 5.3.8 is vendored locally for layout utilities; `assets/styles.css` owns the studio appearance. Global scrollbars use the CSS tokens. Toasts and dialogs are shared browser-side primitives in `assets/app.js`.

## Do's and Don'ts

Do use the real bundled MP3 and supplied imagery with stable dimensions. Do keep role-only administration server protected. Don't imitate Spotify’s green/black palette, hide scrollbars, or use browser alert/confirm dialogs.
