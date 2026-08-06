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
