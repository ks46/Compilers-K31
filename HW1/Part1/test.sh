#!/usr/bin/env bash

FAILED=0

# test some valid expressions

EXPRESSION_LIST=('1&(0)' '1&(0)^6&7^0' '8^3&(3^2^1)' '(5&1^(2)^(7)&3)&0' '(9^3&2^5)&1'
                 '(1)' '1^(2)' '1&2' '4&5&6' '1^2^3' '1^(3&7)&9^8'
                 '5&(4&(2^4^(2&7^8^9^(2^0)&((9^3)^7&5^4))))')

for exp in "${EXPRESSION_LIST[@]}"; do
  result=$(java Main <<< $exp);
  if [[ $result != $(($exp)) ]]; then
    echo "Error: input [$exp] results in [$result]"
    echo "Expected output: [$(($exp))]"
    FAILED=1
  fi
done

# test some malformed expressions

EXPRESSION_LIST=('1&' '(0' '8^3&(3^2^1' ')' '46' '&' '^' '&1' '()' '12^2'
                 '(' '5^)' '2^' '2&&1' '2^^1' '(((3&2))' '1&2^' '(5))' '5^^(2&)' 'a & 3 ')

for exp in "${EXPRESSION_LIST[@]}"; do
  result=$(java Main <<< $exp 2>&1);
  if [[ $result != "parse error" ]]; then
    echo "Error: input [$exp] results in [$result]"
    echo "Expected output: [parse error]"
    FAILED=1
  fi
done

if [[ !FAILED ]]; then
  echo "Passed all tests!"
fi