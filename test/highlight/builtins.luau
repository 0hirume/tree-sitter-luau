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
