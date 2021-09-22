//Author Sean Donnellan
//VERSION 0.0.2

module floatLabel(Label,Color,Size,LabelT){
    TextDepth=Size/10; //how deep to extrude the text
    color(Color,LabelT) translate ([10,-30,10]) rotate([90,0,0]) linear_extrude(height=TextDepth){
             text(Label, size=Size);
    }        
}
