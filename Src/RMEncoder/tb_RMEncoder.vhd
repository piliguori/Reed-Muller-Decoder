--! @Author: Salvatore Barone <salvator.barone@gmail.com, salvator.barone@studenti.unina.it>
--! @Date:   03-05-2017
--! @Filename: tb_RMEncoder.vhd

--! @addtogroup RMEncoder
--! @{

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity tb_RMEncoder is
--  Port ( );
end tb_RMEncoder;

architecture Behavioral of tb_RMEncoder is

	signal clock : std_logic := '0';
	constant period : time := 10 ns;

	component RMEncoder is
		Generic (	m 					: 		natural := 3;
					generator_matrix_01 : 		boolean := true);
	    Port (		data_in 			: in 	std_logic_vector(m downto 0);
	           		data_out 			: out 	std_logic_vector(2**m-1 downto 0));
	end component;

	constant	m	 					: natural := 4;
	constant	generator_matrix_01		: boolean := true;
	signal		data_in 				: std_logic_vector (m downto 0) := (others => '0');
	signal		data_out 				: std_logic_vector (2**m-1 downto 0) := (others => '0');

begin

	uut : RMEncoder
		Generic map (	m 					=> m,
						generator_matrix_01 => generator_matrix_01)
	    Port map (		data_in 			=> data_in,
		           		data_out 			=> data_out);

	stim_process : process
	begin
		for i in 0 to 2**(m+1)-1 loop
			data_in <= std_logic_vector(to_unsigned(i, data_in'length));
			wait for 10 ns;
		end loop;
		wait;
	end process stim_process;

end Behavioral;

--! @}
