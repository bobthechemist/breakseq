// Breakseq humidity chamber
// Authors: Robert J. LeSuer and Jenna DeRycke

cap_od = 35;    // outer diameter of cap
cap_id = 33;    // inner diameter of cap
cap_thickness = 1;  // thickness of cap top
cap_height = 4; // total height of cap

module cap() {
    difference(){
        cylinder(d=cap_od, h = cap_height);
        union(){
            translate([0,0,cap_thickness])cylinder(d=cap_id,h=cap_height);
            translate([8.5,-2,-0.1])cube([cap_od/2,4,2*cap_height]);
        }
    }
}

//cap();

handle_thickness = 2.1; // handle size (x and y direction)
handle_x = 25;  // handle height
handle_y = 14.7; // handle crossbar 
handle_z = 15; // handle ell bar
handle_offset = (handle_y - handle_thickness)/2; // don't change

module handle(){
    cube([handle_x,handle_thickness,handle_thickness]);
    translate([0,-handle_offset,0])cube([handle_thickness,handle_y,handle_thickness]);
    cube([handle_thickness,handle_thickness,handle_z]);
}

//handle();

base_od = 32.6; // base outer diameter
base_id = 30.6; // base inner diameter
base_height = 15;   // height of chamber
base_thickness = 1; // thickness of chamber floor
base_lip = 5; // location of support lip

module base(){
    difference(){
        cylinder(d=base_od,h=base_height);
        translate([0,0,base_thickness])cylinder(d=base_id,h=base_height);
    }
    translate([0,0,base_lip])
    rotate_extrude()translate([base_id/2,0,0])rotate(36,[0,0,1])circle(d=1,$fn=5);
}

//base();

grid = 2;   // pattern size
grid_density = 0.725; // relative size of grid hole
grid_x = grid_density * grid; // do not change
grid_y = grid_x; // do not change
mesh_height =0.8; // thickness of mesh
mesh_od = 30.05; // mesh outer diameter
mesh_id = 27.5; // mesh inner diameter
mesh_i = ceil(mesh_od/grid/2); // do not change
mesh_slot_pos = 10.05; // location of slot for handle
mesh_slot_dim = handle_thickness*1.15; // size of slot for handle

module mesh() {
    linear_extrude(mesh_height){
        difference(){
            circle(d=30.0,$fn=50);
            union(){
                for (i = [-mesh_i:mesh_i]){
                    for (j = [-mesh_i:mesh_i]){
                        translate([i*grid,j*grid])square([grid_x,grid_y],center=true);
                    }
                }
                translate([0,mesh_slot_pos])square([mesh_slot_dim,mesh_slot_dim],center=true);
            }
        }
        difference(){
            circle(d=mesh_od,$fn=50);
            circle(d=mesh_id,$fn=50);
        }
    }
}

//mesh();

tray_od = 30;   // diameter of tray
tray_lod = 19;  // outer diameter of lip
tray_lid = 16.6;    //  inner diameter of lip
tray_z = 0.8;   // height of tray
tray_r = 1.2;   // radius of holes in tray
tray_ht = 2.1; // handle thickness, 
tray_hz = 25;   // handle height
tray_pos = [5,11];  // handle location

module tray(){


    difference(){
        union(){
            cylinder(d=tray_od,h=tray_z,$fn=25);
            translate(tray_pos)
            rotate([60,270,0])
            cube([tray_hz,tray_ht,tray_ht]);
            cylinder(h=tray_z+.2,d=tray_lod);
        }
    
    
    union(){
        for (rot=[0:18:340]){
            rotate(rot,[0,0,1])
            translate([0, (tray_od + tray_lod)/4,-0.1])
            cylinder(h=tray_z+0.2,r=tray_r,$fn=25);
            translate([0,0,tray_z])
            cylinder(h=.21,d=tray_lid);
        }
    }
    }
}

//tray();

module set() {
    translate([-20,20,0])base();
    translate([20,20,0])mesh();
    translate([-25,-20,0])handle();
    translate([20,-20,0])tray();
    translate([-20,60,0])cap();
    
}

set();
