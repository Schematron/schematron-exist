module namespace _ = "0005";

import module namespace s = "http://github.com/vincentml/schematron-exist" at "../../schematron.xqm";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare %test:assertEquals(
    'false',
    'true',
    4,
    'info',
    'info',
    'warn',
    'error',
    '/document/title',
    'short section has fewer than 3 paragraphs',
    '/document/p[2]',
    'p (paragraph) should not be empty'
    ) function _:example1a() {
  let $sch := s:compile(doc('example-1.sch'))
  let $svrl := s:validate(doc('example-1a.xml'), $sch)
  return (
    s:is-valid($svrl),
    s:has-messages($svrl),
    count(s:messages($svrl)),
    s:message-level(s:messages($svrl)[1]),
    s:message-level(s:messages($svrl)[2]),
    s:message-level(s:messages($svrl)[3]),
    s:message-level(s:messages($svrl)[4]),
    data(s:messages($svrl)[3]/@location),
    normalize-space(data(s:messages($svrl)[3]/*:text)),
    data(s:messages($svrl)[4]/@location),
    normalize-space(data(s:messages($svrl)[4]/*:text))
  )
};

declare %test:assertEquals(
    'true',
    'true',
    3,
    'info',
    'info',
    'warn',
    '/document/title',
    'short section has fewer than 3 paragraphs'
    ) function _:example1b() {
  let $sch := s:compile(doc('example-1.sch'))
  let $svrl := s:validate(doc('example-1b.xml'), $sch)
  return (
    s:is-valid($svrl),
    s:has-messages($svrl),
    count(s:messages($svrl)),
    s:message-level(s:messages($svrl)[1]),
    s:message-level(s:messages($svrl)[2]),
    s:message-level(s:messages($svrl)[3]),
    data(s:messages($svrl)[3]/@location),
    normalize-space(data(s:messages($svrl)[3]/*:text))
  )
};

declare %test:assertEquals('true', 'false') function _:example1c() {
  let $sch := s:compile(doc('example-1.sch'))
  let $svrl := s:validate(doc('example-1c.xml'), $sch)
  return (
    s:is-valid($svrl), 
    s:has-messages($svrl)
  )
};
