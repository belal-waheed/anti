---
name: edge-browser-automation
description: Workflows and CLI patterns for headless Microsoft Edge browser automation, UI layout verification, DOM scraping, visual regression screenshots, and Playwright/Puppeteer configurations using the pre-installed Windows Edge engine. Use when testing web pages, taking screenshots, or debugging frontend rendering.
---

# Microsoft Edge Browser Automation & Visual Debugging Guide

## When to use this skill
Trigger whenever capturing rendered screenshots of frontend projects (React, Next.js, HTML), scraping dynamic SPAs, debugging visual layouts, or configuring browser automation in tests.

---

## 1. Global CLI Utility (`edge-browser.mjs`)

You can run the global Edge utility from any working directory across any project:

### A. Capture Viewport Screenshot
```bash
node C:/Users/bel/.gemini/config/scripts/edge-browser.mjs screenshot https://example.com ./screenshot.png 1280 800
```

### B. Render & Inspect Complete Dynamic DOM
```bash
node C:/Users/bel/.gemini/config/scripts/edge-browser.mjs dump http://localhost:3000
```

### C. Verify Page Status & Title
```bash
node C:/Users/bel/.gemini/config/scripts/edge-browser.mjs check http://localhost:3000
```

### D. Export Page to PDF
```bash
node C:/Users/bel/.gemini/config/scripts/edge-browser.mjs pdf https://example.com ./report.pdf
```

---

## 2. Programmatic Integration in Test Suites

### Playwright (Zero Chromium Download)
```ts
import { chromium, test, expect } from '@playwright/test';

test('homepage renders correctly', async () => {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true
  });
  const page = await browser.newPage();
  await page.goto('http://localhost:3000');
  await expect(page).toHaveTitle(/My App/);
  await browser.close();
});
```

### Puppeteer-Core (Direct Edge Binary)
```ts
import puppeteer from 'puppeteer-core';

const browser = await puppeteer.launch({
  executablePath: 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
  headless: 'new'
});
const page = await browser.newPage();
await page.goto('http://localhost:3000');
await page.screenshot({ path: 'preview.png' });
await browser.close();
```

---

## 3. Advantages of Using Edge on Windows
* **Zero Binary Downloads**: Reuses pre-installed Edge at `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`.
* **No Cache Locking**: Eliminates Windows `EPERM` file locks during npm/npx execution.
* **Full DevTools Protocol**: Complete support for CDP, screenshots, headless rendering, and DOM dumping.
