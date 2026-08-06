[
  (function_declaration)
  (local_function_declaration)
  (const_function_declaration)
  (function_expression)
  (declare_function)
  (extern_method)
  (class_method)
  (type_function_declaration)
] @function.around

[
  (function_declaration body: (block) @function.inside)
  (local_function_declaration body: (block) @function.inside)
  (const_function_declaration body: (block) @function.inside)
  (function_expression body: (block) @function.inside)
  (type_function_declaration body: (block) @function.inside)
  (class_method body: (block) @function.inside)
]

[
  (parameter)
  (variadic_parameter)
  (declare_parameter)
  (declare_variadic_parameter)
  (function_type_parameter)
] @parameter.inside @parameter.around

[
  (line_comment)
  (block_comment)
] @comment.inside @comment.around
