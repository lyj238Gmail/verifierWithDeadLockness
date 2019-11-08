(** Translate Paramecium to string of other languages
*)

open Utils
open Paramecium

open Core.Std


(*----------------------------- Module To Debug String ----------------------------------*)

(** Translate to Debug string *)
module Debug = struct

  let ignore_paramref = ref false

  (* Translate a const to Debug const *)
  let const_act c =
    "const "^
    match c with
    | Intc(i) -> Int.to_string i
    | Strc(s) -> s
    | Boolc(b) -> String.uppercase (Bool.to_string b)

  let paramdef_act (Paramdef(vn, tn)) = sprintf "[def-%s:%s]" vn tn

  (** Translate a paramref to Debug string *)
  let paramref_act pr =
    if (!ignore_paramref) then "[iii]" else
    match pr with
    | Paramfix(vname, tname, c) -> sprintf "[%s:%s:%s]" (const_act c) tname vname
    | Paramref(name) -> sprintf "[%s:__ref__]" name

  (* Translate a variable to Debug variable *)
  let var_act v =
    let Arr(ls) = v in
    String.concat ~sep:"." (List.map ls ~f:(fun (n, prs) ->
      match prs with
      | [] -> n
      | _ ->
        let actual_ps = List.map prs ~f:paramref_act in
        sprintf "%s%s" n (String.concat actual_ps)
    ))

  (* Translate an exp to Debug exp *)
  let rec exp_act exp =
    match exp with
    | Const(c) -> const_act c
    | Var(v) -> var_act v
    | Param(pr) -> paramref_act pr
    | Ite(f, e1, e2) ->
      sprintf "ite (%s) (%s) (%s)" (form_act f) (exp_act e1) (exp_act e2)
    | UIF(n, el) -> sprintf "(%s)" (String.concat ~sep:n (List.map el ~f:exp_act))
  (** Translate formula to Debug string

      @param form the formula to be translated
      @return the Debug string
  *)
  and form_act form =
    match form with
    | Chaos -> "TRUE"
    | Miracle -> "FALSE"
    | UIP(n, el) -> sprintf "(%s)" (String.concat ~sep:n (List.map el ~f:exp_act))
    | Eqn(e1, e2) -> sprintf "(%s = %s)" (exp_act e1) (exp_act e2)
    | Neg(form) -> sprintf "(!%s)" (form_act form)
    | AndList(fl) ->
      List.map fl ~f:(form_act)
      |> reduce ~default:"TRUE" ~f:(fun res x -> sprintf "%s & %s" res x)
      |> sprintf "(%s)"
    | OrList(fl) ->
      List.map fl ~f:(form_act)
      |> reduce ~default:"FALSE" ~f:(fun res x -> sprintf "%s | %s" res x)
      |> sprintf "(%s)"
    | Imply(f1, f2) -> sprintf "(%s -> %s)" (form_act f1) (form_act f2)

end




(*----------------------------- Module To SMT String ----------------------------------*)

