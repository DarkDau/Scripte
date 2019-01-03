#!/bin/bash
#
#  Titel: shrink-ma_256k.sh
#  Autor: Bed [@] zockertown.de
#  Web: zockertown.de/s9y/
#  Version 0.4
#  Voraussetzung: Benötigt wird Imagemagick für das Consolentool convert
#  und mogrify
#  Zweck: Die Auflösung der Bilder wird nier nicht verändert. Wenn im Quellbild die
#         Orientierungshinweise intakt sind,
#         wird das Bild korrekt gedreht.
#         Es wird das Bild so komprimierrt, dass es den eingestellten Wert (hier 256KB) nicht überschreitet
#         Dies ist für Foren nützlich, wenn die nur eine begrenzte File_size erlauben
#         Das skalierte Bild wird mit einer Textnotiz versehen, wenn in
#         der Schleife der mogrify disabled wird (durch einfügen des '#')
#         wird das Branding nicht durchgeführt.
count=$(/bin/echo $NAUTILUS_SCRIPT_SELECTED_URIS|wc -w)
teil=$[100 / $count ]
teiler=$teil
( for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do
    file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g' -e 's/.*\///g')
    file_folder=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g' -e "s/$file_name//g")
        convert -auto-orient -strip -define jpeg:extent=1024kb "$file_folder/$file_name" "${file_folder}/${file_name}_max_1024kb.jpg"
        exiftool -tagsFromFile IMG_1857.JPG "$file_folder/$file_name" "${file_folder}/${file_name}_max_1024kb.jpg"
	rm "${file_folder}/${file_name}_max_1024kb.jpg_original"
        teiler=$[$teiler + $teil]
        echo $teiler
    #    mogrify -pointsize 10 -fill gray -gravity SouthWest -draw "text 10,20 'Copyright Bernd Dau'" "${file_folder}/${file_name}_max_256kb.jpg"
done ) | (zenity --progress --percentage=$teil --auto-close)

