# Schematron for eXist

XQuery library module to use ISO Schematron in [eXist](http://exist-db.org/). This module uses the standard Schematron implementation from https://code.google.com/p/schematron/. This module is a port of [schematron-basex](https://github.com/Schematron/schematron-basex) to eXist.

> :warning: This module relies on the ["skeleton" Schematron](https://github.com/Schematron/schematron) implementation, which is no longer maintained. Please consider using [SchXslt](https://github.com/schxslt/schxslt) instead.

## Usage

Install the module in the way described in the eXist documentation. Go to the Dashboard and open the Package Manager. Click the add a package button, and then upload schematron-exist-1.1.xar.

After the module is installed, in your XQuery code declare the module import:

    import module namespace schematron = "http://github.com/Schematron/schematron-exist";

Your Schematron schema file first has to be compiled before it can be used to validate XML. The compiled Schematron can be re-used to validate multiple documents, or possibly stored in a collection for later use.

    let $sch := schematron:compile(doc('rules.sch'))

If your Schematron contains phases you can specify the phase to use by passing the name of the phase in the second argument.

    let $sch := schematron:compile(doc('rules.sch'), 'phase1')

If you need to pass additional parameters to compile the Schematron the second argument can be provided as a parameters element. The phase can be specified by including a parameter named `phase`.

    let $sch := schematron:compile(doc('rules.sch'), <parameters><param name="phase" value="phase1"/></parameters>)

Next, validate an XML using the compiled Schematron.

    let $svrl := schematron:validate(doc('document.xml'), $sch)

The validate method returns SVRL XML. This module provides several utility methods for inspecting SVRL.

To simply check whether validation has passed or failed use the is-valid method, which returns a boolean value.

    let $boolean := schematron:is-valid($svrl)

Schematron validation may return warnings or informational messages in addition to error messages. The has-messages method returns a boolean value to indicate if any messages are present.

    let $boolean := schematron:has-messages($svrl)

To get all messages that were generated as a sequence:

    let $messages := schematron:messages($svrl)

The message-level method returns 'error', 'warn' or 'info' (or custom values) based on the `role` attribute on Schematron `<assert>` and `<report>` elements. This method normalizes the role attribute value from the Schematron schema: if the role attribute is absent or contains 'error' or 'fatal' this method returns 'error'; if role contains 'warn' or 'warning' this method returns 'warn'; if role contains 'info' or 'information' this method returns 'info'. Any other value of the role attribute is returned unchanged. 

    let $level := schematron:message-level($message)

To get the human text description from a message:

    let $string := schematron:message-description($message)

To get the XPath location where a message was generated:

    let $string := schematron:message-location($message)

Putting this all together:

```
import module namespace schematron = "http://github.com/Schematron/schematron-exist";

let $sch := schematron:compile(doc('rules.sch'))
let $svrl := schematron:validate(doc('document.xml'), $sch)
return (
  schematron:is-valid($svrl),
  for $message in schematron:messages($svrl)
  return concat(schematron:message-level($message), ': ', schematron:message-description($message))
)
```

More examples are available in the `examples` folder.


## Using XPath 2.0 and above

XPath 2.0 is supported out of the box. Remember to set attribute `queryBinding="xslt2"` on the schema element of your Schematron.


## Developing

This module was developed using eXist 3.0RC1, although it may work with earlier versions.

Unit tests are located in the `test` folder. To run the unit tests open `test-suite.xq` in eXide and then click the Eval button.

The included Ant build script build.xml will create a xar file for loading into eXist.

