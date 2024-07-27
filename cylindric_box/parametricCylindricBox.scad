// CUSTOMIZER VARIABLES

part = "all"; // [bottom:Bottom only,lid:Lid only,all:Both bottom and lid]

// in mm. Dimensions of space inside each compartment. Final outside box height & width depends on wall & lip thickness.
// Includes thickness of compartment separators.
inner_diameter = 50;

// # of compartments
// compartments = 2;

// Thickness of walls between compartments
// separator_thickness = 1.0;

// The height of both the bottom and lid is the total height of the space inside the container.
bottom_height = 10.0;
lid_height = 5.0;

// Wall thickness in mm. This adds to the outside dimensions of the box.
thickness = 1.2;

// Height of lip above box top, used for the friction fit.
lip_height = 4;

// Height of the lip going below and attached to bottom. Default works well.
lip_overlap_height = 2.0;

// Wall thickness of the attachment lip.
lip_thickness = 0.8;

// Lip outer dimension offset. The larger the number the looser the friction fit.
looseness_offset = 0.15;

/* [Hidden] */

// Generate the bottom.
generate_box = (part == "bottom" || part == "all");

// Generate a lid.
generate_lid = (part == "lid" || part == "all");

// resolution
$fn=100;

// x_width = compartments * x_compartment_width + (compartments - 1) * separator_thickness;

outer_diameter = inner_diameter + thickness*2 + lip_thickness*2 + looseness_offset*2;

bottom_height_outside = bottom_height + thickness;
lid_height_outside = lid_height + thickness;

// ---- Generate bottom
box_height_total = bottom_height_outside + lip_height;
lip_overlap_cut_total = bottom_height - lip_overlap_height;

if (generate_box) {
	translate([-((outer_diameter/2+2) * (generate_lid ? 1 : 0)), 0, 0]) difference()
	{
		union()
		{
            // Outer body
            cylinder(r=outer_diameter/2,h=bottom_height_outside);

            // Inner body that forms lip
			cylinder(r=inner_diameter/2 + lip_thickness,h=box_height_total);
		}

		// Cut out inside
		union()
		{
            main_cut_height = bottom_height - lip_overlap_height;
            translate([0, 0, thickness])
                cylinder(r=outer_diameter/2 - thickness, h=main_cut_height);
            translate([0, 0, thickness + main_cut_height-0.1])
                cylinder(r=inner_diameter/2, h=lip_height + lip_overlap_height +.2);
		}
	};
}

// Generate the lid
if (generate_lid) {
	translate([(outer_diameter/2+1) * (generate_box ? 1 : 0), 0, 0]) {
		difference()
		{
			// Body
			cylinder(r=outer_diameter/2, h=lid_height_outside);

			translate([0,0,thickness])
                cylinder(r=outer_diameter/2 - thickness, h=lid_height_outside);
		}
	};
}


