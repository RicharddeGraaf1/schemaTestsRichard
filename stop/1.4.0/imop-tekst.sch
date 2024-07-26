<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
	<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
	<sch:p>Versie @@@VSOPVERSIE@@@</sch:p>
	<sch:p>Schematron voor aanvullende validatie voor imop-tekst.xsd</sch:p>
	<sch:pattern id="sch_tekst_001">
		<sch:title>Lijst - Nummering lijstitems</sch:title>
		<sch:rule context="tekst:Lijst[@type = 'ongemarkeerd']">
			<sch:assert id="STOP0001" test="count(tekst:Li/tekst:LiNummer) = 0">
				{ "code":
				"STOP0001", "eId": "<sch:value-of select="@eId"/>" }
			</sch:assert>
		</sch:rule>

		<sch:rule context="tekst:Lijst[@type = 'expliciet']">
			<sch:assert id="STOP0002" test="count(tekst:Li[tekst:LiNummer]) = count(tekst:Li)">
				{ "code": "STOP0002", "eId":
				"<sch:value-of select="@eId"/>" }
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_022">
		<sch:title>Alinea - Bevat content</sch:title>
		<sch:rule context="tekst:Al">
			<sch:report id="STOP0005" test="normalize-space(./string()) = '' and not(tekst:InlineTekstAfbeelding | tekst:Nootref)">
				{ "code": "STOP0005",
				"element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId":
				"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>" }
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_027">
		<sch:title>Kop - Bevat content</sch:title>
		<sch:rule context="tekst:Kop">
			<sch:report id="STOP0006" test="normalize-space(./string()) = ''">
				{ "code": "STOP0006",
				"element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId":
				"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>" }
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_003">
		<sch:title>Tabel - Referenties naar een noot</sch:title>
		<sch:rule context="tekst:table//tekst:Nootref">
			<sch:let name="nootID" value="@refid"/>
			<sch:assert id="STOP0008" test="ancestor::tekst:table//tekst:Noot[@id = $nootID]">
				{ "code":
				"STOP0008", "ref": "<sch:value-of select="@refid"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>"}
			</sch:assert>
		</sch:rule>
		<sch:rule context="tekst:Nootref">
			<sch:let name="nootID" value="@refid"/>
			<sch:assert id="STOP0007" test="ancestor::tekst:table">
				{ "code": "STOP0007", "ref":
				"<sch:value-of select="@refid"/>" }
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_004">
		<sch:title>Lijst - plaatsing tabel in een lijst</sch:title>
		<sch:rule context="tekst:Li[tekst:table]">
			<sch:report id="STOP0009" test="self::tekst:Li/tekst:table and not(ancestor::tekst:Instructie)">
				{ "code": "STOP0009",
				"eId": "<sch:value-of select="@eId"/>" }
			</sch:report>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="sch_tekst_032">
		<sch:title>Illustratie - attributen kleur en schaal worden niet ondersteund</sch:title>
		<sch:rule context="tekst:Illustratie | tekst:InlineTekstAfbeelding">
			<sch:report id="STOP0045" test="@schaal">
				{ "code": "STOP0045", "ouder":
				"<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::*[@eId][1]/@eId"/>"}
			</sch:report>
			<sch:report id="STOP0046" test="@kleur">
				{ "code": "STOP0046", "ouder":
				"<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<!--
    INTERNE REFERENTIES HEBBEN CORRECTE VERWIJZINGEN
  -->
	<!--
    Unieke eId en wId's voor Int(Io)Refs
  -->
	<xsl:key match="tekst:*[@eId]" name="alleEIDsVoorIntRefs" use="@eId"/>
	
	<sch:pattern id="sch_tekst_006">
		<sch:title>Referentie intern - correcte verwijzing</sch:title>
		<sch:rule
      context="tekst:IntRef[not(ancestor::tekst:RegelingMutatie | ancestor::tekst:BesluitMutatie)]">
			<sch:let name="doelwit_eid">
				<xsl:choose>
					<xsl:when test="starts-with(@ref, '!')">
						<xsl:value-of select="substring-after(@ref, '#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@ref"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="doelwit_component">
				<xsl:choose>
					<xsl:when test="starts-with(@ref, '!')">
						<xsl:value-of select="translate(substring-before(@ref, '#'), '!', '')"/>
					</xsl:when>
					<xsl:otherwise>[zonder_component]</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="intref_component">
				<xsl:choose>
					<xsl:when test="ancestor::tekst:*[@componentnaam]">
						<xsl:value-of select="ancestor::tekst:*[@componentnaam][1]/@componentnaam"/>
					</xsl:when>
					<xsl:otherwise>[in_hoofdtekst]</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="scopeNaam">
				<xsl:choose>
					<xsl:when test="@scope">
						<xsl:value-of select="@scope"/>
					</xsl:when>
					<xsl:otherwise>[geen-scope]</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="localName">
				<xsl:choose>
					<xsl:when test="$doelwit_component = '[zonder_component]'">
						<xsl:choose>
							<xsl:when test="$intref_component = '[in_hoofdtekst]'">
								<xsl:value-of select="key('alleEIDsVoorIntRefs', $doelwit_eid)[not(ancestor::tekst:*[@componentnaam])]/local-name()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="key('alleEIDsVoorIntRefs', $doelwit_eid)[ancestor::tekst:*[@componentnaam][1]/@componentnaam = $intref_component]/local-name()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$intref_component = '[in_hoofdtekst]'">
						<xsl:value-of select="key('alleEIDsVoorIntRefs', $doelwit_eid)[ancestor::tekst:*[@componentnaam][1]/@componentnaam = $doelwit_component]/local-name()"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</sch:let>
			<sch:let name="var_component">
				<xsl:choose>
					<xsl:when test="$doelwit_component = '[zonder_component]'">
						<xsl:choose>
							<xsl:when test="$intref_component = '[in_hoofdtekst]'">in de hoofdtekst</xsl:when>
							<xsl:otherwise>
								<xsl:text>in de tekst van component '</xsl:text>
								<xsl:value-of select="$intref_component"/>
								<xsl:text>'</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>in component '</xsl:text>
						<xsl:value-of select="$doelwit_component"/>
						<xsl:text>'</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0010" test="$localName != ''">
				{"code": "STOP0010",
				"ref": "<sch:value-of select="@ref"/>",
				"eId": "<sch:value-of select="$doelwit_eid"/>",
				"component": "<sch:value-of select="$var_component"/>"}
			</sch:assert>
			<sch:assert id="STOP0053" test="$localName = '' or $scopeNaam = '[geen-scope]' or $scopeNaam = $localName">
				{"code": "STOP0053",
				"ref": "<sch:value-of select="@ref"/>",
				"eId": "<sch:value-of select="$doelwit_eid"/>",
				"component": "<sch:value-of select="$var_component"/>",
				"scope": "<sch:value-of select="$scopeNaam"/>",
				"local": "<sch:value-of select="$localName"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<xsl:key match="tekst:ExtIoRef[@wId]" name="alleExtIoRefVoorIntIoRefs" use="@wId"/>

	<sch:pattern id="sch_tekst_028">
		<sch:title>Referentie informatieobject - correcte verwijzing</sch:title>
		<sch:rule
      context="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie | ancestor::BesluitMutatie)]">
			<sch:let name="doelwit" value="@ref"/>
			<sch:assert id="STOP0011" test="key('alleExtIoRefVoorIntIoRefs', $doelwit)">
				{ "code":
				"STOP0011", "element": "<sch:name/>", "ref": "<sch:value-of select="$doelwit"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_ExtIoRef">
		<sch:title>ExtIoRef: Referentie extern informatieobject</sch:title>
		<sch:rule context="tekst:ExtIoRef">
			<sch:let name="ref" value="normalize-space(@ref)"/>
			<sch:let name="reeks" value="tokenize($ref, '/')"/>
			<sch:let name="collectie" value="$reeks[4]"/>

			<sch:p>STOP0012: ExtIoRef @ref = ref</sch:p>
			<sch:assert id="STOP0012" test="normalize-space(.) = $ref">
				{
				"code": "STOP0012",
				"eId": "<sch:value-of select="@eId"/>" }
			</sch:assert>

			<sch:p>STOP0092: ExtIoRef alleen voor regdata</sch:p>
			<sch:report id="STOP0092" test="replace($collectie, 'regdata','')">
				{
				"code": "STOP0092",
				"eId": "<sch:value-of select="@eId"/>",
				"ref": "<sch:value-of select="$ref"/>",
				"collectie": "<sch:value-of select="$collectie"/>"}
			</sch:report>

			<sch:p>STOP0102: ExtIoRef alleen binnen Inhoud</sch:p>
			<sch:assert id="STOP0102" test="ancestor::tekst:Inhoud">
				{
				"code": "STOP0102",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>

			<sch:p>STOP0103: ExtIoRef niet binnen Toelichting/ Motivatie</sch:p>
			<sch:report id="STOP0103" test="ancestor::tekst:ArtikelgewijzeToelichting | ancestor::tekst:AlgemeneToelichting | ancestor::tekst:Toelichting | ancestor::tekst:Motivering">
				{
				"code": "STOP0103",
				"element": "<sch:value-of select="local-name((ancestor::tekst:Toelichting | ancestor::tekst:AlgemeneToelichting | ancestor::tekst:ArtikelgewijzeToelichting | ancestor::tekst:Motivering)[last()])"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_104">
		<sch:title>Formule/Titel, Bijschrift, Bron, Lijstaanhef, Lijstsluiting - ExtIoRef niet toegestaan</sch:title>
		<sch:rule context="tekst:Titel[parent::tekst:Figuur]//tekst:ExtIoRef | tekst:Bijschrift//tekst:ExtIoRef | tekst:Bron//tekst:ExtIoRef | tekst:Lijstaanhef//tekst:ExtIoRef | tekst:Lijstsluiting//tekst:ExtIoRef">
			<sch:report id="STOP0104" test=".">
				{
				"code": "STOP0104",
				"element": "<sch:value-of select="local-name((ancestor::tekst:Titel[parent::tekst:Figuur] | ancestor::tekst:Bijschrift | ancestor::tekst:Bron | ancestor::tekst:Lijstaanhef | ancestor::tekst:Lijstsluiting)[1])"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_023">
		<sch:title>RegelingTijdelijkdeel - WijzigArtikel niet toegestaan</sch:title>
		<sch:rule context="tekst:RegelingTijdelijkdeel//tekst:WijzigArtikel">
			<sch:report id="STOP0015" test="self::tekst:WijzigArtikel">
				{ "code": "STOP0015", "eId":
				"<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_026">
		<sch:title>RegelingCompact - WijzigArtikel niet toegestaan</sch:title>
		<sch:rule context="tekst:RegelingCompact//tekst:WijzigArtikel">
			<sch:report id="STOP0016" test="self::tekst:WijzigArtikel">
				{ "code": "STOP0016", "eId":
				"<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	<!-- 
    Renvooi markering alleen toegestaan binnen een tekst:RegelingMutatie
  -->
	<sch:pattern id="sch_tekst_009" see="tekst:RegelingMutatie tekst:NieuweTekst
    tekst:VerwijderdeTekst">
		<sch:title>Mutaties - Wijzigingen tekstueel</sch:title>
		<sch:rule context="tekst:NieuweTekst | tekst:VerwijderdeTekst">
			<sch:p>
				Een tekstuele mutatie ten behoeve van renvooi MAG NIET buiten een Regeling- of
				BesluitMutatie voorkomen
			</sch:p>
			<sch:assert id="STOP0017" test="ancestor::tekst:RegelingMutatie or ancestor::tekst:BesluitMutatie">
				{ "code":
				"STOP0017", "ouder": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId":
				"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "element":
				"<sch:name/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_010">
		<sch:title>Mutaties - Wijzigingen structuur</sch:title>
		<sch:rule context="tekst:*[@wijzigactie]">
			<sch:p>
				Een structuur wijziging MAG NIET buiten een Regeling- of BesluitMutatie met Vervang
				voorkomen
			</sch:p>
			<sch:assert id="STOP0018" test="ancestor::tekst:Vervang or ancestor::tekst:VervangKop">
				{ "code":
				"STOP0018", "element": "<sch:value-of select="local-name()"/>", "eId": "<sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!--
    Unieke eId en wId's  
   	-->
	<xsl:key
		match="tekst:*[@eId][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleEIDs" use="@eId"/>
	<xsl:key
		match="tekst:*[@wId][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleWIDs" use="@wId"/>
	<xsl:key
		match="tekst:Noot[not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleNootIDs" use="@id"/>
	
	<sch:pattern id="sch_tekst_011">
		<sch:title>Identificatie - Alle wId en eId binnen of buiten een AKN-component zijn uniek</sch:title>
		<sch:rule
      context="tekst:*[@eId][not(ancestor-or-self::tekst:WijzigInstructies)]">
			<sch:let name="mijnComponent" value="./ancestor-or-self::tekst:*[@componentnaam][1]/@componentnaam"/>
			<sch:let name="aantalEID">
				<xsl:choose>
					<xsl:when test="exists($mijnComponent)">						
						<xsl:value-of select="count(key('alleEIDs',@eId)[ancestor-or-self::tekst:*[@componentnaam][1]/@componentnaam=$mijnComponent])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(key('alleEIDs',@eId)[not(ancestor-or-self::tekst:*[@componentnaam])])"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="aantalWID">
				<xsl:choose>
					<xsl:when test="exists($mijnComponent)">
						<xsl:value-of select="count(key('alleWIDs',@wId)[ancestor-or-self::tekst:*[@componentnaam][1]/@componentnaam=$mijnComponent])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(key('alleWIDs',@wId)[not(ancestor-or-self::tekst:*[@componentnaam])])"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0020" test="$aantalEID = 1">
				{ "code":
				"STOP0020", "eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
			<sch:assert id="STOP0021" test="$aantalWID = 1">
				{ "code":
				"STOP0021", "wId": "<sch:value-of select="@wId"/>"}
			</sch:assert>
		</sch:rule>
		<sch:rule
      context="tekst:Noot[not(ancestor-or-self::tekst:WijzigInstructies)]">
			<sch:let name="mijnComponent" value="./ancestor-or-self::tekst:*[@componentnaam][1]/@componentnaam"/>
			<sch:let name="aantalNootID">
				<xsl:choose>
					<xsl:when test="exists($mijnComponent)">
						<xsl:value-of select="count(key('alleNootIDs',@id)[ancestor-or-self::tekst:*[@componentnaam][1]/@componentnaam = $mijnComponent])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(key('alleNootIDs',@id)[not(ancestor-or-self::tekst:*[@componentnaam])])"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0068" test="$aantalNootID = 1">
				{ "code": "STOP0068", 
				  "id": "<sch:value-of select="@id"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_020">
		<sch:title>Identificatie - AKN-naamgeving voor eId en wId</sch:title>
		<sch:rule context="*[@eId]">
			<sch:let name="AKNnaam">
				<xsl:choose>
					<xsl:when test="matches(local-name(), 'Lichaam')">body</xsl:when>
					<xsl:when test="matches(local-name(), 'RegelingOpschrift')">longTitle</xsl:when>
					<xsl:when test="matches(local-name(), 'AlgemeneToelichting')">genrecital</xsl:when>
					<xsl:when test="matches(local-name(), '^ArtikelgewijzeToelichting$')">artrecital</xsl:when>
					<xsl:when test="matches(local-name(), 'Artikel|WijzigArtikel|InwerkingtredingArtikel')">art</xsl:when>
					<xsl:when test="matches(local-name(), 'WijzigLid|Lid')">para</xsl:when>
					<xsl:when test="matches(local-name(), 'Divisietekst|Mededelingtekst|Rectificatietekst')">content</xsl:when>
					<xsl:when test="matches(local-name(), 'Divisie')">div</xsl:when>
					<xsl:when test="matches(local-name(), 'Boek')">book</xsl:when>
					<xsl:when test="matches(local-name(), 'Titel')">title</xsl:when>
					<xsl:when test="matches(local-name(), 'Deel')">part</xsl:when>
					<xsl:when test="matches(local-name(), 'Hoofdstuk')">chp</xsl:when>
					<xsl:when test="matches(local-name(), 'Afdeling')">subchp</xsl:when>
					<xsl:when test="matches(local-name(), 'Paragraaf|Subparagraaf|Subsubparagraaf')">subsec</xsl:when>
					<xsl:when test="matches(local-name(), 'WijzigBijlage|Bijlage')">cmp</xsl:when>
					<xsl:when test="matches(local-name(), 'Motivering')">acc</xsl:when>
					<xsl:when test="matches(local-name(), 'Toelichting')">recital</xsl:when>
					<xsl:when test="matches(local-name(), 'InleidendeTekst')">intro</xsl:when>
					<xsl:when test="matches(local-name(), 'Aanhef')">formula_1</xsl:when>
					<xsl:when test="matches(local-name(), 'Kadertekst')">recital</xsl:when>
					<xsl:when test="matches(local-name(), 'Sluiting')">formula_2</xsl:when>
					<xsl:when test="matches(local-name(), 'table')">table</xsl:when>
					<xsl:when test="matches(local-name(), 'Figuur')">img</xsl:when>
					<xsl:when test="matches(local-name(), 'Formule')">math</xsl:when>
					<xsl:when test="matches(local-name(), 'Citaat')">cit</xsl:when>
					<xsl:when test="matches(local-name(), 'Begrippenlijst|Lijst')">list</xsl:when>
					<xsl:when test="matches(local-name(), 'Li|Begrip')">item</xsl:when>
					<xsl:when test="matches(local-name(), 'IntIoRef|ExtIoRef')">ref</xsl:when>
					<xsl:otherwise>AKN-prefix-van-onbekend-element</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="mijnEID">
				<xsl:choose>
					<xsl:when test="contains(@eId, '__')">
						<xsl:value-of select="tokenize(@eId, '__')[last()]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@eId"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0022" test="replace($mijnEID, $AKNnaam, '')='' or starts-with(replace($mijnEID, $AKNnaam, ''),'_')">
				{ "code": "STOP0022",
				"AKNdeel": "<sch:value-of select="$mijnEID"/>", "element": "<sch:name/>", "waarde":
				"<sch:value-of select="$AKNnaam"/>", "wId": "<sch:value-of select="@wId"/>"
				}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- VOOR TABELLEN EEN REEKS CONTROLES OP CALS REGELS -->

	<sch:pattern id="sch_tekst_014">
		<sch:title>Tabel - minimale opbouw</sch:title>
		<sch:rule context="tekst:table/tekst:tgroup">
			<sch:assert id="STOP0029" test="number(@cols) >= 2">
				{ "code":
				"STOP0029", "eId": "<sch:value-of select="parent::tekst:table/@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_093">
		<sch:title>Tabel - minimaal 2 rijen</sch:title>
		<sch:rule context="tekst:table">
			<sch:let name="aantal_rijen">
				<xsl:value-of select="count(tekst:tgroup/tekst:thead/tekst:row[not(@wijzigactie = 'verwijder')]) + count(tekst:tgroup/tekst:tbody/tekst:row[not(@wijzigactie = 'verwijder')])"/>
			</sch:let>
			<sch:assert id="STOP0093" test="$aantal_rijen >= 2">
				{
				"code": "STOP0093",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_094">
		<sch:title>Tabel - minimaal 3 cellen</sch:title>
		<sch:rule context="tekst:table">
			<sch:let name="aantal_cellen">
				<xsl:value-of select="count(tekst:tgroup/tekst:thead/tekst:row[not(@wijzigactie = 'verwijder')]/tekst:entry[not(@wijzigactie = 'verwijder')]) + count(tekst:tgroup/tekst:tbody/tekst:row[not(@wijzigactie = 'verwijder')]/tekst:entry[not(@wijzigactie = 'verwijder')])"/>
			</sch:let>
			<sch:assert id="STOP0094" test="$aantal_cellen >= 3">
				{
				"code": "STOP0094",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_016">
		<sch:title>Tabel - positie en identificatie van een tabelcel</sch:title>
		<sch:rule context="tekst:entry[@namest and @colname]">
			<sch:let name="start" value="@namest"/>
			<sch:let name="col" value="@colname"/>
			<sch:p>
				Bij horizontale overspanning MOET de eerste cel ook de start van de overspanning
				zijn
			</sch:p>
			<sch:assert id="STOP0033" test="$col = $start">
				{ "code": "STOP0033", "naam":
				"<sch:value-of select="@namest"/>", "nummer": "<sch:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder":
				"<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId":
				"<sch:value-of select="ancestor::tekst:table/@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0032">
		<sch:rule context="tekst:entry[@namest][@nameend]">
			<sch:p>
				Bij horizontale overspanning MOET de positie van @nameend groter zijn dan de positie
				van @namest
			</sch:p>
			<sch:let name="start" value="@namest"/>
			<sch:let name="end" value="@nameend"/>
			<sch:let name="colPosities">
				<xsl:for-each select="ancestor::tekst:tgroup/tekst:colspec">
					<xsl:variable name="colnum">
						<xsl:choose>
							<xsl:when test="@colnum">
								<xsl:value-of select="@colnum"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="position()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<col colnum="{$colnum}" name="{@colname}"/>
				</xsl:for-each>
			</sch:let>
			<sch:assert id="STOP0032" test="xs:integer($colPosities/*[@name = $start]/@colnum) &lt;= xs:integer($colPosities/*[@name = $end]/@colnum)">
				{ "code": "STOP0032", "naam": "<sch:value-of select="@namest"/>", "nummer": "<sch:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder":
				"<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId":
				"<sch:value-of select="ancestor::tekst:table/@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0036">
		<sch:rule context="tekst:entry[@colname]">
			<sch:p>De referentie van een cel MOET correct verwijzen naar een kolom</sch:p>
			<sch:let name="id" value="@colname"/>
			<sch:report id="STOP0036" test="not(ancestor::tekst:tgroup/tekst:colspec[@colname = $id])">
				{ "code": "STOP0036",
				"naam": "colname", "nummer": "<sch:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder":
				"<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId":
				"<sch:value-of select="ancestor::tekst:table/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_017">
		<sch:title>Tabel - het aantal cellen is correct</sch:title>
		<sch:rule context="tekst:tgroup/tekst:thead | tekst:tgroup/tekst:tbody">
			<sch:let name="totaalCellen" value="count(tekst:row[not(@wijzigactie = 'verwijder')]) * number(parent::tekst:tgroup/@cols)"/>
			<sch:let name="colPosities">
				<xsl:for-each select="parent::tekst:tgroup/tekst:colspec[not(@wijzigactie = 'verwijder')]">
					<xsl:variable name="colnum">
						<xsl:choose>
							<xsl:when test="@colnum">
								<xsl:value-of select="@colnum"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="position()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<col colnum="{$colnum}" name="{@colname}"/>
				</xsl:for-each>
			</sch:let>
			<sch:let name="spanEinde">
				<xsl:for-each
					select="(self::tekst:tbody|self::tekst:thead)/tekst:row[not(@wijzigactie = 'verwijder')]/tekst:entry[not(@wijzigactie = 'verwijder')]">
					<xsl:variable as="xs:string?" name="namest" select="@namest"/>
					<xsl:variable as="xs:string?" name="nameend" select="@nameend"/>
					<xsl:variable as="xs:integer?" name="numend"
            select="$colPosities/*[@name = $nameend]/@colnum"/>
					<xsl:variable as="xs:integer?" name="numst"
            select="$colPosities/*[@name = $namest]/@colnum"/>
					<nr>
						<xsl:choose>
							<xsl:when test="$numend and $numst and @morerows">
								<xsl:value-of select="($numend - $numst + 1) * (@morerows + 1)"/>
							</xsl:when>
							<xsl:when test="$numend and $numst">
								<xsl:value-of select="$numend - $numst + 1"/>
							</xsl:when>
							<xsl:when test="@morerows">
								<xsl:value-of select="1 + @morerows"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</nr>
				</xsl:for-each>
			</sch:let>
			<sch:let name="spannend" value="sum($spanEinde/*)"/>
			<sch:p>Het aantal colspec's MOET gelijk zijn aan het opgegeven aantal kolommen.</sch:p>
			<sch:assert id="STOP0037" test="number(parent::tekst:tgroup/@cols) = count(parent::tekst:tgroup/tekst:colspec[not(@wijzigactie = 'verwijder')])">
				{
				"code": "STOP0037", "nummer": "<sch:value-of select="count(parent::tekst:tgroup/tekst:colspec[not(@wijzigactie = 'verwijder')])"/>", "naam": "<sch:name/>", "eId":
				"<sch:value-of select="ancestor::tekst:table/@eId"/>", "aantal": "<sch:value-of select="parent::tekst:tgroup/@cols"/>"}
			</sch:assert>
			<sch:p>Het totale aantal cellen MOET overeenkomen met het aantal mogelijke cellen</sch:p>
			<sch:assert id="STOP0038" test="$totaalCellen = $spannend">
				{ "code": "STOP0038",
				"aantal": "<sch:value-of select="$spannend"/>", "naam": "<sch:name/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "nummer": "<sch:value-of select="$totaalCellen"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_033">
		<sch:title>Externe referentie, notatie</sch:title>
		<sch:rule context="tekst:ExtRef">
			<sch:let name="notatie">
				<xsl:choose>
					<xsl:when test="@soort = 'AKN'">/akn/</xsl:when>
					<xsl:when test="@soort = 'JCI'">jci1</xsl:when>
					<xsl:when test="@soort = 'URL'">http</xsl:when>
					<xsl:when test="@soort = 'JOIN'">/join/</xsl:when>
					<xsl:when test="@soort = 'document'"/>
				</xsl:choose>
			</sch:let>
			<sch:p>Een externe referentie MOET de juiste notatie gebruiken</sch:p>
			<sch:assert id="STOP0050" test="starts-with(@ref, $notatie)">
				{"code": "STOP0050",
				"type": "<sch:value-of select="@soort"/>", "ref": "<sch:value-of select="@ref"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_037">
		<sch:title>Gereserveerd als enige element</sch:title>
		<sch:rule context="tekst:Gereserveerd[not(ancestor::tekst:Vervang)][not(ancestor::tekst:Artikel)]">
			<sch:p>
				Het element Gereserveerd MAG GEEN opvolgende elementen op hetzelfde niveau
				hebben
			</sch:p>
			<sch:assert id="STOP0055" test="not(following-sibling::tekst:*)">
				{ "code":
				"STOP0055", "naam": "<sch:value-of select="local-name(following-sibling::tekst:*[1])"/>",
				"element": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of select="parent::tekst:*/@eId"/>" }
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_070">
		<sch:title>Eén type element in Artikel, tenzij binnen vervang</sch:title>
		<sch:rule context="tekst:Artikel[not(ancestor::tekst:Vervang)]">
			<sch:p>
				Het element Artikel MAG slechts één type element op hetzelfde niveau
				hebben. Alleen Lid mag meerdere keren voorkomen, andere elementen kunnen max 1 keer voorkomen.
			</sch:p>
			<sch:let name="aantalKinderenNietLid" value="count(tekst:Inhoud|tekst:Vervallen|tekst:Gereserveerd|tekst:NogNietInWerking)"/>
			<sch:report id="STOP0070" test="(child::tekst:Lid and $aantalKinderenNietLid>0) or ($aantalKinderenNietLid>1)">
				{
				"code": "STOP0070",
				"naam": "<sch:value-of select="local-name()"/>",
				"eId": "<sch:value-of select="@eId"/>"
				}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_039">
		<sch:title>Structuur compleet</sch:title>
		<sch:rule context="tekst:Afdeling | tekst:Bijlage | tekst:Boek | tekst:Deel | tekst:Divisie | tekst:Hoofdstuk | tekst:Paragraaf | tekst:Subparagraaf | tekst:Subsubparagraaf | tekst:Titel[not(parent::tekst:Figuur)]">
			<sch:p>In een regeling MOET een structuur-element altijd ten minste een element na de Kop bevatten</sch:p>
			<sch:assert id="STOP0058" test="child::tekst:*[not(self::tekst:Kop)] or ancestor::tekst:Vervang or ancestor::tekst:VoegToe or ancestor::tekst:Verwijder">
				{"code":
				"STOP0058", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_041">
		<sch:title>Divisietekst compleet</sch:title>
		<sch:rule context="tekst:Divisietekst[not(ancestor::tekst:Vervang)]">
			<sch:p>Een Divisietekst MOET altijd precies één element anders dan een Kop bevatten, tenzij binnen vervang</sch:p>
			<sch:assert id="STOP0060" test="count(child::tekst:*[not(self::tekst:Kop)])=1">
				{"code":
				"STOP0060", "naam": "<sch:value-of select="local-name()"/>", "eId": "<sch:value-of select="xs:string(@eId)"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- STOP0061 nu afgedwongen door schema -->

	<sch:pattern id="sch_tekst_044">
		<sch:title>Vervallen structuur</sch:title>
		<sch:p>identiek aan stop0087 voor NogNietInWerking</sch:p>
		<sch:rule
			context="tekst:Vervallen[not(ancestor::tekst:Vervang)][not(parent::tekst:Artikel)][not(parent::tekst:Divisietekst)]">
			<sch:p>
				Indien een structuur-element vervallen is dan moeten ook alle onderliggende delen
				(structuur en tekst) vervallen zijn
			</sch:p>
			<sch:report id="STOP0062" test="following-sibling::tekst:*[not(child::tekst:Vervallen)]">
				{ "code":"STOP0062", "naam":
				"<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of select="parent::tekst:*/@eId"/>", "element": "<sch:value-of select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/>", "id":
				"<sch:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<!-- STOP0087 nog niet actief, zie STOP0129	-->

	<sch:pattern id="sch_tekst_045">
		<sch:rule context="tekst:Contact">
			<sch:let name="pattern">
				<xsl:choose>
					<xsl:when test="@soort = 'e-mail'">[^@]+@[^\.]+\..+</xsl:when>
					<xsl:otherwise>[onbekend-soort-adres]</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:let name="adres" value="@adres/./string()"/>
			<sch:p>
				Als het element tekst:Contact een attribuut @adres heeft, moet de inhoud van het
				attribuut een adres zijn dat is geformatteerd volgens de specificaties van de waarde van
				attribuut @soort.
			</sch:p>
			<sch:assert id="STOP0064" test="matches($adres, $pattern)">
				{"code": "STOP0064",
				"adres": "<sch:value-of select="./string()"/>",
				"eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_046">
		<sch:rule context="tekst:Motivering[@schemaversie]">
			<sch:report id="STOP0075" test="ancestor::tekst:BesluitCompact|ancestor::tekst:BesluitKlassiek">
				{"code": "STOP0075",
				"schemaversie": "<sch:value-of select="@schemaversie"/>"
				}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_081">
		<sch:title>Toelichting specifiek</sch:title>
		<sch:rule context="tekst:Toelichting[not(parent::tekst:BesluitCompact | parent::tekst:BesluitKlassiek)]">
			<sch:p>ontraden buiten Besluit: De Toelichting heeft een structuur met Divisie of Divisietekst</sch:p>
			<sch:report id="STOP0081" test="child::tekst:Divisie | child::tekst:Divisietekst">
      			{ "code": "STOP0081",
        		  "eId": "<sch:value-of select="@eId"/>" }
      		</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern>
		<sch:rule context="tekst:Toelichting">
			<sch:let name="aantalKinderen" value="count(tekst:ArtikelgewijzeToelichting | tekst:AlgemeneToelichting)"/>
			<sch:p>Toelichting moet een Kop hebben indien meer dan 1 Toelichting onderdelen</sch:p>
			<sch:report id="STOP0084" test="xs:int($aantalKinderen) &gt;1 and not(child::tekst:Kop)">
      			{ "code": "STOP0084",
        		  "eId": "<sch:value-of select="@eId"/>" }   
      		</sch:report>
			
			<sch:p>Toelichting mag geen Kop hebben indien slechts 1 Toelichting onderdeel</sch:p>
			<sch:report id="STOP0085" test="xs:int($aantalKinderen) = 1 and child::tekst:Kop">
      			{ "code": "STOP0085",
        		  "eId": "<sch:value-of select="@eId"/>",
        		  "localName": "<sch:value-of select="local-name(child::tekst:*[2])"/>" }         
      		</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_082">
		<sch:title>ArtikelgewijzeToelichting buiten Toelichting</sch:title>
		<sch:rule context="tekst:ArtikelgewijzeToelichting[not(ancestor::tekst:Verwijder | ancestor::tekst:Vervang | ancestor::tekst:VoegToe)]">
			<sch:p>Een ArtikelgewijzeToelichting geplaatst buiten een element Toelichting</sch:p>
			<sch:assert id="STOP0082" test="parent::tekst:Toelichting">
      { "code": "STOP0082",
        "eId": "<sch:value-of select="@eId"/>" }      
      </sch:assert>      
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_096">
		<sch:title>Ontraden toelichting binnen RegelingKlassiek</sch:title>
		<sch:rule context="tekst:Toelichting[parent::tekst:RegelingKlassiek] | tekst:ArtikelgewijzeToelichting[parent::tekst:RegelingKlassiek]">
			<sch:report id="STOP0096" test=".">
      			{ "code": "STOP0096",
      			  "element": "<sch:value-of select="local-name()"/>",
        		  "wId": "<sch:value-of select="@wId"/>" }
      		</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_089">
		<sch:title>Vaste @eId's en @wId's zonder toevoeging</sch:title>
		<sch:rule context="tekst:Lichaam | tekst:RegelingOpschrift | tekst:Aanhef | tekst:Sluiting | tekst:Toelichting | tekst:ArtikelgewijzeToelichting | tekst:AlgemeneToelichting | tekst:Motivering | tekst:Inhoudsopgave">
			<sch:p>eId/wId van een element met een vaste identificatie mag geen voor- of toevoegingen hebben. Alleen wanneer het Sluiting is, of als het verwijderd moet worden mag het voorzien zijn van een '_instX'</sch:p>
			<sch:let name="patroon" value="'^(body|formula_1|formula_2|longTitle|recital|genrecital|artrecital|acc|toc)$'"/>
			<sch:let name="vpatroon" value="'^(formula_1|formula_2|longTitle|recital|genrecital|artrecital|acc|toc)_inst[0-9]+$'"/>
			<sch:let name="mijnNaam">
				<xsl:choose>
					<xsl:when test="self::tekst:Lichaam">body</xsl:when>
					<xsl:when test="self::tekst:RegelingOpschrift">longTitle</xsl:when>
					<xsl:when test="self::tekst:Aanhef">formula_1</xsl:when>
					<xsl:when test="self::tekst:Sluiting">formula_2</xsl:when>
					<xsl:when test="self::tekst:Toelichting">recital</xsl:when>
					<xsl:when test="self::tekst:ArtikelgewijzeToelichting">artrecital</xsl:when>
					<xsl:when test="self::tekst:AlgemeneToelichting">genrecital</xsl:when>
					<xsl:when test="self::tekst:Motivering">acc</xsl:when>
					<xsl:when test="self::tekst:Inhoudsopgave">toc</xsl:when>
				</xsl:choose>
			</sch:let>
			<sch:let name="wIdtoevoeging">
				<xsl:choose>
					<xsl:when test="self::tekst:Sluiting">
						<xsl:value-of select="replace(substring-after(@wId, 'formula_2'), '^_inst[0-9]+', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-after(@wId, $mijnNaam)"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0089" test="matches(@wId, $patroon) or 
        ((ancestor::tekst:Verwijder or ancestor::tekst:*[@wijzigactie='verwijder'] or self::tekst:Sluiting) and matches(@wId,$vpatroon))">
				{
				"code": "STOP0089",
				"wId": "<sch:value-of select="@wId"/>",
				"element": "<sch:value-of select="local-name()"/>",
				"toevoeging": "<sch:value-of select="$wIdtoevoeging"/>",
				"voorvoeging": "<sch:value-of select="substring-before(@wId, $mijnNaam)"/>" }
			</sch:assert>

			<sch:let name="eIdtoevoeging">
				<xsl:choose>
					<xsl:when test="self::tekst:Sluiting">
						<xsl:value-of select="replace(substring-after(@eId, 'formula_2'), '^_inst[0-9]+', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-after(@eId, $mijnNaam)"/>
					</xsl:otherwise>
				</xsl:choose>
			</sch:let>
			<sch:assert id="STOP0090" test="matches(@eId, $patroon) or 
        ((ancestor::tekst:Verwijder or ancestor::tekst:*[@wijzigactie='verwijder'] or self::tekst:Sluiting) and matches(@eId,$vpatroon))">
				{
				"code": "STOP0090",
				"eId": "<sch:value-of select="@eId"/>",
				"element": "<sch:value-of select="local-name()"/>",
				"toevoeging": "<sch:value-of select="$eIdtoevoeging"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_091">
		<sch:title>@eId begint met @eId voorouder</sch:title>
		<sch:rule context="tekst:*[@eId][not(parent::tekst:Vervang or parent::tekst:Verwijder or parent::tekst:VoegToe or parent::tekst:*[@wijzigactie='verwijderContainer'] or ancestor::tekst:WijzigInstructies)]">
			<sch:p>@eId moet beginnen met het @eId van het eerste bovenliggende element met een @eId
				Tenzij het een eId van een top-element in een renvooi mutatie of 
				een niet-top-element in een renvooi mutatie waarvan de parent verwijderd wordt met 'verwijderContainer'.
				Dan kan de eId niet gecontroleerd worden als onderdeel van de mutatie</sch:p>			
			<sch:let name="ancestorID" value="ancestor::tekst:*[@eId][1]/@eId"/>
			<!-- rest van eId zonder parent moet beginnen met __ -->
			<sch:let name="rest" value="substring-after(@eId, $ancestorID)"/>
			<!-- Controle is alleen zinvol wanneer de eId '__' bevat, want alleen dan afhankelijk van de ouder. -->
			<sch:report id="STOP0091" test="contains(@eId, '__') and (not(starts-with($rest, '__')) or not(starts-with(@eId, $ancestorID)))">
				{
				"code": "STOP0091",
				"eId": "<sch:value-of select="@eId"/>",
				"element": "<sch:value-of select="local-name()"/>",
				"topId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>",
				"topElement": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_0097">
		<sch:title>strong en u ontraden in koppen</sch:title>
		<sch:rule context="tekst:u[ancestor::tekst:Opschrift | ancestor::tekst:Subtitel |  ancestor::tekst:Tussenkop | ancestor::tekst:title | ancestor::tekst:Titel[parent::tekst:Figuur]] | 
			tekst:strong[ancestor::tekst:Opschrift | ancestor::tekst:Subtitel | ancestor::tekst:Tussenkop | ancestor::tekst:title | ancestor::tekst:Titel[parent::tekst:Figuur]]">
			<sch:report id="STOP0097" test=".">
				{
				"code": "STOP0097",
				"element": "<sch:value-of select="local-name()"/>",
				"parent": "<sch:value-of select="local-name(..)"/>",
				"top-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>",
				"topElement": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0101">
		<sch:title>RegelingKlassiek - InwerkingtredingArtikel toegestaan</sch:title>
		<sch:rule context="tekst:InwerkingtredingArtikel">
			<sch:assert id="STOP0101" test="ancestor::tekst:RegelingKlassiek">
				{
				"code": "STOP0101",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0105">
		<sch:title>Formule, Figuur niet binnen Noot</sch:title>
		<sch:rule context="tekst:Formule[ancestor::tekst:Noot] | tekst:Figuur[ancestor::tekst:Noot]">
			<sch:report id="STOP0105" test=".">
				{
				"code": "STOP0105",
				"element": "<sch:value-of select="local-name(.)"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0106">
		<sch:title>Formule, Figuur, table niet Aanhef</sch:title>
		<sch:rule context="tekst:Formule[ancestor::tekst:Aanhef] | tekst:Figuur[ancestor::tekst:Aanhef] | tekst:table[ancestor::tekst:Aanhef]">
			<sch:report id="STOP0106" test=".">
				{
				"code": "STOP0106",
				"element": "<sch:value-of select="local-name(.)"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0107">
		<sch:title>Formule, Figuur, table niet Rectificatietekst</sch:title>
		<sch:rule context="tekst:Formule[ancestor::tekst:Rectificatietekst] | tekst:Figuur[ancestor::tekst:Rectificatietekst] | tekst:table[ancestor::tekst:Rectificatietekst]">
			<sch:assert id="STOP0107" test="ancestor::tekst:RegelingMutatie or ancestor::tekst:BesluitMutatie">
				{
				"code": "STOP0107",
				"element": "<sch:value-of select="local-name(.)"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0108">
		<sch:title>Formule, Figuur, table niet Definitie</sch:title>
		<sch:rule context="tekst:Formule[ancestor::tekst:Definitie] | tekst:Figuur[ancestor::tekst:Definitie] | tekst:table[ancestor::tekst:Definitie]">
			<sch:report id="STOP0108" test=".">
				{
				"code": "STOP0108",
				"element": "<sch:value-of select="local-name(.)"/>",
				"eId": "<sch:value-of select="@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0109">
		<sch:title>i niet recursief</sch:title>
		<sch:rule context="tekst:i[ancestor::tekst:i]">
			<sch:report id="STOP0109" test=".">
				{
				"code": "STOP0109",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0110">
		<sch:title>u niet recursief</sch:title>
		<sch:rule context="tekst:u[ancestor::tekst:u]">
			<sch:report id="STOP0110" test=".">
				{
				"code": "STOP0110",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0111">
		<sch:title>strong niet recursief</sch:title>
		<sch:rule context="tekst:strong[ancestor::tekst:strong]">
			<sch:report id="STOP0111" test=".">
				{
				"code": "STOP0111",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0112">
		<sch:title>b niet recursief</sch:title>
		<sch:rule context="tekst:b[ancestor::tekst:b]">
			<sch:report id="STOP0112" test=".">
				{
				"code": "STOP0112",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0113">
		<sch:title>link niet in een andere link</sch:title>
		<sch:rule context="tekst:ExtRef | tekst:ExtIoRef | tekst:IntIoRef | tekst:IntRef |tekst:Contact">
			<sch:report id="STOP0113" test="ancestor::tekst:IntIoRef or ancestor::tekst:IntRef or ancestor::tekst:ExtRef">
				{
				"code": "STOP0113",
				"element": "<sch:value-of select="node-name(.)"/>",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0114">
		<sch:title>noot niet recursief</sch:title>
		<sch:rule context="tekst:Noot">
			<sch:report id="STOP0114" test="ancestor::tekst:Noot">
				{
				"code": "STOP0114",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0115">
		<sch:title>InlineTekstAfbeelding bij voorkeur niet gebruiken</sch:title>
		<sch:rule context="tekst:InlineTekstAfbeelding">
			<sch:report id="STOP0115" test=".">
				{
				"code": "STOP0115",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0116">
		<sch:title>Redactioneel bij voorkeur niet gebruiken</sch:title>
		<sch:rule context="tekst:Redactioneel">
			<sch:report id="STOP0116" test=".">
				{
				"code": "STOP0116",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern id="sch_tekst_0117">
		<sch:title>IntRef bij voorkeur niet in een kop</sch:title>
		<sch:rule id='STOP0117' context="tekst:IntRef[ancestor::tekst:Kop | ancestor::tekst:Tussenkop | ancestor::tekst:title | ancestor::tekst:Figuur/tekst:Title]">
			<sch:report test=".">
				{
				"code": "STOP0117",
				"ref": "<sch:value-of select="@ref"/>",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_0129">
		<sch:title>NogNietInWerking niet gebruiken</sch:title>
		<sch:rule context="tekst:NogNietInWerking">
			<sch:report id="STOP0129" test=".">
				{
				"code": "STOP0129",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	
	<sch:pattern id="sch_tekst_0140">
		<sch:title>InleidendeTekst bij voorkeur niet gebruiken</sch:title>
		<sch:rule context="tekst:InleidendeTekst">
			<sch:report id="STOP0140" test=".">
				{
				"code": "STOP0140",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_0141">
		<sch:title>ExtRef bij voorkeur niet in een kop</sch:title>
		<sch:rule context="tekst:ExtRef[ancestor::tekst:Kop | ancestor::tekst:Tussenkop | ancestor::tekst:title | ancestor::tekst:Figuur/tekst:Title]">
			<sch:report id="STOP0141" test=".">
				{
				"code": "STOP0141",
				"ref": "<sch:value-of select="@ref"/>",
				"parent": "<sch:value-of select="node-name(ancestor::tekst:*[@eId][1])"/>",
				"parent-eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>"}
			</sch:report>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_0142">
		<sch:title>RegelingOpschrift Klassiek: bij voorkeur in BesluitKlassiek</sch:title>
		<sch:rule context="tekst:BesluitKlassiek">
			<sch:assert id='STOP0142' test="child::tekst:RegelingOpschrift">
				{
				"code": "STOP0142",
				"wordt": "<sch:value-of select="./tekst:RegelingKlassiek/@wordt"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<sch:pattern id="sch_tekst_0143">
		<sch:title>RegelingOpschrift Klassiek aanwezig</sch:title>
		<sch:rule context="tekst:BesluitKlassiek">
			<sch:assert id='STOP0143' test="descendant::tekst:RegelingOpschrift">
				{
				"code": "STOP0143",				
				"wordt": "<sch:value-of select="./tekst:RegelingKlassiek/@wordt"/>"}
			</sch:assert>
		</sch:rule>
	</sch:pattern>

</sch:schema>
