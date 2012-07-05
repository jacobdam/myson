class Myson::GeneratedParser
rule
  start: document;
  
  empty: ;
  os: opt_token_separator;
  opt_token_separator: token_separator | empty;
  token_separator: token_separator_chars;
  token_separator_chars: token_separator_char
    | token_separator_char token_separator_chars
    ;
  token_separator_char: whitespace_char | newline_char;
  whitespace_char: ' ' | "\t";
  newline_char: "\n" | "\r";
  
  document: object | array | primitive;
  literal: object | array | primitive;
  primitive: null | boolean | number | string;
  
  # constant
  null: 'n' 'u' 'l' 'l' { result = nil };
  boolean: 't' 'r' 'u' 'e' { result = true }
    | 'f' 'a' 'l' 's' 'e' { result = false }
    ;

  # number
  number: integer | float;
  integer: positive_integer
    | '-' positive_integer { result = -val[1] }
    ;
  positive_integer: integer_digits { result = val[0].to_i };
  integer_digits: non_zero_digit digits_opt { result = val.join('') }
    | '0'
    ;
  non_zero_digit: '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';
  digit: non_zero_digit | '0';
  digits_opt: digits | empty;
  digits: digit
    | digit digits { result = val[0] + val[1] }
    ;
  float: positive_float
    | '-' positive_float { result = -val[1] }
    ;
  positive_float: float_digits { result = val[0].to_f }
  float_digits: simple_float_digits | exp_float_digits;
  simple_float_digits: integer_digits '.' digits { result = val.join('') };
  exp_float_digits: integer_digits float_exp_digits { result = val.join('') }
    | simple_float_digits float_exp_digits { result = val.join('') }
    ;
  float_exp_digits: float_exp_indicator integer_digits { result = val.join('') }
    | float_exp_indicator '-' integer_digits { result = val.join('') }
    | float_exp_indicator '+' integer_digits { result = val.join('') }
    ;
  float_exp_indicator: 'e' | 'E';
  

  # string
  string: '"' string_items_opt '"' { result = val[1] };
  string_items_opt: string_items 
    | empty { result = '' };
  string_items: string_item
    | string_item string_items { result = val.join('') }
    ;
  string_item: escaped_char | escaped_unicode_char | slash_and_char | unescaped_char;
  escaped_char: '\\' 'n' { result = "\n" }
    | '\\' 'r' { result = "\r" }
    | '\\' 't' { result = "\t" }
    | '\\' 'b' { result = "\b" }
    | '\\' 'f' { result = "\f" }
    ;
  escaped_unicode_char: '\\' 'u' hexa_digit hexa_digit hexa_digit hexa_digit { result = make_unicode_char(val[2..-1].join('').hex) };
  hexa_digit: digit | 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'A' | 'B' | 'C' | 'D' | 'E' | 'F';
  slash_and_char: "\\" ignore_slash_char { result = val[1] };

  # any_char: "\t" | "\n" | "\r" | " " | "\"" | "+" | "," | "-" | "." | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "A" | "B" | "C" | "D" | "E" | "F" | "[" | "\\" | "]" | "a" | "b" | "c" | "d" | "e" | "f" | "l" | "n" | "r" | "s" | "t" | "u";
  # ignore_slash_char = [^bfnrtu]
  ignore_slash_char: known_ignore_slash_char | OTHER;
  known_ignore_slash_char: "\t" | "\n" | "\r" | " " | "\"" | "+" | "," | "-" | "." | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "A" | "B" | "C" | "D" | "E" | "F" | "[" | "\\" | "]" | "a" | "c" | "d" | "e" | "l" | "s";
  
  # unescaped_char = [^\"\\]
  unescaped_char: known_unescaped_char | OTHER;
  known_unescaped_char: "\t" | "\n" | "\r" | " " | "+" | "," | "-" | "." | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "A" | "B" | "C" | "D" | "E" | "F" | "[" | "]" | "a" | "b" | "c" | "d" | "e" | "f" | "l" | "n" | "r" | "s" | "t" | "u";

  # array
  array: '[' os ']' { result = [] }
    | '[' array_items ']' { result = val[1] }
    ;
  array_items: array_item { result = [val[0]] }
    | array_item comma_array_items { result = [val[0]] + val[1] }
    ;
  array_item: os literal os { result = val[1] }
  comma_array_items: comma_array_item { result = [val[0]] }
    | comma_array_item comma_array_items { result = [val[0]] + val[1] }
    ;
  comma_array_item: ',' array_item { result = val[1] };

  # object
  object: '{' os '}' { result = {} }
    | '{' object_items '}' { result = Hash[val[1]] };
  object_items: object_item { result = [val[0]] }
    | object_item comma_object_items { result = [val[0]] + val[1] }
    ;
  object_item: os string os ':' os literal os { result = [val[1], val[5]] };
  comma_object_items: comma_object_item { result = [val[0]] }
    | comma_object_item comma_object_items { result = [val[0]] + val[1] }
    ;
  comma_object_item: ',' object_item { result = val[1] };
end
