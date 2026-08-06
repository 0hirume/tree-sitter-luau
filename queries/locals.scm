(source_file) @local.scope

[
  (block)
  (function_declaration)
  (local_function_declaration)
  (const_function_declaration)
  (function_expression)
  (type_function_declaration)
] @local.scope

(binding name: (identifier) @local.definition)
(parameter name: (identifier) @local.definition)
(declare_parameter name: (identifier) @local.definition)

(local_function_declaration name: (identifier) @local.definition)
(const_function_declaration name: (identifier) @local.definition)
(class_declaration name: (identifier) @local.definition)

(identifier) @local.reference
