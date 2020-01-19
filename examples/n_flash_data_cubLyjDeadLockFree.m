
const

  NODE_NUM : 2;
  DATA_NUM : 2;

type

  NODE : 1..NODE_NUM;
  DATA : 1..DATA_NUM;

  CACHE_STATE : enum {CACHE_I, CACHE_S, CACHE_E};

  NODE_CMD : enum {NODE_None, NODE_Get, NODE_GetX};

  NODE_STATE : record
    ProcCmd : NODE_CMD;
    InvMarked : boolean;
    CacheState : CACHE_STATE;
    CacheData : DATA;
  end;

  DIR_STATE : record
    Pending : boolean;
    Local : boolean;
    Dirty : boolean;
    HeadVld : boolean;
    HeadPtr : NODE;
    HomeHeadPtr : boolean;
    ShrVld : boolean;
    ShrSet : array [NODE] of boolean;
    HomeShrSet : boolean;
    InvSet : array [NODE] of boolean;
    HomeInvSet : boolean;
  end;

  UNI_CMD : enum {UNI_None, UNI_Get, UNI_GetX, UNI_Put, UNI_PutX, UNI_Nak};

  UNI_MSG : record
    Cmd : UNI_CMD;
    Proc : NODE;
    HomeProc : boolean;
    Data : DATA;
  end;

  INV_CMD : enum {INV_None, INV_Inv, INV_InvAck};

  INV_MSG : record
    Cmd : INV_CMD;
  end;

  RP_CMD : enum {RP_None, RP_Replace};

  RP_MSG : record
    Cmd : RP_CMD;
  end;

  WB_CMD : enum {WB_None, WB_Wb};

  WB_MSG : record
    Cmd : WB_CMD;
    Proc : NODE;
    HomeProc : boolean;
    Data : DATA;
  end;

  SHWB_CMD : enum {SHWB_None, SHWB_ShWb, SHWB_FAck};

  SHWB_MSG : record
    Cmd : SHWB_CMD;
    Proc : NODE;
    HomeProc : boolean;
    Data : DATA;
  end;

  NAKC_CMD : enum {NAKC_None, NAKC_Nakc};

  NAKC_MSG : record
    Cmd : NAKC_CMD;
  end;

  STATE : record
    Proc : array [NODE] of NODE_STATE;
    HomeProc : NODE_STATE;
    Dir : DIR_STATE;
    MemData : DATA;
    UniMsg : array [NODE] of UNI_MSG;
    HomeUniMsg : UNI_MSG;
    InvMsg : array [NODE] of INV_MSG;
    HomeInvMsg : INV_MSG;
    RpMsg : array [NODE] of RP_MSG;
    HomeRpMsg : RP_MSG;
    WbMsg : WB_MSG;
    ShWbMsg : SHWB_MSG;
    NakcMsg : NAKC_MSG;
    CurrData : DATA;
  end;

var

  Sta : STATE;


ruleset h : NODE; d : DATA do
startstate "Init"
  Sta.MemData := d;
  Sta.Dir.Pending := false;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := false;
  Sta.Dir.HeadVld := false;
  Sta.Dir.HeadPtr := h;
  Sta.Dir.HomeHeadPtr := true;
  Sta.Dir.ShrVld := false;
  Sta.WbMsg.Cmd := WB_None;
  Sta.WbMsg.Proc := h;
  Sta.WbMsg.HomeProc := true;
  Sta.WbMsg.Data := d;
  Sta.ShWbMsg.Cmd := SHWB_None;
  Sta.ShWbMsg.Proc := h;
  Sta.ShWbMsg.HomeProc := true;
  Sta.ShWbMsg.Data := d;
  Sta.NakcMsg.Cmd := NAKC_None;
  for p : NODE do
    Sta.Proc[p].ProcCmd := NODE_None;
    Sta.Proc[p].InvMarked := false;
    Sta.Proc[p].CacheState := CACHE_I;
    Sta.Proc[p].CacheData := d;
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
    Sta.UniMsg[p].Cmd := UNI_None;
    Sta.UniMsg[p].Proc := h;
    Sta.UniMsg[p].HomeProc := true;
    Sta.UniMsg[p].Data := d;
    Sta.InvMsg[p].Cmd := INV_None;
    Sta.RpMsg[p].Cmd := RP_None;
  end;
  Sta.HomeProc.ProcCmd := NODE_None;
  Sta.HomeProc.InvMarked := false;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.CacheData := d;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeUniMsg.Cmd := UNI_None;
  Sta.HomeUniMsg.Proc := h;
  Sta.HomeUniMsg.HomeProc := true;
  Sta.HomeUniMsg.Data := d;
  Sta.HomeInvMsg.Cmd := INV_None;
  Sta.HomeRpMsg.Cmd := RP_None;
  Sta.CurrData := d;
endstartstate;
endruleset;


ruleset src : NODE; data : DATA do
rule "Store"
  Sta.Proc[src].CacheState = CACHE_E
==>
begin
  Sta.Proc[src].CacheData := data;
  Sta.CurrData := data;
endrule;
endruleset;

ruleset data : DATA do
rule "Store_Home"
  Sta.HomeProc.CacheState = CACHE_E
==>
begin
  Sta.HomeProc.CacheData := data;
  Sta.CurrData := data;
endrule;
endruleset;

ruleset src : NODE do
rule "PI_Remote_Get"
  Sta.Proc[src].ProcCmd = NODE_None &
  Sta.Proc[src].CacheState = CACHE_I
==>
begin
  Sta.Proc[src].ProcCmd := NODE_Get;
  Sta.UniMsg[src].Cmd := UNI_Get;
  Sta.UniMsg[src].HomeProc := true;
endrule;
endruleset;

rule "PI_Local_Get_Get"
  Sta.HomeProc.ProcCmd = NODE_None &
  Sta.HomeProc.CacheState = CACHE_I &
  !Sta.Dir.Pending & Sta.Dir.Dirty
==>
begin
  Sta.HomeProc.ProcCmd := NODE_Get;
  Sta.Dir.Pending := true;
  Sta.HomeUniMsg.Cmd := UNI_Get;
  Sta.HomeUniMsg.Proc := Sta.Dir.HeadPtr;
  Sta.HomeUniMsg.HomeProc := Sta.Dir.HomeHeadPtr;
