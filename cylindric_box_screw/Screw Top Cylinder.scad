// Model from https://www.printables.com/model/491957-parametric-openscad-round-container-jar-with-a-scr
// Adapted for 150mm Skywatcher solar filter: https://www.thingiverse.com/thing:5366929

/* Geometry */
// The inner width in mm
Inner_Width_Base = 180;
// The inner height in mm
Inner_Height_Base = 16;
// the tickness of the cans walls
wall_thickness = 1.2;
// the thickness of the lids walls
wall_thickness_lid = 1.2;
// the thickness of the floor
bottom_thickness = 1.2;
// the height of an optional rim
Hieght_Rim = 0;
// the diameter of the optional rim
Diameter_Rim = Inner_Width_Base + 0.2;
// the height of the thread
thread_height = 5;
// turns of thread
thread_turns = 2;
// Cut away a bit of the thread to make it blunt and easier going. How much (in percent) shall be cut away?
cut_thread_percent = 10;
// true makes the base for the thread of the base wider to fit the lid
smooth_sides = 1; // [0:no, 1:yes]

/* [Printing] */
// Only set this to no if you want to see both parts together
layout_to_print = 1; // [0:no, 1:yes]
// Only set this to true if you want to have a sectioned view
view_sectioned = 0; // [0:no, 1:yes]
// It is recommended to print the parts seperately. Which part do you want to print
part_to_print = 1; // [0:all, 1:can, 2:base]
// Distance between parts
print_distance = 5;

/* Resolution and Tolerance */
// resolution of roundings in steps/360°
fn = 256; // [8,16,32,64,128,256]
// space between moving Parts, printer dependent
partsgap = 0.5;

/* [Hidden] */
tol = 0.05;
thread_thicknes = ((thread_height/thread_turns)/2); // *(100-cut_thread_percent)/100;
ThreadSize = thread_height / thread_turns;

cut_height = thread_thicknes*cut_thread_percent/100;
cut_width = thread_thicknes*(100-cut_thread_percent)/100;

difference()
{
	All();
	if (view_sectioned!=0)
	{
		rotate([0,0,180])
		translate([-Inner_Width_Base,0,-tol])
			cube([Inner_Width_Base*2,Inner_Width_Base,Inner_Height_Base+bottom_thickness+bottom_thickness+tol*2+partsgap]);
	}
}

module All()
{
	if (part_to_print == 0 || part_to_print == 1)
	{
		Base();	
	}
	if ((part_to_print == 0) || (part_to_print == 2))
	{
		translate([
					0,
					(layout_to_print!=0) && (part_to_print == 0) ?
						-(Inner_Width_Base+thread_thicknes*2+wall_thickness*2+wall_thickness_lid*2+print_distance)
						: 0,
					(layout_to_print!=0) ?
						0
						: Inner_Height_Base + bottom_thickness * 2 + partsgap/2
					])
			rotate([0,
					(layout_to_print!=0) ? 
						0
						: 180,
					-0])
				Lid();
	}
}

module Base()
{
	difference()
	{
		union()
		{
			cylinder(r = Inner_Width_Base / 2 + wall_thickness, h = Inner_Height_Base + bottom_thickness, $fn=fn);
			translate([0,0,Inner_Height_Base + bottom_thickness - thread_height - ThreadSize/2])
				screw_extrude
				(
					P = (cut_thread_percent > 0) 
					?
						[
							[-tol,thread_thicknes-tol],
							[cut_width,cut_height],
							[cut_width,-cut_height],
							[-tol,-(thread_thicknes-tol)]	
						]
					:
						[
							[-tol,thread_thicknes-tol],
							[thread_thicknes,0],
							[-tol,-(thread_thicknes-tol)]	
						],
					r = Inner_Width_Base / 2 + wall_thickness,
					p = ThreadSize,
					d = 360 * (thread_turns + 0),
					sr = 0,
					er = 45,
					fn = fn
				);

			translate([0,0,Inner_Height_Base + bottom_thickness - thread_height - ThreadSize])
			{
				cylinder(r=Inner_Width_Base/2+thread_thicknes+wall_thickness + ((smooth_sides!=0) ? wall_thickness_lid : 0), h=ThreadSize, $fn=fn);
				translate([0,0,-wall_thickness*2])
					SideSupport(Inner_Width_Base/2+wall_thickness, 
								thread_thicknes + ((smooth_sides!=0) ? wall_thickness_lid : 0), 
								wall_thickness*2 );
			}
		}
		// Inner space:
		translate([0,0,bottom_thickness])
			cylinder(r=Inner_Width_Base / 2, h=Inner_Height_Base + tol, $fn=fn);
		// Create the Rim:
		translate([0,0,bottom_thickness + Inner_Height_Base - Hieght_Rim]) { color([1,0,0]) 
			cylinder(r = Diameter_Rim/2, h=Hieght_Rim + tol, $fn=fn); }
		// Cut off protruding thread:
		translate([0,0,Inner_Height_Base+bottom_thickness-tol])
			cylinder(r=Inner_Width_Base+wall_thickness*2+thread_thicknes*2+tol, h=ThreadSize*2+tol);

	}
}

