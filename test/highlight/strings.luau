local simple = "line\n"
--                  ^^ constant.character.escape

local hex = "\x41"
--           ^^^^ constant.character.escape

local decimal = "\65"
--               ^^^ constant.character.escape

local unicode = "\u{1F600}"
--               ^^ constant.character.escape
--                 ^ punctuation.special
--                  ^^^^^ constant.numeric.integer
--                       ^ punctuation.special

local greeting = `hello {name}!`
--               ^ punctuation.special
--                ^^^^^^ string
--                      ^ punctuation.special
--                       ^^^^ variable
--                           ^ punctuation.special
--                            ^ string
--                             ^ punctuation.special
