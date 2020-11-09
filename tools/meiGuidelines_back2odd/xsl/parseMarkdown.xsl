<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:func="no:link"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
  xmlns:err="http://www.w3.org/2005/xqt-errors" 
  exclude-result-prefixes="xs math xd func md2doc tei err"
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
    
    <xsl:variable name="tei" select="func:kramdown2tei($content.lines, $sectionid)" as="node()*"/>
    
    <xsl:variable name="level" select="'div' || string(count(tokenize($file.path,'/')))" as="xs:string"/>
    
    <xsl:variable name="blank.filename" select="substring($file.path,1,string-length($file.path) - 3)" as="xs:string"/>
    <!--<xsl:message select="'Exporting ' || $blank.filename || ' to ' || $export.path"/>-->
    <file path="{$blank.filename || '.xml'}" title="{$title}" sectionid="{$sectionid}" level="{$level}">
      <!--<xsl:sequence select="$html"/>-->
      <xsl:sequence select="$tei"/>
    </file>    
    
    <xsl:if test="$sectionid = 'cmnBasics'">
      <xsl:message select="'resolving cmnBasics'"/>
    </xsl:if>

    <!-- enter recursion for sub-chapters -->
    <xsl:try>
      <xsl:for-each select="uri-collection($docs.path || $blank.filename || '/' || '?select=*.md')">
        <xsl:sort select="tokenize(.,'/')[last()]" data-type="text"/>
        <xsl:variable name="relevant.path" select="substring-after(., $docs.path)" as="xs:string"/>
        <xsl:if test="not(ends-with($relevant.path,'/')) and unparsed-text-available(.)">
          <xsl:variable name="chapter.file" select="func:parseMarkdown(., $docs.path, $export.path, $relevant.path)"/>
          <xsl:sequence select="$chapter.file"/>  
        </xsl:if>
      </xsl:for-each>
      <xsl:catch errors="*">
        <xsl:if test="contains($err:description, 'cmnNotesBasic')">
          <xsl:message select="'ERROR: ' || $err:description"/>
        </xsl:if>
        <!--<xsl:message select="'No folder for ' || $docs.path || $blank.filename || '/ : ' || $err:description"/>-->        
      </xsl:catch>
    </xsl:try>
    
  </xsl:function>
  
  <xsl:function name="func:kramdown2tei" as="node()*">
    <xsl:param name="raw.lines" as="xs:string*"/>
    <xsl:param name="sectionid" as="xs:string"/>
    
    <!-- remove duplicate empty lines -->
    <xsl:variable name="cleaned.lines" as="xs:string*">
      <xsl:for-each select="$raw.lines">
        <xsl:variable name="pos" select="position()" as="xs:integer"/>
        <xsl:variable name="current.line" select="." as="xs:string"/>
        <xsl:variable name="is.blank.line" select="func:is.blank.line($current.line)" as="xs:boolean"/>
        <xsl:variable name="preceded.by.blank.line" select="$pos gt 1 and func:is.blank.line($raw.lines[$pos - 1])" as="xs:boolean"/>
        <xsl:if test="not($is.blank.line and $preceded.by.blank.line)">
          <xsl:sequence select="$current.line"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <!-- remove empty lines between gloss entries and specLists -->
    <xsl:variable name="cleaned.list.lines" as="xs:string*">
      <xsl:for-each select="$cleaned.lines">
        <xsl:variable name="pos" select="position()" as="xs:integer"/>
        <xsl:variable name="current.line" select="." as="xs:string"/>
        <xsl:variable name="is.blank.line" select="func:is.blank.line($current.line)" as="xs:boolean"/>
        
        <xsl:variable name="two.ahead.is.gloss" select="$pos gt 2 and func:is.gloss.marker($cleaned.lines[$pos - 2])" as="xs:boolean"/>
        <xsl:variable name="one.ahead.is.valid" select="starts-with(normalize-space($cleaned.lines[$pos - 1]), '**')" as="xs:boolean"/>
        <xsl:variable name="following.is.gloss" select="count($cleaned.lines) gt $pos and func:is.gloss.marker($cleaned.lines[$pos + 1])" as="xs:boolean"/>
        
        <xsl:variable name="one.ahead.is.include.desc" select="$pos gt 1 and func:is.include.desc.line($cleaned.lines[$pos - 1])" as="xs:boolean"/>
        <xsl:variable name="following.is.include.desc" select="count($cleaned.lines) gt $pos and func:is.include.desc.line($cleaned.lines[$pos + 1])" as="xs:boolean"/>
        
        <xsl:if test="not($is.blank.line and $two.ahead.is.gloss and $one.ahead.is.valid and $following.is.gloss) and not($is.blank.line and $one.ahead.is.include.desc and $following.is.include.desc)">
          <xsl:sequence select="$current.line"/>
        </xsl:if>    
      </xsl:for-each>
    </xsl:variable>
  
    <!-- group lines to blocks -->
    <xsl:variable name="raw.blocks" as="node()*">
      <xsl:for-each-group select="$cleaned.list.lines" group-starting-with=".[func:is.blank.line(.)]">
        <block>
          <xsl:for-each select="current-group()">
            <line><xsl:value-of select="."/></line>
          </xsl:for-each>
        </block>
      </xsl:for-each-group>  
    </xsl:variable>
    
    <!-- convert blocks to proper TEI elements -->
    <xsl:variable name="converted.blocks" as="node()*">
      <xsl:for-each select="$raw.blocks">
        <xsl:variable name="current.block" select="." as="node()"/>
        
        <xsl:choose>
          <!-- nothing to look at -->
          <xsl:when test="count($current.block/line) = 0 or (every $line in $current.block/line satisfies func:is.blank.line($line))"/>            
                    
          <!-- glossList -->
          <xsl:when test="func:is.gloss.marker($current.block/line[2])">
            <list xmlns="http://www.tei-c.org/ns/1.0" type="gloss">
              <xsl:for-each select="$current.block/line[position() gt 1 and not(func:is.gloss.marker(.))]">
                <xsl:analyze-string select="normalize-space(text())" regex="^\*\*(.*?)\*\*:" flags="s">
                  <xsl:matching-substring>
                    <label><xsl:value-of select="regex-group(1)"/></label>
                  </xsl:matching-substring>
                  <xsl:non-matching-substring>
                    <item><xsl:value-of select="."/></item>
                  </xsl:non-matching-substring>
                </xsl:analyze-string>
              </xsl:for-each>
            </list>
          </xsl:when>
          
          <!-- unordered lists -->
          <xsl:when test="func:is.unordered.list.entry($current.block/line[2])">
            <list xmlns="http://www.tei-c.org/ns/1.0" rend="bulleted">
              <xsl:for-each select="$current.block/line[position() ge 2]">
                <item><xsl:value-of select="substring(normalize-space(text()), 3)"/></item>
              </xsl:for-each>
            </list>
          </xsl:when>
          
          <!-- ordered lists -->
          <xsl:when test="func:is.ordered.list($current.block/line[2], $current.block/line[3])">
            <list xmlns="http://www.tei-c.org/ns/1.0" rend="numbered">
              <xsl:for-each select="$current.block/line[position() ge 2]">
                <item><xsl:value-of select="replace(normalize-space(text()), '^\d+\. ','')"/></item>
              </xsl:for-each>
            </list>
          </xsl:when>
          
          <!-- specLists -->
          <xsl:when test="every $line in $current.block/line[position() ge 2] satisfies func:is.include.desc.line($line)">
            <xsl:variable name="quot" as="xs:string">"</xsl:variable>
            <p xmlns="http://www.tei-c.org/ns/1.0">
              <specList>
                <xsl:for-each select="$current.block/line[position() ge 2]">
                  <xsl:variable name="current.line" select="normalize-space(text())" as="xs:string"/>
                  <xsl:variable name="target" select="substring-before(substring-after($current.line,'=' || $quot),$quot)" as="xs:string"/>
                  <xsl:variable name="target.type" select="substring-before(substring($current.line,17),'=')" as="xs:string"/>
                  
                  <xsl:choose>
                    <xsl:when test="$target.type = 'elem'">
                      <specDesc key="{$target}"/>
                    </xsl:when>
                    <xsl:when test="$target.type = 'atts'">
                      <xsl:variable name="atts" select="tokenize(replace($target,'---',':'),' ')" as="xs:string*"/>
                      
                      <xsl:for-each-group select="$atts" group-by="substring-before(.,'/')">
                        <xsl:variable name="current.atts" select="for $att in $atts[starts-with(.,current-grouping-key() || '/')] return substring-after($att,'/')" as="xs:string*"/>
                        <specDesc key="{current-grouping-key()}" atts="{string-join($current.atts, ' ')}"/>
                      </xsl:for-each-group>
                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:message select="'ERROR: Unable to resolve target.type _' || $target.type || '_'"/>
                      <xsl:message select="regex-group(1)" terminate="yes"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </specList>
            </p>              
          </xsl:when>
          
          <!-- tables -->
          <xsl:when test="every $line in $current.block/line[position() ge 2] satisfies func:is.table.line($line)">
            <table xmlns="http://www.tei-c.org/ns/1.0">
              <xsl:for-each select="$current.block/line[position() ge 2]/text()">
                <row>
                  <xsl:variable name="current.line" select="normalize-space(.)" as="xs:string"/>
                  <xsl:variable name="cols" select="tokenize(substring($current.line,2,string-length($current.line) -2),'\|')" as="xs:string*"/>
                  <xsl:for-each select="$cols">
                    <cell><xsl:value-of select="."/></cell>
                  </xsl:for-each>
                </row>
              </xsl:for-each>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <p xmlns="http://www.tei-c.org/ns/1.0">
              <xsl:value-of select="normalize-space(string-join($current.block/line[position() ge 2]/text(), ' '))"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="counts" as="xs:string*">
      <xsl:value-of select="'gloss:' || count($converted.blocks/descendant-or-self::tei:list[@type = 'gloss'])"/>
      <xsl:value-of select="'ul:' || count($converted.blocks/descendant-or-self::tei:list[@rend = 'bulleted'])"/>
      <xsl:value-of select="'ol:' || count($converted.blocks/descendant-or-self::tei:list[@rend = 'numbered'])"/>
      <xsl:value-of select="'specList:' || count($converted.blocks/descendant-or-self::tei:specList)"/>
      <xsl:value-of select="'table:' || count($converted.blocks/descendant-or-self::tei:table)"/>
      <xsl:value-of select="'p:' || count($converted.blocks/descendant-or-self::tei:p)"/>
    </xsl:variable>
    
    <!-- DEBUG: The following will print the number of blocks for each chapter -->
    <!--<xsl:message select="$sectionid || ': ' || string-join($counts,' / ')"/>-->
    <!--<xsl:message select="$converted.blocks/descendant-or-self::tei:p"/>-->    
    <xsl:sequence select="$converted.blocks"/>
  </xsl:function>
  
  <xsl:function name="func:is.blank.line" as="xs:boolean">
    <xsl:param name="line" as="xs:string"/>
    <xsl:sequence select="normalize-space($line) = ('', ' ')"/>
  </xsl:function>
  
  <xsl:function name="func:is.gloss.marker" as="xs:boolean">
    <xsl:param name="line" as="xs:string"/>
    <xsl:sequence select="normalize-space($line) = '{:.gloss}'"/>
  </xsl:function>
  
  <xsl:function name="func:is.unordered.list.entry" as="xs:boolean">
    <xsl:param name="line" as="xs:string"/>
    <xsl:sequence select="starts-with(normalize-space($line), '- ')"/>
  </xsl:function>
  
  <xsl:function name="func:is.ordered.list" as="xs:boolean">
    <xsl:param name="first.line" as="xs:string"/>
    <xsl:param name="second.line" as="xs:string"/>
    <xsl:sequence select="starts-with(normalize-space($first.line), '1.') and starts-with(normalize-space($second.line), '2.')"/>
  </xsl:function>
  
  <xsl:function name="func:is.include.desc.line" as="xs:boolean">
    <xsl:param name="line" as="xs:string"/>
    <xsl:sequence select="starts-with(normalize-space($line), '{% include desc ')"/>
  </xsl:function>
  
  <xsl:function name="func:is.table.line" as="xs:boolean">
    <xsl:param name="line" as="xs:string"/>
    <xsl:sequence select="starts-with(normalize-space($line), '|') and ends-with(normalize-space($line), '|')"/>
  </xsl:function>
  
</xsl:stylesheet>