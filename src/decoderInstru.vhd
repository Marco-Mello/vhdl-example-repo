library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
         saida : out std_logic_vector(15 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

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
  --constant AND  : std_logic_vector(3 downto 0) := "1011";
  
  -- JGE = 12 , FLAG_GREATER = 13

  -- JGE = 14 , FLAG_GREATER = 15

  begin
saida <= "0000000000000000" when opcode = NOP else
         "0000000000110010" when opcode = LDA else
         "0000000000101010" when opcode = SOMA else
         "0000000000100010" when opcode = SUB else
         "0000000001110000" when opcode = LDI else
			"0000000000000001" when opcode = STA else
			"0000010000000000" when opcode = JMP else
			"0000000010000000" when opcode = JEQ else
			"0000000000011110" when opcode = CEQ else
			"0001000000000000" when opcode = JGE else
			"0010000000011010" when opcode = CGE else
			"0100000000000000" when opcode = JLE else
			"1000000000011010" when opcode = CLE else
			"0000100100000000" when opcode = JSR else
			"0000001000000000" when opcode = RET else
			--"000000111000" when opcode = AND else
         "0000000000000000";  -- NOP para os opcodes Indefinidos
end architecture;