endrule;

rule "PI_Local_Get_Put"
  Sta.HomeProc.ProcCmd = NODE_None &
  Sta.HomeProc.CacheState = CACHE_I &
  !Sta.Dir.Pending & !Sta.Dir.Dirty
==>
begin
  Sta.Dir.Local := true;
  Sta.HomeProc.ProcCmd := NODE_None;
  if (Sta.HomeProc.InvMarked) then
    Sta.HomeProc.InvMarked := false;
    Sta.HomeProc.CacheState := CACHE_I;
  else
    Sta.HomeProc.CacheState := CACHE_S;
    Sta.HomeProc.CacheData := Sta.MemData;
  end;
endrule;

ruleset src : NODE do
rule "PI_Remote_GetX"
  Sta.Proc[src].ProcCmd = NODE_None &
  Sta.Proc[src].CacheState = CACHE_I
==>
begin
  Sta.Proc[src].ProcCmd := NODE_GetX;
  Sta.UniMsg[src].Cmd := UNI_GetX;
  Sta.UniMsg[src].HomeProc := true;
endrule;
endruleset;

rule "PI_Local_GetX_GetX"
  Sta.HomeProc.ProcCmd = NODE_None &
  ( Sta.HomeProc.CacheState = CACHE_I |
    Sta.HomeProc.CacheState = CACHE_S ) &
  !Sta.Dir.Pending & Sta.Dir.Dirty
==>
begin
  Sta.HomeProc.ProcCmd := NODE_GetX;
  Sta.Dir.Pending := true;
  Sta.HomeUniMsg.Cmd := UNI_GetX;
  Sta.HomeUniMsg.Proc := Sta.Dir.HeadPtr;
  Sta.HomeUniMsg.HomeProc := Sta.Dir.HomeHeadPtr;
endrule;

rule "PI_Local_GetX_PutX_HeadVld"
  Sta.HomeProc.ProcCmd = NODE_None &
  ( Sta.HomeProc.CacheState = CACHE_I |
    Sta.HomeProc.CacheState = CACHE_S ) &
  !Sta.Dir.Pending & !Sta.Dir.Dirty & Sta.Dir.HeadVld
==>
begin
  Sta.Dir.Local := true;
  Sta.Dir.Dirty := true;

  Sta.Dir.Pending := true;
  Sta.Dir.HeadVld := false;
  Sta.Dir.ShrVld := false;

  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;

  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.HomeProc.ProcCmd := NODE_None;
  Sta.HomeProc.InvMarked := false;
  Sta.HomeProc.CacheState := CACHE_E;
  Sta.HomeProc.CacheData := Sta.MemData;
endrule;

rule "PI_Local_GetX_PutX"
  Sta.HomeProc.ProcCmd = NODE_None &
  ( Sta.HomeProc.CacheState = CACHE_I |
    Sta.HomeProc.CacheState = CACHE_S ) &
  !Sta.Dir.Pending & !Sta.Dir.Dirty & !Sta.Dir.HeadVld
==>
begin
  Sta.Dir.Local := true;
  Sta.Dir.Dirty := true;

  Sta.HomeProc.ProcCmd := NODE_None;
  Sta.HomeProc.InvMarked := false;
  Sta.HomeProc.CacheState := CACHE_E;
  Sta.HomeProc.CacheData := Sta.MemData;
endrule;

ruleset dst : NODE do
rule "PI_Remote_PutX"
  Sta.Proc[dst].ProcCmd = NODE_None &
  Sta.Proc[dst].CacheState = CACHE_E
==>
begin
  Sta.Proc[dst].CacheState := CACHE_I;
  Sta.WbMsg.Cmd := WB_Wb;
  Sta.WbMsg.Proc := dst;
  Sta.WbMsg.HomeProc := false;
  Sta.WbMsg.Data := Sta.Proc[dst].CacheData;
endrule;
endruleset;

rule "PI_Local_PutX"
  Sta.HomeProc.ProcCmd = NODE_None &
  Sta.HomeProc.CacheState = CACHE_E
==>
begin
  if (Sta.Dir.Pending) then
    Sta.HomeProc.CacheState := CACHE_I;
    Sta.Dir.Dirty := false;
    Sta.MemData := Sta.HomeProc.CacheData;
  else
    Sta.HomeProc.CacheState := CACHE_I;
    Sta.Dir.Local := false;
    Sta.Dir.Dirty := false;
    Sta.MemData := Sta.HomeProc.CacheData;
  end;
endrule;

ruleset src : NODE do
rule "PI_Remote_Replace"
  Sta.Proc[src].ProcCmd = NODE_None &
  Sta.Proc[src].CacheState = CACHE_S
==>
begin
  Sta.Proc[src].CacheState := CACHE_I;
  Sta.RpMsg[src].Cmd := RP_Replace;
endrule;
endruleset;

rule "PI_Local_Replace"
  Sta.HomeProc.ProcCmd = NODE_None &
  Sta.HomeProc.CacheState = CACHE_S
==>
begin
  Sta.Dir.Local := false;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;

ruleset dst : NODE do
rule "NI_Nak"
  Sta.UniMsg[dst].Cmd = UNI_Nak
==>
begin
  Sta.UniMsg[dst].Cmd := UNI_None;
  Sta.Proc[dst].ProcCmd := NODE_None;
  Sta.Proc[dst].InvMarked := false;
endrule;
endruleset;

rule "NI_Nak_Home"
  Sta.HomeUniMsg.Cmd = UNI_Nak
==>
begin
  Sta.HomeUniMsg.Cmd := UNI_None;
  Sta.HomeProc.ProcCmd := NODE_None;
  Sta.HomeProc.InvMarked := false;
endrule;

rule "NI_Nak_Clear"
  Sta.NakcMsg.Cmd = NAKC_Nakc
==>
begin
  Sta.NakcMsg.Cmd := NAKC_None;
  Sta.Dir.Pending := false;
endrule;

ruleset src : NODE do
rule "NI_Local_Get_Nak"
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].HomeProc &
  Sta.RpMsg[src].Cmd != RP_Replace &
  ( Sta.Dir.Pending |
    Sta.Dir.Dirty & Sta.Dir.Local & Sta.HomeProc.CacheState != CACHE_E |
    Sta.Dir.Dirty & !Sta.Dir.Local & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr)
