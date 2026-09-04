/**
 * @file Tree-sitter grammar for Luau
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />

const PREC = {
  OR: 1,
  AND: 2,
  COMPARE: 3,
  CONCATENATE: 4,
  ADD: 5,
  MULTIPLY: 6,
  UNARY: 7,
  POWER: 8,
  CAST: 9,
  POSTFIX: 10,

  TYPE_UNION: 1,
  TYPE_INTERSECTION: 2,
  TYPE_OPTIONAL: 3,
};

const HARD_KEYWORDS = [
  "and",
  "break",
  "do",
  "else",
  "elseif",
  "end",
  "false",
  "for",
  "function",
  "if",
  "in",
  "local",
  "nil",
  "not",
  "or",
  "repeat",
  "return",
  "then",
  "true",
  "until",
  "while",
];

const CONTEXTUAL_KEYWORDS = [
  "class",
  "const",
  "continue",
  "declare",
  "export",
  "extends",
  "extern",
  "open",
  "public",
  "read",
  "type",
  "typeof",
  "with",
  "write",
];

const BINARY_OPERATORS = [
  ["or", PREC.OR, "left"],
  ["and", PREC.AND, "left"],
  ["<", PREC.COMPARE, "left"],
  ["<=", PREC.COMPARE, "left"],
  [">", PREC.COMPARE, "left"],
  [">=", PREC.COMPARE, "left"],
  ["==", PREC.COMPARE, "left"],
  ["~=", PREC.COMPARE, "left"],
  ["..", PREC.CONCATENATE, "right"],
  ["+", PREC.ADD, "left"],
  ["-", PREC.ADD, "left"],
  ["*", PREC.MULTIPLY, "left"],
  ["/", PREC.MULTIPLY, "left"],
  ["//", PREC.MULTIPLY, "left"],
  ["%", PREC.MULTIPLY, "left"],
  ["^", PREC.POWER, "right"],
];

export default grammar({
  name: "luau",

  extras: ($) => [/[ \t\v\f\r\n]/, $._comment],

  externals: ($) => [$.block_comment, $.long_string],

  reserved: {
    global: () => HARD_KEYWORDS,
  },

  word: ($) => $._identifier,

  supertypes: ($) => [$._statement, $._expression, $._type],

  conflicts: ($) => [
    [$.continue_statement, $.identifier],
    [$.typeof_type, $.identifier],
    [$.access_qualifier, $.identifier],
    [$.expression_statement, $._prefix_expression],
    [$._expression, $._prefix_expression],
    [$.function_type_parameter, $.parenthesized_type],
    [$.function_type_parameter, $.type_list],
    [$._packed_function_type_parameters, $.function_type_parameters, $.type_list],
    [$.parenthesized_type, $.function_type_parameter, $.type_list],
    [$.string_type, $.property_type],
    [$.string_type, $.extern_property],
  ],

  rules: {
    source_file: ($) => repeat(choice($._statement, ";")),

    block: ($) => repeat1(choice($._statement, ";")),

    _statement: ($) =>
      choice(
        $.assignment_statement,
        $.compound_assignment_statement,
        $.expression_statement,
        $.local_declaration,
        $.const_declaration,
        $.function_declaration,
        $.local_function_declaration,
        $.const_function_declaration,
        $.class_declaration,
        $.type_alias_declaration,
        $.type_function_declaration,
        $.declare_global,
        $.declare_function,
        $.extern_type_declaration,
        $.do_statement,
        $.while_statement,
        $.repeat_statement,
        $.if_statement,
        $.numeric_for_statement,
        $.generic_for_statement,
        $.return_statement,
        $.break_statement,
        $.continue_statement,
      ),

    local_declaration: ($) =>
      seq(
        optional("export"),
        "local",
        field("bindings", $.binding_list),
        optional(seq("=", field("values", $.expression_list))),
      ),

    const_declaration: ($) =>
      seq(
        optional("export"),
        "const",
        field("bindings", $.binding_list),
        "=",
        field("values", $.expression_list),
      ),

    binding_list: ($) => commaSep1($.binding),

    binding: ($) => seq(field("name", $.identifier), optional(seq(":", field("type", $._type)))),

    assignment_statement: ($) =>
      seq(field("left", $.assignment_target_list), "=", field("right", $.expression_list)),

    assignment_target_list: ($) => commaSep1($._assignment_target),

    _assignment_target: ($) => choice($.identifier, $.field_expression, $.index_expression),

    compound_assignment_statement: ($) =>
      seq(
        field("left", $._assignment_target),
        field("operator", choice("+=", "-=", "*=", "/=", "//=", "%=", "^=", "..=")),
        field("right", $._expression),
      ),

    expression_statement: ($) => choice($.call_expression, $.method_call_expression),

    function_declaration: ($) =>
      seq(
        optional(field("attributes", $.attributes)),
        optional("export"),
        "function",
        field("name", $.function_name),
        $.function_body,
      ),

    local_function_declaration: ($) =>
      seq(
        optional(field("attributes", $.attributes)),
        "local",
        "function",
        field("name", $.identifier),
        $.function_body,
      ),

    const_function_declaration: ($) =>
      seq(
        optional(field("attributes", $.attributes)),
        "const",
        "function",
        field("name", $.identifier),
        $.function_body,
      ),

    class_declaration: ($) =>
      seq(
        optional("export"),
        optional("open"),
        "class",
        field("name", $.identifier),
        optional(seq("extends", field("superclass", $.class_reference))),
        repeat(field("member", $._class_member)),
        "end",
      ),

    class_reference: ($) =>
      choice(
        $.identifier,
        seq(field("module", $.identifier), ".", field("name", $.identifier)),
        seq(field("module", $.identifier), "[", field("key", $._expression), "]"),
      ),

    _class_member: ($) => choice($.class_property, $.class_method),

    class_property: ($) =>
      seq("public", field("name", $.identifier), optional(seq(":", field("type", $._type)))),

    class_method: ($) =>
      seq(optional("public"), "function", field("name", $.identifier), $.function_body),

    function_name: ($) =>
      seq(
        field("name", $.identifier),
        repeat(seq(".", field("field", $.identifier))),
        optional(seq(":", field("method", $.identifier))),
      ),

    function_body: ($) =>
      seq(
        optional(field("generics", $.generic_parameter_list)),
        field("parameters", $.parameter_list),
        optional(seq(":", field("return_type", $._return_type))),
        optional(field("body", $.block)),
        "end",
      ),

    parameter_list: ($) =>
      seq(
        "(",
        optional(
          choice(
            commaSep1($.parameter),
            seq(commaSep1($.parameter), ",", $.variadic_parameter),
            $.variadic_parameter,
          ),
        ),
        optional(","),
        ")",
      ),

    parameter: ($) => seq(field("name", $.identifier), optional(seq(":", field("type", $._type)))),

    variadic_parameter: ($) =>
      seq("...", optional(seq(":", field("type", choice($._type, $.generic_type_pack))))),

    do_statement: ($) => seq("do", optional(field("body", $.block)), "end"),

    while_statement: ($) =>
      seq(
        "while",
        field("condition", $._expression),
        "do",
        optional(field("body", $.block)),
        "end",
      ),

    repeat_statement: ($) =>
      seq("repeat", optional(field("body", $.block)), "until", field("condition", $._expression)),

    if_statement: ($) =>
      seq(
        "if",
        choice(
          seq(field("condition", $._expression), "then", optional(field("consequence", $.block))),
          $.if_local_clause,
        ),
        repeat(field("alternative", $.elseif_clause)),
        optional(field("alternative", $.else_clause)),
        "end",
      ),

    if_local_clause: ($) =>
      seq(
        choice("local", "const"),
        field("binding", $.binding),
        "=",
        field("condition", $._expression),
        "then",
        optional(field("consequence", $.block)),
      ),

    elseif_clause: ($) =>
      seq(
        "elseif",
        choice(
          seq(field("condition", $._expression), "then", optional(field("consequence", $.block))),
          $.if_local_clause,
        ),
      ),

    else_clause: ($) => seq("else", optional(field("body", $.block))),

    numeric_for_statement: ($) =>
      seq(
        "for",
        field("binding", $.binding),
        "=",
        field("start", $._expression),
        ",",
        field("end", $._expression),
        optional(seq(",", field("step", $._expression))),
        "do",
        optional(field("body", $.block)),
        "end",
      ),

    generic_for_statement: ($) =>
      seq(
        "for",
        field("bindings", $.binding_list),
        "in",
        field("values", $.expression_list),
        "do",
        optional(field("body", $.block)),
        "end",
      ),

    return_statement: ($) =>
      prec.right(seq("return", optional(field("values", $.expression_list)))),

    break_statement: () => "break",

    continue_statement: () => "continue",

    expression_list: ($) => prec.right(commaSep1($._expression)),

    _expression: ($) =>
      choice(
        $.nil,
        $.boolean,
        $.integer,
        $.number,
        $.string,
        $.vararg_expression,
        $.identifier,
        $.parenthesized_expression,
        $.function_expression,
        $.table_constructor,
        $.if_expression,
        $.unary_expression,
        $.binary_expression,
        $.type_cast_expression,
        $.field_expression,
        $.index_expression,
        $.call_expression,
        $.method_call_expression,
        $.type_instantiation_expression,
      ),

    parenthesized_expression: ($) => seq("(", $._expression, ")"),

    function_expression: ($) =>
      seq(optional(field("attributes", $.attributes)), "function", $.function_body),

    if_expression: ($) =>
      prec.right(
        seq(
          "if",
          field("condition", $._expression),
          "then",
          field("consequence", $._expression),
          repeat(field("alternative", $.elseif_expression_clause)),
          "else",
          field("alternative", $._expression),
        ),
      ),

    elseif_expression_clause: ($) =>
      seq("elseif", field("condition", $._expression), "then", field("consequence", $._expression)),

    unary_expression: ($) =>
      prec(
        PREC.UNARY,
        seq(field("operator", choice("not", "-", "#")), field("operand", $._expression)),
      ),

    binary_expression: ($) =>
      choice(
        ...BINARY_OPERATORS.map(([operator, precedence, associativity]) => {
          const rule = seq(
            field("left", $._expression),
            field("operator", operator),
            field("right", $._expression),
          );

          return associativity === "right"
            ? prec.right(precedence, rule)
            : prec.left(precedence, rule);
        }),
      ),

    type_cast_expression: ($) =>
      prec.left(PREC.CAST, seq(field("value", $._expression), "::", field("type", $._type))),

    field_expression: ($) =>
      prec.left(
        PREC.POSTFIX,
        seq(field("table", $._prefix_expression), ".", field("field", $.identifier)),
      ),

    index_expression: ($) =>
      prec.left(
        PREC.POSTFIX,
        seq(field("table", $._prefix_expression), "[", field("index", $._expression), "]"),
      ),

    call_expression: ($) =>
      prec.left(
        PREC.POSTFIX,
        seq(field("function", $._prefix_expression), field("arguments", $.arguments)),
      ),

    method_call_expression: ($) =>
      prec.left(
        PREC.POSTFIX,
        seq(
          field("receiver", $._prefix_expression),
          ":",
          field("method", $.identifier),
          field("arguments", $.arguments),
        ),
      ),

    type_instantiation_expression: ($) =>
      prec.left(
        PREC.POSTFIX,
        choice(
          seq(
            field("function", $._prefix_expression),
            field("type_arguments", $.explicit_type_arguments),
            field("arguments", $.arguments),
          ),
          seq(
            field("receiver", $._prefix_expression),
            ":",
            field("method", $.identifier),
            field("type_arguments", $.explicit_type_arguments),
            field("arguments", $.arguments),
          ),
        ),
      ),

    explicit_type_arguments: ($) => seq("<<", $.type_argument_list, ">>"),

    _prefix_expression: ($) =>
      choice(
        $.identifier,
        $.parenthesized_expression,
        $.field_expression,
        $.index_expression,
        $.call_expression,
        $.method_call_expression,
        $.type_instantiation_expression,
      ),

    arguments: ($) =>
      choice(
        seq("(", optional($.expression_list), optional(","), ")"),
        $.table_constructor,
        $.string,
      ),

    table_constructor: ($) =>
      seq("{", optional(sep1($.table_field, choice(",", ";"))), optional(choice(",", ";")), "}"),

    table_field: ($) =>
      choice(
        seq("[", field("key", $._expression), "]", "=", field("value", $._expression)),
        seq(field("key", $.identifier), "=", field("value", $._expression)),
        field("value", $._expression),
      ),

    vararg_expression: () => "...",

    nil: () => "nil",

    boolean: () => choice("true", "false"),

    integer: () => token(choice(/0[xX][0-9a-fA-F_]+i/, /0[bB][01_]+i/, /[0-9][0-9_]*i/)),

    number: () =>
      token(
        choice(
          /0[xX][0-9a-fA-F_]+(?:\.[0-9a-fA-F_]*)?(?:[pP][+-]?[0-9_]+)?/,
          /0[bB][01_]+/,
          /(?:[0-9][0-9_]*(?:\.[0-9_]*)?|\.[0-9][0-9_]*)(?:[eE][+-]?[0-9_]+)?/,
        ),
      ),

    string: ($) => choice($._string_literal, $.interpolated_string),

    _string_literal: ($) => choice($.quoted_string, $.long_string),

    quoted_string: ($) =>
      choice(
        seq(
          '"',
          repeat(choice(alias($._double_string_content, $.string_content), $.escape_sequence)),
          token.immediate('"'),
        ),
        seq(
          "'",
          repeat(choice(alias($._single_string_content, $.string_content), $.escape_sequence)),
          token.immediate("'"),
        ),
      ),

    _double_string_content: () => token.immediate(prec(1, /[^"\\\r\n]+/)),

    _single_string_content: () => token.immediate(prec(1, /[^'\\\r\n]+/)),

    interpolation_content: () => token.immediate(prec(1, /[^`{\\\r\n]+/)),

    escape_sequence: ($) =>
      choice(
        $.unicode_escape,
        $.decimal_escape,
        $.hex_escape,
        $.whitespace_escape,
        $.simple_escape,
      ),

    unicode_escape: ($) =>
      seq(
        token.immediate("\\u"),
        token.immediate("{"),
        alias(token.immediate(/[0-9a-fA-F]+/), $.escape_codepoint),
        token.immediate("}"),
      ),

    decimal_escape: () => token.immediate(/\\[0-9]{1,3}/),

    hex_escape: () => token.immediate(/\\x[0-9a-fA-F]{2}/),

    whitespace_escape: () => token.immediate(prec(2, seq("\\z", repeat(/[ \t\v\f\r\n]/)))),

    simple_escape: () => token.immediate(choice(/\\[^\r\n]/, /\\\r?\n/)),

    interpolated_string: ($) =>
      seq(
        "`",
        repeat(
          choice(
            $.interpolation_content,
            $.escape_sequence,
            seq("{", field("expression", $._expression), "}"),
          ),
        ),
        token.immediate("`"),
      ),

    type_alias_declaration: ($) =>
      seq(
        optional("export"),
        "type",
        field("name", $.identifier),
        optional(field("generics", $.generic_definition_list)),
        "=",
        field("value", $._type),
      ),

    type_function_declaration: ($) =>
      seq(optional("export"), "type", "function", field("name", $.identifier), $.function_body),

    generic_definition_list: ($) =>
      seq(
        "<",
        commaSep1(choice($.generic_type_definition, $.generic_type_pack_definition)),
        optional(","),
        ">",
      ),

    generic_type_definition: ($) =>
      seq(field("name", $.identifier), optional(seq("=", field("default", $._type)))),

    generic_type_pack_definition: ($) =>
      seq(field("name", $.identifier), "...", optional(seq("=", field("default", $._type_pack)))),

    generic_parameter_list: ($) =>
      seq("<", commaSep1(choice($.generic_type, $.generic_type_pack)), optional(","), ">"),

    generic_type: ($) => field("name", $.identifier),

    generic_type_pack: ($) => seq(field("name", $.identifier), "..."),

    _type: ($) =>
      choice(
        $.type_reference,
        $.nil_type,
        $.boolean_type,
        $.string_type,
        $.typeof_type,
        $.table_type,
        $.function_type,
        $.attributed_function_type,
        $.parenthesized_type,
        $.union_type,
        $.intersection_type,
        $.optional_type,
        $.leading_type,
      ),

    type_reference: ($) =>
      prec.right(
        seq(
          optional(seq(field("module", $.identifier), ".")),
          field("name", $.identifier),
          optional(seq("<", field("arguments", $.type_argument_list), ">")),
        ),
      ),

    type_argument_list: ($) => commaSep1($._type_argument),

    _type_argument: ($) => choice($._type, $._type_pack),

    nil_type: () => "nil",

    boolean_type: () => choice("true", "false"),

    string_type: ($) => $._string_literal,

    typeof_type: ($) => seq("typeof", "(", field("value", $._expression), ")"),

    parenthesized_type: ($) => seq("(", $._type, ")"),

    function_type: ($) =>
      seq(
        optional(field("generics", $.generic_parameter_list)),
        field("parameters", $.function_type_parameters),
        "->",
        field("return_type", $._return_type),
      ),

    _packed_function_type_parameters: ($) => prec(2, seq("(", $._variadic_type_pack, ")")),

    _packed_function_type: ($) =>
      seq(
        field("parameters", alias($._packed_function_type_parameters, $.function_type_parameters)),
        "->",
        field("return_type", $._return_type),
      ),

    attributed_function_type: ($) =>
      seq(field("attributes", $.attributes), field("type", $.function_type)),

    function_type_parameters: ($) =>
      seq(
        "(",
        optional(
          choice(
            commaSep1($.function_type_parameter),
            seq(commaSep1($.function_type_parameter), ",", $._variadic_type_pack),
            $._variadic_type_pack,
          ),
        ),
        optional(","),
        ")",
      ),

    function_type_parameter: ($) =>
      seq(optional(seq(field("name", $.identifier), ":")), field("type", $._type)),

    _return_type: ($) =>
      choice(alias($._packed_function_type, $.function_type), $._type, $._type_pack),

    _type_pack: ($) => choice($.type_pack, $.variadic_type_pack, $.generic_type_pack),

    type_pack: ($) => seq("(", optional($.type_list), optional(","), ")"),

    type_list: ($) =>
      prec.right(
        choice(
          commaSep1($._type),
          seq(commaSep1($._type), ",", prec(1, $._variadic_type_pack)),
          prec(1, $._variadic_type_pack),
        ),
      ),

    _variadic_type_pack: ($) => choice($.variadic_type_pack, $.generic_type_pack),

    variadic_type_pack: ($) => seq("...", field("type", $._type)),

    table_type: ($) =>
      seq(
        "{",
        optional(choice($.array_type, sep1($._table_type_member, choice(",", ";")))),
        optional(choice(",", ";")),
        "}",
      ),

    array_type: ($) =>
      seq(optional(field("access", $.access_qualifier)), field("element", $._type)),

    _table_type_member: ($) => choice($.property_type, $.indexer_type),

    property_type: ($) =>
      prec.dynamic(
        1,
        seq(
          optional(field("access", $.access_qualifier)),
          field("name", choice($.identifier, seq("[", $._string_literal, "]"))),
          ":",
          field("type", $._type),
        ),
      ),

    indexer_type: ($) =>
      seq(
        optional(field("access", $.access_qualifier)),
        "[",
        field("key", $._type),
        "]",
        ":",
        field("value", $._type),
      ),

    access_qualifier: () => choice("read", "write"),

    union_type: ($) =>
      prec.left(PREC.TYPE_UNION, seq(field("left", $._type), "|", field("right", $._type))),

    intersection_type: ($) =>
      prec.left(PREC.TYPE_INTERSECTION, seq(field("left", $._type), "&", field("right", $._type))),

    optional_type: ($) => prec.left(PREC.TYPE_OPTIONAL, seq(field("type", $._type), "?")),

    leading_type: ($) =>
      prec.right(seq(field("operator", choice("|", "&")), field("type", $._type))),

    declare_global: ($) => seq("declare", field("name", $.identifier), ":", field("type", $._type)),

    declare_function: ($) =>
      seq(
        optional(field("attributes", $.attributes)),
        "declare",
        "function",
        field("name", $.identifier),
        optional(field("generics", $.generic_parameter_list)),
        field("parameters", $.declare_parameter_list),
        optional(seq(":", field("return_type", $._return_type))),
      ),

    declare_parameter_list: ($) =>
      seq(
        "(",
        optional(
          choice(
            commaSep1($.declare_parameter),
            seq(commaSep1($.declare_parameter), ",", $.declare_variadic_parameter),
            $.declare_variadic_parameter,
          ),
        ),
        optional(","),
        ")",
      ),

    declare_parameter: ($) => seq(field("name", $.identifier), ":", field("type", $._type)),

    declare_variadic_parameter: ($) =>
      seq("...", ":", field("type", choice($._type, $.generic_type_pack))),

    extern_type_declaration: ($) =>
      seq(
        "declare",
        "extern",
        "type",
        field("name", $.identifier),
        optional(seq("extends", field("supertype", $.identifier))),
        "with",
        repeat(field("member", $._extern_member)),
        "end",
      ),

    _extern_member: ($) => choice($.extern_property, $.extern_indexer, $.extern_method),

    extern_property: ($) =>
      prec.dynamic(
        1,
        seq(
          optional(field("access", $.access_qualifier)),
          field("name", choice($.identifier, seq("[", $._string_literal, "]"))),
          ":",
          field("type", $._type),
        ),
      ),

    extern_indexer: ($) =>
      seq(
        optional(field("access", $.access_qualifier)),
        "[",
        field("key", $._type),
        "]",
        ":",
        field("value", $._type),
      ),

    extern_method: ($) =>
      seq(
        optional(field("attributes", $.attributes)),
        "function",
        field("name", $.identifier),
        optional(field("generics", $.generic_parameter_list)),
        field("parameters", $.parameter_list),
        optional(seq(":", field("return_type", $._return_type))),
      ),

    attributes: ($) => repeat1($.attribute),

    attribute: ($) =>
      choice(
        seq("@", field("name", alias(token.immediate(/[A-Za-z_][A-Za-z0-9_]*/), $.identifier))),
        seq("@[", commaSep1($.parameterized_attribute), optional(","), "]"),
      ),

    parameterized_attribute: ($) =>
      seq(field("name", $.identifier), optional(field("arguments", $.attribute_argument))),

    attribute_argument: ($) =>
      choice(
        $._string_literal,
        $.literal_table,
        seq("(", optional(commaSep1($._literal)), optional(","), ")"),
      ),

    _literal: ($) => choice($.nil, $.boolean, $.number, $._string_literal, $.literal_table),

    literal_table: ($) => seq("{", optional(commaSep1($.literal_field)), optional(","), "}"),

    literal_field: ($) =>
      choice(
        seq(field("key", $.identifier), "=", field("value", $._literal)),
        field("value", $._literal),
      ),

    identifier: ($) => choice($._identifier, ...CONTEXTUAL_KEYWORDS),

    _identifier: () => /[A-Za-z_][A-Za-z0-9_]*/,

    line_comment: () => token(seq("--", /[^\r\n]*/)),

    _comment: ($) => choice($.line_comment, $.block_comment),
  },
});

function commaSep1(rule) {
  return sep1(rule, ",");
}

function sep1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)));
}
