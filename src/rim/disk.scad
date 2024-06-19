/*
CC BY-NC-SA, 2024, Sebastian A. Mueller

An alternative, star shaped disk for the rims of the
Compagnucci RC model car from the early 2000s.
*/

$fn = 77;

module icylinder(ro, ri, h) {
    translate([0, 0, -h/2]) {
        difference() {
            cylinder(r=ro, h=h);
            translate([0, 0, -h*0.05])cylinder(r=ri, h=h*1.1);
        }
    }
}


module bolt_holes(r=25.0, r_bolt=1.05, h=10) {
    for (iphi = [0:8]) {
        phi = 360/8 * iphi;
        translate([r * cos(phi), r * sin(phi), -h/2])
        rotate([0, 0, phi + 30])
        cylinder(r=r_bolt, h=h);
    }
}

module drive_slit() {
    hull() {
        translate([0, -8, 10])
        sphere(r=1.25);
        translate([0, 8, 10])
        sphere(r=1.25);
        translate([0, -8, 3])
        sphere(r=1.25);
        translate([0, 8, 3])
        sphere(r=1.25);
    }
}

dd = 0;


module inner_disk() {
    cap_h = (3.2 - dd/2);
    translate([0,0, (3.8 + dd)/2])
    cylinder(r1=46/2, r2=16/2, h=cap_h);

    translate([0, 0, -(3.8 + dd)/2])
    cylinder(r=46/2, h=3.8+dd);

    translate([0,0, -cap_h - (3.8 + dd)/2])
    cylinder(r2=46/2, r1=16/2, h=cap_h);
}

module axle_shaft() {
    translate([0, 0 ,-10])
    cylinder(r=3.05, h=20);
}


module cylinder_segment(h) {
    translate([0, 0, -h/2])
    difference() {
        cylinder(r=44/2, h=h);

        rotate([0, 0, 115])
        translate([0, 0 -25])
        cube([50, 50, 4*h], center=true);

        rotate([0, 0, -115])
        translate([0, 0 -25])
        cube([50, 50, 4*h], center=true);

        translate([0, -9, 0])
        cube([20, 20, 4*h], center=true);
    }
}

module disk_cutout(h=20) {
    hull() {
        translate([0, 0, -h/2]) {
            translate([0, -10, 0])
            cylinder(r=1, h=h);
            translate([-8, -17.8, 0])
            cylinder(r=2.5, h=h);
            translate([8, -17.8, 0])
            cylinder(r=2.5, h=h);
            translate([0, 0, h/2])
            cylinder_segment(h=h);
        }
    }
}

module disk_cutouts() {
    for (iphi = [0:5]) {
        phi = 53 + 360/5 * iphi;
        rotate([0, 0, phi])
        disk_cutout();
    }
}


module disk() {
    color("gray")
    difference() {
        union() {
            icylinder(ro=58/2, ri=43.6/2, h=1.0 + dd);
            icylinder(ro=55.7/2, ri=43.6/2, h=2.0 + dd);
            icylinder(ro=46.0/2, ri=43.6/2, h=3.8 + dd);
            icylinder(ro=16.0/2, ri=6.0/2, h=10);
            inner_disk();
        }
        drive_slit();
        bolt_holes(r=25.0, r_bolt=1.1, h=10 + dd);
        axle_shaft();
        disk_cutouts();
    }
}


module zcylinder(ro, ri, h) {
    translate([0, 0, 0]) {
        difference() {
            cylinder(r=ro, h=h);
            translate([0, 0, -h*0.05])cylinder(r=ri, h=h*1.1);
        }
    }
}


module rim_part(t=10) {
    color("white") {

        difference() {
            union() {
                translate([0, 0, 0])
                zcylinder(ro=58.3/2, ri=46.1/2, h=2.5);
                zcylinder(ro=58.3/2, ri=55.4/2, h=t - dd/2);
                translate([0, 0, t - dd/2])
                zcylinder(ro=62.2/2, ri=55.4/2, h=1);
                translate([0, 0, t - dd/2 + 1])
                zcylinder(ro=62.2/2, ri=61/2, h=2);
                translate([0, 0, t - dd/2 + 3])
                zcylinder(ro=64.3/2, ri=61/2, h=1.0);
            }
            translate([0, 0, 0])
            bolt_holes(r=25.0, r_bolt=1.1, h=10);
            translate([0, 0, 6.25])
            bolt_holes(r=25.0, r_bolt=2.4, h=10, $fn=6);
        }
    }
}

module rim() {
    translate([0, 0, dd/2 + 1.0])
    rim_part(t=10);
    disk();
    translate([0, 0, -dd/2 - 1])
    rotate([180, 0, 0])
    rim_part(t=18);
}

disk();

/*rim_part();*/