//use <MCAD/boxes.scad>
$fa = 1;
$fs = 0.4;

thickness = 2;
length = 200;
width = 110;
height = 30;

jack_radius = 9/2;
pot_radius = 7/2;
large_toggle_radius = 12/2;
toggle_radius = 6/2;

module roundedCube(size, r, sidesonly, center) {
  s = is_list(size) ? size : [size,size,size];
  translate(center ? -s/2 : [0,0,0]) {
    if (sidesonly) {
      hull() {
        translate([     r,     r]) cylinder(r=r, h=s[2]);
        translate([     r,s[1]-r]) cylinder(r=r, h=s[2]);
        translate([s[0]-r,     r]) cylinder(r=r, h=s[2]);
        translate([s[0]-r,s[1]-r]) cylinder(r=r, h=s[2]);
      }
    }
    else {
      hull() {
        translate([     r,     r,     r]) sphere(r=r);
        translate([     r,     r,s[2]-r]) sphere(r=r);
        translate([     r,s[1]-r,     r]) sphere(r=r);
        translate([     r,s[1]-r,s[2]-r]) sphere(r=r);
        translate([s[0]-r,     r,     r]) sphere(r=r);
        translate([s[0]-r,     r,s[2]-r]) sphere(r=r);
        translate([s[0]-r,s[1]-r,     r]) sphere(r=r);
        translate([s[0]-r,s[1]-r,s[2]-r]) sphere(r=r);
      }
    }
  }
}

module trayWithSides() {
    difference() {
        roundedCube(size=[length+3*thickness, width+2*thickness, height+thickness], r=3, sidesonly=true, center=false);
        translate([thickness, thickness, thickness])
            roundedCube(size=[length+thickness, width, height+2*thickness], r=3, sidesonly=true, center=false);
    }
}

module trayLessEnd() {
    difference() {
        trayWithSides();
        translate([length+thickness, -width/2, -height/2])
            cube([thickness*3, width*2, height*2]);
    }
}

module roundedTrayEnd() {
    difference() {
        translate([-thickness, 0, -thickness])
            trayLessEnd();
        translate([length - height * 2/3, -1, height - height * 2/3])
            difference() {
                cube([height, width*1.4, height]);
                translate([0, width*1.5, 0])
                    rotate([90, 0, 0])
                    cylinder(width*2, height * 2/3, height * 2/3, false);
            }
    }
}

module toggleMount() {
    x = 20;
    l = 2;
    w = 4;
    h = 6;
    translate([0,-x/2,0])
    //translate([0,x,0])
    //polyhedron(
    //           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
    //           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    //           );
    difference() {
        cube([x, x, thickness]);
        translate([x/2, x/2, -10])
            cylinder(20, toggle_radius, toggle_radius, false);
    }
    translate([0,x/2-thickness,0.1])
        rotate([-90,0,0])
        linear_extrude(height=thickness)
        polygon(points=[[0,0],[x,0],[0,height]], paths=[[0,1,2]]);
    translate([0,-x/2,0.1])
        rotate([-90,0,0])
        linear_extrude(height=thickness)
        polygon(points=[[0,0],[x,0],[0,height]], paths=[[0,1,2]]);
}

translate([0, width + 10, 0])
    union() {
        difference() {
            roundedTrayEnd();
            
            // input/output jacks
            translate([-2*thickness, width * 1/3 - jack_radius/2, height/2])
                rotate([0,90,0])
                cylinder(h=thickness*4, r=jack_radius);
            translate([-2*thickness, width * 2/3 + jack_radius/2, height/2])
                rotate([0,90,0])
                cylinder(h=thickness*4, r=jack_radius);
            
            // one side holes
            translate([30, 2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=large_toggle_radius);
            translate([60, 2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([90, 2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([120, 2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([150, 2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=large_toggle_radius);
            
            // other side pots
            translate([30, 1+width+2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=large_toggle_radius);
            translate([60, 1+width+2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([90, 1+width+2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([120, 1+width+2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=pot_radius);
            translate([150, 1+width+2*thickness, height/2])
                rotate([90,0,0])
                cylinder(h=thickness*4, r=large_toggle_radius);
        }
        translate([0-thickness,width/2,height-thickness])
            toggleMount();
    }

// base
translate([-thickness, -thickness, -thickness])
    cube([length + thickness, width + 2*thickness, thickness]);
    
// short wall
difference() {
    translate([-thickness, -thickness, -thickness])
        cube([thickness, width + 2*thickness, height + thickness]);
    translate([-2*thickness, 20, height/2])
        rotate([0,90,0])
        cylinder(h=thickness*4, r=jack_radius);
    translate([-2*thickness, width-20, height/2])
        rotate([0,90,0])
        cylinder(h=thickness*4, r=jack_radius);
}

// long walls
difference() {
    translate([-thickness, -thickness, -thickness])
        cube([length + thickness, thickness, height + thickness]);
    translate([60, 2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
    translate([90, 2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
    translate([120, 2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
}

difference() {
    translate([-thickness, width, -thickness])
        cube([length + thickness, thickness, height + thickness]);
    translate([60, width+2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
    translate([90, width+2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
    translate([120, width+2*thickness, height/2])
        rotate([90,0,0])
        cylinder(h=thickness*4, r=8);
}
