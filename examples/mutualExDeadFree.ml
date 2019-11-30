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
  enum "client" (int_consts [1; 2;3]);
  enum "boolean" [_True; _False];
]



let vardefs = List.concat [
  [arrdef [("n", [paramdef "i0" "client"])] "state"];
  [arrdef [("x", [])] "boolean"]
]

let init = (parallel [(forStatement (assign (arr [("n", [paramref "i"])]) (const _I)) [paramdef "i" "client"]); (assign (global "x") (const (boolc true)))])

let n_Try =
  let name = "n_Try" in
  let params = [paramdef "i" "client"] in
  let formula = (eqn (var (arr [("n", [paramref "i"])])) (const _I)) in
  let statement = (assign (arr [("n", [paramref "i"])]) (const _T)) in
  rule name params formula statement

let n_Crit =
  let name = "n_Crit" in
  let params = [paramdef "i" "client"] in
  let formula = (andList [(eqn (var (arr [("n", [paramref "i"])])) (const _T)); (eqn (var (global "x")) (const (boolc true)))]) in
  let statement = (parallel [(assign (arr [("n", [paramref "i"])]) (const _C)); (assign (global "x") (const (boolc false)))]) in
  rule name params formula statement

let n_Exit =
  let name = "n_Exit" in
  let params = [paramdef "i" "client"] in
  let formula = (eqn (var (arr [("n", [paramref "i"])])) (const _C)) in
  let statement = (assign (arr [("n", [paramref "i"])]) (const _E)) in
  rule name params formula statement

let n_Idle =
  let name = "n_Idle" in
  let params = [paramdef "i" "client"] in
  let formula = (eqn (var (arr [("n", [paramref "i"])])) (const _E)) in
  let statement = (parallel [(assign (arr [("n", [paramref "i"])]) (const _I)); (assign (global "x") (const (boolc true)))]) in
  rule name params formula statement

let rules = [n_Try; n_Crit; n_Exit; n_Idle]

let n_coherence =
  let name = "n_coherence" in
  let params = [paramdef "i" "client"; paramdef "j" "client"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (arr [("n", [paramref "i"])])) (const _C)) (neg (eqn (var (arr [("n", [paramref "j"])])) (const _C))))) in
  prop name params formula

let inferGuard rule=
	let Rule(n,pds,g,a)=rule in
	match pds with
	|[] -> g
	|_ -> existFormula pds g

let inferDeadLockProp rules=
	orList (List.map ~f:inferGuard rules)

let n_deadLockFree =
  let name = "n_deadLockFree" in
  let params = [] in
  let formula = (existFormula [paramdef "i" "client"] (orList [(orList [(orList [(eqn (var (arr [("n", [paramref "i"])])) (const _I)); (andList [(eqn (var (arr [("n", [paramref "i"])])) (const _T)); (eqn (var (global "x")) (const (boolc true)))])]); (eqn (var (arr [("n", [paramref "i"])])) (const _C))]); (eqn (var (arr [("n", [paramref "i"])])) (const _E))])) in
  prop name params formula

let makeDeadLockProp rules=
	let name = "n_deadLockFree" in
  let params = [] in 
	prop name params (inferDeadLockProp rules)

let properties = [makeDeadLockProp rules] (*n_coherence;*) (*n_deadLockFree*)


let protocol = {
  name = "n_mutualExDeadFree";
  types;
  vardefs;
  init;
  rules;
  properties;
}

let () = run_with_cmdline (fun () ->
  let protocol = preprocess_rule_guard ~loach:protocol in
  let cinvs_with_varnames, relations = anotherFind protocol
    ~murphi:(In_channel.read_all "n_mutualExDeadFree.m")
  in
  Isabelle.protocol_act protocol cinvs_with_varnames relations ()
)

