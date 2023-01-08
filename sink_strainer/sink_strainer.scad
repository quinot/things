// outside diameter in mm
outer_diameter=39.5;

// inner nut diameter
inner_diameter=20.5;

// thickness of mesh walls
wall_thickness = 0.4;

// count of concentric walls
concentric_walls=6;

// count of radial walls
radial_walls=36;

// layer height in mm
layer_height=0.2;

/* [Hidden] */

concentric_wall_spacing=(outer_diameter/2 - inner_diameter/2 - concentric_walls * wall_thickness) / (concentric_walls - 1);

module concentric_wall(j) {
    inner_radius = inner_diameter / 2 + j * (concentric_wall_spacing + wall_thickness);
    outer_radius = inner_radius + wall_thickness;

    difference() {
        circle(r=outer_radius, $fn=200);
        circle(r=inner_radius, $fn=200);
    }
}

module radial_wall(j) {
  rotate([0, 0, 360 * j / radial_walls])
      intersection() {
        circle(d=outer_diameter, $fn=200);
        difference() {
          translate([-wall_thickness/2, 0])
            square([wall_thickness, outer_diameter]);
          circle(d=inner_diameter, $fn=200);
        }
      }
}

module core() {
    difference() {
        circle(d=inner_diameter, $fn=200);
        circle(d=inner_diameter, $fn=6);
    }
}

// Inner and outer walls: full height (4 layers)
linear_extrude(height=4*layer_height) {
    core();
    concentric_wall(0);
    concentric_wall(concentric_walls - 1);
}

// Radial walls: 1st and 4th layer
for (z = [0, 3 * layer_height])
    translate([0, 0, z])
         linear_extrude(height=layer_height)
              for (j=[0:radial_walls-1]) radial_wall(j);

// Concentric walls: 2nd and 3rd layers
color("blue") translate([0, 0, layer_height])
    linear_extrude(height=2*layer_height)
        for (j=[1:concentric_walls-2]) concentric_wall(j);
