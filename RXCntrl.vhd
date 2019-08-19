	library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;

entity RXCNTRL is 
	port( clk : in std_logic;
		  rst :in std_logic;
		  SerialIn : in std_logic;
		  baud_enable : in std_logic;
		  DataOut : out std_logic_vector(7 downto 0) := "00000000"
		);
end entity;

architecture behave of RXCNTRL is 
	TYPE state is( IDLE, RCVD_START_BIT, RCVD_DATA, RCVD_STOP_BIT);
	signal RX_State	 : state;
	signal s  :std_logic_vector(7 downto 0)  := "00000000";
	signal countbits : integer range 0 to 15;
	--   variable s : std_logic_vector(3 downto 0) := "0000" ;
    begin
	 process(baud_enable)
		begin
		if (rising_edge (baud_enable)) then 
			if(rst = '1')then
				RX_State <= IDLE;
				s <= "00000000";
				DataOut <= "00000000";
				countbits <= 0;
			else 								
	baud_en: 	 case(RX_State) is
				 	when IDLE => 
								if(SerialIn = '1')then 								
									RX_State <= IDLE;
									s <= (others => '0');
								else
									--countbits <= 0; 							
									RX_State <= RCVD_DATA;				

								end if;

--					when RCVD_START_BIT => countbits <= 0; 
--											
--										   RX_State <= RCVD_DATA;
											
					when RCVD_DATA	=>	  		if(countbits = 8)then
													countbits <= 0;
													RX_STATE <= RCVD_STOP_BIT;	
										   		else
													countbits <= countbits +1;
													s <= (SerialIn & s(7 downto 1));
										   		end if;
														
 
					when RCVD_STOP_BIT => DataOut <= s;
										  RX_State <= IDLE;
											
					when others => RX_State <= IDLE;
				   end case;
				 
					end if ;
									
				end if ;
			end process; 
        
			
end behave;

--	if (rst='1') then
--            s <= "00000000";
--        else
--            s <= (SerialIn & s(7 downto 1));    
--        end if;       
--        DataOut <= s;
--		end if;