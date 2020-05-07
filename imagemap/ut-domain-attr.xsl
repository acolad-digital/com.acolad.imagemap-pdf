<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0">

    <xsl:variable name="defaultSvgShapeStrokeColor" select="'blue'" as="xs:string"/>
    <xsl:variable name="defaultSvgHotspotTextColor" select="'white'" as="xs:string"/>

    <xsl:attribute-set name="svg_shape_container">
        <xsl:attribute name="absolute-position">absolute</xsl:attribute>
        <xsl:attribute name="top">0</xsl:attribute>
        <xsl:attribute name="left">0</xsl:attribute>
        <xsl:attribute name="margin">0</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="svg_shape">
        <xsl:attribute name="stroke"><xsl:value-of select="$defaultSvgShapeStrokeColor"/></xsl:attribute>
        <xsl:attribute name="stroke-width">1</xsl:attribute>
        <xsl:attribute name="fill-opacity">0</xsl:attribute>
        <xsl:attribute name="stroke-opacity">1</xsl:attribute>    
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="svg_shape_rect" use-attribute-sets="svg_shape"/>
    
    <xsl:attribute-set name="svg_shape_poly" use-attribute-sets="svg_shape"/>
    
    <xsl:attribute-set name="svg_shape_circle" use-attribute-sets="svg_shape"/>
    
    <xsl:attribute-set name="svg_hotspot_circle">
        <xsl:attribute name="stroke"><xsl:value-of select="$defaultSvgShapeStrokeColor"/></xsl:attribute>
        <xsl:attribute name="fill"><xsl:value-of select="$defaultSvgShapeStrokeColor"/></xsl:attribute>
        <xsl:attribute name="stroke-width">1</xsl:attribute>
        <xsl:attribute name="fill-opacity">1</xsl:attribute>
        <xsl:attribute name="stroke-opacity">1</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="svg_hotspot_circle_content">
        <xsl:attribute name="fill"><xsl:value-of select="$defaultSvgHotspotTextColor"/></xsl:attribute>
        <xsl:attribute name="font-size">0.4em</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="text-anchor">middle</xsl:attribute>
    </xsl:attribute-set>
    
</xsl:stylesheet>