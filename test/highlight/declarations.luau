--!strict
-- <- keyword.directive

const answer: number = 42
-- <- keyword.storage.modifier
--    ^ variable
--            ^ type.builtin

declare extern type Widget with
-- <- keyword.storage.modifier
--      ^ keyword.storage.modifier
--             ^ keyword.function
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
