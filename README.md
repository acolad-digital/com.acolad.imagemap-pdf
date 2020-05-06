com.amplexor.imagemap-pdf
========================

[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

**com.amplexor.imagemap-pdf** is a plugin for the [DITA-OT](http://dita-ot.github.io) that extends the **org.dita.pdf2** plugin to manage [DITA imagemap element](https://www.oxygenxml.com/dita/1.3/specs/langRef/base/imagemap.html) in PDF.

Tested on DITA-OT 3.X. with Antenna House 6.6 and 7.x.
Some limitation exists with FOP (tested with FOP 2.4): internal link between image map area and an `@id` on dita content doesn't work.

Installation
------------

Copy **com.amplexor.imagemap-pdf** in DITA-OT plugins directory and run `dita --install`

Standalone usage
-----

Launch DITA OT PDF output with **imagemap-pdf** transtype:
```shell
dita --input myDitamap --format imagemap-pdf
```


Usage with custom pdf2 based plugins
------------------------------------

If you want to use this plugin with your custom `pdf2` based plugins you need to add some additional `<xsl:import>` statements:
```xml
<xsl:import href="plugin:com.amplexor.imagemap-pdf:cfg/fo/xsl/ut-domain.xsl"/>
<xsl:import href="plugin:com.amplexor.imagemap-pdf:cfg/fo/attrs/ui-domain-attr.xsl"/>
```

You need also to add a dependency to **com.amplexor.imagemap-pdf** at the end of your **plugin.xml**:

```xml
<require plugin="com.amplexor.imagemap-pdf"/>
```

Usage with Antenna House
------------------------

To use this plugin with Antenna House you have to change [pxpi property](https://www.antennahouse.com/product/ahf60/docs/ahf-optset.html#pxpi) in your AHFSettings.xml:
```xml
<formatter-settings pxpi="72"/>
```        

