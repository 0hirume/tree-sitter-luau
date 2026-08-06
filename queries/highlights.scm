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
  "in"
] @keyword

[
  "function"
  "type"
] @keyword.function

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
  "and"
  "or"
  "not"
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

(field_expression field: (identifier) @variable.other.member)
(table_field key: (identifier) @variable.other.member)
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
    "any" "boolean" "buffer" "never" "nil" "number" "string" "thread" "unknown" "vector"))

((line_comment) @keyword.directive
  (#match? @keyword.directive "^--!(strict|nonstrict|nocheck|native|optimize [0-2])$"))
