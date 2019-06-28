edge_width = 20;
edge_height = 20;
slot_width = 3;
slot_depth = 5;
length = 200;
element = 1; // 1 = Build element ; other = Build icosahedron

PHI = (1 + sqrt(5)) / 2; // Golden ratio
ALPHA = 90 - atan(PHI);
dihedral_angle = 180 - asin(2/3);
angle1 = ALPHA;
angle2 = 108 / 2;

$fn = 50*1;

module tip(length=5) {
    union() {
        rotate([-angle1, 0, 0])
            rotate([0, angle2, 0])
                translate([10, edge_height-5, -1])
                    cylinder(6, 5, 5);
        difference() {
            translate([0, edge_height/2, -length/2])
                cube([edge_width, edge_height, length], center=true);
            rotate([-angle1, 0, 0])
                translate([0, edge_height*0.6, edge_height*0.3])
                    cube([edge_width*1.2, edge_height*1.2, edge_height*0.6], center=true);
            rotate([-angle1, 0, 0])
                rotate([0, angle2, 0])
                    cube([edge_width, edge_height*1.8, edge_height*0.5]);
            rotate([-angle1, 0, 0])
                rotate([0, -90-angle2, 0])
                    cube([edge_height*0.5, edge_height*1.8, edge_width]);
            mirror([-1,0,0])
                    rotate([-angle1, 0, 0])
                        rotate([0, angle2, 0])
                            translate([10, edge_height-5, -6])
                                cylinder(7, 5, 5);
        }
    }
}

module edge(length=5) {
    difference() {
        union() {
            tip(length / 2);
            translate([0, 0, -length])
                //mirror([0, 0, 1])
               rotate([0, 180, 0])
                    tip(length / 2);
        }
        translate([-(edge_width+3*slot_depth)/2+slot_depth,edge_width/2,-length/2])
            rotate([0, 0, -90+dihedral_angle/2])
                cube([slot_depth*3, slot_width, length], center=true);
        translate([(edge_width+3*slot_depth)/2-slot_depth,edge_width/2,-length/2])
            rotate([0, 0, 90-dihedral_angle/2])
                cube([slot_depth*3, slot_width, length], center=true);
    }
}

module flower(length=5, l2=0, nb=5) {
    for (i = [0:nb-1]) {
        rotate([0, 0, i*360/5])
            rotate([90-angle1, 0, 0])
                rotate([0, 0, 180])
                    translate([0,0,-l2/2])
                        edge(length-l2);
    }
}

module flower2(length=5, l2=0, nb=5) {
    for (i = [0:nb-1]) {
        rotate([0, 0, i*360/5])
            rotate([90-angle1, 0, 0])
                rotate([0, 0, 180])
                    translate([0,0,-l2/2-10])
                        edge(length-l2);
    }
}

module isocaedron(l=5, l2=5) {
    translate([+l/2*PHI, +l/2, 0]) rotate([-ALPHA, 90, 0]) rotate([0, 0, -360/5/2]) flower(l, l2, 3);
    translate([+l/2, 0, +l/2*PHI]) rotate([+ALPHA, 0, 90]) rotate([0, 0, -360/5]) flower(l, l2, 3);
    translate([0, +l/2*PHI, +l/2]) rotate([-90+ALPHA, 0, 0]) rotate([0, 0, 5*360/5]) flower(l, l2, 3);
    translate([-l/2, 0, +l/2*PHI]) rotate([-ALPHA, 0, 90]) rotate([0, 0, -360/5/2]) flower(l, l2, 3);
    translate([0, -l/2*PHI, +l/2]) rotate([90-ALPHA, 0, 0]) rotate([0, 0, 3*360/5/2]) flower(l, l2, 3);
    translate([+l/2*PHI, -l/2, 0]) rotate([ALPHA, 90, 0]) rotate([0, 0, -360/5]) flower(l, l2, 3);
    translate([0, -l/2*PHI, -l/2]) rotate([90+ALPHA, 0, 0]) rotate([0, 0, 2*360/5]) flower(l, l2, 3);
    translate([-l/2*PHI, -l/2, 0]) rotate([180-ALPHA, 90, 0]) rotate([0, 0, 5*360/5/2]) flower(l, l2, 3);
    translate([+l/2, 0, -l/2*PHI]) rotate([180-ALPHA, 0, 90]) rotate([0, 0, 5*360/5/2]) flower(l, l2, 3);
    translate([-l/2*PHI, +l/2, 0]) rotate([180+ALPHA, 90, 0]) rotate([0, 0, 3*360/5]) flower(l, l2, 1);
    translate([0, +l/2*PHI, -l/2]) rotate([-90-ALPHA, 0, 0]) rotate([0, 0, 360/5/2]) flower(l, l2, 1);
    translate([-l/2, 0, -l/2*PHI]) rotate([180+ALPHA, 0, 90]) rotate([0, 0, 3*360/5]) flower(l, l2, 1);
}

if (element == 1)
    rotate([90, 0, 0])
        edge(length);
else
    isocaedron(length, (sin($t*360)+1)*length/10);