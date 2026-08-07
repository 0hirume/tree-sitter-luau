[
  (table_constructor)
  (index_expression)
  (field_expression)
  (parameter_list)
  (function_type_parameters)
  (declare_parameter_list)
  (arguments)
  (parenthesized_type)
  (type_pack)
] @rainbow.scope

[
  "(" ")"
  "[" "]"
  "{" "}"
] @rainbow.bracket

(explicit_type_arguments ["<<" ">>"] @rainbow.bracket) @rainbow.scope
(generic_parameter_list ["<" ">"] @rainbow.bracket) @rainbow.scope
(generic_definition_list ["<" ">"] @rainbow.bracket) @rainbow.scope
(type_reference ["<" ">"] @rainbow.bracket) @rainbow.scope
