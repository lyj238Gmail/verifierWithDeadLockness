type
  opcode : enum{op_invalid, read_shared, read_exclusive, req_upgrade, invalidate, invalidate_ack, grant_shared, grant_upgrade, grant_exclusive};
  request_opcode : enum{req_read_shared, req_read_exclusive, req_req_upgrade};
  cache_state : enum{cache_invalid, cache_shared, cache_exclusive};
  status_type : enum{inactive, pending, completed};
  addr_type : 1..2;
  data_type : 1..2;
  node_id : 1..2;
  channel_id : 1..3;



record_0 : record
data :  data_type;
addr :  addr_type;
op :  opcode;
dest :  node_id;
source :  node_id;
end;


record_1 : record
valid :  boolean;
msg :  record_0;
end;


record_2 : record
status :  status_type;
data :  data_type;
op :  opcode;
home :  node_id;
end;


record_3 : record
status :  status_type;
invalidate_list : array [node_id] of boolean;
data :  data_type;
op :  opcode;
source :  node_id;
end;


record_4 : record
data :  data_type;
state :  cache_state;
end;


record_5 : record
outchan_3 :  record_1;
outchan_2 :  record_1;
outchan_1 :  record_1;
inchan_3 :  record_1;
inchan_2 :  record_1;
inchan_1 :  record_1;
remote_requests : array [addr_type] of record_2;
home_requests : array [addr_type] of record_3;
local_requests : array [addr_type] of boolean;
directory : array [addr_type] of array [node_id] of cache_state;
cache : array [addr_type] of record_4;
memory : array [addr_type] of data_type;
end;


var
ha :  addr_type;
home :  node_id;
auxdata : array [addr_type] of data_type;
node : array [node_id] of record_5;


startstate
begin
  for i : node_id do
    for j : addr_type do
      node[i].memory[j] := 1;
      node[i].cache[j].state := cache_invalid;
      node[i].cache[j].data := 1;
      for k : node_id do
        node[i].directory[j][k] := cache_invalid;
      endfor;
      node[i].local_requests[j] := false;
      node[i].home_requests[j].source := i;
      node[i].home_requests[j].op := op_invalid;
      node[i].home_requests[j].data := 1;
      for k : node_id do
        node[i].home_requests[j].invalidate_list[k] := false;
      endfor;
      node[i].home_requests[j].status := inactive;
      node[i].remote_requests[j].home := i;
      node[i].remote_requests[j].op := op_invalid;
      node[i].remote_requests[j].data := 1;
      node[i].remote_requests[j].status := inactive;
    endfor;
    node[i].inchan_1.msg.source := 1;
    node[i].inchan_1.msg.dest := 1;
    node[i].inchan_1.msg.op := op_invalid;
    node[i].inchan_1.msg.addr := 1;
    node[i].inchan_1.msg.data := 1;
    node[i].inchan_1.valid := false;
    node[i].outchan_1.msg.source := 1;
    node[i].outchan_1.msg.dest := 1;
    node[i].outchan_1.msg.op := op_invalid;
    node[i].outchan_1.msg.addr := 1;
    node[i].outchan_1.msg.data := 1;
    node[i].outchan_1.valid := false;
    node[i].inchan_2.msg.source := 1;
    node[i].inchan_2.msg.dest := 1;
    node[i].inchan_2.msg.op := op_invalid;
    node[i].inchan_2.msg.addr := 1;
    node[i].inchan_2.msg.data := 1;
    node[i].inchan_2.valid := false;
    node[i].outchan_2.msg.source := 1;
    node[i].outchan_2.msg.dest := 1;
    node[i].outchan_2.msg.op := op_invalid;
    node[i].outchan_2.msg.addr := 1;
    node[i].outchan_2.msg.data := 1;
    node[i].outchan_2.valid := false;
    node[i].inchan_3.msg.source := 1;
    node[i].inchan_3.msg.dest := 1;
    node[i].inchan_3.msg.op := op_invalid;
    node[i].inchan_3.msg.addr := 1;
    node[i].inchan_3.msg.data := 1;
    node[i].inchan_3.valid := false;
    node[i].outchan_3.msg.source := 1;
    node[i].outchan_3.msg.dest := 1;
    node[i].outchan_3.msg.op := op_invalid;
    node[i].outchan_3.msg.addr := 1;
    node[i].outchan_3.msg.data := 1;
    node[i].outchan_3.valid := false;
  endfor;
  for i : addr_type do
    auxdata[i] := 1;
  endfor;
  home := 1;
  ha := 1;
endstartstate;


