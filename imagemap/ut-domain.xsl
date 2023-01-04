<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:aco="http://www.acolad.com" version="2.0" exclude-result-prefixes="aco">

  <xsl:param name="imagemap.hotspot.enabled" select="'no'" />
  <xsl:param name="imagemap.hotspot.legend" select="'yes'" />

  <xsl:template match="*[contains(@class, ' ut-d/imagemap ')]">
    <xsl:choose>
      <xsl:when test="$imagemap.hotspot.enabled = 'yes'">
        <xsl:variable name="attributes" as="attribute()*">
          <xsl:call-template name="commonattributes" />
        </xsl:variable>
        <xsl:if test="exists($attributes)">
          <fo:inline>
            <xsl:sequence select="$attributes" />
          </fo:inline>
        </xsl:if>

        <fo:block-container margin-left="{$side-col-width}">
          <fo:block-container margin="0" padding="0">
            <!-- reset margins -->
            <!-- image -->
            <fo:block>
              <xsl:apply-templates select="*[contains(@class, ' topic/image ')]" />
            </fo:block>
            <!-- svg hotspots -->
            <xsl:apply-templates select="*[contains(@class, ' ut-d/area ')]" mode="imagemap">
              <xsl:with-param name="scale" tunnel="yes" select="
                  (
                  if (*[contains(@class, ' topic/image ')]/@scale) then
                    *[contains(@class, ' topic/image ')]/@scale
                  else
                    100) div 100" as="xs:double" />
            </xsl:apply-templates>
          </fo:block-container>
        </fo:block-container>
        <!-- hotspots list -->
        <xsl:if test="$imagemap.hotspot.legend = 'yes'">
          <fo:list-block xsl:use-attribute-sets="ol">
            <xsl:apply-templates select="*[contains(@class, ' ut-d/area ')]"> </xsl:apply-templates>
          </fo:list-block>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- circle shape -->
  <xsl:template
    match="*[contains(@class, ' ut-d/area ')][*[contains(@class, ' ut-d/shape ')][. = 'circle']]"
    mode="imagemap">
    <xsl:param name="scale" tunnel="yes" as="xs:double" />
    <xsl:variable name="coord-x"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[1]) * $scale => number()"
      as="xs:double" />
    <xsl:variable name="coord-y"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[2]) * $scale => number()"
      as="xs:double" />
    <xsl:variable name="radius"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[3]) * $scale => number()"
      as="xs:double" />
    <xsl:variable name="width" select="$coord-x + $radius + (2 * $scale)" as="xs:double" />
    <xsl:variable name="height" select="$coord-y + $radius + (2 * $scale)" as="xs:double" />

    <fo:block-container xsl:use-attribute-sets="svg_shape_container">
      <fo:block margin="0" padding="0">
        <fo:instream-foreign-object xmlns:svg="http://www.w3.org/2000/svg">
          <svg:svg height="{$height}px" width="{$width}px">
            <svg:g transform="translate({$coord-x - $radius},{$coord-y - $radius})">
              <svg:a
                xlink:href="{aco:format.href.svg.link(*[contains(@class,' topic/xref ')]/@href)}">
                <!-- shape -->
                <svg:circle cx="{$radius + $scale}px" cy="{$radius + $scale}px"
                  r="{$radius}px" xsl:use-attribute-sets="svg_shape_circle" />
                <!-- hotspot number -->
                <xsl:if test="$imagemap.hotspot.legend = 'yes'">
                  <xsl:call-template name="insert.hotspot.circle">
                    <xsl:with-param name="x" select="$radius + (2 * $scale)" />
                    <xsl:with-param name="y" select="$radius + (2 * $scale)" />
                  </xsl:call-template>
                </xsl:if>
              </svg:a>
            </svg:g>
          </svg:svg>
        </fo:instream-foreign-object>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <!-- polygon shape -->
  <xsl:template
    match="*[contains(@class, ' ut-d/area ')][*[contains(@class, ' ut-d/shape ')][. = 'poly']]"
    mode="imagemap">
    <xsl:param name="scale" tunnel="yes" as="xs:double" />
    <xsl:variable name="coord" select="*[contains(@class, ' ut-d/coords ')]" />
    <xsl:variable name="width" select="
        (max(for $i in tokenize(*[contains(@class, ' ut-d/coords ')], ',')[position() mod 2 = 0]
        return
          number($i)) + 1) * $scale" as="xs:double" />
    <xsl:variable name="height" select="
        (max(for $i in tokenize(*[contains(@class, ' ut-d/coords ')], ',')[position() mod 2 != 0]
        return
          number($i)) + 1) * $scale" as="xs:double" />

    <fo:block-container xsl:use-attribute-sets="svg_shape_container">
      <fo:block margin="0" padding="0">
        <fo:instream-foreign-object xmlns:svg="http://www.w3.org/2000/svg">
          <svg:svg height="{$width}px" width="{$height}px">
            <svg:a xlink:href="{aco:format.href.svg.link(*[contains(@class,' topic/xref ')]/@href)}">
              <!-- shape -->
              <svg:polygon
                points="{string-join(for $i in tokenize($coord,',') return string(floor(number($i)*$scale)),',')}"
                xsl:use-attribute-sets="svg_shape_poly" />

              <!-- hotspot number -->
              <xsl:if test="$imagemap.hotspot.legend = 'yes'">
                <xsl:call-template name="insert.hotspot.circle">
                  <xsl:with-param name="x"
                    select="floor(number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[1]) * $scale) => number()" />
                  <xsl:with-param name="y"
                    select="floor(number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[2]) * $scale) => number()"
                   />
                </xsl:call-template>
              </xsl:if>
            </svg:a>
          </svg:svg>
        </fo:instream-foreign-object>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <!-- rectangle shape -->
  <xsl:template
    match="*[contains(@class, ' ut-d/area ')][*[contains(@class, ' ut-d/shape ')][. = 'rect']]"
    mode="imagemap">
    <xsl:param name="scale" tunnel="yes" as="xs:double" />
    <xsl:variable name="coord-x"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[1]) * $scale => number()"
      as="xs:double" />
    <xsl:variable name="coord-y"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[2]) * $scale => number()"
      as="xs:double" />
    <xsl:variable name="width" select="
        max(for $i in tokenize(*[contains(@class, ' ut-d/coords ')], ',')[position() mod 2 = 0]
        return
          number($i)) * $scale + 1" as="xs:double" />
    <xsl:variable name="height" select="
        max(for $i in tokenize(*[contains(@class, ' ut-d/coords ')], ',')[position() mod 2 != 0]
        return
          number($i)) * $scale + 1" as="xs:double" />
    <xsl:variable name="rect-width"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[3]) * $scale => number() - $coord-x"
      as="xs:double" />
    <xsl:variable name="rect-height"
      select="number(tokenize(*[contains(@class, ' ut-d/coords ')], ',')[4]) * $scale => number() - $coord-y"
      as="xs:double" />

    <fo:block-container xsl:use-attribute-sets="svg_shape_container">
      <fo:block margin="0" padding="0">
        <fo:instream-foreign-object xmlns:svg="http://www.w3.org/2000/svg">
          <svg:svg height="{$width}px" width="{$height}px">
            <svg:g transform="translate({$coord-x},{$coord-y})">
              <svg:a
                xlink:href="{aco:format.href.svg.link(*[contains(@class,' topic/xref ')]/@href)}">
                <!-- shape -->
                <svg:rect width="{$rect-width}px" height="{$rect-height}px"
                  xsl:use-attribute-sets="svg_shape_rect" />
                <!-- hotspot number -->
                <xsl:if test="$imagemap.hotspot.legend = 'yes'">
                  <xsl:call-template name="insert.hotspot.circle" />
            </xsl:if>  </svg:a>
            </svg:g>
          </svg:svg>
        </fo:instream-foreign-object>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <!-- hotspot numbering -->
  <xsl:template name="insert.hotspot.circle">
    <xsl:param name="scale" tunnel="yes" />
    <xsl:param name="x" as="xs:double" select="0" />
    <xsl:param name="y" as="xs:double" select="0" />
    <xsl:param name="number" as="xs:integer" select="position()" />
    <xsl:param name="r" as="xs:double" select="4" />
    <svg:circle r="{$r}px" cx="{$x}px" cy="{$y}px" xsl:use-attribute-sets="svg_hotspot_circle"
      xmlns:svg="http://www.w3.org/2000/svg" />
      <svg:text x="{$x}px" y="{$y+2}px" xsl:use-attribute-sets="svg_hotspot_circle_content"
        xmlns:svg="http://www.w3.org/2000/svg">
        <xsl:value-of select="$number" />
      </svg:text>
  </xsl:template>

  <!-- format href for svg:a element -->
  <xsl:function name="aco:format.href.svg.link" as="xs:string">
    <xsl:param name="xref" as="attribute(href)" />
    <!-- a leading # is required for internal link in a svg link -->
    <xsl:sequence select="
        if (starts-with($xref, '#')) then
          '#' || opentopic-func:getDestinationId($xref)
        else
          $xref" />
  </xsl:function>

  <xsl:template match="*[contains(@class, ' ut-d/shape ')]" />

  <xsl:template match="*[contains(@class, ' ut-d/coords ')]" />
</xsl:stylesheet>
