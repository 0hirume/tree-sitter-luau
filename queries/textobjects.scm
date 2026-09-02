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

(function_body body: (block) @function.inside)

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
