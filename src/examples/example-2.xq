import module namespace schematron = "http://github.com/vincentml/schematron-exist" at "../main/content/schematron.xqm";

let $svrl := schematron:validate(doc('example-1b.xml'), schematron:compile(doc('example-1.sch')))
return schematron:is-valid($svrl)

(: OUTPUT:

true

:)