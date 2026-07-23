# Armarius Repo

This repository builds and distributes a portable document-work skill for agent harnesses.

## Source Of Truth

`AGENTS.md` is the shared instruction file for this repo.

- Keep shared repo guidance here.
- Keep `CLAUDE.md`, `.cursorrules`, and `.cursor/rules/*.mdc` as thin bridges back to this file. Kiro can consume `AGENTS.md` directly.
- Keep skill behavior in `template/skill/SKILL.md` and linked references.
- Keep helper behavior in `template/skill/scripts/`.

## Objective

Maintain a goal-oriented starter kit that helps agents make fast, competent progress on document tasks:

- Read PDFs, Word documents, PowerPoint decks, spreadsheets, standalone images via OCR, CSV/TSV, text, HTML, and common converted forms.
- Sniff file scope before setup and install only required Python dependencies in the target repository under `.armarius/venv`.
- Write extracted text and structured JSON under `.armarius/outputs`.
- Create repo-local custom helper scripts under `.armarius/scripts` when a task needs them.
- Make it straightforward to promote generally useful local scripts or lessons back into this skill repo.

## Repo Layout

- `template/skill/`: Portable skill source with placeholders.
- `template/skill/requirements/`: Dependency profiles installed into target repo `.armarius/venv`.
- `template/skill/scripts/`: Launchers and Python tooling used by the skill.
- `template/skill/references/`: Detailed extraction, dependency, and writing guidance.
- `config/defaults.env`: Centralized product naming.
- `scripts/render_skill.py`: Render the template into a concrete skill folder.
- `install.sh` and `install.ps1`: Global installers for Codex, Claude, Cursor, Kiro, Cline, GitHub Copilot, and Windsurf. The default broad install targets Codex/Claude/Cursor/Kiro/Cline only; Copilot and Windsurf piggyback on `~/.agents/skills` by default and their native paths are explicit opt-ins.

## Working Rules

- Default document-work state belongs in the current repository under `.armarius/`.
- Do not install Python packages globally from skill scripts.
- Keep `.armarius` parsimonious: create `venv`, `outputs`, and `scripts` only when the current job actually needs each path.
- Prefer deterministic helper scripts over one-off extraction snippets.
- Keep `SKILL.md` concise and push detailed guidance into one-level references.
- Validate rendered skill output, not only template source.
- Keep the portable skill itself free of harness-specific behavior except for optional metadata files and path-resolution fallbacks.
- Preserve Engram-style default install semantics: `--all` must not install native Copilot or Windsurf paths because they discover the shared `.agents` install.
- Do not commit or push changes without explicit user approval for that specific commit or push.
