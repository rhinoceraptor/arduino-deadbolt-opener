
// Dimensions of the faceplate for the deadbolt
deadbolt_face_diam = 85;
deadbolt_face_height = 13;
deadbolt_stack_height = 30;

// Dimensions of the box
box_width = 50;
box_length = 105;
base_height = 10;
box_height = deadbolt_stack_height + base_height;


servo_hole_diam = 13;

// To remove screw holes, set 'screw_hole_diam' to 0.
screw_hole_diam = 4;
screw_spacing = (((box_length - deadbolt_face_diam) / 2) / 2);

screw_cap_height = 2;
screw_cap_diam = 10;

long_servo_len = 34.5;
short_servo_len = 14.5;
servo_width = 18.5;
screw_from_center = 5;

servo_bolt_diam = 3;
servo_bolt_head_diam = 4;
servo_bolt_head_height = 2;

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
  

  // Subtract screw hole 1 cap
  translate([((deadbolt_face_diam / 2) + screw_spacing), ((box_width / 2) - screw_spacing), 0])
    cylinder(h = screw_cap_height, r = (screw_cap_diam / 2), center = true);
  

  // Subtract screw hole 2
  translate([((deadbolt_face_diam / 2) + screw_spacing), ((-1 * box_width / 2) + screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
  

  // Subtract screw hole 3
  translate([((-1 * deadbolt_face_diam / 2) - screw_spacing), ((box_width / 2) - screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
  

  // Subtract screw hole 4
  translate([((-1 * deadbolt_face_diam / 2) - screw_spacing), ((-1 * box_width / 2) + screw_spacing), 0])
    cylinder(h = box_height, r = (screw_hole_diam / 2), center = true);
 

   // Subtract servo short length screw hole 1
  translate([(short_servo_len), (screw_from_center), (-1 * box_height / 2)])
    cylinder(h = base_height, r = (servo_bolt_diam / 2));

  // Subtract servo short length screw hole 1 head
  translate([(short_servo_len), (screw_from_center), ((-1 * box_height / 2) + base_height - servo_bolt_head_height)])
    cylinder(h = servo_bolt_head_height, r = (servo_bolt_head_diam / 2));

  // Subtract servo short length screw hole 2
  translate([(short_servo_len), (-1 * screw_from_center), (-1 * box_height / 2)])
    cylinder(h = base_height, r = (servo_bolt_diam / 2));
  
  // Subtract servo short length screw hole 2 head
  translate([(short_servo_len), (-1 * screw_from_center), ((-1 * box_height / 2) + base_height - servo_bolt_head_height)])
    cylinder(h = servo_bolt_head_height, r = (servo_bolt_head_diam / 2));

  // Subtract servo short length screw hole 3
  translate([(-1 * long_servo_len), (screw_from_center), (-1 * box_height / 2)])
    cylinder(h = base_height, r = (servo_bolt_diam / 2));
  
  // Subtract servo short length screw hole 3 head
  translate([(-1 * long_servo_len), (screw_from_center), ((-1 * box_height / 2) + base_height - servo_bolt_head_height)])
    cylinder(h = servo_bolt_head_height, r = (servo_bolt_head_diam / 2));

  // Subtract servo short length screw hole 4
  translate([(-1 * long_servo_len), (-1 * screw_from_center), (-1 * box_height / 2)])
    cylinder(h = base_height, r = (servo_bolt_diam / 2));

  // Subtract servo short length screw hole 4 head
  translate([(-1 * long_servo_len), (-1 * screw_from_center), ((-1 * box_height / 2) + base_height - servo_bolt_head_height)])
    cylinder(h = servo_bolt_head_height, r = (servo_bolt_head_diam / 2));
}


