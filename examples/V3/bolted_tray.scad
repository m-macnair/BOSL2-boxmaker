// clang-format off

include<BOSL2-boxmaker/boxmakerV3.scad>;
include<BOSL2/screws.scad>;
include<BOSL2-defaults.scad>
	// clang-format on

	$model_version = "v1.0.1"; //2024-09-01
T				   = 6;
F_R				   = .1;
F_D				   = F_R * 2;

D		   = get_inner_box_dimensions(T, 40, 40, 40);
screw_type = "M4";
screw_head = "flat";

/* https://www.westfieldfasteners.co.uk/Standards/ScrewBolt_PoziCsk_M.pdf */
/*
	 M3 - 1.65
	 M4 - 2.2
	 M5 - 2.5
*/

info		  = screw_info(screw_type, head = screw_head);
nut_clearance = 3.1; /* bolt + washer */

echo("screw diameter: ", struct_val(info, "diameter"));
echo("head size: ", struct_val(info, "diameter"));

screw_length		 = 16;
screw_inset_distance = (screw_length - nut_clearance - T);

//screw_length = 30;

//left_panel();
//front_panel();
assemble_tray(D, spacing = 15);
//layout_tray(D, spacing = 15);
//
//diff()
//  cuboid(20)
//    attach(TOP)
//
//      #screw_hole("M4,40",head="flat",anchor=TOP);

module back_panel() {
	y_face_panel();
}

module right_panel() {
	x_face_panel();
}

module front_panel() {
	y_face_panel();
}

module bottom_panel() {

	square(D[4], anchor = CTR) {
		attach_male_x_edges(D[4][1], T);
		attach_male_y_edges(D[4][0], T);
	}
}

module y_face_panel() {
	diff()
		square(D[0], anchor = CTR) {
		attach_fat_front_corners(T);
		attach_female_fat_x_edges(D[0][1], T);

		tag("remove") attach(LEFT) back(T / 2) projection() xrot(90) screw_outbound(screw_head = "none");
		tag("remove") attach(RIGHT) back(T / 2) projection() xrot(90) screw_outbound(screw_head = "none");

		attach(FRONT)
			female_fat_edge_assembly(D[0][0], T, anchor = BOT);
	}
}

module x_face_panel() {
	diff("remove")
		square(D[1], anchor = CTR) {
		attach_male_x_edges(D[1][1], T);
		attach(LEFT)
			back(-screw_inset_distance) {
			projection()
				tag("remove")
					screw_outbound();
		}
		attach(RIGHT)
			back(-screw_inset_distance) {
			projection()
				tag("remove")
					screw_outbound();
		}

		attach(FRONT)
			female_fat_edge_assembly(D[1][0], T, anchor = BOT);
	}
}

module screw_outbound(screw_head = screw_head) {
	/* head_oversize is apparently not accessible? */
	screw(screw_type, head_undersize = .5, thread = "none", l = screw_length, head = screw_head, anchor = TOP, orient = FRONT, bevel1 = false);
}

module left_panel() {
	x_face_panel();
}
