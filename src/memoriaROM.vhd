library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 15;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
  
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant CGE  : std_logic_vector(3 downto 0) := "1010";
  constant JGE  : std_logic_vector(3 downto 0) := "1011";
  constant CLE  : std_logic_vector(3 downto 0) := "1100";
  constant JLE  : std_logic_vector(3 downto 0) := "1101";
  constant RET  : std_logic_vector(3 downto 0) := "1110";

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:
		-- Desta posicao para baixo, é necessário acertar os valores
tmp(0) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(1) := x"5" & "00" & '0' & x"00";  -- STA R0 @0
tmp(2) := x"5" & "00" & '0' & x"02";  -- STA R0 @2
tmp(3) := x"4" & "00" & '0' & x"01";  -- LDI R0 $1
tmp(4) := x"5" & "00" & '0' & x"01";  -- STA R0 @1
tmp(5) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(6) := x"5" & "00" & '1' & x"00";  -- STA R0 @256
tmp(7) := x"5" & "00" & '1' & x"01";  -- STA R0 @257
tmp(8) := x"5" & "00" & '1' & x"02";  -- STA R0 @258
tmp(9) := x"5" & "00" & '1' & x"20";  -- STA R0 @288	# DISPLAY1
tmp(10) := x"5" & "00" & '1' & x"21";  -- STA R0 @289	# DISPLAY2
tmp(11) := x"5" & "00" & '1' & x"22";  -- STA R0 @290	# DISPLAY3
tmp(12) := x"5" & "00" & '1' & x"23";  -- STA R0 @291	# DISPLAY4
tmp(13) := x"5" & "00" & '1' & x"24";  -- STA R0 @292	# DISPLAY5
tmp(14) := x"5" & "00" & '1' & x"25";  -- STA R0 @293	# DISPLAY6
tmp(15) := x"5" & "00" & '0' & x"02";  -- STA R0 @2	# UNIDADE
tmp(16) := x"5" & "00" & '0' & x"03";  -- STA R0 @3	# DEZENA
tmp(17) := x"5" & "00" & '0' & x"04";  -- STA R0 @4	# CENTENA
tmp(18) := x"5" & "00" & '0' & x"05";  -- STA R0 @5	# UNIDADE_MILHAR
tmp(19) := x"5" & "00" & '0' & x"06";  -- STA R0 @6	# DEZENA_MILHAR
tmp(20) := x"5" & "00" & '0' & x"07";  -- STA R0 @7	# CENTENA_MILHAR
tmp(21) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(22) := x"5" & "00" & '0' & x"08";  -- STA R0 @8
tmp(23) := x"4" & "00" & '0' & x"06";  -- LDI R0 $6
tmp(24) := x"5" & "00" & '0' & x"09";  -- STA R0 @9	# M[9] = 6 #DEZENA SEGUNDO
tmp(25) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(26) := x"5" & "00" & '0' & x"0A";  -- STA R0 @10	# M[10] = 0 #UNIDADE SEGUNDO
tmp(27) := x"4" & "00" & '0' & x"06";  -- LDI R0 $6
tmp(28) := x"5" & "00" & '0' & x"0B";  -- STA R0 @11	# M[11] = 6 # DEZENA MINUTO
tmp(29) := x"4" & "00" & '0' & x"04";  -- LDI R0 $4
tmp(30) := x"5" & "00" & '0' & x"0C";  -- STA R0 @12	# M[12] = 4 #UNIDADE HORA
tmp(31) := x"4" & "00" & '0' & x"02";  -- LDI R0 $2
tmp(32) := x"5" & "00" & '0' & x"0D";  -- STA R0 @13	# M[13] = 2 #DEZENA_MILHAR
tmp(33) := x"4" & "00" & '0' & x"0A";  -- LDI R0 $10
tmp(34) := x"5" & "00" & '0' & x"0E";  -- STA R0 @14	# M[14] = 6 UNIDADE MINUTO
tmp(35) := x"4" & "00" & '0' & x"06";  -- LDI R0 $6
tmp(36) := x"5" & "00" & '0' & x"0F";  -- STA R0 @15
tmp(37) := x"4" & "00" & '0' & x"02";  -- LDI R0 $2
tmp(38) := x"5" & "00" & '0' & x"10";  -- STA R0 @16
tmp(39) := x"4" & "00" & '0' & x"0A";  -- LDI R0 $10
tmp(40) := x"5" & "00" & '0' & x"11";  -- STA R0 @17
tmp(41) := x"4" & "00" & '0' & x"03";  -- LDI RO $3
tmp(42) := x"5" & "00" & '0' & x"12";  -- STA RO @18
tmp(43) := x"4" & "00" & '0' & x"03";  -- LDI R0 $3
tmp(44) := x"5" & "00" & '0' & x"13";  -- STA R0 @19
tmp(45) := x"4" & "00" & '0' & x"01";  -- LDI RO $1
tmp(46) := x"5" & "00" & '0' & x"14";  -- STA RO @20
tmp(47) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(48) := x"5" & "00" & '0' & x"15";  -- STA R0 @21
tmp(49) := x"6" & "00" & '0' & x"39";  -- JMP  START2
tmp(50) := x"0" & "00" & '0' & x"00";  -- NOP  
tmp(51) := x"4" & "00" & '0' & x"01";  -- LDI R0 @1
tmp(52) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(53) := x"6" & "00" & '0' & x"3D";  -- JMP  START
tmp(54) := x"4" & "00" & '0' & x"00";  -- LDI R0 @0
tmp(55) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(56) := x"6" & "00" & '0' & x"3D";  -- JMP  START
tmp(57) := x"1" & "00" & '1' & x"42";  -- LDA R0 @322
tmp(58) := x"8" & "00" & '0' & x"01";  -- CEQ R0 @1
tmp(59) := x"7" & "00" & '0' & x"33";  -- JEQ  COMECA_HORARIO_AMPM
tmp(60) := x"6" & "00" & '0' & x"36";  -- JMP  COMECA_HORARIO_24H
tmp(61) := x"1" & "00" & '1' & x"60";  -- LDA  @352
tmp(62) := x"8" & "00" & '0' & x"01";  -- CEQ  @1
tmp(63) := x"7" & "00" & '0' & x"CF";  -- JEQ  CHECK_FPGA
tmp(64) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(65) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(66) := x"7" & "00" & '0' & x"3D";  -- JEQ  START
tmp(67) := x"9" & "00" & '0' & x"47";  -- JSR  HORARIO
tmp(68) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(69) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(70) := x"6" & "00" & '0' & x"3D";  -- JMP  START
tmp(71) := x"1" & "00" & '1' & x"42";  -- LDA  @322
tmp(72) := x"8" & "00" & '0' & x"00";  -- CEQ R0 @0
tmp(73) := x"7" & "00" & '0' & x"7F";  -- JEQ  HORARIO_COMECO_DEZENA_HORA
tmp(74) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(75) := x"4" & "00" & '0' & x"20";  -- LDI R0 $32
tmp(76) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(77) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(78) := x"A" & "00" & '0' & x"10";  -- CGE R0 @16	# DEFININDO DEZENA HORA
tmp(79) := x"B" & "00" & '0' & x"4B";  -- JGE  TAG_DEZ_HORA_12H
tmp(80) := x"5" & "00" & '0' & x"07";  -- STA  @7
tmp(81) := x"5" & "00" & '1' & x"25";  -- STA  @293
tmp(82) := x"1" & "00" & '1' & x"63";  -- LDA  @355	# DEFININDO AM/PM
tmp(83) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(84) := x"7" & "00" & '0' & x"61";  -- JEQ  AM_PM_DEFININDO
tmp(85) := x"5" & "00" & '1' & x"FC";  -- STA  @508
tmp(86) := x"1" & "00" & '0' & x"15";  -- LDA  @21
tmp(87) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(88) := x"7" & "00" & '0' & x"5D";  -- JEQ  ACENDE_LED
tmp(89) := x"4" & "00" & '0' & x"00";  -- LDI  $0
tmp(90) := x"5" & "00" & '0' & x"15";  -- STA  @21
tmp(91) := x"5" & "00" & '1' & x"02";  -- STA  @258
tmp(92) := x"6" & "00" & '0' & x"61";  -- JMP  AM_PM_DEFININDO
tmp(93) := x"1" & "00" & '0' & x"01";  -- LDA  @1
tmp(94) := x"5" & "00" & '0' & x"15";  -- STA  @21
tmp(95) := x"1" & "10" & '0' & x"01";  -- LDA R2 @1
tmp(96) := x"5" & "10" & '1' & x"02";  -- STA R2 @258
tmp(97) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(98) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(99) := x"7" & "00" & '0' & x"4B";  -- JEQ  TAG_DEZ_HORA_12H
tmp(100) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(101) := x"4" & "00" & '0' & x"30";  -- LDI R0 $48
tmp(102) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(103) := x"1" & "01" & '0' & x"07";  -- LDA R1 @7
tmp(104) := x"8" & "01" & '0' & x"01";  -- CEQ R1 @1
tmp(105) := x"7" & "00" & '0' & x"73";  -- JEQ  HORA_IGUAL_1_12H
tmp(106) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(107) := x"A" & "00" & '0' & x"11";  -- CGE R0 @17	# DEFININDO UNIDADE HORA
tmp(108) := x"B" & "00" & '0' & x"65";  -- JGE  TAG_UNI_HORA_12H
tmp(109) := x"5" & "00" & '0' & x"06";  -- STA  @6
tmp(110) := x"5" & "00" & '1' & x"24";  -- STA  @292
tmp(111) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(112) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(113) := x"7" & "00" & '0' & x"65";  -- JEQ  TAG_UNI_HORA_12H
tmp(114) := x"6" & "00" & '0' & x"A1";  -- JMP  HORARIO_COMECO_DEZENA_MINUTO
tmp(115) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(116) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(117) := x"7" & "00" & '0' & x"73";  -- JEQ  HORA_IGUAL_1_12H
tmp(118) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(119) := x"A" & "00" & '0' & x"12";  -- CGE R0 @18	# DEFININDO UNIDADE HORA
tmp(120) := x"B" & "00" & '0' & x"73";  -- JGE  HORA_IGUAL_1_12H
tmp(121) := x"5" & "00" & '0' & x"06";  -- STA  @6
tmp(122) := x"5" & "00" & '1' & x"24";  -- STA  @292
tmp(123) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(124) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(125) := x"7" & "00" & '0' & x"73";  -- JEQ  HORA_IGUAL_1_12H
tmp(126) := x"6" & "00" & '0' & x"A1";  -- JMP  HORARIO_COMECO_DEZENA_MINUTO
tmp(127) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(128) := x"4" & "00" & '0' & x"20";  -- LDI R0 $32
tmp(129) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(130) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(131) := x"A" & "00" & '0' & x"12";  -- CGE R0 @18	# DEFININDO DEZENA HORA
tmp(132) := x"B" & "00" & '0' & x"80";  -- JGE  TAG_DEZ_HORA
tmp(133) := x"5" & "00" & '0' & x"07";  -- STA  @7
tmp(134) := x"5" & "00" & '1' & x"25";  -- STA  @293
tmp(135) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(136) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(137) := x"7" & "00" & '0' & x"80";  -- JEQ  TAG_DEZ_HORA
tmp(138) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(139) := x"4" & "00" & '0' & x"30";  -- LDI R0 $48
tmp(140) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(141) := x"1" & "01" & '0' & x"07";  -- LDA R1 @7
tmp(142) := x"C" & "01" & '0' & x"01";  -- CLE R1 @1
tmp(143) := x"D" & "00" & '0' & x"99";  -- JLE  HORA_MENOR_IGUAL_1
tmp(144) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(145) := x"A" & "00" & '0' & x"0C";  -- CGE R0 @12	# DEFININDO UNIDADE HORA
tmp(146) := x"B" & "00" & '0' & x"8B";  -- JGE  TAG_UNI_HORA
tmp(147) := x"5" & "00" & '0' & x"06";  -- STA  @6
tmp(148) := x"5" & "00" & '1' & x"24";  -- STA  @292
tmp(149) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(150) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(151) := x"7" & "00" & '0' & x"8B";  -- JEQ  TAG_UNI_HORA
tmp(152) := x"6" & "00" & '0' & x"A1";  -- JMP  HORARIO_COMECO_DEZENA_MINUTO
tmp(153) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(154) := x"A" & "00" & '0' & x"11";  -- CGE R0 @17	# DEFININDO UNIDADE HORA
tmp(155) := x"B" & "00" & '0' & x"99";  -- JGE  HORA_MENOR_IGUAL_1
tmp(156) := x"5" & "00" & '0' & x"06";  -- STA  @6
tmp(157) := x"5" & "00" & '1' & x"24";  -- STA  @292
tmp(158) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(159) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(160) := x"7" & "00" & '0' & x"99";  -- JEQ  HORA_MENOR_IGUAL_1
tmp(161) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(162) := x"4" & "00" & '0' & x"38";  -- LDI R0 $56
tmp(163) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(164) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(165) := x"A" & "00" & '0' & x"09";  -- CGE R0 @9	# DEFININDO DEZENA MINUTO
tmp(166) := x"B" & "00" & '0' & x"A2";  -- JGE  TAG_DEZ_MIN
tmp(167) := x"5" & "00" & '0' & x"05";  -- STA  @5
tmp(168) := x"5" & "00" & '1' & x"23";  -- STA  @291
tmp(169) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(170) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(171) := x"7" & "00" & '0' & x"A2";  -- JEQ  TAG_DEZ_MIN
tmp(172) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(173) := x"4" & "00" & '0' & x"3C";  -- LDI R0 $60
tmp(174) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(175) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(176) := x"A" & "00" & '0' & x"11";  -- CGE R0 @17	# DEFININDO UNIDADE MINUTO
tmp(177) := x"B" & "00" & '0' & x"AD";  -- JGE  TAG_UNI_MIN
tmp(178) := x"5" & "00" & '0' & x"04";  -- STA  @4
tmp(179) := x"5" & "00" & '1' & x"22";  -- STA  @290
tmp(180) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(181) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(182) := x"7" & "00" & '0' & x"AD";  -- JEQ  TAG_UNI_MIN
tmp(183) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(184) := x"4" & "00" & '0' & x"3E";  -- LDI R0 $62
tmp(185) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(186) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(187) := x"A" & "00" & '0' & x"09";  -- CGE R0 @9	# DEFININDO DEZENA SEGUNDO
tmp(188) := x"B" & "00" & '0' & x"B8";  -- JGE  TAG_DEZ_SEG
tmp(189) := x"5" & "00" & '0' & x"03";  -- STA  @3
tmp(190) := x"5" & "00" & '1' & x"21";  -- STA  @289
tmp(191) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(192) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(193) := x"7" & "00" & '0' & x"B8";  -- JEQ  TAG_DEZ_SEG
tmp(194) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(195) := x"4" & "00" & '0' & x"3F";  -- LDI R0 $63
tmp(196) := x"5" & "00" & '1' & x"00";  -- STA  @256
tmp(197) := x"1" & "00" & '1' & x"40";  -- LDA R0 @320
tmp(198) := x"A" & "00" & '0' & x"11";  -- CGE R0 @17	# DEFININDO UNIDADE SEGUNDO
tmp(199) := x"B" & "00" & '0' & x"C3";  -- JGE  TAG_UNI_SEG
tmp(200) := x"5" & "00" & '0' & x"02";  -- STA  @2
tmp(201) := x"5" & "00" & '1' & x"20";  -- STA  @288
tmp(202) := x"1" & "00" & '1' & x"61";  -- LDA  @353
tmp(203) := x"8" & "00" & '0' & x"00";  -- CEQ  @0
tmp(204) := x"7" & "00" & '0' & x"C3";  -- JEQ  TAG_UNI_SEG
tmp(205) := x"5" & "00" & '1' & x"FE";  -- STA  @510
tmp(206) := x"E" & "00" & '0' & x"00";  -- RET  
tmp(207) := x"5" & "00" & '1' & x"FF";  -- STA R0 @511
tmp(208) := x"1" & "00" & '1' & x"64";  -- LDA R0 @356
tmp(209) := x"8" & "00" & '0' & x"01";  -- CEQ R0 @1
tmp(210) := x"7" & "00" & '0' & x"D4";  -- JEQ R0 CLOCK_WORKING
tmp(211) := x"6" & "00" & '0' & x"00";  -- JMP R0 INICIO
tmp(212) := x"1" & "00" & '1' & x"65";  -- LDA R0 @357
tmp(213) := x"8" & "00" & '0' & x"00";  -- CEQ R0 @0
tmp(214) := x"7" & "00" & '0' & x"D8";  -- JEQ R0 JMP_FPGA
tmp(215) := x"9" & "00" & '0' & x"DA";  -- JSR R0 INCREMENTO
tmp(216) := x"0" & "00" & '0' & x"00";  -- NOP  
tmp(217) := x"6" & "00" & '0' & x"CF";  -- JMP R0 CHECK_FPGA
tmp(218) := x"5" & "00" & '1' & x"FD";  -- STA R0 @509
tmp(219) := x"1" & "00" & '0' & x"02";  -- LDA R0 @2
tmp(220) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(221) := x"5" & "00" & '0' & x"02";  -- STA R0 @2
tmp(222) := x"8" & "00" & '0' & x"0E";  -- CEQ R0 @14
tmp(223) := x"7" & "00" & '0' & x"E1";  -- JEQ R0 ZERO_VALOR_UNIDADE
tmp(224) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(225) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(226) := x"5" & "00" & '0' & x"02";  -- STA R0 @2
tmp(227) := x"1" & "00" & '0' & x"03";  -- LDA R0 @3
tmp(228) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(229) := x"5" & "00" & '0' & x"03";  -- STA R0 @3
tmp(230) := x"8" & "00" & '0' & x"0F";  -- CEQ R0 @15
tmp(231) := x"7" & "00" & '0' & x"E9";  -- JEQ R0 ZERO_VALOR_DEZENA
tmp(232) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(233) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(234) := x"5" & "00" & '0' & x"03";  -- STA R0 @3
tmp(235) := x"1" & "00" & '0' & x"04";  -- LDA R0 @4
tmp(236) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(237) := x"5" & "00" & '0' & x"04";  -- STA R0 @4
tmp(238) := x"8" & "00" & '0' & x"0E";  -- CEQ R0 @14
tmp(239) := x"7" & "00" & '0' & x"F1";  -- JEQ R0 ZERO_VALOR_CENTENA
tmp(240) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(241) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(242) := x"5" & "00" & '0' & x"04";  -- STA R0 @4
tmp(243) := x"1" & "00" & '0' & x"05";  -- LDA R0 @5
tmp(244) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(245) := x"5" & "00" & '0' & x"05";  -- STA R0 @5
tmp(246) := x"8" & "00" & '0' & x"0F";  -- CEQ R0 @15
tmp(247) := x"7" & "00" & '0' & x"F9";  -- JEQ R0 ZERO_VALOR_UNIDADE_MILHAR
tmp(248) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(249) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(250) := x"5" & "00" & '0' & x"05";  -- STA R0 @5
tmp(251) := x"1" & "00" & '0' & x"06";  -- LDA R0 @6
tmp(252) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(253) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(254) := x"8" & "00" & '0' & x"0E";  -- CEQ R0 @14
tmp(255) := x"7" & "00" & '1' & x"01";  -- JEQ R0 ZERO_VALOR_DEZENA_MILHAR
tmp(256) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(257) := x"1" & "00" & '0' & x"00";  -- LDA R0 @0
tmp(258) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(259) := x"1" & "00" & '0' & x"07";  -- LDA R0 @7
tmp(260) := x"2" & "00" & '0' & x"01";  -- SOMA R0 @1
tmp(261) := x"5" & "00" & '0' & x"07";  -- STA R0 @7
tmp(262) := x"6" & "00" & '1' & x"23";  -- JMP R0 ATUALIZA_DISPLAY
tmp(263) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(264) := x"5" & "00" & '0' & x"02";  -- STA R0 @2
tmp(265) := x"5" & "00" & '0' & x"03";  -- STA R0 @3
tmp(266) := x"5" & "00" & '0' & x"04";  -- STA R0 @4
tmp(267) := x"5" & "00" & '0' & x"05";  -- STA R0 @5
tmp(268) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(269) := x"5" & "00" & '0' & x"07";  -- STA R0 @7
tmp(270) := x"6" & "00" & '1' & x"23";  -- JMP  ATUALIZA_DISPLAY
tmp(271) := x"4" & "00" & '0' & x"01";  -- LDI R0 $1
tmp(272) := x"5" & "00" & '1' & x"02";  -- STA R0 @258
tmp(273) := x"5" & "00" & '0' & x"15";  -- STA R0 @21
tmp(274) := x"6" & "00" & '1' & x"23";  -- JMP  ATUALIZA_DISPLAY
tmp(275) := x"4" & "00" & '0' & x"00";  -- LDI R0 @0
tmp(276) := x"5" & "00" & '0' & x"02";  -- STA R0 @2
tmp(277) := x"5" & "00" & '0' & x"03";  -- STA R0 @3
tmp(278) := x"5" & "00" & '0' & x"04";  -- STA R0 @4
tmp(279) := x"5" & "00" & '0' & x"05";  -- STA R0 @5
tmp(280) := x"4" & "00" & '0' & x"01";  -- LDI R0 @1
tmp(281) := x"5" & "00" & '0' & x"06";  -- STA R0 @6
tmp(282) := x"4" & "00" & '0' & x"00";  -- LDI R0 @0
tmp(283) := x"5" & "00" & '0' & x"07";  -- STA R0 @7
tmp(284) := x"1" & "00" & '0' & x"15";  -- LDA R0 @21
tmp(285) := x"8" & "00" & '0' & x"00";  -- CEQ R0 @0
tmp(286) := x"7" & "00" & '1' & x"0F";  -- JEQ  ACENDE_LED9
tmp(287) := x"4" & "00" & '0' & x"00";  -- LDI R0 $0
tmp(288) := x"5" & "00" & '1' & x"02";  -- STA R0 @258
tmp(289) := x"5" & "00" & '0' & x"15";  -- STA R0 @21
tmp(290) := x"0" & "00" & '0' & x"00";  -- NOP  
tmp(291) := x"1" & "00" & '0' & x"02";  -- LDA R0 @2
tmp(292) := x"5" & "00" & '1' & x"20";  -- STA R0 @288
tmp(293) := x"1" & "00" & '0' & x"03";  -- LDA R0 @3
tmp(294) := x"5" & "00" & '1' & x"21";  -- STA R0 @289
tmp(295) := x"1" & "00" & '0' & x"04";  -- LDA R0 @4
tmp(296) := x"5" & "00" & '1' & x"22";  -- STA R0 @290
tmp(297) := x"1" & "00" & '0' & x"05";  -- LDA R0 @5
tmp(298) := x"5" & "00" & '1' & x"23";  -- STA R0 @291
tmp(299) := x"1" & "00" & '0' & x"06";  -- LDA R0 @6
tmp(300) := x"5" & "00" & '1' & x"24";  -- STA R0 @292
tmp(301) := x"1" & "00" & '0' & x"07";  -- LDA R0 @7
tmp(302) := x"5" & "00" & '1' & x"25";  -- STA R0 @293
tmp(303) := x"0" & "00" & '0' & x"00";  -- NOP  
tmp(304) := x"1" & "00" & '0' & x"02";  -- LDA R0 @2
tmp(305) := x"8" & "00" & '0' & x"08";  -- CEQ R0 @8
tmp(306) := x"7" & "00" & '1' & x"34";  -- JEQ R0 CHECK_DEZENA
tmp(307) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(308) := x"1" & "00" & '0' & x"03";  -- LDA R0 @3
tmp(309) := x"8" & "00" & '0' & x"08";  -- CEQ R0 @8
tmp(310) := x"7" & "00" & '1' & x"38";  -- JEQ R0 CHECK_CENTENA
tmp(311) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(312) := x"1" & "00" & '0' & x"04";  -- LDA R0 @4
tmp(313) := x"8" & "00" & '0' & x"08";  -- CEQ R0 @8
tmp(314) := x"7" & "00" & '1' & x"3C";  -- JEQ R0 CHECK_UN_MILHAR
tmp(315) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(316) := x"1" & "00" & '0' & x"05";  -- LDA R0 @5
tmp(317) := x"8" & "00" & '0' & x"08";  -- CEQ R0 @8
tmp(318) := x"7" & "00" & '1' & x"40";  -- JEQ R0 ESCOLHER_RELOGIO
tmp(319) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(320) := x"1" & "00" & '1' & x"42";  -- LDA R0 @322
tmp(321) := x"8" & "00" & '0' & x"01";  -- CEQ R0 @1
tmp(322) := x"7" & "00" & '1' & x"44";  -- JEQ  MODO_12H
tmp(323) := x"6" & "00" & '1' & x"4C";  -- JMP  MODO_24H
tmp(324) := x"1" & "00" & '0' & x"06";  -- LDA R0 @6
tmp(325) := x"8" & "00" & '0' & x"13";  -- CEQ R0 @19
tmp(326) := x"7" & "00" & '1' & x"48";  -- JEQ R0 CHECK_CENT_MILHAR_12H
tmp(327) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(328) := x"1" & "00" & '0' & x"07";  -- LDA R0 @7
tmp(329) := x"8" & "00" & '0' & x"14";  -- CEQ R0 @20
tmp(330) := x"7" & "00" & '1' & x"13";  -- JEQ R0 ZERANDO_DISPLAY_12H
tmp(331) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(332) := x"1" & "00" & '0' & x"06";  -- LDA R0 @6
tmp(333) := x"8" & "00" & '0' & x"0C";  -- CEQ R0 @12
tmp(334) := x"7" & "00" & '1' & x"50";  -- JEQ R0 CHECK_CENT_MILHAR_24H
tmp(335) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(336) := x"1" & "00" & '0' & x"07";  -- LDA R0 @7
tmp(337) := x"8" & "00" & '0' & x"0D";  -- CEQ R0 @13
tmp(338) := x"7" & "00" & '1' & x"07";  -- JEQ R0 ZERANDO_DISPLAY
tmp(339) := x"6" & "00" & '1' & x"54";  -- JMP R0 RETORNO
tmp(340) := x"E" & "00" & '0' & x"00";  -- RET  









        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;