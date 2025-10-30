library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keyTratamento is
    port 
    (
		  data_in  : in std_logic;
		  clk      : in std_logic;
        rst : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture comportamento of keyTratamento is


  signal edgeOUT: std_logic;

begin


flipflop : entity work.flipFlopCEQ
          port map ( CLK => edgeOUT,
					DIN => '1',
					ENABLE => '1',
					RST    => rst,
					DOUT   => data_out
			 );

edgedetector :  entity work.edgeDetector
        port map(clk  => CLK,
              entrada => data_in,
              saida   => edgeOUT);
					  
end architecture;