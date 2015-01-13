--
--    This file is part of top_test_fsm_implem
--    Copyright (C) 2011  Julien Thevenon ( julien_thevenon at yahoo.fr )
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_test_fsm_implem is
    Port ( clk : in  STD_LOGIC;
           w1a : inout  STD_LOGIC_VECTOR (15 downto 0));
end top_test_fsm_implem;

architecture Behavioral of top_test_fsm_implem is
	 signal reset : std_logic;
	 signal output : std_logic;
begin			
--		inst_fsm_implem : entity work.fsm_implem(Test)
--		inst_fsm_implem : entity work.fsm_implem(Simple)
--		inst_fsm_implem : entity work.fsm_implem(Naive)
		inst_fsm_implem : entity work.fsm_implem(Trial)
			port map (
				clk => clk,
				rst => reset,
				output => output
				);
		w1a(0) <= output;
		reset <= '0';
		generate_w1a : for I in 1 to 15 generate
			w1a(I) <= '0';
		end generate generate_w1a;
end Behavioral;

