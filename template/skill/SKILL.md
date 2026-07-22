---
name: __PRODUCT_NAME__
description: Goal-oriented document reading and writing starter kit for PDF, Word, PowerPoint, Excel, CSV/TSV, text, HTML, and converted document work. Use when an agent needs to inspect, extract, summarize, compare, transform, convert, or create documents, decks, or spreadsheets; when practical Python document dependencies should be installed automatically; or when repo-local document tooling should be scaffolded under `.armarius`.
---

# __PRODUCT_TITLE__

## Non-Negotiable Outcome

When Armarius is active for document work, make measurable progress before replying:

- Set up the repo-local `.armarius/venv` when needed.
- Extract the document into text and structured JSON before reasoning from it.
- Save task artifacts under `.armarius/outputs`.
- Create custom repo-local helper scripts under `.armarius/scripts` when the task needs repeatable local logic.
- Use any native document, spreadsheet, browser, or file tooling exposed by the current harness when it helps accomplish the user's goal.

Do not ask whether to install normal Python document-reading packages. Install them into `.armarius/venv`, not globally.

## Quick Start

1. Resolve the absolute directory containing this `SKILL.md` as `<skill-dir>`. This is the installed skill directory, not the current workspace. In Claude Code, `${CLAUDE_SKILL_DIR}` is available. In Kiro global installs, use `~/.kiro/skills/__PRODUCT_NAME__` if no skill path is exposed. In Cline global installs, use `~/.cline/skills/__PRODUCT_NAME__` if no skill path is exposed. In GitHub Copilot native installs, use `~/.copilot/skills/__PRODUCT_NAME__` if no skill path is exposed. In Windsurf global installs, use `~/.codeium/windsurf/skills/__PRODUCT_NAME__` if no skill path is exposed. In other harnesses, use this skill's listed file path.
2. Treat the current repository or working directory as the task root.
3. Bootstrap document-reading tooling:

```bash
<skill-dir>/scripts/armarius-bootstrap --profile read --json
```

4. Extract the document:

```bash
<skill-dir>/scripts/armarius-read path/to/document --json
```

5. Read `.armarius/outputs/<document-stem>/extraction.json` and `.armarius/outputs/<document-stem>/extracted.txt`, then answer the user's actual question from those artifacts.

The read command auto-bootstraps by default. Run bootstrap explicitly first when you want clearer setup diagnostics.

## Workflow

### Establish Tooling

- Use `.armarius/venv` for Python dependencies.
- Use `.armarius/outputs` for extraction results, conversions, and generated artifacts.
- Use `.armarius/scripts` for task-specific helper scripts that belong to the current repo.
- Use native harness tooling when it is available and fits the task.
- If native tooling will not work, is too narrow, or needs custom glue, repurpose the approach into repo-local scripts under `.armarius/scripts` and run them from `.armarius/venv`.
- If a useful local helper becomes generally reusable, tell the user it is a candidate to feed back into the Armarius skill repo.

### Read Documents

- Use `scripts/armarius-read` before writing custom extraction code.
- Prefer the JSON result for provenance and the text result for fast inspection.
- If extraction quality is weak, rerun with an additional profile or create a custom helper under `.armarius/scripts`.
- For scanned PDFs, read `references/dependency-profiles.md` before attempting OCR.
- For nuanced extraction choices, read `references/extraction-contract.md`.

### Write Documents

Writing is secondary but supported. Use:

```bash
<skill-dir>/scripts/armarius-bootstrap --profile write --json
<skill-dir>/scripts/armarius-write --help
```

Use writing helpers for basic DOCX, PPTX, XLSX, and PDF creation. For complex preservation of existing formatting, inspect the source format directly and make a targeted local helper.

Read `references/writing-contract.md` before promising formatting fidelity.

## Dependency Policy

- Install reasonable Python dependencies automatically into `.armarius/venv`.
- Do not install system tools automatically. If LibreOffice, Pandoc, or Tesseract is needed and missing, report the exact tool and continue with available Python-only extraction when possible.
- Keep dependency additions task-local unless the user is working on the Armarius skill repo itself.

## Self-Healing

- If an extensionless launcher does not execute on POSIX, run it with `sh`.
- In PowerShell, use `.ps1` launchers.
- In `cmd.exe`, use `.cmd` launchers.
- If Python is missing entirely, explain that Python 3 is required and stop only after reporting the exact blocker.
- If extraction returns little or no text, inspect warnings in `extraction.json`, then try layout/OCR/conversion paths as appropriate.

## References

- Read `references/dependency-profiles.md` when choosing dependency profiles or diagnosing missing packages/system tools.
- Read `references/extraction-contract.md` when extracting tables, layout, page provenance, workbook formulas, or mixed document content.
- Read `references/writing-contract.md` when creating or modifying DOCX, XLSX, PDF, or conversion outputs.
