(** Language for cache coherence protocols
*)

(*------------------------------ Types ---------------------------------*)

open ParameciumNu

(** Unexhausted instantiation
    This exception should never be raised. Once raised, There should be a bug in this tool.
*)
exception Unexhausted_inst

type exp =
  | Const of const
  | Var of designator
  | Param of paramref
  | Ite of formula * exp * exp
  | UIF of string * exp list
(** Boolean expressions, including
    + Boolean constants, Chaos as True, Miracle as false
    + Equation expression
    + Other basic logical operations, including negation,
      conjuction, disjuction, and implication
*)
and designator =
	| Ident  of string
	| Field of designator* string
	| Arr of designator* paramref
	
and paramref =
	| Paramref of string 
  | Paramfix of string * string * exp
  
and formula =
  | Chaos
  | Miracle
  | UIP of string * exp list
  | Eqn of exp * exp
  | Neg of formula
  | AndList of formula list
  | OrList of formula list
  | Imply of formula * formula
  | ForallFormula of paramdef list * formula
  | ExistFormula of paramdef list * formula
with sexp


val const : const -> exp
val var : designator -> exp
val param : paramref -> exp
val ite : formula -> exp -> exp -> exp
val uif : string -> exp list -> exp

val chaos : formula
val miracle : formula
val uip : string -> exp list -> formula
val eqn : exp -> exp -> formula
val neg : formula -> formula
val andList : formula list -> formula
val orList : formula list -> formula
val imply : formula -> formula -> formula

(** Forall formula *)
val forallFormula : paramdef list -> formula -> formula

(** Exist formula *)
val existFormula : paramdef list -> formula -> formula

(** Assignment statements *)
type statement =
  | Assign of designator * exp
  | Parallel of statement list
  | IfStatement of formula * statement
  | IfelseStatement of formula * statement * statement
  | ForStatement of statement * paramdef list
with sexp

val assign : designator -> exp -> statement
val parallel : statement list -> statement
val ifStatement : formula -> statement -> statement
val ifelseStatement : formula -> statement -> statement -> statement
val forStatement : statement -> paramdef list -> statement


type prop =
  | Prop of string * paramdef list * formula
with sexp

val prop : string -> paramdef list -> formula -> prop

type rule = 
  | Rule of string * paramdef list * formula * statement
with sexp

val rule : string -> paramdef list -> formula -> statement -> rule

(** Represents the whole protocol *)
type protocol = {
  name: string;
  types: typedef list;
  vardefs: vardef list;
  init: statement;
  rules: rule list;
  properties: prop list;
}
with sexp



(*----------------------------- Exceptions ----------------------------------*)

(*----------------------------- Functions ----------------------------------*)
(*\beta substitution *)
val apply_exp : exp -> p:ParameciumNu.paramref list -> exp
val apply_form : formula -> p:ParameciumNu.paramref list -> formula
val apply_statement : statement -> p:ParameciumNu.paramref list -> types:ParameciumNu.typedef list -> 
      statement
val eliminate_for : statement -> types:ParameciumNu.typedef list -> statement
val apply_rule : rule -> p:ParameciumNu.paramref list -> types:ParameciumNu.typedef list -> rule
val rule_to_insts : rule -> types:ParameciumNu.typedef list -> rule list
val analyze_if : statement -> formula -> types:ParameciumNu.typedef list -> 
      (ParameciumNu.designator * (formula * exp) list) list


val balance_ifstatement : statement -> statement list
val eliminate_ifelse : statement -> statement

val preprocess_rule_guard : loach:protocol -> protocol

val flat_loach_and_to_list:  formula -> formula list

val apply_statement_without_fold_forStatement : statement -> p:ParameciumNu.paramref list -> types:ParameciumNu.typedef list -> 
      statement
 
val apply_rule_without_fold_forStatement: rule -> p:ParameciumNu.paramref list -> types:ParameciumNu.typedef list -> rule

val eliminate_false_eq:  int -> exp list ->formula ->formula

val simplify_rule_by_elim_false_eq:  int -> exp list ->rule  ->rule 

val negDisjI2Implication: formula ->formula list

(*----------------------------- Translate module ---------------------------------*)

(** Translate language of this level to the next lower level *)
module Trans : sig

  exception Unexhausted_flatten

  (** Translate language of Loach to Paramecium

      @param loach cache coherence protocol written in Loach
      @return the protocol in Paramecium
  *)
  val act : loach:protocol -> ParameciumNu.protocol
  val trans_formula:    types:ParameciumNu.typedef list ->  formula -> ParameciumNu.formula
  
  val trans_exp:    types:ParameciumNu.typedef list ->  exp -> ParameciumNu.exp
  
  val trans_designator:    types:ParameciumNu.typedef list ->  designator-> ParameciumNu.designator
  
  val trans_paramref:    types:ParameciumNu.typedef list ->  paramref-> ParameciumNu.paramref
  
  val invTrans_formula:  ParameciumNu.formula->formula
  
  val invTrans_prop: ParameciumNu.prop ->prop
end


module ToSmv : sig
	
  val protocol_act : ?limit_param:bool -> protocol -> string
end



module PartParam : sig
  val apply_protocol : string list -> protocol -> protocol
end
open Core.Std

module ParasOf : sig

  (** Names of var *)
  val of_var : designator -> Int.Set.t

  (** Names of exp *)
  val of_exp : exp -> Int.Set.t

  (** Names of formula *)
  val of_form : formula -> Int.Set.t

  val of_statement : statement -> Int.Set.t

  val of_rule : rule -> Int.Set.t
end

module ComputeMap : sig
	val computeMapTable: rule -> rule list -> ((string, string)  Core_kernel.Core_hashtbl.t)
end

module ParaNameReplace : sig
	val apply_rule: rule->dict:((string, string)  Core_kernel.Core_hashtbl.t) -> rule
end

