#!/usr/bin/env bash
set -eu

purple=$'\033[38;5;141m'
cyan=$'\033[38;5;81m'
green=$'\033[38;5;78m'
amber=$'\033[38;5;215m'
muted=$'\033[38;5;245m'
bold=$'\033[1m'
reset=$'\033[0m'

line() {
  printf '%b\n' "$1"
  sleep "${2:-0.7}"
}

type_text() {
  local text=$1
  local i
  for ((i = 0; i < ${#text}; i++)); do
    printf '%s' "${text:i:1}"
    sleep 0.025
  done
  printf '\n'
}

printf '\033[2J\033[H'
line "${muted}ModelDuet demo · illustrated workflow${reset}" 0.8
printf "\n${bold}❯ ${reset}"
type_text "/modelduet Add a health endpoint with tests"
sleep 0.8

line "${bold}MODELDUET${reset}  Fable 5 supervising · GPT-5.6 Sol building" 1
line "${purple}◆ Fable 5${reset}  Discovery" 0.7
line "  ${green}✓${reset} scope: src/health.ts · tests/health.test.ts" 0.5
line "  ${green}✓${reset} acceptance: GET /health → 200 {\"status\":\"ok\"}" 0.5
line "  ${green}✓${reset} branch: modelduet/health-endpoint" 0.5
line "  ${green}✓${reset} plan: 3 steps · 2 verification commands" 1

line "${cyan}→ GPT-5.6 Sol${reset}  Round 1 · implementing" 0.8
line "  ${green}+${reset} endpoint and tests" 0.5
line "  ${green}✓${reset} 11 tests passed" 1

line "${purple}◆ Fable 5${reset}  Review · diff + verification" 0.7
line "  ${amber}! BLOCKING${reset} src/health.ts:18 — cached response object" 0.5
line "    expected: return a fresh timestamp per request" 1

line "${cyan}→ GPT-5.6 Sol${reset}  Round 2 · fixing 1 blocker" 0.8
line "  ${green}✓${reset} fresh response per request" 0.5
line "  ${green}✓${reset} 12 tests passed · typecheck passed" 1

line "${purple}◆ Fable 5${reset}  Final review" 0.7
line "  ${green}✓${reset} 4/4 acceptance criteria" 0.5
line "  ${green}✓${reset} zero blocking findings" 0.7
line "${green}${bold}APPROVED${reset}  2 rounds · branch ready for you" 1
printf '\n%b\n' "${muted}ModelDuet never merges or pushes without your approval.${reset}"
sleep 4
