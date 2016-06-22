<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:set="http://exslt.org/set"
  xmlns:common="http://exslt.org/common"
  extension-element-prefixes="date set common" >

  <xsl:output method="xml" indent="yes"/>      
  <xsl:key name="groups-day" match="/eventList/events" use="day" />
  <xsl:key name="groups-location" match="/eventList/events" use="location" />
  <xsl:key name="groups-host" match="//events" use="host/text()" />

	<xsl:variable name="groups">
    <xsl:for-each select="//events[generate-id() = generate-id(key('groups-host', host)[1])]">
      <group num="{position()}" val="{host}"/>
    </xsl:for-each>
	</xsl:variable>

  <xsl:template match="/eventList">
		<schedule>
			<conference>
				<title>NOWHERE 2016</title>
				<subtitle/>
				<venue>Nowhere</venue>
				<city>Spain</city>
				<start>2016-07-05</start>
				<end>2016-07-10</end>
				<days>5</days>
				<day_change>04:00:00</day_change>
				<timeslot_duration>00:05:00</timeslot_duration>
			</conference>
     <xsl:apply-templates
      select="events[generate-id() = generate-id(key('groups-day', day)[1])]" mode="day">
      <xsl:sort select="day" data-type="number"/>
`    </xsl:apply-templates>
		</schedule>
  </xsl:template>

  <xsl:template match="events" mode="day">
    <xsl:variable name="day" select='day' /> 
    <day index="{position()}" date="2016-07-{day}">
      <xsl:for-each 
        select="//events[generate-id() = generate-id(key('groups-location', location)[1])]">
        <xsl:variable name="location" select='location' /> 
        <room name="{$location}">
          <xsl:apply-templates
            select="//events[(day=$day) and (location = $location)]" mode="location"/>
        </room>
      </xsl:for-each>
    </day>
  </xsl:template>

  <xsl:template match="events" mode="location">
    <xsl:variable name="duration" select="date:seconds(date:difference(startTime,endTime))"/>
    <event id="{count(preceding-sibling::events)}">
      <start><xsl:value-of select="substring(startTime, 12, 5)"/></start>
      <end><xsl:value-of select="endTime"/></end>
      <duration>
        <xsl:call-template name="format-duration">
          <xsl:with-param name="value" select="$duration" />
        </xsl:call-template>
      </duration>
      <room><xsl:value-of select="location"/></room>
      <slug>this is a slug</slug>
      <title><xsl:value-of select="name"/></title>
      <subtitle>this is a subtitle</subtitle>
      <track><xsl:value-of select="location"/></track>
      <type><xsl:value-of select="category"/></type>
      <language/>
      <abstract><xsl:value-of select="info"/></abstract>
      <description>
        <!--<xsl:value-of select="info"/>-->
      </description>
      <persons>
        <person id="{common:node-set($groups)/group[@val=current()/host]/@num}">
          <xsl:value-of select="host"/>
        </person>
      </persons>
      <!--<links>-->
        <!--<link href=""/>-->
      <!--</links>-->
    </event>
  </xsl:template>

  <xsl:template name="format-duration">
    <xsl:param name="value" select="." />
    <xsl:param name="alwaysIncludeHours" select="true()" />
    <xsl:param name="includeSeconds" select="false()" />

    <xsl:if test="$value > 3600 or $alwaysIncludeHours">
      <xsl:value-of select="concat(format-number($value div 3600, '00'), ':')"/>
    </xsl:if>

    <xsl:value-of select="format-number($value div 60 mod 60, '00')" />

    <xsl:if test="$includeSeconds">
      <xsl:value-of select="concat(':', format-number($value mod 60, '00'))" />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
