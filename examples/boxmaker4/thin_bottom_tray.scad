// clang-format off
include<./shared_attributes.scad>;
include<BOSL2-boxmaker/boxmaker4.scad>;
include<BOSL2-boxmaker/boxmaker4/thin_bottom_tray.scad>;

// clang-format on
$thin_bottom_tray_version = "v1.1.0"; //2024-06-09
$fn						  = 60;		  // circular part resolution
F_R						  = .05;
F_D						  = F_R * 2;
T						  = 3;
D						  = get_outer_fat_tray_dimensions(T, 150, 200, 15);

assemble_tray(D, spacing = T);
//bottom_panel(D,T);