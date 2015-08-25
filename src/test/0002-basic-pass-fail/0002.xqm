module namespace _ = "0002";

import module namespace s = "http://github.com/vincentml/schematron-exist" at "../../main/content/schematron.xqm";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare %test:assertTrue function _:valid() {
  let $r := s:validate(doc('0002-valid.xml'), s:compile(doc('0002.sch')))
  return s:is-valid($r)
};

declare %test:assertFalse function _:invalid() {
  let $r := s:validate(doc('0002-invalid.xml'), s:compile(doc('0002.sch')))
  return s:is-valid($r)
};

declare %test:assertEmpty function _:valid-messages() {
  let $r := s:messages(s:validate(doc('0002-valid.xml'), s:compile(doc('0002.sch'))))
  return $r
};

declare %test:assertEquals(1) function _:invalid-messages() {
  let $r := s:messages(s:validate(doc('0002-invalid.xml'), s:compile(doc('0002.sch'))))
  return count($r)
};
