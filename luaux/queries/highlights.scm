; inherits: luau

(element_name
  name: (identifier) @tag
  !field)

(element_name
  field: (identifier) @tag)

(markup_attribute
  name: (identifier) @attribute)

(opening_element
  ["<" ">"] @punctuation.bracket)

(closing_element
  ["</" ">"] @punctuation.bracket)

(self_closing_element
  ["<" "/>"] @punctuation.bracket)

(fragment
  ["<>" "</>"] @punctuation.bracket)

(markup_attribute
  "=" @punctuation.delimiter)

(inferred_attribute
  "=" @punctuation.delimiter)

(expression_hole
  ["{" "}"] @punctuation.bracket)

(spread_attribute
  ["{" "}"] @punctuation.bracket)

(comment_hole
  ["{" "}"] @punctuation.bracket)

(markup_comment) @comment
(markup_text) @string
