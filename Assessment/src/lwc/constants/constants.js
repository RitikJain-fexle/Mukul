/**
 * 
 * Purpose : Constant Component JS
 * 
 * Created Date : 28/01/2022
 * 
 * Created By : Mukul Pichunia
 * 
 * Revision Logs : V_1.0 - Created - 28/01/2022
 * 
 */

const CHAR_BLANK = '';
const CHAR_BLANK_SPACE = '';
const CHAR_BLANK_COLON = '';
const CHAR_BLANK_DASH = '';
const NUMBER_ONE = 1; 
const NUMBER_TWO = 2; 
const NUMBER_THREE = 3; 


const CHARACTERS = {
    CHAR_BLANK,
    CHAR_BLANK_SPACE,
    CHAR_BLANK_COLON,
    CHAR_BLANK_DASH
}

const NUMBERS = {
    NUMBER_ONE,
    NUMBER_TWO,
    NUMBER_THREE
}

Object.freeze(CHARACTERS);
Object.freeze(NUMBERS);

export {
    CHARACTERS, NUMBERS
}