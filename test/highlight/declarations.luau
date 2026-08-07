--!strict
-- <- keyword.directive

const answer: number = 42
-- <- keyword.storage.modifier
--    ^ constant
--            ^ type.builtin

local copy = answer
--           ^^^^^^ constant

declare extern type Widget with
-- <- keyword.storage.modifier
--      ^ keyword.storage.modifier
--             ^ keyword.storage.type
--                  ^ type
  read name: string
  -- <- keyword.storage.modifier
  --   ^ variable.other.member
  --         ^ type.builtin
end

@checked declare function create(value: number): Widget
-- ^ attribute
--       ^ keyword.storage.modifier
--               ^ keyword.function
--                        ^ function
--                               ^ variable.parameter

declare utf8: {
-- <- keyword.storage.modifier
--      ^^^^ variable.builtin
  codepoint: (string, number?, number?) -> (...number),
  -- <- variable.other.member
  codes: (string) -> ((string, number) -> (number, number), string, number),
  -- <- variable.other.member
}

function Widget.new(): Widget
--       ^^^^^^ namespace
--              ^^^ function.method
--                     ^^^^^^ type
end

type Value = planck.SystemTable<jecs.World>
--           ^^^^^^ namespace
--                  ^^^^^^^^^^^ type
--                              ^^^^ namespace
--                                   ^^^^^ type

local planck = require("planck")
--    ^^^^^^ variable

local jecs = require("jecs")
--    ^^^^ variable

world:component<<Widget>>()
-- <- namespace
--    ^^^^^^^^^ function.method
