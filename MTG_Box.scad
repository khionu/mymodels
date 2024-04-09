// TODO: Reverse all this so the front is in the back, and uses smaller
//   offsets.

// -- Dimensions
// W = X-axis 
// H = Z-axis
// D = Y-axis
// -- Positions are relative to the parent

// Magic offset to ensure clean deliniation
moffset = [0.001].xxx;
// Thickness of the walls
wall_thick = [5].xxx;
// Thickness of internal separators
sep_thick = [1].xxx;
// Dimensions for single card space
card_dim = [67, 1, 90];
// Dimensions for 100-card deck
deck_dim = [card_dim.x, 67, card_dim.z];
// Standard width of all Front Elements
front_elems_width = 60;
// Dimensions of cmdr art window
art_dim = [front_elems_width, (wall_thick + card_dim).y, 50];
// Dimensions of box label
label_dim = [front_elems_width, 2, 15]; // must be y > wall_thick.y
// Dimensions of outer box
outer_dim = (wall_thick + concat(wall_thick.xy, 0)) +
+ deck_dim + [0, (sep_thick + card_dim).y, 0];

function x_offset_to_center(x) = (deck_dim.x - x) / 2;

// Standard Front Elements offset 
front_elems_centering = [x_offset_to_center(front_elems_width), 0, 0];
// Position for main deck space
deck_space_pos = [0].xxx; // Currently relative to inner box space, post-walls
// We want to move to be flush with the wall, but are starting from
//   the rear of the front. The front will be flush with the wall,
//   so we add the wall thickness and card depth to find the y 
//   value that the outer box ends at. Then we subtract the depth
//   of the inlay so the outer-most of the inlay is flush with the
//   outer-most of the wall.
label_depth_offset = (card_dim + wall_thick - label_dim).y;
// Position of cmdr art window, relative to Front Elements
art_pos = [0, 0, 33] + front_elems_centering;
// Position of box label, relative to Front Elements
label_pos = [0, label_depth_offset, 8] + front_elems_centering;
// Position of Front Elements relative to outer box margins
front_elems_pos = [0, (deck_dim + sep_thick).y, 0];

module front_elems() {
    // Commander space
    cube(card_dim);
    // Commander art window
    translate(art_pos)
        cube(art_dim);
    // Deck label window
    translate(label_pos)
        cube(label_dim);
}

// Module so it's easy to disable for testing
module main() {
  difference() {
    // Outer box dimensions
    cube(outer_dim);
    // Provide an inner margin using the wall thickness + magic offset
    #translate(wall_thick + moffset) {
      translate(front_elems_pos)
        front_elems();
      // Deck space
      cube(deck_dim);
    }
  }
}

main();
