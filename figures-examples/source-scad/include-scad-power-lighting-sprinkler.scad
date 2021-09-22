module power(Label,Labelc,LabelT,Xo,Yo,Height,Width,Rt){
    translate([Xo,Yo,Height]){
        color([200/255,200/255,200/255],Rt) cube([Width,50,200]);
        translate([1100,0,100]) floatLabel(Label,Labelc,100,LabelT);
        //power comes from left and right and do not join in the middle
        //3 power rails next to one another
        //A rail and B rail for dual connected devices (PDU)
        //C rail for single cord devices
    }
}
module lighting(Label,Labelc,LabelT,Xo,Yo,Height,Width,Rt){
    translate([Xo,Yo,Height]){
        color([200/255,200/255,200/255],Rt) cube([Width,200,50]);
        translate([80,0,100]) floatLabel(Label,Labelc,100,LabelT);
    }
}
module sprinkler(Label,Labelc,LabelT,Xo,Yo,Height,Width,Rt){
    translate([Xo,2*600+400,2860]){
        union(){
            color([200/255,200/255,200/255],Rt){
                rotate([0,90,0]) cylinder(h=Width,d=50);
                translate([1000,0,0]) rotate([0,0,90]) cylinder(h=400,d=50);
            }
        }
    //there is a 2520mm high pipe linking the sprinler rows.
    translate([500,0,0]) floatLabel(Label,Labelc,100,LabelT);
    }
}
//power("Power Rail A",FloatLabelColorTitle,LabelT,0,2*600+500,2790,20*600,0.1);
//lighting("Lighting Row A",FloatLabelColorTitle,LabelT,0,2*600+500,2560,20*600,0.1);
//sprinkler("Sprinkler Row A",FloatLabelColorTitle,LabelT,0,2*600+400,2860,20*600,0.1);
