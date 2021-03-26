.thumb
.org 0x270
rom_start:

@.org 0x00008108-rom_start
.org 0x000022BC-rom_start
sub_regen_hook:
  bl regen

.org 0x0000329C-rom_start
flight_subtract_hook:
  push {lr}
  bl flight_subtract

.org 0x00005CA8-rom_start
damage_check:

.org 0x00007354-rom_start
sub_damage_hook:
  bl damage
.org 0x0000739A-rom_start
  nop
.org 0x000073B0-rom_start
  nop
.org 0x000073C6-rom_start
  nop


.org 0x000074AE-rom_start
sub_goku_damage_hook:
  bl set_damage_as_goku

.org 0x00008016-rom_start
sub_08008016:

.org 0x114A8-rom_start
stat_tables:
.4byte 0xFFFFFFFF, 0x0000001F4, 0x0000190, 0x00000032 @ Level 1
.4byte 0x0000015E, 0x000000208, 0x00001B8, 0x00000034 @ Level 2
.4byte 0x000001F4, 0x000000226, 0x000021C, 0x00000036 @ Level 3
.4byte 0x00000384, 0x00000025D, 0x00002A8, 0x00000038 @ Level 4
.4byte 0x00000640, 0x00000029E, 0x0000348, 0x0000003A @ Level 5
.4byte 0x00000C80, 0x0000002F3, 0x00003FC, 0x0000003C @ Level 6
.4byte 0x00001900, 0x00000035C, 0x00004E2, 0x0000003E @ Level 7
.4byte 0x00003200, 0x0000003D4, 0x00005E6, 0x00000041 @ Level 8
.4byte 0x00006400, 0x000000460, 0x000074E, 0x00000043 @ Level 9
.4byte 0x000076C0, 0x0000004F6, 0x00008F2, 0x00000045 @ Level 10
.4byte 0x0000ABE0, 0x000000596, 0x0000ABE, 0x00000047 @ Level 11
.4byte 0x000123A8, 0x000000686, 0x0000CDA, 0x00000049 @ Level 12
.4byte 0x000186A0, 0x00000079E, 0x0000F82, 0x0000004A @ Level 13
.4byte 0x0001C240, 0x0000008F2, 0x00012B6, 0x0000004C @ Level 14
.4byte 0x0001EE90, 0x000000A78, 0x000164E, 0x0000004E @ Level 15
.4byte 0x00026C20, 0x000000C4E, 0x0001A4A, 0x00000050 @ Level 16
.4byte 0x00034460, 0x000000E60, 0x0001F0E, 0x00000052 @ Level 17
.4byte 0x0004A120, 0x0000010B8, 0x0002440, 0x00000054 @ Level 18
.4byte 0x00059CF0, 0x00000136A, 0x0002A1C, 0x00000056 @ Level 19
.4byte 0x00065500, 0x000001644, 0x00030A2, 0x00000058 @ Level 20
.4byte 0x0007BBA0, 0x00000196E, 0x000380E, 0x0000005A @ Level 21
.4byte 0x00094240, 0x000001CC0, 0x0004024, 0x0000005C @ Level 22
.4byte 0x000B91C0, 0x00000203A, 0x0004902, 0x0000005E @ Level 23
.4byte 0x000C4D60, 0x0000023E6, 0x0005230, 0x00000060 @ Level 24
.4byte 0x000E0000, 0x0000027D8, 0x0005C08, 0x00000063 @ Level 25

.arm
.text
.org 0x00100000
.global main
main:
  mov r0, #100
  mov r1, #10
  mul r0, r1
  add r0, #1
  bx r0


.org 0x0014BF00-rom_start
.thumb
damage:
  push {lr}
  push {r1, r2}
  mov r3, r3
  bpl damage_continue
  mov r1, #0
  sub r1, #1
  mul r3, r1
  lsr r3, #1
damage_continue:
  ldr r1, is_goku_damage
  ldr r2, [r1, #0]
  cmp r2, #0
  beq enemy_damage
  mov r2, #3
  mul r3, r2
  mov r2, #0
  str r2, [r1, #0]
  b damage_finish
.byte 0x00, 0x00
is_goku_damage:
  .4byte 0x02004D00
enemy_damage:
  mov r1, #100
  cmp r3, r1
  bcc damage_less_than_100
  mov r1, #250
  lsl r1, #2
  cmp r3, r1
  bcc damage_less_than_1000
  mov r1, #3
  b divide_damage
damage_less_than_100:
  mov r1, #1
  b divide_damage
damage_less_than_1000:
  mov r1, #2
  b divide_damage
divide_damage:
  asr r3, r1
damage_finish:
  pop {r1, r2}
  add r0, #128       @ thing we wrote over
  ldrh r0, [r0, #26] @ ^
  pop {pc}
no_regen_counter1:
  .4byte 0x02004D04

set_damage_as_goku:
  push {lr}
  push {r1, r2}
  mov r2, #1
  ldr r1, is_goku_damage2
  stmia r1!, {r2}
  bl damage_check
  pop {r1, r2}
  pop {pc}
  .byte 0x00, 0x00
is_goku_damage2:
  .4byte 0x02004D00

regen:
  push {lr}
  push {r0, r1, r2, r3, r4}

@ Flight Regen
  ldr r0, flight_set_var
  ldr r1, [r0, #0]
  cmp r1, #0
  beq flight_regen_continue
  sub r1, #1
  str r1, [r0, #0]
  b regen_return
flight_regen_continue:
  ldr r0, flight
  ldrb r3, [r0, #0]
  ldrb r1, [r0, #1]
  mov r2, r3
  lsr r2, #5
  add r1, r2
  add r1, #1
  cmp r1, r3
  bcc flight_set
  mov r1, r3
flight_set:
  strb r1, [r0, #1]
  ldr r0, flight_set_var
  mov r1, #32
  str r1, [r0, #0]

regen_return:
  pop {r0, r1, r2, r3, r4}
  bl sub_08008016 @ thing we wrote over
  pop {pc}
.byte 0x00, 0x00
flight:
  .4byte 0x030007AC
flight_set_var:
  .4byte 0x02004D08

flight_subtract:
  push {r2, r3}
  ldr r2, flight_set_var2
  mov r3, #32
  str r3, [r2, #0]
  strb r0, [r1, #1] @ thing we wrote over
  mov r0, #1        @ ^
  pop {r2, r3}
  pop {pc}
flight_set_var2:
  .4byte 0x02004D08

.org 0x006B61CC-rom_start
raditz_health:
  .4byte 0x00005DC0

.org 0x006B634C-rom_start
bankrobber1_health:
  .4byte 0x00000320

.org 0x006B638C-rom_start
bankrobber2_health:
  .4byte 0x00000320

.org 0x006B650C-rom_start
ginyu_health:
  .4byte 0x000445C0

.org 0x006B68CC-rom_start
vegeta_health:
  .4byte 0x00009C40




