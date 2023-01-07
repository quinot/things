part = "all"; // [holder:Holder Only,ring:Ring Only,cover:Cover Only,all:Holder Ring and Cover]

// outside diameter in mm of one binocular tube
diameter=76;

// thickness of the walls in mm (for best results, make this a multiple of your nozzle width)
wall_thickness = 1.2;

// width of the ring of material on the holder that prevents the filter from falling through
holder_annulus_width = 10;

//width of the ring that sandwiches the filter from the inside (should be slightly smaller than holder_annulus_width)
ring_annulus_width = 9;

// depth of the filter holder that slides over the binoculars
holder_depth = 10;

// depth of the cover that slides over the holder
cover_depth = 7;

// amount of gap between the cover and the holder
cover_gap = 0.25;

// # of nubs inside holder
nub_count = 8;

// diameter of nub
nub_dia = 3;

// total height of nub, as fraction of holder height
nub_height = 1;

// the distance between parts when printed together
part_spacing = 3;

/* [Hidden] */
cover_inner_diameter = diameter + 2 * wall_thickness + 2 * cover_gap;
cover_outer_diameter = cover_inner_diameter + 2 * wall_thickness;

// clip cylinder is halfway between internal and external walls of holder
_nub_clip_dia = diameter + wall_thickness;
_ring_diameter = _nub_clip_dia - nub_dia;

module cover() {
    color("SteelBlue")
        union() {
            translate([0, 0, wall_thickness / 2]) {
                cylinder(h = wall_thickness,
                         d = cover_outer_diameter,
                         center = true,
                         $fn=200);
            }
            translate([0 , 0, wall_thickness + cover_depth / 2]) {
                difference() {
                    cylinder(h = cover_depth,
                             d = cover_outer_diameter,
                             center = true,
                             $fn = 200);
                    cylinder(h = cover_depth + 1,
                             d = cover_inner_diameter,
                             center = true,
                             $fn = 200);
                }
            }
        }
}

module nub() {
    _nub_cyl_height = holder_depth * nub_height - nub_dia / 2;

    intersection() {
        translate([0, _nub_clip_dia / 2, wall_thickness])
            union() {
                cylinder(h = _nub_cyl_height, d = nub_dia, $fn=200);
                translate([0, 0, _nub_cyl_height])
                    sphere(d = nub_dia, $fn=200);
            }


        translate([0, 0, holder_depth / 2 + wall_thickness])
            cylinder(h=holder_depth, d=_nub_clip_dia, center=true, $fn=200);
    }
}

module holder() {
    union() {
        translate([0, 0, wall_thickness / 2]) {
            difference() {
                cylinder(h = wall_thickness,
                         d = diameter + 2 * wall_thickness,
                         center = true,
                         $fn = 200);
                cylinder(h = wall_thickness + 1,
                         d = diameter - 2 * holder_annulus_width,
                         center = true,
                         $fn = 200);
            }
        }
        translate([0, 0, holder_depth / 2 + wall_thickness]) {
            difference() {
                cylinder(h = holder_depth,
                         d = diameter + 2 * wall_thickness,
                         center = true,
                         $fn = 200);
                cylinder(h = holder_depth + 1,
                         d = diameter,
                         center = true,
                         $fn = 200);
            }
        }
        for (_nub_j = [0 : nub_count - 1])
            rotate(_nub_j * 360 / nub_count)
                nub();
    }
}


module ring() {
    color("Chartreuse")
        union() {
             translate([0, 0, wall_thickness / 2]) {
                difference() {
                    cylinder(h = wall_thickness,
                             d = _ring_diameter,
                             center = true,
                             $fn = 200);
                    cylinder(h = wall_thickness + 1,
                             d = diameter - ring_annulus_width * 2,
                             center = true,
                             $fn = 200);
                }
            }
        }
}


// Create one STL file at a time
if (part == "cover") {
    cover();
} else if (part == "holder") {
    holder();
} else if (part == "ring") {
    ring();
} else if (part == "nub") {
    nub();
} else if (part == "all") {
    spacing = cover_outer_diameter + part_spacing;

    translate([-spacing * sqrt(3) / 4, spacing / 2, 0]) cover();
    translate([-spacing * sqrt(3) / 4, -spacing / 2, 0]) holder();
    translate([spacing * sqrt(3) / 4, 0, 0]) ring();
}
