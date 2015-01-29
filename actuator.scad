
servo_axle_height = 10;
servo_axle_diam = 10;

screw_cap_height = 1;
screw_cap_diam = 4;
screw_shank_diam = 2;

axle_diam = 13;
axle_height = servo_axle_height + screw_cap_height + 2;

deadbolt_short_len = 15;
deadbolt_long_len = 30;
deadbolt_width = 10;
deadbolt_height = 10;

thick_mult = 1.1;


difference()
{
  // Outer shell of deadbolt actuator, includes cap
  linear_extrude(height = deadbolt_height * thick_mult, convexity = 10, twist = 0)
    polygon(points = [[0, deadbolt_width * thick_mult], [(deadbolt_long_len * thick_mult), 0], [0, (-1 * (deadbolt_width * thick_mult))], [(-1 * (deadbolt_short_len * thick_mult)), 0]], paths = [[0, 1, 2, 3, 0]]);

  // Remove inner shell of deadbolt actuator
  translate([0, 0, (deadbolt_height * thick_mult) - deadbolt_height])
  linear_extrude(height = deadbolt_height, convexity = 10, twist = 0)
    polygon(points = [[0, deadbolt_width], [deadbolt_long_len, 0], [0, (-1 * deadbolt_width)], [-1 * deadbolt_short_len, 0]], paths = [[0, 1, 2, 3, 0]]);
  // Cylinder for screw cap to fit into
  translate([0, 0, (axle_height - screw_cap_height)])
    cylinder(h = screw_cap_height, r = (screw_cap_diam / 2));
}

difference()
{
  translate([0, 0, (-1 * axle_height)])
  // Main axle cylinder
  cylinder(h = axle_height, r = (axle_diam / 2));
 translate([0, 0, (-1 * axle_height)])
  // Cylinder where the servo axle will fit
  cylinder(h = servo_axle_height, r = (servo_axle_diam / 2));
  // Cylinder fr the screw shank to fit into
  cylinder(h = axle_height, r = (screw_shank_diam / 2));
}
