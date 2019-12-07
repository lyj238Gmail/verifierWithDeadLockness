
(* This program is translated from its corresponding murphi version *)

open Core.Std
open Utils
open Paramecium
open Loach
open Formula
open InvFinder
open Cmdline

let _CACHE_I = strc "CACHE_I"
let _CACHE_S = strc "CACHE_S"
let _CACHE_E = strc "CACHE_E"
let _NODE_None = strc "NODE_None"
let _NODE_Get = strc "NODE_Get"
let _NODE_GetX = strc "NODE_GetX"
let _UNI_None = strc "UNI_None"
let _UNI_Get = strc "UNI_Get"
let _UNI_GetX = strc "UNI_GetX"
let _UNI_Put = strc "UNI_Put"
let _UNI_PutX = strc "UNI_PutX"
let _UNI_Nak = strc "UNI_Nak"
let _INV_None = strc "INV_None"
let _INV_Inv = strc "INV_Inv"
let _INV_InvAck = strc "INV_InvAck"
let _RP_None = strc "RP_None"
let _RP_Replace = strc "RP_Replace"
let _WB_None = strc "WB_None"
let _WB_Wb = strc "WB_Wb"
let _SHWB_None = strc "SHWB_None"
let _SHWB_ShWb = strc "SHWB_ShWb"
let _SHWB_FAck = strc "SHWB_FAck"
let _NAKC_None = strc "NAKC_None"
let _NAKC_Nakc = strc "NAKC_Nakc"
let _True = boolc true
let _False = boolc false

let types = [
  enum "CACHE_STATE" [_CACHE_I; _CACHE_S; _CACHE_E];
  enum "NODE_CMD" [_NODE_None; _NODE_Get; _NODE_GetX];
  enum "UNI_CMD" [_UNI_None; _UNI_Get; _UNI_GetX; _UNI_Put; _UNI_PutX; _UNI_Nak];
  enum "INV_CMD" [_INV_None; _INV_Inv; _INV_InvAck];
  enum "RP_CMD" [_RP_None; _RP_Replace];
  enum "WB_CMD" [_WB_None; _WB_Wb];
  enum "SHWB_CMD" [_SHWB_None; _SHWB_ShWb; _SHWB_FAck];
  enum "NAKC_CMD" [_NAKC_None; _NAKC_Nakc];
  enum "NODE" (int_consts [1; 2; ]);
  enum "DATA" (int_consts [1; ]);
  enum "boolean" [_True; _False];
]

let _NODE_STATE = List.concat [
  [arrdef [("ProcCmd", [])] "NODE_CMD"];
  [arrdef [("InvMarked", [])] "boolean"];
  [arrdef [("CacheState", [])] "CACHE_STATE"];
  [arrdef [("CacheData", [])] "DATA"]
]

let _DIR_STATE = List.concat [
  [arrdef [("Pending", [])] "boolean"];
  [arrdef [("Local", [])] "boolean"];
  [arrdef [("Dirty", [])] "boolean"];
  [arrdef [("HeadVld", [])] "boolean"];
  [arrdef [("HeadPtr", [])] "NODE"];
  [arrdef [("HomeHeadPtr", [])] "boolean"];
  [arrdef [("ShrVld", [])] "boolean"];
  [arrdef [("ShrSet", [paramdef "i0" "NODE"])] "boolean"];
  [arrdef [("HomeShrSet", [])] "boolean"];
  [arrdef [("InvSet", [paramdef "i1" "NODE"])] "boolean"];
  [arrdef [("HomeInvSet", [])] "boolean"]
]

let _UNI_MSG = List.concat [
  [arrdef [("Cmd", [])] "UNI_CMD"];
  [arrdef [("Proc", [])] "NODE"];
  [arrdef [("HomeProc", [])] "boolean"];
  [arrdef [("Data", [])] "DATA"]
]

let _INV_MSG = List.concat [
  [arrdef [("Cmd", [])] "INV_CMD"]
]

let _RP_MSG = List.concat [
  [arrdef [("Cmd", [])] "RP_CMD"]
]

let _WB_MSG = List.concat [
  [arrdef [("Cmd", [])] "WB_CMD"];
  [arrdef [("Proc", [])] "NODE"];
  [arrdef [("HomeProc", [])] "boolean"];
  [arrdef [("Data", [])] "DATA"]
]

let _SHWB_MSG = List.concat [
  [arrdef [("Cmd", [])] "SHWB_CMD"];
  [arrdef [("Proc", [])] "NODE"];
  [arrdef [("HomeProc", [])] "boolean"];
  [arrdef [("Data", [])] "DATA"]
]

let _NAKC_MSG = List.concat [
  [arrdef [("Cmd", [])] "NAKC_CMD"]
]

let _STATE = List.concat [
  record_def "Proc" [paramdef "i2" "NODE"] _NODE_STATE;
  record_def "HomeProc" [] _NODE_STATE;
  record_def "Dir" [] _DIR_STATE;
  [arrdef [("MemData", [])] "DATA"];
  record_def "UniMsg" [paramdef "i3" "NODE"] _UNI_MSG;
  record_def "HomeUniMsg" [] _UNI_MSG;
  record_def "InvMsg" [paramdef "i4" "NODE"] _INV_MSG;
  record_def "HomeInvMsg" [] _INV_MSG;
  record_def "RpMsg" [paramdef "i5" "NODE"] _RP_MSG;
  record_def "HomeRpMsg" [] _RP_MSG;
  record_def "WbMsg" [] _WB_MSG;
  record_def "ShWbMsg" [] _SHWB_MSG;
  record_def "NakcMsg" [] _NAKC_MSG;
  [arrdef [("CurrData", [])] "DATA"]
]

let vardefs = List.concat [
  record_def "Sta" [] _STATE
]

let init = (parallel [(assign (record [global "Sta"; global "MemData"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramfix "h" "NODE" (intc 1)))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (assign (record [global "Sta"; global "WbMsg"; global "Cmd"]) (const _WB_None)); (assign (record [global "Sta"; global "WbMsg"; global "Proc"]) (param (paramfix "h" "NODE" (intc 1)))); (assign (record [global "Sta"; global "WbMsg"; global "HomeProc"]) (const (boolc true))); (assign (record [global "Sta"; global "WbMsg"; global "Data"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "ShWbMsg"; global "Cmd"]) (const _SHWB_None)); (assign (record [global "Sta"; global "ShWbMsg"; global "Proc"]) (param (paramfix "h" "NODE" (intc 1)))); (assign (record [global "Sta"; global "ShWbMsg"; global "HomeProc"]) (const (boolc true))); (assign (record [global "Sta"; global "ShWbMsg"; global "Data"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_None)); (forStatement (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "CacheData"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "p"])]; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "p"])]; global "Proc"]) (param (paramfix "h" "NODE" (intc 1)))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "p"])]; global "HomeProc"]) (const (boolc true))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "p"])]; global "Data"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("RpMsg", [paramref "p"])]; global "Cmd"]) (const _RP_None))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Proc"]) (param (paramfix "h" "NODE" (intc 1)))); (assign (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"]) (const (boolc true))); (assign (record [global "Sta"; global "HomeUniMsg"; global "Data"]) (param (paramfix "d" "DATA" (intc 1)))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "HomeRpMsg"; global "Cmd"]) (const _RP_None)); (assign (record [global "Sta"; global "CurrData"]) (param (paramfix "d" "DATA" (intc 1))))])

let n_Store =
  let name = "n_Store" in
  let params = [paramdef "src" "NODE"; paramdef "data" "DATA"] in
  let formula = (eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheState"])) (const _CACHE_E)) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheData"]) (param (paramref "data"))); (assign (record [global "Sta"; global "CurrData"]) (param (paramref "data")))]) in
  rule name params formula statement

let n_Store_Home =
  let name = "n_Store_Home" in
  let params = [paramdef "data" "DATA"] in
  let formula = (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (param (paramref "data"))); (assign (record [global "Sta"; global "CurrData"]) (param (paramref "data")))]) in
  rule name params formula statement

