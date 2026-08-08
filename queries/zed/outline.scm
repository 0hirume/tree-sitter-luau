(function_declaration
  name: (function_name name: (identifier) @name)) @item
(function_declaration
  name: (function_name field: (identifier) @name)) @item
(function_declaration
  name: (function_name method: (identifier) @name)) @item

(local_function_declaration name: (identifier) @name) @item
(const_function_declaration name: (identifier) @name) @item
(type_function_declaration name: (identifier) @name) @item
(declare_function name: (identifier) @name) @item
(declare_global name: (identifier) @name) @item
(class_declaration name: (identifier) @name) @item
(class_method name: (identifier) @name) @item
(type_alias_declaration name: (identifier) @name) @item
(extern_type_declaration name: (identifier) @name) @item
(extern_method name: (identifier) @name) @item

(assignment_statement
  left: (assignment_target_list
    (identifier) @name)
  right: (expression_list
    (function_expression))) @item
(assignment_statement
  left: (assignment_target_list
    (field_expression field: (identifier) @name))
  right: (expression_list
    (function_expression))) @item