ruleset source : node_id; dest : node_id do
  rule "n_Transfer_message_from_source_via_ch_ch1"
    ((node[dest].inchan_1.valid = false) & (node[source].outchan_1.valid = true) & (dest = node[source].outchan_1.msg.dest)) ==>
  begin
    node[dest].inchan_1.msg.source := node[source].outchan_1.msg.source;
    node[dest].inchan_1.msg.dest := node[source].outchan_1.msg.dest;
    node[dest].inchan_1.msg.op := node[source].outchan_1.msg.op;
    node[dest].inchan_1.msg.addr := node[source].outchan_1.msg.addr;
    node[dest].inchan_1.msg.data := node[source].outchan_1.msg.data;
    node[dest].inchan_1.valid := node[source].outchan_1.valid;
    node[source].outchan_1.msg.op := op_invalid;
    node[source].outchan_1.valid := false;
  endrule;
endruleset;


ruleset source : node_id; dest : node_id do
  rule "n_Transfer_message_from_source_via_ch_ch2"
    ((node[dest].inchan_2.valid = false) & (node[source].outchan_2.valid = true) & (dest = node[source].outchan_2.msg.dest)) ==>
  begin
    node[dest].inchan_2.msg.source := node[source].outchan_2.msg.source;
    node[dest].inchan_2.msg.dest := node[source].outchan_2.msg.dest;
    node[dest].inchan_2.msg.op := node[source].outchan_2.msg.op;
    node[dest].inchan_2.msg.addr := node[source].outchan_2.msg.addr;
    node[dest].inchan_2.msg.data := node[source].outchan_2.msg.data;
    node[dest].inchan_2.valid := node[source].outchan_2.valid;
    node[source].outchan_2.msg.op := op_invalid;
    node[source].outchan_2.valid := false;
  endrule;
endruleset;


ruleset source : node_id; dest : node_id do
  rule "n_Transfer_message_from_source_via_ch_ch3"
    ((node[dest].inchan_3.valid = false) & (node[source].outchan_3.valid = true) & (dest = node[source].outchan_3.msg.dest)) ==>
  begin
    node[dest].inchan_3.msg.source := node[source].outchan_3.msg.source;
    node[dest].inchan_3.msg.dest := node[source].outchan_3.msg.dest;
    node[dest].inchan_3.msg.op := node[source].outchan_3.msg.op;
    node[dest].inchan_3.msg.addr := node[source].outchan_3.msg.addr;
    node[dest].inchan_3.msg.data := node[source].outchan_3.msg.data;
    node[dest].inchan_3.valid := node[source].outchan_3.valid;
    node[source].outchan_3.msg.op := op_invalid;
    node[source].outchan_3.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_shared_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_exclusive))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_exclusive_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_exclusive))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_req_upgrade_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_exclusive))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_shared_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_exclusive))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_exclusive_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_exclusive))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_req_upgrade_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_exclusive))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_shared_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_exclusive))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_read_exclusive_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_exclusive))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__0_reqreq_req_upgrade_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_exclusive))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_shared_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_shared))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_exclusive_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_shared))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_req_upgrade_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_shared))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_shared_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_shared))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_exclusive_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_shared))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_req_upgrade_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_shared))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_shared_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_shared = req_read_shared))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_read_exclusive_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_read_exclusive = req_read_shared))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__1_reqreq_req_upgrade_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_invalid) & (req_req_upgrade = req_read_shared))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_shared_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_shared = req_req_upgrade))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_exclusive_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_exclusive = req_req_upgrade))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_req_upgrade_channel11"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_1.valid = false) & (1 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_req_upgrade = req_req_upgrade))) ==>
  begin
    node[client].outchan_1.msg.source := client;
    if (addr = ha) then
      node[client].outchan_1.msg.dest := home;
else
      node[client].outchan_1.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_1.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_1.msg.op := read_exclusive;
else
        node[client].outchan_1.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_shared_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_shared = req_req_upgrade))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_exclusive_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_exclusive = req_req_upgrade))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_req_upgrade_channel12"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_2.valid = false) & (2 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_req_upgrade = req_req_upgrade))) ==>
  begin
    node[client].outchan_2.msg.source := client;
    if (addr = ha) then
      node[client].outchan_2.msg.dest := home;
else
      node[client].outchan_2.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_2.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_2.msg.op := read_exclusive;