let n_PI_Remote_Get =
  let name = "n_PI_Remote_Get" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheState"])) (const _CACHE_I))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "ProcCmd"]) (const _NODE_Get)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Get)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"]) (const (boolc true)))]) in
  rule name params formula statement

let n_PI_Remote_GetX =
  let name = "n_PI_Remote_GetX" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheState"])) (const _CACHE_I))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "ProcCmd"]) (const _NODE_GetX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_GetX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"]) (const (boolc true)))]) in
  rule name params formula statement

let n_PI_Remote_PutX =
  let name = "n_PI_Remote_PutX" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "WbMsg"; global "Cmd"]) (const _WB_Wb)); (assign (record [global "Sta"; global "WbMsg"; global "Proc"]) (param (paramref "dst"))); (assign (record [global "Sta"; global "WbMsg"; global "HomeProc"]) (const (boolc false))); (assign (record [global "Sta"; global "WbMsg"; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"])))]) in
  rule name params formula statement

let n_PI_Remote_Replace =
  let name = "n_PI_Remote_Replace" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheState"])) (const _CACHE_S))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "src"])]; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"]) (const _RP_Replace))]) in
  rule name params formula statement

let n_NI_Nak =
  let name = "n_NI_Nak" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"])) (const _UNI_Nak)) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "InvMarked"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_Local_Get_Nak =
  let name = "n_NI_Local_Get_Nak" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (neg (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)))]); (orList [(orList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True)); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)))])]); (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) in
  let statement = (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Nak)) in
  rule name params formula statement

let n_NI_Local_Get_Get =
  let name = "n_NI_Local_Get_Get" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (neg (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]); (orList [(neg (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _True))])]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Get)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"]) (var (record [global "Sta"; global "Dir"; global "HeadPtr"]))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"]) (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])))]) in
  rule name params formula statement

let n_NI_Local_Get_Put_Head =
  let name = "n_NI_Local_Get_Put_Head" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (neg (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "src"])]]) (const (boolc true))); (forStatement (ifelseStatement (eqn (param (paramref "p")) (param (paramref "src"))) (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))) (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])))) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (var (record [global "Sta"; global "Dir"; global "HomeShrSet"]))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Put)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_NI_Local_Get_Put =
  let name = "n_NI_Local_Get_Put" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (neg (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Put)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_NI_Local_Get_Put_Dirty =
  let name = "n_NI_Local_Get_Put_Dirty" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (neg (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "HomeProc"; global "CacheData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Put)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "HomeProc"; global "CacheData"])))]) in
  rule name params formula statement

let n_NI_Remote_Get_Nak =
  let name = "n_NI_Remote_Get_Nak" in
  let params = [paramdef "src" "NODE"; paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(neg (eqn (param (paramref "src")) (param (paramref "dst")))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _False))]); (neg (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E)))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Nak)); (assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_Nakc))]) in
  rule name params formula statement

let n_NI_Remote_Get_Nak_Home =
  let name = "n_NI_Remote_Get_Nak_Home" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"])) (const _False))]); (neg (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_Nak)); (assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_Nakc))]) in
  rule name params formula statement

let n_NI_Remote_Get_Put =
  let name = "n_NI_Remote_Get_Put" in
  let params = [paramdef "src" "NODE"; paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(neg (eqn (param (paramref "src")) (param (paramref "dst")))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _False))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Put)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"]))); (assign (record [global "Sta"; global "ShWbMsg"; global "Cmd"]) (const _SHWB_ShWb)); (assign (record [global "Sta"; global "ShWbMsg"; global "Proc"]) (param (paramref "src"))); (assign (record [global "Sta"; global "ShWbMsg"; global "HomeProc"]) (const (boolc false))); (assign (record [global "Sta"; global "ShWbMsg"; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"])))]) in
  rule name params formula statement

let n_NI_Remote_Get_Put_Home =
  let name = "n_NI_Remote_Get_Put_Home" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"])) (const _False))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_Put)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"])))]) in
  rule name params formula statement

let n_NI_Local_GetX_Nak =
  let name = "n_NI_Local_GetX_Nak" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (orList [(orList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True)); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)))])]); (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) in
  let statement = (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Nak)) in
  rule name params formula statement

let n_NI_Local_GetX_GetX =
  let name = "n_NI_Local_GetX_GetX" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]); (orList [(neg (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _True))])]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_GetX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"]) (var (record [global "Sta"; global "Dir"; global "HeadPtr"]))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"]) (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_1 =
  let name = "n_NI_Local_GetX_PutX_1" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc true)))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_2 =
  let name = "n_NI_Local_GetX_PutX_2" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_3 =
  let name = "n_NI_Local_GetX_PutX_3" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_4 =
  let name = "n_NI_Local_GetX_PutX_4" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (imply (neg (eqn (param (paramref "p")) (param (paramref "src")))) (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _False))))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc true)))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_5 =
  let name = "n_NI_Local_GetX_PutX_5" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (imply (neg (eqn (param (paramref "p")) (param (paramref "src")))) (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _False))))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_6 =
  let name = "n_NI_Local_GetX_PutX_6" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (imply (neg (eqn (param (paramref "p")) (param (paramref "src")))) (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _False))))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_7 =
  let name = "n_NI_Local_GetX_PutX_7" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (orList [(neg (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _True))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_7_NODE_Get =
  let name = "n_NI_Local_GetX_PutX_7_NODE_Get" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (orList [(neg (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _True))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc true)))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_8_Home =
  let name = "n_NI_Local_GetX_PutX_8_Home" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_8_Home_NODE_Get =
  let name = "n_NI_Local_GetX_PutX_8_Home_NODE_Get" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc true)))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_8 =
  let name = "n_NI_Local_GetX_PutX_8" in
  let params = [paramdef "src" "NODE"; paramdef "pp" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "pp"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (neg (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_8_NODE_Get =
  let name = "n_NI_Local_GetX_PutX_8_NODE_Get" in
  let params = [paramdef "src" "NODE"; paramdef "pp" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "pp"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc true)))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_9 =
  let name = "n_NI_Local_GetX_PutX_9" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (orList [(neg (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _True))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_10_Home =
  let name = "n_NI_Local_GetX_PutX_10_Home" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_10 =
  let name = "n_NI_Local_GetX_PutX_10" in
  let params = [paramdef "src" "NODE"; paramdef "pp" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "src")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "pp"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (andList [(neg (eqn (param (paramref "p")) (param (paramref "src")))); (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p")))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_NI_Local_GetX_PutX_11 =
  let name = "n_NI_Local_GetX_PutX_11" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (param (paramref "src"))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; global "HomeProc"; global "CacheData"]))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Remote_GetX_Nak =
  let name = "n_NI_Remote_GetX_Nak" in
  let params = [paramdef "src" "NODE"; paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(neg (eqn (param (paramref "src")) (param (paramref "dst")))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _False))]); (neg (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E)))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_Nak)); (assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_Nakc))]) in
  rule name params formula statement

let n_NI_Remote_GetX_Nak_Home =
  let name = "n_NI_Remote_GetX_Nak_Home" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"])) (const _False))]); (neg (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E)))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_Nak)); (assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_Nakc))]) in
  rule name params formula statement

let n_NI_Remote_GetX_PutX =
  let name = "n_NI_Remote_GetX_PutX" in
  let params = [paramdef "src" "NODE"; paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(neg (eqn (param (paramref "src")) (param (paramref "dst")))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "HomeProc"])) (const _False))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; arr [("UniMsg", [paramref "src"])]; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"]))); (assign (record [global "Sta"; global "ShWbMsg"; global "Cmd"]) (const _SHWB_FAck)); (assign (record [global "Sta"; global "ShWbMsg"; global "Proc"]) (param (paramref "src"))); (assign (record [global "Sta"; global "ShWbMsg"; global "HomeProc"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_Remote_GetX_PutX_Home =
  let name = "n_NI_Remote_GetX_PutX_Home" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (param (paramref "dst")))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"])) (const _False))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_PutX)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Data"]) (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"])))]) in
  rule name params formula statement

let n_NI_Remote_Put =
  let name = "n_NI_Remote_Put" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"])) (const _UNI_Put)) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"]) (const _NODE_None)); (ifelseStatement (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "InvMarked"])) (const _True)) (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_I))]) (parallel [(assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"]) (var (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Data"])))]))]) in
  rule name params formula statement

