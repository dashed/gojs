// Based on: https://stackoverflow.com/a/38757490/412627
export const splitAt = (input, index) => [
    input.slice(0, index),
    input.slice(index)
];
