/**
 *  Parametric servo arm generator for OpenScad
 *  Générateur de palonnier de servo pour OpenScad
 *
 *  Copyright (c) 2012 Charles Rincheval.  All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  Last update :
 *  
 *
 *  http://www.digitalspirit.org/
 */

$fn = 40;

/**
 *  Clear between arm head and servo head
 *  With PLA material, use clear : 0.3, for ABS, use 0.2
 */
SERVO_HEAD_CLEAR = 0.2;

/**
 *  Head / Tooth parameters
 *  Futaba 3F Standard Spline
 *  http://www.servocity.com/html/futaba_servo_splines.html
 *
 *  First array (head related) :
 *  0. Head external diameter
 *  1. Head heigth
 *  2. Head thickness
 *  3. Head screw diameter
 *
 *  Second array (tooth related) :
 *  0. Tooth count
 *  1. Tooth height
 *  2. Tooth length
 *  3. Tooth width
 */
FUTABA_3F_SPLINE = [
    [5.82, 12, 3, 3],
    [23, 0.3, 0.7, 0.1]
];

module servo_futaba_3f(length, count) {
    servo_arm(FUTABA_3F_SPLINE, [length, count]);
}

/**
 *  If you want to support a new servo, juste add a new spline definition array
 *  and a module named like servo_XXX_YYY where XXX is servo brand and YYY is the
 *  connection type (3f) or the servo type (s3003)
 */

module servo_standard(length, count) {
    servo_futaba_3f(length, count);
}

/**
 *  Tooth
 *
 *    |<-w->|
 *    |_____|___
 *    /     \  ^h
 *  _/       \_v
 *   |<--l-->|
 *
 *  - tooth length (l)
 *  - tooth width (w)
 *  - tooth height (h)
 *  - height
 *
 */
module servo_head_tooth(length, width, height, head_height) {
    linear_extrude(height = head_height) {
        polygon([[-length / 2, 0], [-width / 2, height], [width / 2, height], [length / 2,0]]);
    }
}

/**
 *  Servo head
 */
module servo_head(params, clear = SERVO_HEAD_CLEAR) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_heigth = head[1];

    tooth_count = tooth[0];
    tooth_height = tooth[1];
    tooth_length = tooth[2];
    tooth_width = tooth[3];

    % cylinder(r = head_diameter / 2, h = head_heigth + 1);

    cylinder(r = head_diameter / 2 - tooth_height + 0.03 + clear, h = head_heigth);

    for (i = [0 : tooth_count]) {
        rotate([0, 0, i * (360 / tooth_count)]) {
            translate([0, head_diameter / 2 - tooth_height + clear, 0]) {
                servo_head_tooth(tooth_length, tooth_width, tooth_height, head_heigth);
            }
        }
    }
}

/**
 *  Servo hold
 *  - Head / Tooth parameters
 *  - Arms params (length and count)
 */
module servo_arm(params, arms) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_heigth = head[1];
    head_thickness = head[2];
    head_screw_diameter = head[3];

    tooth_length = tooth[2];
    tooth_width = tooth[3];

    arm_length = 0; //arms[0];
    arm_count = 0; //arms[1];

    /**
     *  Servo arm
     *  - length is from center to last hole
     */
    module arm(tooth_length, tooth_width, head_height, head_heigth, hole_count = 1) {

        arm_screw_diameter = 2;

        difference() {
            union() {
                cylinder(r = tooth_width / 2, h = head_heigth);

                linear_extrude(height = head_heigth) {
                    polygon([
                        [-tooth_width / 2, 0], [-tooth_width / 3, tooth_length],
                        [tooth_width / 3, tooth_length], [tooth_width / 2, 0]
                    ]);
                }

                translate([0, tooth_length, 0]) {
                    cylinder(r = tooth_width / 3, h = head_heigth);
                }

                if (tooth_length >= 12) {
                    translate([-head_heigth / 2 + 2, 3.8, -4]) {
                        rotate([90, 0, 0]) {
                            rotate([0, -90, 0]) {
                                linear_extrude(height = head_heigth) {
                                    polygon([
                                        [-tooth_length / 1.7, 4], [0, 4], [0, - head_height + 5],
                                        [-2, - head_height + 5]
                                    ]);
                                }
                            }
                        }
                    }
                }
            }

            // Hole
            for (i = [0 : hole_count - 1]) {
                //translate([0, length - (length / hole_count * i), -1]) {
                translate([0, tooth_length - (4 * i), -1]) {
                    cylinder(r = arm_screw_diameter / 2, h = 10);
                }
            }

            cylinder(r = head_screw_diameter / 2, h = 10);
        }
    }

    difference() {
        translate([0, 0, 0.1]) {
            cylinder(r = head_diameter / 2 + head_thickness, h = head_heigth + 1);
        }

        cylinder(r = head_screw_diameter / 2, h = 10);

        servo_head(params);
    }

    arm_thickness = head_thickness;

    // Arm
    translate([0, 0, head_heigth]) {
        for (i = [0 : arm_count - 1]) {
            rotate([0, 0, i * (360 / arm_count)]) {
                arm(arm_length, head_diameter + arm_thickness * 2, head_heigth, 2);
            }
        }
    }
}

module demo() {
    rotate([0, 180, 0])
        servo_standard(20, 4);
}




servo_axle_height = 5;
servo_axle_diam = 10;

screw_cap_height = 2;
screw_cap_diam = 6;
screw_shank_diam = 3;

axle_diam = 13;
axle_height = servo_axle_height + screw_cap_height + 2;

deadbolt_short_len = 23;
deadbolt_long_len = 32;
deadbolt_width = 10;
deadbolt_height = 10;

thick_mult = 1.2;

difference()
{
  union()
  {
    demo();
    difference()
    {
      // Outer shell of deadbolt actuator, includes cap
      translate([0, 0, (-1 * deadbolt_height * thick_mult) - 12])
      linear_extrude(height = deadbolt_height * thick_mult, convexity = 10, twist = 0  )
        polygon(points = [[0, deadbolt_width * thick_mult], [(deadbolt_long_len * thick_mult), 0], [0, (-1 * (deadbolt_width * thick_mult))], [(-1 * (deadbolt_short_len * thick_mult)), 0]], paths = [[0, 1, 2, 3, 0]]);

      // Remove inner shell of deadbolt actuator
      translate([0, 0, (-1 * deadbolt_height * thick_mult) - 12])
      linear_extrude(height = deadbolt_height, convexity = 10, twist = 0)
        polygon(points = [[0, deadbolt_width], [deadbolt_long_len, 0], [0, (-1 * deadbolt_width)], [-1 * deadbolt_short_len, 0]], paths = [[0, 1, 2, 3, 0]]);

      // Cylinder for screw to fit through
      translate([0, 0, -20])
        cylinder(h = 20, r = (screw_shank_diam / 2));
    }
  // Fill in servo splines for screw cap
  translate([0, 0, -12])
  cylinder(h = 7, r = 4);
  }
  // screw hole
  translate([0, 0, -30])
    cylinder(h = 30, r = 1.5); 
  // screw head capper
  translate([0, 0, -17])
    cylinder(h = 10, r = 2.5);

}