let n_NI_Remote_PutX =
  let name = "n_NI_Remote_PutX" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"])) (const _NODE_GetX))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_E)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheData"]) (var (record [global "Sta"; arr [("UniMsg", [paramref "dst"])]; global "Data"])))]) in
  rule name params formula statement

let n_NI_Inv =
  let name = "n_NI_Inv" in
  let params = [paramdef "dst" "NODE"] in
  let formula = (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "dst"])]; global "Cmd"])) (const _INV_Inv)) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "dst"])]; global "Cmd"]) (const _INV_InvAck)); (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "CacheState"]) (const _CACHE_I)); (ifStatement (eqn (var (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "ProcCmd"])) (const _NODE_Get)) (assign (record [global "Sta"; arr [("Proc", [paramref "dst"])]; global "InvMarked"]) (const (boolc true))))]) in
  rule name params formula statement

let n_NI_InvAck_exists_Home =
  let name = "n_NI_InvAck_exists_Home" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeInvSet"])) (const _True))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_InvAck_exists =
  let name = "n_NI_InvAck_exists" in
  let params = [paramdef "src" "NODE"; paramdef "pp" "NODE"] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]])) (const _True))]); (andList [(neg (eqn (param (paramref "pp")) (param (paramref "src")))); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "pp"])]])) (const _True))])]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_InvAck_1 =
  let name = "n_NI_InvAck_1" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeInvSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (orList [(eqn (param (paramref "p")) (param (paramref "src"))); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]])) (const _False))]))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_InvAck_2 =
  let name = "n_NI_InvAck_2" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeInvSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (orList [(eqn (param (paramref "p")) (param (paramref "src"))); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]])) (const _False))]))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_InvAck_3 =
  let name = "n_NI_InvAck_3" in
  let params = [paramdef "src" "NODE"] in
  let formula = (andList [(andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]); (eqn (var (record [global "Sta"; global "Dir"; global "HomeInvSet"])) (const _False))]); (forallFormula [paramdef "p" "NODE"] (orList [(eqn (param (paramref "p")) (param (paramref "src"))); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]])) (const _False))]))]) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("InvMsg", [paramref "src"])]; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_Replace =
  let name = "n_NI_Replace" in
  let params = [paramdef "src" "NODE"] in
  let formula = (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"])) (const _RP_Replace)) in
  let statement = (parallel [(assign (record [global "Sta"; arr [("RpMsg", [paramref "src"])]; global "Cmd"]) (const _RP_None)); (ifStatement (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "src"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "src"])]]) (const (boolc false)))]))]) in
  rule name params formula statement

let n_PI_Local_Get_Get =
  let name = "n_PI_Local_Get_Get" in
  let params = [] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_Get)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_Get)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Proc"]) (var (record [global "Sta"; global "Dir"; global "HeadPtr"]))); (assign (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"]) (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])))]) in
  rule name params formula statement

let n_PI_Local_Get_Put =
  let name = "n_PI_Local_Get_Put" in
  let params = [] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc true))); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (ifelseStatement (eqn (var (record [global "Sta"; global "HomeProc"; global "InvMarked"])) (const _True)) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (var (record [global "Sta"; global "MemData"])))]))]) in
  rule name params formula statement

let n_PI_Local_GetX_GetX =
  let name = "n_PI_Local_GetX_GetX" in
  let params = [] in
  let formula = (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (orList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_GetX)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_GetX)); (assign (record [global "Sta"; global "HomeUniMsg"; global "Proc"]) (var (record [global "Sta"; global "Dir"; global "HeadPtr"]))); (assign (record [global "Sta"; global "HomeUniMsg"; global "HomeProc"]) (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])))]) in
  rule name params formula statement

let n_PI_Local_GetX_PutX_HeadVld =
  let name = "n_PI_Local_GetX_PutX_HeadVld" in
  let params = [] in
  let formula = (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (orList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _True))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc false))); (forStatement (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (ifelseStatement (orList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]); (andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (param (paramref "p"))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const _False))])]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_Inv))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; arr [("InvMsg", [paramref "p"])]; global "Cmd"]) (const _INV_None))]))]) [paramdef "p" "NODE"]); (assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeInvMsg"; global "Cmd"]) (const _INV_None)); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_E)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_PI_Local_GetX_PutX =
  let name = "n_PI_Local_GetX_PutX" in
  let params = [] in
  let formula = (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (orList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const _False))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc true))); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_E)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (var (record [global "Sta"; global "MemData"])))]) in
  rule name params formula statement

let n_PI_Local_PutX =
  let name = "n_PI_Local_PutX" in
  let params = [] in
  let formula = (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]) in
  let statement = (ifelseStatement (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const _True)) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "HomeProc"; global "CacheData"])))]) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I)); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "HomeProc"; global "CacheData"])))])) in
  rule name params formula statement

let n_PI_Local_Replace =
  let name = "n_PI_Local_Replace" in
  let params = [] in
  let formula = (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))]) in
  let statement = (parallel [(assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) in
  rule name params formula statement

let n_NI_Nak_Home =
  let name = "n_NI_Nak_Home" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Nak)) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_Nak_Clear =
  let name = "n_NI_Nak_Clear" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)) in
  let statement = (parallel [(assign (record [global "Sta"; global "NakcMsg"; global "Cmd"]) (const _NAKC_None)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false)))]) in
  rule name params formula statement

let n_NI_Local_Put =
  let name = "n_NI_Local_Put" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put)) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc true))); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "HomeUniMsg"; global "Data"]))); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (ifelseStatement (eqn (var (record [global "Sta"; global "HomeProc"; global "InvMarked"])) (const _True)) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_I))]) (parallel [(assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_S)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (var (record [global "Sta"; global "HomeUniMsg"; global "Data"])))]))]) in
  rule name params formula statement

let n_NI_Local_PutXAcksDone =
  let name = "n_NI_Local_PutXAcksDone" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX)) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeUniMsg"; global "Cmd"]) (const _UNI_None)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Local"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "ProcCmd"]) (const _NODE_None)); (assign (record [global "Sta"; global "HomeProc"; global "InvMarked"]) (const (boolc false))); (assign (record [global "Sta"; global "HomeProc"; global "CacheState"]) (const _CACHE_E)); (assign (record [global "Sta"; global "HomeProc"; global "CacheData"]) (var (record [global "Sta"; global "HomeUniMsg"; global "Data"])))]) in
  rule name params formula statement

let n_NI_Wb =
  let name = "n_NI_Wb" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb)) in
  let statement = (parallel [(assign (record [global "Sta"; global "WbMsg"; global "Cmd"]) (const _WB_None)); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HeadVld"]) (const (boolc false))); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "WbMsg"; global "Data"])))]) in
  rule name params formula statement

let n_NI_FAck =
  let name = "n_NI_FAck" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)) in
  let statement = (parallel [(assign (record [global "Sta"; global "ShWbMsg"; global "Cmd"]) (const _SHWB_None)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (ifStatement (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const _True)) (parallel [(assign (record [global "Sta"; global "Dir"; global "HeadPtr"]) (var (record [global "Sta"; global "ShWbMsg"; global "Proc"]))); (assign (record [global "Sta"; global "Dir"; global "HomeHeadPtr"]) (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])))]))]) in
  rule name params formula statement

