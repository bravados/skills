---
name: chrome-browser-prefs
description: User preferences for Chrome DevTools MCP sessions. Use this skill when the user intends to record/film their screen showing ads (e.g. "quiero grabar los anuncios", "voy a hacer un video con los anuncios", "preparar grabación"). Especially when the URL is from Facebook/Meta Ad Library (facebook.com/ads/library). Do NOT apply for general browsing requests.
---

# Chrome Browser Preferences

## When to activate
Apply locale and blur **only** when the user's intent is to **record a video** of their screen showing ads. Signals:
- Mentions recording, filming, video, grabación, grabar, screencast, etc.
- URL is from Meta Ad Library (`facebook.com/ads/library`)
- Wants to show ads to an audience without exposing the advertiser's identity

For any other browsing request, skip locale and blur entirely.

## Mobile Layout (vertical recording)
For vertical/mobile-style recordings, the **only reliable approach** is Chrome DevTools device emulation. CSS/JS viewport hacks (`resizeTo`, patching `innerWidth`, meta viewport) do NOT reliably trigger Facebook's mobile layout because CSS media queries are evaluated against the real browser window size.

### Workflow
1. Open the page with `new_page`.
2. **Ask the user** to:
   - Open DevTools: `Cmd + Option + I`
   - Enable Device Toolbar: `Cmd + Shift + M`
   - Select device (e.g. iPhone 12 Pro) from the dropdown
   - Reload: `Cmd + R`
3. Wait for user confirmation that device emulation is active.
4. Proceed with locale cookie + reload + blur script (steps below).

Do NOT attempt automated viewport hacks before asking the user to do this step.

## Locale (es_ES)
The user is Spanish, in Spain, with a Spanish-speaking audience. Force Spanish locale so the UI matches their audience's language.

### How to apply
1. After opening the page, set the locale cookie:
   ```js
   document.cookie = 'locale=es_ES; domain=.' + location.hostname + '; path=/; max-age=31536000';
   ```
2. Reload the page.
3. Do this **before** any DOM modifications.

## Privacy Blur Workflow
Blur the minimum data needed to hide the advertiser's identity:

1. Take a snapshot to identify company name, logos, and profile images.
2. Extract the company/brand name from page context (headings, search inputs, image alts).
3. Inject a blur script targeting:
   - Images with alt matching the company name, "Page profile picture", or "Foto del perfil de la página"
   - Links, headings (h1-h4), and standalone spans/divs with exact company name text
   - Search inputs containing the company name
4. Install a `MutationObserver` on `document.body` (childList + subtree, debounce 300ms) to re-apply blur on DOM changes (modals, lazy-loaded content, pagination).
5. Take a screenshot to verify and show the user.
6. Inform the user of residual exposures (e.g. company name baked into ad creative images or mentioned in ad copy text).
