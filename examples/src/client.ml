(** Client for connect to smv/smt2 server
*)

open Core.Std;;
open Utils;;

exception Server_exception

type request_type =
  | ERROR
  | WAITING
  | OK
  | COMPUTE_REACHABLE
  | QUERY_REACHABLE
  | CHECK_INV
  | SMV_QUIT
  | GO_BMC
  | CHECK_INV_BMC
  | SMV_BMC_QUIT
  | SET_SMT2_CONTEXT
  | QUERY_SMT2
  | QUERY_STAND_SMT2
  | SET_MU_CONTEXT
  | CHECK_INV_BY_MU
  (*add new service*)
  | CHECK_INV_BY_ASSOCIATE_RULE
  | CHECK_INV_BY_DT_TREE
  | QUERY_SMT2_CE
  | QUERY_STAND_SMT2_CE

let request_type_to_str rt =
  match rt with
  | ERROR -> "-2"
  | WAITING -> "-1"
  | OK -> "0"
  | COMPUTE_REACHABLE -> "1"
  | QUERY_REACHABLE -> "2"
  | CHECK_INV -> "3"
  | SMV_QUIT -> "7"
  | GO_BMC -> "10"
  | CHECK_INV_BMC -> "11"
  | SMV_BMC_QUIT -> "12"
  | SET_SMT2_CONTEXT -> "4"
  | QUERY_SMT2 -> "5"
  | QUERY_STAND_SMT2 -> "6"
  | SET_MU_CONTEXT -> "8"
  | CHECK_INV_BY_MU -> "9"
   (*add new service*)
  | CHECK_INV_BY_ASSOCIATE_RULE -> "13"
  | CHECK_INV_BY_DT_TREE -> "14"
  | QUERY_SMT2_CE -> "15"
  | QUERY_STAND_SMT2_CE -> "16"

let splitChar =','

let str_to_request_type str =
  match str with
  | "-2" -> ERROR
  | "-1" -> WAITING
  | "0" -> OK
  | "1" -> COMPUTE_REACHABLE
  | "2" -> QUERY_REACHABLE
  | "3" -> CHECK_INV
  | "7" -> SMV_QUIT
  | "10" -> GO_BMC
  | "11" -> CHECK_INV_BMC
  | "12" -> SMV_BMC_QUIT
  | "4" -> SET_SMT2_CONTEXT
  | "5" -> QUERY_SMT2
  | "6" -> QUERY_STAND_SMT2
  | "8" -> SET_MU_CONTEXT
  | "9" -> CHECK_INV_BY_MU
  | "13" ->CHECK_INV_BY_ASSOCIATE_RULE
  | "14" ->CHECK_INV_BY_DT_TREE  
  | "15" -> QUERY_SMT2_CE 
  | "16" -> QUERY_STAND_SMT2_CE 
  | _ -> Prt.error (sprintf "error return code from server: %s" str); raise Empty_exception

let make_request str host port =
(*	let ()=printf "%s" (UnixLabels.string_of_inet_addr (host)) in*)
  let sock = Unix.socket ~domain:UnixLabels.PF_INET ~kind:UnixLabels.SOCK_STREAM ~protocol:0 in
  let res = String.make 10240 '\000' in
  Unix.connect sock ~addr:(UnixLabels.ADDR_INET(host, port));
  let _writed = Unix.write sock ~buf:str in
  let len = Unix.read sock ~buf:res in
  let result=Unix.close sock;
  String.sub res ~pos:0 ~len in
	(*let ()=print_endline result in*)
	result


let command_id = ref 0

