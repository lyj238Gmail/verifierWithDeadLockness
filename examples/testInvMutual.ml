
open Core.Std
open Utils
open Paramecium
open Loach
open Formula
open InvFinder
open Cmdline
open CheckInv 

let _I = strc "I"
let _T = strc "T"
let _C = strc "C"
let _E = strc "E"
let _True = boolc true
let _False = boolc false

let types = [
  enum "state" [_I; _T; _C; _E];
  enum "client" (int_consts [1;2]);
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
  let params = [paramdef "i" "client"; paramdef "j" "client"; paramdef "k" "client"] in
  let formula = (imply (andList [(neg (eqn (param (paramref "i")) (param (paramref "j"))));(neg (eqn (param (paramref "k")) (param (paramref "j")))); (neg (eqn (param (paramref "i")) (param (paramref "k"))))]) (neg (andList [(andList [(andList [(eqn (var (arr [("n", [paramref "i"])])) (const _T)); (eqn (var (arr [("n", [paramref "j"])])) (const _T))]); (eqn (var (global "x")) (const (boolc false)))]); (eqn (var (arr [("n", [paramref "k"])])) (const _T))]))) in
  prop name params formula

let properties = [n_coherence]


let protocol = {
  name = "n_mutualEx1";
  types;
  vardefs;
  init;
  rules;
  properties;
}

	
let n_test1 =
  let name = "n_test1" in
  let params = [] in
  let formula = (imply (eqn (var (arr [("n_a", [paramfix "i" "client" (Intc 1)])])) (const _C)) 
  (neg (eqn (var (arr [("n_a", [paramfix "j" "client" (Intc 2)])])) (const _C)))) in
  prop name params formula
  
(*let n_test1 =
  let name = "n_test1" in
  let params = [] in
  let formula = (imply (eqn (var (arr [("n", [paramfix "i" "client" (Intc 1)])])) (const _C)) 
  (neg (eqn (var (arr [("n", [paramfix "j" "client" (Intc 2)])])) (const _C)))) in
  prop name params formula  *)

let properties = [  n_test1]
	
let invStr="(n_a[1] = C -> n_a[2] = C)"	
let prog ()=	
	let localhost="127.0.0.1" in
	
  let protocol = preprocess_rule_guard ~loach:protocol in
  let a=CheckInv.startServer ~murphi:(In_channel.read_all "a_mutualEx.m")
    ~smv:(In_channel.read_all "mutualEx.smv") "a_mutualEx"  "mutualEx" 
    localhost localhost "n_mutualEx1" protocol in
  (*let b=CheckInv.checkInv invStr in
  let c=CheckInv.checkProps types  properties in*)
	 
	let formula = Loach.Trans.trans_formula ~types ( (imply (eqn (var (arr [("n", [paramfix "i" "client" (Intc 1)])])) (const _C)) 
  (neg (eqn (var (arr [("n", [paramfix "j" "client" (Intc 2)])])) (const _C))))) in
	let tab=ToStr.Variable.genVarName2VarMap formula in
	let (b,ce)=Smt.chkWithCe (ToStr.AnotherSmt2.form_of formula) tab in 
	let Some(ce)=ce in
	let ()=print_endline (String.concat ~sep:"\n" (List.map ~f:ToStr.Smv.form_act ce)) in
  ()
  
let ()= run_with_cmdline  prog
    
