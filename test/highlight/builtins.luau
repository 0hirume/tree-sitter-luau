local Players = game:GetService("Players")
--              ^ variable.builtin
--                   ^ function.builtin
--                              ^ string.special

Players:GetPlayers()
--      ^^^^^^^^^^ function.method

consume(Players.PlayerAdded)
--              ^^^^^^^^^^^ variable.other.member

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
-- <- variable
--     ^ function

local handlers = {
  run = function() end,
  -- <- function.method
}

local part: Part = Instance.new("Part")
--          ^^^^ type.builtin
--                 ^^^^^^^^ type.builtin
--                          ^^^ function

local size = UDim2.fromOffset(0, 0)
--           ^^^^^ type.builtin
--                 ^^^^^^^^^^ function

local key = Enum.KeyCode.F4
--          ^^^^ type.builtin

local annotation: WorkspaceAnnotation? = nil
--                ^^^^^^^^^^^^^^^^^^^ type.builtin

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
--                ^ type.builtin
--                        ^ constant.builtin

local output = print
--             ^^^^^ function.builtin

local print = output
--    ^^^^^ variable

local dataModel = game
--                ^^^^ variable.builtin

local game = dataModel
--    ^^^^ variable

do
  local spawn = output
  consume(spawn)
  --      ^^^^^ variable
  spawn()
  -- <- variable
end

do
  const spawn = output
  consume(spawn)
  --      ^^^^^ constant
  spawn()
  -- <- constant
end

do
  local UDim2 = {}
  UDim2.fromOffset(0, 0)
  -- <- variable
end
