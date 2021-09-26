#!/bin/bash

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHIBI_SAT=${CHIBI_SAT:-$REPO_ROOT/.build/release/chibi-sat}
PICOSAT=${PICOSAT:-$REPO_ROOT/Benchmarks/build/picosat/picosat}

for i in $(seq 2 49); do
  target_cnf=$REPO_ROOT/Benchmarks/small-cnf/small-cnf-${i}.cnf
  $CHIBI_SAT $target_cnf > /dev/null 2>&1
  actual_code=$?
  $PICOSAT $target_cnf > /dev/null 2>&1
  expected_code=$?

  if [[ $actual_code != $expected_code ]]; then
    echo "The result of $target_cnf is not compatible"
    exit 1
  fi

  printf .
done