==>
begin
  Sta.UniMsg[src].Cmd := UNI_Nak;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_Get_Get"
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].HomeProc &
  Sta.RpMsg[src].Cmd != RP_Replace &
  !Sta.Dir.Pending & Sta.Dir.Dirty & !Sta.Dir.Local &
  (Sta.Dir.HeadPtr != src | Sta.Dir.HomeHeadPtr)
==>
begin
  Sta.Dir.Pending := true;
  Sta.UniMsg[src].Cmd := UNI_Get;
  Sta.UniMsg[src].Proc := Sta.Dir.HeadPtr;
  Sta.UniMsg[src].HomeProc := Sta.Dir.HomeHeadPtr;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_Get_Put_Head"
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].HomeProc &
  Sta.RpMsg[src].Cmd != RP_Replace &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld
==>
begin
  Sta.Dir.ShrVld := true;
  Sta.Dir.ShrSet[src] := true;
  for p : NODE do
    if (p = src)  then
      Sta.Dir.InvSet[p] := true;
    else
      Sta.Dir.InvSet[p] := Sta.Dir.ShrSet[p];
    end;
  end;
  Sta.Dir.HomeInvSet := Sta.Dir.HomeShrSet;
  Sta.UniMsg[src].Cmd := UNI_Put;
  Sta.UniMsg[src].Data := Sta.MemData;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_Get_Put"
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].HomeProc &
  Sta.RpMsg[src].Cmd != RP_Replace &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & !Sta.Dir.HeadVld
==>
begin
    Sta.Dir.HeadVld := true;
    Sta.Dir.HeadPtr := src;
    Sta.Dir.HomeHeadPtr := false;
    Sta.UniMsg[src].Cmd := UNI_Put;
    Sta.UniMsg[src].Data := Sta.MemData;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_Get_Put_Dirty"
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].HomeProc &
  Sta.RpMsg[src].Cmd != RP_Replace &
  !Sta.Dir.Pending &
  Sta.Dir.Dirty & Sta.Dir.Local & Sta.HomeProc.CacheState = CACHE_E
==>
begin
  Sta.Dir.Dirty := false;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.MemData := Sta.HomeProc.CacheData;
  Sta.HomeProc.CacheState := CACHE_S;
  Sta.UniMsg[src].Cmd := UNI_Put;
  Sta.UniMsg[src].Data := Sta.HomeProc.CacheData;
endrule;
endruleset;

ruleset src : NODE; dst : NODE do
rule "NI_Remote_Get_Nak"
  src != dst &
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].Proc = dst & !Sta.UniMsg[src].HomeProc &
  Sta.Proc[dst].CacheState != CACHE_E
==>
begin
  Sta.UniMsg[src].Cmd := UNI_Nak;
  Sta.NakcMsg.Cmd := NAKC_Nakc;
endrule;
endruleset;

ruleset dst : NODE do
rule "NI_Remote_Get_Nak_Home"
  Sta.HomeUniMsg.Cmd = UNI_Get &
  Sta.HomeUniMsg.Proc = dst & !Sta.HomeUniMsg.HomeProc &
  Sta.Proc[dst].CacheState != CACHE_E
==>
begin
  Sta.HomeUniMsg.Cmd := UNI_Nak;
  Sta.NakcMsg.Cmd := NAKC_Nakc;
endrule;
endruleset;

ruleset src : NODE; dst : NODE do
rule "NI_Remote_Get_Put"
  src != dst &
  Sta.UniMsg[src].Cmd = UNI_Get &
  Sta.UniMsg[src].Proc = dst & !Sta.UniMsg[src].HomeProc &
  Sta.Proc[dst].CacheState = CACHE_E
==>
begin
  Sta.Proc[dst].CacheState := CACHE_S;
  Sta.UniMsg[src].Cmd := UNI_Put;
  Sta.UniMsg[src].Data := Sta.Proc[dst].CacheData;
  Sta.ShWbMsg.Cmd := SHWB_ShWb;
  Sta.ShWbMsg.Proc := src;
  Sta.ShWbMsg.HomeProc := false;
  Sta.ShWbMsg.Data := Sta.Proc[dst].CacheData;
endrule;
endruleset;

ruleset dst : NODE do
rule "NI_Remote_Get_Put_Home"
  Sta.HomeUniMsg.Cmd = UNI_Get &
  Sta.HomeUniMsg.Proc = dst & !Sta.HomeUniMsg.HomeProc &
  Sta.Proc[dst].CacheState = CACHE_E
==>
begin
  Sta.Proc[dst].CacheState := CACHE_S;
  Sta.HomeUniMsg.Cmd := UNI_Put;
  Sta.HomeUniMsg.Data := Sta.Proc[dst].CacheData;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_Nak"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  ( Sta.Dir.Pending |
    Sta.Dir.Dirty & Sta.Dir.Local & Sta.HomeProc.CacheState != CACHE_E |
    Sta.Dir.Dirty & !Sta.Dir.Local & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr)
==>
begin
  Sta.UniMsg[src].Cmd := UNI_Nak;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_GetX"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending & Sta.Dir.Dirty & !Sta.Dir.Local &
  (Sta.Dir.HeadPtr != src | Sta.Dir.HomeHeadPtr)
==>
begin
  Sta.Dir.Pending := true;
  Sta.UniMsg[src].Cmd := UNI_GetX;
  Sta.UniMsg[src].Proc := Sta.Dir.HeadPtr;
  Sta.UniMsg[src].HomeProc := Sta.Dir.HomeHeadPtr;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_1"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & !Sta.Dir.HeadVld & Sta.Dir.Local & Sta.HomeProc.ProcCmd = NODE_Get
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.InvMarked := true;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_2"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & !Sta.Dir.HeadVld & Sta.Dir.Local & Sta.HomeProc.ProcCmd != NODE_Get
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_3"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & !Sta.Dir.HeadVld & !Sta.Dir.Local
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_4"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr & !Sta.Dir.HomeShrSet &
  forall p : NODE do p != src -> !Sta.Dir.ShrSet[p] end &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd = NODE_Get
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.InvMarked := true;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_5"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr & !Sta.Dir.HomeShrSet &
  forall p : NODE do p != src -> !Sta.Dir.ShrSet[p] end &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd != NODE_Get
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_6"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr & !Sta.Dir.HomeShrSet &
  forall p : NODE do p != src -> !Sta.Dir.ShrSet[p] end &
  !Sta.Dir.Local
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_7"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & (Sta.Dir.HeadPtr != src | Sta.Dir.HomeHeadPtr) &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd != NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_7_NODE_Get"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & (Sta.Dir.HeadPtr != src | Sta.Dir.HomeHeadPtr) &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd = NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.InvMarked := true;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_8_Home"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.HomeShrSet &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd != NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_8_Home_NODE_Get"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.HomeShrSet &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd = NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.InvMarked := true;
endrule;
endruleset;

