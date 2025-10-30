library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 8 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		saidaFlag: out STD_LOGIC;
		saidaFlagGreater: out STD_LOGIC;
		saidaFlagLess: out STD_LOGIC
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal passa:      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal compara:    STD_LOGIC_VECTOR((larguraDados-1) downto 0);
	signal AND1:   STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
      passa     <= entradaB;
		compara   <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		--  <= entradaA and entradaB;
      saida <= soma       when (seletor = "01") else
             subtracao  when (seletor = "00") else
				 --AND1  when (seletor = "10") else
				 compara when (seletor = "11") else
             passa;
				 
				 saidaFlag <= not ( Saida(7) or Saida(6) or Saida(5) or Saida(4) or Saida(3) or Saida(2) or Saida(1) or Saida(0) );
				 saidaFlagGreater <= '1' when entradaB <= entradaA else '0';
				 saidaFlagLess <= '1' when entradaB >= entradaA else '0';
				 
end architecture;