#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


PDF_EXTENSIONS = {".pdf"}
WORD_EXTENSIONS = {".docx"}
DECK_EXTENSIONS = {".pptx", ".pptm", ".ppsx", ".ppsm", ".potx", ".potm"}
SHEET_EXTENSIONS = {".xlsx", ".xlsm", ".xls"}
HTML_EXTENSIONS = {".html", ".htm"}
IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".tif", ".tiff", ".bmp", ".gif", ".webp"}
NO_DEP_EXTENSIONS = {".txt", ".md", ".rst", ".log", ".json", ".xml", ".yaml", ".yml", ".csv", ".tsv"}

PROFILE_FILES = {
    "core": [],
    "pdf": ["pdf.txt"],
    "word": ["word.txt"],
    "deck": ["deck.txt"],
    "sheet": ["sheet.txt"],
    "html": ["html.txt"],
    "image-ocr": ["image-ocr.txt"],
    "read": ["read.txt"],
    "write": ["write.txt"],
    "write-docx": ["write-docx.txt"],
    "write-deck": ["write-deck.txt"],
    "write-sheet": ["write-sheet.txt"],
    "write-pdf": ["write-pdf.txt"],
    "ocr": ["image-ocr.txt"],
    "all": [
        "read.txt",
        "write.txt",
        "image-ocr.txt",
        "write-docx.txt",
        "write-deck.txt",
        "write-sheet.txt",
        "write-pdf.txt",
    ],
}


def repo_root(value: str | None) -> Path:
    return Path(value or os.getcwd()).resolve()


def skill_root() -> Path:
    return Path(__file__).resolve().parents[1]


def sniff_profile(source: Path) -> str:
    ext = source.suffix.lower()
    if ext in PDF_EXTENSIONS:
        return "pdf"
    if ext in WORD_EXTENSIONS:
        return "word"
    if ext in DECK_EXTENSIONS:
        return "deck"
    if ext in SHEET_EXTENSIONS:
        return "sheet"
    if ext in HTML_EXTENSIONS:
        return "html"
    if ext in IMAGE_EXTENSIONS:
        return "image-ocr"
    if ext in NO_DEP_EXTENSIONS:
        return "core"
    return "core"


def venv_python(venv_dir: Path) -> Path:
    if os.name == "nt":
        return venv_dir / "Scripts" / "python.exe"
    return venv_dir / "bin" / "python"


def run(command: list[str], dry_run: bool) -> None:
    if dry_run:
        return
    subprocess.check_call(command)


def ensure_venv(root: Path, dry_run: bool) -> Path:
    armarius_dir = root / ".armarius"
    venv_dir = armarius_dir / "venv"
    if dry_run:
        return venv_python(venv_dir)
    armarius_dir.mkdir(parents=True, exist_ok=True)

    python_path = venv_python(venv_dir)
    if not python_path.exists():
        run([sys.executable, "-m", "venv", str(venv_dir)], dry_run)
    return python_path


def requirement_paths(profiles: list[str]) -> list[Path]:
    requirements_dir = skill_root() / "requirements"
    paths: list[Path] = []
    for profile in profiles:
        for filename in PROFILE_FILES[profile]:
            path = requirements_dir / filename
            if path not in paths:
                paths.append(path)
    return paths


def resolve_profiles(raw_profiles: list[str] | None, source: str | None) -> list[str]:
    profiles = raw_profiles or ["core"]
    resolved: list[str] = []
    source_path = Path(source).resolve() if source else None
    for profile in profiles:
        selected = sniff_profile(source_path) if profile == "auto" and source_path else profile
        if selected == "auto":
            selected = "core"
        if selected not in resolved:
            resolved.append(selected)
    return resolved


def install_requirements(python_path: Path, paths: list[Path], upgrade: bool, dry_run: bool) -> None:
    if not paths:
        return
    pip_base = [str(python_path), "-m", "pip"]
    run(pip_base + ["install", "--upgrade", "pip", "setuptools", "wheel"], dry_run)
    for path in paths:
        command = pip_base + ["install", "-r", str(path)]
        if upgrade:
            command.insert(3, "--upgrade")
        run(command, dry_run)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Set up repo-local Armarius document tooling.")
    parser.add_argument("--repo-root", help="Target repository root. Defaults to the current directory.")
    parser.add_argument("--source", help="Optional source file used to sniff the smallest dependency profile.")
    parser.add_argument(
        "--profile",
        action="append",
        choices=sorted([*PROFILE_FILES, "auto"]),
        default=None,
        help="Dependency profile to install. May be repeated. Defaults to core. Use auto with --source to sniff.",
    )
    parser.add_argument("--upgrade", action="store_true", help="Upgrade installed dependencies.")
    parser.add_argument("--dry-run", action="store_true", help="Report planned setup without installing.")
    parser.add_argument("--json", action="store_true", help="Emit JSON.")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    root = repo_root(args.repo_root)
    profiles = resolve_profiles(args.profile, args.source)
    paths = requirement_paths(profiles)
    python_path = ensure_venv(root, args.dry_run) if paths else venv_python(root / ".armarius" / "venv")
    install_requirements(python_path, paths, args.upgrade, args.dry_run)

    result = {
        "repo_root": str(root),
        "armarius_dir": str(root / ".armarius"),
        "venv_dir": str(root / ".armarius" / "venv"),
        "python": str(python_path),
        "profiles": profiles,
        "requirements": [str(path) for path in paths],
        "source": str(Path(args.source).resolve()) if args.source else None,
        "venv_required": bool(paths),
        "dry_run": args.dry_run,
    }

    if args.json:
        print(json.dumps(result, indent=2, sort_keys=True))
    else:
        print(f"armarius_dir={result['armarius_dir']}")
        print(f"python={result['python']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
