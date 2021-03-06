<?
function sync(){
  global $mhigh, $mlow;
  if( $mlow ){
    outbits( 5 << $mhigh );
    outbits( (4 << $mhigh)+1 );
  }
  else{
    outbits( (4 << $mhigh)+1 );
    outbits( 4 << $mhigh );
  }
}
function outbits($val){
  global $inibit, $bytes;
  for($i= 0; $i<$val; $i++)
//    $bytes.= $inibit ? '@' : '?';
    $bytes.= $inibit ? ' ?' : '? ';
  $inibit^= 1;
}
function pilot($val){
  global $mhigh, $mlow;
  if( $mlow )
    while( $val-- ){
      outbits( 15 << $mhigh );
      outbits( 15 << $mhigh );
    }
  else
    while( $val-- ){
      outbits( 14 << $mhigh );
      outbits( 13 << $mhigh );
    }
}
function block($str, $type){
  $chk= $type;
  for($i= 0; $i<strlen($str); $i++)
    $chk^= ord($str[$i]);
  return chr($type) . $str . chr($chk);
}
$argc==1 && die(
  "\nCargandoLeches Standard WAV generator v0.1 14-02-2012 Antonio Villena, GPLv3 license\n\n".
  "  leches_std file.tap [Sample Rate] [Polarity]\n".
  "  leches_std file.sna [Sample Rate] [Polarity] [Address Patch]\n\n".
  "-Sample Rate: In Khz and rounded (22, 24, 44 or 48). For 22050, 24000, 44100 and 48000Hz\n".
  "-Polarity:    0 or 1. If 1 the WAV signal is inverted. Same results if the signal is balanced\n".
  "-Address Patch: Address used in SNA for storing the register. Must be unused in the game\n\n".
  "Only file is mandatory. Default values are 44 (Sample Rate), 0 (Polarity) and 5780 (Address Patch)\n");
$mlow= $argv[2]==24 || $argv[2]==48 ? 1 : 0;
$mhigh= $argv[2]==22 || $argv[2]==24 ? 0 : 1;
$srate= array(array(22050,24000),array(44100,48000));
$inibit= $argv[3]==1 ? 1 : 0;
$st= array();
for($i= 0; $i<256; $i++){
  if( $mlow )
    for( $j= 0; $j<8; $j++ ){
       outbits( $i<<$j & 0x80 ? 12 << $mhigh: 6 << $mhigh );
       outbits( $i<<$j & 0x80 ? 11 << $mhigh: 6 << $mhigh );
    }
  else
    for( $j= 0; $j<8; $j++ ){
       outbits( $i<<$j & 0x80 ? 11 << $mhigh: 6 << $mhigh );
       outbits( $i<<$j & 0x80 ? 11 << $mhigh: 5 << $mhigh );
    }
  $st[$i]= $bytes;
  $bytes= '';
}
file_exists($argv[1]) || die ("\n  Error: File not exists\n");
$nombre= substr($argv[1],0,-4);
$sna= file_get_contents($argv[1]);
$noprint || print("\nGenerating WAV...");
$fi= fopen($nombre.'.wav', 'w+');
$chan= 2;
fwrite($fi, 'RIFF    WAVEfmt '.pack('L', 16).pack('v', 1).pack('v', $chan).
            pack('L', $srate[$mhigh][$mlow]).pack('L', $srate[$mhigh][$mlow]*$chan).
            pack('v', $chan).pack('v', 8).'data    ');
