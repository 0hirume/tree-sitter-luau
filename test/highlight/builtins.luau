local Players = game:GetService("Players")
--              ^ variable.builtin
--                   ^ function.builtin
--                              ^ string.special

print(math.abs(1), math.pi)
-- <- function.builtin
--    ^ variable.builtin
--         ^ function.builtin
--                 ^ variable.builtin
--                      ^ constant.builtin

local frozen = table.freeze({})
--             ^ variable.builtin
--                   ^ function.builtin
--                          ^ constructor

module.start()
-- <- namespace
--     ^ function

local handlers = {
  run = function() end,
  -- <- function.method
}

local part: Part = Instance.new("Part")
--          ^^^^ type.builtin

local annotation: WorkspaceAnnotation? = nil
--                ^^^^^^^^^^^^^^^^^^^ type.builtin

local legacy: AnimationStreamTrack? = nil
--            ^^^^^^^^^^^^^^^^^^^^ type.builtin

local finite = math.isfinite(1)
--             ^ variable.builtin
--                  ^ function.builtin

local reflected = types.singleton("string")
--                ^ variable.builtin
--                      ^ function.builtin

local reflectedAny = types.any
--                   ^ variable.builtin
--                         ^ constant.builtin

local noContent = Content.none
--                ^ variable.builtin
--                        ^ constant.builtin

local output = print
--             ^^^^^ function.builtin

local print = output
--    ^^^^^ variable

local dataModel = game
--                ^^^^ variable.builtin

local game = dataModel
--    ^^^^ variable