let n_NI_ShWb =
  let name = "n_NI_ShWb" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)) in
  let statement = (parallel [(assign (record [global "Sta"; global "ShWbMsg"; global "Cmd"]) (const _SHWB_None)); (assign (record [global "Sta"; global "Dir"; global "Pending"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "Dirty"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "ShrVld"]) (const (boolc true))); (forStatement (ifelseStatement (orList [(andList [(eqn (param (paramref "p")) (var (record [global "Sta"; global "ShWbMsg"; global "Proc"]))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])) (const _False))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]])) (const _True))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc true)))]) (parallel [(assign (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p"])]]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p"])]]) (const (boolc false)))])) [paramdef "p" "NODE"]); (ifelseStatement (orList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])) (const _True)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const _True))]) (parallel [(assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc true))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc true)))]) (parallel [(assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false)))])); (assign (record [global "Sta"; global "MemData"]) (var (record [global "Sta"; global "ShWbMsg"; global "Data"])))]) in
  rule name params formula statement

let n_NI_Replace_Home =
  let name = "n_NI_Replace_Home" in
  let params = [] in
  let formula = (eqn (var (record [global "Sta"; global "HomeRpMsg"; global "Cmd"])) (const _RP_Replace)) in
  let statement = (parallel [(assign (record [global "Sta"; global "HomeRpMsg"; global "Cmd"]) (const _RP_None)); (ifStatement (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const _True)) (parallel [(assign (record [global "Sta"; global "Dir"; global "HomeShrSet"]) (const (boolc false))); (assign (record [global "Sta"; global "Dir"; global "HomeInvSet"]) (const (boolc false)))]))]) in
  rule name params formula statement

let rules = [n_Store; n_Store_Home; n_PI_Remote_Get; n_PI_Remote_GetX; n_PI_Remote_PutX; n_PI_Remote_Replace; n_NI_Nak; n_NI_Local_Get_Nak; n_NI_Local_Get_Get; n_NI_Local_Get_Put_Head; n_NI_Local_Get_Put; n_NI_Local_Get_Put_Dirty; n_NI_Remote_Get_Nak; n_NI_Remote_Get_Nak_Home; n_NI_Remote_Get_Put; n_NI_Remote_Get_Put_Home; n_NI_Local_GetX_Nak; n_NI_Local_GetX_GetX; n_NI_Local_GetX_PutX_1; n_NI_Local_GetX_PutX_2; n_NI_Local_GetX_PutX_3; n_NI_Local_GetX_PutX_4; n_NI_Local_GetX_PutX_5; n_NI_Local_GetX_PutX_6; n_NI_Local_GetX_PutX_7; n_NI_Local_GetX_PutX_7_NODE_Get; n_NI_Local_GetX_PutX_8_Home; n_NI_Local_GetX_PutX_8_Home_NODE_Get; n_NI_Local_GetX_PutX_8; n_NI_Local_GetX_PutX_8_NODE_Get; n_NI_Local_GetX_PutX_9; n_NI_Local_GetX_PutX_10_Home; n_NI_Local_GetX_PutX_10; n_NI_Local_GetX_PutX_11; n_NI_Remote_GetX_Nak; n_NI_Remote_GetX_Nak_Home; n_NI_Remote_GetX_PutX; n_NI_Remote_GetX_PutX_Home; n_NI_Remote_Put; n_NI_Remote_PutX; n_NI_Inv; n_NI_InvAck_exists_Home; n_NI_InvAck_exists; n_NI_InvAck_1; n_NI_InvAck_2; n_NI_InvAck_3; n_NI_Replace; n_PI_Local_Get_Get; n_PI_Local_Get_Put; n_PI_Local_GetX_GetX; n_PI_Local_GetX_PutX_HeadVld; n_PI_Local_GetX_PutX; n_PI_Local_PutX; n_PI_Local_Replace; n_NI_Nak_Home; n_NI_Nak_Clear; n_NI_Local_Put; n_NI_Local_PutXAcksDone; n_NI_Wb; n_NI_FAck; n_NI_ShWb; n_NI_Replace_Home]

let n_inv_3 =
  let name = "n_inv_3" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_4 =
  let name = "n_inv_4" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_5 =
  let name = "n_inv_5" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_6 =
  let name = "n_inv_6" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_7 =
  let name = "n_inv_7" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_8 =
  let name = "n_inv_8" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_9 =
  let name = "n_inv_9" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_10 =
  let name = "n_inv_10" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_11 =
  let name = "n_inv_11" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_13 =
  let name = "n_inv_13" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_14 =
  let name = "n_inv_14" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_15 =
  let name = "n_inv_15" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_16 =
  let name = "n_inv_16" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_17 =
  let name = "n_inv_17" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_18 =
  let name = "n_inv_18" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_19 =
  let name = "n_inv_19" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_22 =
  let name = "n_inv_22" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_23 =
  let name = "n_inv_23" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_24 =
  let name = "n_inv_24" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_25 =
  let name = "n_inv_25" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_26 =
  let name = "n_inv_26" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_27 =
  let name = "n_inv_27" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_28 =
  let name = "n_inv_28" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_30 =
  let name = "n_inv_30" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_31 =
  let name = "n_inv_31" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_32 =
  let name = "n_inv_32" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_33 =
  let name = "n_inv_33" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_34 =
  let name = "n_inv_34" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_35 =
  let name = "n_inv_35" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Proc"])) (const (intc 1))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_36 =
  let name = "n_inv_36" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_37 =
  let name = "n_inv_37" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_40 =
  let name = "n_inv_40" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_41 =
  let name = "n_inv_41" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_42 =
  let name = "n_inv_42" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_45 =
  let name = "n_inv_45" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_47 =
  let name = "n_inv_47" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_48 =
  let name = "n_inv_48" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_49 =
  let name = "n_inv_49" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_51 =
  let name = "n_inv_51" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_53 =
  let name = "n_inv_53" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_54 =
  let name = "n_inv_54" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_56 =
  let name = "n_inv_56" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_59 =
  let name = "n_inv_59" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_60 =
  let name = "n_inv_60" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_61 =
  let name = "n_inv_61" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_62 =
  let name = "n_inv_62" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_63 =
  let name = "n_inv_63" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_64 =
  let name = "n_inv_64" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_65 =
  let name = "n_inv_65" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_66 =
  let name = "n_inv_66" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_67 =
  let name = "n_inv_67" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_71 =
  let name = "n_inv_71" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_72 =
  let name = "n_inv_72" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_73 =
  let name = "n_inv_73" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_76 =
  let name = "n_inv_76" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_80 =
  let name = "n_inv_80" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_84 =
  let name = "n_inv_84" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_85 =
  let name = "n_inv_85" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_86 =
  let name = "n_inv_86" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_90 =
  let name = "n_inv_90" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_91 =
  let name = "n_inv_91" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_92 =
  let name = "n_inv_92" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_93 =
  let name = "n_inv_93" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_94 =
  let name = "n_inv_94" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_95 =
  let name = "n_inv_95" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_96 =
  let name = "n_inv_96" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_97 =
  let name = "n_inv_97" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_98 =
  let name = "n_inv_98" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_102 =
  let name = "n_inv_102" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_104 =
  let name = "n_inv_104" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_106 =
  let name = "n_inv_106" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_107 =
  let name = "n_inv_107" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_108 =
  let name = "n_inv_108" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_110 =
  let name = "n_inv_110" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_112 =
  let name = "n_inv_112" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_113 =
  let name = "n_inv_113" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_114 =
  let name = "n_inv_114" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_115 =
  let name = "n_inv_115" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_116 =
  let name = "n_inv_116" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_118 =
  let name = "n_inv_118" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_119 =
  let name = "n_inv_119" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_120 =
  let name = "n_inv_120" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_121 =
  let name = "n_inv_121" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_122 =
  let name = "n_inv_122" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_123 =
  let name = "n_inv_123" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_124 =
  let name = "n_inv_124" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_125 =
  let name = "n_inv_125" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_126 =
  let name = "n_inv_126" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_127 =
  let name = "n_inv_127" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_128 =
  let name = "n_inv_128" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_129 =
  let name = "n_inv_129" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_136 =
  let name = "n_inv_136" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_140 =
  let name = "n_inv_140" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_141 =
  let name = "n_inv_141" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_142 =
  let name = "n_inv_142" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_145 =
  let name = "n_inv_145" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_146 =
  let name = "n_inv_146" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_147 =
  let name = "n_inv_147" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_148 =
  let name = "n_inv_148" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_149 =
  let name = "n_inv_149" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_150 =
  let name = "n_inv_150" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_151 =
  let name = "n_inv_151" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_152 =
  let name = "n_inv_152" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_153 =
  let name = "n_inv_153" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_154 =
  let name = "n_inv_154" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_155 =
  let name = "n_inv_155" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_156 =
  let name = "n_inv_156" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_GetX))])) in
  prop name params formula

