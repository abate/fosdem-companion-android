
all:
	wget -q -O wwwguide.xml "$$@" "https://wwwguide.goingnowhere.org/api/events?populate=true&output=catalogue"
	xsltproc wwwguide.xslt wwwguide.xml > nowhere-schedule.xml
	scp nowhere-schedule.xml root@beta.frenchburners.org:/var/www/frenchburners.org/www/

clean:
	rm wwwguide.xml nowhere-schedule.xml
