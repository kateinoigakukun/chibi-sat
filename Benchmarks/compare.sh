#!/bin/bash

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHIBI_SAT=${CHIBI_SAT:-$REPO_ROOT/.build/release/chibi-sat}
PICOSAT=${PICOSAT:-$REPO_ROOT/Benchmarks/build/picosat/picosat}
RESULTS_DIR="$REPO_ROOT/Benchmarks/results"

mkdir -p "$RESULTS_DIR"
hyperfine --parameter-scan var_size 2 29 --max-runs 10 \
  --ignore-failure  --export-csv $RESULTS_DIR/compare.csv \
  "$CHIBI_SAT $REPO_ROOT/Benchmarks/small-cnf/small-cnf-{var_size}.cnf" \
  "$PICOSAT   $REPO_ROOT/Benchmarks/small-cnf/small-cnf-{var_size}.cnf"

