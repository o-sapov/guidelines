<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:func="no:link"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs math xd func tei"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 29, 2020</xd:p>
      <xd:p><xd:b>Author:</xd:b> Johannes Kepper</xd:p>
      <xd:p>This translates HTML markup to proper ODD.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="p" mode="html2odd">
    <p xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </p>
  </xsl:template>
  
  <xsl:template match="a[.//text()]" mode="html2odd">
    <ref xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </ref>
  </xsl:template>
  
  <xsl:template match="a[not(.//text())]" mode="html2odd">
    <ptr xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </ptr>
  </xsl:template>
  
  <xsl:template match="a/@href" mode="html2odd">
    <xsl:attribute name="target" select="."/>    
  </xsl:template>
  
  <xsl:template match="a/@title" mode="html2odd"/>
  
  <xsl:template match="em" mode="html2odd">
    <hi xmlns="http://www.tei-c.org/ns/1.0" rend="italic">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </hi>
  </xsl:template>
  
  <xsl:template match="strong" mode="html2odd">
    <hi xmlns="http://www.tei-c.org/ns/1.0" rend="bold">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </hi>
  </xsl:template>
  
  <xsl:template match="text()" mode="html2odd.prep" priority="1">    
    <xsl:analyze-string select="." regex="GLOSSLIST-LABEL-(.+?)-ENDLABEL-ITEM-(.*?)-ENDITEM-ENDGLOSSLIST">
      <xsl:matching-substring>
        <list xmlns="http://www.tei-c.org/ns/1.0" type="gloss"><label><xsl:value-of select="regex-group(1)"/></label><item><xsl:value-of select="regex-group(2)"/></item></list>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:sequence select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <xsl:template match="text()" mode="html2odd" priority="1">
    <xsl:variable name="quot" as="xs:string">"</xsl:variable>
    <xsl:analyze-string select="normalize-space(.)" regex="\{{% include +(link .*?|mei .*?|desc .*?|verovio .*?|figure .*?|smufl .*?|.*?) ?%\}}" flags="s">
      <xsl:matching-substring>
        <xsl:choose>
          
          <!-- A link to something -->
          <xsl:when test="starts-with(regex-group(1), 'link')">
            <xsl:variable name="target.type" select="substring-before(substring(regex-group(1), 6),'=')" as="xs:string"/>
            
            <xsl:choose>
              <!-- reference to a guidelines chapter -->
              <xsl:when test="$target.type = 'id'">
                <xsl:variable name="target" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string"/>
                <ptr xmlns="http://www.tei-c.org/ns/1.0" target="#{$target}"/>
              </xsl:when>
              
              <!-- reference to an element -->
              <xsl:when test="$target.type = 'elem'">
                <xsl:variable name="name" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string"/>
                <gi xmlns="http://www.tei-c.org/ns/1.0" scheme="MEI"><xsl:value-of select="$name"/></gi>
              </xsl:when>
              
              <!-- reference to an attribute class -->
              <xsl:when test="$target.type = ('att', 'atts')">
                <xsl:variable name="name" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string"/>
                <xsl:variable name="full.name" select="if(starts-with($name,'att.')) then($name) else('att.'||$name)"/>
                <ident xmlns="http://www.tei-c.org/ns/1.0" type="class"><xsl:value-of select="$full.name"/></ident>                
              </xsl:when>
              
              <!-- reference to a model class -->
              <xsl:when test="$target.type = 'model'">
                <xsl:variable name="name" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string"/>
                <xsl:variable name="full.name" select="if(starts-with($name,'model.')) then($name) else('model.'||$name)"/>
                <ident xmlns="http://www.tei-c.org/ns/1.0" type="class"><xsl:value-of select="$full.name"/></ident>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message select="'ERROR: Unable to resolve target.type _' || $target.type || '_'"/>
                <xsl:message select="regex-group(1)" terminate="yes"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <!-- A description of something -->
          <xsl:when test="starts-with(regex-group(1), 'desc')">
            <xsl:variable name="target.type" select="substring-before(substring(regex-group(1), 6),'=')" as="xs:string"/>
            
            <xsl:choose>
              <xsl:when test="$target.type = 'elem'">
                <xsl:variable name="name" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string"/>
                <specList xmlns="http://www.tei-c.org/ns/1.0">
                  <specDesc key="{$name}"/>
                </specList>
              </xsl:when>
              <xsl:when test="$target.type = 'atts'">
                <xsl:variable name="atts" select="tokenize(replace(normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot)),'---',':'),' ')" as="xs:string*"/>
                <specList xmlns="http://www.tei-c.org/ns/1.0">
                  <xsl:for-each-group select="$atts" group-by="substring-before(.,'/')">
                    <xsl:variable name="current.atts" select="for $att in $atts[starts-with(.,current-grouping-key() || '/')] return substring-after($att,'/')" as="xs:string*"/>
                    <specDesc key="{current-grouping-key()}" atts="{string-join($current.atts, ' ')}"/>
                  </xsl:for-each-group>
                </specList>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message select="'ERROR: Unable to resolve target.type _' || $target.type || '_'"/>
                <xsl:message select="regex-group(1)" terminate="yes"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <!-- An image of some kind -->
          <xsl:when test="starts-with(regex-group(1), 'figure')">
            <xsl:variable name="target" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string?"/>
            <xsl:variable name="caption" select="normalize-space(substring-before(substring-after(regex-group(1),'caption='||$quot),$quot))" as="xs:string"/>
            
            <figure xmlns="http://www.tei-c.org/ns/1.0">
              <!-- figure caption -->
              <xsl:choose>
                <xsl:when test="not($caption) or $caption = ''"/>                
                <xsl:otherwise>
                  <head><xsl:value-of select="$caption"/></head>
                </xsl:otherwise>
              </xsl:choose>
              <!-- figure content -->
              <xsl:choose>
                <xsl:when test="not($target) or $target = ''">
                  <xsl:comment>TODO: This figure lacks content; please check!</xsl:comment>
                </xsl:when>
                <xsl:when test="ends-with($target, '.jpg') or ends-with($target, '.png')">
                  <graphic url="{$target}"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message select="'ERROR: Unable to resolve figure with target _' || $target || '_'" terminate="yes"/>
                </xsl:otherwise>
              </xsl:choose>
            </figure>
          </xsl:when>
          
          <!-- an MEI example file -->
          <xsl:when test="starts-with(regex-group(1), 'mei')">
            <xsl:variable name="target" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string?"/>
            <xsl:variable name="valid" select="normalize-space(substring-before(substring-after(regex-group(1),'valid='||$quot),$quot))" as="xs:string?"/>
            
            <egXML xmlns="http://www.tei-c.org/ns/Examples" rend="code" xml:space="preserve"><xsl:if test="$valid and $valid = ('true', 'false', 'feasible')"><xsl:attribute name="valid" select="$valid"/></xsl:if><include xmlns="use.xinclude" href="{$target}"/></egXML>
            
          </xsl:when>
          
          <!-- an MEI example file, which is supposed to be rendered as well (it had an option to turn off showing the XML, but that's never been used) -->
          <xsl:when test="starts-with(regex-group(1), 'verovio')">
            <xsl:variable name="target" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string?"/>
            <xsl:variable name="valid" select="normalize-space(substring-before(substring-after(regex-group(1),'valid='||$quot),$quot))" as="xs:string?"/>
            
            <egXML xmlns="http://www.tei-c.org/ns/Examples" rend="verovio code" xml:space="preserve"><include xmlns="use.xinclude" href="{$target}"/></egXML>
            
          </xsl:when>
          
          <!-- a symbol using a smufl font -->
          <xsl:when test="starts-with(regex-group(1), 'smufl')">
            <xsl:variable name="code" select="normalize-space(substring-before(substring-after(regex-group(1),$quot),$quot))" as="xs:string?"/>
            
            <graphic xmlns="http://www.tei-c.org/ns/1.0" rend="smufl" url="https://edirom.de/smufl-browser/{$code}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message select="'ERROR: Unable to parse the following inclusion: ' || regex-group(1)" terminate="yes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    
  </xsl:template>
  
  <xsl:template match="tei:list[@type='gloss']" mode="html2odd.post">
    <xsl:variable name="list" select="." as="node()"/>
    <xsl:variable name="prec.1" select="preceding-sibling::tei:*[1]" as="node()?"/>
    <xsl:variable name="foll.1" select="func:getFollowingGlossLists($list)" as="node()*"/>
    <xsl:choose>
      <xsl:when test="exists($prec.1) and local-name($prec.1) = 'list' and $prec.1/@type = 'gloss'"/>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*" mode="#current"/>
          <xsl:apply-templates select="node() | $foll.1/child::node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="func:getFollowingGlossLists" as="node()*">
    <xsl:param name="elem" as="node()"/>
    <xsl:variable name="foll.1" select="$elem/following-sibling::tei:*[1]" as="node()?"/>
    <xsl:if test="exists($foll.1) and local-name($foll.1) = 'list' and $foll.1/@type = 'gloss'">
      <xsl:sequence select="$foll.1"/>
      <xsl:sequence select="func:getFollowingGlossLists($foll.1)"/>
    </xsl:if>
  </xsl:function>
  
</xsl:stylesheet>