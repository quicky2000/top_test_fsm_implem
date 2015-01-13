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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_implem is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           output : out  STD_LOGIC);
end fsm_implem;

-- Fmax : 217.58Mhz
-- Number of Slice Flip Flops : 6
-- Number of 4 input LUTs : 9
-- Number of occupied Slices : 5
-- Number of BUFGMUXs : 1
-- Average Fanout of Non-Clock Nets : 3.6
architecture Simple of fsm_implem is
	constant low_duration : positive := 7;
	constant max_value : positive := 18;
	type output_type is (low,high);
	signal next_value : output_type := low;
	signal value : output_type := low;
	signal counter : std_logic_vector ( 4 downto 0 ) := (others => '0');
begin
	-- process managing state register
	process (clk,rst)
	begin
		if rising_edge(clk) then
			if rst = '1' or unsigned(counter) = max_value then
				counter <= (others => '0');
			else
				counter <= std_logic_vector(unsigned(counter) + 1);
			end if;
		end if;
	end process;
	
	-- process managing state register
	process (clk,rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				value <= low;
			else
				value <= next_value;
			end if;
		end if;
	end process;
	
	-- process computing next state
	process (value,counter)
	begin
		case value is
			when low => if unsigned(counter) = low_duration then
					next_value <= high;
					else
					next_value <= low;
				end if;
			when high => if unsigned(counter) = max_value then
					next_value <= low;
				else
					next_value <= high;
				end if;
			when others => next_value <= low;
		end case;
	end process;

	-- output function 
	output <= '1' when value = high else '0';
	
end Simple;

-- Fmax : 223.065 Mhz
-- Total Number Slice Registers : 7
-- Number used as Flip Flops : 6
-- Number used as Latches : 1
-- Number of 4 input LUTs : 9
-- Number of occupied Slices : 7
-- Number of BUFGMUXs : 1
-- Average Fanout of Non-Clock Nets : 3.9
architecture Trial of fsm_implem is
	constant low_duration : positive := 7;
	constant max_value : positive := 18;
	type output_type is (low,high);
	signal next_value : output_type := low;
	signal prepared_value : output_type := low;
	signal value : output_type := low;
	signal counter : std_logic_vector ( 4 downto 0 ) := (others => '0');
begin
	-- process managing state register
	process (clk,rst)
	begin
		if rising_edge(clk) then
			if rst = '1' or unsigned(counter) = max_value then
				counter <= (others => '0');
			else
				counter <= std_logic_vector(unsigned(counter) + 1);
			end if;
		end if;
	end process;
	
	-- process managing state register
	process (clk,rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				value <= low;
			else
				value <= next_value;
			end if;
		end if;
	end process;
	
	-- process computing prepared_value
	process (value)
	begin
		case value is
			when low => prepared_value <= high;
			when high => prepared_value <= low;
			when others => prepared_value <= low;
		end case;
	end process;

	-- process computing next_value_value
	process (counter,prepared_value,next_value)
	begin
		if unsigned(counter) = low_duration or unsigned(counter) = max_value then
			next_value <= prepared_value;
		else
			next_value <= next_value;
		end if;
	end process;

	-- output function 
	output <= '1' when value = high else '0';
	
end Trial;

-- Fmax : 229.727 Mhz
-- Number of Slice Flip Flops : 6
-- Number of 4 input LUTs : 8
-- Number of occupied Slices : 6
-- Total Number of 4 input LUTs : 8
-- Number of BUFGMUXs : 1
-- Average Fanout of Non-Clock Nets : 3.20
architecture Naive of fsm_implem is
	constant low_duration : positive := 7;
	constant max_value : positive := 18;
	signal counter : std_logic_vector ( 4 downto 0 ) := (others => '0');
begin
	-- process managing state register
	process (clk,rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				counter <= (others => '0');
				output <=  '0';
			else
				if unsigned(counter) = max_value - 1 then
					counter <= (others => '0');
				else
					counter <= std_logic_vector(unsigned(counter) + 1);
				end if;
				
				if unsigned(counter) < low_duration then
					output <= '0';
				else
					output <= '1';
				end if;

			end if;
		end if;
	end process;
	
end Naive;

-- Fmax : 315.159 MHz
-- Number of Slice Flip Flops : 7
-- Number of 4 input LUTs : 6
-- Number of occupied Slices : 6
-- Total Number of 4 input LUTs : 6
-- Number of BUFGMUXs : 1
-- Average Fanout of Non-Clock Nets : 3.00
architecture Test of fsm_implem is
	constant low_duration : positive := 7;
	constant max_value : positive := 18;
	constant counter_low : positive := 16-low_duration+1;
	constant counter_high : positive := 16 - (max_value - low_duration )+ 1;
	signal valueN : std_logic := '0';
	signal valueP : std_logic := '0';
	signal counterP : std_logic_vector ( 4 downto 0 ) := std_logic_vector(to_unsigned(counter_low,5));
	signal counterN : std_logic_vector ( 4 downto 0 ) := (others => '0');
begin
	-- main_process
	main_process : process(clk,rst)
	begin
		if rst = '1' then
			counterP <= std_logic_vector(to_unsigned(counter_low,5));
			valueP <= '0';
		elsif rising_edge(clk) then
			output <= valueP;
			if counterP(4) = '1' then
				valueP <= valueN;
				counterP <= counterN;			
			else
				counterP <= std_logic_vector(unsigned(counterP)+1);			
			end if;

		end if;
	end process;

	-- process computing next_value
	prepare_next_value : process (valueP)
	begin
		case valueP is
			when '0' => valueN <= '1';
			when '1' => valueN <= '0';
			when others => valueN <= '0';
		end case;
	end process;

	-- process computing next counter
	prepare_next_counter : process (valueP)
	begin
		case valueP is
			when '0' => counterN <= std_logic_vector(to_unsigned(counter_high,5));
			when '1' => counterN <= std_logic_vector(to_unsigned(counter_low,5));
			when others => counterN <= std_logic_vector(to_unsigned(counter_high,5));
		end case;
	end process;	

end Test;
