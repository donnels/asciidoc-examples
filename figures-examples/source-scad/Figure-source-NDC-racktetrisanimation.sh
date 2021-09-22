#!/bin/bash
sourcefile="Figure-source-NDC-racktetrisanimation.scad"
outputgif="Figure-source-NDC-racktetrisanimation.gif"

OpenScad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
STEPS=100
PATTERN=%04d.png
for a in $(seq 0 $STEPS)
do
        FILE="Frame"$(printf "$PATTERN" $a)
        echo "$FILE"
        $OpenScad --imgsize=1920,1080 --colorscheme=Tomorrow --camera=988,464,55,68,0,206,8172 "-D\$t=$a/$STEPS" -o "$FILE" "$sourcefile"
done

#The following line is for an MP4
#ffmpeg -i Frame"$PATTERN" -c:v libx264 -r 30 -pix_fmt yuv420p animation.mp4
#The folowing line is for inimated GIF
convert -quality 100 Frame* $outputgif
rm Frame*

#The following line is catenated here from a tail -n1 from the scad
#//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Figure-source-NDC-racktetrisanimation.png --colorscheme=Tomorrow --imgsize=1220,1080 --camera=988,464,55,68,0,206,8172 Figure-source-NDC-racktetrisanimation.scad
