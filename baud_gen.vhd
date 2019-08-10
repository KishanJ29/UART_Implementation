	library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
entity baud_gen is 
	port( sysclk :in std_logic;
		  rst : in std_logic;
		  baud_rate: in std_logic; 
			--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
		  enable_96:out std_logic;
		  enable_1152:out std_logic	
		);
end baud_gen;

architecture rtl of baud_gen is 

 
		signal count_96 :  integer range 0 to 2000 := 0; 
		signal count_1152 :  integer range 0 to 2000 := 0; 
	begin
	
		 process(sysclk)
				begin
				  if(rising_edge(sysclk))then
					 if(rst ='1')then
						count_96 <= 0;
						enable_96 <= '0';
						count_1152 <= 0;							
						enable_1152<= '0';
         		  else
						if(baud_rate = '1')then 
		Count_9600_Baud: 		enable_96 <= '0';
								count_96 <= count_96 + 1;
							   if(count_96 = 1250)then
								enable_96 <= '1';
								count_96 <= 0;
							 
						 	  end if ;--Count_9600_Baud;
	 				     else 				
		Count_1152_Baud : 		enable_1152 <= '0';
								count_1152 <= count_1152 + 1;
							   if(count_1152 = 104)then
								enable_1152 <= '1';
								count_1152 <= 0;
							   end if;
					   end if;  --Count_1152_Baud;
					end if;
				end if;
			end process;	
end rtl;