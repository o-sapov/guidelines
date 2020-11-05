<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:func="no:link"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs math xd func tei xi"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 29, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
            <xd:p>This re-generates the mei-source.xml file, with proper XIncludes.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="tei:schemaSpec" mode="rebuild.source">
        <xsl:param name="modules" as="xs:string*" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@ident | @ns | @start | @xml:xi"/>
            <xsl:namespace name="xi" select="'http://www.w3.org/2001/XInclude'"/>
            <xsl:element name="xi:include">
                <xsl:attribute name="href" select="'modules/MEI.xml'"/>
            </xsl:element>
            <xsl:for-each select="$modules[not(ends-with(.,'MEI.xml'))]">
                <xsl:sort select="." data-type="text"/>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href" select="'modules/' || tokenize(.,'/')[last()]"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body" mode="rebuild.source">
        <xsl:param name="chapters" as="node()*" tunnel="yes"/>
        <xsl:copy>
            <xsl:variable name="first.level.chapters" select="$chapters/descendant-or-self::node()[@level= 'div1']" as="node()*"/>
            <xsl:for-each select="$first.level.chapters">
                <xsl:sort select="@path" data-type="text"/>
                <xsl:variable name="folder" select="replace(@path,'.xml','/')" as="xs:string"/>
                <xsl:variable name="num" select="xs:string(xs:integer(substring-before(@path,'-')))" as="xs:string"/>
                <div xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@sectionid}" n="{$num}" type="div1">
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href" select="'docs/' || @path"/>
                    </xsl:element>
                    <xsl:sequence select="func:getChildChapters($chapters, 2, @path, $folder, $num)"/>
                </div>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="func:getChildChapters" as="node()*">
        <xsl:param name="chapters" as="node()*"/>
        <xsl:param name="level" as="xs:integer"/>
        <xsl:param name="parent.path" as="xs:string"/>
        <xsl:param name="folder" as="xs:string"/>
        <xsl:param name="num" as="xs:string"/>
        
        <xsl:variable name="search.path" select="replace($parent.path,'.xml','/')" as="xs:string"/>
        <xsl:variable name="relevant.chapters" select="$chapters/descendant-or-self::node()[(@level = 'div' || xs:string($level)) and starts-with(@path, $search.path)]" as="node()*"/>
        
        <xsl:for-each select="$relevant.chapters">
            <xsl:sort select="@path" data-type="text"/>
            <xsl:variable name="new.num" select="$num || '.' || xs:string(xs:integer(substring-before(substring-after(@path,$search.path),'-')))" as="xs:string"/>
            <div xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@sectionid}" n="{$new.num}" type="div{xs:string($level)}">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href" select="'docs/' || $folder || @sectionid || '.xml'"/>
                </xsl:element>
                <xsl:sequence select="func:getChildChapters($chapters, $level + 1, @path, $folder, $new.num)"/>
            </div>
        </xsl:for-each>
    </xsl:function>
    
    <!-- avoid strange things in Oxygen-->
    <xsl:template match="tei:name" mode="rebuild.source">
        <xsl:copy>
            <xsl:apply-templates select="@ref | @xml:id | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:p | tei:div | tei:availability | tei:sourceDesc" mode="rebuild.source">
        <xsl:copy>
            <xsl:apply-templates select="@ref | @xml:id | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>