ruleset src : NODE; pp : NODE do
rule "NI_Local_GetX_PutX_8"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.ShrSet[pp] &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd != NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE; pp : NODE do
rule "NI_Local_GetX_PutX_8_NODE_Get"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.ShrSet[pp] &
  Sta.Dir.Local & Sta.HomeProc.ProcCmd = NODE_Get
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
  Sta.HomeProc.CacheState := CACHE_I;
  Sta.HomeProc.InvMarked := true;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_9"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & (Sta.Dir.HeadPtr != src | Sta.Dir.HomeHeadPtr) &
  !Sta.Dir.Local
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_10_Home"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.HomeShrSet &
  !Sta.Dir.Local
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
endrule;
endruleset;

ruleset src : NODE; pp : NODE do
rule "NI_Local_GetX_PutX_10"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  !Sta.Dir.Dirty & Sta.Dir.HeadVld & Sta.Dir.HeadPtr = src & !Sta.Dir.HomeHeadPtr &
  Sta.Dir.ShrSet[pp] &
  !Sta.Dir.Local
==>
begin
  Sta.Dir.Pending := true;
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    if ( p != src &
         ( Sta.Dir.ShrVld & Sta.Dir.ShrSet[p] |
           Sta.Dir.HeadVld & Sta.Dir.HeadPtr = p & !Sta.Dir.HomeHeadPtr) ) then
      Sta.Dir.InvSet[p] := true;
      Sta.InvMsg[p].Cmd := INV_Inv;
    else
      Sta.Dir.InvSet[p] := false;
      Sta.InvMsg[p].Cmd := INV_None;
    end;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.HomeInvMsg.Cmd := INV_None;

  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.MemData;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_Local_GetX_PutX_11"
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].HomeProc &
  !Sta.Dir.Pending &
  Sta.Dir.Dirty & Sta.Dir.Local & Sta.HomeProc.CacheState = CACHE_E
==>
begin
  Sta.Dir.Local := false;
  Sta.Dir.Dirty := true;
  Sta.Dir.HeadVld := true;
  Sta.Dir.HeadPtr := src;
  Sta.Dir.HomeHeadPtr := false;
  Sta.Dir.ShrVld := false;
  for p : NODE do
    Sta.Dir.ShrSet[p] := false;
    Sta.Dir.InvSet[p] := false;
  end;
  Sta.Dir.HomeShrSet := false;
  Sta.Dir.HomeInvSet := false;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.HomeProc.CacheData;
  Sta.HomeProc.CacheState := CACHE_I;
endrule;
endruleset;

ruleset src : NODE; dst : NODE do
rule "NI_Remote_GetX_Nak"
  src != dst &
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].Proc = dst & !Sta.UniMsg[src].HomeProc &
  Sta.Proc[dst].CacheState != CACHE_E
==>
begin
  Sta.UniMsg[src].Cmd := UNI_Nak;
  Sta.NakcMsg.Cmd := NAKC_Nakc;
endrule;
endruleset;

ruleset dst : NODE do
rule "NI_Remote_GetX_Nak_Home"
  Sta.HomeUniMsg.Cmd = UNI_GetX &
  Sta.HomeUniMsg.Proc = dst & !Sta.HomeUniMsg.HomeProc &
  Sta.Proc[dst].CacheState != CACHE_E
==>
begin
  Sta.HomeUniMsg.Cmd := UNI_Nak;
  Sta.NakcMsg.Cmd := NAKC_Nakc;
endrule;
endruleset;

ruleset src : NODE; dst : NODE do
rule "NI_Remote_GetX_PutX"
  src != dst &
  Sta.UniMsg[src].Cmd = UNI_GetX &
  Sta.UniMsg[src].Proc = dst & !Sta.UniMsg[src].HomeProc &
  Sta.Proc[dst].CacheState = CACHE_E
==>
begin
  Sta.Proc[dst].CacheState := CACHE_I;
  Sta.UniMsg[src].Cmd := UNI_PutX;
  Sta.UniMsg[src].Data := Sta.Proc[dst].CacheData;
  Sta.ShWbMsg.Cmd := SHWB_FAck;
  Sta.ShWbMsg.Proc := src;
  Sta.ShWbMsg.HomeProc := false;
endrule;
endruleset;

ruleset dst : NODE do
rule "NI_Remote_GetX_PutX_Home"
  Sta.HomeUniMsg.Cmd = UNI_GetX &
  Sta.HomeUniMsg.Proc = dst & !Sta.HomeUniMsg.HomeProc &
  Sta.Proc[dst].CacheState = CACHE_E
==>
begin
  Sta.Proc[dst].CacheState := CACHE_I;
  Sta.HomeUniMsg.Cmd := UNI_PutX;
  Sta.HomeUniMsg.Data := Sta.Proc[dst].CacheData;
endrule;
endruleset;

rule "NI_Local_Put"
  Sta.HomeUniMsg.Cmd = UNI_Put
==>
begin
  Sta.HomeUniMsg.Cmd := UNI_None;
  Sta.Dir.Pending := false;
  Sta.Dir.Dirty := false;
  Sta.Dir.Local := true;
  Sta.MemData := Sta.HomeUniMsg.Data;
  Sta.HomeProc.ProcCmd := NODE_None;
  if (Sta.HomeProc.InvMarked) then
    Sta.HomeProc.InvMarked := false;
    Sta.HomeProc.CacheState := CACHE_I;
  else
    Sta.HomeProc.CacheState := CACHE_S;
    Sta.HomeProc.CacheData := Sta.HomeUniMsg.Data;
  end;
