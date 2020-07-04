exception Error

type token = 
  | SENDTO
  | RIGHT_MIDBRACE
  | RIGHT_BRACE
  | LEFT_MIDBRACE
  | LEFT_BRACE
  | INTEGER of (string)
  | ID of (string)
  | EQ
  | EOF
  | ELSE
  | COMMA


val smtModel: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> ((string * string) list)