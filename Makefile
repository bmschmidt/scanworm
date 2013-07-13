webDirectory=/Library/Webserver/Documents
project=Printers

all: $(webDirectory)/bookreader $(webDirectory)/images/$(project)/bookreader

$(webDirectory)/images/$(project): $(webDirectory)/bookreader
	mkdir -p $(webDirectory)/images
	mkdir -p $(webDirectory)/images/$(project)

$(webDirectory)/bookreader:
	git clone https://github.com/openlibrary/bookreader
	mv bookreader $(webDirectory)

$(webDirectory)/images/$(project)/bookreader: $(webDirectory)/images/$(project)/list.html $(webDirectory)/bookreader
	find $(webDirectory)/images/$(project)/ -type d | xargs -I volumename cp $(webDirectory)/bookreader/bookreaderDemo/* volumename
	cp -r $(webDirectory)/bookreader/bookreader $(webDirectory)/images/$(project)


#Dummy file: this converts every tif into a hierarchically structured jpg file.
$(webDirectory)/images/$(project)/list.html:
#find -print0 pdfs | sed 's/.*\///; s/.pdf//' | xargs -0 -I volume -P 4 -n 1 sh scripts/convertTifTreeToWebJPGs.sh volume
	touch $(webDirectory)/images/$(project)/list.html


#UPDATE catalog SET searchstring=CONCAT('<a href="http://localhost/images/Printers/',volume,'/#page/',page,'/mode/2up">Volume ', volume,' Page ', page, '</a>');