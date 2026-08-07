(function_declaration
  name: (function_name name: (identifier) @name)) @definition.function
(function_declaration
  name: (function_name field: (identifier) @name)) @definition.function
(function_declaration
  name: (function_name method: (identifier) @name)) @definition.function

(local_function_declaration name: (identifier) @name) @definition.function
(const_function_declaration name: (identifier) @name) @definition.function
(type_function_declaration name: (identifier) @name) @definition.function
(class_declaration name: (identifier) @name) @definition.class
(type_alias_declaration name: (identifier) @name) @definition.type

(assignment_statement
  left: (assignment_target_list
    (identifier) @name)
  right: (expression_list
    (function_expression))) @definition.function
(assignment_statement
  left: (assignment_target_list
    (field_expression field: (identifier) @name))
  right: (expression_list
    (function_expression))) @definition.function

(call_expression function: (identifier) @name) @reference.call
(method_call_expression method: (identifier) @name) @reference.call
