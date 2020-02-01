xquery version "3.1";
(:~
 : Schematron module for eXist
 :
 : @author Vincent M. Lizzi
 : @author Duncan Paterson
 : @see LICENSE (The MIT License)
 : @see http://exist-db.org/
 : @see http://github.com/Schematron/schematron-exist
 : @version 1.1.0
 :)

module namespace _ = "http://github.com/Schematron/schematron-exist";

declare namespace sch = "http://purl.oclc.org/dsdl/schematron";
declare namespace svrl = "http://purl.oclc.org/dsdl/svrl";
declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";
declare namespace xmldb = "http://exist-db.org/xquery/xmldb";

declare variable $_:path := '/db/system/repo/schematron-exist-2.0.0/content/iso-schematron/';

declare variable $_:include := $_:path || "iso_dsdl_include.xsl";
declare variable $_:expand := $_:path || "iso_abstract_expand.xsl";
declare variable $_:compile1 := $_:path || "iso_svrl_for_xslt1.xsl";
declare variable $_:compile2 := $_:path || "iso_svrl_for_xslt2.xsl";

declare variable $_:error := ('error', 'fatal');
declare variable $_:warn := ('warn', 'warning');
declare variable $_:info := ('info', 'information');

(:~
 : Compile a given Schematron file so that it can be used to validate documents.
 :)
declare function _:compile($schematron) as node() {
  _:compile($schematron, () )
};

(:~
 : Compile a given Schematron file using given parameters so that it can be used to validate documents.
 :)
declare function _:compile($schematron, $params) as node() {
  let $p := typeswitch ($params)
    case xs:string return <parameters><param name="phase" value="{$params}"/></parameters>
    default return $params
  let $step1 := transform:transform($schematron, doc($_:include), $p)
  let $step2 := transform:transform($step1, doc($_:expand), $p)
  let $step3 := transform:transform($step2, doc($_:compile2), $p)
  return $step3
};

(:~
 : Validate a given document using a compiled Schematron. Returns SVRL validation result.
 :)
declare function _:validate($document as node(), $compiledSchematron as node()) as node() {
  transform:transform($document, $compiledSchematron, ())
};

(:~
 : Check whether a SVRL validation result indicates valid in a pass/fail sense.
 :)
declare function _:is-valid($svrl) as xs:boolean {
  boolean($svrl[descendant::svrl:fired-rule]) and
  not(boolean(($svrl//svrl:failed-assert union $svrl//svrl:successful-report)[
    not(@role) or @role = $_:error
  ]))
};

(:~
 : Check whether a SVRL validation result contains any error, warning, or informational messages.
 :)
declare function _:has-messages($svrl) as xs:boolean {
  boolean(($svrl//svrl:failed-assert union $svrl//svrl:successful-report))
};

(:~
 : Return messages from a SVRL validation result.
 :)
declare function _:messages($svrl) as item()* {
  ($svrl//svrl:failed-assert union $svrl//svrl:successful-report)
};

(:~
 : Return severity (error, warn, info) of a message based on the role attribute.
 : Variations are standardized:
 :     'error' and 'fatal' return 'error',
 :     'warn' and 'warning' returns 'warn',
 :     'info' and 'information' returns 'info'
 : If the role attribute value is unrecognized the value is returned unchanged.
 :)
declare function _:message-level($message) as xs:string {
  if ($message[not(@role) or @role = $_:error]) then $_:error[1]
  else if ($message[@role = $_:warn]) then $_:warn[1]
  else if ($message[@role = $_:info]) then $_:info[1]
  else data($message/@role)
};


declare function _:message-description($message) as xs:string {
  data($message/svrl:text)
};

declare function _:message-location($message) as xs:string {
  data($message/@location)
};