let n_inv_157 =
  let name = "n_inv_157" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None))])) in
  prop name params formula

let n_inv_158 =
  let name = "n_inv_158" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_159 =
  let name = "n_inv_159" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_160 =
  let name = "n_inv_160" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_161 =
  let name = "n_inv_161" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_162 =
  let name = "n_inv_162" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_163 =
  let name = "n_inv_163" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_164 =
  let name = "n_inv_164" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_165 =
  let name = "n_inv_165" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_171 =
  let name = "n_inv_171" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_173 =
  let name = "n_inv_173" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_174 =
  let name = "n_inv_174" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_175 =
  let name = "n_inv_175" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_176 =
  let name = "n_inv_176" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_177 =
  let name = "n_inv_177" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_178 =
  let name = "n_inv_178" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_179 =
  let name = "n_inv_179" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_182 =
  let name = "n_inv_182" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_184 =
  let name = "n_inv_184" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_185 =
  let name = "n_inv_185" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_186 =
  let name = "n_inv_186" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_187 =
  let name = "n_inv_187" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_188 =
  let name = "n_inv_188" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv))])) in
  prop name params formula

let n_inv_189 =
  let name = "n_inv_189" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_190 =
  let name = "n_inv_190" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_191 =
  let name = "n_inv_191" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_192 =
  let name = "n_inv_192" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_193 =
  let name = "n_inv_193" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_194 =
  let name = "n_inv_194" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_195 =
  let name = "n_inv_195" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_196 =
  let name = "n_inv_196" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_197 =
  let name = "n_inv_197" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_199 =
  let name = "n_inv_199" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_200 =
  let name = "n_inv_200" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_201 =
  let name = "n_inv_201" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_202 =
  let name = "n_inv_202" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_203 =
  let name = "n_inv_203" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_204 =
  let name = "n_inv_204" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_205 =
  let name = "n_inv_205" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_206 =
  let name = "n_inv_206" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_207 =
  let name = "n_inv_207" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_208 =
  let name = "n_inv_208" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_209 =
  let name = "n_inv_209" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_210 =
  let name = "n_inv_210" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_211 =
  let name = "n_inv_211" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_212 =
  let name = "n_inv_212" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_213 =
  let name = "n_inv_213" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_214 =
  let name = "n_inv_214" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_215 =
  let name = "n_inv_215" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_216 =
  let name = "n_inv_216" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_218 =
  let name = "n_inv_218" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_220 =
  let name = "n_inv_220" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_221 =
  let name = "n_inv_221" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_224 =
  let name = "n_inv_224" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_225 =
  let name = "n_inv_225" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_226 =
  let name = "n_inv_226" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_227 =
  let name = "n_inv_227" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_228 =
  let name = "n_inv_228" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_229 =
  let name = "n_inv_229" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_231 =
  let name = "n_inv_231" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_233 =
  let name = "n_inv_233" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_234 =
  let name = "n_inv_234" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_235 =
  let name = "n_inv_235" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_236 =
  let name = "n_inv_236" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_237 =
  let name = "n_inv_237" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_239 =
  let name = "n_inv_239" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_240 =
  let name = "n_inv_240" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_241 =
  let name = "n_inv_241" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_242 =
  let name = "n_inv_242" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_243 =
  let name = "n_inv_243" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_244 =
  let name = "n_inv_244" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_245 =
  let name = "n_inv_245" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_246 =
  let name = "n_inv_246" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_247 =
  let name = "n_inv_247" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_248 =
  let name = "n_inv_248" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv1"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_249 =
  let name = "n_inv_249" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_250 =
  let name = "n_inv_250" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_251 =
  let name = "n_inv_251" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_252 =
  let name = "n_inv_252" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_253 =
  let name = "n_inv_253" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_254 =
  let name = "n_inv_254" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_255 =
  let name = "n_inv_255" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_256 =
  let name = "n_inv_256" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_257 =
  let name = "n_inv_257" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_258 =
  let name = "n_inv_258" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_259 =
  let name = "n_inv_259" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_260 =
  let name = "n_inv_260" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_261 =
  let name = "n_inv_261" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_262 =
  let name = "n_inv_262" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_263 =
  let name = "n_inv_263" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_264 =
  let name = "n_inv_264" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_265 =
  let name = "n_inv_265" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv1"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_266 =
  let name = "n_inv_266" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_I)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_268 =
  let name = "n_inv_268" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_269 =
  let name = "n_inv_269" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_270 =
  let name = "n_inv_270" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_271 =
  let name = "n_inv_271" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_272 =
  let name = "n_inv_272" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_273 =
  let name = "n_inv_273" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_274 =
  let name = "n_inv_274" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_275 =
  let name = "n_inv_275" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_276 =
  let name = "n_inv_276" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_277 =
  let name = "n_inv_277" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_278 =
  let name = "n_inv_278" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_279 =
  let name = "n_inv_279" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_280 =
  let name = "n_inv_280" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_281 =
  let name = "n_inv_281" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_282 =
  let name = "n_inv_282" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_283 =
  let name = "n_inv_283" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_284 =
  let name = "n_inv_284" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_285 =
  let name = "n_inv_285" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_286 =
  let name = "n_inv_286" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_287 =
  let name = "n_inv_287" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_288 =
  let name = "n_inv_288" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_289 =
  let name = "n_inv_289" in
  let params = [paramdef "p__Inv0" "NODE"] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_290 =
  let name = "n_inv_290" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_291 =
  let name = "n_inv_291" in
  let params = [paramdef "p__Inv0" "NODE"; paramdef "p__Inv1" "NODE"] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_CacheStateProp =
  let name = "n_CacheStateProp" in
  let params = [] in
  let formula = (forallFormula [paramdef "p" "NODE"] (forallFormula [paramdef "q" "NODE"] (imply (neg (eqn (param (paramref "p")) (param (paramref "q")))) (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "q"])]; global "CacheState"])) (const _CACHE_E))]))))) in
  prop name params formula

let n_CacheStatePropHome =
  let name = "n_CacheStatePropHome" in
  let params = [] in
  let formula = (forallFormula [paramdef "p" "NODE"] (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]))) in
  prop name params formula

let n_inv_3 =
  let name = "n_inv_3" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_4 =
  let name = "n_inv_4" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_5 =
  let name = "n_inv_5" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_6 =
  let name = "n_inv_6" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_7 =
  let name = "n_inv_7" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_8 =
  let name = "n_inv_8" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_9 =
  let name = "n_inv_9" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_10 =
  let name = "n_inv_10" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_11 =
  let name = "n_inv_11" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_12 =
  let name = "n_inv_12" in
  let params = [] in
  let formula = (neg (eqn (var (record [global "Sta"; global "Dir"; global "HomeShrSet"])) (const (boolc true)))) in
  prop name params formula

