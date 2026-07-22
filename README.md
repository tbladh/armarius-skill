# Armarius

Armarius is a portable document-work starter kit for agents. It helps a harness quickly set up repo-local Python tooling, read document formats, and write basic outputs without relying on global packages.

The skill defaults all task-local tooling and artifacts to the current repository:

```text
.armarius/
|-- venv/
|-- outputs/
`-- scripts/
```

## Install

From a clone:

```bash
bash install.sh --codex --yes
```

PowerShell:

```powershell
.\install.ps1 -Codex -Yes
```

The default target is the Codex-compatible global skill path at `~/.agents/skills/armarius`. Explicit targets are available for Claude, Cursor, Kiro, Cline, GitHub Copilot, and Windsurf.

## Use

Ask your agent to use Armarius for document work, for example:

```text
Use $armarius to read this PDF and summarize the obligations by section.
Use $armarius to inspect this workbook and explain the calculated columns.
Use $armarius to convert this markdown summary into a DOCX.
```

The skill will create `.armarius/venv`, install practical document-reading packages, extract text and structured JSON, and proceed from those artifacts.
