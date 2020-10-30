<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:func="no:link"
  xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
  exclude-result-prefixes="xs math xd func md2doc"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 23, 2020</xd:p>
      <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
      <xd:p>This translates Markdown documents to XML.</xd:p>
    </xd:desc>
  </xd:doc>
  
  
  <xd:doc>
    <xd:desc>
      <xd:p>A function that parses a Markdown file to simple XML</xd:p>
    </xd:desc>
    <xd:param name="path"></xd:param>
    <xd:return></xd:return>
  </xd:doc>
  <xsl:function name="func:parseMarkdown" as="node()*">
    <xsl:param name="path" as="xs:string"/>
    <xsl:param name="docs.path" as="xs:string"/>
    <xsl:param name="export.path" as="xs:string"/>
    <xsl:param name="file.path" as="xs:string"/>
    
    <xsl:variable name="raw.file.lines" select="unparsed-text-lines($path)" as="xs:string+"/>
    <xsl:variable name="separator.pos" select="index-of($raw.file.lines,'---')" as="xs:integer+"/>
    <xsl:variable name="front.matter" select="$raw.file.lines[position() gt $separator.pos[1] and position() lt $separator.pos[2]]" as="xs:string+"/>
    <xsl:variable name="apos" as="xs:string">'</xsl:variable>
    <xsl:variable name="quot" as="xs:string">"</xsl:variable>
    <xsl:variable name="title" select="replace(normalize-space(substring-after($front.matter[starts-with(.,'title:')],'title:')),$quot,'')" as="xs:string"/>
    <xsl:variable name="sectionid" select="replace(normalize-space(substring-after($front.matter[starts-with(.,'sectionid:')],'sectionid:')),$quot,'')" as="xs:string"/>
    <xsl:variable name="content.lines" select="$raw.file.lines[position() gt $separator.pos[2]]" as="xs:string*"/>
    
    <xsl:variable name="html" select="md2doc:get-html(string-join($content.lines,' '))" as="node()*"/>
    
    <xsl:variable name="blank.filename" select="substring($file.path,1,string-length($file.path) - 3)" as="xs:string"/>
    <!--<xsl:message select="'Exporting ' || $blank.filename || ' to ' || $export.path"/>-->
    <file path="{$blank.filename || '.xml'}">
      <xsl:sequence select="$html"/>  
    </file>    
        
    <!-- enter recursion for sub-chapters -->
    <xsl:try>
      <xsl:for-each select="uri-collection($docs.path || $blank.filename || '/' || '?select=*.md')">
        <xsl:variable name="relevant.path" select="substring-after(., $docs.path)" as="xs:string"/>
        <xsl:variable name="chapter.file" select="func:parseMarkdown(., $docs.path, $export.path, $relevant.path)"/>
        <xsl:sequence select="$chapter.file"/>
      </xsl:for-each>
      <xsl:catch>
        <!--<xsl:message select="'No folder for ' || $docs.path || $blank.filename || '/'"/>-->
      </xsl:catch>
    </xsl:try>
    
  </xsl:function>
  
</xsl:stylesheet>