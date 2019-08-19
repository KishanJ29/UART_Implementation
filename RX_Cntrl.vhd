		library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
-- vlib work; vmap work work; vcom rxcntrl; 
-- vsim work._the_toplevel_entity;
--
entity RXN_CNTRL is 
	port( rst :in std_logic;
		  SerialIn : in std_logic;
		  baud_rate: in std_logic;
		  DataOut : out std_logic_vector(7 downto 0)
		);
end entity;

architecture behave of RXN_CNTRL is 
	TYPE state is( IDLE, SEND_START_BIT, SEND_DATA, SEND_STOP_BIT);
	signal TX_State	 : state;
	   signal s : std_logic_vector(3 downto 0) := "0000" ;
    begin
SIPO: process(clk,rst)
	 begin
	  if (rising_edge (clk)) then
        if (reset='1') then
            s <= "0000";
        else       
            s <= (din & s(3 downto 1));    
        end if;       
        dout <= s;
	 end if;
    end process sipo;
			
end architecture;