let n_inv_13 =
  let name = "n_inv_13" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_14 =
  let name = "n_inv_14" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_15 =
  let name = "n_inv_15" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_16 =
  let name = "n_inv_16" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_17 =
  let name = "n_inv_17" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_18 =
  let name = "n_inv_18" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_19 =
  let name = "n_inv_19" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_20 =
  let name = "n_inv_20" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_22 =
  let name = "n_inv_22" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_23 =
  let name = "n_inv_23" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_24 =
  let name = "n_inv_24" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_25 =
  let name = "n_inv_25" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_26 =
  let name = "n_inv_26" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_27 =
  let name = "n_inv_27" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_28 =
  let name = "n_inv_28" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_29 =
  let name = "n_inv_29" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_30 =
  let name = "n_inv_30" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_31 =
  let name = "n_inv_31" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_32 =
  let name = "n_inv_32" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_33 =
  let name = "n_inv_33" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_34 =
  let name = "n_inv_34" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_35 =
  let name = "n_inv_35" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Proc"])) (const (intc 1))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_36 =
  let name = "n_inv_36" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_37 =
  let name = "n_inv_37" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_38 =
  let name = "n_inv_38" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_40 =
  let name = "n_inv_40" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_41 =
  let name = "n_inv_41" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_42 =
  let name = "n_inv_42" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_43 =
  let name = "n_inv_43" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_45 =
  let name = "n_inv_45" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_46 =
  let name = "n_inv_46" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_47 =
  let name = "n_inv_47" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_48 =
  let name = "n_inv_48" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_49 =
  let name = "n_inv_49" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_50 =
  let name = "n_inv_50" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_51 =
  let name = "n_inv_51" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_52 =
  let name = "n_inv_52" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_53 =
  let name = "n_inv_53" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_54 =
  let name = "n_inv_54" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_55 =
  let name = "n_inv_55" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_56 =
  let name = "n_inv_56" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_57 =
  let name = "n_inv_57" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeProc"; global "ProcCmd"])) (const _NODE_Get))])) in
  prop name params formula

let n_inv_59 =
  let name = "n_inv_59" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_60 =
  let name = "n_inv_60" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_61 =
  let name = "n_inv_61" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_62 =
  let name = "n_inv_62" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_63 =
  let name = "n_inv_63" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_64 =
  let name = "n_inv_64" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_65 =
  let name = "n_inv_65" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_66 =
  let name = "n_inv_66" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_67 =
  let name = "n_inv_67" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_68 =
  let name = "n_inv_68" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_70 =
  let name = "n_inv_70" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_71 =
  let name = "n_inv_71" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_72 =
  let name = "n_inv_72" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_73 =
  let name = "n_inv_73" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_74 =
  let name = "n_inv_74" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_76 =
  let name = "n_inv_76" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_77 =
  let name = "n_inv_77" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_79 =
  let name = "n_inv_79" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_80 =
  let name = "n_inv_80" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_81 =
  let name = "n_inv_81" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_83 =
  let name = "n_inv_83" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_84 =
  let name = "n_inv_84" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_85 =
  let name = "n_inv_85" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_86 =
  let name = "n_inv_86" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_87 =
  let name = "n_inv_87" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_89 =
  let name = "n_inv_89" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_90 =
  let name = "n_inv_90" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_91 =
  let name = "n_inv_91" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_92 =
  let name = "n_inv_92" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_93 =
  let name = "n_inv_93" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_94 =
  let name = "n_inv_94" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_95 =
  let name = "n_inv_95" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_96 =
  let name = "n_inv_96" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_97 =
  let name = "n_inv_97" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_98 =
  let name = "n_inv_98" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_99 =
  let name = "n_inv_99" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_101 =
  let name = "n_inv_101" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_102 =
  let name = "n_inv_102" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_103 =
  let name = "n_inv_103" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I))])) in
  prop name params formula

let n_inv_104 =
  let name = "n_inv_104" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_105 =
  let name = "n_inv_105" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_106 =
  let name = "n_inv_106" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_107 =
  let name = "n_inv_107" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_108 =
  let name = "n_inv_108" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_109 =
  let name = "n_inv_109" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_110 =
  let name = "n_inv_110" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_111 =
  let name = "n_inv_111" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_112 =
  let name = "n_inv_112" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_113 =
  let name = "n_inv_113" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_114 =
  let name = "n_inv_114" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_115 =
  let name = "n_inv_115" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_116 =
  let name = "n_inv_116" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_117 =
  let name = "n_inv_117" in
  let params = [] in
  let formula = (neg (eqn (var (record [global "Sta"; global "Dir"; global "HomeInvSet"])) (const (boolc true)))) in
  prop name params formula

let n_inv_118 =
  let name = "n_inv_118" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_119 =
  let name = "n_inv_119" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_120 =
  let name = "n_inv_120" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_121 =
  let name = "n_inv_121" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_122 =
  let name = "n_inv_122" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_123 =
  let name = "n_inv_123" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_124 =
  let name = "n_inv_124" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_125 =
  let name = "n_inv_125" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_126 =
  let name = "n_inv_126" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_127 =
  let name = "n_inv_127" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_128 =
  let name = "n_inv_128" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_129 =
  let name = "n_inv_129" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_130 =
  let name = "n_inv_130" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_132 =
  let name = "n_inv_132" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_134 =
  let name = "n_inv_134" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_136 =
  let name = "n_inv_136" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_137 =
  let name = "n_inv_137" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_139 =
  let name = "n_inv_139" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_140 =
  let name = "n_inv_140" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_S))])) in
  prop name params formula

let n_inv_141 =
  let name = "n_inv_141" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_142 =
  let name = "n_inv_142" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_143 =
  let name = "n_inv_143" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_145 =
  let name = "n_inv_145" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_146 =
  let name = "n_inv_146" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_147 =
  let name = "n_inv_147" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_148 =
  let name = "n_inv_148" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_149 =
  let name = "n_inv_149" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_150 =
  let name = "n_inv_150" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_151 =
  let name = "n_inv_151" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_152 =
  let name = "n_inv_152" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_153 =
  let name = "n_inv_153" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_154 =
  let name = "n_inv_154" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_155 =
  let name = "n_inv_155" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_156 =
  let name = "n_inv_156" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_GetX))])) in
  prop name params formula

let n_inv_157 =
  let name = "n_inv_157" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None))])) in
  prop name params formula

let n_inv_158 =
  let name = "n_inv_158" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_159 =
  let name = "n_inv_159" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_160 =
  let name = "n_inv_160" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_161 =
  let name = "n_inv_161" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_162 =
  let name = "n_inv_162" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_163 =
  let name = "n_inv_163" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_164 =
  let name = "n_inv_164" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_165 =
  let name = "n_inv_165" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_166 =
  let name = "n_inv_166" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_I))])) in
  prop name params formula

let n_inv_168 =
  let name = "n_inv_168" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_170 =
  let name = "n_inv_170" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_171 =
  let name = "n_inv_171" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_172 =
  let name = "n_inv_172" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_173 =
  let name = "n_inv_173" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_174 =
  let name = "n_inv_174" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_175 =
  let name = "n_inv_175" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_176 =
  let name = "n_inv_176" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S))]); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_177 =
  let name = "n_inv_177" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck))])) in
  prop name params formula

let n_inv_178 =
  let name = "n_inv_178" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))])) in
  prop name params formula

let n_inv_179 =
  let name = "n_inv_179" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_180 =
  let name = "n_inv_180" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_182 =
  let name = "n_inv_182" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_183 =
  let name = "n_inv_183" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_184 =
  let name = "n_inv_184" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_185 =
  let name = "n_inv_185" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_186 =
  let name = "n_inv_186" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_187 =
  let name = "n_inv_187" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_188 =
  let name = "n_inv_188" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv))])) in
  prop name params formula

let n_inv_189 =
  let name = "n_inv_189" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb))])) in
  prop name params formula

let n_inv_190 =
  let name = "n_inv_190" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_191 =
  let name = "n_inv_191" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E))])) in
  prop name params formula

