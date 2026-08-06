(identifier) @variable

[
  (line_comment)
  (block_comment)
] @comment

[
  (quoted_string)
  (long_string)
  (interpolated_string)
] @string

(number) @constant.numeric
(integer) @constant.numeric.integer
(boolean) @constant.builtin.boolean
(nil) @constant.builtin
(vararg_expression) @constant

(attribute name: (identifier) @attribute)
(parameterized_attribute name: (identifier) @attribute)

[
  (break_statement)
  (continue_statement)
] @keyword.control

"return" @keyword.control.return

[
  "if"
  "elseif"
  "else"
  "then"
] @keyword.control.conditional

[
  "while"
  "repeat"
  "until"
  "for"
] @keyword.control.repeat

[
  "do"
  "end"
] @keyword

"function" @keyword.function
"type" @keyword.storage.type

[
  "in"
  "and"
  "or"
  "not"
] @keyword.operator

[
  "local"
  "const"
  "class"
  "declare"
  "extern"
  "public"
  "extends"
  "with"
  "read"
  "write"
  "export"
] @keyword.storage.modifier

"typeof" @keyword.operator

[
  "+"
  "-"
  "*"
  "/"
  "//"
  "%"
  "^"
  "#"
  "=="
  "~="
  "<"
  "<="
  ">"
  ">="
  ".."
  "="
  "+="
  "-="
  "*="
  "/="
  "//="
  "%="
  "^="
  "..="
  "::"
  "->"
  "|"
  "&"
  "?"
] @operator

[
  ","
  ";"
  "."
  ":"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "<"
  ">"
  "<<"
  ">>"
] @punctuation.bracket

(table_constructor
  [
    "{"
    "}"
  ] @constructor)

(binding name: (identifier) @variable)
(parameter name: (identifier) @variable.parameter)
(declare_parameter name: (identifier) @variable.parameter)
(function_type_parameter name: (identifier) @variable.parameter)

(function_declaration name: (function_name name: (identifier) @function))
(function_name field: (identifier) @function.method)
(function_name method: (identifier) @function.method)
(local_function_declaration name: (identifier) @function)
(const_function_declaration name: (identifier) @function)
(declare_function name: (identifier) @function)
(extern_method name: (identifier) @function.method)
(class_method name: (identifier) @function.method)

(call_expression function: (identifier) @function)
(method_call_expression method: (identifier) @function.method)
(type_instantiation_expression function: (identifier) @function)
(type_instantiation_expression method: (identifier) @function.method)

(field_expression table: (identifier) @namespace)
(field_expression field: (identifier) @variable.other.member)
(table_field key: (identifier) @variable.other.member)
(table_field
  key: (identifier) @function.method
  value: (function_expression))
(call_expression
  function: (field_expression
    table: (identifier) @namespace
    field: (identifier) @function))
(type_instantiation_expression
  function: (field_expression
    table: (identifier) @namespace
    field: (identifier) @function))
(property_type name: (identifier) @variable.other.member)
(extern_property name: (identifier) @variable.other.member)
(class_property name: (identifier) @variable.other.member)

(type_alias_declaration name: (identifier) @type)
(extern_type_declaration name: (identifier) @type)
(extern_type_declaration supertype: (identifier) @type)
(class_declaration name: (identifier) @type)
(class_reference module: (identifier) @namespace)
(class_reference name: (identifier) @type)
(type_reference module: (identifier) @namespace)
(type_reference name: (identifier) @type)

[
  (generic_type_definition name: (identifier))
  (generic_type_pack_definition name: (identifier))
  (generic_type name: (identifier))
  (generic_type_pack name: (identifier))
] @type.parameter

((type_reference name: (identifier) @type.builtin)
  (#any-of? @type.builtin
    "any" "boolean" "buffer" "never" "nil" "number" "string" "thread" "unknown" "userdata" "vector"))

