<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:mei="http://www.music-encoding.org/ns/mei"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:ex="http://www.tei-c.org/ns/Examples"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:func="no:link"  
  xmlns:file="http://expath.org/ns/file"
  xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
  exclude-result-prefixes="xs math xd mei rng sch func md2doc file ex" 
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
  <xsl:variable name="guidelines.path.includes" select="$base.path || $guidelines.path || '_includes/' || $guidelines.version || '/examples/'" as="xs:string"/>
  <xsl:variable name="guidelines.path.images" select="$base.path || $guidelines.path || 'images/' || $guidelines.version || '/'" as="xs:string"/>
  
  <xsl:variable name="guidelines.path.docs.export" select="$base.path || $guidelines.path || '/tools/meiGuidelines_back2odd/export/' || $guidelines.version || '/'" as="xs:string"/>
  <xsl:variable name="export.path" select="$base.path || $guidelines.path || '/tools/meiGuidelines_back2odd/export/'" as="xs:string"/>
  
  <xsl:variable name="files" as="node()*">
    <xsl:for-each select="uri-collection($guidelines.path.docs || '?select=*.md')">
      <xsl:variable name="relevant.path" select="substring-after(., $guidelines.path.docs)" as="xs:string"/>
      <xsl:variable name="chapter.file" select="func:parseMarkdown(., $guidelines.path.docs, $guidelines.path.docs.export, $relevant.path)"/>
      <xsl:sequence select="$chapter.file"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="modules" select="uri-collection($base.path || '/modules/?select=*.xml;recurse=yes')" as="xs:string*"/>
  <xsl:variable name="modules.files" select="collection($base.path || '/modules/?select=*.xml;recurse=yes')" as="node()*"/>
  
  <xd:doc>
    <xd:desc>
      <xd:p>The start template</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <xsl:message select="'files: ' || count($files)"/>
    <xsl:variable name="converted.files" as="node()*">
      <xsl:for-each select="$files">
        <xsl:variable name="current.file" select="." as="node()"/>
        <!--<xsl:message select="'aiming at ' || $guidelines.path.docs.export || $current.file/@path"/>-->
        <xsl:variable name="html.prepped" as="node()*">
          <xsl:apply-templates select="$current.file/child::node()" mode="html2odd.prep">
            <xsl:with-param name="chapters" select="$files//@sectionid" as="xs:string*" tunnel="yes"/>
            <xsl:with-param name="modules" select="$modules.files" as="node()*" tunnel="yes"/>
            <xsl:with-param name="export.path" select="$export.path" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="examples.path" select="$guidelines.path.includes" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="images.path" select="$guidelines.path.images" as="xs:string" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="odd.prepped" as="node()*">
          <xsl:apply-templates select="$html.prepped" mode="html2odd">
            <xsl:with-param name="chapters" select="$files//@sectionid" as="xs:string*" tunnel="yes"/>
            <xsl:with-param name="modules" select="$modules.files" as="node()*" tunnel="yes"/>
            <xsl:with-param name="export.path" select="$export.path" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="examples.path" select="$guidelines.path.includes" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="images.path" select="$guidelines.path.images" as="xs:string" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="odd.cleaned" as="node()*">
          <xsl:apply-templates select="$odd.prepped" mode="html2odd.post">
            <xsl:with-param name="export.path" select="$export.path" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="examples.path" select="$guidelines.path.includes" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="images.path" select="$guidelines.path.images" as="xs:string" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:variable>
        <!--<xsl:result-document href="{$guidelines.path.docs.export || $current.file/@path}" indent="yes" method="xml">-->
        <div xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$current.file/@sectionid}" type="{$current.file/@level}" path="{$current.file/@path}">
          <head><xsl:value-of select="$current.file/@title"/></head>
          <xsl:sequence select="$odd.cleaned"/>
        </div>        
        <!--</xsl:result-document>-->
      </xsl:for-each>
    </xsl:variable>
    
    <!-- copy example files -->
    <xsl:for-each select="distinct-values($converted.files//*:egXML//@href)">
      <xsl:variable name="target" select="." as="xs:string"/>
      <xsl:variable name="doc.available" select="doc-available($guidelines.path.includes || $target)" as="xs:boolean"/>
      <xsl:variable name="text.available" select="unparsed-text-available($guidelines.path.includes || $target)" as="xs:boolean"/>
      <xsl:variable name="xml.doc.available" select="doc-available($guidelines.path.includes || replace($target,'.txt','.xml'))" as="xs:boolean"/>
      <xsl:variable name="xml.text.available" select="unparsed-text-available($guidelines.path.includes || replace($target,'.txt','.xml'))" as="xs:boolean"/>
      <xsl:variable name="href" select="$export.path || 'examples/' || $target"/>
      <xsl:choose>
        <xsl:when test="$doc.available">
          <xsl:result-document href="{$href}">
            <xsl:sequence select="doc($guidelines.path.includes || $target)"/>
          </xsl:result-document>
        </xsl:when>
        <xsl:when test="$text.available">
          <xsl:result-document href="{$href}" method="html">
            <xsl:sequence select="unparsed-text($guidelines.path.includes || $target, 'UTF-8')" />
          </xsl:result-document>
        </xsl:when>
        <xsl:when test="$xml.doc.available">
          <xsl:result-document href="{$href}">
            <xsl:sequence select="doc($guidelines.path.includes || replace($target,'.txt','.xml'))"/>
          </xsl:result-document>
        </xsl:when>
        <xsl:when test="$xml.text.available">
          <xsl:result-document href="{$href}" method="text">
            <xsl:sequence select="unparsed-text($guidelines.path.includes || replace($target,'.txt','.xml'), 'UTF-8')"/>
          </xsl:result-document>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="is.verovio.example" select="exists($converted.files//*:egXML[.//@href = $target and @rend = 'verovio code'])" as="xs:boolean"/>
          <xsl:variable name="code.available" select="doc-available($guidelines.path.includes || '../../../mei/dev/' || $target)" as="xs:boolean"/>
          <xsl:if test="$is.verovio.example and $code.available">
            <xsl:variable name="verovio.href" select="$export.path || 'examples/verovio/' || $target"/>
            <xsl:result-document href="{$verovio.href}">
              <xsl:sequence select="doc($guidelines.path.includes || '../../../mei/dev/' || $target)"/>
            </xsl:result-document>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    
    <!-- control image files -->
    <xsl:variable name="used.images" select="distinct-values($converted.files//*:graphic/@url)" as="xs:string*"/>
    <xsl:variable name="available.images" as="xs:string*">
      <xsl:sequence select="uri-collection($guidelines.path.images || '?select=*.png;recurse=yes')"/>
      <xsl:sequence select="uri-collection($guidelines.path.images || '?select=*.jpg;recurse=yes')"/>
      <xsl:sequence select="uri-collection($guidelines.path.images || '?select=*.gif;recurse=yes')"/>
      <xsl:sequence select="uri-collection($guidelines.path.images || '?select=*.bmp;recurse=yes')"/>
    </xsl:variable>
    <xsl:message select="'Images: ' || count($used.images) || ' used, ' || (count(distinct-values($available.images)) - count($used.images)) || ' unused'"/>
    <xsl:result-document href="{$export.path}unusedImages.txt" method="text">
      <xsl:for-each select="distinct-values($available.images)">
        <xsl:sort select="." data-type="text"/>
        <xsl:if test="not(substring-after(.,'guidelines/images/dev/') = $used.images)">
          <xsl:value-of select="substring-after(.,'guidelines/images/dev/') || '&#10;'"/>  
        </xsl:if>
      </xsl:for-each>
    </xsl:result-document>
    <xsl:result-document href="{$export.path}usedImages.txt" method="text">
      <xsl:for-each select="distinct-values($used.images)[not(starts-with(.,'https://'))]">
        <xsl:sort select="." data-type="text"/>
        <xsl:value-of select=". || '&#10;'"/>        
      </xsl:for-each>
    </xsl:result-document>
    <!-- try to copy images -->
    <xsl:for-each select="distinct-values($used.images)[not(starts-with(.,'https://'))]">
      <xsl:variable name="target" select="." as="xs:string"/>
      <xsl:variable name="source.path" select="$guidelines.path.images || $target" as="xs:string"/>
      <xsl:sequence select="file:copy($source.path, $export.path || 'images/' || .)"/>
       <!-- 
        file:copy($source as xs:string,
          $target as xs:string)
       -->
    </xsl:for-each>
    <!--<xsl:variable name="image.available" select="file:exists(file:new('../../guidelines/images/dev/' || $target))" as="xs:boolean"/>-->
    
    <xsl:message select="'modules: ' || count($modules)"/>
    <xsl:for-each select="$modules.files">
      <xsl:variable name="filename" select="substring-after(.//tei:specGrp/@xml:id,'module.')" as="xs:string"/>
      <xsl:result-document href="{$export.path}/modules/{$filename}.xml">
        <xsl:sequence select="."/>
      </xsl:result-document>
    </xsl:for-each>
    
    <xsl:result-document href="{$export.path}/mei-source.xml">
      <xsl:apply-templates select="node()" mode="rebuild.source">
        <xsl:with-param name="chapters" select="$converted.files" as="node()*" tunnel="yes"/>
        <xsl:with-param name="modules" select="$modules" as="xs:string*" tunnel="yes"/>
        <xsl:with-param name="path" select="$export.path" as="xs:string" tunnel="yes"/>
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