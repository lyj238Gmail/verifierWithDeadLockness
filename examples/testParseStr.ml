open Core.Std
open SmtLexer
open Lexing
let () =
	let reult= GetModelString.readCeFromStr "[x = False,
 n = [2 -> T, 3 -> T, else -> T] , 
k!14 = [2 -> T, 3 -> T, else -> T]
]" in
(*test chkce*)

()
