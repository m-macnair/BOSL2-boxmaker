// clang-format off
include<./shared_attributes.scad>;
include<BOSL2-boxmaker/boxmaker4/fat_top_box.scad>;

// clang-format on
$fn					 = 60;		 // circular part resolution
$fat_top_box_version = "v1.1.0"; //2026-08-29
F_R					 = .05;
F_D					 = F_R * 2;
T					 = 3;
D					 = get_outer_fat_tray_dimensions(T, 150, 200, 120);

assemble_box(D, spacing = T * 3);
//bottom_panel(D,T);
