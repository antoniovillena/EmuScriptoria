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
  global $bytes;
  $bytes.= $val ? '@' : '?';
//  $bytes.= $val ? ' ' : '?';
//  $bytes.= $val ? ' ?' : '? ';
}
function pilot($val, $samples= 6){
  global $mhigh;
  while( $val-- )
    outbits_double( $samples << $mhigh );
}
function loadconf($b24){
  global $mhigh;
  outbits( 6 << $mhigh );
  outbits( 14 << $mhigh );
  pilot( 3 );
  outbits(1 << $mhigh);
  outbits((1 << $mhigh)+3);
  $c24= 24;
  while( $c24-- ){
    if (($c24==7 || $c24==7) && $mhigh){
      outbits( $b24&0x800000 ? 4 : 8 );
      outbits( $b24&0x800000 ? 5 : 9 );
    }
    else
      outbits_double( ($b24&0x800000 ? 2 : 4) << $mhigh );
    $b24<<= 1;
  }
  outbits_double(1 << $mhigh);
}
$tabla1= array( array(1,2,2,3), array(2,2,3,3), array(2,3,3,4), array(3,3,4,4),
                array(1,2,3,4), array(2,3,4,5), array(2,3,4,5), array(3,4,5,6), array(1,1,2,2));
$tabla2= array( array(1,1,2,2), array(1,2,2,3), array(2,2,3,3), array(2,3,3,4),
                array(1,2,3,4), array(1,2,3,4), array(2,3,4,5), array(2,3,4,5), array(1,2,2,3));
$byvel= array(  array(0xed, 0xde, 0xd2, 0xc3, 0x00, 0x71, 0x62, 0x53, 0x62),
                array(0xf1, 0xe5, 0xd6, 0xc7, 0x04, 0x78, 0x69, 0x5d, 0x69));
$termin=array(  array( 21, 22, 23, 24, 23, 24, 25, 26, 13),
                array( 13, 14, 15, 16, 15, 16, 17, 18, 9));
$argc==1 && die(
  "\nLeches WAV generator v0.1 28-10-2012 Antonio Villena, GPLv3 license\n\n".
  "  leches file.tap [Speed] [Sample Rate] [Polarity] [Offset]\n\n".
  "-Speed:       A number between 0 and 7. [0..3] for Safer and [4..7] for Reckless. Lower is faster\n".
  "-Sample Rate: In Khz and rounded (22, 24, 44 or 48). For 22050, 24000, 44100 and 48000Hz\n".
  "-Polarity:    0 or 1. If 1 the WAV signal is inverted. Same results if the signal is balanced\n".
  "-Offset:      -2,-1,0,1 or 2. Fine grain adjust for symbol offset. Change if you see loading errors \n".
  "Only file is mandatory. Default values for the rest of parameters are: 3 (Speed), 44 (Sample Rate), ".
  "0 (Polarity) and 0 (Offset)\n");
file_exists($argv[1]) || die ("\n  Error: File not exists\n");
$velo= isset($argv[2]) ? $argv[2] : 3;
$mlow= $argv[3]==24 || $argv[3]==48 ? 1 : 0;
$mhigh= $argv[3]==22 || $argv[3]==24 ? 0 : 1;
if(!$mhigh)
  $velo= 8;
$refconf= ($byvel[$mlow][$velo]                                     &128)
        + ($byvel[$mlow][$velo]+3*hexdec(isset($argv[5])?$argv[5]:0)&127);
$srate= array(array(22050,24000),array(44100,48000));
$inibit= $argv[4]==1 ? 1 : 0;
$noprint || print("\nGenerating WAV...");
$st= array();
for($i= 0; $i<256; $i++){
  $val= $i >> 6;
  outbits($tabla1[$velo][$val]);
  outbits($tabla2[$velo][$val]);
  $val= $i >> 4 & 3;
  outbits($tabla1[$velo][$val]);
  outbits($tabla2[$velo][$val]);
  $val= $i  >> 2 & 3;
  outbits($tabla1[$velo][$val]);
  outbits($tabla2[$velo][$val]);
  $val= $i  & 3;
  outbits($tabla1[$velo][$val]);
  outbits($tabla2[$velo][$val]);
  $st[$i]= $bytes;
  $bytes= '';
}
$sna= file_get_contents($argv[1]);
$long= strlen($sna);
$lastbl= $pos= 0;
while($pos<$long){
  $len= ord($sna[$pos])|ord($sna[$pos+1])<<8;
  pilot( $lastbl ? 2000+700 : 200+700 );
  loadconf( $refconf
          | ord($sna[$pos+2])<<8            // byte flag
          | ord($sna[$pos+$len+1])<<16);    // checksum
  for($i= 2; $i<$len; $i++)
    $bytes.= $st[ord($sna[$pos+1+$i])];
  outbits($termin[$mlow][$velo]>>1);
  outbits($termin[$mlow][$velo]-($termin[$mlow][$velo]>>1));
  outbits_double(1 << $mhigh);
  $lastbl= ord($sna[$pos+2]);
  $pos+= $len+2;
}
pilot( 700 );
$longi= strlen($bytes);
$noprint || print("Done\n");
$chan= 1;
$output=  'RIFF'.pack('L', $longi+36).'WAVEfmt '.pack('L', 16).pack('v', 1).pack('v', $chan).
          pack('L', $srate[$mhigh][$mlow]).pack('L', $srate[$mhigh][$mlow]*$chan).
          pack('v', $chan).pack('v', 8).'data'.pack('L', $longi).$bytes;
$noprint || file_put_contents(substr($argv[1],0,-4).'.wav', $output);