(** Translate to smt2 string *)
module Smt2 = struct

  let const_is_strc c = 
    match c with
    | Strc(_) -> true
    | Intc(_) | Boolc(_) -> false

  let const_is_intc c = 
    match c with
    | Intc(_) -> true
    | Strc(_) | Boolc(_) -> false

  let const_is_boolc c = 
    match c with
    | Boolc(_) -> true
    | Intc(_) | Strc(_) -> false

  (* Translate a type definition to smt2 type definition *)
  let type_act t =
    let Enum(name, values) = t in
    let is_strc = all values ~f:const_is_strc in
    if is_strc then
      let strs = List.map values ~f:(fun c ->
        match c with
        | Strc(s) -> s
        | Intc(_) | Boolc(_) -> raise Empty_exception
      ) in
      sprintf "(declare-datatypes () ((%s %s)))" name (String.concat ~sep:" " strs)
    else
      ""
  
  (* Translate a variable definition to smt2 function definition *)
  let vardef_act vd ~types =
    let Arrdef(ls, tname) = vd in
    let (names, paramdefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let paramdefs = List.concat paramdefs_list in
    let type_name tname =
      let consts = name2type ~tname ~types in
      if all consts ~f:const_is_strc then
        tname
      else if all consts ~f:const_is_intc then
        "Int"
      else
        "Bool"
    in
    let param_ts = List.map paramdefs ~f:(fun (Paramdef(_, t)) -> type_name t) in
    sprintf "(declare-fun %s (%s) %s)" name (String.concat ~sep:" " param_ts) (type_name tname)

  (* Translate a const to smt const *)
  let const_act c =
    match c with
    | Intc(i) -> Int.to_string i
    | Strc(s) -> s
    | Boolc(b) -> Bool.to_string b

  (* Translate a variable to smt2 function call *)
  let var_act v =
    let Arr(ls) = v in
    let (names, paramrefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let params = List.concat paramrefs_list in
    if params = [] then
      name
    else begin
      let actual_ps = List.map params ~f:(fun p ->
        match p with
        | Paramfix(_, _, c) -> const_act c
        | Paramref(_) -> raise Unexhausted_inst
      ) in
      sprintf "(%s %s)" name (String.concat ~sep:" " actual_ps)
    end

  (* Translate an exp to smt2 exp *)
  let rec exp_act exp =
    match exp with
    | Const(c) -> const_act c
    | Var(v) -> var_act v
    | Param(Paramfix(_, _, c)) -> const_act c
    | Param(Paramref _) -> raise Unexhausted_inst
    | Ite(f, e1, e2) ->
      sprintf "(ite %s %s %s)" (form_act f) (exp_act e1) (exp_act e2)
    | UIF(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
  (* Translate formula to smt2 string *)
  and form_act form =
    match form with
    | Chaos -> "true"
    | Miracle -> "false"
    | UIP(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
    | Eqn(e1, e2) -> sprintf "(= %s %s)" (exp_act e1) (exp_act e2)
    | Neg(form) -> sprintf "(not %s)" (form_act form)
    | AndList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"true" ~f:(fun res x -> sprintf "(and %s %s)" res x)
    | OrList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"false" ~f:(fun res x -> sprintf "(or %s %s)" res x)
    | Imply(f1, f2) -> sprintf "(=> %s %s)" (form_act f1) (form_act f2)

  let apply_vardef vardef insym_types ~types =
    let attach name pf =
      let c =
        match pf with
        | Paramfix(_, _, x) -> x
        | _ -> raise Empty_exception
      in
      match c with
      | Strc(x) -> sprintf "%s_%s" name x
      | Intc(x) -> sprintf "%s_%d" name x
      | Boolc(x) -> sprintf "%s_%b" name x
    in
    let attach_list name pfs =
      List.fold pfs ~init:name ~f:attach
    in
    let Arrdef(parts, tname) = vardef in
    let new_parts = List.map parts ~f:(fun (n, pds) ->
      let insym_pds, sym_pds = List.partition_tf pds ~f:(fun (Paramdef(_, tn)) ->
        List.exists insym_types ~f:(fun t -> t = tn)
      ) in
      let ps = cart_product_with_paramfix insym_pds types in
      if ps = [] then
        [(n, pds)]
      else begin
        List.map ps ~f:(fun p -> (attach_list n p, sym_pds))
      end
    ) in
    List.map (cartesian_product new_parts) ~f:(fun parts -> arrdef parts tname)

  let context_of ~insym_types ~types ~vardefs =
    let type_str =
      List.map types ~f:type_act
      |> List.filter ~f:(fun x -> not (x = ""))
      |> String.concat ~sep:"\n"
    in
    let vardef_str =
      List.map vardefs ~f:(fun vd -> apply_vardef vd insym_types ~types)
      |> List.concat
      |> List.map ~f:(vardef_act ~types)
      |> String.concat ~sep:"\n"
    in
   (*let ()=printf "%s%s" type_str vardef_str in*)
    sprintf "%s%s" type_str vardef_str
    
 

  let form_of form =
    sprintf "(assert %s)" (form_act form)

end



(*----------------------------- Another Module To SMT String ----------------------------------*)

(** Translate to smt2 string *)
module AnotherSmt2 = struct
	(*"NODE" ->[1,2] *)
	
  let const_is_strc c = 
    match c with
    | Strc(_) -> true
    | Intc(_) | Boolc(_) -> false

  let const_is_intc c = 
    match c with
    | Intc(_) -> true
    | Strc(_) | Boolc(_) -> false

  let const_is_boolc c = 
    match c with
    | Boolc(_) -> true
    | Intc(_) | Strc(_) -> false

  (* Translate a type definition to smt2 type definition *)
  let type_act t =
    let Enum(name, values) = t in
    let is_strc = all values ~f:const_is_strc in
    if is_strc then
      let strs = List.map values ~f:(fun c ->
        match c with
        | Strc(s) -> s
        | Intc(_) | Boolc(_) -> raise Empty_exception
      ) in
      sprintf "(declare-datatypes () ((%s %s)))" name (String.concat ~sep:" " strs)
    else       ""
  
  (* Translate a variable definition to smt2 function definition *)
  let vardef_act vd ~types =
    let Arrdef(ls, tname) = vd in
    let (names, paramdefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let paramdefs = List.concat paramdefs_list in
    let type_name tname =
      let consts = name2type ~tname ~types in
      if all consts ~f:const_is_strc then
        tname
      else if all consts ~f:const_is_intc then
        "Int"
      else
        "Bool"
    in
    let param_ts = List.map paramdefs ~f:(fun (Paramdef(_, t)) -> type_name t) in
    sprintf "(declare-fun %s (%s) %s)" name (String.concat ~sep:" " param_ts) (type_name tname)

  (* Translate a const to smt const *)
  let const_act c =
    match c with
    | Intc(i) -> Int.to_string i
    | Strc(s) -> s
    | Boolc(b) -> Bool.to_string b

  (* Translate a variable to smt2 function call *)
  (*let var_act v =
    let Arr(ls) = v in
    let (names, paramrefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let params = List.concat paramrefs_list in
    if params = [] then
      name
    else begin
      let actual_ps = List.map params ~f:(fun p ->
        match p with
        | Paramfix(_, _, c) -> const_act c
        | Paramref(n) -> n (*let ()=print_endline n in  raise Unexhausted_inst*)
      ) in
      sprintf "(%s %s)" name (String.concat ~sep:" " actual_ps)
    end*)
    
  let paramref_act pr =
  match pr with
  | Paramfix(_, _, c) -> const_act c
  | Paramref(name) -> name  
  
  let rec wrap ls str=
  	match ls with
  	|[] ->str 
  	|x::ls0-> 
  		let (n,prs)=x in
  		 match prs with
    	| [] -> let str0= if (str="") then n else sprintf "(%s %s)" n str    in
    	         wrap ls0 str0
    	 (* match ls0 with |[]-> n |_ ->*)
   		| _ ->
      let actual_ps = List.map prs ~f:paramref_act in
      (*(select s1 0 0)*)
      let str0=if (str="") then sprintf "(select %s %s %s)" n str  (String.concat (List.map actual_ps ~f:(fun p -> sprintf " %s " p))) 
      				else sprintf "(select (%s %s) %s)" n str  (String.concat (List.map actual_ps ~f:(fun p -> sprintf " %s " p)))  in
      wrap ls0 str0
   
  		
  		
  let var_act v =
  let Arr(ls) = v in
  wrap ls ""
  (*let str=String.concat ~sep:"." (List.map ls ~f:(fun (n, prs) ->
    match prs with
    | [] -> sprintf "%s" n
    | _ ->
      let actual_ps = List.map prs ~f:paramref_act in
      sprintf "%s%s" n (String.concat (List.map actual_ps ~f:(fun p -> sprintf " %s " p)))
  )) in
  sprintf "%s" str*)

  (* Translate an exp to smt2 exp *)
  let rec exp_act exp =
    match exp with
    | Const(c) -> const_act c
    | Var(v) -> var_act v
    | Param(Paramfix(_, _, c)) -> const_act c
    | Param(Paramref _) -> raise Unexhausted_inst
    | Ite(f, e1, e2) ->
      sprintf "(ite %s %s %s)" (form_act f) (exp_act e1) (exp_act e2)
    | UIF(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
  (* Translate formula to smt2 string *)
  and form_act form =
    match form with
    | Chaos -> "true"
    | Miracle -> "false"
    | UIP(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
    | Eqn(e1, e2) -> sprintf "(= %s %s)" (exp_act e1) (exp_act e2)
    | Neg(form) -> sprintf "(not %s)" (form_act form)
    | AndList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"true" ~f:(fun res x -> sprintf "(and %s %s)" res x)
    | OrList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"false" ~f:(fun res x -> sprintf "(or %s %s)" res x)
    | Imply(f1, f2) -> sprintf "(=> %s %s)" (form_act f1) (form_act f2)

  let apply_vardef vardef insym_types ~types =
    let attach name pf =
      let c =
        match pf with
        | Paramfix(_, _, x) -> x
        | _ -> raise Empty_exception
      in
      match c with
      | Strc(x) -> sprintf "%s_%s" name x
      | Intc(x) -> sprintf "%s_%d" name x
      | Boolc(x) -> sprintf "%s_%b" name x
    in
    let attach_list name pfs =
      List.fold pfs ~init:name ~f:attach
    in
    let Arrdef(parts, tname) = vardef in
    let new_parts = List.map parts ~f:(fun (n, pds) ->
      let insym_pds, sym_pds = List.partition_tf pds ~f:(fun (Paramdef(_, tn)) ->
        List.exists insym_types ~f:(fun t -> t = tn)
      ) in
      let ps = cart_product_with_paramfix insym_pds types in
      if ps = [] then
        [(n, pds)]
      else begin
        List.map ps ~f:(fun p -> (attach_list n p, sym_pds))
      end
    ) in
    List.map (cartesian_product new_parts) ~f:(fun parts -> arrdef parts tname)

  let context_of ~insym_types ~types ~vardefs =
    let type_str =
      List.map types ~f:type_act
      |> List.filter ~f:(fun x -> not (x = ""))
      |> String.concat ~sep:"\n"
    in
    let vardef_str =
      List.map vardefs ~f:(fun vd -> apply_vardef vd insym_types ~types)
      |> List.concat
      |> List.map ~f:(vardef_act ~types)
      |> String.concat ~sep:"\n"
    in
   (*let ()=printf "%s%s" type_str vardef_str in*)
    sprintf "%s%s" type_str vardef_str
    
 

  let form_of form =
  (*	let ()=print_endline (form_act form) in *)
    sprintf "(assert %s)" (form_act form)

end





(*----------------------------- Module To SMV String ----------------------------------*)

(** Translate to smv string *)
module Smv = struct

  let strc_to_lower = ref true

  (* Translate a const to smv const *)
  let const_act c =
    match c with
    | Intc(i) -> Int.to_string i
    | Strc(s) -> if (!strc_to_lower) then String.lowercase s else begin s end
    | Boolc(b) -> if (!strc_to_lower=false) then String.lowercase (Bool.to_string b)
		else String.uppercase (Bool.to_string b)

  let type_act ~types name =
    let Enum(_, consts) = List.find_exn types ~f:(fun (Enum(n, _)) -> n = name) in
    let range =
      List.map consts ~f:const_act
      |> String.concat ~sep:", "
    in
    if range = "TRUE, FALSE" || range = "FALSE, TRUE" then "boolean"
    else begin sprintf "{%s}" range end

  (** Translate a paramref to smv string *)
  let paramref_act pr =
    match pr with
    | Paramfix(_, _, c) -> sprintf "[%s]" (const_act c)
    | Paramref(name) -> Prt.error ("Unexhausted_inst param: "^name);raise Unexhausted_inst

  let vardef_act ~types vd =
    let Arrdef(ls, t) = vd in
    let type_str = type_act ~types t in
    let parts = List.map ls ~f:(fun (n, pds) ->
      match pds with
      | [] -> [n]
      | _ ->
        let ps = cart_product_with_paramfix pds types in
        let const_strs = List.map ps ~f:(fun group -> 
          List.map group ~f:(fun pr -> paramref_act pr)
          |> String.concat
        ) in
        List.map const_strs ~f:(fun cstr -> sprintf "%s%s" n cstr)
    ) in
    let full_parts = cartesian_product parts in
    let full_names = List.map full_parts ~f:(fun parts -> String.concat ~sep:"." parts) in
    String.concat ~sep:"\n" (List.map full_names ~f:(fun n -> sprintf "%s : %s;" n type_str))

  (* Translate a variable to smv variable *)
  let var_act v =
    let Arr(ls) = v in
    String.concat ~sep:"." (List.map ls ~f:(fun (n, prs) ->
      match prs with
      | [] -> n
      | _ -> sprintf "%s%s" n (String.concat (List.map prs ~f:paramref_act))
    ))

  (* Translate an exp to smv exp *)
  let rec exp_act exp =
    match exp with
    | Const(c) -> const_act c
    | Var(v) -> var_act v
    | Param(pr) -> (
        match pr with
        | Paramfix(_, _, c) -> sprintf "%s" (const_act c)
        | Paramref(_) -> raise Unexhausted_inst
      )
    | Ite(f, e1, e2) ->
      let lower = (!strc_to_lower) in
      sprintf "case\n%s : %s; TRUE : %s;\nesac" (form_act ~lower f) (exp_act e1) (exp_act e2)
    | UIF(n, el) -> sprintf "(%s)" (String.concat ~sep:(" "^n^" ") (List.map el ~f:exp_act))
  (** Translate formula to smv string

      @param form the formula to be translated
      @return the smv string
  *)
  and form_act ?(lower=true) form =
    strc_to_lower := lower;
    match form with
    | Chaos -> "TRUE"
    | Miracle -> "FALSE"
    | UIP(n, el) -> sprintf "(%s)" (String.concat ~sep:n (List.map el ~f:exp_act))
    | Eqn(e1, e2) -> sprintf "(%s = %s)" (exp_act e1) (exp_act e2)
    | Neg(form) -> sprintf "(!%s)" (form_act ~lower form)
    | AndList(fl) ->
      List.map fl ~f:(form_act ~lower)
      |> reduce ~default:"TRUE" ~f:(fun res x -> sprintf "%s & %s" res x)
      |> sprintf "(%s)"
    | OrList(fl) ->
      List.map fl ~f:(form_act ~lower)
      |> reduce ~default:"FALSE" ~f:(fun res x -> sprintf "%s | %s" res x)
      |> sprintf "(%s)"
    | Imply(f1, f2) -> sprintf "(%s -> %s)" (form_act ~lower f1) (form_act ~lower f2)

  let rec statement_act ?(is_init=false) s fstr =
    match s with
    | Assign(v, e) ->
      let var_str = var_act v in
      let exp_str = exp_act e in
      if is_init then
        sprintf "init(%s) := case\nTRUE : (%s);\nesac;" var_str exp_str
      else begin
        sprintf "next(%s) := case\n(%s) : (%s);\nTRUE : (%s);\nesac;" var_str fstr exp_str var_str
      end
    | Parallel(ss) ->
      if ss = [] then "" else begin
        List.map ss ~f:(fun s' -> statement_act ~is_init s' fstr)
        |> String.concat ~sep:"\n"
      end

  (*let rec init_act s =
    match s with
    | Assign(v, e) ->
      let var_str = var_act v in
      let exp_str = exp_act e in
      sprintf "init(%s) := %s;" var_str exp_str
    | Parallel(ss) ->
      if ss = [] then "" else begin
        List.map ss ~f:init_act
        |> String.concat ~sep:"\n"
      end*)
  let init_act s = statement_act ~is_init:true s "TRUE"

  let rule_act r =
    let escape n =
      String.substr_replace_all n ~pattern:"[" ~with_:"__"
      |> String.substr_replace_all ~pattern:"]" ~with_:""
      |> String.substr_replace_all ~pattern:"." ~with_:"__"
    in
    let vars = String.Set.to_list (VarNamesWithParam.of_rule r ~of_var:(fun v ->
      String.Set.of_list [var_act v]
    )) in
    let vars_str = String.concat vars ~sep:", " in
    (* rule process instance *)
    let Rule(n, _, f, s) = r in
    let name = escape n
    in
    let rule_proc_inst = sprintf "%s : process Proc__%s(%s);" name name vars_str in
    (* rule process *)
    let form_str = form_act f in
    let statement_str = escape (statement_act s form_str) in
    let rule_proc = 
      sprintf "MODULE Proc__%s(%s)\nASSIGN\n%s" name (escape vars_str) statement_str
    in
    (* result *)
    (rule_proc_inst, rule_proc)

  let prop_act property =
    let Prop(_, _, f) = property in
    sprintf "SPEC\n  AG (!%s)" (form_act f)

  let protocol_act {name=_; types; vardefs; init; rules; properties} =
    let property_strs = List.map properties ~f:prop_act in
    let rule_proc_insts, rule_procs =List.unzip (List.map rules ~f:rule_act) in
    let vardef_str = 
      sprintf "VAR\n%s" (String.concat ~sep:"\n" (List.map vardefs ~f:(vardef_act ~types)))
    in
    let rule_proc_insts_str = String.concat ~sep:"\n\n" rule_proc_insts in
    let init_str = sprintf "ASSIGN\n%s" (init_act init) in
    let prop_str = String.concat ~sep:"\n\n" property_strs in
    let rule_procs_str = String.concat ~sep:"\n\n---------\n\n" rule_procs in
    let strs = [vardef_str; rule_proc_insts_str; init_str; prop_str] in
    let main_module = 
      sprintf "MODULE main\n%s" (String.concat ~sep:"\n\n--------------------\n\n" strs)
    in
    sprintf "%s\n\n--------------------\n\n%s" main_module rule_procs_str

end


(*********************************** Module Variables **************************************)

(** Get variable names in the components *)
module Variable = struct
  
  let dict = Core.Std.Hashtbl.create ~hashable:Core.Std.String.hashable ()

  (** Names of var *)
  let of_var v =
    let Arr(ls) = v in
    [v]

  (** Names of exp *)
  let rec of_exp e =
    match e with
    | Const(_)
    | Param(_) ->   []
    | Var(v) -> of_var v
    | Ite(f, e1, e2) -> List.dedup ( (of_exp e1)@ (of_exp e2))
    | UIF(n, el) ->  List.dedup (List.concat (List.map el ~f:of_exp))
  (** Names of formula *)
  and of_form f =
    match f with
    | Chaos
    | Miracle ->   []
    | UIP(n, el) ->  List.dedup (List.concat (List.map el ~f:of_exp))
    | Eqn(e1, e2) -> List.dedup ( (of_exp e1)@ (of_exp e2))
    | Neg(form) -> of_form form
    | AndList(fl)
    | OrList(fl) -> List.dedup (List.concat (List.map fl ~f:of_form))
    | Imply(f1, f2) -> List.dedup (of_form f1@( of_form f2))

	let rec splitBracePair str0 pre suff=
		let l=String.index str0 '['    	in 
		match  l  with
		|Some(l)->
			let Some(r)=String.index  str0 ']' in
			let str1=String.sub  str0 l (r-l+1) in
			(*let ()=print_endline ("str1"^str1) in*)
			let pre0=String.sub  str0 0 (l - 1+1) in
			(*let ()=print_endline ("pre0"^pre0) in*)
			let suf0=String.sub  str0 (r+1) (String.length str0-r-1) in 
			(*let ()=print_endline ("suf0"^suf0) in*)
			splitBracePair suf0 (pre^pre0) (suff^str1) 
		|None->pre^str0^suff

	let addOneVar2Tab v=
		(*let ()=print_endline ("vstr"^(Smv.var_act  (v))) in*)
		let vstr= splitBracePair (Smv.var_act  (v)) "" ""   in
		(*let ()=print_endline ("vstr'"^vstr) in*)
		 Hashtbl.replace dict ~key:(vstr) ~data:v

	let genVarName2VarMap f =
		let vars= of_form f in
		(*let ()=print_endline "enter genVarName2VarMap" in*)
		(*let ()=Core.Std.Hashtbl.clear dict in*)
		List.fold ~f:(fun () v ->addOneVar2Tab v) vars ~init:(); dict
		
end


(*----------------------------- Another Module To SMT String ----------------------------------*)

(** Translate to smt2 string *)
module Another1Smt2 = struct

let subRangeTypeEnumConstTab= Core.Std.Hashtbl.create ~hashable:String.hashable ()

let varDefTab= Core.Std.Hashtbl.create  ~hashable:String.hashable ()

  let const_is_strc c = 
    match c with
    | Strc(_) -> true
    | Intc(_) | Boolc(_) -> false

  let const_is_intc c = 
    match c with
    | Intc(_) -> true
    | Strc(_) | Boolc(_) -> false

  let const_is_boolc c = 
    match c with
    | Boolc(_) -> true
    | Intc(_) | Strc(_) -> false

  (* Translate a type definition to smt2 type definition *)
  let type_act t =
    let Enum(name, values) = t in
    let is_strc = all values ~f:const_is_strc in
    if is_strc then
      let strs = List.map values ~f:(fun c ->
        match c with
        | Strc(s) -> s
        | Intc(_) | Boolc(_) -> raise Empty_exception
      ) in
      sprintf "(declare-datatypes () ((%s %s)))" name (String.concat ~sep:" " strs)
    else
		begin
			let is_intc = all values ~f:const_is_intc in
   		if is_intc then
      let ranges = List.map values ~f:(fun c ->
        match c with
        | Intc(_) -> c
        | _ -> raise Empty_exception
      ) in
      (Core.Std.Hashtbl.replace subRangeTypeEnumConstTab  name ranges;
      "")
			else ""
		end
  
  (* Translate a variable definition to smt2 function definition 	 
   (declare-const AuxData DATA) *)
  let vardef_act vd ~types =
    let Arrdef(ls, tname) = vd in
    let (names, paramdefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let paramdefs = List.concat paramdefs_list in
    let type_name tname =
      let consts = name2type ~tname ~types in
      if all consts ~f:const_is_strc then
        tname
      else if all consts ~f:const_is_intc then
        "Int"
      else
        "Bool"
    in
    let param_ts = List.map paramdefs ~f:(fun (Paramdef(_, t)) -> type_name t) in
		if (List.length param_ts =0) then
    	(Core.Std.Hashtbl.replace varDefTab ~key:name ~data:(  tname); 
			sprintf "(declare-fun %s (%s) %s)" name (String.concat ~sep:" " param_ts) (type_name tname))
		else
			(Core.Std.Hashtbl.replace varDefTab ~key:name ~data:(  tname); 
			sprintf "(declare-const %s  (Array  %s  %s))" name (String.concat ~sep:" " param_ts) (type_name tname))

 
  (* Translate a const to smt const *)
  let const_act c =
    match c with
    | Intc(i) -> Int.to_string i
    | Strc(s) -> s
    | Boolc(b) -> Bool.to_string b

  (* Translate a variable to smt2 function call *)
  let var_act v =
    let Arr(ls) = v in
    let (names, paramrefs_list) = List.unzip ls in
    let name =
      String.concat ~sep:"." names
      |> string_replace "\\[" "_"
      |> string_replace "\\]" ""
    in
    let params = List.concat paramrefs_list in
    if params = [] then
      name
    else begin
      let actual_ps = List.map params ~f:(fun p ->
        match p with
        | Paramfix(_, _, c) -> const_act c
        | Paramref(_) -> raise Unexhausted_inst
      ) in
			match actual_ps with
				|[] ->  sprintf "(%s %s)" name (String.concat ~sep:" " actual_ps)
				|_ -> sprintf "(select %s %s)" name (String.concat ~sep:" " actual_ps)
    end

(*let paramref_act pr =
  match pr with
  | Paramfix(_, _, c) -> const_act c
  | Paramref(name) -> name  
  
  let rec wrap ls str=
  	match ls with
  	|[] ->str 
  	|x::ls0-> 
  		let (n,prs)=x in
  		 match prs with
    	| [] -> let str0= if (str="") then n else sprintf "(%s %s)" n str    in
    	         wrap ls0 str0
    	 (* match ls0 with |[]-> n |_ ->*)
   		| _ ->
      let actual_ps = List.map prs ~f:paramref_act in
      (*(select s1 0 0)*)
      let str0=if (str="") then sprintf "(select %s %s %s)" n str  (String.concat (List.map actual_ps ~f:(fun p -> sprintf " %s " p))) 
      				else sprintf "(select (%s %s) %s)" n str  (String.concat (List.map actual_ps ~f:(fun p -> sprintf " %s " p)))  in
      wrap ls0 str0
   
  		
  		
  let var_act v =
  let Arr(ls) = v in
  wrap ls ""*)


  (* Translate an exp to smt2 exp *)
  let rec exp_act exp =
    match exp with
    | Const(c) -> const_act c
    | Var(v) -> var_act v
    | Param(Paramfix(_, _, c)) -> const_act c
    | Param(Paramref _) -> raise Unexhausted_inst
    | Ite(f, e1, e2) ->
      sprintf "(ite %s %s %s)" (form_act f) (exp_act e1) (exp_act e2)
    | UIF(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
  (* Translate formula to smt2 string *)
  and form_act form =
    match form with
    | Chaos -> "true"
    | Miracle -> "false"
    | UIP(n, el) ->
      let els = List.map el ~f:exp_act in
      List.reduce_exn els ~f:(fun res x -> sprintf "(%s %s %s)" n res x)
    | Eqn(e1, e2) -> sprintf "(= %s %s)" (exp_act e1) (exp_act e2)
    | Neg(form) -> sprintf "(not %s)" (form_act form)
    | AndList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"true" ~f:(fun res x -> sprintf "(and %s %s)" res x)
    | OrList(fl) ->
      List.map fl ~f:form_act
      |> reduce ~default:"false" ~f:(fun res x -> sprintf "(or %s %s)" res x)
    | Imply(f1, f2) -> sprintf "(=> %s %s)" (form_act f1) (form_act f2)

  let apply_vardef vardef insym_types ~types =
    let attach name pf =
      let c =
        match pf with
        | Paramfix(_, _, x) -> x
        | _ -> raise Empty_exception
      in
      match c with
      | Strc(x) -> sprintf "%s_%s" name x
      | Intc(x) -> sprintf "%s_%d" name x
      | Boolc(x) -> sprintf "%s_%b" name x
    in
    let attach_list name pfs =
      List.fold pfs ~init:name ~f:attach
    in
    let Arrdef(parts, tname) = vardef in
    let new_parts = List.map parts ~f:(fun (n, pds) ->
      let insym_pds, sym_pds = List.partition_tf pds ~f:(fun (Paramdef(_, tn)) ->
        List.exists insym_types ~f:(fun t -> t = tn)
      ) in
      let ps = cart_product_with_paramfix insym_pds types in
      if ps = [] then
        [(n, pds)]
      else begin
        List.map ps ~f:(fun p -> (attach_list n p, sym_pds))
      end
    ) in
    List.map (cartesian_product new_parts) ~f:(fun parts -> arrdef parts tname)

  let context_of ~insym_types ~types ~vardefs =
    let type_str =
      List.map types ~f:type_act
      |> List.filter ~f:(fun x -> not (x = ""))
      |> String.concat ~sep:"\n"
    in
    let vardef_str =
      List.map vardefs ~f:(fun vd -> apply_vardef vd insym_types ~types)
      |> List.concat
      |> List.map ~f:(vardef_act ~types)
      |> String.concat ~sep:"\n"
    in
   (*let ()=printf "%s%s" type_str vardef_str in*)
    sprintf "%s%s" type_str vardef_str
 let printVarMap=ref 0

let  printvarNames=ref 0 

 let genConsConstr f=
	let vars=Variable.of_form f in
	let varMaps=Variable.genVarName2VarMap f in
	let varNames =Core.Std.Hashtbl.keys  varDefTab in
	
	let tm1=if (!printVarMap=0) then 
						let ()=print_endline  "names in varMaps" in
						let ()=printVarMap:=1 in List.map ~f:(fun x ->let Some(v0)=Hashtbl.find varDefTab x in print_endline (x^"->"^v0)) varNames 
					else [()]
		      in
	
	let tm1=if (!printvarNames=0 ) && (List.length vars >0) then 
						let ()=print_endline  "names in vars" in
						let ()=printvarNames:=1 in 
								List.map ~f:(fun x -> 
															let vstr=(Variable.splitBracePair (Smv.var_act  (x)) "" "") in
															let l=String.index vstr '[' in
															let vstr= match l with 
																	|Some(l)->String.sub vstr 0 (l )
																	|None -> vstr in	
															let Some(v0)=Hashtbl.find varDefTab vstr in print_endline (vstr^"->"^v0)) vars 
					else [()]
		      in
	let genOneConstr v vals= 
		orList (List.map ~f:(fun x-> Eqn(Var(v),Const( x))) vals) in
  let gen v= 
		let vstr= Variable.splitBracePair (Smv.var_act  (v)) "" "" in
		let l=String.index vstr '[' in
		let vstr= match l with 
			|Some(l)->String.sub vstr 0 (l )
			|None -> vstr in		
		let (typ)=Core.Std.Hashtbl.find varDefTab  vstr in
			match typ with
			|None->""
			|Some(typ)->
				begin
					let vals=Core.Std.Hashtbl.find subRangeTypeEnumConstTab typ in
					match vals with
					|Some(rng) -> begin (*let ()=print_endline ("vstr="^vstr) in*)
							sprintf "(assert %s)" (form_act (genOneConstr v rng)) end
					|None ->""
				end  in
	String.concat ~sep:"\n" (List.map ~f:gen vars)

let form_of form =
    String.concat ~sep:"\n" 
		[sprintf "(assert %s)" (form_act form) ; genConsConstr form]


end