((call_expression function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    "assert" "collectgarbage" "elapsedTime"
    "error" "gcinfo" "getfenv"
    "getmetatable" "ipairs" "loadstring"
    "next" "newproxy" "pairs"
    "pcall" "PluginManager" "print"
    "printidentity" "rawequal" "rawget"
    "rawlen" "rawset" "require"
    "select" "setfenv" "setmetatable"
    "spawn" "tick" "time"
    "tonumber" "tostring" "type"
    "typeof" "unpack" "UserSettings"
    "version" "warn" "workspace"
    "xpcall"))

((identifier) @variable.builtin
  (#any-of? @variable.builtin
    "_G" "_VERSION" "bit32"
    "coroutine" "debug"
    "game" "math" "os"
    "plugin" "script"
    "table" "task" "utf8"
    "workspace"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "bit32")
  (#any-of? @function.builtin
    "arshift" "lrotate" "lshift" "replace"
    "rrotate" "rshift" "btest" "bxor"
    "band" "bnot" "bor" "countlz"
    "countrz" "extract" "byteswap"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "coroutine")
  (#any-of? @function.builtin
    "close" "create" "isyieldable"
    "resume" "running" "status"
    "wrap" "yield"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "debug")
  (#any-of? @function.builtin
    "info" "traceback" "profilebegin"
    "profileend" "resetmemorycategory" "setmemorycategory"
    "dumpcodesize"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "math")
  (#any-of? @function.builtin
    "abs" "acos" "asin"
    "atan" "atan2" "ceil"
    "clamp" "cos" "cosh"
    "deg" "exp" "floor"
    "fmod" "frexp" "ldexp"
    "log" "log10" "max"
    "min" "modf" "noise"
    "pow" "rad" "random"
    "randomseed" "round" "sign"
    "sin" "sinh" "sqrt"
    "tan" "tanh"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "math")
  (#any-of? @constant.builtin "huge" "pi"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "os")
  (#any-of? @function.builtin "clock" "date" "difftime" "time"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "string")
  (#any-of? @function.builtin
    "byte" "char" "find"
    "format" "gmatch" "gsub"
    "len" "lower" "match"
    "pack" "packsize" "rep"
    "reverse" "split" "sub"
    "unpack" "upper"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "table")
  (#any-of? @function.builtin
    "create" "clear" "clone"
    "concat" "foreach" "foreachi"
    "find" "freeze" "getn"
    "insert" "isfrozen" "maxn"
    "move" "pack" "remove"
    "sort" "unpack"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "task")
  (#any-of? @function.builtin
    "cancel" "defer" "delay"
    "synchronize" "desynchronize" "spawn"
    "wait"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "utf8")
  (#any-of? @function.builtin
    "char" "codepoint" "codes"
    "graphemes" "len" "offset"
    "nfcnormalize" "nfdnormalize"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "utf8")
  (#eq? @constant.builtin "charpattern"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "buffer")
  (#any-of? @function.builtin
    "create" "fromstring" "tostring"
    "len" "copy" "fill"
    "readi8" "readu8" "readi16"
    "readu16" "readi32" "readu32"
    "readf32" "readf64" "writei8"
    "writeu8" "writei16" "writeu16"
    "writei32" "writeu32" "writef32"
    "writef64" "readstring" "writestring"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "vector")
  (#any-of? @function.builtin
    "create" "magnitude" "normalize"
    "cross" "dot" "angle"
    "floor" "ceil" "abs"
    "sign" "clamp" "max"
    "min"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @constant.builtin)
  (#eq? @variable.builtin "vector")
  (#any-of? @constant.builtin "zero" "one"))

((field_expression
  table: (identifier) @variable.builtin
  field: (identifier) @function.builtin)
  (#eq? @variable.builtin "Content")
  (#any-of? @function.builtin "fromUri" "fromAssetId" "fromObject"))

((method_call_expression
  receiver: (identifier) @variable.builtin
  method: (identifier) @function.builtin
  arguments: (arguments
    (expression_list
      .
      (string
        (quoted_string) @string.special))))
  (#eq? @variable.builtin "game")
  (#eq? @function.builtin "GetService"))

((line_comment) @keyword.directive
  (#match? @keyword.directive "^--!(strict|nonstrict|nocheck|native|optimize [0-2])$"))
