# Armarius

Armarius is a portable document-work starter kit for agents. It helps a harness quickly set up repo-local Python tooling, read documents, decks, spreadsheets, and write basic outputs without relying on global packages.

The skill defaults all task-local tooling and artifacts to the current repository:

```text
.armarius/
|-- venv/
|-- outputs/
`-- scripts/
```

## Install

The installer supports global skill installs for Codex, Claude Code, Cursor, Kiro, Cline, GitHub Copilot, and Windsurf. Kiro support uses its documented global skill directory at `~/.kiro/skills/`. The default broad install supports GitHub Copilot and Windsurf through the shared `~/.agents/skills/` install that both can discover. Native paths, `~/.copilot/skills/` and `~/.codeium/windsurf/skills/`, are intentionally not part of `--all`; install them only when those harnesses are selected explicitly.

The quickstart installer is intentionally broad: it installs Armarius into the default global skill directories for Codex, Claude Code, Cursor, Kiro, and Cline, even if some harnesses are not installed. That creates `~/.agents/skills/armarius`, which is the default piggyback path for GitHub Copilot and Windsurf. When replacing an existing Armarius install, it overwrites the entire `armarius` skill directory for that harness. Any local changes inside those installed `armarius` skill directories will be lost.

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Yes
```

Both commands install globally for the default broad harness set and replace existing installed `armarius` skill folders by staging a fresh copy and swapping it into place, so removed files do not linger. Python 3 must be available on `PATH`.

From a clone, run `bash install.sh --codex`, `bash install.sh --cline`, or another explicit flag. Native Windows supports the matching PowerShell switches such as `.\install.ps1 -Codex` and `.\install.ps1 -Cline`. Legacy Codex installation is opt-in with `--legacy-codex` or `-LegacyCodex`.

### Explicit Harness Installs

Use these when you only want Armarius installed for one harness. Use `--copilot` or `--windsurf` only when you want the native harness path in addition to, or instead of, the default shared `.agents` path.

```bash
bash install.sh --codex --yes
bash install.sh --claude --yes
bash install.sh --cursor --yes
bash install.sh --kiro --yes
bash install.sh --cline --yes
bash install.sh --copilot --yes
bash install.sh --windsurf --yes
```

```powershell
.\install.ps1 -Codex -Yes
.\install.ps1 -Claude -Yes
.\install.ps1 -Cursor -Yes
.\install.ps1 -Kiro -Yes
.\install.ps1 -Cline -Yes
.\install.ps1 -Copilot -Yes
.\install.ps1 -Windsurf -Yes
```

## Use

Ask your agent to use Armarius for document work, for example:

```text
Use $armarius to read this PDF and summarize the obligations by section.
Use $armarius to inspect this workbook and explain the calculated columns.
Use $armarius to read this PowerPoint and summarize each slide.
Use $armarius to convert this markdown summary into a DOCX.
```

The skill will create `.armarius/venv`, install practical document-reading packages, extract text and structured JSON, and proceed from those artifacts.
