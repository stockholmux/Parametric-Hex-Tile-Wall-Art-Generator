include <BOSL2/std.scad>

/* [Artwork] */ 
// SVG: filename & path
svg_fname = "sample-poo.svg";
// Scaling factor of SVG from 0-100, 100 = 100%, 90 = 90%, and so on
scale_factor = 1;

/* [Tile Specifications] */ 
// hexagon side length in mm
side_length = 105;
// border along side edges of hex in mm
border_thickness = 1;
// Thickness of the tile in mm
base_thickness = 3;
// Thickness of the design and border in mm
design_thickness = 1;

/* [Tile Counts] */
y_count = 6;
x_count = 5;

/* [Generation] */
show_only = false;
onlyX = 0;
onlyY = 0;

// calculations
apothem = sqrt( side_length^2 - (side_length/2)^2 );
y_stacking = side_length * 1.5;
x_stacking = apothem * 2;

// debugging messages
echo("TOTAL TILES:", y_count * x_count);
if (show_only == true) {
    echo("Showing Only:",onlyX,onlyY);
} else {
    echo("Showing everything. This may take a while.");
}

// execution
if (show_only == false) {
    tiles();
    artwork();
} else {
    intersection() {
        translate([0,0,base_thickness])
            tiles();
        artwork();
    }
    tiles();
}

// modules
module tiles() 
    for(y_translation = [0:y_count]) 
        translate([
                (y_translation % 2) * apothem,
                0,
                0
            ])
                for(x_translation = [0:x_count])
                    translate([
                        x_translation * x_stacking,
                        y_translation * y_stacking,
                        0
                    ]) let(
                        tile_id = [x_translation, y_translation]
                    ) 
                        if (show_only == false)
                            tile();
                        else if (
                            (onlyX == tile_id.x) && 
                            (onlyY == tile_id.y)) 
                                tile();

module artwork()
    translate([0,0,base_thickness])
        linear_extrude(design_thickness)
            scale(scale_factor / 100)
                import(svg_fname);

module tile() 
    rotate([0,0,90]) {
        color("lightgrey") 
            linear_extrude(base_thickness)
                hexagon(side=side_length);

        translate([0,0,base_thickness])
            linear_extrude(design_thickness)
                difference() {
                    hexagon(side=side_length);
                    hexagon(side=side_length-border_thickness);
                }
    }
        