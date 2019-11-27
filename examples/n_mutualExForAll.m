const clientNUMS : 3;
type state : enum{I, T, C, E};

     client: 1..clientNUMS;

var n : array [client] of state;

    x : boolean; 
    
ruleset i : client do
rule "Try" n[i] = I ==> begin
      n[i] := T;endrule; 

rule "Crit"
      n[i] = T& x = true ==>begin
      n[i] := C; x := false; endrule;

rule "Exit"
      n[i] = C ==>begin
      n[i] := E;endrule;
      
 
rule "Idle"
      n[i] = E ==> begin n[i] := I;
      x := true;endrule;
endruleset;

startstate
begin
 for i: client do
    n[i] := I; 
  endfor;
  x := true;
endstartstate;

ruleset i:client  do
invariant "coherence"
  (x=true -> forall j:client do n[j] != C endforall );
endruleset;

ruleset i:client  do
invariant "coherence1"
  (x=false -> exists j:client do n[j] = C | n[j]=E endexists );
endruleset;
