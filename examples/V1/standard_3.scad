// clang-format off
include<BOSL2/std.scad>
include<boxmaker.scad>
include<floating_boxmaker.scad>
			// clang-format on

			// material thickness
			T = 6;

//foot plate +  height
X = 110;
Y = 250;
Z = 80;

// MINIMUM tab width
W = 25;

tray_btm(X, Y, Z, T, W);
xcopies(X * 2, n = 2) {
	tray_y(X, Y, Z, T, W);
}
ymove(-(Y / 2 + Z))
	zrot(90)

		tray_x(X, Y, Z, T, W);

ymove((Y / 2 + Z))
	zrot(270)
		difference() {

	tray_x(X, Y, Z, T, W);
	zrot(90) {
		ymove(-15)
			text("Driver", anchor = CTR, size = 15, font = "USSR STENCIL");
		ymove(15)
			text("Cross", anchor = CTR, size = 15, font = "USSR STENCIL");
	}
}

//back(Y/2 + 55 )
//zmove(-1)        tray_y(X,Y,Z,T,W);
//        tray_x(X,Y,Z,T,W);

//
//xm_yf_face(X,Y,T,W);
//
//
//xmove(Y + Y/2)
//    xf_ym_face(Z,Y,T,W);
//
//
//linear_extrude(T)
//tray_btm(X,Y,Z,T,W);
//up( Z/2 + T)
//xcopies(X  - (T*3))
//yrot(90)
//linear_extrude(T)
//tray_y(X,Y,Z,T,W);
//
//ycopies(Y - T, n =2  )
//zmove(Z/2 + T)
//yrot(90)
//xrot(90)
//
//linear_extrude(T)
//tray_x(X,Y,Z,T,W);
//

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