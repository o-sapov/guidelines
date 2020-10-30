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
                <ptr xmlns="http://www.tei-c.org/ns/1.0" target="{$target}"/>
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
            
            <xsl:message select="'_' || $target || '_: ' || $caption"/>
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
          
          <xsl:when test="starts-with(regex-group(1), 'mei')">
            
          </xsl:when>
          <xsl:when test="starts-with(regex-group(1), 'verovio')">
            
          </xsl:when>
          
          <xsl:when test="starts-with(regex-group(1), 'smufl')">
            
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
  
</xsl:stylesheet>