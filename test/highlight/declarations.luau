--!strict
-- <- keyword.directive

const answer: number = 42
-- <- keyword.storage.modifier
--    ^ constant
--            ^ type.builtin

const object = {}
--    ^^^^^^ constant

object.field = true
-- <- constant

object:update()
-- <- constant

object:update<<string>>()
-- <- constant

function object.reset(): ()
--       ^^^^^^ constant
--              ^^^^^ function.method
end

local copy = answer
--           ^^^^^^ constant

local with = copy
--    ^^^^ variable

local query = model:with()
--            ^^^^^ variable
--                  ^^^^ function.method

model.field = true
-- <- variable
--    ^^^^^ variable.other.member

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
--       ^^^^^^ variable
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
-- <- variable
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
