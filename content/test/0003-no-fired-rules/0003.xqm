module namespace _ = "0003";

import module namespace s = "http://github.com/Schematron/schematron-exist";

declare namespace test="http://exist-db.org/xquery/xqsuite";

(:~ Expect validation to fail if the Schematron doesn't match anything in the document. :)
declare %test:assertFalse function _:test() {
  let $c := s:compile(doc('0003.sch'))
  let $r := s:validate(doc('0003.xml'), $c)
  return s:is-valid($r)
};
