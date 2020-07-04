
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
  let statement = (parallel [(assign (global "auxDATA") (param (paramref "data"))); (assign (record [arr [("n", [paramref "i"])]; global "data"]) (param (paramref "data")))]) in
  rule name params formula statement

let n_ABS_Store_NODE_1 =
  let name = "n_ABS_Store_NODE_1" in
  let params = [paramdef "DATA_1" "DATA"] in
  let formula = (forallFormula [paramdef "NODE_2" "NODE"] (andList [(andList [(eqn (var (global "x")) (const (boolc false))); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _C)))]); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _E)))])) in
  let statement = (assign (global "auxDATA") (param (paramref "DATA_1"))) in
  rule name params formula statement

let n_ABS_Crit_NODE_1 =
  let name = "n_ABS_Crit_NODE_1" in
  let params = [] in
  let formula = (andList [(eqn (var (global "x")) (const (boolc true))); (forallFormula [paramdef "NODE_2" "NODE"] (andList [(andList [(andList [(andList [(eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _T)); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _I)))]); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _C)))]); (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "data"])) (var (global "auxDATA")))]); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _E)))]))]) in
  let statement = (assign (global "x") (const (boolc false))) in
  rule name params formula statement

let n_ABS_Idle_NODE_1 =
  let name = "n_ABS_Idle_NODE_1" in
  let params = [] in
  let formula = (forallFormula [paramdef "NODE_2" "NODE"] (andList [(andList [(eqn (var (global "x")) (const (boolc false))); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _C)))]); (neg (eqn (var (record [arr [("n", [paramref "NODE_2"])]; global "st"])) (const _E)))])) in
  let statement = (parallel [(assign (global "x") (const (boolc true))); (assign (global "memDATA") (var (global "auxDATA")))]) in
  rule name params formula statement

let rules = [n_Try; n_Crit; n_Exit; n_Idle; n_Store; n_ABS_Store_NODE_1; n_ABS_Crit_NODE_1; n_ABS_Idle_NODE_1]

let n_coherence =
  let name = "n_coherence" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_c51 =
  let name = "n_c51" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let n_rule_1 =
  let name = "n_rule_1" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_rule_2 =
  let name = "n_rule_2" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (andList [(eqn (var (global "x")) (const (boolc true))); (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))]) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I))))) in
  prop name params formula

let n_rule_3 =
  let name = "n_rule_3" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_rule_4 =
  let name = "n_rule_4" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (andList [(eqn (var (global "x")) (const (boolc true))); (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))]) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA"))))) in
  prop name params formula

let n_rule_5 =
  let name = "n_rule_5" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_rule_6 =
  let name = "n_rule_6" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_rule_7 =
  let name = "n_rule_7" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))))) in
  prop name params formula

let n_rule_8 =
  let name = "n_rule_8" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_rule_9 =
  let name = "n_rule_9" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (andList [(eqn (var (global "x")) (const (boolc true))); (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))]) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E))))) in
  prop name params formula

let n_rule_10 =
  let name = "n_rule_10" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA"))))) in
  prop name params formula

let n_rule_11 =
  let name = "n_rule_11" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (eqn (var (global "x")) (const (boolc false)))) in
  prop name params formula

let n_rule_12 =
  let name = "n_rule_12" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_rule_13 =
  let name = "n_rule_13" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (eqn (var (global "x")) (const (boolc false)))) in
  prop name params formula

let n_rule_14 =
  let name = "n_rule_14" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)))) in
  prop name params formula

let n_rule_15 =
  let name = "n_rule_15" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I)) (eqn (var (global "x")) (const (boolc true)))) in
  prop name params formula

let n_rule_16 =
  let name = "n_rule_16" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (andList [(eqn (var (global "x")) (const (boolc true))); (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))]) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_rule_17 =
  let name = "n_rule_17" in
  let params = [paramdef "j" "NODE"] in
  let formula = (imply (eqn (var (global "x")) (const (boolc true))) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _C)))) in
  prop name params formula

let n_rule_18 =
  let name = "n_rule_18" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_rule_19 =
  let name = "n_rule_19" in
  let params = [paramdef "j" "NODE"] in
  let formula = (imply (eqn (var (global "x")) (const (boolc true))) (neg (eqn (var (record [arr [("n", [paramref "j"])]; global "st"])) (const _E)))) in
  prop name params formula

let n_rule_20 =
  let name = "n_rule_20" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C))))) in
  prop name params formula

let n_rule_21 =
  let name = "n_rule_21" in
  let params = [paramdef "i" "NODE"] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _E)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let n_rule_22 =
  let name = "n_rule_22" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (andList [(eqn (var (global "x")) (const (boolc true))); (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T))]) (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)))) in
  prop name params formula

let n_rule_23 =
  let name = "n_rule_23" in
  let params = [paramdef "i" "NODE"; paramdef "j" "NODE"] in
  let formula = (imply (neg (eqn (param (paramref "i")) (param (paramref "j")))) (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _T)) (neg (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _I))))) in
  prop name params formula

let n_c51 =
  let name = "n_c51" in
  let params = [] in
  let formula = (imply (eqn (var (record [arr [("n", [paramref "i"])]; global "st"])) (const _C)) (eqn (var (record [arr [("n", [paramref "i"])]; global "data"])) (var (global "auxDATA")))) in
  prop name params formula

let properties = [n_coherence; n_c51; n_rule_1; n_rule_2; n_rule_3; n_rule_4; n_rule_5; n_rule_6; n_rule_7; n_rule_8; n_rule_9; n_rule_10; n_rule_11; n_rule_12; n_rule_13; n_rule_14; n_rule_15; n_rule_16; n_rule_17; n_rule_18; n_rule_19; n_rule_20; n_rule_21; n_rule_22; n_rule_23; n_c51]


let protocol = {
  name = "n_ABS_mutdata_1";
  types;
  vardefs;
  init;
  rules;
  properties;
}

let () = run_with_cmdline (fun () ->
  let protocol = preprocess_rule_guard ~loach:protocol in
  let cinvs_with_varnames, relations = anotherFind protocol
    ~murphi:(In_channel.read_all "n_ABS_mutdata_1.m")
  in
  Isabelle.protocol_act protocol cinvs_with_varnames relations ()
)

