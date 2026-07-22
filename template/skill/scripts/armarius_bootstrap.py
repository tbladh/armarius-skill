#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


PROFILE_FILES = {
    "read": ["read.txt"],
    "write": ["write.txt"],
    "ocr": ["ocr.txt"],
    "all": ["read.txt", "write.txt", "ocr.txt"],
}


def repo_root(value: str | None) -> Path:
    return Path(value or os.getcwd()).resolve()


def skill_root() -> Path:
    return Path(__file__).resolve().parents[1]


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
    (armarius_dir / "outputs").mkdir(parents=True, exist_ok=True)
    (armarius_dir / "scripts").mkdir(parents=True, exist_ok=True)
    (armarius_dir / "cache").mkdir(parents=True, exist_ok=True)

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


def install_requirements(python_path: Path, paths: list[Path], upgrade: bool, dry_run: bool) -> None:
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
    parser.add_argument(
        "--profile",
        action="append",
        choices=sorted(PROFILE_FILES),
        default=None,
        help="Dependency profile to install. May be repeated. Defaults to read.",
    )
    parser.add_argument("--upgrade", action="store_true", help="Upgrade installed dependencies.")
    parser.add_argument("--dry-run", action="store_true", help="Report planned setup without installing.")
    parser.add_argument("--json", action="store_true", help="Emit JSON.")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    root = repo_root(args.repo_root)
    profiles = args.profile or ["read"]
    paths = requirement_paths(profiles)
    python_path = ensure_venv(root, args.dry_run)
    install_requirements(python_path, paths, args.upgrade, args.dry_run)

    result = {
        "repo_root": str(root),
        "armarius_dir": str(root / ".armarius"),
        "venv_dir": str(root / ".armarius" / "venv"),
        "python": str(python_path),
        "profiles": profiles,
        "requirements": [str(path) for path in paths],
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
