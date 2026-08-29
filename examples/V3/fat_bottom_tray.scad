// clang-format off

include<BOSL2-boxmaker/boxmakerV3.scad>;

// clang-format on
$fn			   = 60;	   // circular part resolution
$slop		   = 0.5;	   // BOSL2 margin of error for bolt threads
$model_version = "v1.1.0"; //2024-06-09
T			   = 4;
F_R			   = .05;
F_D			   = F_R * 2;

D = get_outer_fat_tray_dimensions(T, 140, 260, 30);

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

		attach(LEFT + FRONT)
			xmove(-O_m)
				ymove(-O_m)
					zrot(45) {
#square(T * 2);
		}
		attach(RIGHT + FRONT)
			xmove(-O_m)
				ymove(-O_m)
					zrot(45) {
#square(T * 2);
		}
		attach(LEFT + BACK)
			xmove(-O_m)
				ymove(-O_m)
					zrot(45) {
#square(T * 2);
		}
		attach(RIGHT + BACK)
			xmove(-O_m)
				ymove(-O_m)
					zrot(45) {
#square(T * 2);
		}
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
