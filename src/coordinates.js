// 3rd-party imports

import { indexOf, toInteger } from "lodash";

// local imports

import { splitAt } from "./utils";

// Ref: https://senseis.xmp.net/?Coordinates
//
// Various coordinate systems for the go board (i.e. the goban).
// A coordinate system describes the position of the stones or positional point
// on the go board.
//
// Coordinates are normalized to 0-indexed row-col matrice convention. (i.e. [row, col])
//
// NOTE: [row, col] starts at top-left corner at [0,0]

// Style 1-1 or 一1
//
// 1-1 is the origin that begins at the upper left corner, and continues to
// 19-19 at the lower-right corner.
export const japanese = (src_row, src_col) => {
    // 1 <= src_row <= 19
    // 1 <= src_col <= 19

    return [src_row - 1, src_col - 1];
};

const translateCoord = coord => {
    let [letter, number] = splitAt(coord, 1);

    letter = letter.trim().toLowerCase();
    number = toInteger(number.trim());

    return [letter, number];
};

// NOTE: i is excluded from this alphabet list
const lookup = Array.from("abcdefghjklmnopqrst");

// In Europe it is usual to give coordinates in the form of A1 to T19. Where A1 is in the lower left corner and T19 in the upper right corner (from black's view).
// Note: "I" is not used, historically to avoid confusion with "J"
export const europe = function(coord, row_size) {
    // invariant: coord is string. e.g. T19

    const [letter, number] = translateCoord(coord);

    // invariant: A <= letter <= T (exclude J)
    // invariant: 1 <= number <= 19

    // letter represents coord of x-axis
    // number represents coord of y-axis

    const col = indexOf(lookup, letter);
    const row = number - row_size;

    return [row, col];
};

export const A1 = europe;
export const western = europe;
