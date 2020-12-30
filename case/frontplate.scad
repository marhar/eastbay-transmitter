//------------------------------------------------------------------------------
// frontplate.scad - front transmitter insert.
//
// This is part of the ArrBot EastBay Transmitter project.
// https://github.com/marhar/eastbay-transmitter
// Copyright (c) 2020 Google LLC
//------------------------------------------------------------------------------

include <constants.scad>

module screw_holes(xx, yy) {
  // for attaching to case.
  translate([post_wid/2,yy-post_wid/2,0]) cylinder(plate_zz, d=screw3b_dd);
  translate([post_wid/2,post_wid/2,0]) cylinder(plate_zz, d=screw3b_dd);
  translate([xx-post_wid/2,yy-post_wid/2,0]) cylinder(plate_zz, d=screw3b_dd);
  translate([xx-post_wid/2,post_wid/2,0]) cylinder(plate_zz, d=screw3b_dd);
}

module power_hole(xx,yy) {
  // big power hole.
  power_offset=30;
  translate([xx/2,yy-power_offset,0]) cylinder(plate_zz, d=power_dd);
}

switch_offset=15;

module switchhole(xoff, yoff) {
  //  single switch hole.
  translate([xoff,yoff,0]) cylinder(plate_zz,d=switch_dd);
}

module switch_holes(xx,yy) {
  // all switch holes across top.
  for (i = [1,2,3]) switchhole(0+i*switch_offset,yy-20);
  for (i = [1,2,3]) switchhole(xx/2+switch_offset+i*switch_offset,yy-20);
}

gimbal_big_dd = 49;
gimbal_screwhole_offset = 27;
gimbal_small_dd = 7;
gimbal_screw_dd = 2.5;

module gimbal_hole() {
  // hole for one gimbal.
  cylinder(plate_zz, d=gimbal_big_dd);
  for (i=[-1,1], j=[-1,1]) {
    translate([i*gimbal_screwhole_offset,j*gimbal_screwhole_offset,0]) {
      cylinder(plate_zz, d=gimbal_screw_dd);
      translate([0,0,plate_zz-1]) cylinder(plate_zz, d=gimbal_small_dd);
    }
  }
}

support_ww = 4;
support_zz = 8;

module lateral_support(xx) {
  // to redule flex in frontplate.
  cube([xx,support_ww, support_zz]);
}

module frontplate() {
  // holds all switches, gimbals, etc.
  xx = box_xx-2*wall;
  yy = box_yy-2*wall;
  difference() {
    union() {
      cube([xx,yy,plate_zz]);
      translate([0,post_wid,0]) lateral_support(xx);
      translate([0,yy-2*post_wid,0]) lateral_support(xx);
      poff = gimbal_screwhole_offset+support_ww+5;
      for (i =[-1,1]) {
        translate([0,yy/2-support_ww/2+i*poff,0]) lateral_support(xx);
      }
    }
    switch_holes(xx,yy);
    screw_holes(xx,yy);
    power_hole(xx,yy);
    translate([xx*1/4,yy/2,0]) gimbal_hole();
    translate([xx*3/4,yy/2,0]) gimbal_hole();
  }
}

module single_gimbal() {
  // for testing a single gimbal.
  xx = 80;
  yy = xx;
  difference() {
    union() {
      cube([xx,yy,plate_zz]);
    }
    translate([xx/2,yy/2,0]) gimbal_hole();
  }
}

frontplate();
//single_gimbal();
