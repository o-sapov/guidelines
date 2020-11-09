<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:func="no:link"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:ex="http://www.tei-c.org/ns/Examples"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:temp="use.xinclude"
    exclude-result-prefixes="xs math xd func tei xi temp ex"
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
        <xsl:param name="path" as="xs:string" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="@ident | @ns | @start | @xml:xi"/>
            <xsl:namespace name="xi" select="'http://www.w3.org/2001/XInclude'"/>
            <xsl:element name="xi:include">
                <xsl:attribute name="href" select="'modules/MEI.xml'"/>
            </xsl:element>
            <xsl:message select="'Path: ' || $path"/>
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
        <xsl:param name="path" as="xs:string" tunnel="yes"/>
        <xsl:copy>
            <xsl:variable name="first.level.chapters" select="$chapters/descendant-or-self::node()[@type= 'div1']" as="node()*"/>
            <xsl:for-each select="$first.level.chapters">
                <xsl:sort select="@path" data-type="text"/>
                <xsl:variable name="folder" select="replace(@path,'.xml','/')" as="xs:string"/>
                <xsl:variable name="num" select="xs:string(xs:integer(substring-before(@path,'-')))" as="xs:string"/>
            
                <xsl:element name="xi:include">
                    <xsl:attribute name="href" select="'docs/' || @path"/>
                    <xsl:attribute name="xpointer" select="@xml:id"/>
                </xsl:element>
                <!--<xsl:sequence select="func:getChildChapters($chapters, 2, @path, $folder, $num)"/>-->
                <xsl:result-document href="{$path || 'docs/' || @path}" method="xml" indent="yes">
                    <xsl:comment>
© 2017 by the Music Encoding Initiative (MEI) Council.
  Licensed under the Educational Community License, Version 2.0 (the "License"); you may
  not use this file except in compliance with the License. You may obtain a copy of the License
  at http://opensource.org/licenses/ECL-2.0.

  Unless required by applicable law or agreed to in writing, software distributed under the
  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
  OF ANY KIND, either express or implied. See the License for the specific language
  governing permissions and limitations under the License.

  This is a derivative work based on earlier versions of the schema © 2001-2006 Perry Roland
  and the Rector and Visitors of the University of Virginia; licensed under the Educational
  Community License version 1.0.

  CONTACT: info@music-encoding.org                        
                    </xsl:comment>
                    <xsl:processing-instruction name="xml-model"> href="../validation/mei_odds.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
                    <xsl:processing-instruction name="xml-model"> href="../validation/mei_odds.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
                    <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:rng="http://relaxng.org/ns/structure/1.0"
                        xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xi="http://www.w3.org/2001/XInclude"
                        version="5.0" rend="book" xml:lang="en">
                        <teiHeader>
                            <fileDesc>
                                <titleStmt>
                                    <title level="s">The Music Encoding Initiative Guidelines</title>
                                    <title level="a"><xsl:sequence select="child::tei:head/text()"/></title>
                                    <respStmt>
                                        <resp>Edited by</resp>
                                        <xsl:comment>TODO: To be filled manually</xsl:comment>                                        
                                    </respStmt>
                                    <respStmt>
                                        <resp>With contributions by</resp>
                                        <xsl:comment>TODO: To be filled automatically via GitHub API</xsl:comment>
                                    </respStmt>
                                </titleStmt>
                                <publicationStmt>
                                    <distributor>Music Encoding Initiative (MEI) Council</distributor>
                                    <availability>
                                        <p>
                                            <hi>Music Encoding Initiative (MEI)</hi>
                                        </p>
                                        <p>NOTICE: Copyright (c) 2018 by the Music Encoding Initiative (MEI) Council.</p>
                                        <p>Licensed under the Educational Community License, Version 2.0 (the "License"); you may
                                            not use this file except in compliance with the License. You may obtain a copy of the
                                            License at <ref target="http://opensource.org/licenses/ECL-2.0"
                                                >http://opensource.org/licenses/ECL-2.0</ref>.</p>
                                        <p>Unless required by applicable law or agreed to in writing, software distributed under
                                            the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
                                            KIND, either express or implied. See the License for the specific language governing
                                            permissions and limitations under the License.</p>
                                        <p>This is a derivative work based on earlier versions of the schema copyright (c)
                                            2001-2006 Perry Roland and the Rector and Visitors of the University of Virginia;
                                            licensed under the Educational Community License version 1.0.</p>
                                        <p>CONTACT: contact@music-encoding.org </p>
                                    </availability>
                                </publicationStmt>
                            </fileDesc>
                        </teiHeader>
                        <text>
                            <body>
                    <xsl:apply-templates select="." mode="#current"/>
                            </body>
                        </text>
                    </TEI>
                </xsl:result-document>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@path]" mode="rebuild.source">
        <xsl:param name="chapters" as="node()*" tunnel="yes"/>
        
        <xsl:variable name="child.type" select="'div' || xs:string(xs:integer(substring(@type,4)) + 1)" as="xs:string"/>
        <xsl:variable name="search.path" select="replace(@path,'.xml','/')" as="xs:string"/>
        <xsl:variable name="child.chapters" select="$chapters/descendant-or-self::node()[@type = $child.type and starts-with(@path, $search.path)]" as="node()*"/>
                
        <xsl:variable name="content" as="node()+">
            <xsl:copy>
                <xsl:apply-templates select="node() | @* except @path" mode="#current"/>
                
                <xsl:apply-templates select="$child.chapters" mode="#current"/>
            </xsl:copy>
        </xsl:variable>
        <xsl:apply-templates select="$content" mode="clean.source"/>
    </xsl:template>
    
    <xsl:function name="func:getChildChapters" as="node()*">
        <xsl:param name="chapters" as="node()*"/>
        <xsl:param name="level" as="xs:integer"/>
        <xsl:param name="parent.path" as="xs:string"/>
        <xsl:param name="folder" as="xs:string"/>
        <xsl:param name="num" as="xs:string"/>
        
        <xsl:variable name="search.path" select="replace($parent.path,'.xml','/')" as="xs:string"/>
        <xsl:variable name="relevant.chapters" select="$chapters/descendant-or-self::node()[(@level = 'div' || xs:string($level)) and starts-with(@path, $search.path)]" as="node()*"/>
        
        <xsl:if test="ends-with($parent.path,'cmnNotesBasic.xml')">
            <xsl:message select="'Welcome to this beautiful mess'"/>
        </xsl:if>
        
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
    
    <xsl:template match="temp:include" mode="clean.source">
        <xsl:element name="xi:include">
            <xsl:choose>
                <xsl:when test="ancestor::ex:egXML[@rend = 'code']">
                    <xsl:attribute name="href" select="'../examples/' || @href"/>
                </xsl:when>
                <xsl:when test="ancestor::ex:egXML[@rend = 'verovio code']">
                    <xsl:attribute name="href" select="'../examples/verovio/' || @href"/>
                </xsl:when>
            </xsl:choose>            
            <xsl:attribute name="parse" select="'text/plain'"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:p | tei:div | tei:availability | tei:sourceDesc" mode="rebuild.source">
        <xsl:copy>
            <xsl:apply-templates select="@ref | @xml:id | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>