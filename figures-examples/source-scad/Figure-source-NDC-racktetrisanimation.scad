UnitArray=[19*2.54*10,32*2.54*10,1.75*2.54*10];
/*
* This array represents x,y,z locations that the crane
* moves to.  Note that the array is doubly indexed.  So that creates
* an array of vectors. Which are themselves an array of three
*/
loc0 = [
    [0,0,0],
    [0,300,0],
    [0,600,0],
    [0,1000,0],
    [0,1000,300],
    [0,1000,600],
    [0,1000,1000],
    [300,1000,1000],
    [600,1000,1000],
    [1000,1000,1000],
    [1000,1000,600],
    [1000,1000,300],
    [1000,1000,0],
    [1000,600,0],
    [1000,300,0],
    [1000,0,0],
    [1000,000,0],
    [1000,000,0],
    [1000,000,0],
    [1000,000,0]
      ];
 loc1 = [
    [1000,0,000],
    [1000,300,200],
    [1000,600,200],
    [1000,1000,200],
    [1000,1000,200],
    [1000,1000,500],
    [1000,1000,700],
    [1000,1000,900],
    [1000,1000,1100],
    [600,1000,1100],
    [300,1000,1100],
    [0,1000,1100],
    [0,1000,700],
    [0,1000,300],
    [0,1000,0],
    [0,600,0],
    [0,300,0],
    [0,0,0],
    [0,0,0],
    [0,0,0]
  
      ];


/*
* This is the secret sauce.  The lookup function does interpolations
* between entries.  A lookup table has a series of keys and values.
* The keys must be monotonic. That is they all increase in value from
* one to the next or they all decrease in value.  Then when a key is
* passed that is in between two key values.  The lookup function
* interpolates between the two.
*
* The key values are given values from 0 to 1 by dividing by the 
* len of the array of vectors.  This makes the keys represent
* possible values of $t.  The values are points in the loc array.
*
* The lookup table can have variables as values.  So we effectively
* have three lookup tables. See below for example with constants.
*
* 
*/
function xyz0(t,i) = 
    lookup(t, [
    [0/len(loc0),loc0[0][i]],
    [1/len(loc0),loc0[1][i]],
    [2/len(loc0),loc0[2][i]],
    [3/len(loc0),loc0[3][i]],
    [4/len(loc0),loc0[4][i]],
    [5/len(loc0),loc0[5][i]],
    [6/len(loc0),loc0[6][i]],
    [7/len(loc0),loc0[7][i]],
    [8/len(loc0),loc0[8][i]],
    [9/len(loc0),loc0[9][i]],
    [10/len(loc0),loc0[10][i]],
    [11/len(loc0),loc0[11][i]],
    [12/len(loc0),loc0[12][i]],
    [13/len(loc0),loc0[13][i]],
    [14/len(loc0),loc0[14][i]],
    [15/len(loc0),loc0[15][i]],
    [16/len(loc0),loc0[16][i]],
    [17/len(loc0),loc0[17][i]],
    [18/len(loc0),loc0[18][i]],
    [19/len(loc0),loc0[19][i]],
    [20/len(loc0),loc0[20][i]],
]);
function xyz1(t,i) = 
    lookup(t, [
    [0/len(loc1),loc1[0][i]],
    [1/len(loc1),loc1[1][i]],
    [2/len(loc1),loc1[2][i]],
    [3/len(loc1),loc1[3][i]],
    [4/len(loc1),loc1[4][i]],
    [5/len(loc1),loc1[5][i]],
    [6/len(loc1),loc1[6][i]],
    [7/len(loc1),loc1[7][i]],
    [8/len(loc1),loc1[8][i]],
    [9/len(loc1),loc1[9][i]],
    [10/len(loc1),loc1[10][i]],
    [11/len(loc1),loc1[11][i]],
    [12/len(loc1),loc1[12][i]],
    [13/len(loc1),loc1[13][i]],
    [14/len(loc1),loc1[14][i]],
    [15/len(loc1),loc1[15][i]],
    [16/len(loc1),loc1[16][i]],
    [17/len(loc1),loc1[17][i]],
    [18/len(loc1),loc1[18][i]],
    [19/len(loc1),loc1[19][i]],
    [20/len(loc1),loc1[20][i]],
]);

/*
* I am showing these as an example of one variable in the lookup
* table.  This approach is fine if one has one variable or several
* unrelated variables.  Because x,y, and z represent points that the
* effector is being moved to, the array approach is easier to make
* changes to the path.
*/
/*
function X(t) = 
    lookup(t, [
    [0/len(loc),0],
    [1/len(loc),50],
    [2/len(loc),-50],
    [3/len(loc),-50],
    [4/len(loc),40],
    [5/len(loc),40],
    [6/len(loc),50],
    [7/len(loc),0],

]);function Y(t) = 
    lookup(t, [
    [0/len(loc),0],
    [1/len(loc),50],
    [2/len(loc),50],
    [3/len(loc),-50],
    [4/len(loc),-40],
    [5/len(loc),40],
    [6/len(loc),0],
    [7/len(loc),0],

]);function Z(t) = 
    lookup(t, [
    [0/len(loc),10],
    [1/len(loc),10],
    [2/len(loc),50],
    [3/len(loc),10],
    [4/len(loc),30],
    [5/len(loc),10],
    [6/len(loc),40],
    [7/len(loc),10],

]);
*/

//Call the main module with variables that depend on $t
Unit(xyz0($t,0),xyz0($t,1),xyz0($t,2),[1-1*$t,$t,0]);
Unit(xyz1($t,0),xyz1($t,1),xyz1($t,2),[$t,1-1*$t,0]);
translate([-10,0,-1000]) color([0,1,0],0.2) cube([20*2.54*10,33*2.54*10,2000]);
translate([990,0,-1000]) color([1,0,0],0.2) cube([20*2.54*10,33*2.54*10,2000]);

module Unit(x,y,z,c)
{
    color(c)
    translate([x,y,z])
    cube(UnitArray);
}

//the LAST two lines are the commands to make the STL and the png. last line makes PNG and second last line makes STL
//converting dumped images from animation to mpeg:
//convert -quality 100 frame*.png outputfile.mpeg
//to get the last line do: (exec $(tail -n1 filename))
//to get the second last line do: (exec $(tail -n2 filename|head -n1))

//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --render -o Figure-source-NDC-racktetrisanimation.stl Figure-source-NDC-racktetrisanimation.scad
//Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o Figure-source-NDC-racktetrisanimation.png --colorscheme=Tomorrow --imgsize=1220,1080 --camera=988,464,55,68,0,206,8172 Figure-source-NDC-racktetrisanimation.scad