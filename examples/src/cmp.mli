 open Loach
	exception ParaNumErrors 
	exception OtherException	
	val cmpStrengthRule : formula list -> types:Paramecium.typedef list ->  int list -> rule*formula list -> (rule*formula list) option
	 
	val cmp: prop list->  types:Paramecium.typedef list -> Paramecium.paramref  -> int list -> ?unAbstractedParas:Paramecium.paramdef list  -> exp list ->rule ->(rule list* formula list) 
	
	val instantiatePr2Rules :	Paramecium.paramref ->  int list -> Paramecium.typedef list -> ?unAbstractedParas:Paramecium.paramdef list -> rule -> (Loach.rule * int list) list

	
	val cmpOnPrs: 	prop list->  types:Paramecium.typedef list -> Paramecium.paramref  -> int list -> 
	?unAbstractedReqs:(string * Paramecium.paramdef list) list   -> exp list->rule list ->(rule list* formula list)
	
	val properties2invs: Loach.prop list -> types:Paramecium.typedef list -> Paramecium.paramref -> Loach.formula list
	
	val initInvs: Loach.prop list ->  Paramecium.typedef list -> Paramecium.paramref->unit
	
	val setPrules: Loach.rule list -> unit
 
