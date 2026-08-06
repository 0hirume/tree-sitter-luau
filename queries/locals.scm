(source_file) @local.scope

[
  (block)
  (function_declaration)
  (local_function_declaration)
  (const_function_declaration)
  (function_expression)
  (type_function_declaration)
] @local.scope

; Helix uses typed definitions; tree-sitter-cli still requires the bare capture.
(binding name: (identifier) @local.definition @local.definition.variable)
(parameter name: (identifier) @local.definition @local.definition.variable.parameter)
(declare_parameter name: (identifier) @local.definition @local.definition.variable.parameter)

(local_function_declaration name: (identifier) @local.definition @local.definition.function)
(const_function_declaration name: (identifier) @local.definition @local.definition.function)
(class_declaration name: (identifier) @local.definition @local.definition.type)

(identifier) @local.reference
