// longer side of the console
console_width = 151;
// thickness of the console, excluding buttons
console_height = 19;
// shorter side of the console
console_length = 70;

// thickness of walls of the final print, adjust for strength
wall_thickness = 2;

// thickness of foam padding on sides and bottom
pad_thickness = 2;
// thickness of foam padding on top, 3.5mm for what anbernic ships with their devices
top_pad_thickness = 3.5;

// whether to put holes for magnets
has_magnets = true;
// height of the magnet, assumed to be a cylinder
magnet_height = 1.8;
// diameter of the magnet, NOT RADIUS
magnet_diameter = 10;

// diameter of wire used as a hinge pin
wire_diameter = 1;

// text to be embossed on the model
watermark = "RG351M";
watermarkfont = "Liberation Sans:style=Bold Italic";

// the actual model
// assuming walls are 2mm
cons_pad_w = console_width + pad_thickness * 2;
cons_pad_h = console_height + top_pad_thickness + pad_thickness;
cons_pad_l = console_length + pad_thickness * 2;

full_w = cons_pad_w + wall_thickness * 2;
full_h = (cons_pad_h + wall_thickness * 2);
full_l = cons_pad_l + wall_thickness * 2;


magnet_holder_w = full_w;
magnet_holder_h = full_h;
magnet_holder_l = magnet_diameter + wall_thickness;
magnet_holder_l_mid_pos = full_l/2 + magnet_holder_l/2;

magnet_y = magnet_holder_l_mid_pos;
magnet_x = full_w/4;
magnet_z = -0.9*magnet_height;


hinge_y = -1 * (full_l/2);
hinge_d = wire_diameter*3;

difference() {
    union() {
        // main body
        difference() {
            union() {
                difference() {
                    // start with just a rectangle
                    cube([full_w, full_l, full_h], center=true);
                    // indent space to be taken by console
                    cube([cons_pad_w, cons_pad_l, cons_pad_h], center=true);        
                };
                // add space for the thing holding in magnets
                translate([0, magnet_holder_l_mid_pos, 0]) cube([magnet_holder_w, magnet_holder_l, magnet_holder_h], center=true);
            }
            // remove some space for magnets
            translate([magnet_x, magnet_y, magnet_z]) cylinder(magnet_height, d=magnet_diameter, center=false);
            translate([magnet_x*-1, magnet_y, magnet_z]) cylinder(magnet_height, d=magnet_diameter, center=false);
            // chop off all of top half
            translate([0, 0, full_h/2]) cube([full_w*5, full_l*5, full_h], center=true);
            // make space for other half's hinge
            translate([-1*full_w/2, -1*full_l/2, 0]) rotate([0, 90, 0]) cylinder(full_w, d=hinge_d, $fn=10);
        };
        // hinge
        difference() {
            translate([-1*full_w/2, -1*full_l/2, 0]) rotate([0, 90, 0]) cylinder(full_w, d=hinge_d, $fn=10);
            // subtract 50% of it in some spots
            for (x = [-1*full_w/2 : 20 : full_w/2]) {
                translate([x, -1*full_l/2 - 5, -5]) cube([10, 10, 10], center=false);
            }
        }
    }
    // subtract space for hinge holding wire
    translate([-1*full_w/2, -1*full_l/2, 0]) rotate([0, 90, 0]) cylinder(full_w*2, d=wire_diameter*1.2, $fn=10);
    // text uwu
    if (watermark != "") {
            translate([full_w/2 - 4, full_l/2 - 2, -1*full_h/2 - 0.5]) linear_extrude(height = wall_thickness/2 + 0.5) rotate([180, 0, 0]) text(text = watermark, font = watermarkfont, halign = "right", valign = "top");
 
    }
}
