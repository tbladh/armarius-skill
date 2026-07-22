# Armarius

Armarius is a portable document-work starter kit for agents. It helps a harness quickly set up repo-local Python tooling, read documents, decks, spreadsheets, and write basic outputs without relying on global packages.

The skill defaults all task-local tooling and artifacts to the current repository:

```text
.armarius/
|-- venv/
|-- outputs/
`-- scripts/
```

## Supported Harnesses

The installer supports global skill installs for Codex, Claude Code, Cursor, Kiro, Cline, GitHub Copilot, and Windsurf. Kiro support uses its documented global skill directory at `~/.kiro/skills/`.

The default broad install supports GitHub Copilot and Windsurf through the shared `~/.agents/skills/` install that both can discover. Native paths, `~/.copilot/skills/` and `~/.codeium/windsurf/skills/`, are intentionally not part of `--all`; install them only when those harnesses are selected explicitly.

## Install

> [!WARNING]
> The quickstart installer is intentionally broad: it installs Armarius into the default global skill directories for Codex, Claude Code, Cursor, Kiro, and Cline, even if some harnesses are not installed. That creates `~/.agents/skills/armarius`, which is the default piggyback path for GitHub Copilot and Windsurf. When replacing an existing Armarius install, it overwrites the entire `armarius` skill directory for that harness. Any local changes inside those installed `armarius` skill directories will be lost.

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Yes
```

Both commands install globally for the default broad harness set and replace existing installed `armarius` skill folders by staging a fresh copy and swapping it into place, so removed files do not linger. Python 3 must be available on `PATH`.

### Explicit Harness Installs

Use these when you only want Armarius installed for one harness. Use `--copilot` or `--windsurf` only when you want the native harness path in addition to, or instead of, the default shared `.agents` path.

**Codex**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --codex --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Codex -Yes
```

**Claude Code**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --claude --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Claude -Yes
```

**Cursor**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --cursor --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Cursor -Yes
```

**Kiro**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --kiro --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Kiro -Yes
```

**Cline**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --cline --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Cline -Yes
```

**GitHub Copilot Native Path**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --copilot --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Copilot -Yes
```

**Windsurf Native Path**

macOS, Linux, Git Bash, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.sh | bash -s -- --windsurf --yes
```

Windows PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/tbladh/armarius-skill/main/install.ps1))) -Windsurf -Yes
```

From a clone, run `bash install.sh --codex`, `bash install.sh --cline`, or another explicit flag. Native Windows supports the matching PowerShell switches such as `.\install.ps1 -Codex` and `.\install.ps1 -Cline`. Legacy Codex installation is opt-in with `--legacy-codex` or `-LegacyCodex`.

## What It Sets Up

Armarius creates task-local tooling under the current repository:

```text
.armarius/venv
.armarius/outputs
.armarius/scripts
```

The skill installs practical Python dependencies into `.armarius/venv`, writes extracted text and structured JSON under `.armarius/outputs`, and uses `.armarius/scripts` for custom repo-local helpers when built-in or native harness tooling is not enough.

## Use

Ask your agent to use Armarius for document work, for example:

```text
Use $armarius to read this PDF and summarize the obligations by section.
Use $armarius to inspect this workbook and explain the calculated columns.
Use $armarius to read this PowerPoint and summarize each slide.
Use $armarius to convert this markdown summary into a DOCX.
```

The skill will create `.armarius/venv`, install practical document-reading packages, extract text and structured JSON, and proceed from those artifacts.

> [!TIP]
> Example slash prompt:
>
> `/armarius Read the attached PowerPoint and summarize the goal, risks, and decisions slide by slide.`
> `If extraction needs custom parsing, create the helper under .armarius/scripts and keep the extracted artifacts under .armarius/outputs.`

## License

[MIT](LICENSE)
