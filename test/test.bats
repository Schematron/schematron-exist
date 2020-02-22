#!/usr/bin/env bats


# https://github.com/bats-core/bats-core#printing-to-the-terminal

@test "Testuite reports no failures or errors" {
  run xmllint --xpath '//@failures > 0 or //@errors > 0' test/result/*.xml
  [ "$status" -eq 0 ]
  [ "$output" = false ]
}

@test "No testcase failures" {
  run xmllint --xpath "//failure/../../*" test/result/*.xml
  for FAIL in ${output}
  do
    echo "# " ${FAIL} >&3
  done
  [ "$output" = 'XPath set is empty' ]
}

@test "No testcase errors" {
  run xmllint --xpath "//error/../../*" test/result/*.xml
  for ERR in ${output}
  do
    echo "# " ${ERR} >&3
  done
  [ "$output" = 'XPath set is empty' ]
}
