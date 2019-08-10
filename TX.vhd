	library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
entity TX_Top is 
	port( clk : in std_logic;
          rst: in std_logic;
		  data_in : in unsigned(7 downto 0);
		  baud_rate: in std_logic;
		  RTS :in std_logic;
		  serial_out:out std_logic
		  );
	end TX_Top;

architecture TOP of TX_Top is 
	component baud_gen is 
		port( sysclk :in std_logic;
			  rst : in std_logic;
			  baud_rate: in std_logic;
		--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
			  enable_96:out std_logic;
			  enable_1152:out std_logic	
			);
	end component;

	component TXNCNTRL is 
	port( sysclk : in std_logic;
		  rst : in std_logic;
		  din : in unsigned(7 downto 0);
		  baud_rate: in std_logic;
		  baud_enable : in std_logic;
		  RTS : in std_logic; -- Request to Send 
 		  d_out	: out std_logic
		);
	end component;
		signal baudEnable_BaudGen_Cntrl : std_logic;
		signal baud96_BaudGen_Cntrl: std_logic;
		signal baud1152_BaudGen_Cntrl: std_logic;

	begin
		baudEnable_BaudGen_Cntrl <= baud96_BaudGen_Cntrl or baud1152_BaudGen_Cntrl;
		TXNCNTRL_BLK : entity work.TXNCNTRL port map( 	  sysclk => clk,
														  rst => rst,
														  din => data_in,
														  baud_rate => baud_rate,
														  baud_enable => baudEnable_BaudGen_Cntrl,
														  RTS	 => RTS, -- Request to Send 
												 		  d_out	=> serial_out
														);

		Baud_Gen_Blk	: entity work.baud_gen port map( 	  sysclk => clk,
														  rst => rst,
														  baud_rate => baud_rate,
													--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
														  enable_96 => baud96_BaudGen_Cntrl,
														  enable_1152=> baud1152_BaudGen_Cntrl
														);
	end TOP;