module Lid()
{
	difference()
	{
		cylinder(r = Inner_Width_Base/2 + thread_thicknes + wall_thickness+wall_thickness_lid, h = thread_height + bottom_thickness, $fn=fn);
		translate([0,0,bottom_thickness])
			cylinder(r=Inner_Width_Base / 2 + wall_thickness + thread_thicknes + partsgap, h= thread_height + tol, $fn=fn);
	}
	difference()
	{
		translate([0,0, bottom_thickness - ThreadSize/2])
		{	
			screw_extrude
			(
				P = (cut_thread_percent > 0) 
				?
					[
						[tol*2,-(thread_thicknes-tol)],
						[-cut_width,-cut_height],
						[-cut_width, cut_height],
						[tol*2,thread_thicknes-tol]
					]
				:
					[
						[tol,-(thread_thicknes-tol)],
						[-thread_thicknes,0],
						[tol,thread_thicknes-tol]
					]
				,
				r = Inner_Width_Base / 2 + wall_thickness + thread_thicknes + partsgap,
				p = ThreadSize,
				d = 360 * (thread_turns + 0),
				sr = 0,
				er = 45,
				fn = fn
			);
		}
		translate([0,0,thread_height + bottom_thickness])
			cylinder(r=Inner_Width_Base+wall_thickness*2+thread_thicknes+tol, h=ThreadSize+tol);
		rotate([180,0,0])
			translate([0,0,-tol])
			cylinder(r=Inner_Width_Base+wall_thickness*2+thread_thicknes+tol, h=ThreadSize+tol);
	}
}

module SideSupport(r,w,h)
{
	rotate_extrude($fn=fn)
		translate([r,0,0])
						polygon([[0,0],
							[w,h],
							[0,h]]);
		
}

/**
 * screw_extrude(P, r, p, d, sr, er, fn)
	by Philipp Klostermann
	
	screw_rotate rotates polygon P 
	with the radius r 
	with increasing height by p mm per turn 
	with a rotation angle of d degrees
	with a starting-ramp of sr degrees length
	with an ending-ramp of er degrees length
	in fn steps per turn.
	
	the points of P must be defined in clockwise direction looking from the outside.
	r must be bigger than the smallest negative X-coordinate in P.
	sr+er <= d
**/

module screw_extrude(P, r, p, d, sr, er, fn)
{
	anz_pt = len(P);
	steps = round(d * fn / 360);
	mm_per_deg = p / 360;
	points_per_side = len(P);
	echo ("steps: ", steps, " mm_per_deg: ", mm_per_deg);
	
	VL = [ [ r, 0, 0] ];
	PL = [ for (i=[0:1:anz_pt-1]) [ 0, 1+i,1+((i+1)%anz_pt)] ];
	V = [
		for(n=[1:1:steps-1])
			let 
			(
				w1 = n * d / steps,
				h1 = mm_per_deg * w1,
				s1 = sin(w1),
				c1 = cos(w1),
				faktor = (w1 < sr)
				?
					(w1 / sr)
				:
					(
						(w1 > (d - er))
						?
							1 - ((w1-(d-er)) / er)
						:
							1
					)
			)
			for (pt=P)
			[
				r * c1 + pt[0] * c1 * faktor, 
				r * s1 + pt[0] * s1 * faktor, 
				h1 + pt[1] * faktor 
			]
	];
	P1 = [
		for(n=[0:1:steps-3])
			for (i=[0:1:anz_pt-1]) 
			[
				1+(n*anz_pt)+i,
				1+(n*anz_pt)+anz_pt+i,
				1+(n*anz_pt)+anz_pt+(i+1)%anz_pt
			] 
			
		
	];
	P2 = 
	[
		for(n=[0:1:steps-3])
			 for (i=[0:1:anz_pt-1]) 
				[
					1+(n*anz_pt)+i,
					1+(n*anz_pt)+anz_pt+(i+1)%anz_pt,
					1+(n*anz_pt)+(i+1)%anz_pt,
				] 
			
		
	];

	VR = [ [ r * cos(d), r * sin(d), mm_per_deg * d ] ];
	PR = 
	[
		for (i=[0:1:anz_pt-1]) 
		[
			1+(steps-1)*anz_pt,
			1+(steps-2)*anz_pt+((i+1)%anz_pt),
			1+(steps-2)*anz_pt+i
		]
	];
			
	VG=concat(VL,V,VR);
	PG=concat(PL,P1,P2,PR);
	convex = round(d/45)+4;
	echo ("convexity = round(d/180)+4 = ", convex);
	polyhedron(VG,PG,convexity = convex);
}

