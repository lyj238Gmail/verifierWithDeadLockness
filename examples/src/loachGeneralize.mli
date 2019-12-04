open Utils
open Paramecium



open Loach

open Core.Std
 
(** Convert statement*)
val form_act: generalizedtParas:const list -> ?rename:bool ->formula ->Paramecium.paramdef list ->
Paramecium.paramref list -> Paramecium.paramdef list *Paramecium.paramref list * formula

val rule_act :  generalizedtParas:const list -> ?rename:bool ->rule ->rule

val concreteInv2ParamProp: formula -> int ->prop
