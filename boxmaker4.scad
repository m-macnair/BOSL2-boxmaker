/*
	 ai_contract:ai_assisted
*/
// clang-format off
include<BOSL2/std.scad>
	// clang-format on
	$boxmaker4_version = "v1.0.0";
/* slop margin in mm for female/socket/void parts  - typically overwritten*/
S_f = .03;
/* Overlap margin for parts that boolean union into other parts - very helpful for it to be an even number*/
O_m = .002;
/* 
	 0 = back - Red 
	 1 = right - green
	 2 = front - blue
	 3 = left - magenta
	 4 = bottom - cyan
	 5 = top  - yellow

	 fat = enclosed male teeth331
	 
	 thin = non-enclosed male teeth
*/

/* 
	 given x,y and z  dimensions of enclosed space, 
	 return enclosure dimensions regardless of teeth definition 
*/
function get_inner_box_dimensions(T, x, y, z) = [
	//
	[ x, z ], /*back*/
	[ y, z ], /*right*/
	[ x, z ], /*front*/
	/**/
	[ y, z ], /*left*/
	[ x, y ], /*bottom*/
	[ x, y ]  /*top*/
];

/*
	 given maximum desired outer dimensions, 
	 return panels for a tray with a maximally sized bottom panel
	 and minimally sized front and back panels
	 
*/
function get_outer_fat_tray_dimensions(T, x, y, z) = [
	//
	[ x - (T * 4), z - (T * 1) ], /*back*/
	[ y - (T * 4), z - (T * 1) ], /*right*/
	[ x - (T * 4), z - (T * 1) ], /*front*/
	/**/
	[ y - (T * 4), z - (T * 1) ], /*left*/

	[ x - (T * 4), y - (T * 4) ], /*bottom*/
];

/*
	 as get_outer_fat_tray_dimensions but use a specific desired interior space and work out what neeeds added from that
	 
*/
function get_inner_fat_tray_dimensions(T, x, y, z) = [

	[ x - (T * 4), z - (T * 2) ], /*back*/
	[ y - (T * 4), z - (T * 2) ], /*right*/
	[ x - (T * 4), z - (T * 2) ], /*front*/
	/**/
	[ y - (T * 4), z - (T * 2) ], /*left*/
	[ x - (T * 4), y - (T * 4) ], /*bottom*/
];

/*
	 male_edge_teeth 
	 Given:
			dimension O_m edge to attach tabs
			material thickness used for tab y dimension
			teeth/tab count if more than 2
			non-default overlap for union() in calling method
	 return attachable tooth assembly
*/
module male_edge_teeth(x, t, teeth = 2, overlap_forward = O_m, overlap_back = 0, anchor = CTR, spin) {
	assert(!is_undef(t), "t value cannot be inferred from a default and must be supplied");
	segments = (teeth * 2) + 1;
	tab_x	 = x / segments;

	/* This works because the overlap margin _already_ adds half of the overlap required, and then the fwd cuts it off the opposite edge */
	overlap = overlap_forward + overlap_back;
	tab_y	= t + overlap;

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ x + (t * 2), t ]) {
		adjust_for_overlap(overlap_forward, overlap_back) union() {
			xcopies(n = teeth, tab_x * 2) {
				square([ tab_x, tab_y ], anchor = CTR);
			}
		}
		children();
	}
}

/* TODO: refactor this and the above to use functions */
module male_fat_edge_teeth(x, t, teeth = 2, overlap_forward = O_m, overlap_back = 0, anchor = CTR, spin) {
	assert(!is_undef(t), "t value cannot be inferred from a default and must be supplied");
	segments = (teeth * 2) + 1;
	tab_x	 = x / segments;

	/* This works because the overlap margin _already_ adds half of the overlap required, and then the fwd cuts it off the opposite edge */
	overlap = overlap_forward + overlap_back;
	tab_y	= t + overlap;

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ x + (t * 2), t ]) {
		adjust_for_overlap(overlap_forward, overlap_back) union() {
			xcopies(n = teeth, tab_x * 2) {
				square([ tab_x, tab_y ], anchor = CTR);
			}
			xcopies(n = teeth, x + (t)) {
				square([ t, tab_y ], anchor = CTR);
			}
		}
		children();
	}
}

