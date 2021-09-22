#!/bin/bash

sourcefile="Figure-source-NDC-example.scad"
outputgif="Figure-source-NDC-example.gif"
OpenScad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
STEPS=100
animationvalue=180
PATTERN=%04d.png
#$vpt = [1558, 1683, 1170];
#$vpr = [$t*5-275, 0, $t*180+210];
#$vpd = 9072;

for a in $(seq 0 $STEPS)
do
        FILE="Frame"$(printf "$PATTERN" $a)
        degrees=$(($animationvalue * $a/$STEPS))
	degrees=$(($degrees + 210))
        echo "$FILE"
        $OpenScad \
                --imgsize=1820,1080 \
	              --colorscheme=Tomorrow \
                --camera=1558,1683,1170,-270,0,$degrees,9072 \
                "-D\$t=$a/$STEPS" \
                -o "$FILE" "$sourcefile"
done

#The following line is for an MP4
#ffmpeg -i Frame"$PATTERN" -c:v libx264 -r 30 -pix_fmt yuv420p animation.mp4

#The folowing line is for inimated GIF
convert -quality 100 Frame* $outputgif
rm Frame*
