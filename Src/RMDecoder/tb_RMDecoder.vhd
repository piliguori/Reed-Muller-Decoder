--! @Author: Salvatore Barone <salvator.barone@gmail.com, salvator.barone@studenti.unina.it>
--! @Date:   03-05-2017
--! @Filename: tb_RMDecoder.vhd

--! @addtogroup RMDecoder
--! @{

-- Revision History
-- 03-05-2017 : File creation and first implementation
--

library ieee;
use ieee.std_logic_1164.ALL;


entity tb_RMDecoder is
--  Port ( );
end tb_RMDecoder;

architecture Behavioral of tb_RMDecoder is

	component RMDecoder is
		Generic (	m 					: 		natural := 6;
					generator_matrix_01 : 		boolean := true);
	    Port (		clock 				: in	std_logic;
					reset_n 			: in	std_logic;
					data_in 			: in 	std_logic_vector (2**m-1 downto 0);
	           		data_out 			: out	std_logic_vector (m downto 0));
	end component;

	type matrix is array (natural range <>) of std_logic_vector (2**m-1 downto 0);

	constant	m 					: natural := 4;
	-- decommenta queste righe per eseguire il test su Reed-Muller(1,3)
	--constant encoded : matrix(0 to 2**(m+1)-1) := (
	--	(x"00"), (x"55"), (x"33"), (x"66"),
	--	(x"0f"), (x"5a"), (x"3c"), (x"69"),
	--	(x"ff"), (x"aa"), (x"cc"), (x"99"),
	--	(x"f0"), (x"a5"), (x"c3"), (x"96"));
	-- decommenta queste righe per eseguire il test su  Reed-Muller(1,4)
	constant encoded : matrix(0 to 2**(m+1)-1) := (
			(x"0000"), (x"5555"), (x"3333"), (x"6666"), (x"0f0f"), (x"5a5a"), (x"3c3c"), (x"6969"),
			(x"00ff"), (x"55aa"), (x"33cc"), (x"6699"), (x"0ff0"), (x"5aa5"), (x"3cc3"), (x"6996"),
			(x"ffff"), (x"aaaa"), (x"cccc"), (x"9999"), (x"f0f0"), (x"a5a5"), (x"c3c3"), (x"9696"),
			(x"ff00"), (x"aa55"), (x"cc33"), (x"9966"), (x"f00f"), (x"a55a"), (x"c33c"), (x"9669"));


	constant 	clock_period		: time := 10 ns;
	constant	generator_matrix_01 : boolean := true;
	signal		clock 				: std_logic := '0';
	signal		reset_n 			: std_logic := '0';
	signal		data_in 			: std_logic_vector (2**m-1 downto 0) := (others => '0');
	signal		data_out 			: std_logic_vector (m downto 0) := (others => '0');

begin

	uut : RMDecoder
		Generic map (	m 					=> m,
						generator_matrix_01 => generator_matrix_01)
		Port map (		clock 				=> clock,
						reset_n 			=> reset_n,
						data_in 			=> data_in,
						data_out 			=> data_out);

	clock_process : process
	begin
		clock <= not clock;
		wait for clock_period / 2;
	end process clock_process;

	stim_process : process
	begin
		reset_n <= '0', '1' after 5*clock_period;
		wait for 7*clock_period;
		for i in 0 to 2**(m+1)-1 loop
			data_in <=	encoded(i);
			wait for clock_period;
		end loop;

		for i in 2**(m+1)-1 downto 0 loop
			data_in <=	encoded(i);
			wait for clock_period;
		end loop;

		wait;
	end process stim_process;

end Behavioral;


--! @}
