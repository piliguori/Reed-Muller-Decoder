--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 19.12.2015  17:27:35
--! @file ripple_carry_adder.vhd
--! @copyright
--! This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
--! published by the Free Software Foundation; either version 3 of the License, or any later version.
--! This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
--! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--! You should have received a copy of the GNU General Public License along with this program; if not, write to the Free
--! Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

--! @addtogroup MajorityVoter
--! @{

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--!	@brief	Implementazione VHDL Structural di un Ripple Carry Adder generico a N bit
--!
--!	@param	N[in]			parametro che determina il numero di bit per addendo
--!
--! @param	x[in]			addendo 1
--! @param	x[in]			addendo 2
--! @param	carry_in[in]	carry in ingresso
--! @param	carry_out[out]	carry in uscita
--! @param	sum[out]		somma dei due addendi
--!

entity ripple_carry_adder is
	generic ( N : natural := 4);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end ripple_carry_adder;

architecture structural of ripple_carry_adder is

	component full_adder
		Port (	add_1 		: 	in  STD_LOGIC;
			   	add_2 		: 	in  STD_LOGIC;
			   	carry_in 	: 	in  STD_LOGIC;
			   	carry_out 	: 	out  STD_LOGIC;
				sum 		: 	out  STD_LOGIC);
	end component full_adder;

	signal tmp_carry : std_logic_vector (N downto 0) := (others => '0');

begin

tmp_carry(0) <= carry_in;
carry_out <= tmp_carry(N);

full_adder_waterfall: for i in N-1 downto 0 generate
	full_adder_inst : full_adder
		Port Map(	add_1		=> 	x(i),
					add_2 		=> 	y(i),
					carry_in 	=> 	tmp_carry(i),
					carry_out 	=> 	tmp_carry(i+1),
					sum 		=> 	sum(i));
	end generate;

end structural;

--! @}
