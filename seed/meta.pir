memory 8192
bytes dash "-"
bytes newline "\n"
bytes limited "plang0: memory limit\n"
bytes invalid "plang0: atom manifest rejected\n"

func next 3
arg %fd 0
arg %buffer 1
arg %capacity 2
u64 %zero 0
u64 %one 1
u64 %lf 10
u64 %length 0
label read
eq %test %length %capacity
nonzero %test full
add %seat %buffer %length
read %count %fd %seat %one
slt %test %count %zero
nonzero %test full
zero %count done
load8 %byte %seat %zero
eq %test %byte %lf
nonzero %test done
add %length %length %one
jump read
label done
ret %length
label full
ret %capacity
end

func same 4
arg %left 0
arg %llen 1
arg %right 2
arg %rlen 3
u64 %zero 0
u64 %one 1
ne %test %llen %rlen
nonzero %test no
u64 %index 0
label byte
eq %test %index %llen
nonzero %test yes
load8 %a %left %index
load8 %b %right %index
ne %test %a %b
nonzero %test no
add %index %index %one
jump byte
label yes
ret %one
label no
ret %zero
end

func decimal 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %ten 10
u64 %ascii 48
u64 %nine 57
u64 %unknown 255
u64 %index 0
u64 %result 0
zero %length bad
label digit
eq %test %index %length
nonzero %test done
load8 %byte %token %index
le %test %ascii %byte
zero %test bad
le %test %byte %nine
zero %test bad
mul %result %result %ten
sub %byte %byte %ascii
add %result %result %byte
add %index %index %one
jump digit
label done
ret %result
label bad
ret %unknown
end

func atom_count 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %eight 8
ne %test %length %one
nonzero %test bad
call %count decimal 2 %token %length
zero %count bad
le %test %count %eight
zero %test bad
ret %count
label bad
ret %zero
end

func expansion 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %four 4
u64 %ascii 48
u64 %limit 4095
le %test %length %four
zero %test bad
eq %test %length %one
nonzero %test parse
load8 %first %token %zero
eq %test %first %ascii
nonzero %test bad
label parse
call %value decimal 2 %token %length
zero %value bad
le %test %value %limit
zero %test bad
ret %value
label bad
ret %zero
end

func budget 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %five 5
u64 %ascii 48
u64 %limit 65535
le %test %length %five
zero %test bad
eq %test %length %one
nonzero %test parse
load8 %first %token %zero
eq %test %first %ascii
nonzero %test bad
label parse
call %value decimal 2 %token %length
zero %value bad
le %test %value %limit
zero %test bad
ret %value
label bad
ret %zero
end

func emission 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %ascii 48
u64 %limit 8
u64 %unknown 255
ne %test %length %one
nonzero %test bad
call %value decimal 2 %token %length
eq %test %value %unknown
nonzero %test bad
le %test %value %limit
zero %test bad
ret %value
label bad
ret %unknown
end

func natural 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %four 4
u64 %ascii 48
u64 %limit 4095
u64 %unknown 255
le %test %length %four
zero %test bad
eq %test %length %one
nonzero %test parse
load8 %first %token %zero
eq %test %first %ascii
nonzero %test bad
label parse
call %value decimal 2 %token %length
eq %test %value %unknown
nonzero %test bad
le %test %value %limit
zero %test bad
ret %value
label bad
ret %unknown
end

func mode 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %constant 99
u64 %affine 97
ne %test %length %one
nonzero %test bad
load8 %value %token %zero
eq %test %value %constant
nonzero %test constant_mode
eq %test %value %affine
zero %test bad
ret %one
label constant_mode
ret %zero
label bad
u64 %unknown 255
ret %unknown
end

func effect_valid 2
arg %token 0
arg %length 1
u64 %zero 0
u64 %one 1
u64 %plus 43
u64 %minus 45
u64 %a 97
u64 %z 122
zero %length bad
eq %test %length %one
zero %test scan
load8 %value %token %zero
eq %test %value %minus
nonzero %test yes
label scan
u64 %index 0
u64 %component 0
label byte
eq %test %index %length
nonzero %test done
load8 %value %token %index
eq %test %value %plus
nonzero %test separator
le %test %a %value
zero %test bad
le %test %value %z
zero %test bad
add %component %component %one
jump next
label separator
zero %component bad
u64 %component 0
label next
add %index %index %one
jump byte
label done
zero %component bad
label yes
ret %one
label bad
ret %zero
end

