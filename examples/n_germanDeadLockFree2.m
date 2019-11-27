const

  NODE_NUM : 3;
  DATA_NUM : 2;

type

  NODE : 1..NODE_NUM;
  DATA : 1..DATA_NUM;

  CACHE_STATE : enum {I, S, E};
  CACHE : record State : CACHE_STATE; Data : DATA; end;

  MSG1  : enum {Empty1, ReqS1, ReqE1 };
	MSG2   : enum {Empty2, Inv2, GntS2, GntE2 };	
	MSG3  : enum {Empty3,  InvAck3 };
	MSG1_CMD: record Cmd:MSG1 end;
	MSG2_DATA : record Cmd : MSG2; Data : DATA; end;
  MSG3_DATA : record Cmd : MSG3; Data : DATA; end;
	MSG_CMD:  enum {Empty, ReqS, ReqE };

var

  Cache : array [NODE] of CACHE;
  Chan1 : array [NODE] of MSG1_CMD;   
  Chan2 : array [NODE] of MSG2_DATA;      
  Chan3 : array [NODE] of MSG3_DATA;     
  InvSet : array [NODE] of boolean;  
  ShrSet : array [NODE] of boolean; 
  ExGntd : boolean;   
  CurCmd : MSG_CMD;  
  CurPtr : NODE;   
  MemData : DATA;  
  AuxData : DATA;


ruleset d : DATA do startstate "Init"
  for i : NODE do
    Chan1[i].Cmd := Empty1; Chan2[i].Cmd := Empty2; Chan3[i].Cmd := Empty3;
    Cache[i].State := I; InvSet[i] := false; ShrSet[i] := false;
  end;
  ExGntd := false; CurCmd := Empty; MemData := d; AuxData := d;
endstartstate; endruleset;


ruleset i : NODE; d : DATA do rule "Store"
  Cache[i].State = E
==> begin
  Cache[i].Data := d; AuxData := d;
endrule; endruleset;

ruleset i : NODE do rule "SendReqS"
  Chan1[i].Cmd = Empty1 & Cache[i].State = I
==> begin
  Chan1[i].Cmd := ReqS1;
endrule; endruleset;

ruleset i : NODE do rule "SendReqE"
  Chan1[i].Cmd = Empty1 & (Cache[i].State = I | Cache[i].State = S)
==> begin
  Chan1[i].Cmd := ReqE1;
endrule; endruleset;

ruleset i : NODE do rule "RecvReqS"
  CurCmd = Empty & Chan1[i].Cmd = ReqS1
==> begin
  CurCmd := ReqS; CurPtr := i; Chan1[i].Cmd := Empty1;
  for j : NODE do InvSet[j] := ShrSet[j]; end;
endrule; endruleset;

ruleset i : NODE do rule "RecvReqE"
  CurCmd = Empty & Chan1[i].Cmd = ReqE1
==> begin
  CurCmd := ReqE; CurPtr := i; Chan1[i].Cmd := Empty1;
  for j : NODE do InvSet[j] := ShrSet[j]; end;
endrule; endruleset;

ruleset i : NODE do rule "SendInv"
  Chan2[i].Cmd = Empty2 & InvSet[i] = true &
  ( CurCmd = ReqE | CurCmd = ReqS & ExGntd = true )
==> begin
  Chan2[i].Cmd := Inv2; InvSet[i] := false;
endrule; endruleset;



ruleset i : NODE do rule "SendInvAck"
  Chan2[i].Cmd = Inv2 & Chan3[i].Cmd = Empty3
==> begin
  Chan2[i].Cmd := Empty2; Chan3[i].Cmd := InvAck3;
  if (Cache[i].State = E) then Chan3[i].Data := Cache[i].Data; end;
  Cache[i].State := I;
endrule; endruleset;

ruleset i : NODE do rule "RecvInvAck"
  Chan3[i].Cmd = InvAck3 & CurCmd != Empty
==> begin
  Chan3[i].Cmd := Empty3; ShrSet[i] := false;
  if (ExGntd = true)
  then ExGntd := false; MemData := Chan3[i].Data; end;
endrule; endruleset;

ruleset i : NODE do rule "SendGntS"
  CurCmd = ReqS & CurPtr = i & Chan2[i].Cmd = Empty2 & ExGntd = false
==> begin
  Chan2[i].Cmd := GntS2; Chan2[i].Data := MemData; ShrSet[i] := true;
  CurCmd := Empty;
endrule; endruleset;

ruleset i : NODE do rule "SendGntE"
  CurCmd = ReqE & CurPtr = i & Chan2[i].Cmd = Empty2 & ExGntd = false &
  forall j : NODE do ShrSet[j] = false end
==> begin
  Chan2[i].Cmd := GntE2; Chan2[i].Data := MemData; ShrSet[i] := true;
  ExGntd := true; CurCmd := Empty;
endrule; endruleset;

ruleset i : NODE do rule "RecvGntS"
  Chan2[i].Cmd = GntS2
==> begin
  Cache[i].State := S; Cache[i].Data := Chan2[i].Data;
  Chan2[i].Cmd := Empty2;
endrule; endruleset;

ruleset i : NODE do rule "RecvGntE"
  Chan2[i].Cmd = GntE2
==> begin
  Cache[i].State := E; Cache[i].Data := Chan2[i].Data;
  Chan2[i].Cmd := Empty2;
endrule; endruleset;


ruleset i: NODE; j: NODE do
invariant "CntrlProp"
    i != j -> (Cache[i].State = E -> Cache[j].State = I) &
              (Cache[i].State = S -> Cache[j].State = I | Cache[j].State = S);
endruleset;

invariant "DataProp"
  ( ExGntd = false -> MemData = AuxData ) &
  forall i : NODE do Cache[i].State != I -> Cache[i].Data = AuxData end;


invariant "deadLockFree"
  exists i:NODE do 
	( Chan2[i].Cmd = GntE2)|
	Chan2[i].Cmd = GntS2 |
	(CurCmd = ReqE & CurPtr = i & Chan2[i].Cmd = Empty2 & ExGntd = false &
  forall j : NODE do ShrSet[j] = false end) |
	(CurCmd = ReqS & CurPtr = i & Chan2[i].Cmd = Empty2 & ExGntd = false)|
	(Chan3[i].Cmd = InvAck3 & CurCmd != Empty )|
	(Chan2[i].Cmd = Inv2 & Chan3[i].Cmd = Empty3)|
	(Chan2[i].Cmd = Empty2 & InvSet[i] = true &   ( CurCmd = ReqE | CurCmd = ReqS & ExGntd = true ))|
	(CurCmd = Empty & Chan1[i].Cmd = ReqE1)| 
	( CurCmd = Empty & Chan1[i].Cmd = ReqS1) |
	(Chan1[i].Cmd = Empty1 & (Cache[i].State = I | Cache[i].State = S))|
	(Chan1[i].Cmd = Empty1 & Cache[i].State = I)|
  Cache[i].State = E
 end;
































































































































































































































































