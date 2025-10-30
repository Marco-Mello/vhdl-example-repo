library ieee;
use ieee.std_logic_1164.all;

entity logicaDesvio is
  port (
    JLE    : in  std_logic;
    JGE    : in  std_logic;
    JMP    : in  std_logic;
    JEQ    : in  std_logic;
	 JSR    : in std_logic;
	 RET    : in std_logic;
    flag_logica : in  std_logic;
	 flag_logica_jge : std_logic;
	 flag_logica_jle : std_logic;
	 saida_logica : out std_logic_vector(1 downto 0)
  );
end entity;

architecture comportamento of logicaDesvio is
begin
  process(JLE,JGE,JMP, JEQ, JSR, RET, flag_logica,flag_logica_jge,flag_logica_jle)
  begin
    if RET = '1' then
      saida_logica <= "10";
    elsif JSR = '1' then
      saida_logica <= "01";
    elsif (JMP = '1') or (JEQ = '1' and flag_logica = '1') or (JGE = '1' and flag_logica_jge = '1') or (JLE = '1' and flag_logica_jle = '1') then
      saida_logica <= "01";
    else
      saida_logica <= "00";
    end if;
  end process;
end architecture;