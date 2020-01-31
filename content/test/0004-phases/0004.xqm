module namespace _ = "0004";

import module namespace s = "http://github.com/Schematron/schematron-exist";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare %test:assertTrue function _:phase1() {
  let $p := <parameters><param name="phase" value="phase1"/></parameters>
  let $s := s:compile(doc('0004.sch'), $p)
  let $r := s:validate(doc('0004.xml'), $s)
  return s:is-valid($r)
};

declare %test:assertFalse function _:phase2() {
  let $p := <parameters><param name="phase" value="phase2"/></parameters>
  let $s := s:compile(doc('0004.sch'), $p)
  let $r := s:validate(doc('0004.xml'), $s)
  return s:is-valid($r)
};

declare %test:assertTrue function _:phase1string() {
  let $s := s:compile(doc('0004.sch'), 'phase1')
  let $r := s:validate(doc('0004.xml'), $s)
  return s:is-valid($r)
};

declare %test:assertFalse function _:phase2string() {
  let $s := s:compile(doc('0004.sch'), 'phase2')
  let $r := s:validate(doc('0004.xml'), $s)
  return s:is-valid($r)
};
