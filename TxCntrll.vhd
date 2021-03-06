	library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
entity TXNCNTRL is 
	port( sysclk : in std_logic;
		  rst : in std_logic;
		  din : in unsigned(7 downto 0);
		  baud_rate: in integer;
		  baud_enable : in std_logic;
		  RTS : in std_logic; -- Request to Send 
 		  d_out		: out std_logic
		);
end entity;

architecture behave of TXNCNTRL is 
	TYPE state is( IDLE, SEND_START_BIT, SEND_DATA, SEND_STOP_BIT);
	signal TX_State	 : state;
	signal data_in	 : unsigned(7 downto 0);
	signal load		 :  std_logic;
	signal countbits : integer range 0 to 8;
	signal piso_out		: std_logic := '1';
	signal NXT_STATE : state;
	signal bit_out : std_logic := '1';
	begin 
--
--	SEQ: process(baud_enable)
--			begin
--			if(rising_edge(baud_enable))then
--				if(rst= '1')then
--					TX_State  <= IDLE;
--					--NXT_STATE <= IDLE;
--					data_in <= (others => '0');
--			--	d_out <= '1';
--				data_in <= (others => '0');
--				piso_out <= '1';
--				load <= '0';
-- 				else
--					if(baud_enable = '1')then
--						TX_STATE <= NXT_STATE;
--					end if;
--				end if;
--			end if;
--		end process SEQ;
--
		
	d_out <= bit_out or piso_out ;		
							-- The D_out combines the output of protocol overhead and Databits i.e PISO
   COMB:process(baud_enable,rst)
		begin
Reset:			
			if(rst = '1')then
				TX_State <= IDLE;
				data_in <= (others => '0');
				bit_out <= '1';
				data_in <= (others => '0');
				piso_out <= '0';
				load <= '0';

			elsif(rising_edge(baud_enable))then								
	baud_en: 	 case(TX_State) is
				 	when IDLE => bit_out <= '1';
								if(RTS = '1')then 					
									load <= '1';
									countbits <= 0;
									TX_State <= SEND_START_BIT;
								else 							
									TX_State <= IDLE;				

								end if;

					when SEND_START_BIT =>  
											bit_out <= '0';
											load <= '0';
										   TX_State <= SEND_DATA;
											
					when SEND_DATA	=> 
 										   if(countbits = 7)then
												TX_STATE <= SEND_STOP_BIT;	
										   else
												countbits <= countbits + 1;
										   end if;
									   
 
					when SEND_STOP_BIT => bit_out <= '1';
										  TX_State <= IDLE;
											
					when others => TX_State <= IDLE;
				   end case;
				 
					--end if ;
						case(load) is
					when '1' => 
						data_in <= din;
					when others =>
	 					data_in <= shift_right((data_in),1); --the function only accepts Unsigned else it use convert to unsigned  
					end case;
					if( countbits > 2) then
						piso_out <= data_in(0);
					else 
						piso_out <= '1';
					end if;
				end if ;
			end process; 
--	TX_PISO : process(sysclk)
--		 begin
		--if(rising_edge(sysclk))then
		   --if(rst = '1')then
--			data_in <= (others => '0');
--			d_out <= '1';
--		   else
--			case(load) is
--				when '1' => 
--					data_in <= din;
--				when others =>
-- 					data_in <= shift_right((data_in),1); --the function only accepts Unsigned else it use convert to unsigned  
--				end case;
--					piso_out <= data_in(0);
		 --  end if;
		 --end if;
--end process; 
--
	end behave;