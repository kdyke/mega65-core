library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--
entity THEROM is
  port (Clk : in std_logic;
        address : in std_logic_vector(13 downto 0);
        -- Yes, we do have a write enable, because we allow modification of ROMs
        -- in the running machine, unless purposely disabled.  This gives us
        -- something like the WOM that the Amiga had.
        we : in std_logic;
        -- chip select, active low       
        data_i : in std_logic_vector(7 downto 0);
        data_o : out std_logic_vector(7 downto 0)
        );
end THEROM;

architecture Behavioral of THEROM is

-- 16K x 8bit pre-initialised RAM
  type ram_t is array (0 to 16383) of std_logic_vector(7 downto 0);
  signal ram : ram_t := (ROMDATA);

begin

--process for read and write operation.
  PROCESS(Clk,ram,address,we,data_i)
  BEGIN
    if(rising_edge(Clk)) then 
        if(we='1') then
        ram(to_integer(unsigned(address))) <= data_i;
      end if;
      data_o <= ram(to_integer(unsigned(address)));
    end if;
--    if cs='1' then
--      data_o <= ram(to_integer(unsigned(address)));
--    else
--      data_o <= "ZZZZZZZZ";
--    end if;
  END PROCESS;

end Behavioral;