let request cmd req_str host port =
  let cmd  = request_type_to_str cmd in
  let cmd_id = !command_id in
  let req = sprintf "%s%c%d%c%s" cmd splitChar cmd_id splitChar req_str in
  let wrapped = sprintf "%d%c%s" (String.length req) splitChar req in
  incr command_id; (*printf "%d\n" (!command_id);*)
  let res = String.split (make_request wrapped host port) ~on:splitChar in
  match res with
  | [] -> raise Empty_exception
  | status::res' -> 
    let s = str_to_request_type status in
    if s = ERROR then raise Server_exception
    else begin (s, res') end




module Smv = struct

  exception Cannot_check

  let host = ref (UnixLabels.inet_addr_of_string "127.0.0.1")

  let port = ref 50008
  
  let compute_reachable ?(smv_ord="") name content =
    let (status, _) =
      request COMPUTE_REACHABLE (sprintf "%s,%s,%s" name content smv_ord) (!host) (!port)
    in
    status = OK

  let query_reachable name =
    let (status, diameter) = request QUERY_REACHABLE name (!host) (!port) in
    if status = OK then 
      match diameter with
      | "-1"::[] -> raise Server_exception
      | d::[] -> Int.of_string d
      | _ -> raise Server_exception
    else begin 0 end

  let check_inv name inv =
    let (status, res) = request CHECK_INV (sprintf "%s,%s" name inv) (!host) (!port) in
    if status = OK then
      match res with
      | "0"::[] -> raise Cannot_check
      | r::[] -> Bool.of_string r
      | _ -> raise Server_exception
    else begin raise Server_exception end

  let quit name =
    let (s, _) = request SMV_QUIT name (!host) (!port) in
    s = OK

end


module SmvBMC = struct

  exception Cannot_check

  let host = ref (UnixLabels.inet_addr_of_string "127.0.0.1")

  let port = ref 50008
  
  let go_bmc name content =
    let (status, _) = request GO_BMC (sprintf "%s,%s" name content) (!host) (!port) in
    status = OK

  let check_inv name inv =
    let (status, res) = request CHECK_INV_BMC (sprintf "%s,%s" name inv) (!host) (!port) in
    if status = OK then
      match res with
      | "0"::[] -> raise Cannot_check
      | r::[] -> Bool.of_string r
      | _ -> raise Server_exception
    else begin raise Server_exception end

  let quit name =
    let (s, _) = request SMV_BMC_QUIT name (!host) (!port) in
    s = OK

end




module Murphi = struct

  let host = ref (UnixLabels.inet_addr_of_string "127.0.0.1")

  let port = ref 50008

  let set_context name context =
    let (s, _) = request SET_MU_CONTEXT (sprintf "%s,%s" name context) (!host) (!port) in
    s = OK

  let check_inv name inv =
    let (_, res) = request CHECK_INV_BY_MU (sprintf "%s,%s" name inv) (!host) (!port) in
    match res with
    | r::[] -> Bool.of_string r
    | _ -> (print_endline "murphi checking run with exception"; raise  Server_exception)

end






module Smt2 = struct

let host = ref (UnixLabels.inet_addr_of_string "127.0.0.1")

let port = ref 50008

  let set_context name context =
    let (s, _) = request SET_SMT2_CONTEXT (sprintf "%s,%s" name context) (!host) (!port) in
    s = OK

  let check name f =
    let (_, res) = request QUERY_SMT2 (sprintf "%s,%s" name f) (!host) (!port) in
    match res with
    | r::[] ->
      if r = "unsat" then false
      else if r = "sat" then true
      else raise Server_exception
    | _ -> raise Server_exception

  let check_stand context f =
    let (_, res) = request QUERY_STAND_SMT2 (sprintf "%s,%s" context f) (!host) (!port) in
    match res with
    | r::[] -> 
      if r = "unsat" then false
      else if r = "sat" then true
      else raise Server_exception
    | _ -> raise Server_exception
    
  let check_ce name f =
    let (_, res) = request QUERY_SMT2_CE (sprintf "%s,%s" name f) (!host) (!port) in
    match res with
    | r::rs ->
      if r = "unsat" then (false,None)
      else if r = "sat" then 
      	begin
      		let [ce]=rs in
      	(*	let ()=print_endline ce in*)
      		(true, Some(ce))
      	end
      else raise Server_exception
    | _ -> raise Server_exception

  let check_stand_ce context f =
    let (_, res) = request QUERY_STAND_SMT2_CE (sprintf "%s,%s" context f) (!host) (!port) in
    match res with
    | r::rs -> 
      if r = "unsat" then (false, None)
      else if r = "sat" then 
      	begin
      		let [ce]=rs in
      		(*let ()=print_endline ce in*)
      		(true, Some(ce))
      	end
      else raise Server_exception
    | _ -> raise Server_exception

	(*let apply eqPair   dict=
		let (vn,vval)=eqPair in
		let ()= Core.Std.Hashtbl.replace dict ~key:vn ~data:vval in 
		dict

	let rec applyEqs eqPairs   	dict=
 	match refs with 
 	[] -> dict
 	|eqPair:eqPairs0 ->
 		let dict1=apply eqPair   dict in 
		 applyEqs eqPairs0 	dict1*)
(*open Char*)




 let getCE varName2Vars eqPairs (*exclusiveNames*)=	  
	let getOneEq eq=
		let (varName, val0)=eq in
		(*let ()=print_endline ("varName:="^varName) in*)
		(*if (List.mem varName exclusiveNames) then []
		else *)
			begin let ocmval0=if (val0 ="True") 
						then (Paramecium.Const(Boolc(true)))
						else 
						begin
							if (val0 ="False") 
							then (Paramecium.Const(Boolc(false)))
							else 
								begin try Paramecium.Const((Intc(int_of_string val0 ) ))		with 
								| _ -> (Paramecium.Const(Strc(val0)))
								end
            end
						(*else if (Char.code('0')<=Char.code(val0.[0]) & Char.code(val0.[0])<=Char.code('9'))
						then (Paramecium.Const(Int32.of_string  )))
						else (Paramecium.Const(Strc(val0)))*) in
	       	match Core.Std.Hashtbl.find   varName2Vars varName with
			    |Some(v) -> [Paramecium.Eqn(Var(v), ocmval0)]
			    |None -> [] 
				end in
	let eqs=List.concat (List.map ~f:getOneEq eqPairs) in
		Paramecium.andList eqs
		
  
 let check_allce name f varName2Vars (*exclusiveNames*)=
    
	let rec chk curf ces=
				let (_, res) = request QUERY_SMT2_CE (sprintf "%s,%s" name curf) (!host) (!port) in
				  match res with
    			| r::rs ->
     				 if r = "unsat" then ces
    				 else if r = "sat" then 
      				begin
      					let ce =String.concat ~sep:"," rs in
      					let ()=print_endline ce in
								let eqPairs=GetModelString.readCeFromStr ce in
									match eqPairs with 
									|[]->[Paramecium.Chaos]
									|_->
										let cexf=getCE   varName2Vars  eqPairs in
										let ()=print_endline "ce\n" in
										let ()=print_endline (ToStr.Another1Smt2.form_of (Paramecium.neg cexf)) in 
      							 chk (String.concat ~sep:"\n" [curf; (ToStr.Another1Smt2.form_of (Paramecium.neg cexf))]) (cexf::ces)  
										(*[cexf]*)
									
      		    end
            else raise Server_exception
          | _ -> raise Server_exception   in

	let (_, res) = request QUERY_SMT2_CE (sprintf "%s,%s" name f) (!host) (!port) in
				  match res with
    			| r::rs ->
						(*let ()=print_endline r in*)
     				 if r = "unsat" then (false,None)
    				 else
								begin if r = "sat" then 
								let result= chk f [] in

								(true,Some(result))
								else raise Server_exception
								end
							
          | _ -> raise Server_exception 

 (* let check_stand_allce context f varName2Vars=
		let rec chk curf ces=
				let (_, res) =   request QUERY_STAND_SMT2_CE (sprintf "%s,%s" context f) (!host) (!port) in
				  match res with
    			| r::rs ->
     				 if r = "unsat" then ces
    				 else if r = "sat" then 
      				begin
      					let [ce]=rs in
      					let ()=print_endline ce in
								let eqPairs=GetModelString.readCeFromStr ce in
								let cexf=getCE   varName2Vars  eqPairs in
      						chk (String.concat ~sep:"\n" [curf; (ToStr.Smt2.form_of (Paramecium.neg cexf))]) (cexf::ces) 
									
      		    end
            else raise Server_exception
          | _ -> raise Server_exception   in
	let result= chk f [] in
		result*)
	

    
end

