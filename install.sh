#!/usr/bin/env bash
set -euo pipefail

SCRIPT_SOURCE="${BASH_SOURCE:-$0}"
REPO_ROOT="$(cd "$(dirname "${SCRIPT_SOURCE}")" && pwd)"
ASSUME_YES=0
TARGET_MODE="codex"
INSTALL_HOME_DIR="${ARMARIUS_INSTALL_HOME:-${HOME}}"

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Install Armarius globally for an agent harness.

Options:
  --codex       Install to ~/.agents/skills (default)
  --claude      Install to ~/.claude/skills
  --cursor      Install to ~/.cursor/skills
  --kiro        Install to ~/.kiro/skills
  --cline       Install to ~/.cline/skills
  --copilot     Install to ~/.copilot/skills
  --windsurf    Install to ~/.codeium/windsurf/skills
  --yes         Replace existing install without prompting
  --help        Show this help text

Environment:
  ARMARIUS_INSTALL_HOME  Override the home directory used for installation targets.
EOF
}

run_python() {
  if command -v python3 >/dev/null 2>&1; then
    python3 "$@"
    return
  fi
  if command -v python >/dev/null 2>&1; then
    python "$@"
    return
  fi
  if command -v py >/dev/null 2>&1; then
    py -3 "$@"
    return
  fi
  echo "Armarius installer needs Python 3, but no Python launcher was found on PATH." >&2
  return 127
}

confirm_replace() {
  local harness="$1"
  local path="$2"
  if [[ ! -e "${path}" || "${ASSUME_YES}" -eq 1 ]]; then
    return 0
  fi
  if [[ ! -t 0 ]]; then
    printf '%s\n' "Skipped ${harness}: rerun with --yes to replace ${path}." >&2
    return 1
  fi
  local reply=""
  printf 'Replace existing %s install at %s? [y/N] ' "${harness}" "${path}"
  read -r reply || true
  case "${reply}" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

install_one() {
  local harness="$1"
  local root_dir="$2"
  local rendered_skill_dir="$3"
  local skill_name
  skill_name="$(basename "${rendered_skill_dir}")"
  local dest_dir="${root_dir}/${skill_name}"
  local stage_dir="${root_dir}/.${skill_name}.new.$$"
  local backup_dir="${root_dir}/.${skill_name}.previous.$$"

  mkdir -p "${root_dir}"
  if ! confirm_replace "${harness}" "${dest_dir}"; then
    echo "Skipped ${harness}."
    return 0
  fi

  rm -rf "${stage_dir}" "${backup_dir}"
  cp -R "${rendered_skill_dir}" "${stage_dir}"
  if [[ -e "${dest_dir}" ]]; then
    mv "${dest_dir}" "${backup_dir}"
  fi
  if ! mv "${stage_dir}" "${dest_dir}"; then
    [[ -e "${backup_dir}" ]] && mv "${backup_dir}" "${dest_dir}"
    echo "Could not install ${harness}; restored the previous install." >&2
    return 1
  fi
  rm -rf "${backup_dir}"
  echo "Installed ${harness}: ${dest_dir}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --codex|--claude|--cursor|--kiro|--cline|--copilot|--windsurf)
      TARGET_MODE="${1#--}"
      ;;
    --yes)
      ASSUME_YES=1
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

RENDER_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/armarius-render.XXXXXX")"
trap 'rm -rf "${RENDER_ROOT}"' EXIT
RENDERED_SKILL_DIR="$(run_python "${REPO_ROOT}/scripts/render_skill.py" --repo-root "${REPO_ROOT}" --output-dir "${RENDER_ROOT}")"

case "${TARGET_MODE}" in
  codex) install_one "Codex" "${INSTALL_HOME_DIR}/.agents/skills" "${RENDERED_SKILL_DIR}" ;;
  claude) install_one "Claude" "${INSTALL_HOME_DIR}/.claude/skills" "${RENDERED_SKILL_DIR}" ;;
  cursor) install_one "Cursor" "${INSTALL_HOME_DIR}/.cursor/skills" "${RENDERED_SKILL_DIR}" ;;
  kiro) install_one "Kiro" "${INSTALL_HOME_DIR}/.kiro/skills" "${RENDERED_SKILL_DIR}" ;;
  cline) install_one "Cline" "${INSTALL_HOME_DIR}/.cline/skills" "${RENDERED_SKILL_DIR}" ;;
  copilot) install_one "GitHub Copilot" "${INSTALL_HOME_DIR}/.copilot/skills" "${RENDERED_SKILL_DIR}" ;;
  windsurf) install_one "Windsurf" "${INSTALL_HOME_DIR}/.codeium/windsurf/skills" "${RENDERED_SKILL_DIR}" ;;
esac
