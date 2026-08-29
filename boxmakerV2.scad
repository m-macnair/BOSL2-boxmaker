// clang-format OMf
include<BOSL2 / std.scad>
	// clang-format on
	/* Void margin - add this to x/y/z values used to calculate voids that recieve a tooth/peg etc*/
	VM = .03;
/* Overlap margin for parts that boolean union into other parts - very helpful for it to be an even number*/
OM = .002;
/* 
	 0 = back
	 1 = right
	 2 = front
	 3 = left
	 4 = bottom
	 5 = top 

*/

/* given x,y and z OM desired volume, return enclosure dimensions regardless OM tab/socket concerns */
function get_inner_box_dimensions(x, y, z) = [
	//
	[ x, z ], /*back*/
	[ y, z ], /*right*/
	[ x, z ], /*front*/

	[ y, z ], /*left*/
	[ x, y ], /*bottom*/
	[ x, y ]  /*top*/
];

function get_outer_fat_tray_dimensions(T, x, y, z) = [
	//
	[ x - (T * 4), z - (T * 2) ], /*back*/
	[ y - (T * 4), z - (T * 2) ], /*right*/
	[ x - (T * 4), z - (T * 2) ], /*front*/
	[ y - (T * 4), z - (T * 2) ], /*left*/
	[ x - (T * 4), y - (T * 4) ], /*bottom*/
];

/*
	 male_edge_teeth 
	 Given:
			dimension OM edge to attach tabs
			material thickness used for tab y dimension
			teeth/tab count if more than 2
			non-default overlap for union() in calling method
	 return attachable tooth assembly
*/
module male_edge_teeth(x, t, teeth = 2, overlap = OM, anchor = CTR, spin) {

	segments = (teeth * 2) + 1;
	tab_x	 = x / segments;
	tab_y	 = t;

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ x, t ]) {
		ymove(-overlap) union() {
			xcopies(n = teeth, tab_x * 2) {
				square([ tab_x, tab_y + overlap ], anchor = CTR);
			}
		}
		children();
	}
}

module female_thin_edge_teeth(
	X,
	T	  = T,
	teeth = 2,

	overlap = OM,
	anchor	= CTR,
	spin	= 0,

	y_extra = 0) {
	echo("working_x:", X);
	segments  = (teeth * 2) + 1;
	segment_x = X / segments;
	echo("segment_x:", segment_x);

	tab_x = segment_x - VM;
	echo("tab_x:", tab_x);

	tab_y = T + y_extra + overlap;
	echo("tab_y:", tab_y);

	spacing = (tab_x * 2) + (VM * 2) + VM / 2;
	echo("spacing:", spacing);

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ X, tab_y ]) {
		ymove(-overlap) union() {
			xcopies(
				n = teeth + 1,
				spacing) {
				color("red")
					square([ tab_x, tab_y ], anchor = CTR);
			}
		}
		children();
	}
}

module female_fat_edge_assembly(X, T = T, teeth = 2, overlap = OM, anchor = CTR, spin) {
	lip_y = T - VM;
	echo("lip_y:", lip_y);

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ X, OM + (T * 2) ]) {
		union()
			female_thin_edge_teeth(
				X, T, teeth, overlap, anchor = BACK, y_extra = (OM * 4) + VM) {
			attach(BACK) {
				color("blue")
					back(-OM * 2)
						square([ X, lip_y ], anchor = FRONT);
			}
		}
		children();
	}
}

module attach_male_x_edges(X, T) {
	attach(LEFT)
		male_edge_teeth(X, T, anchor = BOT);
	attach(RIGHT)
		male_edge_teeth(X, T, anchor = BOT);
}

module attach_female_fat_x_edges(X, T) {
	attach(LEFT)
		female_fat_edge_assembly(X, T, anchor = BOT);
	attach(RIGHT)
		female_fat_edge_assembly(X, T, anchor = BOT);
}
module attach_female_thin_x_edges(X, T) {
	attach(LEFT)
		female_thin_edge_teeth(X, T, anchor = BOT);
	attach(RIGHT)
		female_thin_edge_teeth(X, T, anchor = BOT);
}

module attach_female_fat_y_edges(X, T) {
	attach(BACK)
		female_fat_edge_assembly(X, T, anchor = BOT);
	attach(FRONT)
		female_fat_edge_assembly(X, T, anchor = BOT);
}
module attach_female_thin_y_edges(X, T) {
	attach(BACK)
		female_thin_edge_teeth(X, T, anchor = BOT);
	attach(FRONT)
		female_thin_edge_teeth(X, T, anchor = BOT);
}

module assemble_xy_panels(D, T = T) {
	ymove(D[1][0] / 2) {
		color("red")
			zrot(180)
				xrot(90)
					linear_extrude(T)

						back_panel();
	}
	ymove(-D[1][0] / 2) {
		color("blue")
			xrot(90)
				linear_extrude(T)

					front_panel();
	}

	xmove(D[0][0] / 2) {
		color("green")
			zrot(90)
				xrot(90)
					linear_extrude(T)

						right_panel();
	}

	xmove(-D[0][0] / 2) {
		color("cyan")
			zrot(-90)
				xrot(90)
					linear_extrude(T)

						left_panel();
	}
}

module assemble_tray(D, T = T) {
	assemble_xy_panels(D, T);
	color("yellow")
		zmove(-D[0][1] / 2 - T)
			linear_extrude(T)
				bottom_panel();
}
