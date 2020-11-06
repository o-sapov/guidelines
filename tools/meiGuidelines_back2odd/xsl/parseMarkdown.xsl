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
    
    <xsl:variable name="marked.glosses" select="func:markGlosses($content.lines)" as="xs:string*"/>
    
    <xsl:variable name="html" select="md2doc:get-html(string-join($marked.glosses,' '))" as="node()*"/>
    <xsl:variable name="level" select="'div' || string(count(tokenize($file.path,'/')))" as="xs:string"/>
    <!--<xsl:if test="$sectionid = 'cmnOrnamentsMordents'">
      <xsl:message select="$marked.glosses"></xsl:message>
      <xsl:message select="$html"/>
      <xsl:message select="$file.path"/>
      <xsl:message select="$path"/>
    </xsl:if>-->
    
    <xsl:variable name="blank.filename" select="substring($file.path,1,string-length($file.path) - 3)" as="xs:string"/>
    <!--<xsl:message select="'Exporting ' || $blank.filename || ' to ' || $export.path"/>-->
    <file path="{$blank.filename || '.xml'}" title="{$title}" sectionid="{$sectionid}" level="{$level}">
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
  
  <xsl:function name="func:markGlosses" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    
    <xsl:variable name="output">
      
      <xsl:for-each select="$lines">
        <xsl:variable name="current.line" select="." as="xs:string"/>
        <xsl:variable name="pos" select="position()" as="xs:integer"/>
        <xsl:variable name="prev.line" select="$lines[$pos - 1]" as="xs:string?"/>
        <xsl:variable name="next.line" select="$lines[$pos + 1]" as="xs:string?"/>
        <xsl:choose>
          <xsl:when test="contains($current.line, '{:.gloss}')"/>
          <xsl:when test="$current.line = '' and $lines[$pos - 2] and contains($lines[$pos - 2], '{:.gloss}') and $next.line and contains($next.line, '{:.gloss}')">
            <!--<xsl:if test="some $line in $lines satisfies starts-with($line, 'A mordent is an ornament that involves')"><xsl:message select="'should be skipping a line here…'"/></xsl:if>-->
          </xsl:when>
          <xsl:when test="$prev.line and contains($prev.line, '{:.gloss}')">
            <xsl:variable name="label" select="if(contains($current.line,':')) then(replace(substring-before($current.line,':'),'\*','')) else($current.line)" as="xs:string?"/>
            <xsl:variable name="item" select="if(contains($current.line,':')) then(substring-after($current.line,':')) else()" as="xs:string?"/>
            <!--<xsl:message select="'GLOSS: _' || $label || '_ – _' || $item || '_'"/>-->
            <xsl:if test="$label">GLOSSLIST-LABEL-<xsl:value-of select="$label"/>-ENDLABEL-ITEM-<xsl:value-of select="$item"/>-ENDITEM-ENDGLOSSLIST</xsl:if>
          </xsl:when>
          <!-- resolve other lists -->
          <xsl:when test="starts-with($current.line,'- ')">
            REGULARLIST-<xsl:value-of select="$current.line"/>-ENDREGULARLIST
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$current.line"/>
          </xsl:otherwise>
        </xsl:choose>  
      </xsl:for-each>
      
      <!--<xsl:for-each select="$input">
        <xsl:analyze-string  select="." regex="\{{:.gloss\}}\n(.*?)\n" flags="s">
          <xsl:matching-substring>
            <xsl:message select="'I have found something…'"></xsl:message>
            <xsl:choose>
              <!-\- there is no content for the gloss -\->
              <xsl:when test="string-length(regex-group(1)) = 0"/>
              
              <!-\- the gloss has no description -\->
              <xsl:when test="not(contains(regex-group(1),':'))">
                <xsl:message select="'case 1: ' || regex-group(1)"></xsl:message>
                GLOSSLIST-LABEL-<xsl:sequence select="substring-before(regex-group(1),':')"/>-ENDLABEL-EMPTYITEM-ENDGLOSSLIST
              </xsl:when>
              <xsl:otherwise>
                <xsl:message select="'case 2: ' || regex-group(1)"></xsl:message>
                GLOSSLIST-LABEL-<xsl:sequence select="substring-before(regex-group(1),':')"/>-ENDLABEL-ITEM-<xsl:sequence select="substring-after(regex-group(1),':')"/>-ENDITEM-ENDGLOSSLIST              
              </xsl:otherwise>
            </xsl:choose>
          </xsl:matching-substring>
          <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:for-each>-->
      
    </xsl:variable>
    <xsl:sequence select="$output"/>
  </xsl:function>
  
</xsl:stylesheet>