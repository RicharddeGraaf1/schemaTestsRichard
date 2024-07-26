<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:se="http://www.opengis.net/se"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/"/>
  <sch:ns prefix="se" uri="http://www.opengis.net/se"/>
  <sch:ns prefix="ogc" uri="http://www.opengis.net/ogc"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <sch:ns prefix="basisgeo" uri="http://www.geostandaarden.nl/basisgeometrie/1.0"/>
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>

  <sch:p>Versie @@@VSOPVERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor het STOP-deel van de Symbol Encoding (se)
    standaard.</sch:p>

  <sch:pattern id="sch_se_001" see="se:FeatureTypeStyle">
    <sch:rule context="se:FeatureTypeStyle">
      <sch:assert id="STOP3100" role="warning" test="not(se:Name)">
        {"code": "STOP3100",
         "ID": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:assert>

      <sch:assert id="STOP3101" role="warning" test="not(se:Description)">
        {"code": "STOP3101",
         "ID": "<sch:value-of select="./se:Description/se:Title/normalize-space()"/>"
        }
	    </sch:assert>

    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_002" see="se:FeatureTypeName">
    <sch:rule context="se:FeatureTypeName">
      <sch:assert id="STOP3102" role="error" test="(string(.) = 'Locatie') or (substring-after(string(.), ':') = 'Locatie')">
        {"code": "STOP3102",
        "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>


  <sch:pattern id="sch_se_003" see="se:SemanticTypeIdentifier">
    <sch:rule context="se:SemanticTypeIdentifier">
      <sch:let name="AllowedValue"
        value="'^(geometrie|groepID|kwalitatieveNormwaarde|kwantitatieveNormwaarde)$'"/>
      <sch:assert id="STOP3103" role="error" test="matches(substring-after(./string(), ':'), $AllowedValue)">
        {"code": "STOP3103",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_004" see="ogc:Filter">
    <sch:rule context="ogc:Filter">
      <sch:let name="SemanticTypeId"
        value="substring-after(preceding::se:SemanticTypeIdentifier/string(), ':')"/>
      <sch:let name="AllowedValue"
        value="'^(groepID|kwalitatieveNormwaarde|kwantitatieveNormwaarde)$'"/>
      <sch:assert id="STOP3114" role="error" test="matches($SemanticTypeId, $AllowedValue)">
        {"code": "STOP3114",
         "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_005" see="ogc:PropertyName">
    <sch:rule context="ogc:PropertyName">
      <sch:assert id="STOP3115" role="error" test="./string() = substring-after(preceding::se:SemanticTypeIdentifier/string(), ':')">
        {"code": "STOP3115",
         "ID": "<sch:value-of select="."/>",
         "ID2": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_006" see="ogc:Filter">
    <sch:rule
      context="ogc:PropertyIsBetween | ogc:PropertyIsNotEqualTo | ogc:PropertyIsLessThan | ogc:PropertyIsGreaterThan | ogc:PropertyIsLessThanOrEqualTo | ogc:PropertyIsGreaterThanOrEqualTo">
      <sch:let name="SemanticTypeId"
        value="substring-after(preceding::se:SemanticTypeIdentifier/string(), ':')"/>
      <sch:let name="AllowedValue" value="'^(kwantitatieveNormwaarde)$'"/>
      <sch:assert id="STOP3118" role="error" test="matches($SemanticTypeId, $AllowedValue)">
        {"code": "STOP3118",
         "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_007" see="ogc:And">
    <sch:rule context="ogc:And">
      <sch:assert id="STOP3120" role="error" test="./ogc:PropertyIsGreaterThanOrEqualTo and ./ogc:PropertyIsLessThan">
        {"code": "STOP3120",
         "ID": "<sch:value-of select="preceding::se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_008" see="se:Rule">
    <sch:rule context="se:Rule/se:Description">
      <sch:assert id="STOP3126" role="error" test="se:Title/normalize-space() != ''">
        {"code": "STOP3126",
         "ID": "<sch:value-of select="preceding-sibling::se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_009" see="se:PointSymbolizer">
    <sch:rule context="se:PointSymbolizer">
      <sch:assert id="STOP3135" role="error" test="not(./se:Graphic/se:Mark/se:Fill/se:GraphicFill)">
        {"code": "STOP3135",
         "ID": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_010" see="se:SvgParameter">
    <sch:rule context="se:SvgParameter[@name = 'stroke']">
      <sch:assert id="STOP3140" role="error" test="matches(./string(), '^#[0-9a-f]{6}$')">
       {"code": "STOP3140",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'fill']">
      <sch:assert id="STOP3147" role="error" test="matches(./string(), '^#[0-9a-f]{6}$')">
       {"code": "STOP3147",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'stroke-width']">
      <sch:assert id="STOP3141" role="error" test="matches(./string(), '^[0-9]+(.[0-9])?[0-9]?$')">
       {"code": "STOP3141",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'stroke-dasharray']">
      <sch:assert id="STOP3142" role="error" test="matches(./string(), '^([0-9]+ ?)*$')">
       {"code": "STOP3142",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'stroke-linecap']">
      <sch:assert id="STOP3143" role="error" test="./string() = 'butt'">
       {"code": "STOP3143",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'stroke-opacity']">
      <sch:assert id="STOP3144" role="error" test="matches(./string(), '^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
       {"code": "STOP3144",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'fill-opacity']">
      <sch:assert id="STOP3148" role="error" test="matches(./string(), '^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
       {"code": "STOP3148",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>

    <sch:rule context="se:SvgParameter[@name = 'stroke-linejoin']">
      <sch:assert id="STOP3145" role="error" test="./string() = 'round'">
       {"code": "STOP3145",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_011" see="se:Stroke/SvgParameter">
    <sch:rule context="se:Stroke/se:SvgParameter">
      <sch:let name="AllowedValue"
        value="'^(stroke|stroke-width|stroke-dasharray|stroke-linecap|stroke-opacity|stroke-linejoin)$'"/>
      <sch:assert id="STOP3139" role="error" test="matches(./@name, $AllowedValue)"> 
        {"code": "STOP3139",
         "ID": "<sch:value-of select="./@name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_012" see="se:Fill/se:SvgParameter">
    <sch:rule context="se:Fill/se:SvgParameter">
      <sch:let name="AllowedValue" value="'^(fill|fill-opacity)$'"/>
      <sch:assert id="STOP3146" role="error" test="matches(./@name, $AllowedValue)"> 
        {"code": "STOP3146",
         "ID": "<sch:value-of select="./@name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_013" see="se:WellKnownName">
    <sch:rule context="se:WellKnownName">
      <sch:let name="AllowedValue" value="'^(cross|cross_fill|square|circle|star|triangle)$'"/>
      <sch:assert id="STOP3157" role="error" test="matches(./string(), $AllowedValue)">
        {"code": "STOP3157",
         "ID": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_014" see="se:Size">
    <sch:rule context="se:Size">
      <sch:assert id="STOP3163" role="error" test="matches(./string(), '^[0-9]+$')">
       {"code": "STOP3163",
         "ID": "<sch:value-of select="../../se:Name"/>",
         "ID2": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_016" see="se:PolygonSymbolizer/se:Fill/se:GraphicFill/se:Graphic">
    <sch:rule context="se:PolygonSymbolizer/se:Fill/se:GraphicFill/se:Graphic">
      <sch:assert id="STOP3170" role="error" test="./se:ExternalGraphic and not(./se:Mark)">
        {"code": "STOP3170",
         "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_017" see="se:InlineContent[@encoding='base64']">
    <sch:rule context="se:InlineContent[@encoding = 'base64']">
      <sch:assert id="STOP3173" role="error" test="matches(./normalize-space(), '^[A-Z0-9a-z+/ =]*$')">
       {"code": "STOP3173",
         "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>",
         "ID2": "<sch:value-of select="normalize-space(replace(./string(), '[A-Z0-9a-z+/ =]', ''))"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_018" see="se:ExternalGraphic/se:Format">
    <sch:rule context="se:ExternalGraphic/se:Format">
      <sch:assert id="STOP3174" role="error" test="./string() = 'image/png'">
       {"code": "STOP3174",
         "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>",
         "ID2": "<sch:value-of select="."/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_3176" see="se:FeatureTypeStyle">
    <sch:rule context="se:FeatureTypeStyle">
      <sch:let name="childnames">
        <xsl:for-each select="child::*">
          <xsl:value-of select="node-name(.)"/>
          <xsl:if test="count(following-sibling::*) > 0">, </xsl:if>
        </xsl:for-each>
      </sch:let>
      <sch:assert id="STOP3176" role="error" test="count(child::*) = 0 or (se:FeatureTypeName and se:SemanticTypeIdentifier and se:Rule)">
       {"code": "STOP3176",
         "childnames": "<sch:value-of select="$childnames"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_3177" see="se:PointSymbolizer">
    <sch:rule context="se:PointSymbolizer">
      <sch:assert id="STOP3177" role="error" test="not(./se:Graphic/se:ExternalGraphic)">
        {"code": "STOP3177",
         "ID": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_3178" see="se:PointSymbolizer">
    <sch:rule context="se:PointSymbolizer">
      <sch:assert id="STOP3178" role="error" test="./se:Graphic/se:Mark/se:Fill">
        {"code": "STOP3178",
         "ID": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_3179" see="se:PointSymbolizer">
    <sch:rule context="se:PointSymbolizer">
      <sch:assert id="STOP3179" role="error" test="./se:Graphic/se:Mark/se:Stroke">
        {"code": "STOP3179",
         "ID": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_se_3180" see="se:Rule">
    <sch:rule context="se:Rule">
      <sch:let name="SemanticTypeId"
        value="substring-after(preceding::se:SemanticTypeIdentifier/string(), ':')"/>
      <sch:let name="AllowedValue" value="'^(groepID|kwalitatieveNormwaarde|kwantitatieveNormwaarde)$'"/>
      <sch:report id="STOP3180" role="error" test="matches($SemanticTypeId, $AllowedValue) and not(./ogc:Filter)"> 
        {"code": "STOP3180",
         "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>",
         "ID2": "<sch:value-of select="./se:Name"/>"
        }
	    </sch:report>
    </sch:rule>
  </sch:pattern>
  
  
  <sch:pattern id="sch_se_3181" see="se:PolygonSymbolizer">
    <sch:rule context="se:PolygonSymbolizer">
      <sch:assert id="STOP3181" role="error" test="se:Stroke or se:Fill">
        {"code": "STOP3181",
         "ID": "<sch:value-of select="se:Name"/>"
        }
	    </sch:assert>
    </sch:rule>
  </sch:pattern>

</sch:schema>