endrule;

ruleset dst : NODE do
rule "NI_Remote_Put"
  Sta.UniMsg[dst].Cmd = UNI_Put
==>
begin
  Sta.UniMsg[dst].Cmd := UNI_None;
  Sta.Proc[dst].ProcCmd := NODE_None;
  if (Sta.Proc[dst].InvMarked) then
    Sta.Proc[dst].InvMarked := false;
    Sta.Proc[dst].CacheState := CACHE_I;
  else
    Sta.Proc[dst].CacheState := CACHE_S;
    Sta.Proc[dst].CacheData := Sta.UniMsg[dst].Data;
  end;
endrule;
endruleset;

rule "NI_Local_PutXAcksDone"
  Sta.HomeUniMsg.Cmd = UNI_PutX
==>
begin
  Sta.HomeUniMsg.Cmd := UNI_None;
  Sta.Dir.Pending := false;
  Sta.Dir.Local := true;
  Sta.Dir.HeadVld := false;
  Sta.HomeProc.ProcCmd := NODE_None;
  Sta.HomeProc.InvMarked := false;
  Sta.HomeProc.CacheState := CACHE_E;
  Sta.HomeProc.CacheData := Sta.HomeUniMsg.Data;
endrule;

ruleset dst : NODE do
rule "NI_Remote_PutX"
  Sta.UniMsg[dst].Cmd = UNI_PutX &
  Sta.Proc[dst].ProcCmd = NODE_GetX
==>
begin
  Sta.UniMsg[dst].Cmd := UNI_None;
  Sta.Proc[dst].ProcCmd := NODE_None;
  Sta.Proc[dst].InvMarked := false;
  Sta.Proc[dst].CacheState := CACHE_E;
  Sta.Proc[dst].CacheData := Sta.UniMsg[dst].Data;
endrule;
endruleset;

ruleset dst : NODE do
rule "NI_Inv"
  Sta.InvMsg[dst].Cmd = INV_Inv
==>
begin
  Sta.InvMsg[dst].Cmd := INV_InvAck;
  Sta.Proc[dst].CacheState := CACHE_I;
  if (Sta.Proc[dst].ProcCmd = NODE_Get) then
    Sta.Proc[dst].InvMarked := true;
  end;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_InvAck_exists_Home"
  Sta.InvMsg[src].Cmd = INV_InvAck &
  Sta.Dir.Pending & Sta.Dir.InvSet[src] &
  Sta.Dir.HomeInvSet
==>
begin
  Sta.InvMsg[src].Cmd := INV_None;
  Sta.Dir.InvSet[src] := false;
endrule;
endruleset;

ruleset src : NODE; pp : NODE do
rule "NI_InvAck_exists"
  Sta.InvMsg[src].Cmd = INV_InvAck &
  Sta.Dir.Pending & Sta.Dir.InvSet[src] &
  (pp != src & Sta.Dir.InvSet[pp])
==>
begin
  Sta.InvMsg[src].Cmd := INV_None;
  Sta.Dir.InvSet[src] := false;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_InvAck_1"
  Sta.InvMsg[src].Cmd = INV_InvAck &
  Sta.Dir.Pending & Sta.Dir.InvSet[src] &
  Sta.Dir.Local & !Sta.Dir.Dirty &
  !Sta.Dir.HomeInvSet & forall p : NODE do p = src | !Sta.Dir.InvSet[p] end
==>
begin
  Sta.InvMsg[src].Cmd := INV_None;
  Sta.Dir.InvSet[src] := false;
  Sta.Dir.Pending := false;
  Sta.Dir.Local := false;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_InvAck_2"
  Sta.InvMsg[src].Cmd = INV_InvAck &
  Sta.Dir.Pending & Sta.Dir.InvSet[src] &
  !Sta.Dir.Local &
  !Sta.Dir.HomeInvSet & forall p : NODE do p = src | !Sta.Dir.InvSet[p] end
==>
begin
  Sta.InvMsg[src].Cmd := INV_None;
  Sta.Dir.InvSet[src] := false;
  Sta.Dir.Pending := false;
endrule;
endruleset;

ruleset src : NODE do
rule "NI_InvAck_3"
  Sta.InvMsg[src].Cmd = INV_InvAck &
  Sta.Dir.Pending & Sta.Dir.InvSet[src] &
  Sta.Dir.Dirty &
  !Sta.Dir.HomeInvSet & forall p : NODE do p = src | !Sta.Dir.InvSet[p] end
==>
begin
  Sta.InvMsg[src].Cmd := INV_None;
  Sta.Dir.InvSet[src] := false;
  Sta.Dir.Pending := false;
endrule;
endruleset;

rule "NI_Wb"
  Sta.WbMsg.Cmd = WB_Wb
==>
begin
  Sta.WbMsg.Cmd := WB_None;
  Sta.Dir.Dirty := false;
  Sta.Dir.HeadVld := false;
  Sta.MemData := Sta.WbMsg.Data;
endrule;

rule "NI_FAck"
  Sta.ShWbMsg.Cmd = SHWB_FAck
==>
begin
  Sta.ShWbMsg.Cmd := SHWB_None;
  Sta.Dir.Pending := false;
  if (Sta.Dir.Dirty) then
    Sta.Dir.HeadPtr := Sta.ShWbMsg.Proc;
    Sta.Dir.HomeHeadPtr := Sta.ShWbMsg.HomeProc;
  end;
endrule;

rule "NI_ShWb"
  Sta.ShWbMsg.Cmd = SHWB_ShWb
==>
begin
  Sta.ShWbMsg.Cmd := SHWB_None;
  Sta.Dir.Pending := false;
  Sta.Dir.Dirty := false;
  Sta.Dir.ShrVld := true;
  for p : NODE do
    if (p = Sta.ShWbMsg.Proc & !Sta.ShWbMsg.HomeProc) | Sta.Dir.ShrSet[p] then
      Sta.Dir.ShrSet[p] := true;
      Sta.Dir.InvSet[p] := true;
    else
      Sta.Dir.ShrSet[p] := false;
      Sta.Dir.InvSet[p] := false;
    end;
  end;
  if (Sta.ShWbMsg.HomeProc | Sta.Dir.HomeShrSet) then
    Sta.Dir.HomeShrSet := true;
    Sta.Dir.HomeInvSet := true;
  else
    Sta.Dir.HomeShrSet := false;
    Sta.Dir.HomeInvSet := false;
  end;
  Sta.MemData := Sta.ShWbMsg.Data;
