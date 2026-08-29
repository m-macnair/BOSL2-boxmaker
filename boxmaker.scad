// clang-format off
include<BOSL2/std.scad>
	// clang-format on
	// fudge factor for voids to accomodate machine error
	/* TODO: make this get_slop */
	F = .04;

module tray(X, Y, Z, T, W, margin = 20) {

	zmargin = (Z / 2) + margin;

	zmove(-zmargin)
		color("blue")
			yrot(180)
				linear_extrude(T)

					xf_ym0_face(X, Y, T, W, anchor = CENTER, x_extra = T);

	ymargin = (Y / 2) + T + margin;
	ymove(ymargin)
		color("green")
			xrot(90)
				linear_extrude(T) xm_ym_face(X, Z, T, W, anchor = CENTER);
	ymove(-ymargin)
		xrot(-90)
			color("yellow")
				linear_extrude(T) xm_ym_face(X, Z, T, W, anchor = CENTER);

	xmargin = (X / 2) + T + margin;
	color("cyan")
		xmove(-xmargin) yrot(90) linear_extrude(T) xf_yf_face(Z, Y, T, W, anchor = CENTER);
	color("magenta")
		xmove(xmargin) yrot(-90) linear_extrude(T) xf_yf_face(Z, Y, T, W, anchor = CENTER);
}

module exploded_cube_view(X, Y, Z, T, W, margin = 20) {

	zmargin = (Z / 2) + margin;
	color("red")
		zmove(zmargin)

			linear_extrude(T)

				xf_ym_face(X, Y, T, W, anchor = CENTER, x_extra = T);
	zmove(-zmargin)
		color("blue")
			yrot(180)
				linear_extrude(T)
					xf_ym_face(X, Y, T, W, anchor = CENTER, x_extra = T);

	ymargin = (Y / 2) + T + margin;
	ymove(ymargin)
		color("green")
			xrot(90)
				linear_extrude(T) xm_ym_face(X, Z, T, W, anchor = CENTER);
	ymove(-ymargin)
		xrot(-90)
			color("yellow")
				linear_extrude(T) xm_ym_face(X, Z, T, W, anchor = CENTER);

	xmargin = (X / 2) + T + margin;
	color("cyan")
		xmove(-xmargin) yrot(90) linear_extrude(T) xf_yf_face(Z, Y, T, W, anchor = CENTER);
	color("magenta")
		xmove(xmargin) yrot(-90) linear_extrude(T) xf_yf_face(Z, Y, T, W, anchor = CENTER);
}

module exploded_square_view(X, Y, Z, T, W, spacing = X) {

	//    xdistribute(sizes=[X, Y, Z], spacing=spacing) {
	xdistribute(sizes = [ X, X, X, Y, Y, Y ], spacing = spacing) {
		color("red")
			xf_ym_face(X, Y, T, W, anchor = BOT);
		color("blue")
			xf_ym_face(X, Y, T, W, anchor = CENTER, x_extra = T);
		color("green")
			xm_ym_face(X, Z, T, W, anchor = CENTER);

		color("yellow")
			xm_ym_face(X, Z, T, W, anchor = CENTER);

		color("cyan")
			xf_yf_face(Z, Y, T, W, anchor = CENTER);

		color("magenta")
			xf_yf_face(Z, Y, T, W, anchor = CENTER);
	}
}

// main method - fully and independently customisable tabbed panel - no automatic adjustment for long edges
// given
//    xyz dimensions for a main cube
//    an array of optional edge specifications for 0,90,180 and 270 degree edge
//       m/f for edge type
//          x axis
//          material thickness
//          tab width
//          optional fudge
//          x_extra - extra material to add to the x  for handling 3d joins
//          y_extra - as above on y axis
// return a tabbed panel
// feasibly this could be used to have inset tabs as well

module dynamic_panel_square(x, y, tab_vector, f = F, anchor = CTR) {

	//feasibly this could be a children() call ?
	attach_points = [ BACK, RIGHT, FRONT, LEFT ];
	union() {
		square([ x, y ], anchor = anchor) {
			for (A = [ 0, 1, 2, 3 ]) {
				if (is_list(tab_vector[A])) {
					if (tab_vector[A][0] == "m") {
						attach(attach_points[A]) edge_square_m(tab_vector[A][1], tab_vector[A][2], tab_vector[A][3]);
					} else {
						attach(attach_points[A]) fat_edge_square_f(tab_vector[A][1], tab_vector[A][2], tab_vector[A][3], tab_vector[0][4], f);
					}
				}
			}
		}
	}
}

