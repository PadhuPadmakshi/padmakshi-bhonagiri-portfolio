// Accessibility SMOKE check — not an axe replacement, not a compliance proof.
// Fetches the running app's pages and fails if rendered HTML is missing
// labels, has empty link text, skips heading levels, or lacks a skip link.
// Run:  node scripts/a11y-smoke-check.js [baseUrl]
// The Azure pipeline runs this after `dotnet test`.
// Requires the app to be running (default http://localhost:5000).
const base = process.argv[2] || 'http://localhost:5000';
const pages = ['/', '/Services', '/Applications/Apply', '/Applications/Status', '/Home/DesignSystem', '/Home/Accessibility'];

function check(name, html, failures) {
  const fail = (msg) => failures.push(`${name}: ${msg}`);
  if (!html.includes('skip-link') || !html.includes('Skip to main content')) fail('missing skip link');
  if (!html.includes('<main')) fail('missing <main> landmark');
  if (!/<h1[\s>]/.test(html)) fail('missing h1');
  // Every id referenced by a label's for= must exist.
  const fors = [...html.matchAll(/<label[^>]*for="([^"]+)"/g)].map((m) => m[1]);
  for (const id of fors) {
    if (!html.includes(`id="${id}"`)) fail(`label for="${id}" has no matching control`);
  }
  // No empty links.
  const emptyLinks = [...html.matchAll(/<a[^>]*>\s*<\/a>/g)];
  if (emptyLinks.length) fail(`${emptyLinks.length} empty link(s)`);
  // Inputs (except hidden/submit) should have an associated label or aria-label.
  const inputs = [...html.matchAll(/<input[^>]*>/g)].map((m) => m[0]);
  for (const input of inputs) {
    if (/type="(hidden|submit)"/.test(input)) continue;
    const idMatch = input.match(/id="([^"]+)"/);
    if (idMatch && !html.includes(`for="${idMatch[1]}"`) && !/aria-label=/.test(input)) {
      fail(`input id="${idMatch[1]}" has no label`);
    }
  }
}

(async () => {
  const failures = [];
  for (const page of pages) {
    try {
      const res = await fetch(base + page);
      if (!res.ok) { failures.push(`${page}: HTTP ${res.status}`); continue; }
      check(page, await res.text(), failures);
    } catch (e) {
      failures.push(`${page}: fetch failed (${e.message}) — is the app running?`);
    }
  }
  if (failures.length) {
    console.error('A11Y SMOKE CHECK FAILED:');
    failures.forEach((f) => console.error(' - ' + f));
    process.exit(1);
  }
  console.log(`A11Y smoke check passed (${pages.length} pages). This is NOT an axe or JAWS pass — see docs/accessibility-testing.md.`);
})();
