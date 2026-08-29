// clang-format off

include<BOSL2-boxmaker/boxmaker3.scad>;
include<./shared_attributes.scad>;

// clang-format on
$fn = 60; // circular part resolution

$postal_box_cabinets_version = "v1.1.0"; //2024-06-09
F_R							 = .1;
F_D							 = F_R * 2;

//D = get_inner_thin_tray_dimensions(T, 350, 700, 600);
/* I do not understand why this works but other approaches don't - someting to do with functions returning vectors */
//D = fat_bottom_box(T*2,[ 11, 22, 33])[0];
//D = fat_bottom_box(T*2,[ 600, 700, 350])[0];

/* Kitchen Top */
Q = [ 1940, 450, 200 - (T * 2) ];
D = fat_bottom_cabinet(T * 2, Q)[0];
//D = side_bound_cabinet(T * 2, [ 1200, 400 , 300-(T*2) ])[0];
echo_the_dimensions(D);

//assemble_attachable_cabinet(D, T, spacing = 0);
projection() scale([ .1, .1 ]) layout_attachable(D, T, spacing = 10);
//bottom_panel(D,T);

module bottom_panel(D, T, anchor, spin, orient) {
	/* I don't get why it has to be like this  - something to do with children () probably*/
	key = 4;
	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("YELLOW")
			panel_3d(D[key], T);
		children();
	}
}

module back_panel(D, T, anchor, spin, orient) {
	key = 0;

	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("RED")
			panel_3d(D[key], T);
		children();
	}
}

module right_panel(D, T, anchor, spin, orient) {
	key = 1;
	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("GREEN")
			panel_3d(D[key], T);
		children();
	}
}
module front_panel(D, T, anchor, spin, orient) {
	key = 2;
	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("BLUE")
			panel_3d(D[key], T);
		children();
	}
}

module left_panel(D, T, anchor, spin, orient) {
	key = 3;
	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("CYAN")
			panel_3d(D[key], T);
		children();
	}
}

module top_panel(D, T, anchor, spin, orient) {
	key = 5;
	attachable(anchor, spin, orient, size = [ D[key][0], D[key][1], T ]) {
		color("MAGENTA")
			panel_3d(D[key], T);
		children();
	}
}
