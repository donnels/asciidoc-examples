module raisedFloor(FSc,RFh,FSd,FCd,FTOx,FTOy,FTh){
	FloorCarrierAndTileHeight=FCd+FTh;
	SupportHeight=RFh-FloorCarrierAndTileHeight;
	SupportOffset=SupportHeight+FloorCarrierAndTileHeight;
	union(){
    		translate([0,0,-SupportOffset])
    			color(FSc) floorSupports(FSc,SupportHeight,FSd,FTOx,FTOy);
    		color(FSc)
    			translate([0,0,-FTh]) floorTileCarriers(FCd,FTOx,FTOy);
	}
}
module floorCarrier(FCd,FCl){
	translate([FCd/2,-FCd/2,-FCd]) cube([FCl-FCd,FCd,FCd]);
}
module floorTileCarriers(FTCd,FTOx,FTOy){
        floorCarrier(FTCd,FTOx);
        translate([0,FTOy,0]) floorCarrier(FTCd,FTOx);
        rotate([0,0,90]) floorCarrier(FTCd,FTOy);
        translate([FTOx,0,0]) rotate([0,0,90]) floorCarrier(FTCd,FTOy);
}
module floorSupports(FSc,FSh,FSd,FTOx,FTOy){
        color(FSc){
            floorSupport(FSh,FSd);
            translate([FTOx,0,0]) floorSupport(FSh,FSd);
            translate([0,FTOy,0]) floorSupport(FSh,FSd);
            translate([FTOx,FTOy,0]) floorSupport(FSh,FSd);
        }
    }
module floorSupport(FSh,FSd) {
	union(){
		cylinder(h=FSh,d=FSd);
        	cylinder(h=50, r1=FSd, r2=0);
        	translate([0,0,FSh-50]) cylinder(h=50, r1=0, r2=FSd);
	}
}
//The following variables are examples
//uncomment the following lines to render a floortileraisedfloorsupport
//RaisedFloorHeight=500;
//FTOx=600;
//FTOy=600;
//FloorDepth=40;
//raisedFloor([0,0,0],RaisedFloorHeight,FloorCarrierDiameter,FTOx,FTOy,FloorDepth);
//The RaisedFloorColor Variable has been included here to get all raised floor stuff out of the main scad file. Modify it here.
RaisedFloorColor=[150/255, 150/255, 150/255];
FSd=60;
