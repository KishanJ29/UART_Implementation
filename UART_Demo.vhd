
		library ieee;
		use ieee.std_logic_1164.all;
		use ieee.Numeric_std.all;
entity UART_Demo is 
	port( clk_TOP : in std_logic;
          rst_TOP: in std_logic;
		  data_in_TOP : in unsigned(7 downto 0);
		  baud_rate_TOP: in integer;
		  RTS_TOP : in std_logic;
		  D_Out : out std_logic_vector(7 downto 0)
		  );
	end UART_Demo;

architecture TOP of UART_Demo is 
	component baud_gen is 
		port( sysclk :in std_logic;
			  rst : in std_logic;
			  baud_rate_TOP: in integer;
		--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
			   baudEnable:out std_logic	
			);
	end component;

	component TXNCNTRL is 
	port( sysclk : in std_logic;
		  rst : in std_logic;
		  din : in unsigned(7 downto 0);
		  baud_rate: in integer;
		  baud_enable : in std_logic;
		  RTS : in std_logic; -- Request to Send 
 		  d_out	: out std_logic
		);
	end component;
		component RX is
		port(clk : in std_logic;
			 rst : in std_logic;
			 baud_rate : in integer;
			 Serial_Input : in std_logic;
			 D_Out : out std_logic_vector(7 downto 0) 
			);
		end component;
		signal baudEnable_BaudGen_Cntrl : std_logic;
--		signal baud96_BaudGen_Cntrl: std_logic;
--		signal baud1152_BaudGen_Cntrl: std_logic;
		signal Serial :  std_logic;
	begin
	 		

		
	   TX_BLK : entity work.TXNCNTRL port map(sysclk => clk_TOP,
											  rst => rst_TOP,
											  din => data_in_TOP,
											  baud_rate => baud_rate_TOP,
											  baud_enable => baudEnable_BaudGen_Cntrl,
											  RTS	 => RTS_TOP, -- Request to Send 
									 		  d_out	=> serial
											);
		

		Baud_Gen_Blk	: entity work.baud_gen port map(  sysclk => clk_TOP,
														  rst => rst_TOP,
														  baud_rate => baud_rate_TOP,
													--Baud Rate chossen from the system; 1 -> 9600; 0-> 115200  
														  baudEnable	 => baudEnable_BaudGen_Cntrl														 
														);
		RX_BLK : entity work.RX port map (   clk => clk_TOP,
											 rst => rst_TOP,
											 baud_rate => baud_rate_TOP,
											 Serial_Input => Serial,
											 D_Out => D_Out 
											);
	end TOP;
