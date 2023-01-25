<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>
  <!-- Find the root node called Menus 

and call MenuListing for its children -->
  <xsl:template match="/NewDataSet">

    <MenuItems>
      <xsl:call-template name="MenuListing" />

    </MenuItems>
  </xsl:template>


  <!-- Allow for child node processing -->

  <xsl:template name="MenuListing">
    <xsl:apply-templates select="Menu" />
  </xsl:template>


  <xsl:template match="Menu">

    <MenuItem>
      <!-- Convert Menu child elements to MenuItem attributes -->

      <xsl:attribute name="Text">
        <xsl:value-of select="MenuName"/>

      </xsl:attribute>
      <xsl:attribute name="ToolTip">

        <xsl:value-of select="Description"/>
      </xsl:attribute>    


      <!-- Call ItemListing if there are child Menu nodes -->
      <xsl:if test="count(Items) > 0">
        <xsl:call-template name="ItemListing" />
      </xsl:if>

    </MenuItem>
  </xsl:template>

  <xsl:template name="ItemListing">
    <xsl:apply-templates select="Items" />
  </xsl:template>
  <xsl:template match="Items">
    <xsl:variable name="VirtualDir">/his</xsl:variable>
    <Item>
      <!-- Convert Menu child elements to MenuItem attributes -->

      <xsl:attribute name="Text">
        <xsl:value-of select="DispName"/>
      </xsl:attribute>     

      <xsl:attribute name="NavigateUrl">
        
        <xsl:value-of select="concat($VirtualDir,URLName)"/> 
        
      </xsl:attribute>     

    </Item>
  </xsl:template>

</xsl:stylesheet>