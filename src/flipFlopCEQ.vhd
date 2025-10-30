library ieee;
use ieee.std_logic_1164.all;

entity flipFlopCEQ is
  port (
    CLK    : in  std_logic;
    DIN    : in  std_logic;
    ENABLE : in  std_logic;
    RST    : in  std_logic;
    DOUT   : out std_logic
  );
end entity;

architecture comportamento of flipFlopCEQ is
  signal q_reg : std_logic := '0';
begin
  process(CLK, RST)
  begin
    if RST = '1' then
      q_reg <= '0';
    elsif rising_edge(CLK) then
      if ENABLE = '1' then
        q_reg <= DIN;
      end if;
    end if;
  end process;

  DOUT <= q_reg;
end architecture;
