// clang-format off
include<BOSL2/std.scad>
include<boxmaker.scad>
		// clang-format on

		//desired internal void dimensions
		X = 150;
Y		  = 150;
Z		  = 50;

// material thickness
T = 4;
// MINIMUM tab width
W = 10;
//
//xm_yf_face(X,Y,T,W);
//
//
//xmove(Y + Y/2)
//    xf_ym_face(Z,Y,T,W);
//
//

exploded_square_view(X, Y, Z, T, W);

//        x_axis_tabs = [
//            "m",X ,T,W
//        ];
//        y_axis_tabs = [
//            "f",Y + (T * 2) ,T,W
//        ];
//        dynamic_panel_square(X,Y,[
//            x_axis_tabs,
//            y_axis_tabs,
//            x_axis_tabs,
//            y_axis_tabs,
//        ] );

//exploded_square_view(X,Y,Z,T,W, margin = 1 );

//color("blue",0.2)
//edge_square_f(X,T,W);
//xmove(X/2){
//    ymove(T + (T/2))
//    edge_square_m(X,T,W);
//    fat_edge_square_f(X,T,W);
//}

//    ymove (5)
//    edge_square_m(X,T,W);

//ymove (40){
//edge_cube_f(X,T,W);
//ymove (20)
//edge_cube_m(X,T,W);
//}