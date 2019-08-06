 library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;

entity piso is 
	port( piso_clk : in std_logic;
		  rst : in std_logic;
		  din : in unsigned(7 downto 0);		  
		  load: in std_logic;		  
 		  d_out		: out std_logic
		);
end piso;

architecture rtl of piso is 
	signal data_in : unsigned(7 downto 0);
	begin
		  
		process(rst, piso_clk)
		 begin
		  if(rst = '1')then
			data_in <= (others => '0');
			d_out <= '1';
		 elsif(rising_edge(piso_clk))then
--			if(load = '1')then
--				data_in <= din;
--			else
--				data_in <= shift_right((data_in),1); --the function only accepts Unsined else it use concert to unsigned  
--			end if;
			case(load) is
				when '1' => 
					data_in <= din;
				when others =>
 					data_in <= shift_right((data_in),1); --the function only accepts Unsined else it use concert to unsigned  
				end case;
					d_out <= data_in(0);
		  end if;
		end process; 
	
				
end rtl;
