class Myson::GeneratedParser
rule
  start: document;
  
  # document
  document: object | array | null;
  literal: object | array | primitive;
  
  # primative
  primitive: null | boolean | number | string;
  null: 'null' { result = nil };
  boolean: 'true' { result = true }
    | 'false' { result = false }
    ;
  number: NUMBER;
  string: STRING;
  
  # array
  array: '[' ']' { result = [] }
    | '[' array_items ']' { result = val[1] }
    ;
  array_items: literal { result = [val[0]] }
    | literal comma_array_items { result = [val[0]] + val[1] }
    ;
  comma_array_items: comma_array_item { result = [val[0]] }
    | comma_array_item comma_array_items { result = [val[0]] + val[1] }
    ;
  comma_array_item: ',' literal { result = val[1] };

  # object
  object: '{' '}' { result = {} }
    | '{' object_items '}' { result = Hash[val[1]] };
  object_items: object_item { result = [val[0]] }
    | object_item comma_object_items { result = [val[0]] + val[1] }
    ;
  object_item: string ':' literal { result = [val[0], val[2]] };
  comma_object_items: comma_object_item { result = [val[0]] }
    | comma_object_item comma_object_items { result = [val[0]] + val[1] }
    ;
  comma_object_item: ',' object_item { result = val[1] };
end
