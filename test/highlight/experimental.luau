export const LIMIT = 64i
-- <- keyword.storage.modifier
--     ^ keyword.storage.modifier
--                   ^ constant.numeric.integer

export class Child extends package.Base
-- <- keyword.storage.modifier
--     ^ keyword.storage.modifier
--           ^ type
--                         ^ namespace
--                                 ^ type
  public value: number
  -- <- keyword.storage.modifier
  --     ^ variable.other.member
  --            ^ type.builtin

  function get(self): number
  -- <- keyword.function
  --       ^ function.method
  --           ^ variable.parameter
    return self.value
  end
end

open class Parent
-- <- keyword.storage.modifier
--   ^ keyword.storage.modifier
end

const current = source
--    ^^^^^^^ constant

if local current = source then
-- ^^^^^ keyword.storage.modifier
--       ^^^^^^^ variable
  consume(current)
  --      ^^^^^^^ variable
elseif const alternate = source then
--     ^^^^^ keyword.storage.modifier
--           ^^^^^^^^^ constant
  consume(alternate)
  --      ^^^^^^^^^ constant
else
  consume(current)
  --      ^^^^^^^ constant
end

consume(current)
--      ^^^^^^^ constant