else
        node[client].outchan_2.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_shared_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_shared = req_req_upgrade))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_shared = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_shared = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_read_exclusive_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_read_exclusive = req_req_upgrade))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_read_exclusive = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_read_exclusive = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; dest : node_id do
  rule "n_client_generates_new_req_for_addr__part__2_reqreq_req_upgrade_channel13"
    ((node[client].local_requests[addr] = false) & (node[client].outchan_3.valid = false) & (3 = 1) & (!(home = dest)) & ((node[client].cache[addr].state = cache_shared) & (req_req_upgrade = req_req_upgrade))) ==>
  begin
    node[client].outchan_3.msg.source := client;
    if (addr = ha) then
      node[client].outchan_3.msg.dest := home;
else
      node[client].outchan_3.msg.dest := dest;
    endif;
    if (req_req_upgrade = req_read_shared) then
      node[client].outchan_3.msg.op := read_shared;
else
      if (req_req_upgrade = req_read_exclusive) then
        node[client].outchan_3.msg.op := read_exclusive;
else
        node[client].outchan_3.msg.op := req_upgrade;
      endif;
    endif;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].local_requests[addr] := true;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_accepts_invalidate_request_channel21"
    ((node[client].inchan_1.msg.op = invalidate) & (node[client].inchan_1.valid = true) & (node[client].remote_requests[addr].status = inactive) & (addr = node[client].inchan_1.msg.addr) & (1 = 2)) ==>
  begin
    node[client].remote_requests[addr].home := node[client].inchan_1.msg.source;
    node[client].remote_requests[addr].op := node[client].inchan_1.msg.op;
    node[client].remote_requests[addr].status := pending;
    node[client].inchan_1.msg.op := op_invalid;
    node[client].inchan_1.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_accepts_invalidate_request_channel22"
    ((node[client].inchan_2.msg.op = invalidate) & (node[client].inchan_2.valid = true) & (node[client].remote_requests[addr].status = inactive) & (addr = node[client].inchan_2.msg.addr) & (2 = 2)) ==>
  begin
    node[client].remote_requests[addr].home := node[client].inchan_2.msg.source;
    node[client].remote_requests[addr].op := node[client].inchan_2.msg.op;
    node[client].remote_requests[addr].status := pending;
    node[client].inchan_2.msg.op := op_invalid;
    node[client].inchan_2.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_accepts_invalidate_request_channel23"
    ((node[client].inchan_3.msg.op = invalidate) & (node[client].inchan_3.valid = true) & (node[client].remote_requests[addr].status = inactive) & (addr = node[client].inchan_3.msg.addr) & (3 = 2)) ==>
  begin
    node[client].remote_requests[addr].home := node[client].inchan_3.msg.source;
    node[client].remote_requests[addr].op := node[client].inchan_3.msg.op;
    node[client].remote_requests[addr].status := pending;
    node[client].inchan_3.msg.op := op_invalid;
    node[client].inchan_3.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_processes_invalidate_request_for_addr"
    ((node[client].remote_requests[addr].op = invalidate) & (node[client].remote_requests[addr].status = pending)) ==>
  begin
    node[client].remote_requests[addr].data := node[client].cache[addr].data;
    node[client].remote_requests[addr].status := completed;
    node[client].cache[addr].state := cache_invalid;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_prepares_invalidate_ack_for_addr_channel31"
    ((node[client].outchan_1.valid = false) & (node[client].remote_requests[addr].op = invalidate) & (node[client].remote_requests[addr].status = completed) & (1 = 3)) ==>
  begin
    node[client].outchan_1.msg.op := invalidate_ack;
    node[client].outchan_1.msg.source := client;
    node[client].outchan_1.msg.dest := node[client].remote_requests[addr].home;
    node[client].outchan_1.msg.data := node[client].remote_requests[addr].data;
    node[client].outchan_1.msg.addr := addr;
    node[client].outchan_1.valid := true;
    node[client].remote_requests[addr].home := home;
    node[client].remote_requests[addr].op := op_invalid;
    node[client].remote_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_prepares_invalidate_ack_for_addr_channel32"
    ((node[client].outchan_2.valid = false) & (node[client].remote_requests[addr].op = invalidate) & (node[client].remote_requests[addr].status = completed) & (2 = 3)) ==>
  begin
    node[client].outchan_2.msg.op := invalidate_ack;
    node[client].outchan_2.msg.source := client;
    node[client].outchan_2.msg.dest := node[client].remote_requests[addr].home;
    node[client].outchan_2.msg.data := node[client].remote_requests[addr].data;
    node[client].outchan_2.msg.addr := addr;
    node[client].outchan_2.valid := true;
    node[client].remote_requests[addr].home := home;
    node[client].remote_requests[addr].op := op_invalid;
    node[client].remote_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_prepares_invalidate_ack_for_addr_channel33"
    ((node[client].outchan_3.valid = false) & (node[client].remote_requests[addr].op = invalidate) & (node[client].remote_requests[addr].status = completed) & (3 = 3)) ==>
  begin
    node[client].outchan_3.msg.op := invalidate_ack;
    node[client].outchan_3.msg.source := client;
    node[client].outchan_3.msg.dest := node[client].remote_requests[addr].home;
    node[client].outchan_3.msg.data := node[client].remote_requests[addr].data;
    node[client].outchan_3.msg.addr := addr;
    node[client].outchan_3.valid := true;
    node[client].remote_requests[addr].home := home;
    node[client].remote_requests[addr].op := op_invalid;
    node[client].remote_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__0_channel21"
    ((node[client].inchan_1.valid = true) & (addr = node[client].inchan_1.msg.addr) & (1 = 2) & (node[client].inchan_1.msg.op = grant_exclusive)) ==>
  begin
    if (node[client].inchan_1.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_1.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_1.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_1.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_1.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_1.msg.op := op_invalid;
    node[client].inchan_1.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__0_channel22"
    ((node[client].inchan_2.valid = true) & (addr = node[client].inchan_2.msg.addr) & (2 = 2) & (node[client].inchan_2.msg.op = grant_exclusive)) ==>
  begin
    if (node[client].inchan_2.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_2.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_2.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_2.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_2.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_2.msg.op := op_invalid;
    node[client].inchan_2.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__0_channel23"
    ((node[client].inchan_3.valid = true) & (addr = node[client].inchan_3.msg.addr) & (3 = 2) & (node[client].inchan_3.msg.op = grant_exclusive)) ==>
  begin
    if (node[client].inchan_3.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_3.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_3.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_3.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_3.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_3.msg.op := op_invalid;
    node[client].inchan_3.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__1_channel21"
    ((node[client].inchan_1.valid = true) & (addr = node[client].inchan_1.msg.addr) & (1 = 2) & (node[client].inchan_1.msg.op = grant_shared)) ==>
  begin
    if (node[client].inchan_1.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_1.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_1.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_1.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_1.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_1.msg.op := op_invalid;
    node[client].inchan_1.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__1_channel22"
    ((node[client].inchan_2.valid = true) & (addr = node[client].inchan_2.msg.addr) & (2 = 2) & (node[client].inchan_2.msg.op = grant_shared)) ==>
  begin
    if (node[client].inchan_2.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_2.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_2.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_2.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_2.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_2.msg.op := op_invalid;
    node[client].inchan_2.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__1_channel23"
    ((node[client].inchan_3.valid = true) & (addr = node[client].inchan_3.msg.addr) & (3 = 2) & (node[client].inchan_3.msg.op = grant_shared)) ==>
  begin
    if (node[client].inchan_3.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_3.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_3.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_3.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_3.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_3.msg.op := op_invalid;
    node[client].inchan_3.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__2_channel21"
    ((node[client].inchan_1.valid = true) & (addr = node[client].inchan_1.msg.addr) & (1 = 2) & (node[client].inchan_1.msg.op = grant_upgrade)) ==>
  begin
    if (node[client].inchan_1.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_1.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_1.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_1.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_1.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_1.msg.op := op_invalid;
    node[client].inchan_1.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__2_channel22"
    ((node[client].inchan_2.valid = true) & (addr = node[client].inchan_2.msg.addr) & (2 = 2) & (node[client].inchan_2.msg.op = grant_upgrade)) ==>
  begin
    if (node[client].inchan_2.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_2.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_2.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_2.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_2.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_2.msg.op := op_invalid;
    node[client].inchan_2.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type do
  rule "n_client_receives_reply_from_home__part__2_channel23"
    ((node[client].inchan_3.valid = true) & (addr = node[client].inchan_3.msg.addr) & (3 = 2) & (node[client].inchan_3.msg.op = grant_upgrade)) ==>
  begin
    if (node[client].inchan_3.msg.op = grant_shared) then
      node[client].cache[addr].data := node[client].inchan_3.msg.data;
      node[client].cache[addr].state := cache_shared;
else
      if (node[client].inchan_3.msg.op = grant_upgrade) then
        node[client].cache[addr].state := cache_exclusive;
else
        if (node[client].inchan_3.msg.op = grant_exclusive) then
          node[client].cache[addr].data := node[client].inchan_3.msg.data;
          node[client].cache[addr].state := cache_exclusive;
        endif;
      endif;
    endif;
    node[client].local_requests[addr] := false;
    node[client].inchan_3.msg.op := op_invalid;
    node[client].inchan_3.valid := false;
  endrule;
endruleset;


ruleset client : node_id; addr : addr_type; data : data_type do
  rule "n_client_stores_data_in_cache_for_addr"
    ((node[client].cache[addr].state = cache_exclusive) & (!(node[client].remote_requests[addr].status = pending))) ==>
  begin
    node[client].cache[addr].data := data;
    auxdata[addr] := data;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_accepts_a_request_message_channel11"
    ((node[home].home_requests[addr].status = inactive) & (node[home].inchan_1.valid = true) & (addr = node[home].inchan_1.msg.addr) & (1 = 1) & (source = node[home].inchan_1.msg.source)) ==>
  begin
    if ((node[home].inchan_1.msg.op = req_upgrade) & (node[home].directory[addr][source] = cache_invalid)) then
      node[home].inchan_1.msg.op := read_exclusive;
    endif;
    node[home].home_requests[addr].source := source;
    node[home].home_requests[addr].op := node[home].inchan_1.msg.op;
    if ((node[home].inchan_1.msg.op = read_shared) & (node[home].directory[addr][home] = cache_shared)) then
      if (node[home].cache[addr].state = cache_shared) then
        node[home].home_requests[addr].data := node[home].cache[addr].data;
else
        node[home].home_requests[addr].data := node[home].memory[addr];
      endif;
      node[home].home_requests[addr].status := completed;
else
      if (((node[home].inchan_1.msg.op = read_shared) & (node[home].directory[addr][home] = cache_invalid)) & (!(exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists))) then
        node[home].home_requests[addr].data := node[home].memory[addr];
        node[home].home_requests[addr].status := completed;
else
        if ((node[home].inchan_1.msg.op = read_shared) & (exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists)) then
          for n : node_id do
            if (!(node[home].directory[addr][n] = cache_invalid)) then
              node[home].home_requests[addr].invalidate_list[n] := true;
else
              node[home].home_requests[addr].invalidate_list[n] := false;
            endif;
          endfor;
          node[home].home_requests[addr].status := pending;
else
          if (node[home].inchan_1.msg.op = req_upgrade) then
            for n : node_id do
              if ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) then
                node[home].home_requests[addr].invalidate_list[n] := true;
else
                node[home].home_requests[addr].invalidate_list[n] := false;
              endif;
            endfor;
            if (exists n : node_id do ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) endexists) then
              node[home].home_requests[addr].status := pending;
else
              node[home].home_requests[addr].status := completed;
            endif;
else
            if (node[home].inchan_1.msg.op = read_exclusive) then
              for n : node_id do
                if (!(node[home].directory[addr][n] = cache_invalid)) then
                  node[home].home_requests[addr].invalidate_list[n] := true;
else
                  node[home].home_requests[addr].invalidate_list[n] := false;
                endif;
              endfor;
              if (exists n : node_id do (!(node[home].directory[addr][n] = cache_invalid)) endexists) then
                node[home].home_requests[addr].status := pending;
else
                node[home].home_requests[addr].data := node[home].memory[addr];
                node[home].home_requests[addr].status := completed;
              endif;
            endif;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_1.msg.op := op_invalid;
    node[home].inchan_1.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_accepts_a_request_message_channel12"
    ((node[home].home_requests[addr].status = inactive) & (node[home].inchan_2.valid = true) & (addr = node[home].inchan_2.msg.addr) & (2 = 1) & (source = node[home].inchan_2.msg.source)) ==>
  begin
    if ((node[home].inchan_2.msg.op = req_upgrade) & (node[home].directory[addr][source] = cache_invalid)) then
      node[home].inchan_2.msg.op := read_exclusive;
    endif;
    node[home].home_requests[addr].source := source;
    node[home].home_requests[addr].op := node[home].inchan_2.msg.op;
    if ((node[home].inchan_2.msg.op = read_shared) & (node[home].directory[addr][home] = cache_shared)) then
      if (node[home].cache[addr].state = cache_shared) then
        node[home].home_requests[addr].data := node[home].cache[addr].data;
else
        node[home].home_requests[addr].data := node[home].memory[addr];
      endif;
      node[home].home_requests[addr].status := completed;
else
      if (((node[home].inchan_2.msg.op = read_shared) & (node[home].directory[addr][home] = cache_invalid)) & (!(exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists))) then
        node[home].home_requests[addr].data := node[home].memory[addr];
        node[home].home_requests[addr].status := completed;
else
        if ((node[home].inchan_2.msg.op = read_shared) & (exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists)) then
          for n : node_id do
            if (!(node[home].directory[addr][n] = cache_invalid)) then
              node[home].home_requests[addr].invalidate_list[n] := true;
else
              node[home].home_requests[addr].invalidate_list[n] := false;
            endif;
          endfor;
          node[home].home_requests[addr].status := pending;
else
          if (node[home].inchan_2.msg.op = req_upgrade) then
            for n : node_id do
              if ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) then
                node[home].home_requests[addr].invalidate_list[n] := true;
else
                node[home].home_requests[addr].invalidate_list[n] := false;
              endif;
            endfor;
            if (exists n : node_id do ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) endexists) then
              node[home].home_requests[addr].status := pending;
else
              node[home].home_requests[addr].status := completed;
            endif;
else
            if (node[home].inchan_2.msg.op = read_exclusive) then
              for n : node_id do
                if (!(node[home].directory[addr][n] = cache_invalid)) then
                  node[home].home_requests[addr].invalidate_list[n] := true;
else
                  node[home].home_requests[addr].invalidate_list[n] := false;
                endif;
              endfor;
              if (exists n : node_id do (!(node[home].directory[addr][n] = cache_invalid)) endexists) then
                node[home].home_requests[addr].status := pending;
else
                node[home].home_requests[addr].data := node[home].memory[addr];
                node[home].home_requests[addr].status := completed;
              endif;
            endif;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_2.msg.op := op_invalid;
    node[home].inchan_2.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_accepts_a_request_message_channel13"
    ((node[home].home_requests[addr].status = inactive) & (node[home].inchan_3.valid = true) & (addr = node[home].inchan_3.msg.addr) & (3 = 1) & (source = node[home].inchan_3.msg.source)) ==>
  begin
    if ((node[home].inchan_3.msg.op = req_upgrade) & (node[home].directory[addr][source] = cache_invalid)) then
      node[home].inchan_3.msg.op := read_exclusive;
    endif;
    node[home].home_requests[addr].source := source;
    node[home].home_requests[addr].op := node[home].inchan_3.msg.op;
    if ((node[home].inchan_3.msg.op = read_shared) & (node[home].directory[addr][home] = cache_shared)) then
      if (node[home].cache[addr].state = cache_shared) then
        node[home].home_requests[addr].data := node[home].cache[addr].data;
else
        node[home].home_requests[addr].data := node[home].memory[addr];
      endif;
      node[home].home_requests[addr].status := completed;
else
      if (((node[home].inchan_3.msg.op = read_shared) & (node[home].directory[addr][home] = cache_invalid)) & (!(exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists))) then
        node[home].home_requests[addr].data := node[home].memory[addr];
        node[home].home_requests[addr].status := completed;
else
        if ((node[home].inchan_3.msg.op = read_shared) & (exists n : node_id do (node[home].directory[addr][n] = cache_exclusive) endexists)) then
          for n : node_id do
            if (!(node[home].directory[addr][n] = cache_invalid)) then
              node[home].home_requests[addr].invalidate_list[n] := true;
else
              node[home].home_requests[addr].invalidate_list[n] := false;
            endif;
          endfor;
          node[home].home_requests[addr].status := pending;
else
          if (node[home].inchan_3.msg.op = req_upgrade) then
            for n : node_id do
              if ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) then
                node[home].home_requests[addr].invalidate_list[n] := true;
else
                node[home].home_requests[addr].invalidate_list[n] := false;
              endif;
            endfor;
            if (exists n : node_id do ((!(node[home].directory[addr][n] = cache_invalid)) & (!(n = source))) endexists) then
              node[home].home_requests[addr].status := pending;
else
              node[home].home_requests[addr].status := completed;
            endif;
else
            if (node[home].inchan_3.msg.op = read_exclusive) then
              for n : node_id do
                if (!(node[home].directory[addr][n] = cache_invalid)) then
                  node[home].home_requests[addr].invalidate_list[n] := true;
else
                  node[home].home_requests[addr].invalidate_list[n] := false;
                endif;
              endfor;
              if (exists n : node_id do (!(node[home].directory[addr][n] = cache_invalid)) endexists) then
                node[home].home_requests[addr].status := pending;
else
                node[home].home_requests[addr].data := node[home].memory[addr];
                node[home].home_requests[addr].status := completed;
              endif;
            endif;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_3.msg.op := op_invalid;
    node[home].inchan_3.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; dest : node_id do
  rule "n_home_prepares_invalidate_for_addr_channel21"
    ((node[home].home_requests[addr].invalidate_list[dest] = true) & (node[home].home_requests[addr].status = pending) & (node[home].outchan_1.valid = false) & (1 = 2) & (exists n : node_id do (node[home].home_requests[addr].invalidate_list[n] = true) endexists)) ==>
  begin
    node[home].outchan_1.msg.addr := addr;
    node[home].outchan_1.msg.op := invalidate;
    node[home].outchan_1.msg.source := home;
    node[home].outchan_1.msg.dest := dest;
    node[home].outchan_1.valid := true;
    node[home].home_requests[addr].invalidate_list[dest] := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; dest : node_id do
  rule "n_home_prepares_invalidate_for_addr_channel22"
    ((node[home].home_requests[addr].invalidate_list[dest] = true) & (node[home].home_requests[addr].status = pending) & (node[home].outchan_2.valid = false) & (2 = 2) & (exists n : node_id do (node[home].home_requests[addr].invalidate_list[n] = true) endexists)) ==>
  begin
    node[home].outchan_2.msg.addr := addr;
    node[home].outchan_2.msg.op := invalidate;
    node[home].outchan_2.msg.source := home;
    node[home].outchan_2.msg.dest := dest;
    node[home].outchan_2.valid := true;
    node[home].home_requests[addr].invalidate_list[dest] := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; dest : node_id do
  rule "n_home_prepares_invalidate_for_addr_channel23"
    ((node[home].home_requests[addr].invalidate_list[dest] = true) & (node[home].home_requests[addr].status = pending) & (node[home].outchan_3.valid = false) & (3 = 2) & (exists n : node_id do (node[home].home_requests[addr].invalidate_list[n] = true) endexists)) ==>
  begin
    node[home].outchan_3.msg.addr := addr;
    node[home].outchan_3.msg.op := invalidate;
    node[home].outchan_3.msg.source := home;
    node[home].outchan_3.msg.dest := dest;
    node[home].outchan_3.valid := true;
    node[home].home_requests[addr].invalidate_list[dest] := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_processes_invalidate_ack_channel31"
    ((node[home].home_requests[addr].status = pending) & (node[home].inchan_1.msg.op = invalidate_ack) & (node[home].inchan_1.valid = true) & (addr = node[home].inchan_1.msg.addr) & (1 = 3) & (source = node[home].inchan_1.msg.source)) ==>
  begin
    if (node[home].directory[addr][source] = cache_exclusive) then
      node[home].memory[addr] := node[home].inchan_1.msg.data;
    endif;
    node[home].home_requests[addr].data := node[home].inchan_1.msg.data;
    node[home].directory[addr][source] := cache_invalid;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].home_requests[addr].status := completed;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        if (forall n : node_id do ((!(n = node[home].home_requests[addr].source)) -> (node[home].directory[addr][n] = cache_invalid)) endforall) then
          node[home].home_requests[addr].status := completed;
        endif;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          if (forall n : node_id do (node[home].directory[addr][n] = cache_invalid) endforall) then
            node[home].home_requests[addr].status := completed;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_1.msg.op := op_invalid;
    node[home].inchan_1.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_processes_invalidate_ack_channel32"
    ((node[home].home_requests[addr].status = pending) & (node[home].inchan_2.msg.op = invalidate_ack) & (node[home].inchan_2.valid = true) & (addr = node[home].inchan_2.msg.addr) & (2 = 3) & (source = node[home].inchan_2.msg.source)) ==>
  begin
    if (node[home].directory[addr][source] = cache_exclusive) then
      node[home].memory[addr] := node[home].inchan_2.msg.data;
    endif;
    node[home].home_requests[addr].data := node[home].inchan_2.msg.data;
    node[home].directory[addr][source] := cache_invalid;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].home_requests[addr].status := completed;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        if (forall n : node_id do ((!(n = node[home].home_requests[addr].source)) -> (node[home].directory[addr][n] = cache_invalid)) endforall) then
          node[home].home_requests[addr].status := completed;
        endif;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          if (forall n : node_id do (node[home].directory[addr][n] = cache_invalid) endforall) then
            node[home].home_requests[addr].status := completed;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_2.msg.op := op_invalid;
    node[home].inchan_2.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_processes_invalidate_ack_channel33"
    ((node[home].home_requests[addr].status = pending) & (node[home].inchan_3.msg.op = invalidate_ack) & (node[home].inchan_3.valid = true) & (addr = node[home].inchan_3.msg.addr) & (3 = 3) & (source = node[home].inchan_3.msg.source)) ==>
  begin
    if (node[home].directory[addr][source] = cache_exclusive) then
      node[home].memory[addr] := node[home].inchan_3.msg.data;
    endif;
    node[home].home_requests[addr].data := node[home].inchan_3.msg.data;
    node[home].directory[addr][source] := cache_invalid;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].home_requests[addr].status := completed;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        if (forall n : node_id do ((!(n = node[home].home_requests[addr].source)) -> (node[home].directory[addr][n] = cache_invalid)) endforall) then
          node[home].home_requests[addr].status := completed;
        endif;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          if (forall n : node_id do (node[home].directory[addr][n] = cache_invalid) endforall) then
            node[home].home_requests[addr].status := completed;
          endif;
        endif;
      endif;
    endif;
    node[home].inchan_3.msg.op := op_invalid;
    node[home].inchan_3.valid := false;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_sends_grant_for_addr_channel21"
    ((node[home].home_requests[addr].status = completed) & (node[home].outchan_1.valid = false) & (1 = 2) & (source = node[home].home_requests[addr].source)) ==>
  begin
    node[home].outchan_1.msg.source := home;
    node[home].outchan_1.msg.dest := node[home].home_requests[addr].source;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].outchan_1.msg.op := grant_shared;
      node[home].directory[addr][source] := cache_shared;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        node[home].outchan_1.msg.op := grant_upgrade;
        node[home].directory[addr][source] := cache_exclusive;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          node[home].outchan_1.msg.op := grant_exclusive;
          node[home].directory[addr][source] := cache_exclusive;
        endif;
      endif;
    endif;
    node[home].outchan_1.msg.data := node[home].home_requests[addr].data;
    node[home].outchan_1.msg.addr := addr;
    node[home].outchan_1.valid := true;
    node[home].home_requests[addr].op := op_invalid;
    for k : node_id do
      node[home].home_requests[addr].invalidate_list[k] := false;
    endfor;
    node[home].home_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_sends_grant_for_addr_channel22"
    ((node[home].home_requests[addr].status = completed) & (node[home].outchan_2.valid = false) & (2 = 2) & (source = node[home].home_requests[addr].source)) ==>
  begin
    node[home].outchan_2.msg.source := home;
    node[home].outchan_2.msg.dest := node[home].home_requests[addr].source;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].outchan_2.msg.op := grant_shared;
      node[home].directory[addr][source] := cache_shared;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        node[home].outchan_2.msg.op := grant_upgrade;
        node[home].directory[addr][source] := cache_exclusive;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          node[home].outchan_2.msg.op := grant_exclusive;
          node[home].directory[addr][source] := cache_exclusive;
        endif;
      endif;
    endif;
    node[home].outchan_2.msg.data := node[home].home_requests[addr].data;
    node[home].outchan_2.msg.addr := addr;
    node[home].outchan_2.valid := true;
    node[home].home_requests[addr].op := op_invalid;
    for k : node_id do
      node[home].home_requests[addr].invalidate_list[k] := false;
    endfor;
    node[home].home_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset home : node_id; addr : addr_type; source : node_id do
  rule "n_home_sends_grant_for_addr_channel23"
    ((node[home].home_requests[addr].status = completed) & (node[home].outchan_3.valid = false) & (3 = 2) & (source = node[home].home_requests[addr].source)) ==>
  begin
    node[home].outchan_3.msg.source := home;
    node[home].outchan_3.msg.dest := node[home].home_requests[addr].source;
    if (node[home].home_requests[addr].op = read_shared) then
      node[home].outchan_3.msg.op := grant_shared;
      node[home].directory[addr][source] := cache_shared;
