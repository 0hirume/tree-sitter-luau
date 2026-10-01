(source_file) @local.scope

[
  (block)
  (function_body)
  (if_local_clause)
  (if_local_expression_clause)
] @local.scope

(binding_list
  (binding name: (identifier) @local.definition @local.definition.variable))
(numeric_for_statement
  binding: (binding name: (identifier) @local.definition @local.definition.variable))
(_
  binding: (binding name: (identifier) @local.definition @local.definition.variable)
  condition: (_) @local.definition-value)
((local_declaration
  bindings: (binding_list
    .
    (binding name: (identifier) @local.definition @local.definition.namespace)
    .)
  values: (expression_list
    .
    (call_expression function: (identifier) @_require)
    .))
  (#eq? @_require "require"))
(const_declaration
  bindings: (binding_list
    (binding name: (identifier) @local.definition @local.definition.constant)))
(if_local_clause
  "const"
  binding: (binding name: (identifier) @local.definition @local.definition.constant)
  condition: (_) @local.definition-value)
(if_local_expression_clause
  "const"
  binding: (binding name: (identifier) @local.definition @local.definition.constant)
  condition: (_) @local.definition-value)
(parameter name: (identifier) @local.definition @local.definition.variable.parameter)
(declare_parameter name: (identifier) @local.definition @local.definition.variable.parameter)

(local_function_declaration name: (identifier) @local.definition @local.definition.function)
(const_function_declaration name: (identifier) @local.definition @local.definition.function)
(class_declaration name: (identifier) @local.definition @local.definition.type)

(expression_list (identifier) @local.reference)
(assignment_target_list (identifier) @local.reference)
(parenthesized_expression (identifier) @local.reference)
(interpolated_string (identifier) @local.reference)
(function_name name: (identifier) @local.reference)
(table_field "[" key: (identifier) @local.reference)
(ERROR (identifier) @local.reference)
(_ condition: (identifier) @local.reference)
(_ consequence: (identifier) @local.reference)
(_ alternative: (identifier) @local.reference)
(_ operand: (identifier) @local.reference)
(_ left: (identifier) @local.reference)
(_ right: (identifier) @local.reference)
(_ value: (identifier) @local.reference)
(_ table: (identifier) @local.reference)
(_ index: (identifier) @local.reference)
(_ function: (identifier) @local.reference)
(_ receiver: (identifier) @local.reference)
(_ start: (identifier) @local.reference)
(_ end: (identifier) @local.reference)
(_ step: (identifier) @local.reference)
