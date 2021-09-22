//Script to create a DC RU Rack
//Author Sean Donnellan
//VERSION 0.0.2

//The follwoing are extras that can be included or just comment out the include line and they disapear from the rendering
module raisedFloor(){
    echo("WARNING: raised floor details are included in an additional scad file");
}
RaisedFloorColor=[0,0,0];
//comment the next line to hide the raisedfloor details
include <include-scad-DCRaisedFloor.scad>;
module DCfloor(){
    echo("WARNING: Floor details are included in an additional scad file");
}
//the DCfloor module also calls the raised floor module so disabling this also removes the raised floor supports if they're being shown.
//comment the next line to hide the raisedfloor details
include <include-scad-DCFloor.scad>;
include <include-scad-floatLabel.scad>;
//define empty modules in case we comment out one. All loaded in the include that follows.
module sprinkler();
module power();
module lighting();
include <include-scad-power-lighting-sprinkler.scad>;
//Global Variables for the DC (Universally one DC floor will not mix tile types)
    //openscad calculates in mm
    //an inch is 2.54cm
    //factor is times 2.54 to get to cm and then times ten to make mm
    Factor=2.54 * 10;
    //Srandard 19" rack has 1.75 inches per RU - convert to mm
    StandardRackUnitHeight=1.75 * Factor;

module rackStrutX(RackFrameThickness,RackWidth,Color){
    //all measurements in mm
    color(Color,0.8)
    cube([RackWidth,RackFrameThickness,RackFrameThickness]);
}
module rackStrutZ(RackFrameThickness,RackDepth,Color){
    //all measurements in mm
    color(Color,0.8)
    cube([RackFrameThickness,RackDepth,RackFrameThickness]);
}
module rackStrutY(RackFrameThickness,RackHeight,Color){
    //all measurements in mm
    color(Color,0.8)
    cube([RackFrameThickness,RackFrameThickness,RackHeight]);
}
module rackFrame(Rx,Ry,Rz,St,Rc){
        //Rx RackWidth, Ry RackHeight, Rz RackDepth, St StrutThickness, Rc RackColor
    union(){
        //fornat and back Struts
        translate ([0,0,0]) rackStrutX(St,Rx,Rc);
        translate ([0,Rz-St,0]) rackStrutX(St,Rx,Rc);
        translate ([0,Rz-St,Ry-St]) rackStrutX(St,Rx,Rc);
        translate ([0,0,Ry-St]) rackStrutX(St,Rx,Rc);
        //Side Struts
        translate ([0,0,0]) rackStrutZ(St,Rz,Rc);
        translate ([Rx-St,0,0]) rackStrutZ(St,Rz,Rc);
        translate ([Rx-St,0,Ry-St]) rackStrutZ(St,Rz,Rc);
        translate ([0,0,Ry-St]) rackStrutZ(St,Rz,Rc);
        //Uprights
        translate ([0,0,0]) rackStrutY(St,Ry,Rc);
        translate ([0,Rz-St,0]) rackStrutY(St,Ry,Rc);
        translate ([Rx-St,Rz-St,0]) rackStrutY(St,Ry,Rc);
        translate ([Rx-St,0,0]) rackStrutY(St,Ry,Rc);
    }
}
module positionRack(FloorOffset,RackWidth,RackHeight,RackDepth,RackFrameThickness,RackColor){
    translate(FloorOffset) rackFrame(RackWidth,RackHeight,RackDepth,RackFrameThickness,RackColor);
}
module rackUnitSolid(RUx,RUy,RUz,RUc){
    color(RUc)
    cube([RUx,RUz,RUy]);
}
module embossLabel(Label){
    TextDepth=20; //how deep to extrude the text so positioning in device and extruding out
    translate ([10,TextDepth,10]) rotate([90,0,0]) linear_extrude(height=TextDepth){
            text(Label, size=30);
    }
}
module multiRackUnit(RackUnitWidth,RackUnitHeight,RackUnitDepth,RackUnitColor,Label){
    difference(){
        rackUnitSolid(RackUnitWidth,RackUnitHeight,RackUnitDepth,RackUnitColor);
        //render the labe embossed
        embossLabel(Label);
        }
        floatLabel(Label,FloatLabelColor,30,LabelT);
}
module placeInRack(RUp,RackUnitWidth,RackUnitHeight,RackUnitDepth,RackUnitColor,Label){
    translate([XWiggle/2,ZWiggle/2,RUp * StandardRackUnitHeight]) multiRackUnit(RackUnitWidth,RackUnitHeight,RackUnitDepth,RackUnitColor,Label);
}
//DC Floor - included in external scad files and modules
//square floor numtiles x numtiles
RaisedFloorHeight=900;
RaisedFloorTransparency=0.8;
 union(){
    DCfloor(6,5,FloorColor,RaisedFloorTransparency,RaisedFloorHeight);
 }
