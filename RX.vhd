	library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
	entity RX is
		port(clk : in std_logic;
			 rst : in std_logic;
			 baud_rate : in integer;
			 Serial_Input : in std_logic;
			 D_Out : out std_logic_vector(7 downto 0) 
			);
		end entity;

architecture behave of RX is 
	component RXCNTRL is 
	port( clk : in std_logic;
		  rst :in std_logic;
		  SerialIn : in std_logic;
		  baud_enable : in std_logic;
		  DataOut : out std_logic_vector(7 downto 0) := "00000000"
		);
	end component;
	component baud_gen is 
	port( sysclk :in std_logic;
		  rst : in std_logic;
		  baud_rate: in std_logic; 
			--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
		  baudEnable:out std_logic
		);
	end component;
	signal Baud_enable_BaudGen_Cntrl : std_logic;

	begin
		RX_Contrll : entity work.RXCNTRL port map (clk => clk,
												  rst => rst,
												  SerialIn => Serial_Input,
												  baud_enable => Baud_enable_BaudGen_Cntrl,
												  DataOut => D_Out
												);

	    RX_Baud : entity work.baud_gen port map(  sysclk => clk,
												  rst => rst,
												  baud_rate => baud_rate,
													--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
												  baudEnable => baud_enable_BaudGen_Cntrl 
												);

end behave;
	