// clang-format off
include<BOSL2/std.scad>
	// clang-format on
	// margin in mm for f parts to accomodate machine error;
	$slop = 0.075;

module tray_btm(X, Y, Z, T, W, margin = 20) {
	difference() {
		square([ X, Y ], anchor = CTR);

		xcopies(X - (T * 3), n = 2)
			ycopies((Y / 7) * 2, n = 3)
				color("red")
					square([ T + $slop, Y / 7 + $slop ], anchor = CTR);

		ycopies(Y - (T * 3), n = 2)
			xcopies((X / 7) * 2, n = 3)
				color("red")
					square([ X / 7 + $slop, T + $slop ], anchor = CTR);
	}
}

module tray_y(X, Y, Z, T, W, margin = 20, y_tabs = 1) {
	z = Z - T;
	difference() {
		union() {
			square([ z, Y ], anchor = CTR);
			if (y_tabs == 1) {
				xmove(z / 2 + T / 2 - .1)
					ycopies((Y / 7) * 2, n = 3)
						color("blue")
							square([ T + .1, Y / 7 ], anchor = CTR);
			}
		}

		ycopies(Y - (T * 3), n = 2)
			xcopies((z / 7) * 2, n = 3)
				color("red")
					square([ z / 7 + $slop, T + $slop ], anchor = CTR);
	}
}

module tray_x(X, Y, Z, T, W, margin = 20, x_tabs = 1, y_tabs = 1) {
	z = Z - T;
	union() {
		square([ z, X - (T * 4) ], anchor = CTR);
		if (y_tabs != 0) {
			xmove(z / 2 + T / 2 - .1)
				ycopies((X / 7) * 2, n = 3)
					color("blue")
						square([ T + .1, X / 7 ], anchor = CTR);
		}
		if (x_tabs != 0) {
			ycopies(X - (T * 3) - .1, n = 2)
				xcopies((z / 7) * 2, n = 3)
					color("blue")
						square([ z / 7, T + .1 ], anchor = CTR);
		}
	}
}
