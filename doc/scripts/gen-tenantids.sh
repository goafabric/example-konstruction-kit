#!/bin/bash

# Generate 100 random 8-character hexadecimal numbers
for i in {1..100}; do
  # Use head to read 4 random bytes and convert to hexadecimal
  random_hex=$(head -c 4 /dev/random | xxd -p | tr -d '\n')
  echo -n "$random_hex"
  if [ $i -lt 100 ]; then
    echo -n ","
  fi
done
echo