// per Rack stuff
    NumRackUnits=42; //is a multiplication factor so no conversion
    //19 Inches converted to mm
    StandardRackUnitWidth=19 * Factor;
    //37 inches converted to mm BUT can now be per device was global
    RackUnitDepth=30 * Factor;
    //inches to mm
    RackWidth=800;
    //inches to mm
    //RackDepth=45 * Factor;
    RackDepth=800;
    //height is calculated from Rack units here. so 44RUs times RU height = n mm
    //RackHeight=44 * StandardRackUnitHeight;
 //rackheight CPL/ZPL 2070mm
 //standardrackheight NDC 2000mm
 //standard rack depth and width 800mm
    RackHeight=2000;
    //max height in DC=2200mm
    //no conversion required as works with converted units
    NetRackHeight=StandardRackUnitHeight * NumRackUnits;
    XWiggle=RackWidth - StandardRackUnitWidth;
    ZWiggle=RackDepth - RackUnitDepth;
    YWiggle=RackHeight - NetRackHeight;
    OffsetInRack=[ XWiggle/2 , ZWiggle/2 , 0];
    // this one is in mm as it's decoration only
    RackFrameThickness=20;
    RackColor=[5/255, 5/255, 5/255];
    FloatLabelColor=[255/255, 255/255, 255/255];
    FloatLabelColorTitle=[255/255, 0/255, 0/255];
    LabelT=1;
    RackUnitColor=[100/255, 100/255, 100/255];
    RackUnitColorRed=[200/255, 100/255, 100/255];
    RackUnitColorGreen=[100/255, 200/255, 100/255];
    RackUnitColorBlue=[100/255, 100/255, 200/255];
//first row
    RowOffset0=[1*600,2*600,0];
    DCFloorOffset0=[RackWidth*0,0,0]+RowOffset0;
    DCFloorOffset1=[RackWidth*1,0,0]+RowOffset0;
    DCFloorOffset2=[RackWidth*2,0,0]+RowOffset0;

    //invisible rack for animation
    DCFloorOffset1000=[RackWidth*0,-RackDepth*$t,0]+RowOffset0;
    DCFloorOffset1001=[RackWidth*1,-RackDepth*$t,0]+RowOffset0;
    DCFloorOffset1002=[RackWidth*2,-RackDepth*$t,0]+RowOffset0;
    //Racks
    positionRack(DCFloorOffset0,RackWidth,RackHeight,RackDepth,RackFrameThickness,RackColor);
    positionRack(DCFloorOffset1,RackWidth,RackHeight,RackDepth,RackFrameThickness,RackColor);
    positionRack(DCFloorOffset2,RackWidth,RackHeight,RackDepth,RackFrameThickness,RackColor);