module adjust_for_overlap(overlap_forward, overlap_back) {
	fwd(overlap_forward / 2)
		back(overlap_back / 2)
			children();
}

module female_thin_edge_teeth(
	X,
	T	  = T,
	teeth = 2,

	overlap = O_m,
	anchor	= CTR,
	spin	= 0,

	y_extra = 0) {
	echo("working_x:", X);
	segments  = (teeth * 2) + 1;
	segment_x = X / segments;
	echo("segment_x:", segment_x);

	tab_x = segment_x - S_f;
	echo("tab_x:", tab_x);

	tab_y = T + y_extra + overlap;
	echo("tab_y:", tab_y);

	spacing = (tab_x * 2) + (S_f * 2) + S_f / 2;
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

module female_fat_edge_assembly(X, T = T, teeth = 2, overlap = O_m, anchor = CTR, spin) {
	lip_y = T - S_f;
	echo("lip_y:", lip_y);

	attachable(anchor = anchor, spin = spin, two_d = true, size = [ X, O_m + (T * 2) ]) {
		union()
			female_thin_edge_teeth(
				X, T, teeth, overlap, anchor = BACK, y_extra = (O_m * 4) + S_f) {
			attach(BACK) {
				color("blue")
					back(-O_m * 2)
						square([ X, lip_y ], anchor = FRONT);
			}
		}
		children();
	}
}

module attach_male_x_edges(X, T, teeth = 2) {
	attach(LEFT)
		male_edge_teeth(X, T, anchor = BOT, teeth = teeth);
	attach(RIGHT)
		male_edge_teeth(X, T, anchor = BOT, teeth = teeth);
}

module attach_male_y_edges(Y, T) {
	attach(BACK)
		male_edge_teeth(Y, T, anchor = BOT);
	attach(FRONT)
		male_edge_teeth(Y, T, anchor = BOT);
}

module attach_female_fat_x_edges(X, T, teeth = 2) {
	attach(LEFT)
		female_fat_edge_assembly(X, T, anchor = BOT);
	attach(RIGHT)
		female_fat_edge_assembly(X, T, anchor = BOT);
}
module attach_female_thin_x_edges(X, T, teeth = 2) {
	attach(LEFT)
		female_thin_edge_teeth(X, T, anchor = BOT, teeth = teeth);
	attach(RIGHT)
		female_thin_edge_teeth(X, T, anchor = BOT, teeth = teeth);
}

module attach_female_fat_y_edges(X, T, teeth = 2) {
	attach(BACK)
		female_fat_edge_assembly(X, T, anchor = BOT);
	attach(FRONT)
		female_fat_edge_assembly(X, T, anchor = BOT);
}
module attach_female_thin_y_edges(X, T, teeth = 2) {
	attach(BACK)
		female_thin_edge_teeth(X, T, anchor = BOT, teeth = teeth);
	attach(FRONT)
		female_thin_edge_teeth(X, T, anchor = BOT, teeth = teeth);
}

/* 
	 within a thin panel{}'s definition, 
	 usually after teeth attachment, 
	 add squares so that the teeth of the panel are within a square instead of poking out 
*/
module attach_fat_corners(T, O_m = O_m) {
	attach_fat_back_corners(T, O_m);
	attach_fat_front_corners(T, O_m);
}

module attach_fat_back_corners(T, O_m = O_m) {
	Dc = (T * 2) + O_m;
	attach(LEFT + BACK)
		zrot(45)
			xmove(-O_m)
				ymove(-O_m)

					square(Dc);

	attach(RIGHT + BACK)
		zrot(45)
			xmove(-O_m)
				ymove(-O_m)
					square(Dc);
}

module attach_fat_front_corners(T, O_m = O_m) {
	Dc = (T * 2) + O_m;
	attach(LEFT + FRONT)
		zrot(45)
			xmove(-O_m)
				ymove(-O_m)

					square(Dc);

	attach(RIGHT + FRONT)
		zrot(45)
			xmove(-O_m)
				ymove(-O_m)

					square(Dc);
}

module assemble_xy_panels(D, T, spacing = 10) {

	diagonal = spacing / 2;

	translate([ 0, diagonal, diagonal ])
		ymove(D[1][0] / 2) {
		color("red")
			zrot(180)
				xrot(90)
					linear_extrude(T)

						back_panel(D, T);
	}
	translate([ 0, -diagonal, diagonal ])
		ymove(-D[1][0] / 2) {
		color("blue")
			xrot(90)
				linear_extrude(T)

					front_panel(D, T);
	}
	translate([ diagonal, 0, diagonal ])
		xmove(D[0][0] / 2) {
		color("green")
			zrot(90)
				xrot(90)
					linear_extrude(T)

						right_panel(D, T);
	}
	translate([ -diagonal, 0, diagonal ])
		xmove(-D[0][0] / 2) {
		color("magenta")
			zrot(-90)
				xrot(90)
					linear_extrude(T)

						left_panel(D, T);
	}
}

module layout_tray(D, T = T, spacing = 0) {
	q		  = (T * 4) + spacing;
	x_spacing = ((D[4][0] + D[3][1]) / 2) + q;
	y_spacing = ((D[4][1] + D[0][1]) / 2) + q;

	color("cyan")
		bottom_panel(D, T);

	back(y_spacing)
		color("red")
			back_panel(D, T);

	right(x_spacing)
		color("green")
			zrot(-90)
				right_panel(D, T);

	back(-y_spacing)
		color("blue")
			zrot(180)
				front_panel(D, T);

	left(x_spacing)
		color("magenta")
			zrot(90)
				left_panel(D, T);
}

module layout_movement_tray(D, T = T, spacing = 0) {
	q		  = T + spacing;
	x_spacing = ((D[4][0] + D[3][1]) / 2) + q;
	y_spacing = ((D[4][1] + D[0][1]) / 2) + q;

	color("cyan")
		bottom_panel(D, T);

	back(y_spacing)
		color("red")
			back_panel(D, T);

	right(x_spacing)
		color("green")
			zrot(-90)
				right_panel(D, T);

	back(-y_spacing)
		color("blue")
			zrot(180)
				front_panel(D, T);

	left(x_spacing)
		color("magenta")
			zrot(90)
				left_panel(D, T);
}

module layout_movement_tray_edges_together(D, T = T, spacing = 0) {
	q		  = T + spacing;
	x_spacing = ((D[4][0] + D[3][1]) / 2) + q;
	y_spacing = ((D[4][1] + D[0][1]) / 2) + q;

	back() {
		color("red")
			back_panel(D, T);
		color("blue")
			back(D[1][1] + get_slop())
				zrot(180)
					front_panel(D, T);
	}
	fwd(D[4][1] / 2 + D[1][1] * 1.5 + get_slop()) {
		color("cyan") bottom_panel(D, T);
	}

	back(D[1][1] * 4 + get_slop()) {
		color("yello")
			right_panel(D, T);
		color("magenta")
			back(D[1][1] + get_slop())
				zrot(180)
					left_panel(D, T);
	}
}

module assemble_tray(D, T = T, spacing = 0) {
	assemble_xy_panels(D, T, spacing);

	color("yellow")
		down(
			((D[0][1]) / 2) + T + spacing)
			linear_extrude(T)
				bottom_panel(D, T);
}

module assemble_box(D, T = T, spacing = 0) {
	assemble_xy_panels(D, T, spacing);
	assemble_tray(D, T, spacing);
	color("cyan")
		up(
			((D[0][1]) / 2) - T + spacing)
			linear_extrude(T)
				bottom_panel(D, T);
}

/* male on both x and front y edge */
module standard_tray_y_panel(D, T, anchor, spin) {

	attachable(
		anchor = anchor,
		spin   = spin,
		two_d  = true,
		size   = [
			  D[0][0] + (T * 2),
			  D[0][1] +
			  T
		]) {
		back(T / 2)
			square(D[0], anchor = CTR) {
			attach_male_x_edges(D[0][1], T);
			attach(FRONT)
				male_edge_teeth(D[0][0], T, anchor = BOT);
		}

		children();
	}
}
/* fat female on x and male on front y edge */
module standard_tray_fat_x_panel(D, T, anchor, spin) {

	attachable(
		anchor = anchor,
		spin   = spin,
		two_d  = true,
		size   = [
			  D[0][0] + (T * 2),
			  D[1][0] +
			  T
		]) {
		back(T / 2) {
			square(D[1], anchor = CTR) {
				attach_female_fat_x_edges(D[0][1], T);
				attach(FRONT)
					male_edge_teeth(D[1][0], T, anchor = BOT);
			}
		}
		children();
	}
}

module standard_tray_fat_z_panel(D, T, anchor, spin) {

	attachable(
		anchor = anchor,
		spin   = spin,
		two_d  = true,
		size   = [
			  D[0][0] + (T * 2),
			  D[1][0] +
			  T
		]) {
		square(D[4], anchor = CTR) {
			attach_female_fat_y_edges(D[4][0], T);
			attach_female_fat_x_edges(D[4][1], T);
			attach_corner_squares(T, T);
		}
		children();
	}
}

module panel_3d(d, T, anchor, spin, orient) {
	attachable(anchor, spin, orient, size = [ d[0], d[1], T ]) {
		cube([ d[0], d[1], T ], anchor = CTR);
		children();
	}
}

/* 
	 this _HAS_ to use the returned [0] value, otherwise it returns a vector of a vector of vectors, instead of a vector of vectors as intended and I don't know why 
	 green and cyan are the correct size - if they were not spaced out, they'd overlap with red and blue
*/
function fat_bottom_box(fat, pure) = [fatten_bottom_y(fat,
													  pure_box(pure[0], pure[1], pure[2]))];

function fat_bottom_cabinet(fat, pure) = [fatten_bottom_y(fat,
														  pure_box(pure[0], pure[1], pure[2]))];

function movement_tray(pure, T)		   = [pure_box(pure[0], pure[1], pure[2])];
function side_bound_cabinet(fat, pure) = [fatten_side_z(fat,
														pure_box(pure[0], pure[1], pure[2]))];

/* slightly worrying that i've been doing this WRONG for months */
function pure_box(x, y, z) = [[x, z], /*back*/
							  [y, z], /*right*/
							  [x, z], /*front*/
							  /**/
							  [y, z], /*left*/
							  [x, y], /*bottom*/
							  [x, y]  /*top*/
];

function fatten_bottom_y(q, D) = [[D [0] [0], D [0] [1]], /*back*/
								  [D [1] [0], D [1] [1]], /*right*/
								  [D [2] [0], D [2] [1]], /*front*/
								  /**/
								  [D [3] [0], D [3] [1]],	  /*left*/
								  [D [4] [0] + q, D [4] [1]], /*bottom*/
								  [D [5] [0] + q, D [5] [1]]  /*top*/
];

function fatten_side_z(q, D) = [[D [0] [0], D [0] [1]],		/*back*/
								[D [1] [0], D [1] [1] + q], /*right*/
								[D [2] [0], D [2] [1]],		/*front*/
								/**/
								[D [3] [0], D [3] [1] + q], /*left*/
								[D [4] [0], D [4] [1]],		/*bottom*/
								[D [5] [0], D [5] [1]]		/*top*/
];

module assemble_attachable_tray(D, T = T, spacing = 0) {

	bottom_panel(D, T) {
		attach(TOP) {
			attach(BACK) up(spacing) back(spacing) back_panel(D, T, anchor = FRONT + TOP);
			attach(RIGHT) color("GREEN") up(spacing) back(spacing) right_panel(D, T, anchor = FRONT + TOP);
			attach(FRONT) color("BLUE") up(spacing) back(spacing) front_panel(D, T, anchor = FRONT + TOP);
			attach(LEFT) color("CYAN") up(spacing) back(spacing) left_panel(D, T, anchor = FRONT + TOP);
		}
	}
}

module assemble_attachable_cabinet(D, T = T, spacing = 0) {

	bottom_panel(D, T) {
		attach(TOP) {
			attach(BACK) up(spacing) back(spacing) back_panel(D, T, anchor = FRONT + TOP) {
				position(BACK + TOP) back(spacing) top_panel(D, T, anchor = FRONT + BOT, orient = BACK);
			}
			attach(RIGHT) up(spacing) back(spacing) right_panel(D, T, anchor = FRONT + TOP);
			attach(LEFT) up(spacing) back(spacing) left_panel(D, T, anchor = FRONT + TOP);
		}
	}
}

module layout_attachable(D, T = T, spacing = 0, skip) {

	bottom_panel(D, T) {
		position(BACK) back(spacing) back_panel(D, T, anchor = FRONT);
		position(RIGHT) right(spacing) right_panel(D, T, anchor = FRONT, spin = -90);
		position(FRONT) fwd(spacing) front_panel(D, T, anchor = BACK);
		position(RIGHT) right(spacing) right_panel(D, T, anchor = FRONT, spin = -90);
		position(LEFT) left(spacing) left_panel(D, T, anchor = FRONT, spin = 90);
		position(BACK + RIGHT) right(spacing) back(spacing) top_panel(D, T, anchor = FRONT + LEFT);
		//	 }
		//
		//				 attach(BACK)   up(spacing) back(spacing) ,anchor = FRONT+TOP){
		//						position(BACK+TOP)   up(spacing) back(spacing) top_panel(D,T,anchor = FRONT+BOT , orient =BACK);
		//				 }
		//				 attach(RIGHT)  up(spacing) back(spacing) right_panel(D,T,anchor = FRONT+TOP);
		//				 attach(LEFT)  up(spacing) back(spacing) left_panel(D,T,anchor = FRONT+TOP);
		//				 }
		//	 }
	}
}

/* Thin trays attach only the teeth, the extra material at the 4 corners needs to be specified */
module attach_corner_squares(nominal_csquare_x, nominal_csquare_y, O_m = O_m, ) {
	adjusted_csquare_x = nominal_csquare_x + O_m;
	adjusted_csquare_y = nominal_csquare_y + O_m;
	/* */
	_corner_square(adjusted_csquare_x, adjusted_csquare_y, O_m, BACK + LEFT);
	_corner_square(adjusted_csquare_x, adjusted_csquare_y, O_m, BACK + RIGHT);
	_corner_square(adjusted_csquare_x, adjusted_csquare_y, O_m, FRONT + LEFT);
	_corner_square(adjusted_csquare_x, adjusted_csquare_y, O_m, FRONT + RIGHT);
}

function opposite_corner(c) = -c;

module _corner_square(x, y, O_m, parent_corner) {
	//	 up(10)
	child_corner = opposite_corner(parent_corner);
	position(parent_corner)
		//	 echo(parent_corner);
		translate([
			-parent_corner[0] * O_m,
			-parent_corner[1] *
			O_m
		])
		//
		square([ x, y ], anchor = child_corner);
}

module echo_the_dimensions(D) {
	echo("back panel:", D[0][0], " by ", D[0][1]);
	echo("left panel:", D[1][0], " by ", D[1][1]);
	echo("front panel:", D[2][0], " by ", D[2][1]);
	echo("right panel:", D[3][0], " by ", D[3][1]);
	echo("bottom panel:", D[4][0], " by ", D[4][1]);
	echo("top panel:", D[5][0], " by ", D[5][1]);
}