func put 2
arg %data 0
arg %length 1
u64 %fd 1
write %result %fd %data %length
ret %result
end

func emit 2
arg %data 0
arg %length 1
u64 %one 1
call %wrote put 2 %data %length
out newline
ret %one
end

func copy 3
arg %target 0
arg %source 1
arg %length 2
u64 %zero 0
u64 %one 1
u64 %max 63
le %test %length %max
zero %test bad
u64 %index 0
label byte
eq %test %index %length
nonzero %test done
load8 %value %source %index
store8 %target %index %value
add %index %index %one
jump byte
label done
ret %one
label bad
ret %zero
end

func nextcopy 4
arg %buffer 0
arg %capacity 1
arg %target 2
arg %target_capacity 3
u64 %zero 0
u64 %fd 0
call %length next 3 %fd %buffer %capacity
zero %length bad
le %test %target_capacity %length
nonzero %test bad
call %test copy 3 %target %buffer %length
zero %test bad
ret %length
label bad
ret %zero
end

func seat 3
arg %records 0
arg %index 1
arg %size 2
mul %offset %index %size
add %record %records %offset
ret %record
end

func main 0
u64 %zero 0
u64 %one 1
u64 %unknown 255
u64 %capacity 4096
u64 %small 64
u64 %record_size 416
u64 %rule_size 144
u64 %fd 0
alloc %buffer %capacity
alloc %a %small
zero %buffer limited
zero %a limited
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %count atom_count 2 %a %length
zero %count invalid
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %work_budget budget 2 %a %length
zero %work_budget invalid
mul %length %count %record_size
alloc %records %length
zero %records limited
u64 %index 0
label record
eq %test %index %count
nonzero %test records_done
call %current seat 3 %records %index %record_size
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %length nextcopy 4 %buffer %capacity %current %small
zero %length invalid
u64 %offset 256
store64 %current %offset %length
u64 %offset 64
add %target %current %offset
call %length nextcopy 4 %buffer %capacity %target %small
zero %length invalid
u64 %offset 264
store64 %current %offset %length
u64 %offset 192
add %target %current %offset
call %length nextcopy 4 %buffer %capacity %target %small
zero %length invalid
u64 %offset 280
store64 %current %offset %length
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %test effect_valid 2 %a %length
zero %test invalid
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %test effect_valid 2 %a %length
zero %test invalid
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value expansion 2 %a %length
zero %value invalid
u64 %offset 288
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value expansion 2 %a %length
zero %value invalid
u64 %offset 296
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value emission 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 304
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value expansion 2 %a %length
zero %value invalid
u64 %offset 312
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value mode 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 320
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value natural 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 328
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value natural 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 336
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value emission 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 344
store64 %current %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value natural 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 408
store64 %current %offset %value
u64 %offset 320
load64 %value %current %offset
nonzero %value affine_rule
u64 %offset 336
load64 %value %current %offset
nonzero %value invalid
u64 %offset 344
load64 %value %current %offset
nonzero %value invalid
jump rule_done
label affine_rule
u64 %offset 336
load64 %value %current %offset
zero %value invalid
u64 %offset 344
load64 %value %current %offset
zero %value invalid
label rule_done
u64 %offset 128
add %target %current %offset
call %length nextcopy 4 %buffer %capacity %target %small
zero %length invalid
u64 %offset 272
store64 %current %offset %length
u64 %offset 352
store64 %current %offset %zero
u64 %offset 360
store64 %current %offset %unknown
u64 %offset 368
store64 %current %offset %zero
u64 %offset 376
store64 %current %offset %zero
u64 %offset 384
store64 %current %offset %zero
u64 %offset 392
store64 %current %offset %zero
u64 %offset 400
store64 %current %offset %zero
add %index %index %one
jump record
label records_done
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %rule_count emission 2 %a %length
eq %test %rule_count %unknown
nonzero %test invalid
u64 %value 4
le %test %rule_count %value
zero %test invalid
u64 %length 576
alloc %rules %length
zero %rules limited
u64 %index 0
label extension_record
eq %test %index %rule_count
nonzero %test extension_records_done
call %other seat 3 %rules %index %rule_size
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value emission 2 %a %length
eq %test %value %unknown
nonzero %test invalid
le %test %count %value
nonzero %test invalid
u64 %offset 64
store64 %other %offset %value
call %length nextcopy 4 %buffer %capacity %other %small
zero %length invalid
u64 %offset 72
store64 %other %offset %length
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value expansion 2 %a %length
zero %value invalid
u64 %offset 80
store64 %other %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value mode 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 88
store64 %other %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value natural 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 96
store64 %other %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value natural 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 104
store64 %other %offset %value
call %length nextcopy 4 %buffer %capacity %a %small
zero %length invalid
call %value emission 2 %a %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 112
store64 %other %offset %value
u64 %offset 88
load64 %value %other %offset
nonzero %value extension_affine
u64 %offset 104
load64 %value %other %offset
nonzero %value invalid
u64 %offset 112
load64 %value %other %offset
nonzero %value invalid
jump extension_rule_done
label extension_affine
u64 %offset 104
load64 %value %other %offset
zero %value invalid
u64 %offset 112
load64 %value %other %offset
zero %value invalid
label extension_rule_done
u64 %offset 120
store64 %other %offset %zero
u64 %offset 128
store64 %other %offset %zero
u64 %offset 136
store64 %other %offset %zero
add %index %index %one
jump extension_record
label extension_records_done
call %length next 3 %fd %buffer %capacity
nonzero %length invalid
u64 %index 0
label unique
eq %test %index %count
nonzero %test aux_unique
call %current seat 3 %records %index %record_size
u64 %offset 256
load64 %length %current %offset
add %other_index %index %one
label unique_other
eq %test %other_index %count
nonzero %test unique_next
call %other seat 3 %records %other_index %record_size
load64 %value %other %offset
call %test same 4 %current %length %other %value
nonzero %test invalid
add %other_index %other_index %one
jump unique_other
label unique_next
add %index %index %one
jump unique
label aux_unique
u64 %index 0
label aux_rule
eq %test %index %count
nonzero %test extension_unique
call %current seat 3 %records %index %record_size
u64 %offset 192
add %target %current %offset
u64 %offset 280
load64 %length %current %offset
data %a %small dash
call %test same 4 %target %length %a %small
nonzero %test aux_rule_next
u64 %offset 256
load64 %value %current %offset
call %test same 4 %target %length %current %value
nonzero %test invalid
u64 %other_index 0
label aux_other
eq %test %other_index %count
nonzero %test aux_rule_next
eq %test %other_index %index
nonzero %test aux_other_next
call %other seat 3 %records %other_index %record_size
u64 %offset 256
load64 %value %other %offset
call %test same 4 %target %length %other %value
nonzero %test invalid
u64 %offset 192
add %a %other %offset
u64 %offset 280
load64 %small %other %offset
call %test same 4 %target %length %a %small
nonzero %test invalid
label aux_other_next
add %other_index %other_index %one
jump aux_other
label aux_rule_next
add %index %index %one
jump aux_rule
label extension_unique
u64 %index 0
label extension_rule_unique
eq %test %index %rule_count
nonzero %test edges
call %other seat 3 %rules %index %rule_size
u64 %offset 72
load64 %length %other %offset
data %a %small dash
call %test same 4 %other %length %a %small
nonzero %test invalid
u64 %other_index 0
label extension_atom_unique
eq %test %other_index %count
nonzero %test extension_peer_unique
call %current seat 3 %records %other_index %record_size
u64 %offset 256
load64 %value %current %offset
call %test same 4 %other %length %current %value
nonzero %test invalid
u64 %offset 192
add %target %current %offset
u64 %offset 280
load64 %value %current %offset
data %a %small dash
call %test same 4 %target %value %a %small
nonzero %test extension_atom_next
call %test same 4 %other %length %target %value
nonzero %test invalid
label extension_atom_next
add %other_index %other_index %one
jump extension_atom_unique
label extension_peer_unique
add %other_index %index %one
label extension_peer
eq %test %other_index %rule_count
nonzero %test extension_rule_next
call %current seat 3 %rules %other_index %rule_size
u64 %offset 72
load64 %value %current %offset
call %test same 4 %other %length %current %value
nonzero %test invalid
add %other_index %other_index %one
jump extension_peer
label extension_rule_next
add %index %index %one
jump extension_rule_unique
label edges
u64 %index 0
label edge
eq %test %index %count
nonzero %test census_open
call %current seat 3 %records %index %record_size
u64 %offset 64
add %target %current %offset
u64 %offset 264
load64 %length %current %offset
data %a %small dash
call %test same 4 %target %length %a %small
u64 %offset 304
load64 %value %current %offset
zero %test emitted_edge
nonzero %value invalid
jump edge_next
label emitted_edge
zero %value invalid
u64 %chosen 255
u64 %other_index 0
label consumer
eq %test %other_index %count
nonzero %test consumer_done
call %other seat 3 %records %other_index %record_size
u64 %offset 256
load64 %value %other %offset
call %test same 4 %target %length %other %value
zero %test consumer_next
u64 %chosen 0
add %chosen %chosen %other_index
label consumer_next
add %other_index %other_index %one
jump consumer
label consumer_done
eq %test %chosen %unknown
nonzero %test invalid
u64 %offset 360
store64 %current %offset %chosen
call %other seat 3 %records %chosen %record_size
u64 %offset 352
load64 %value %other %offset
add %value %value %one
store64 %other %offset %value
label edge_next
add %index %index %one
jump edge
label census_open
u64 %fd 3
u64 %source_tokens 0
label census
call %length next 3 %fd %buffer %capacity
zero %length census_done
eq %test %length %capacity
nonzero %test invalid
add %source_tokens %source_tokens %one
le %test %source_tokens %work_budget
zero %test invalid
u64 %index 0
label census_atom
eq %test %index %count
nonzero %test census_extension_open
call %current seat 3 %records %index %record_size
u64 %offset 400
load64 %value %current %offset
zero %value census_match
sub %value %value %one
store64 %current %offset %value
nonzero %value census_match
call %value natural 2 %buffer %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 336
load64 %other_index %current %offset
mul %value %value %other_index
u64 %offset 328
load64 %other_index %current %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
u64 %offset 392
load64 %other_index %current %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
le %test %value %work_budget
zero %test invalid
store64 %current %offset %value
label census_match
u64 %offset 256
load64 %value %current %offset
call %test same 4 %buffer %length %current %value
zero %test census_aux
u64 %offset 376
load64 %value %current %offset
add %value %value %one
store64 %current %offset %value
label census_aux
u64 %offset 192
add %target %current %offset
u64 %offset 280
load64 %value %current %offset
data %a %small dash
call %test same 4 %target %value %a %small
nonzero %test census_next
call %test same 4 %buffer %length %target %value
zero %test census_next
u64 %offset 384
load64 %value %current %offset
add %value %value %one
store64 %current %offset %value
u64 %offset 320
load64 %value %current %offset
nonzero %value census_affine
u64 %offset 328
load64 %value %current %offset
u64 %offset 392
load64 %other_index %current %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
le %test %value %work_budget
zero %test invalid
store64 %current %offset %value
jump census_next
label census_affine
u64 %offset 400
load64 %value %current %offset
nonzero %value invalid
u64 %offset 344
load64 %value %current %offset
u64 %offset 400
store64 %current %offset %value
label census_next
add %index %index %one
jump census_atom
label census_extension_open
u64 %index 0
label census_extension
eq %test %index %rule_count
nonzero %test census
call %other seat 3 %rules %index %rule_size
u64 %offset 136
load64 %value %other %offset
zero %value census_extension_match
sub %value %value %one
store64 %other %offset %value
nonzero %value census_extension_match
call %value natural 2 %buffer %length
eq %test %value %unknown
nonzero %test invalid
u64 %offset 104
load64 %other_index %other %offset
mul %value %value %other_index
u64 %offset 96
load64 %other_index %other %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
u64 %offset 128
load64 %other_index %other %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
le %test %value %work_budget
zero %test invalid
store64 %other %offset %value
label census_extension_match
u64 %offset 72
load64 %value %other %offset
call %test same 4 %buffer %length %other %value
zero %test census_extension_next
u64 %offset 120
load64 %value %other %offset
add %value %value %one
store64 %other %offset %value
u64 %offset 88
load64 %value %other %offset
nonzero %value census_extension_affine
u64 %offset 96
load64 %value %other %offset
u64 %offset 128
load64 %other_index %other %offset
add %value %value %other_index
le %test %other_index %value
zero %test invalid
le %test %value %work_budget
zero %test invalid
store64 %other %offset %value
jump census_extension_next
label census_extension_affine
u64 %offset 136
load64 %value %other %offset
nonzero %value invalid
u64 %offset 112
load64 %value %other %offset
u64 %offset 136
store64 %other %offset %value
label census_extension_next
add %index %index %one
jump census_extension
label census_done
zero %source_tokens invalid
u64 %index 0
label pending_check
eq %test %index %count
nonzero %test extension_pending_open
call %current seat 3 %records %index %record_size
u64 %offset 400
load64 %value %current %offset
nonzero %value invalid
add %index %index %one
jump pending_check
label extension_pending_open
u64 %index 0
label extension_pending
eq %test %index %rule_count
nonzero %test sort
call %other seat 3 %rules %index %rule_size
u64 %offset 136
load64 %value %other %offset
nonzero %value invalid
add %index %index %one
jump extension_pending
label sort
u64 %step 0
u64 %work 0
u64 %current_bound 0
add %current_bound %current_bound %source_tokens
label select
eq %test %step %count
nonzero %test success
u64 %chosen 255
u64 %index 0
label candidate
eq %test %index %count
nonzero %test candidate_done
call %current seat 3 %records %index %record_size
u64 %offset 368
load64 %value %current %offset
nonzero %value candidate_next
u64 %offset 352
load64 %value %current %offset
nonzero %value candidate_next
u64 %chosen 0
add %chosen %chosen %index
jump candidate_done
label candidate_next
add %index %index %one
jump candidate
label candidate_done
eq %test %chosen %unknown
nonzero %test invalid
call %current seat 3 %records %chosen %record_size
u64 %offset 376
load64 %markers %current %offset
nonzero %markers plan_active
u64 %offset 384
load64 %value %current %offset
nonzero %value plan_active
u64 %index 0
label plan_active_extension
eq %test %index %rule_count
nonzero %test plan_inactive
call %other seat 3 %rules %index %rule_size
u64 %offset 64
load64 %value %other %offset
ne %test %value %chosen
nonzero %test plan_active_extension_next
u64 %offset 120
load64 %value %other %offset
nonzero %value plan_active
label plan_active_extension_next
add %index %index %one
jump plan_active_extension
label plan_inactive
jump plan_settle
label plan_active
add %value %work %current_bound
le %test %work %value
zero %test invalid
le %test %value %work_budget
zero %test invalid
u64 %work 0
add %work %work %value
u64 %offset 288
load64 %value %current %offset
mul %other_index %markers %value
le %test %other_index %current_bound
zero %test invalid
sub %value %current_bound %other_index
u64 %offset 296
load64 %length %current %offset
mul %other_index %markers %length
add %length %value %other_index
le %test %value %length
zero %test invalid
u64 %value 0
add %value %value %length
zero %markers plan_fixed_done
u64 %offset 408
load64 %other_index %current %offset
add %length %value %other_index
le %test %value %length
zero %test invalid
u64 %value 0
add %value %value %length
label plan_fixed_done
u64 %offset 384
load64 %index %current %offset
u64 %offset 312
load64 %length %current %offset
mul %other_index %index %length
le %test %other_index %value
zero %test invalid
sub %value %value %other_index
u64 %offset 392
load64 %length %current %offset
add %length %value %length
le %test %value %length
zero %test invalid
u64 %value 0
add %value %value %length
u64 %index 0
label plan_extension
eq %test %index %rule_count
nonzero %test plan_extension_done
call %other seat 3 %rules %index %rule_size
u64 %offset 64
load64 %length %other %offset
ne %test %length %chosen
nonzero %test plan_extension_next
u64 %offset 120
load64 %length %other %offset
u64 %offset 80
load64 %other_index %other %offset
mul %other_index %length %other_index
le %test %other_index %value
zero %test invalid
sub %value %value %other_index
u64 %offset 128
load64 %length %other %offset
add %length %value %length
le %test %value %length
zero %test invalid
u64 %value 0
add %value %value %length
label plan_extension_next
add %index %index %one
jump plan_extension
label plan_extension_done
le %test %value %work_budget
zero %test invalid
u64 %current_bound 0
add %current_bound %current_bound %value
u64 %offset 128
add %target %current %offset
u64 %offset 272
load64 %length %current %offset
call %value emit 2 %target %length
zero %value invalid
label plan_settle
u64 %offset 368
store64 %current %offset %one
u64 %offset 360
load64 %value %current %offset
eq %test %value %unknown
nonzero %test selected
call %other seat 3 %records %value %record_size
u64 %offset 376
load64 %length %other %offset
u64 %offset 304
load64 %other_index %current %offset
mul %other_index %markers %other_index
add %length %length %other_index
u64 %offset 376
store64 %other %offset %length
u64 %offset 352
load64 %length %other %offset
zero %length invalid
sub %length %length %one
store64 %other %offset %length
label selected
add %step %step %one
jump select
label success
exit 0
label limited
err limited
exit 1
label invalid
err invalid
exit 1
end
