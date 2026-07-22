# Dependency Profiles

Armarius installs Python packages into the current repository under `.armarius/venv`.

## Profiles

- `read`: Default profile for document inspection. Installs PDF, DOCX, PPTX/PPSX/POTX, XLSX, XLS, CSV-adjacent, HTML, and table helpers.
- `write`: Basic document creation for DOCX, PPTX, XLSX, and PDF.
- `ocr`: Python OCR bindings. Requires the separate system `tesseract` executable.
- `all`: Installs every bundled profile.

## Default Behavior

Use `read` for any extraction, summary, comparison, or document QA task.
Use `write` only when creating or exporting documents.
Use `ocr` only when a PDF appears scanned or text extraction is insufficient.

## System Tools

Do not install system tools automatically. Detect and report them:

- LibreOffice or `soffice`: Convert `.doc`, `.xls`, and office files that Python libraries cannot read directly.
- Pandoc: Convert between markdown, DOCX, HTML, and PDF-adjacent formats when available.
- Tesseract: OCR scanned pages when paired with `pytesseract`.

Continue with available Python-only extraction whenever possible.

## Repo-Local Customization

When a task needs custom parsing, create helper scripts under `.armarius/scripts`.
If the helper is broadly useful across repositories, mention that it can be promoted into `template/skill/scripts` in the Armarius skill repo.

Native harness tooling is allowed. If a native document/spreadsheet/PDF tool solves the task, use it. If it does not fit the file, dependency state, output contract, or custom workflow, use its useful parts as a model and implement the repo-local version under `.armarius/scripts`.