endrule;

ruleset src : NODE do
rule "NI_Replace"
  Sta.RpMsg[src].Cmd = RP_Replace
==>
begin
  Sta.RpMsg[src].Cmd := RP_None;
  if (Sta.Dir.ShrVld) then
    Sta.Dir.ShrSet[src] := false;
    Sta.Dir.InvSet[src] := false;
  end;
endrule;
endruleset;

rule "NI_Replace_Home"
  Sta.HomeRpMsg.Cmd = RP_Replace
==>
begin
  Sta.HomeRpMsg.Cmd := RP_None;
  if (Sta.Dir.ShrVld) then
    Sta.Dir.HomeShrSet := false;
    Sta.Dir.HomeInvSet := false;
  end;
endrule;


invariant "CacheStateProp"
  forall p : NODE do forall q : NODE do
    p != q ->
    !(Sta.Proc[p].CacheState = CACHE_E & Sta.Proc[q].CacheState = CACHE_E)
  end end;

invariant "CacheStatePropHome"
  forall p : NODE do
    !(Sta.Proc[p].CacheState = CACHE_E & Sta.HomeProc.CacheState = CACHE_E)
  end;

ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__3"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__4"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Proc[p__Inv0].CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__5"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeProc.CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__6"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.HomeProc.CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__7"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.Dirty = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__8"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeProc.CacheState = CACHE_S)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__9"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.HeadVld = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__10"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__11"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
invariant "inv__12"
  (!((Sta.Dir.HomeShrSet = true)));
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__13"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Dir.ShrSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__14"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.ShrSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__15"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.Local = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__16"
    (!((Sta.UniMsg[p__Inv1].Cmd = UNI_PutX) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__17"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__18"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__19"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
invariant "inv__20"
  (!((Sta.Dir.HeadVld = true) & (Sta.Dir.HomeHeadPtr = true)));
invariant "inv__21"
  (!((Sta.Dir.HeadVld = true) & (Sta.HomeProc.CacheState = CACHE_E)));
ruleset p__Inv0 : NODE do
  invariant "inv__22"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.HomeProc.CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__23"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.Dirty = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__24"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadVld = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__25"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__26"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__27"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__28"
    (!((Sta.HomeProc.CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
invariant "inv__29"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.ShWbMsg.HomeProc = true)));
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__30"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__31"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__32"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__33"
    (!((Sta.Dir.Local = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__34"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__35"
    (!((Sta.UniMsg[p__Inv0].Proc = 1) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__36"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__37"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.Dir.Dirty = true)));
endruleset;
invariant "inv__38"
  (!((Sta.HomeProc.CacheState = CACHE_S) & (Sta.Dir.Dirty = true)));
invariant "inv__39"
  (!((Sta.Dir.Pending = false) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
ruleset p__Inv0 : NODE do
  invariant "inv__40"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__41"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_GetX) & (Sta.HomeUniMsg.Proc = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__42"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
invariant "inv__43"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.ShWbMsg.HomeProc = true)));
invariant "inv__44"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.Dir.Dirty = false)));
ruleset p__Inv0 : NODE do
  invariant "inv__45"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.Dir.HeadVld = false)));
endruleset;
invariant "inv__46"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
ruleset p__Inv0 : NODE do
  invariant "inv__47"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__48"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__49"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
endruleset;
invariant "inv__50"
  (!((Sta.HomeProc.CacheState = CACHE_S) & (Sta.Dir.Local = false)));
ruleset p__Inv0 : NODE do
  invariant "inv__51"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
