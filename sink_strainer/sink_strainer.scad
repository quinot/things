// outside diameter in mm
outer_diameter=40;

// inner nut diameter
inner_diameter=20;

// thickness of mesh walls
wall_thickness = 0.4;

// count of radial walls
radial_walls=6;

// count of angular walls
angular_walls=36;

// height in mm
height=0.8;

/* [Hidden] */

radial_wall_spacing=(outer_diameter/2 - inner_diameter/2 - radial_walls * wall_thickness) / (radial_walls - 1);

module radial_wall(j) {
    inner_radius = inner_diameter / 2 + j * (radial_wall_spacing + wall_thickness);
    outer_radius = inner_radius + wall_thickness;

    difference() {
        circle(r=outer_radius, $fn=200);
        circle(r=inner_radius, $fn=200);
    }
}

module angular_wall(j) {
  rotate([0, 0, 360 * j / angular_walls])
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

linear_extrude(height=height) {
    core();
    for (j=[0:radial_walls-1]) radial_wall(j);
    for (j=[0:angular_walls-1]) angular_wall(j);
}