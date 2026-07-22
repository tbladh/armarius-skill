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
  "kind": "pdf|docx|xlsx|xls|csv|tsv|html|text|unknown",
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
- XLSX sheets: `{"type": "sheet", "locator": "Sheet1", "rows": [...]}`

## Quality Rules

- Preserve provenance before summarizing.
- Keep warnings visible when extraction is partial.
- Prefer values over formatting unless the user asks about layout.
- For spreadsheets, capture sheet names, dimensions, formulas, and visible values where available.
- For PDFs, inspect page counts and extraction length. Low text per page may indicate scanned content.
