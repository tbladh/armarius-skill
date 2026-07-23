# Dependency Profiles

Armarius installs Python packages into the current repository under `.armarius/venv` only when the current task needs them.

## Profiles

- `core`: No dependencies. Use for plain text, markdown, JSON, XML, CSV, and TSV.
- `pdf`: PDF text and table extraction with `pypdf` and `pdfplumber`.
- `word`: DOCX extraction with `python-docx`.
- `deck`: PPTX/PPSX/POTX extraction with `python-pptx`.
- `sheet`: XLSX/XLSM/XLS extraction with `openpyxl` and `xlrd`.
- `html`: HTML extraction with `beautifulsoup4` and `lxml`.
- `image-ocr`: Standalone image OCR for PNG, JPEG, TIFF, BMP, GIF, and WebP. Requires the separate system `tesseract` executable for actual OCR.
- `read`: Broad document prewarm profile. Use only when the user wants common read dependencies installed up front.
- `write-docx`, `write-deck`, `write-sheet`, `write-pdf`: Targeted writing profiles.
- `write`: Broad write prewarm profile. Use only when the user wants all common write dependencies installed up front.
- `ocr`: Alias for `image-ocr`.
- `all`: Installs every bundled profile.

## Default Behavior

Use `armarius-read` with its default `--profile auto` for extraction, summary, comparison, or document QA tasks. It sniffs the source extension and installs the smallest profile required. Plain text and CSV-style files should not create `.armarius/venv`.

Use targeted writing profiles through `armarius-write`; the command selects `write-docx`, `write-deck`, `write-sheet`, or `write-pdf` automatically. Use broad `read`, `write`, or `all` only for deliberate prewarming.

Use `image-ocr` for standalone image OCR. For scanned PDFs, first try `pdf`; then use `image-ocr` only after rendering pages to images with a native harness tool, a system tool, or a repo-local helper.

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
