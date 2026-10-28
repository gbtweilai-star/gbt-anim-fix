#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_anim_fix info
PYTHONPATH=src python -m gbt_anim_fix check --payload '{}'
PYTHONPATH=src python -m gbt_anim_fix run   --payload '{}'