//Device Stuff
//Place extra side components in rack 0
    translate(DCFloorOffset0-[-35,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
    translate(DCFloorOffset0-[-653.6,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
//place devices in the rack 0
    translate(DCFloorOffset0-[0,100,0])
        placeInRack(1,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset0-[0,100,0])
        placeInRack(3,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset0)
        placeInRack(5,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
    translate(DCFloorOffset0-[0,100,0])
        placeInRack(11,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset0-[0,100,0])
        placeInRack(13,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset0)
        placeInRack(15,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset0-[0,100,0])
        placeInRack(21,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset0-[0,100,0])
        placeInRack(23,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset0)
        placeInRack(25,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset0-[0,100,0])
        placeInRack(31,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset0-[0,100,0])
        placeInRack(33,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset0)
        placeInRack(35,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset0-[0,100,0])
        placeInRack(41,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
 //Place extra side components in rack 1
    translate(DCFloorOffset1-[-35,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
    translate(DCFloorOffset1-[-653.6,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
 //place devices in the rack 1
    translate(DCFloorOffset1-[0,100,0])
        placeInRack(1,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(3,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset1001)
        placeInRack(5,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorBlue,"6*RU Fibre Panel(s)");
     translate(DCFloorOffset1-[0,100,0])
        placeInRack(11,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(13,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
     translate(DCFloorOffset1001)
        placeInRack(15,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorBlue,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(21,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(23,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset1001)
        placeInRack(25,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorBlue,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(31,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(33,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset1001)
        placeInRack(35,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorBlue,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset1-[0,100,0])
        placeInRack(41,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
 //Place extra side components in rack 2
    translate(DCFloorOffset2-[-35,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
    translate(DCFloorOffset2-[-653.6,80,-45])
        color(RackUnitColor) cube([110,110,1866.9]);
     //place devices in the rack 2
    translate(DCFloorOffset2-[0,100,0])
        placeInRack(1,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(3,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
    translate(DCFloorOffset2)
        placeInRack(5,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
     translate(DCFloorOffset2-[0,100,0])
        placeInRack(11,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(13,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
     translate(DCFloorOffset2)
        placeInRack(15,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(21,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(23,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset2)
        placeInRack(25,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(31,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(33,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");
            translate(DCFloorOffset2)
        placeInRack(35,StandardRackUnitWidth,6*StandardRackUnitHeight,RackUnitDepth/2,RackUnitColorGreen,"6*RU Fibre Panel(s)");
        translate(DCFloorOffset2-[0,100,0])
        placeInRack(41,StandardRackUnitWidth,2*StandardRackUnitHeight,RackUnitDepth*.15,RackUnitColor,"Cable Guide");


//example power Lights and sprinkler at proper heights as verified by joachim Luft
power("Power",FloatLabelColorTitle,LabelT,0,3*600+500,2790,6*600);
lighting("Lighting",FloatLabelColorTitle,LabelT,0,600,2560,6*600);
sprinkler("Sprinkler",FloatLabelColorTitle,LabelT,0,2*600+400,2860,6*600);

translate([110,0,0]) floatLabel("NDC programme example diagrams - Author: Sean Donnellan",FloatLabelColorTitle,60,LabelT);

//camera settings for Openscad GUI animation - Animation in CLI needs the last two comments at then end of the file
$vpt = [1558, 1683, 1170];
$vpr = [$t*5-275, 0, $t*180+210];
$vpd = 9072;
//the LAST two lines are the commands to make the STL and the png. last line makes PNG and second last line makes STL
//converting dumped images from animation to mpeg:
//convert -quality 100 frame*.png outputfile.mpeg
//to get the last line do: (exec $(tail -n1 filename))
//to get the second last line do: (exec $(tail -n2 filename|head -n1))
//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --render -o Figure-source-PAA-Lab-Rack-Layout.stl Figure-source-PAA-Lab-Rack-Layout.scad
//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Figure-source-PAA-Lab-Rack-Layout.png --colorscheme=Tomorrow --imgsize=1220,1080 --camera=1207,249,1090,89,0,359.5,6236  Figure-source-PAA-Lab-Rack-Layout.scad//the LAST two lines are the commands to make the STL and the png. last line makes PNG and second last line makes STL
//converting dumped images from animation to mpeg:
//convert -quality 100 frame*.png outputfile.mpeg
//to get the last line do: (exec $(tail -n1 filename))
//to get the second last line do: (exec $(tail -n2 filename|head -n1))

//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --render -o Figure-source-NDC-CPL-rack.stl Figure-source-NDC-CPL-rack.scad
//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Figure-source-NDC-CPL-rack.png --colorscheme=Tomorrow --imgsize=1220,1080 --camera=1558,1683,1170,89,0,24,9072  Figure-source-NDC-CPL-rack.scad
