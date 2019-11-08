
(* This program is translated from its corresponding murphi version *)

open Core.Std
open Utils
open Paramecium
open Loach
open Formula
open InvFinder
open Cmdline

let _I = strc "I"
let _T = strc "T"
let _C = strc "C"
let _E = strc "E"
let _True = boolc true
let _False = boolc false

let types = [
  enum "state" [_I; _T; _C; _E];
  enum "DATA" (int_consts [1; 2]);
  enum "NODE" (int_consts [1; 2]);
  enum "boolean" [_True; _False];
]

let _status = List.concat [
  [arrdef [("st", [])] "state"];
  [arrdef [("data", [])] "DATA"]
]

let vardefs = List.concat [
  record_def "n" [paramdef "i0" "NODE"] _status;
  [arrdef [("x", [])] "boolean"];
  [arrdef [("auxDATA", [])] "DATA"];
  [arrdef [("memDATA", [])] "DATA"]
]

let init = (parallel [(forStatement (parallel [(assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _I)); (assign (record [arr [("n", [paramref "i"])]; global "data"]) (param (paramfix "d" "DATA" (intc 1))))]) [paramdef "i" "NODE"]); (assign (global "x") (const (boolc true))); (assign (global "auxDATA") (param (paramfix "d" "DATA" (intc 1)))); (assign (global "memDATA") (param (paramfix "d" "DATA" (intc 1))))])

let n_Try =
  let name = "n_Try" in
  let params = [paramdef "i" "NODE"] in
  let formula = (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) in
  let statement = (assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _T)) in
  rule name params formula statement

let n_Crit =
  let name = "n_Crit" in
  let params = [paramdef "i" "NODE"] in
  let formula = (andList [(eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)); (eqn (var (global "x")) (const (boolc true)))]) in
  let statement = (parallel [(assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _C)); (assign (global "x") (const (boolc false))); (assign (record [arr [("n", [paramref "i"])]; global "data"]) (var (global "memDATA")))]) in
  rule name params formula statement

let n_Exit =
  let name = "n_Exit" in
  let params = [paramdef "i" "NODE"] in
  let formula = (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) in
  let statement = (assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _E)) in
  rule name params formula statement

let n_Idle =
  let name = "n_Idle" in
  let params = [paramdef "i" "NODE"] in
  let formula = (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) in
  let statement = (parallel [(assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _I)); (assign (global "x") (const (boolc true))); (assign (global "memDATA") (var (record [arr [("n", [paramref "i"])]; global "data"])))]) in
  rule name params formula statement

let n_Store =
  let name = "n_Store" in
  let params = [paramdef "i" "NODE"; paramdef "data" "DATA"] in
  let formula = (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) in
  let statement = (parallel [(assign (record [arr [("n", [paramref "i"])]; global "st"]) (const _C)); (assign (global "x") (const (boolc false))); (assign (global "auxDATA") (param (paramref "data"))); (assign (record [arr [("n", [paramref "i"])]; global "data"]) (param (paramref "data")))]) in
  rule name params formula statement

let n_ABS_Store =
  let name = "n_ABS_Store" in
  let params = [paramdef "data" "DATA"] in
  let formula = (forallFormula [paramdef "j" "NODE"] (andList [(neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C))); (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _E)))])) in
  let statement = (parallel [(assign (global "x") (const (boolc false))); (assign (global "auxDATA") (param (paramref "data")))]) in
  rule name params formula statement

let n_ABS_Crit =
  let name = "n_ABS_Crit" in
  let params = [] in
  let formula = (eqn (var (global "x")) (const (boolc true))) in
  let statement = (assign (global "x") (const (boolc false))) in
  rule name params formula statement

let n_ABS_Idle =
  let name = "n_ABS_Idle" in
  let params = [] in
  let formula = (forallFormula [paramdef "j" "NODE"] (andList [(neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C))); (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _E)))])) in
  let statement = (parallel [(assign (global "x") (const (boolc true))); (assign (global "memDATA") (var (global "auxDATA")))]) in
  rule name params formula statement

let rules = [n_Try; n_Crit; n_Exit; n_Idle; n_Store; n_ABS_Store; n_ABS_Crit; n_ABS_Idle]

let n_coherence =
  let name = "n_coherence" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_inv1 =
  let name = "n_inv1" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let n_inv2 =
  let name = "n_inv2" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let n_inv3 =
  let name = "n_inv3" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_inv4 =
  let name = "n_inv4" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_inv5 =
  let name = "n_inv5" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_inv6 =
  let name = "n_inv6" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (global "x")) (const (boolc true))) (eqn (var (global "memDATA")) (var (global "auxDATA")))) in
  prop name params formula
(*
let n_inv1 =
  let name = "n_inv1" in
  let params = [] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let n_inv2 =
  let name = "n_inv2" in
  let params = [] in
  let formula = (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) in
  prop name params formula

let n_inv3 =
  let name = "n_inv3" in
  let params = [] in
  let formula = (neg (eqn (var (global "i")) (var (global "j")))) in
  prop name params formula
; n_inv1; n_inv2; n_inv3
*)
let properties = [n_coherence; n_inv1; n_inv2; n_inv3; n_inv4; n_inv5; n_inv6]


let protocol = {
  name = "n_mutualExAbs1";
  types;
  vardefs;
  init;
  rules;
  properties;
}

let () = run_with_cmdline (fun () ->
  let protocol = preprocess_rule_guard ~loach:protocol in
  let cinvs_with_varnames, relations = anotherFind protocol
    ~murphi:(In_channel.read_all "n_mutualExAbs1.m")
  in
  Isabelle.protocol_act protocol cinvs_with_varnames relations ()
)