let n_inv_192 =
  let name = "n_inv_192" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_193 =
  let name = "n_inv_193" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_194 =
  let name = "n_inv_194" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_195 =
  let name = "n_inv_195" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Proc"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_196 =
  let name = "n_inv_196" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_197 =
  let name = "n_inv_197" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_198 =
  let name = "n_inv_198" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_199 =
  let name = "n_inv_199" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_200 =
  let name = "n_inv_200" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_201 =
  let name = "n_inv_201" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_ShWb)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_202 =
  let name = "n_inv_202" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_203 =
  let name = "n_inv_203" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_204 =
  let name = "n_inv_204" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_205 =
  let name = "n_inv_205" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_206 =
  let name = "n_inv_206" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_207 =
  let name = "n_inv_207" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_208 =
  let name = "n_inv_208" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_209 =
  let name = "n_inv_209" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_210 =
  let name = "n_inv_210" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_211 =
  let name = "n_inv_211" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; arr [("RpMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _RP_Replace))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_212 =
  let name = "n_inv_212" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_GetX)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_213 =
  let name = "n_inv_213" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_214 =
  let name = "n_inv_214" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_215 =
  let name = "n_inv_215" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_216 =
  let name = "n_inv_216" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_217 =
  let name = "n_inv_217" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_218 =
  let name = "n_inv_218" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_219 =
  let name = "n_inv_219" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_220 =
  let name = "n_inv_220" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_221 =
  let name = "n_inv_221" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_222 =
  let name = "n_inv_222" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_224 =
  let name = "n_inv_224" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_225 =
  let name = "n_inv_225" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_226 =
  let name = "n_inv_226" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_227 =
  let name = "n_inv_227" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_228 =
  let name = "n_inv_228" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_229 =
  let name = "n_inv_229" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_230 =
  let name = "n_inv_230" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_231 =
  let name = "n_inv_231" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_232 =
  let name = "n_inv_232" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeProc"; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_233 =
  let name = "n_inv_233" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_234 =
  let name = "n_inv_234" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_235 =
  let name = "n_inv_235" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_236 =
  let name = "n_inv_236" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_237 =
  let name = "n_inv_237" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_238 =
  let name = "n_inv_238" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "HomeProc"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_239 =
  let name = "n_inv_239" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_240 =
  let name = "n_inv_240" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_241 =
  let name = "n_inv_241" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_242 =
  let name = "n_inv_242" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_243 =
  let name = "n_inv_243" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_244 =
  let name = "n_inv_244" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_245 =
  let name = "n_inv_245" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_246 =
  let name = "n_inv_246" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_InvAck)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_247 =
  let name = "n_inv_247" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_248 =
  let name = "n_inv_248" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv1"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get))])) in
  prop name params formula

let n_inv_249 =
  let name = "n_inv_249" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get))]); (eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Proc"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_250 =
  let name = "n_inv_250" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_251 =
  let name = "n_inv_251" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))])) in
  prop name params formula

let n_inv_252 =
  let name = "n_inv_252" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_253 =
  let name = "n_inv_253" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_254 =
  let name = "n_inv_254" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_255 =
  let name = "n_inv_255" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_256 =
  let name = "n_inv_256" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_257 =
  let name = "n_inv_257" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc))])) in
  prop name params formula

let n_inv_258 =
  let name = "n_inv_258" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))])) in
  prop name params formula

let n_inv_259 =
  let name = "n_inv_259" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_260 =
  let name = "n_inv_260" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_261 =
  let name = "n_inv_261" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc false)))])) in
  prop name params formula

let n_inv_262 =
  let name = "n_inv_262" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "ShrVld"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))])) in
  prop name params formula

let n_inv_263 =
  let name = "n_inv_263" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_264 =
  let name = "n_inv_264" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv0"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_265 =
  let name = "n_inv_265" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; arr [("ShrSet", [paramref "p__Inv1"])]])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_266 =
  let name = "n_inv_266" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_I)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_267 =
  let name = "n_inv_267" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_268 =
  let name = "n_inv_268" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_269 =
  let name = "n_inv_269" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_270 =
  let name = "n_inv_270" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_S)); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_271 =
  let name = "n_inv_271" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_272 =
  let name = "n_inv_272" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_273 =
  let name = "n_inv_273" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; global "HeadPtr"])) (const (intc 2)))])) in
  prop name params formula

let n_inv_274 =
  let name = "n_inv_274" in
  let params = [] in
  let formula = (neg (andList [(andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Local"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Put))]); (eqn (var (record [global "Sta"; global "Dir"; global "Dirty"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_275 =
  let name = "n_inv_275" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_276 =
  let name = "n_inv_276" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_277 =
  let name = "n_inv_277" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_278 =
  let name = "n_inv_278" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "Dir"; global "HeadVld"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_279 =
  let name = "n_inv_279" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "NakcMsg"; global "Cmd"])) (const _NAKC_Nakc)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_280 =
  let name = "n_inv_280" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_PutX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_281 =
  let name = "n_inv_281" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_282 =
  let name = "n_inv_282" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_None)); (eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_283 =
  let name = "n_inv_283" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "ProcCmd"])) (const _NODE_Get)); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_GetX))])) in
  prop name params formula

let n_inv_284 =
  let name = "n_inv_284" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("InvMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _INV_Inv)); (eqn (var (record [global "Sta"; global "Dir"; global "HomeHeadPtr"])) (const (boolc true)))])) in
  prop name params formula

let n_inv_285 =
  let name = "n_inv_285" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv0"])]; global "InvMarked"])) (const (boolc true))); (eqn (var (record [global "Sta"; global "ShWbMsg"; global "Cmd"])) (const _SHWB_FAck))])) in
  prop name params formula

let n_inv_286 =
  let name = "n_inv_286" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; global "WbMsg"; global "Cmd"])) (const _WB_Wb))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_287 =
  let name = "n_inv_287" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))]); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv0"])]; global "HomeProc"])) (const (boolc false)))])) in
  prop name params formula

let n_inv_288 =
  let name = "n_inv_288" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_Get)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_289 =
  let name = "n_inv_289" in
  let params = [] in
  let formula = (neg (andList [(eqn (var (record [global "Sta"; global "HomeUniMsg"; global "Cmd"])) (const _UNI_GetX)); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_290 =
  let name = "n_inv_290" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; arr [("Proc", [paramref "p__Inv1"])]; global "CacheState"])) (const _CACHE_E)); (eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false)))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula

let n_inv_291 =
  let name = "n_inv_291" in
  let params = [] in
  let formula = (neg (andList [(andList [(eqn (var (record [global "Sta"; global "Dir"; global "Pending"])) (const (boolc false))); (eqn (var (record [global "Sta"; arr [("UniMsg", [paramref "p__Inv1"])]; global "Cmd"])) (const _UNI_PutX))]); (eqn (var (record [global "Sta"; global "Dir"; arr [("InvSet", [paramref "p__Inv0"])]])) (const (boolc true)))])) in
  prop name params formula


let inferGuard rule=
	let Rule(n,pds,g,a)=rule in
	match pds with
	|[] -> g
	|_ -> existFormula pds g

let inferDeadLockProp rules=
	orList (List.map ~f:inferGuard rules)



let makeDeadLockProp rules=
	let name = "n_deadLockFree" in
  let params = [] in 
	prop name params (inferDeadLockProp rules)
(*; n_MemDataProp makeDeadLockProp rules*)

 