if( strtolower(substr($argv[1],-3))=='tap' ){
  while( $pos<strlen($sna) ){
    $len= ord($sna[$pos++])|ord($sna[$pos++])<<8;
    pilot( 2000 );
    sync();
    while( $len-- )
      $bytes.= $st[ord($sna[$pos++])];
  }
  fwrite($fi, $bytes);
  $longi+= strlen($bytes);
  $bytes= '';
}
else{
  strtolower(substr($argv[1],-3))=='sna' || die ("\n  Invalid file: Must be TAP or SNA\n");
  $r= ord($sna[20]);
  $parche= isset($argv[4]) ? hexdec($argv[4]) : 0x5780;
  if( strlen($sna)==49179 ){
    $r= (($r&127)-13)&127 | $r&128;
    $sp= ord($sna[23]) | ord($sna[24])<<8;
    $regs=  chr(0x21).substr($sna, 7, 2).chr(0xe5).pack('v', 0x8f1). // AF'
            chr(0x3e).ord($sna[26]).chr(0xd3).chr(0xfe).  // Border
            chr(0x01).substr($sna, 13, 2).                // BC
            chr(0x11).substr($sna, 11, 2).                // DE
            pack('v', 0x21dd).substr($sna, 17, 2).        // IX
            chr(0x3e).chr($r).pack('v', 0x4fed).          // R
            chr(0x21).substr($sna, 21, 2).pack('v', 0xf1e5). // AF
            chr(0x21).substr($sna, 0x8004-0x3fe5, 2).chr(0xe5). // restore stack in HL
            chr(0x21).substr($sna, 0x8002-0x3fe5, 2).chr(0xe5). // restore stack in HL
            chr(0x21).substr($sna, 0x8000-0x3fe5, 2).chr(0xe5). // restore stack in HL
            chr(0x21).substr($sna, 9, 2).                 // HL
            chr(0x31).pack('v', $sp+2).                   // SP
            chr(0xf3|ord($sna[19])<<3).                   // IFF1
            chr(0xc3).substr($sna, $sp-0x3fe5, 2);        // PC
    $bl2= block(chr(0x3e).$sna[0].pack('v', 0x47ed).      // I
                chr(0xde).chr(0xc0).chr(0x37).chr(0x0e).chr(0x8f).chr(0x39).chr(0x96).
                chr(0x01).substr($sna, 5, 2).             // BC'
                chr(0x11).substr($sna, 3, 2).             // DE'
                chr(0x21).substr($sna, 1, 2).chr(0xd9).   // HL'
                chr(0xed).chr(ord($sna[25])==1?0x56:
                              (ord($sna[25])?0x5e:0x46)). // IM
                pack('v', 0x21fd).substr($sna, 15, 2).    // IY
                chr(0x11).pack('v', 0xc000).              // LD DE, $C000
                chr(0x21).pack('v', 0x4000).              // LD HL, $4000
                chr(0x31).pack('v', 0x8008).              // LD SP, $8008
                chr(0xc3).pack('v', 0x07f4), 255);        // JP $07F4
    $sna=   substr($sna, 27, 0x4002).
            pack('vv', 0x05cd, $parche).
            substr($sna, 0x8006-0x3fe5);
    $sna=   block(substr($sna, 0, $parche-0x4000).
                  $regs.
                  substr($sna, $parche+strlen($regs)-0x4000), 255);
    $bl1= block("\0".substr(str_pad($nombre,10),0,10).pack('vvv', 39, 0,  39), 0);
    pilot( 2000 );
    sync();
    for( $i= 0; $i<19; $i++ )
      $bytes.= $st[ord($bl1[$i])];
    pilot( 2000 );
    sync();
    for( $i= 0; $i<41; $i++ )
      $bytes.= $st[ord($bl2[$i])];
    pilot( 2000 );
    sync();
    for( $i= 0; $i<0xc002; $i++ )
      $bytes.= $st[ord($sna[$i])];
  }
  else{
    $r= (($r&127)-7)&127 | $r&128;
    strlen($sna)==131103 || die ("\n  Invalid length for SNA file: Must be 49179 or 131103\n");
    $page[5]= substr($sna, 27, 0x4000);
    $rutina=  chr(0xd9).                         // BFE6    EXX
              chr(0x1c).                         // BFF7    INC   E
              chr(0xcb).chr(0x5b).               // BFE8    BIT   3, E
              chr(0xc2).pack('v', $parche).      // BFEA    JP    NZ, PARCHE
              chr(0xed).chr(0x59).               // BFED    OUT   (C), E
              chr(0xd9).                         // BFEF    EXX
              chr(0x3b).                         // BFF0    DEC   SP
              chr(0x3b).                         // BFF1    DEC   SP
              chr(0x16).chr(0x40).               // BFF2    LD    D, $40
              chr(0xdd).chr(0x26).chr(0xc0).     // BFF4    LD    IXH, $C0
              chr(0xc3).pack('v', 0x05c8).       // BFF7    JP    $05c8
              pack('vv', 0, 0);                  // BFFA
    $rutina.= pack('v', 0xbffe-strlen($rutina));
    $antp2= substr($sna, 0x801b-strlen($rutina), strlen($rutina));
    $page[2]= substr($sna, 0x401b, 0x4000-strlen($rutina)).$rutina;
    $last= ord($sna[0xc01d])&7;
    $page[$last]= substr($sna, 21, 2).
                  substr($sna, 0x801d, 0x3ffe);
    for($i= 0; $i<8; $i++)
      if(($last!=$i)&&($i!=2)&&($i!=5))
        $page[$i]= substr($sna, 0xc01f+$next++*0x4000, 0x4000);
    $regs=  chr(0x3e).$sna[0xc01d].chr(0xed).chr(0x79).  // last 7FFD
            chr(0x01).substr($sna, 5, 2).                // BC'
            chr(0x1e).$sna[3].chr(0xd9).                 // E'
            chr(0x21).substr($sna, 7, 2).chr(0xe5).pack('v', 0x8f1). // AF'
            chr(0x01).pack('v', strlen($antp2)).         // LD   BC, len(antp2)
            chr(0x11).pack('v', 0xc000-strlen($antp2)).  // LD   DE, $c000-len(antp2)
            chr(0x21).pack('v', $parche+62).             // LD   HL, point
            chr(0xed).chr(0xb0).                         // LDIR
            chr(0x3e).ord($sna[26]).chr(0xd3).chr(0xfe). // Border
            chr(0x01).substr($sna, 13, 2).               // BC
            chr(0x11).substr($sna, 11, 2).               // DE
            pack('v', 0x21dd).substr($sna, 17, 2).       // IX
            chr(0x3e).chr($r).pack('v', 0x4fed).         // R
            chr(0xf1).                                   // AF
            chr(0x21).substr($sna, 0x801b, 2).chr(0x22).pack('v', 0xc000).// last stack value
            chr(0x21).substr($sna, 9, 2).                // HL
            chr(0x31).substr($sna, 23, 2).               // SP
            chr(0xf3|ord($sna[19])<<3).                  // IFF1
            chr(0xc3).substr($sna, 0xc01b, 2).           // PC
            $antp2;
    $bl2= block(chr(0x11).chr(0x10).$sna[4].             // D' E=$10
                chr(0x0e).chr(0xfd).                     // LD    C, $FD
                chr(0xc0).chr(0x38).chr(0x0e).chr(0x8f).chr(0x39).chr(0x96).
                chr(0x06).chr(0x7f).                     // LD    B, $7F
                chr(0x21).substr($sna, 1, 2).            // HL'
                chr(0xd9).                               // EXX
                chr(0x3e).$sna[0].pack('v', 0x47ed).     // I
                chr(0xed).chr(ord($sna[25])==1?0x56:
                             (ord($sna[25])?0x5e:0x46)). // IM
                pack('v', 0x21fd).substr($sna, 15, 2).   // IY
                chr(0x11).pack('v', 0x4000+strlen($rutina)).//LD  DE, $401b
                chr(0x21).pack('v', 0xc000-strlen($rutina)).//LD  HL, $BFE5
                chr(0x31).pack('v', 0xc002).             // LD    SP, $C002
                chr(0xc3).pack('v', 0x07f4), 255);       // JP    $07F4
    if($parche<0x8000)
      $page[5]= substr($page[5], 0, $parche-0x4000).
                $regs.
                substr($page[5], $parche+strlen($regs)-0x4000);
    else
      $page[2]= substr($page[2], 0, $parche-0x8000).
                $regs.
                substr($page[2], $parche+strlen($regs)-0x8000);
    $bl1= block("\0".substr(str_pad($nombre,10),0,10).pack('vvv', 39, 0,  39), 0);
    pilot( 2000 );
    sync();
    for( $i= 0; $i<19; $i++ )
      $bytes.= $st[ord($bl1[$i])];
    pilot( 2000 );
    sync();
    for( $i= 0; $i<41; $i++ )
      $bytes.= $st[ord($bl2[$i])];
    pilot( 2000 );
    sync();
    $bl3= block($rutina.$page[0], 255);
    for( $i= 0; $i<0x4002+strlen($rutina); $i++ )
      $bytes.= $st[ord($bl3[$i])];
    for($i= 1; $i<8; $i++){
      $page[$i]= block($page[$i], 0);
      for($j= 1; $j<0x4002; $j++)
        $bytes.= $st[ord($page[$i][$j])];
    }
  }
}
pilot( 4*300 );
fwrite($fi, $bytes);
$longi+= strlen($bytes);
fseek($fi, 4);
fwrite($fi, pack('L', $longi+36));
fseek($fi, 40);
fwrite($fi, pack('L', $longi));
fclose($fi);
$noprint || print("Done\n");