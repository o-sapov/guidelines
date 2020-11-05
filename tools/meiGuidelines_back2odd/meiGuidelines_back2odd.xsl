<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:mei="http://www.music-encoding.org/ns/mei"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:func="no:link"
  xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
  exclude-result-prefixes="xs math xd mei rng sch func md2doc" 
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 23, 2020</xd:p>
      <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
      <xd:p>This XSLT is supposed to translate the Markdown version of the MEI Guidelines back into ODD documents. 
        It is run on the mei-source.xml within the music-encoding/music-encoding repo, at ./source/mei-source.xml.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="guidelines.path" select="'/../../guidelines/'" as="xs:string"/>
  <xsl:param name="guidelines.version" select="'dev'" as="xs:string"/>
  
  <xsl:import href="md2doc/md2doc.xsl"/>
  
  <xsl:include href="xsl/parseMarkdown.xsl"/>
  <xsl:include href="xsl/html2odd.xsl"/>
  <xsl:include href="xsl/build.source.xsl"/>
  
  <xsl:variable name="base.path" select="string-join(tokenize(string(document-uri(/)),'/')[position() != last()],'/')" as="xs:string"/>
  <xsl:variable name="guidelines.path.docs" select="$base.path || $guidelines.path || '_guidelines-' || $guidelines.version || '/'" as="xs:string"/>
  <xsl:variable name="guidelines.path.includes" select="$base.path || $guidelines.path || '_includes/' || $guidelines.version || '/'" as="xs:string"/>
  
  <xsl:variable name="guidelines.path.docs.export" select="$base.path || $guidelines.path || '/tools/meiGuidelines_back2odd/export/' || $guidelines.version || '/'" as="xs:string"/>
  
  <xsl:variable name="files" as="node()*">
    <xsl:for-each select="uri-collection($guidelines.path.docs || '?select=*.md')">
      <xsl:variable name="relevant.path" select="substring-after(., $guidelines.path.docs)" as="xs:string"/>
      <xsl:variable name="chapter.file" select="func:parseMarkdown(., $guidelines.path.docs, $guidelines.path.docs.export, $relevant.path)"/>
      <xsl:sequence select="$chapter.file"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="modules" select="uri-collection($base.path || '/modules/?select=*.xml')" as="xs:string*"/>
  
  <xd:doc>
    <xd:desc>
      <xd:p>The start template</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:message select="'files: ' || count($files)"/>
    <xsl:for-each select="$files">
      <xsl:variable name="current.file" select="." as="node()"/>
      <!--<xsl:message select="'aiming at ' || $guidelines.path.docs.export || $current.file/@path"/>-->
      <xsl:variable name="html.prepped" as="node()*">
        <xsl:apply-templates select="$current.file/child::node()" mode="html2odd.prep"/>
      </xsl:variable>
      <xsl:variable name="odd.prepped" as="node()*">
        <xsl:apply-templates select="$html.prepped" mode="html2odd"/>
      </xsl:variable>
      <xsl:variable name="odd.cleaned" as="node()*">
        <xsl:apply-templates select="$odd.prepped" mode="html2odd.post"/>
      </xsl:variable>
      <xsl:result-document href="{$guidelines.path.docs.export || $current.file/@path}" indent="yes" method="xml">
        <div xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$current.file/@sectionid}" type="{$current.file/@level}">
          <head><xsl:value-of select="$current.file/@title"/></head>
          <xsl:sequence select="$odd.cleaned"/>
        </div>        
      </xsl:result-document>
    </xsl:for-each>
    
    <xsl:message select="'modules: ' || count($modules)"/>
    
    <xsl:result-document href="{$base.path || $guidelines.path || '/tools/meiGuidelines_back2odd/export/'}/mei-source-new.xml">
      <xsl:apply-templates select="node()" mode="rebuild.source">
        <xsl:with-param name="chapters" select="$files" as="node()*" tunnel="yes"/>
        <xsl:with-param name="modules" select="$modules" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
    <!--<xsl:apply-templates select="node()"/>-->
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>A simple copy template</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="node() | @*" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
    
</xsl:stylesheet>