module floorTile(Ft,Ftc,Ftt){
	color(Ftc,Ftt) cube(Ft);
}
module DCfloor(NumTilesX,NumTilesY,Color,Transparency,RaisedFloorHeight){
	//EMEA Floor tiles are 600mm x 600mm The tile spaceing is left at 600
	//and the tile itsel can be made smaller for effect (leave spaces between tiles)
	FloorTileHeight=40;
	FloorTileGap=10;
	FloorTileXOffset=600;
	FloorTileYOffset=600;
	//Variables used for the raisedfloor include
	//RaisedFloorHeight=500;
	RaisedFloorStrutDiameter=60;
	FloorCarrierDiameter=60;
	FloorTile=[FloorTileXOffset - FloorTileGap,FloorTileYOffset - FloorTileGap,FloorTileHeight];
	union(){
        	for (yp=[1:FloorTileYOffset:NumTilesY * FloorTileYOffset]){
            		for (xp=[1:FloorTileXOffset:NumTilesX * FloorTileXOffset]){
                    		translate([xp,yp,0]){
					translate([0,0,-FloorTileHeight]){
                        			floorTile(FloorTile,Color,Transparency);
					}
                        		//comment the next line to hide the raised floor details
                        		raisedFloor(RaisedFloorColor,RaisedFloorHeight,RaisedFloorStrutDiameter,FloorCarrierDiameter,FloorTileXOffset,FloorTileYOffset,FloorTileHeight);
				}
			}
		}
	}
}
FloorColor=[200/255, 200/255, 150/255];
FloorColorHVAC=[100/255, 100/255, 200/255];
FloorColorMaint=[100/255, 100/255, 200/255];
FloorColorEntry=[200/255, 100/255, 100/255];
