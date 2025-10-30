library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
generic ( larguraDados : natural := 8;
		  enderecoRom: natural := 9;
		  DataRom: natural := 13;
		  EnderecoRam: natural := 8;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLK : in std_logic;
	 Instruction_IN: in std_logic_vector(14 downto 0);	
	 Data_IN : in std_logic_vector(larguraDados-1 downto 0);
	 ROM_Address : out std_logic_vector(8 downto 0);
    Data_OUT: out std_logic_vector(larguraDados-1 downto 0);
	 Data_Address : out std_logic_vector(8 downto 0);  
	 HabilitaleituraRAM: out std_logic;
    HabilitaescritaRAM: out std_logic
  );
end entity;


architecture arquitetura of CPU is

  signal chavesY_MUX_A : std_logic_vector (larguraDados-1 downto 0);
  signal MUX_REG1 : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_MPPC : std_logic_vector (larguraDados downto 0);
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal Sinais_Controle : std_logic_vector(15 downto 0);
  signal opcode : std_logic_vector(12 downto 0);
  signal Endereco : std_logic_vector (enderecoRom-1 downto 0);
  signal Endereco_RET : std_logic_vector (enderecoRom-1 downto 0);
  signal proxPC : std_logic_vector (enderecoRom-1 downto 0);
  signal Chave_Operacao_ULA : std_logic;
  signal SelMUX : std_logic;
  signal SelMUXPC : std_logic;
  signal SAIDA_ULAF : std_logic;
  signal FLAG_JGE : std_logic;
  signal FLAG_JLE : std_logic;
  signal SAIDA_FLAG : std_logic;
  signal SAIDA_FLAG_GREATER : std_logic;
  signal SAIDA_FLAG_LESS : std_logic;
  SIGNAL FLAG_GREATER: std_logic;
  SIGNAL FLAG_LESS : std_logic;
  signal SAIDA_LOGICAD : std_logic_vector(1 downto 0);
  signal FLAG : std_logic;
  signal Habilita_A : std_logic;
  signal Reset_A : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal RamM : std_logic_vector (7 downto 0);

begin

-- O port map completo do MUX.
MUX_EntradaB_ULA :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Data_IN,
                 entradaB_MUX =>  Instruction_IN(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => MUX_REG1);
					  
-- O port map completo do MUX.
MUX_PC :  entity work.muxGenerico4x1  generic map (larguraDados => 9)
        port map( entrada0_MUX => proxPC,
                 entrada1_MUX =>  Instruction_IN(8 downto 0),
                 entrada2_MUX => Endereco_RET,
					  entrada3_MUX =>  "000000000",
                 seletor_MUX => SAIDA_LOGICAD,
                 saida_MUX => Saida_MPPC);
					  
BancoRegs : entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => larguraDados, larguraEndBancoRegs => 2)
          port map ( clk => CLK,
              endereco => instruction_in(10 downto 9), --ENDERECO REGISTRADOR
              dadoEscrita => Saida_ULA,
              habilitaEscrita => Habilita_A,
              saida  => REG1_ULA_A);

-- O port map completo do Acumulador.
--REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
--          port map (DIN => Saida_ULA,
--						  DOUT => REG1_ULA_A,
--						  ENABLE => Habilita_A,
--						  CLK => CLK, 
--						  RST => '0');

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => enderecoRom)
          port map (DIN => Saida_MPPC,
						  DOUT => Endereco,
						  ENABLE => '1',
						  CLK =>CLK,
						  RST => '0');
						  
REG_RETORNO : entity work.registradorGenerico   generic map (larguraDados => enderecoRom)
          port map (DIN => proxPC,
						  DOUT => Endereco_RET,
						  ENABLE => Sinais_controle(11), 
						  CLK => CLK,
						  RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => enderecoRom, constante => 1)
        port map( entrada => Endereco ,saida => proxPC);

-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, 
			 entradaB => MUX_REG1, 
			 saida => Saida_ULA, 
			 seletor => Operacao_ULA, 
			 saidaFlag => SAIDA_ULAF,
			 saidaFlagGreater=>FLAG_JGE,
			 saidaFlagLess=>FLAG_JLE);

DECODER : entity work.decoderInstru
          port map (opcode => Instruction_IN(14 downto 11),
			saida => Sinais_Controle);

			 
FLAGZERO : entity work.flipFlopCEQ
    port map (
      clk     => CLK,
      rst     => '0',
      enable => FLAG,
      din => SAIDA_ULAF,
		dout => SAIDA_FLAG);
		
FLAGJGE : entity work.flipFlopCEQ
    port map (
      clk     => CLK,
      rst     => '0',
      enable => FLAG_GREATER,
      din => FLAG_JGE,
		dout => SAIDA_FLAG_GREATER);
		
FLAGJLE : entity work.flipFlopCEQ
    port map (
      clk     => CLK,
      rst     => '0',
      enable => FLAG_LESS,
      din => FLAG_JLE,
		dout => SAIDA_FLAG_LESS);
		
DESVIO : entity work.logicaDESVIO
    port map (
	 JLE => Sinais_controle(14),
	 JGE => Sinais_controle(12),
    JMP => Sinais_controle(10),
    JEQ => Sinais_controle(7),
	 JSR => Sinais_controle(8),
	 RET => Sinais_controle(9),
    flag_logica => SAIDA_FLAG,
	 flag_logica_jge => SAIDA_FLAG_GREATER,
	 flag_logica_jle => SAIDA_FLAG_LESS,
	 saida_logica => SAIDA_LOGICAD);
			 

HabilitaescritaRAM <= Sinais_Controle(0);
HabilitaleituraRAM <= Sinais_Controle(1);
FLAG <= Sinais_Controle(2);
Operacao_ULA <= Sinais_Controle(4 downto 3);
Habilita_A <= Sinais_Controle(5);
selMUX <= Sinais_Controle(6);
SelMUXPC <= Sinais_Controle(6);
FLAG_GREATER <= Sinais_Controle(13);
FLAG_LESS <= Sinais_Controle(15);
Data_ADDRESS <= Instruction_IN(8 downto 0);
ROM_Address <= Endereco;
Data_OUT <= REG1_ULA_A;





end architecture;