module xm_yf_face(x, y, t, w, f = F, anchor = BOT) {

	x_axis_tabs = [
		"m",
		x,
		t,
		w
	];
	y_axis_tabs = [
		"f",
		y,
		t,
		w
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs,
		y_axis_tabs,
	],
						 anchor = anchor);
}

module xf_ym_face(x, y, t, w, f = F, anchor = BOT, x_extra = 0, y_extra = 0) {

	x_axis_tabs = [
		"f",
		x,
		t,
		w,
		x_extra
	];
	y_axis_tabs = [
		"m",
		y,
		t,
		w,
		y_extra
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs,
		y_axis_tabs,
	]);
}

module xf_yf_face(x, y, t, w, f = F, anchor = BOT) {

	x_axis_tabs = [
		"f",
		x,
		t,
		w,
		0
	];
	y_axis_tabs = [
		"f",
		y,
		t,
		w,
		0
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs,
		y_axis_tabs,
	]);
}

module xm_ym_face(x, y, t, w, f = F, anchor = BOT) {

	x_axis_tabs = [
		"m",
		x,
		t,
		w,
		0
	];
	y_axis_tabs = [
		"m",
		y,
		t,
		w,
		0
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs,
		y_axis_tabs,
	]);
}

// TODO refactor shared calculation into function (?)

module xm_yf0_face(x, y, t, w, f = F, anchor = BOT) {

	x_axis_tabs = [
		"m",
		x,
		t,
		w
	];
	y_axis_tabs = [
		"f",
		y,
		t,
		w
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs
	],
						 anchor = anchor);
}

module xm_ym0_face(x, y, t, w, f = F, anchor = BOT) {

	x_axis_tabs = [
		"m",
		x,
		t,
		w,
		0
	];
	y_axis_tabs = [
		"m",
		y,
		t,
		w,
		0
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs
	]);
}

module xf_ym0_face(x, y, t, w, f = F, anchor = BOT, x_extra = 0, y_extra = 0) {

	x_axis_tabs = [
		"f",
		x,
		t,
		w,
		x_extra
	];
	y_axis_tabs = [
		"m",
		y,
		t,
		w,
		y_extra
	];
	dynamic_panel_square(x, y, [
		x_axis_tabs,
		y_axis_tabs,
		x_axis_tabs
	]);
}

module edge_square_m(x, t, min_tab_width) {

	//usable full min_tab_width segments in x
	// TODO : can this be refactored?
	segments = floor(x / min_tab_width);
	// note lack of fudge - included to simplify calls
	tab_x		= min_tab_width;
	tab_y		= t;
	teeth_count = ceil(segments / 2);
	edge_margin = (x - (min_tab_width * segments)) / 2;
	overlap		= .1;
	ymove(-overlap) union() {
		xcopies(n = teeth_count - 1, spacing = (min_tab_width * 2)) {
			square([ tab_x, tab_y + overlap ], anchor = BOT);
		}
	}
}
//Given
//    x of edge length
//    t of material width, which translates to the y to use
//    tab_width as minimum tab width
//    fudge as machine error handling correction as mm
//
//    create a fat edged tabbed f socket piece for a corresponding m piece

module fat_edge_square_f(x, t, min_tab_width, extra = 0, fudge = F) {

	//usable full min_tab_width segments in x
	// TODO : can this be refactored?
	segments	= floor(x / min_tab_width);
	tab_x		= min_tab_width - (fudge / 2);
	tab_y		= t;
	teeth_count = ceil(segments / 2);
	edge_margin = (x - (min_tab_width * segments)) / 2;

	// TODO: detect some form of debug mode and add colour mods conditionally
	union() {
		xcopies(n = teeth_count, spacing = (min_tab_width * 2)) {
			square([ tab_x, tab_y ], anchor = BOT);
		}
		xmove(-((x / 2) + extra))
			square([ min_tab_width + extra, tab_y ], anchor = BOT + LEFT);
		xmove((x / 2) + extra)
			square([ min_tab_width + extra, tab_y ], anchor = BOT + RIGHT);
	}
}

module fat_edge_cube_f(x, t, tab_width, fudge = F) {
	linear_extrude(t, false) edge_square_f(x, t, tab_width, fudge);
}

module edge_cube_m(x, t, tab_width, fudge = F) {
	linear_extrude(t, false) edge_square_m(x, t, tab_width, fudge);
}
