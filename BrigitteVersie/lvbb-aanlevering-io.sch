<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/" />
  <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/" />
  <sch:ns prefix="gio" uri="https://standaarden.overheid.nl/stop/imop/gio/" />
  <sch:ns prefix="se" uri="http://www.opengis.net/se" />
  <sch:ns prefix="lvbba" uri="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
  <sch:p>Versie @@@BHKVVERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validaties voor lvbba</sch:p>
  <!--  -->
  <sch:pattern id="sch_lvbba_BHKV1014" see="lvbba:InformatieObjectVersie">
    <sch:title>Informatieobject - aanleveren GIO</sch:title>
    <sch:rule context="lvbba:InformatieObjectVersie">
      <sch:let name="Expression-ID" value="data:ExpressionIdentificatie/data:FRBRExpression" />
      <sch:assert id="BHKV1014" role="error" test="count(data:InformatieObjectVersieMetadata/data:heeftBestanden/data:heeftBestand) = 1">
        {"code":"BHKV1014", "Expression-ID": "<sch:value-of select="$Expression-ID" />"}</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_023" see="data:heeftGeboorteregeling">
    <sch:title>heeftGeboorteregeling met juiste soortWork en formaatInformatieobject</sch:title>
    <sch:rule
      context="lvbba:AanleveringInformatieObject//lvbba:InformatieObjectVersie[normalize-space(//data:soortWork) = '/join/id/stop/work_010'][normalize-space(//data:formaatInformatieobject) = '/join/id/stop/gio_002']">
      <sch:p>heeftGeboorteregeling MOET aanwezig zijn INDIEN saartWork=work_010 èn
        formaatinformatieobject=gio_002</sch:p>
      <sch:assert id="BHKV1015" role="error" test="//data:heeftGeboorteregeling">{"code":
        "BHKV1015", "id": "<sch:value-of select="//data:FRBRExpression" />"}</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_024">
    <sch:title>Informatieobject van het juiste type</sch:title>
    <sch:rule
      context="lvbba:AanleveringInformatieObject//lvbba:InformatieObjectVersie//data:ExpressionIdentificatie">
      <sch:p>De identificatie van een InformatieObject moet als soort werk '/join/id/stop/work_010'
        zijn</sch:p>
      <sch:assert id="BHKV1016" role="error" test="normalize-space(data:soortWork) = '/join/id/stop/work_010'">{"code": "BHKV1016",
        "work": "<sch:value-of select="data:soortWork" />", "id": "<sch:value-of select="data:FRBRExpression" />"}</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_025"> 
    <sch:title>Officieletitel gelijk aan FRBRWork</sch:title>
    <sch:rule
      context="lvbba:InformatieObjectVersie/data:InformatieObjectMetadata/data:officieleTitel">
      <sch:let name="titel" value="normalize-space(.)" />
      <sch:let name="work"
        value="normalize-space(ancestor::lvbba:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork)" />
      <sch:p>De officiele titel van een informatieobject moet gelijk zijn aan het FRBRWork</sch:p>
      <sch:assert id="BHKV1017" role="error" test="$work = $titel">
      {
      "code": "BHKV1017",
      "work": "<sch:value-of select="$work" />",
      "titel": "<sch:value-of select="$titel" />"
      }</sch:assert>
    </sch:rule>
  </sch:pattern>
    <!--  -->
  <sch:pattern id="sch_lvbba_026">
    <sch:title>De collectie gebruikt in de AKN identifier van een informatieobject MOET overeenkomen met zijn data:publicatieinstructie</sch:title>
    <sch:rule context="lvbba:InformatieObjectVersie/data:InformatieObjectMetadata/data:publicatieinstructie">
      <sch:let name="work"
        value="normalize-space(ancestor::lvbba:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork)" />
	  <sch:let name="Work_reeks" value="tokenize($work, '/')"/>
      <sch:let name="Work_collectie" value="$Work_reeks[4]"/>
      <sch:p>publicatieinstructie moet passen bij AKN identifier veld collectie</sch:p>
      <sch:assert id="BHKV1018" role="error" test="(((./string()='TeConsolideren') and ($Work_collectie='regdata')) or
	                                                ((./string()='AlleenBekendTeMaken') and ($Work_collectie='pubdata')) or
												    ((./string()='Informatief') and ($Work_collectie='infodata')))">
      {
      "code": "BHKV1018",
      "Work-ID": "<sch:value-of select="$work" />",
      "substring": "<sch:value-of select="./string()" />"
      }</sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_lvbba_027">
    <sch:title>De module se:FeatureTypeStyle MAG ALLEEN bij een Geoinformatieobject
      aangeleverd worden.</sch:title>
    <sch:rule context="lvbba:InformatieObjectVersie/se:FeatureTypeStyle[preceding-sibling::data:InformatieObjectMetadata]">
      <sch:let name="formaat" value="preceding-sibling::data:InformatieObjectMetadata/data:formaatInformatieobject/string()"/>
      <sch:assert id="BHKV1064" role="error" test="$formaat = '/join/id/stop/informatieobject/gio_002'">
      {
      "code": "BHKV1064",
      "Expressie": "<sch:value-of select="normalize-space(preceding-sibling::data:ExpressionIdentificatie/data:FRBRExpression)" />",
      "Module": "<sch:value-of select="node-name(.)" />",
      "formaat": "<sch:value-of select="$formaat" />"   
      }</sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="sch_lvbba_028">
    <sch:title>De module gio:JuridischeBorgingVan MAG ALLEEN bij een Geoinformatieobject
      aangeleverd worden.</sch:title>
    <sch:rule context="lvbba:InformatieObjectVersie/gio:JuridischeBorgingVan[preceding-sibling::data:InformatieObjectMetadata]">
      <sch:let name="formaat" value="preceding-sibling::data:InformatieObjectMetadata/data:formaatInformatieobject/string()"/>
      <sch:assert id="BHKV1065" role="error" test="$formaat = '/join/id/stop/informatieobject/gio_002'">
      {
      "code": "BHKV1065",
      "Expressie": "<sch:value-of select="normalize-space(preceding-sibling::data:ExpressionIdentificatie/data:FRBRExpression)" />",
      "Module": "<sch:value-of select="node-name(.)" />",
      "formaat": "<sch:value-of select="$formaat" />"   
      }</sch:assert>
    </sch:rule>
  </sch:pattern>
  
</sch:schema>

