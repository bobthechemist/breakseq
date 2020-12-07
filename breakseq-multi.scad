// All units in mm
grid_r = 15; // grid radius
base_h = 22; // base height
base_tol = 0.3; // tolerance for base/mesh diameters
base_r = base_tol + grid_r;
base_lip = 5; // height of lip to support mesh
in_port_od = 2.2; //in-port outer diameter
in_port_id = 1.2;  //in-port inner diameter
out_port_od = 7.5;  //out-port outer diameter
out_port_id = 5;  //out-port inner diameter
port_h = 2.5;
in_port_h = 13.5; 
out_port_h = 13.5; 
cport_od = 6.3; //outer diameter of connecting ports
cport_id = 3.8; //inner diameter of connecting ports
port_l = 6; // Length of port
drain = true; // Set to false for no drain

//-------------------------------------------------------------

module multicell(){


//Centered Cell
translate([-0.1,10,0])
difference(){
    //BUILD UP
    union(){
        linear_extrude(base_h)difference(){
            circle(r=base_r+1);circle(r=base_r);
        }
        // Lip
        translate([0,0,base_lip])
        rotate_extrude()translate([1*base_r,0,0])rotate(36,[0,0,1])circle(d=1,$fn=5);
        // Ports
        if(drain){
            //exit port
            translate([base_r,0,out_port_h])
            rotate(90,[0,1,0])
            cylinder(d=out_port_od,h=port_l,$fn=25);
           
         //connecting port 
          translate([-base_r-port_l+2.5,0,port_h])
            rotate(90,[0,1,0])
            cylinder(d=cport_od,h=port_l-3,$fn=25);         

        }
    }
    
    //CUTOUT
    if(drain){
        //exit port
        translate([base_r-1,0,out_port_h])
        rotate(90,[0,1,0])
        cylinder(d=out_port_id,h=port_l+2,$fn=25);
    
        //connecting port
        translate([-base_r-port_l+1.5,0,port_h])
        rotate(90,[0,1,0])
        cylinder(d=cport_id,h=port_l,$fn=25);
        
        //middle cell connecting port cutout
         translate([-20,0,0])
         translate([base_r-1,0,port_h])
         rotate(90,[0,1,0])
         cylinder(d=cport_id,h=port_l,$fn=25);
       
            
    } 
}


//-------------------------------------------------------------
//Middle Cell
translate([-15,10,0])
difference(){
    //BUILD UP
    union(){
          translate([-20,0,0])
        linear_extrude(base_h)difference(){
            circle(r=base_r+1);circle(r=base_r);
        }
        // Lip
          translate([-20,0,0])
        translate([0,0,base_lip])
        rotate_extrude()translate([1*base_r,0,0])rotate(36,[0,0,1])circle(d=1,$fn=5);
        }
    
    
    
    //CUTOUT
    //Ports
    if(drain){
        //connecting port to centered cutout
         translate([-20,0,0])
         translate([base_r-1,0,port_h])
         rotate(90,[0,1,0])
         cylinder(d=cport_id,h=port_l,$fn=25);

        //exit port to outer cell cutout
        translate([-20,0,0])
        translate([-base_r-port_l,0,port_h])
        rotate(90,[0,1,0])
        cylinder(d=cport_id,h=port_l+2,$fn=25);
        
        



    } 
}

//-------------------------------------------------------------
//Outer Cell
translate([-50,10,0])
difference(){
    //BUILD UP
    union(){
          translate([-20,0,0])
        linear_extrude(base_h)difference(){
            circle(r=base_r+1);circle(r=base_r);
        }
        // Lip
          translate([-20,0,0])
        translate([0,0,base_lip])
        rotate_extrude()translate([1*base_r,0,0])rotate(36,[0,0,1])circle(d=1,$fn=5);
        
        // Ports
        if(drain){
            //connecting port 
            translate([-20,0,0])
            translate([base_r,0,port_h])
            rotate(90,[0,1,0])
            cylinder(d=cport_od,h=port_l-1.5,$fn=25);            

            //exit port
            translate([-20,0,0])
            translate([-base_r-port_l,0,out_port_h])
            rotate(90,[0,1,0])
            cylinder(d=out_port_od,h=port_l,$fn=25);
        }
    }
    
    //CUTOUT
    if(drain){
        //connecting port cutout
         translate([-20,0,0])
         translate([base_r-1,0,port_h])
         rotate(90,[0,1,0])
         cylinder(d=cport_id,h=port_l,$fn=25);

        //exit port cutout
        translate([-20,0,0])
        translate([-base_r-port_l,0,out_port_h])
        rotate(90,[0,1,0])
        cylinder(d=out_port_id,h=port_l+2,$fn=25);
        
        
        
        

    } 
}

//--------------------------------------------------------------
//Flat Base
translate([-89,-10,-1])
cube([108, grid_r*2.5,1]);

//support beam center cell
translate([21.5,10,-1])
cylinder(d=1.6, h=11);
translate([20,8,-1])
cube([4,4,.4]);

//support beam outer cell
translate([-91.5,10,-1])
cylinder(d=1.6, h=11);
translate([-94,8,-1])
cube([4,4,.4]);


}

module cap(center=true) {
base_h = 15; // base height
base_tol = 0.3; // tolerance for base/mesh diameters
base_r = base_tol + grid_r;

cap_tol=0.2;
difference(){
    difference(){
        cylinder(r=base_r+2+cap_tol,h=4);
        translate([0,0,1])
        cylinder(r=base_r+1+cap_tol,h=4);
    }
    translate([base_r+2+cap_tol-9,-2,-1])
    cube([9,4,6]);
}
    if (center) {
        for (i=[16,-19]){
            translate([5,i,0])
            rotate([0,0,90])
            cube([3,10,1]);
        }
    }
}


module multicap() {
    rotate(90,[0,0,1])for (i=[-35,0,35]){
        translate([0,i,0])cap(i==0?true:false);
    }
}

multicell();
translate([-40,60,0])multicap();













