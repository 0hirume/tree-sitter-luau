(source_file) @local.scope

[
  (block)
  (function_body)
] @local.scope

(binding name: (identifier) @local.definition @local.definition.variable)
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
(parameter name: (identifier) @local.definition @local.definition.variable.parameter)
(declare_parameter name: (identifier) @local.definition @local.definition.variable.parameter)

(local_function_declaration name: (identifier) @local.definition @local.definition.function)
(const_function_declaration name: (identifier) @local.definition @local.definition.function)
(class_declaration name: (identifier) @local.definition @local.definition.type)

(identifier) @local.reference

(call_expression function: (identifier) @_context)
(type_instantiation_expression function: (identifier) @_context)
(method_call_expression method: (identifier) @_context)
(type_instantiation_expression method: (identifier) @_context)
(field_expression field: (identifier) @_context)
(table_field key: (identifier) @_context)
(property_type name: (identifier) @_context)
(type_reference module: (identifier) @_context)
(type_reference name: (identifier) @_context)
(class_reference module: (identifier) @_context)
(type_alias_declaration name: (identifier) @_context)
(function_name field: (identifier) @_context)
(function_name method: (identifier) @_context)