invariant "inv__52"
  (!((Sta.Dir.Pending = false) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
ruleset p__Inv0 : NODE do
  invariant "inv__53"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.HomeUniMsg.Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__54"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.Dirty = true)));
endruleset;
invariant "inv__55"
  (!((Sta.Dir.Pending = false) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
ruleset p__Inv0 : NODE do
  invariant "inv__56"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
invariant "inv__57"
  (!((Sta.Dir.Local = true) & (Sta.HomeProc.ProcCmd = NODE_Get)));
invariant "inv__58"
  (!((Sta.Dir.Local = true) & (Sta.HomeProc.ProcCmd = NODE_GetX)));
ruleset p__Inv0 : NODE do
  invariant "inv__59"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.Dir.HeadVld = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__60"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.Dir.ShrSet[p__Inv0] = false) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__61"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.HomeProc.CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__62"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.InvMsg[p__Inv0].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__63"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Local = false) & (Sta.InvMsg[p__Inv1].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__64"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__65"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__66"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__67"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
invariant "inv__68"
  (!((Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__69"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__70"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
ruleset p__Inv0 : NODE do
  invariant "inv__71"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.HomeUniMsg.Cmd = UNI_GetX) & (Sta.HomeUniMsg.Proc = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__72"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.Pending = false) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__73"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
endruleset;
invariant "inv__74"
  (!((Sta.Dir.Dirty = false) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__75"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.WbMsg.Cmd = WB_Wb)));
ruleset p__Inv0 : NODE do
  invariant "inv__76"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
invariant "inv__77"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.Dir.HeadVld = false)));
invariant "inv__78"
  (!((Sta.Dir.Pending = false) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
invariant "inv__79"
  (!((Sta.Dir.Pending = false) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
ruleset p__Inv0 : NODE do
  invariant "inv__80"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
invariant "inv__81"
  (!((Sta.Dir.HeadVld = false) & (Sta.WbMsg.Cmd = WB_Wb)));
invariant "inv__82"
  (!((Sta.WbMsg.Cmd = WB_Wb) & (Sta.Dir.Dirty = false)));
invariant "inv__83"
  (!((Sta.Dir.Local = true) & (Sta.WbMsg.Cmd = WB_Wb)));
ruleset p__Inv0 : NODE do
  invariant "inv__84"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.HomeProc.CacheState = CACHE_S)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__85"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__86"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
invariant "inv__87"
  (!((Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
invariant "inv__88"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
invariant "inv__89"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
ruleset p__Inv0 : NODE do
  invariant "inv__90"
    (!((Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__91"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.Dir.HeadVld = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__92"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.Dir.ShrSet[p__Inv0] = false) & (Sta.Dir.HeadPtr = 2) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__93"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__94"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__95"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__96"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__97"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__98"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
invariant "inv__99"
  (!((Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
invariant "inv__100"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
invariant "inv__101"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
ruleset p__Inv0 : NODE do
  invariant "inv__102"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
invariant "inv__103"
  (!((Sta.Dir.Pending = false) & (Sta.Dir.Local = true) & (Sta.HomeProc.CacheState = CACHE_I)));
ruleset p__Inv0 : NODE do
  invariant "inv__104"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.HeadVld = false) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
invariant "inv__105"
  (!((Sta.Dir.HeadVld = false) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
ruleset p__Inv0 : NODE do
  invariant "inv__106"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__107"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.Dir.HeadPtr = 2) & (Sta.RpMsg[p__Inv0].Cmd = RP_Replace)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__108"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.HeadPtr = 2) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
invariant "inv__109"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.ShWbMsg.Proc = 2) & (Sta.Dir.HeadPtr = 2)));
ruleset p__Inv0 : NODE do
  invariant "inv__110"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.HomeProc.CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
invariant "inv__111"
  (!((Sta.Dir.Local = false) & (Sta.HomeProc.CacheState = CACHE_E)));
ruleset p__Inv0 : NODE do
  invariant "inv__112"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.HomeProc.CacheState = CACHE_E) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__113"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.Proc[p__Inv0].CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__114"
    (!((Sta.Dir.Pending = false) & (Sta.InvMsg[p__Inv0].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__115"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Dir.Local = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__116"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
invariant "inv__117"
  (!((Sta.Dir.HomeInvSet = true)));
ruleset p__Inv0 : NODE do
  invariant "inv__118"
    (!((Sta.Dir.ShrVld = true) & (Sta.InvMsg[p__Inv0].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__119"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__120"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__121"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__122"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__123"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.HomeUniMsg.Cmd = UNI_PutX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__124"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.HomeUniMsg.Cmd = UNI_PutX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__125"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__126"
    (!((Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__127"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.HeadPtr = 2) & (Sta.InvMsg[p__Inv1].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__128"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__129"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.ShWbMsg.Proc = 2)));
endruleset;
invariant "inv__130"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__131"
  (!((Sta.WbMsg.Cmd = WB_Wb) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__132"
  (!((Sta.HomeProc.CacheState = CACHE_S) & (Sta.WbMsg.Cmd = WB_Wb)));
invariant "inv__133"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.WbMsg.Cmd = WB_Wb)));
invariant "inv__134"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
invariant "inv__135"
  (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
ruleset p__Inv0 : NODE do
  invariant "inv__136"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
invariant "inv__137"
  (!((Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
invariant "inv__138"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
invariant "inv__139"
  (!((Sta.WbMsg.Cmd = WB_Wb) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
ruleset p__Inv0 : NODE do
  invariant "inv__140"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.HomeProc.CacheState = CACHE_S)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__141"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__142"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.HomeUniMsg.Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
invariant "inv__143"
  (!((Sta.Dir.Pending = false) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
invariant "inv__144"
  (!((Sta.Dir.Pending = false) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
ruleset p__Inv0 : NODE do
  invariant "inv__145"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__146"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__147"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__148"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__149"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.HomeUniMsg.Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__150"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__151"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__152"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__153"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.RpMsg[p__Inv0].Cmd = RP_Replace)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__154"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__155"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.ShWbMsg.Proc = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__156"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Proc[p__Inv0].ProcCmd = NODE_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__157"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Proc[p__Inv0].ProcCmd = NODE_None)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__158"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__159"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__160"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__161"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__162"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__163"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.HomeUniMsg.Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__164"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.HomeUniMsg.Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__165"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
invariant "inv__166"
  (!((Sta.Dir.Local = true) & (Sta.Dir.Dirty = true) & (Sta.HomeProc.CacheState = CACHE_I)));
invariant "inv__167"
  (!((Sta.HomeProc.InvMarked = true)));
invariant "inv__168"
  (!((Sta.Dir.Local = true) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
invariant "inv__169"
  (!((Sta.Dir.Local = true) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
invariant "inv__170"
  (!((Sta.Dir.Local = true) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
ruleset p__Inv0 : NODE do
  invariant "inv__171"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.HeadVld = false) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
invariant "inv__172"
  (!((Sta.Dir.ShrVld = true) & (Sta.Dir.HeadVld = false)));
ruleset p__Inv0 : NODE do
  invariant "inv__173"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__174"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.Dir.ShrVld = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__175"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.WbMsg.Cmd = WB_Wb) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__176"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__177"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.WbMsg.Cmd = WB_Wb) & (Sta.InvMsg[p__Inv1].Cmd = INV_InvAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__178"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.Dir.HeadPtr = 2) & (Sta.RpMsg[p__Inv0].Cmd = RP_Replace)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__179"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.HeadPtr = 2) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
invariant "inv__180"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
invariant "inv__181"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
ruleset p__Inv0 : NODE do
  invariant "inv__182"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.HomeProc.CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
invariant "inv__183"
  (!((Sta.Dir.ShrVld = true) & (Sta.HomeProc.CacheState = CACHE_E)));
ruleset p__Inv0 : NODE do
  invariant "inv__184"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__185"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.Dir.Pending = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__186"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__187"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__188"
    (!((Sta.Dir.ShrVld = true) & (Sta.InvMsg[p__Inv0].Cmd = INV_Inv)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__189"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.ShWbMsg.Cmd = SHWB_ShWb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__190"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__191"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.Proc[p__Inv0].CacheState = CACHE_E)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__192"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.Dir.Dirty = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__193"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__194"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__195"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.ShWbMsg.Proc = 2) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__196"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__197"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.HeadPtr = 2) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
invariant "inv__198"
  (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__199"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__200"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__201"
    (!((Sta.ShWbMsg.Cmd = SHWB_ShWb) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__202"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.HomeUniMsg.Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__203"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.HomeUniMsg.Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__204"
    (!((Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__205"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__206"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__207"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__208"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_Get) & (Sta.HomeUniMsg.Proc = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__209"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Proc[p__Inv0].InvMarked = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__210"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.WbMsg.Cmd = WB_Wb) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__211"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.RpMsg[p__Inv0].Cmd = RP_Replace) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__212"
    (!((Sta.Proc[p__Inv0].ProcCmd = NODE_GetX) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__213"
    (!((Sta.Proc[p__Inv0].ProcCmd = NODE_None) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__214"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__215"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__216"
    (!((Sta.Dir.Local = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
invariant "inv__217"
  (!((Sta.Dir.Local = true) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
ruleset p__Inv0 : NODE do
  invariant "inv__218"
    (!((Sta.Dir.Local = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
invariant "inv__219"
  (!((Sta.Dir.Local = true) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
ruleset p__Inv0 : NODE do
  invariant "inv__220"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.Dir.HeadPtr = 2) & (Sta.Dir.ShrVld = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__221"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.WbMsg.Cmd = WB_Wb) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
invariant "inv__222"
  (!((Sta.Dir.ShrVld = true) & (Sta.HomeUniMsg.Cmd = UNI_PutX)));
invariant "inv__223"
  (!((Sta.Dir.ShrVld = true) & (Sta.WbMsg.Cmd = WB_Wb)));
ruleset p__Inv0 : NODE do
  invariant "inv__224"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__225"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__226"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__227"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__228"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__229"
    (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
invariant "inv__230"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_Get)));
ruleset p__Inv0 : NODE do
  invariant "inv__231"
    (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
invariant "inv__232"
  (!((Sta.HomeProc.CacheState = CACHE_E) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
ruleset p__Inv0 : NODE do
  invariant "inv__233"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__234"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__235"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__236"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__237"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
invariant "inv__238"
  (!((Sta.ShWbMsg.HomeProc = false) & (Sta.Dir.HomeHeadPtr = true)));
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__239"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__240"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__241"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2) & (Sta.HomeUniMsg.Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__242"
    (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__243"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__244"
    (!((Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__245"
    (!((Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__246"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_InvAck) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__247"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__248"
    (!((Sta.Dir.ShrSet[p__Inv1] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Get)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__249"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.HomeUniMsg.Cmd = UNI_Get) & (Sta.HomeUniMsg.Proc = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__250"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__251"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.WbMsg.Cmd = WB_Wb)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__252"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Proc[p__Inv0].InvMarked = false) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__253"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.ShrVld = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__254"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__255"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__256"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__257"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.NakcMsg.Cmd = NAKC_Nakc)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__258"
    (!((Sta.Dir.Dirty = true) & (Sta.Dir.HeadPtr = 2) & (Sta.UniMsg[p__Inv0].HomeProc = true) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__259"
    (!((Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.Dir.Dirty = true) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__260"
    (!((Sta.InvMsg[p__Inv1].Cmd = INV_Inv) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__261"
    (!((Sta.Proc[p__Inv0].InvMarked = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.InvSet[p__Inv0] = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__262"
    (!((Sta.Dir.ShrVld = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__263"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__264"
    (!((Sta.Dir.ShrSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__265"
    (!((Sta.Dir.ShrSet[p__Inv1] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__266"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_I) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.Dir.Dirty = true) & (Sta.Dir.HeadPtr = 2)));
endruleset;
invariant "inv__267"
  (!((Sta.Dir.HeadPtr = 2) & (Sta.Dir.HomeHeadPtr = true)));
ruleset p__Inv0 : NODE do
  invariant "inv__268"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_GetX) & (Sta.Dir.InvSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__269"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__270"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_S) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.Dir.Dirty = true) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__271"
    (!((Sta.Proc[p__Inv0].InvMarked = true) & (Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.Dir.Dirty = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__272"
    (!((Sta.Dir.Pending = false) & (Sta.Dir.Dirty = true) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__273"
    (!((Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].Cmd = UNI_PutX) & (Sta.Dir.HeadPtr = 2)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__274"
    (!((Sta.Dir.Local = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_Put) & (Sta.UniMsg[p__Inv0].Cmd = UNI_Put) & (Sta.Dir.Dirty = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__275"
    (!((Sta.Proc[p__Inv0].CacheState = CACHE_E) & (Sta.Proc[p__Inv0].InvMarked = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__276"
    (!((Sta.Proc[p__Inv0].InvMarked = true) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__277"
    (!((Sta.Proc[p__Inv0].InvMarked = true) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__278"
    (!((Sta.Dir.Pending = false) & (Sta.Dir.HeadVld = false) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__279"
    (!((Sta.NakcMsg.Cmd = NAKC_Nakc) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__280"
    (!((Sta.HomeUniMsg.Cmd = UNI_PutX) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__281"
    (!((Sta.ShWbMsg.Cmd = SHWB_FAck) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__282"
    (!((Sta.Proc[p__Inv0].ProcCmd = NODE_None) & (Sta.Proc[p__Inv0].InvMarked = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__283"
    (!((Sta.Proc[p__Inv0].ProcCmd = NODE_Get) & (Sta.UniMsg[p__Inv0].Cmd = UNI_GetX)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__284"
    (!((Sta.InvMsg[p__Inv0].Cmd = INV_Inv) & (Sta.Dir.HomeHeadPtr = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__285"
    (!((Sta.Proc[p__Inv0].InvMarked = true) & (Sta.ShWbMsg.Cmd = SHWB_FAck)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__286"
    (!((Sta.Dir.Pending = false) & (Sta.WbMsg.Cmd = WB_Wb) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__287"
    (!((Sta.UniMsg[p__Inv0].Cmd = UNI_Get) & (Sta.Dir.InvSet[p__Inv0] = true) & (Sta.UniMsg[p__Inv0].HomeProc = false)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__288"
    (!((Sta.HomeUniMsg.Cmd = UNI_Get) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE do
  invariant "inv__289"
    (!((Sta.HomeUniMsg.Cmd = UNI_GetX) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__290"
    (!((Sta.Proc[p__Inv1].CacheState = CACHE_E) & (Sta.Dir.Pending = false) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
ruleset p__Inv0 : NODE; p__Inv1 : NODE do
  invariant "inv__291"
    (!((Sta.Dir.Pending = false) & (Sta.UniMsg[p__Inv1].Cmd = UNI_PutX) & (Sta.Dir.InvSet[p__Inv0] = true)));
endruleset;
