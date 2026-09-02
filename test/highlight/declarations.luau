--!strict
-- <- keyword.directive

const answer: number = 42
-- <- keyword.storage.modifier
--    ^ constant
--            ^ type.builtin

local copy = answer
--           ^^^^^^ constant

local with = copy
--    ^^^^ variable

local query = model:with()
--                  ^^^^ function.method

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

type Value = source.ValueHolder<data.Entry>
--           ^^^^^^ namespace
--                  ^^^^^^^^^^^ type
--                              ^^^^ namespace
--                                   ^^^^^ type

type Flags = {
  [string]: true,
  --        ^^^^ constant.builtin.boolean
}

type Nothing = nil
--             ^^^ constant.builtin

type Accessors = {
  read read: () -> (),
  -- <- keyword.storage.modifier
  --   ^^^^ variable.other.member
  write write: () -> (),
  -- <- keyword.storage.modifier
  --    ^^^^^ variable.other.member
}

local source = require("source")
--    ^^^^^^ variable

local data = require("data")
--    ^^^^ variable

model:transform<<Record>>()
-- <- namespace
--    ^^^^^^^^^ function.method

local Players = game:GetService("Players")
--    ^^^^^^^ namespace
--              ^^^^ variable.builtin
--                   ^^^^^^^^^^ function.builtin

type function TypeFactory(value: number): number
-- <- keyword.storage.type
--      ^^^^^^^^ keyword.function
--               ^^^^^^^^^^^ type
end
-- <- keyword.function

const function operation(): ()
end

local callback = operation
--               ^ function
