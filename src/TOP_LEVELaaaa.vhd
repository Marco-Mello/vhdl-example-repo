library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_LEVEL is
    port (
        CLOCK : in  std_logic;
        LEDR  : out std_logic_vector(0 downto 0)
    );
end entity;

architecture RTL of TOP_LEVEL is
    signal counter : unsigned(25 downto 0) := (others => '0'); -- Enough for 25 million
    signal led_reg : std_logic := '0';
begin

    process (CLOCK)
    begin
        if rising_edge(CLOCK) then
            if counter = 24_999_999 then  -- 0 to 24,999,999 = 25,000,000 cycles
                counter <= (others => '0');
                led_reg <= not led_reg;   -- Toggle LED
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    LEDR(0) <= led_reg;

end architecture;