else
      if (node[home].home_requests[addr].op = req_upgrade) then
        node[home].outchan_3.msg.op := grant_upgrade;
        node[home].directory[addr][source] := cache_exclusive;
else
        if (node[home].home_requests[addr].op = read_exclusive) then
          node[home].outchan_3.msg.op := grant_exclusive;
          node[home].directory[addr][source] := cache_exclusive;
        endif;
      endif;
    endif;
    node[home].outchan_3.msg.data := node[home].home_requests[addr].data;
    node[home].outchan_3.msg.addr := addr;
    node[home].outchan_3.valid := true;
    node[home].home_requests[addr].op := op_invalid;
    for k : node_id do
      node[home].home_requests[addr].invalidate_list[k] := false;
    endfor;
    node[home].home_requests[addr].status := inactive;
  endrule;
endruleset;


ruleset n1 : node_id; n2 : node_id; addr : addr_type do
  invariant "n_coherent"
    (((!(n1 = n2)) & (node[n1].cache[addr].state = cache_exclusive)) -> (node[n2].cache[addr].state = cache_invalid));
endruleset;


ruleset client : node_id; addr : addr_type do
  invariant "n_data_consistency_property"
    ((!(node[client].cache[addr].state = cache_invalid)) -> (node[client].cache[addr].data = auxdata[addr]));
endruleset;


