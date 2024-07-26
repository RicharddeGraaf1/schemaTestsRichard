<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>

  <sch:p>Versie @@@VSOPVERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor consolidatie-informatie</sch:p>

  <sch:pattern id="sch_data_012" see="data:BeoogdeRegeling">
    <sch:title>data:instrumentVersie moet expressionID (AKN/act) zijn</sch:title>
    <sch:rule context="data:BeoogdeRegeling">
      <sch:p>data:instrumentVersie moet expressionID (AKN/act) zijn</sch:p>
      <sch:let name="instrument" value="concat(data:instrument/string(), data:instrumentVersie/string())"/>
      <sch:assert id="STOP1026" role="error" test="matches($instrument, '^/akn/(nl|aw|cw|sx)/act')">
        {"code": "STOP1026",
		     "ID": "<sch:value-of select="$instrument"/>"}		     
	  </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_013" see="data:BeoogdInformatieobject">
    <sch:title>data:instrumentVersie moet JOIN/regdata zijn</sch:title>
    <sch:rule context="data:BeoogdInformatieobject">
      <sch:p>data:instrumentVersie moet JOIN/regdata zijn</sch:p>
      <sch:let name="instrument" value="concat(data:instrument/string(), data:instrumentVersie/string())"/>
      <sch:assert id="STOP1027" role="error" test="matches($instrument, '^/join/id/regdata/') or matches($instrument, '^/join/id/pubdata/')">
        {"code": "STOP1027",
		     "ID": "<sch:value-of select="$instrument"/>"}		     
	  </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_014" see="data:BeoogdInformatieobject">
    <sch:title>data:Intrekking/data:instrument moet een Work-Id ('/AKN/act/...' of
      '/join/id/regdata/...') hebben</sch:title>
    <sch:rule context="data:Intrekking">
      <sch:p>Het instrument binnen een Intrekking moet een akn of join identificatie hebben
        ('/AKN/act/[...]' of '/join/id/regdata/[...]')</sch:p>
      <sch:assert id="STOP1028" role="error" test="matches(./data:instrument/string(), '^/akn/(nl|aw|cw|sx)/act|^/join/id/regdata/')">
        {"code": "STOP1028",
		 "ID": "<sch:value-of select="./data:instrument/string()"/>"}		     
	  </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_data_015" see="data:doel data:Tijdstempel">
    <sch:title>Een doel kan maar 1 datum juridischWerkendVanaf hebben</sch:title>
    <sch:rule context="data:Tijdstempels">
      <sch:p>Een doel kan maar 1 datum juridischWerkendVanaf hebben</sch:p>
      <sch:let name="Dubbel">
        <xsl:for-each select="data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'juridischWerkendVanaf')]">
          <xsl:sort select="data:doel"/>
          <xsl:if test="preceding::data:doel[1] = .">
            <dubbel><xsl:value-of select="."/></dubbel>
          </xsl:if> 
        </xsl:for-each>
      </sch:let>
      <sch:let name="melding">
        <xsl:for-each select="$Dubbel/dubbel">
          <xsl:value-of select="."/>
          <xsl:if test="not(position()=last())">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </sch:let>      
      <sch:assert id="STOP1077" role="error" test="count(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'juridischWerkendVanaf')]) = count(distinct-values(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'juridischWerkendVanaf')]))">
        {"code": "STOP1077",
         "Dubbel": "<sch:value-of select="$melding"/>"
        }		     
	    </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_data_1078" see="data:doel data:Tijdstempel">
    <sch:title>Een doel kan maar 1 datum geldigVanaf hebben</sch:title>
    <sch:rule context="data:Tijdstempels">
      <sch:p>Een doel kan maar 1 datum geldigVanaf hebben</sch:p>
      <sch:let name="Dubbel">
        <xsl:for-each select="data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'geldigVanaf')]">
          <xsl:sort select="data:doel"/>
          <xsl:if test="preceding::data:doel[1] = .">
            <dubbel><xsl:value-of select="."/></dubbel>
          </xsl:if> 
        </xsl:for-each>
      </sch:let>
      <sch:let name="melding">
        <xsl:for-each select="$Dubbel/dubbel">
          <xsl:value-of select="."/>
          <xsl:if test="not(position()=last())">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </sch:let>      
      <sch:assert id="STOP1078" role="error" test="count(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'geldigVanaf')]) = count(distinct-values(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'geldigVanaf')]))">
        {"code": "STOP1078",
         "Dubbel": "<sch:value-of select="$melding"/>"
        }		     
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
