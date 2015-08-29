module namespace _ = "0001";

import module namespace s = "http://github.com/vincentml/schematron-exist" at "../../schematron.xqm";

declare namespace svrl="http://purl.oclc.org/dsdl/svrl";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace test="http://exist-db.org/xquery/xqsuite";


declare %test:assertExists function _:compile() {
  let $c := s:compile(doc('0001.sch'))
  return $c[self::xsl:stylesheet]
};

declare %test:assertExists function _:validationResult() {
  let $c := s:compile(doc('0001.sch'))
  let $r := s:validate(doc('0001.xml'), $c)
  return $r[self::svrl:schematron-output]
};


