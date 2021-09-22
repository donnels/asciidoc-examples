#!/bin/bash
ls -la
#This script remakes the document sources and then the document

#Make the individual Cad files if they are present.
#
echo "making source openscad diagrams"
for file in Figure*.scad; do
	(exec $(tail -n1 "$file"))
done
#Make the plantuml files (network diagrams etc)
#plantuml *.plantuml
echo "making source plantuml diagrams"
for file in *.plantuml; do
	echo "$file"
	plantuml "$file"
done

#Make the PDF and HTML Document
#PDF first because then it's possible to link non animated pngs in for the pdf and then leave the directory with the animated ones in place
#after creating the HTML
#asciidoctor-pdf *.asciidoc
#remove all .link files and then replace them with links to static png
echo "removing .link files and generating links to PNG"
rm *.link
for i in *.gif; do echo $i; suffix=$(echo $i| cut -d"." -f2); name=$(echo $i| cut -d"." -f1); ln -s "$name".png "$name".link; done
echo "making PDF"
for file in *.asciidoc; do
	echo "$file"
	#asciidoctor-pdf "$file"
	docker run -v "$PWD":/documents/ --name asciidoc-to-pdf \
	asciidoctor/docker-asciidoctor asciidoctor-pdf -D /documents/ "$file"
	docker rm asciidoc-to-pdf
done

#asciidoctor *.asciidoc
#remove all .link files and then replace them with links to static png
echo "removing .link files and generating links to animated gif"
rm *.link
for i in *.gif; do echo $i; suffix=$(echo $i| cut -d"." -f2); name=$(echo $i| cut -d"." -f1); ln -s "$name".gif "$name".link; done
echo "making HTML"
for file in *.asciidoc; do
	echo "$file"
	#asciidoctor "$file"
	docker run -v "$PWD":/documents/ --name asciidoc-to-html \
	asciidoctor/docker-asciidoctor asciidoctor -D /documents/ "$file"
	docker rm asciidoc-to-html
done
#The following line creates the STL files and that takes quite a while.
#(exec $(tail -n2 Figure-source-PAA-Lab-Rack-Layout.scad|head -n1))
for file in Figure*.scad; do
	echo "$file"
#	(exec $(tail -n2 "$file"|head -n1))
done
