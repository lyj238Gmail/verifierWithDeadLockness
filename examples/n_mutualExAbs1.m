const 
      NODENUMS : 2;
	dataNums: 2;
			
type 
     state : enum{I, T, C, E};

     DATA: 1..dataNums;

     status : record st:state; data: DATA; end;
     
     NODE: 1..NODENUMS;

var n : array [NODE] of status;

    x : boolean; 
    
    auxDATA : DATA;
    
    memDATA: DATA;
    

ruleset i : NODE do
rule "Try" 
      n[i].st = I 
==>
begin
      n[i].st := T;
endrule;endruleset;


ruleset i : NODE do
rule "Crit"
      n[i].st = T & 
      x = true 
==>
begin
      n[i].st := C; x := false; 
      n[i].data := memDATA; 
endrule;endruleset;


ruleset i : NODE do
rule "Exit"
      n[i].st = C 
==>
begin
      n[i].st := E;
endrule;endruleset;
      
 
ruleset i : NODE do
rule "Idle"
      n[i].st = E 
==>
begin 
      n[i].st := I;
      x := true; 
      memDATA := n[i].data; 
endrule;endruleset;

ruleset i : NODE; data : DATA do rule "Store"
	n[i].st = C
==>
begin
      n[i].st := C; 
      x := false; 
      auxDATA := data; 
      n[i].data := data; 
endrule;endruleset;    


rule "ABS_Crit"
  x = true
==>
begin
x := false;
endrule;



rule "ABS_Idle"
  forall j : NODE do 
    n[j].st != C &
    n[j].st != E 
  end
==>
begin
x := true;
 memDATA := auxDATA;
endrule;



ruleset data: DATA do rule "ABS_Store"
  forall j : NODE do 
    n[j].st != C &
    n[j].st != E 
  end
==>
begin
	x := false;
 auxDATA := data;
endrule;endruleset;

ruleset d : DATA do 
startstate
begin
 for i: NODE do
    n[i].st := I; 
    n[i].data:=d;
  endfor;
  x := true;
  auxDATA := d;
  memDATA:=d;
endstartstate;
endruleset;


ruleset i: NODE; j: NODE do
invariant "coherence"
  i != j -> (n[i].st = C -> n[j].st != C);
endruleset;

ruleset i:NODE  do 
invariant "inv1"
  (n[i].st= C -> n[i].data =auxDATA);
endruleset;
 
ruleset i:NODE  do 
invariant "inv2"
  n[i].st = E -> n[i].data = auxDATA
endruleset;

ruleset i:NODE; j:NODE  do 
invariant "inv3"
  i != j ->( n[i].st = C -> n[j].st != E )
endruleset;

ruleset i: NODE; j: NODE do
invariant "inv4"
  i != j ->(n[i].st = E -> n[j].st != E)
endruleset;

ruleset i: NODE; j: NODE do
invariant "inv5"
 i != j ->( n[i].st = E -> n[j].st != C)
endruleset;

ruleset i: NODE  do
invariant "inv6"   
	 ( x = true -> memDATA = auxDATA )
endruleset;
