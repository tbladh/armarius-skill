# Writing Contract

Writing support is intentionally basic and output-oriented.

## Supported Defaults

- Text or markdown-like text to DOCX.
- Text or markdown-like text to PPTX.
- Text to simple PDF.
- JSON rows or extraction-like content to XLSX.

## Fidelity Boundary

Do not promise full preservation of arbitrary source formatting unless you have inspected and tested the specific document path.

For complex editing:

1. Extract the source document first.
2. Identify the smallest required change.
3. Prefer a repo-local helper under `.armarius/scripts`.
4. Validate the written artifact by reading it back with `armarius-read` when possible.

## Output Location

Write generated files under `.armarius/outputs` unless the user requested a specific path.
