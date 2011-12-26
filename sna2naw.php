<?
function outbits($val){
  global $inibit;
  for($i= 0; $i<$val; $i++)
    outbit($inibit);
  $inibit^= 1;
}
function outbits_double($val){
  outbits($val);
  outbits($val);
}
function outbit($val){
  global $bytes, $byte;
  $byte= $byte*2+$val;
  if($byte>255){
    $bytes.= chr($byte & 255);
    $byte= 1;
  }
}
function pilot($val){
  global $muest;
  while( $val-- )
    outbits_double($muest);
}
$tabla1= array( array(1,2,2,3), // 0
                array(2,2,3,3), // 1
                array(2,3,3,4), // 2
                array(3,3,4,4), // 3
                array(1,2,3,4), // 4
                array(2,3,4,5), // 5
                array(2,3,4,5), // 6
                array(3,4,5,6));// 7
$tabla2= array( array(1,1,2,2), // 0
                array(1,2,2,3), // 1
                array(2,2,3,3), // 2
                array(2,3,3,4), // 3
                array(1,2,3,4), // 4
                array(1,2,3,4), // 5
                array(2,3,4,5), // 6
                array(2,3,4,5));// 7
$termin= array( array( 21, 22, 23, 24, 23, 24, 25, 26),  // 0 1 2 3 4 5 6 7
                array( 13, 14, 15, 16, 15, 16, 17, 18)); // 0 1 2 3 4 5 6 7
$byvel=  array( array( 0xed, 0xde, 0xd2, 0xc3, 0x00, 0x71, 0x62, 0x53),  // 0 1 2 3 4 5 6 7
                array( 0xf1, 0xe2, 0xd6, 0xc7, 0x04, 0x78, 0x69, 0x5d)); // 0 1 2 3 4 5 6 7
$cont= file_get_contents($_SERVER['argv'][1]);
$velo= isset($_SERVER['argv'][2]) ? $_SERVER['argv'][2] : 3;
$muest= $_SERVER['argv'][3]==48 ? 13 : 12;
$inibit= $_SERVER['argv'][4]==1 ? 1 : 0;
$skip= $_SERVER['argv'][5]=='skip' ? 1 : 0;
$parche= isset($_SERVER['argv'][6]) ? hexdec($_SERVER['argv'][6]) : 0x5b00;
$tzx= "ZXTape!\32\1\24\25".chr($muest&1?73:79)."\0\0\0\10";
$byte= 1;
$pos= 27;
$long= 49152+$pos;
$r= ord($cont[20]);
$r= (($r&127)-5)&127 | $r&128;
$sp= ord($cont[23]) | ord($cont[24])<<8;
$regs=  substr($cont, 0xff48-0x3fe5, 4).          // stack padding
        substr($cont, 5, 2).                      // BC'
        substr($cont, 3, 2).                      // DE'
        substr($cont, 1, 2).                      // HL'
        substr($cont, 7, 2).                      // AF'
        substr($cont, 13, 2).                     // BC
        substr($cont, 11, 2).                     // DE
        $cont[0].chr($r).                         // IR
        substr($cont, 17, 2).                     // IX
        substr($cont, 15, 2).                     // IY
        chr(ord($cont[25])>>1                     // IM
          | ord($cont[19])<<7                     // IFF1
          | ord($cont[26])<<1).                   // Border
        substr($cont, 21, 2).                     // AF
        chr(0x21) . substr($cont, 9, 2).          // HL
        chr(0x31) . pack('v', $sp+2).             // SP
        chr(0xc3) . substr($cont, $sp-0x3fe5, 2); // PC
$cont=  substr($cont, 0, 0xff48-0x3fe5).
        pack('vv', 0x39c2, $parche).
        substr($cont, 0xff4c-0x3fe5);
$cont=  substr($cont, 0, $parche-0x3fe5).
        $regs.
        substr($cont, $parche+34-0x3fe5);
pilot( 1000 );
outbits_double(3);
$c26= 26;
$b26= $byvel[$muest&1][$velo]         // byte velo
    | 1<<8                            // bit snapshot activado
    | 0<<9                            // bit checksum desactivado
    | 0<<10                           // byte flag
    | $checksum<<18;                  // checksum
while( $c26-- ){
  outbits_double( $b26&0x2000000 ? 3 : 6 );
  $b26<<= 1;
}
outbits_double(2);
while($pos<$long){
  $val= ord($cont[$pos]) >> 6;
  outbits($tabla1[$velo][$val^3]);
  outbits($tabla2[$velo][$val^3]);
  $val= ord($cont[$pos]) >> 4 & 3;
  outbits($tabla1[$velo][$val]);
  outbits($tabla2[$velo][$val]);
  $val= ord($cont[$pos]) >> 2 & 3;
  outbits($tabla1[$velo][$val^2]);
  outbits($tabla2[$velo][$val^2]);
  $val= ord($cont[$pos++]) & 3;
  outbits($tabla1[$velo][$val^1]);
  outbits($tabla2[$velo][$val^1]);
}
outbits($termin[$muest&1][$velo]>>1);
outbits($termin[$muest&1][$velo]-($termin[$muest&1][$velo]>>1));
outbits_double(3);
pilot( 200 );
$longi= strlen($bytes);
echo substr($_SERVER['argv'][1],0,-4).'.tzx';
file_put_contents(substr($_SERVER['argv'][1],0,-4).'.tzx',
                  $tzx.chr($longi&255).chr($longi>>8&255).chr($longi>>16&255).$bytes);
/*
    POP HL
    LD  SP,HL
    POP HL            ; reemplazo pila, 4 bytes
    LD  (ff40), HL
    POP HL
    LD  (ff42), HL
    POP BC            ; BC'
    POP DE            ; DE'
    POP HL            ; HL'
    EXX
    POP AF            ; AF'
    EX  AF,AF'
    POP BC            ; BC
    POP DE            ; DE
    POP HL            ; IR
    POP IX            ; IX
    POP IY            ; IY
    LD  A,L
    LD  I,A
    POP AF            ; IM,IFF
    JR  C,im2
    im  2
im2 JR  Z,nei
    EI
nei DEC SP
    LD  A,H
    LD  HL,0002
    ADD HL,SP
    LD  R,A
    POP AF            ; AF
    JP  (HL)

    LD  HL,XXXX       ; HL
    LD  SP,XXXX       ; SP
    JP  XXXX          ; PC

38fa 1
390c 1
39f3 8
3a98 17
3ac2 1
3bfa 1
3c02 1
3c05 4

total 34

*/