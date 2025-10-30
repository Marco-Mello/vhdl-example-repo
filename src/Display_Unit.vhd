library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display_Unit is
   generic (
         dataWidth: natural := 7;
         addrWidth: natural := 4
    );
    port 
    (
		  data_in  : in std_logic_vector(addrWidth-1 downto 0);
		  clk      : in std_logic;
        habilita : in std_logic;
        data_out : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture comportamento of Display_Unit is


  signal REG_DATAOUT: std_logic_vector(3 downto 0);

begin


REG_DISPLAY : entity work.registradorGenerico   generic map (larguraDados => addrWidth)
          port map (DIN => data_in,
						  DOUT => REG_DATAOUT,
						  ENABLE => habilita, 
						  CLK => CLK,
						  RST => '0');

Display_Unit :  entity work.decoderHex
        port map(dadoHex => REG_DATAOUT,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => data_out);
					  
end architecture;