let properties = [makeDeadLockProp rules; n_inv_3; n_inv_4; n_inv_5; n_inv_6; n_inv_7; n_inv_8; n_inv_9; n_inv_10; n_inv_11; n_inv_13; n_inv_14; n_inv_15; n_inv_16; n_inv_17; n_inv_18; n_inv_19; n_inv_22; n_inv_23; n_inv_24; n_inv_25; n_inv_26; n_inv_27; n_inv_28; n_inv_30; n_inv_31; n_inv_32; n_inv_33; n_inv_34; n_inv_35; n_inv_36; n_inv_37; n_inv_40; n_inv_41; n_inv_42; n_inv_45; n_inv_47; n_inv_48; n_inv_49; n_inv_51; n_inv_53; n_inv_54; n_inv_56; n_inv_59; n_inv_60; n_inv_61; n_inv_62; n_inv_63; n_inv_64; n_inv_65; n_inv_66; n_inv_67; n_inv_71; n_inv_72; n_inv_73; n_inv_76; n_inv_80; n_inv_84; n_inv_85; n_inv_86; n_inv_90; n_inv_91; n_inv_92; n_inv_93; n_inv_94; n_inv_95; n_inv_96; n_inv_97; n_inv_98; n_inv_102; n_inv_104; n_inv_106; n_inv_107; n_inv_108; n_inv_110; n_inv_112; n_inv_113; n_inv_114; n_inv_115; n_inv_116; n_inv_118; n_inv_119; n_inv_120; n_inv_121; n_inv_122; n_inv_123; n_inv_124; n_inv_125; n_inv_126; n_inv_127; n_inv_128; n_inv_129; n_inv_136; n_inv_140; n_inv_141; n_inv_142; n_inv_145; n_inv_146; n_inv_147; n_inv_148; n_inv_149; n_inv_150; n_inv_151; n_inv_152; n_inv_153; n_inv_154; n_inv_155; n_inv_156; n_inv_157; n_inv_158; n_inv_159; n_inv_160; n_inv_161; n_inv_162; n_inv_163; n_inv_164; n_inv_165; n_inv_171; n_inv_173; n_inv_174; n_inv_175; n_inv_176; n_inv_177; n_inv_178; n_inv_179; n_inv_182; n_inv_184; n_inv_185; n_inv_186; n_inv_187; n_inv_188; n_inv_189; n_inv_190; n_inv_191; n_inv_192; n_inv_193; n_inv_194; n_inv_195; n_inv_196; n_inv_197; n_inv_199; n_inv_200; n_inv_201; n_inv_202; n_inv_203; n_inv_204; n_inv_205; n_inv_206; n_inv_207; n_inv_208; n_inv_209; n_inv_210; n_inv_211; n_inv_212; n_inv_213; n_inv_214; n_inv_215; n_inv_216; n_inv_218; n_inv_220; n_inv_221; n_inv_224; n_inv_225; n_inv_226; n_inv_227; n_inv_228; n_inv_229; n_inv_231; n_inv_233; n_inv_234; n_inv_235; n_inv_236; n_inv_237; n_inv_239; n_inv_240; n_inv_241; n_inv_242; n_inv_243; n_inv_244; n_inv_245; n_inv_246; n_inv_247; n_inv_248; n_inv_249; n_inv_250; n_inv_251; n_inv_252; n_inv_253; n_inv_254; n_inv_255; n_inv_256; n_inv_257; n_inv_258; n_inv_259; n_inv_260; n_inv_261; n_inv_262; n_inv_263; n_inv_264; n_inv_265; n_inv_266; n_inv_268; n_inv_269; n_inv_270; n_inv_271; n_inv_272; n_inv_273; n_inv_274; n_inv_275; n_inv_276; n_inv_277; n_inv_278; n_inv_279; n_inv_280; n_inv_281; n_inv_282; n_inv_283; n_inv_284; n_inv_285; n_inv_286; n_inv_287; n_inv_288; n_inv_289; n_inv_290; n_inv_291; n_CacheStateProp; n_CacheStatePropHome; n_inv_3; n_inv_4; n_inv_5; n_inv_6; n_inv_7; n_inv_8; n_inv_9; n_inv_10; n_inv_11; n_inv_12; n_inv_13; n_inv_14; n_inv_15; n_inv_16; n_inv_17; n_inv_18; n_inv_19; n_inv_20; n_inv_22; n_inv_23; n_inv_24; n_inv_25; n_inv_26; n_inv_27; n_inv_28; n_inv_29; n_inv_30; n_inv_31; n_inv_32; n_inv_33; n_inv_34; n_inv_35; n_inv_36; n_inv_37; n_inv_38; n_inv_40; n_inv_41; n_inv_42; n_inv_43; n_inv_45; n_inv_46; n_inv_47; n_inv_48; n_inv_49; n_inv_50; n_inv_51; n_inv_52; n_inv_53; n_inv_54; n_inv_55; n_inv_56; n_inv_57; n_inv_59; n_inv_60; n_inv_61; n_inv_62; n_inv_63; n_inv_64; n_inv_65; n_inv_66; n_inv_67; n_inv_68; n_inv_70; n_inv_71; n_inv_72; n_inv_73; n_inv_74; n_inv_76; n_inv_77; n_inv_79; n_inv_80; n_inv_81; n_inv_83; n_inv_84; n_inv_85; n_inv_86; n_inv_87; n_inv_89; n_inv_90; n_inv_91; n_inv_92; n_inv_93; n_inv_94; n_inv_95; n_inv_96; n_inv_97; n_inv_98; n_inv_99; n_inv_101; n_inv_102; n_inv_103; n_inv_104; n_inv_105; n_inv_106; n_inv_107; n_inv_108; n_inv_109; n_inv_110; n_inv_111; n_inv_112; n_inv_113; n_inv_114; n_inv_115; n_inv_116; n_inv_117; n_inv_118; n_inv_119; n_inv_120; n_inv_121; n_inv_122; n_inv_123; n_inv_124; n_inv_125; n_inv_126; n_inv_127; n_inv_128; n_inv_129; n_inv_130; n_inv_132; n_inv_134; n_inv_136; n_inv_137; n_inv_139; n_inv_140; n_inv_141; n_inv_142; n_inv_143; n_inv_145; n_inv_146; n_inv_147; n_inv_148; n_inv_149; n_inv_150; n_inv_151; n_inv_152; n_inv_153; n_inv_154; n_inv_155; n_inv_156; n_inv_157; n_inv_158; n_inv_159; n_inv_160; n_inv_161; n_inv_162; n_inv_163; n_inv_164; n_inv_165; n_inv_166; n_inv_168; n_inv_170; n_inv_171; n_inv_172; n_inv_173; n_inv_174; n_inv_175; n_inv_176; n_inv_177; n_inv_178; n_inv_179; n_inv_180; n_inv_182; n_inv_183; n_inv_184; n_inv_185; n_inv_186; n_inv_187; n_inv_188; n_inv_189; n_inv_190; n_inv_191; n_inv_192; n_inv_193; n_inv_194; n_inv_195; n_inv_196; n_inv_197; n_inv_198; n_inv_199; n_inv_200; n_inv_201; n_inv_202; n_inv_203; n_inv_204; n_inv_205; n_inv_206; n_inv_207; n_inv_208; n_inv_209; n_inv_210; n_inv_211; n_inv_212; n_inv_213; n_inv_214; n_inv_215; n_inv_216; n_inv_217; n_inv_218; n_inv_219; n_inv_220; n_inv_221; n_inv_222; n_inv_224; n_inv_225; n_inv_226; n_inv_227; n_inv_228; n_inv_229; n_inv_230; n_inv_231; n_inv_232; n_inv_233; n_inv_234; n_inv_235; n_inv_236; n_inv_237; n_inv_238; n_inv_239; n_inv_240; n_inv_241; n_inv_242; n_inv_243; n_inv_244; n_inv_245; n_inv_246; n_inv_247; n_inv_248; n_inv_249; n_inv_250; n_inv_251; n_inv_252; n_inv_253; n_inv_254; n_inv_255; n_inv_256; n_inv_257; n_inv_258; n_inv_259; n_inv_260; n_inv_261; n_inv_262; n_inv_263; n_inv_264; n_inv_265; n_inv_266; n_inv_267; n_inv_268; n_inv_269; n_inv_270; n_inv_271; n_inv_272; n_inv_273; n_inv_274; n_inv_275; n_inv_276; n_inv_277; n_inv_278; n_inv_279; n_inv_280; n_inv_281; n_inv_282; n_inv_283; n_inv_284; n_inv_285; n_inv_286; n_inv_287; n_inv_288; n_inv_289; n_inv_290; n_inv_291] 


let protocol = {
  name = "n_flash_data_cubLyjDeadLockFree";
  types;
  vardefs;
  init;
  rules;
  properties;
}

let () = run_with_cmdline (fun () ->
  let protocol = preprocess_rule_guard ~loach:protocol in
  let cinvs_with_varnames, relations = anotherFind protocol
    ~murphi:(In_channel.read_all "n_flash_data_cub.m")
  in
  Isabelle.protocol_act protocol cinvs_with_varnames relations ()
)

