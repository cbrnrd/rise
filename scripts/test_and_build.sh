#!/bin/bash
cd ..
rspec
if [[ "$?" -ne "0"  ]]; then
  echo -e "\033[0;31mTests failed, not building the gem\033[0;0m"
  exit $?
fi

rubocop --fail-level W
if [[ "$?" -ne "0"  ]]; then
  echo -e "\033[0;31mRubocop failed, not building the gem\033[0;0m"
  exit $?
fi

rake build
