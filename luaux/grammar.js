/**
 * @file Tree-sitter grammar for LuauX
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />

const luau = require("../grammar");

module.exports = grammar(luau, {
  name: "luaux",

  externals: ($, original) => [...original, $.markup_text, $._markup_comment_text],

  rules: {
    _expression: ($, original) => choice(original, $._markup_expression),

    _prefix_expression: ($, original) => choice(original, $._markup_expression),

    _markup_expression: ($) => choice($.element, $.self_closing_element, $.fragment),

    element: ($) =>
      prec.dynamic(
        -1,
        seq(
          field("open_tag", $.opening_element),
          repeat(field("child", $._markup_child)),
          field("close_tag", $.closing_element),
        ),
      ),

    self_closing_element: ($) =>
      prec.dynamic(
        -1,
        seq("<", field("name", $.element_name), repeat(field("attribute", $._attribute)), "/>"),
      ),

    fragment: ($) => prec.dynamic(-1, seq("<>", repeat(field("child", $._markup_child)), "</>")),

    opening_element: ($) =>
      seq("<", field("name", $.element_name), repeat(field("attribute", $._attribute)), ">"),

    closing_element: ($) => seq("</", field("name", $.element_name), ">"),

    element_name: ($) =>
      seq(field("name", $.identifier), repeat(seq(".", field("field", $.identifier)))),

    _attribute: ($) => choice($.markup_attribute, $.spread_attribute, $.inferred_attribute),

    markup_attribute: ($) =>
      prec.right(
        seq(
          field("name", $.identifier),
          optional(seq("=", field("value", choice($.quoted_string, $.expression_hole)))),
        ),
      ),

    spread_attribute: ($) => seq("{", field("expression", $._expression), "}"),

    inferred_attribute: ($) => seq("=", field("value", $.expression_hole)),

    expression_hole: ($) => seq("{", field("expression", $._expression), "}"),

    comment_hole: ($) =>
      seq("{", repeat1(field("comment", choice($.line_comment, $.block_comment))), "}"),

    _markup_child: ($) =>
      choice(
        $.element,
        $.self_closing_element,
        $.fragment,
        $.expression_hole,
        $.comment_hole,
        $.markup_comment,
        $.markup_text,
      ),

    markup_comment: ($) => seq("<!--", optional($._markup_comment_text), $._markup_comment_end),

    _markup_comment_end: () => token(prec(1, "-->")),
  },
});
