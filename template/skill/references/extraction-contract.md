# Extraction Contract

Use the JSON extraction as the durable source of truth for document work.

## Output Files

Each `armarius-read` run writes:

- `extraction.json`: Structured content, metadata, warnings, dependencies, and output paths.
- `extracted.txt`: Plain text optimized for fast review and summarization.

## JSON Shape

```json
{
  "source_path": "/absolute/input/path",
  "kind": "pdf|docx|pptx|ppt|xlsx|xls|csv|tsv|html|text|image|unknown",
  "metadata": {},
  "content": [],
  "warnings": [],
  "missing_dependencies": [],
  "outputs": {
    "json": "/absolute/output/extraction.json",
    "text": "/absolute/output/extracted.txt"
  }
}
```

## Content Items

Prefer content items with clear locators:

- PDF: `{"type": "page", "locator": "page 1", "text": "..."}`
- PDF tables: `{"type": "table", "locator": "page 1 table 1", "rows": [...]}`
- DOCX paragraphs: `{"type": "paragraph", "locator": "paragraph 12", "text": "..."}`
- DOCX tables: `{"type": "table", "locator": "table 2", "rows": [...]}`
- PPTX slides: `{"type": "slide", "locator": "slide 3", "title": "...", "text": "..."}`
- PPTX tables: `{"type": "table", "locator": "slide 3 table 1", "rows": [...]}`
- XLSX sheets: `{"type": "sheet", "locator": "Sheet1", "rows": [...]}`
- Images: `{"type": "image_ocr", "locator": "screenshot.png", "text": "..."}`

## Quality Rules

- Preserve provenance before summarizing.
- Keep warnings visible when extraction is partial.
- Prefer values over formatting unless the user asks about layout.
- For spreadsheets, capture sheet names, dimensions, formulas, and visible values where available.
- For decks, preserve slide numbers, titles, body text, tables, and speaker notes where available.
- For images, capture dimensions and OCR text when Tesseract is available; otherwise return metadata, missing dependency details, and a clear warning.
- For PDFs, inspect page counts and extraction length. Low text per page may indicate scanned content.
