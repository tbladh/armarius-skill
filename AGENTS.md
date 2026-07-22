# Armarius Repo

This repository builds and distributes a portable document-work skill for agent harnesses.

## Source Of Truth

`AGENTS.md` is the shared instruction file for this repo.

- Keep shared repo guidance here.
- Keep skill behavior in `template/skill/SKILL.md` and linked references.
- Keep helper behavior in `template/skill/scripts/`.

## Objective

Maintain a goal-oriented starter kit that helps agents make fast, competent progress on document tasks:

- Read PDFs, Word documents, spreadsheets, CSV/TSV, text, HTML, and common converted forms.
- Set up practical Python dependencies automatically in the target repository under `.armarius/venv`.
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
- `install.sh` and `install.ps1`: Install the rendered skill into local agent harness paths.

## Working Rules

- Default document-work state belongs in the current repository under `.armarius/`.
- Do not install Python packages globally from skill scripts.
- Prefer deterministic helper scripts over one-off extraction snippets.
- Keep `SKILL.md` concise and push detailed guidance into one-level references.
- Validate rendered skill output, not only template source.
- Do not commit or push changes without explicit user approval for that specific commit or push.
