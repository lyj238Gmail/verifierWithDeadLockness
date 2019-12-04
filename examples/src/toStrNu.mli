(** Translate Paramecium to string of other languages
*)

open ParameciumNu

(*----------------------------- Module To SMT String ----------------------------------*)

(** Translate to smt2 string *)
module Smt2 : sig

  val form_of: formula -> string

  val context_of: insym_types:string list -> types:typedef list -> vardefs:vardef list -> string

end

(*----------------------------- Module To SMV String ----------------------------------*)

(** Translate to smv string *)
module Smv : sig

  val const_act : const -> string
  val paramref_act : paramref -> string
  val vardef_act : types:ParameciumNu.typedef list -> ParameciumNu.vardef -> string
  val designator_act : designator -> string
  val exp_act : exp -> string

  (** Translate formula to smv string

      @param form the formula to be translated
      @return the smv string
  *)
  val form_act : ?lower:bool -> formula -> string
(*  val rule_act:rule ->string*)
  val protocol_act : protocol -> string
  
end

(*----------------------------- Module To Debug String ----------------------------------*)

module Debug : sig
  val ignore_paramref : bool ref
  val const_act : const -> string
  val paramref_act : paramref -> string
  val paramdef_act : paramdef -> string
  val designator_act : ParameciumNu.designator -> string
  val exp_act : exp -> string
  val form_act : formula -> string
end
