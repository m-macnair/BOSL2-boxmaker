// clang-format off

include<BOSL2-boxmaker/boxmaker3.scad>;
include<./shared_attributes.scad>;
// clang-format on
$fn			   = 60;	   // circular part resolution
$model_version = "v1.1.0"; //2024-06-09
F_R			   = .1;
F_D			   = F_R * 2;

D = get_outer_fat_tray_dimensions(T, 140, 260, 60);

assemble_tray(D);

module back_panel(D, T) {

	y_panel(D, T);
}

module right_panel(D, T) {

	x_panel(D, T);
}

module front_panel(D, T) {
	difference() {
		y_panel(D, T);
		xcopies(n = 2, (D[1][0] / 2) - T * 2)
#circle(d = 3.1);
	}
}

module bottom_panel(D, T) {

	square(D[4], anchor = CTR) {
		attach_female_fat_y_edges(D[4][0], T);
		attach_female_fat_x_edges(D[4][1], T);
		attach_fat_corners(T);
	}
}

module y_panel(D, T) {
	square(D[0], anchor = CTR) {
		attach_male_x_edges(D[0][1], T);
		attach(FRONT)
			male_edge_teeth(D[0][0], T, anchor = BOT);
	}
}

module x_panel(D, T) {
	square(D[1], anchor = CTR) {
		attach_female_fat_x_edges(D[0][1], T);
		attach(FRONT)
			male_edge_teeth(D[1][0], T, anchor = BOT);
	}
}

module left_panel(D, T) {
	x_panel(D, T);
}
