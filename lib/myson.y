class Myson::GeneratedParser
rule
  start: document;
  
  empty: ;
  os: token_separator | empty;
  token_separator: token_separator_chars;
  token_separator_chars: token_separator_char
    | token_separator_char token_separator_chars
    ;
  token_separator_char: whitespace_char | newline_char;
  whitespace_char: ' ' | '\t';
  newline_char: '\n' | 'r';
  
  
  
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
  float_exp_digits: 'e' integer_digits { result = val.join('') }
    | 'e' '-' integer_digits { result = val.join('') }
    | 'e' '+' integer_digits { result = val.join('') }
    ;
  # string
  
  # array
  array: '[' os ']' { result = [] }
    | '[' os array_items os ']' { result = val[2] }
    ;
  array_items: literal { result = [val[0]] }
    | literal rest_array_items { result = [val[0]] + val[1] }
    ;
  rest_array_items: rest_array_item { result = [val[0]] }
    | rest_array_item rest_array_items { result = [val[0]] + val[1] }
    ;
  rest_array_item: os ',' os literal { result = val[3] };
end
