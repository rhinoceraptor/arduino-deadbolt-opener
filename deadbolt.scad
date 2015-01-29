
// Dimensions of the faceplate for the deadbolt
deadbolt_face_diam = 75;
deadbolt_face_height = 13;
deadbolt_stack_height = 30;

// Dimensions of the box
box_width = 50;
box_length = 105;
box_height = deadbolt_stack_height + 5;


servo_hole_diam = 12;

screw_holes = true;
screw_hole_diam = 4;

screw_spacing = (((box_length - deadbolt_face_diam) / 2) / 2);

// This bit is confusing. It is logically equivalent to the following:
// if (screw_holes == false)
//   screw_hole_diam = 0;
// This is due to SCAD not supporting assignment in the body of if statements.
screw_hole_diam = screw_holes ? (screw_hole_diam / 2) : 0;

difference()
{
  // Draw the main box
  cube([box_length, box_width, box_height], center = true);
  // Subtract the cylinder for the deadbolt
  translate([0, 0, ((box_height - deadbolt_stack_height)/2)])
    cylinder(h = deadbolt_stack_height, r = (deadbolt_face_diam/2), center = true);
  // Subtract the servo axle hole cylinder
  translate([0, 0, (box_height / 2 * -1)])
    cylinder(h = (box_height - deadbolt_face_height), r = (servo_hole_diam / 2));
  // Subtract screw hole 1
  translate([((deadbolt_face_diam / 2) + screw_spacing), ((box_width / 2) - screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
  // Subtract screw hole 2
  translate([((deadbolt_face_diam / 2) + screw_spacing), ((-1 * box_width / 2) + screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
  // Subtract screw hole 3
  translate([((-1 * deadbolt_face_diam / 2) - screw_spacing), ((box_width / 2) - screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
  // Subtract screw hole 4
  translate([((-1 * deadbolt_face_diam / 2) - screw_spacing), ((-1 * box_width / 2) + screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
}
