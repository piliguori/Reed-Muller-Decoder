--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 12/19/2015  17:27:35
--! @file parallel_counter_4.vhd
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

entity parallel_counter_4 is
    Port(	X 	: 	in STD_LOGIC_VECTOR (3 downto 0);
           	C0 	: 	out STD_LOGIC;
           	C1 	:	out STD_LOGIC;
           	C2 	: 	out STD_LOGIC);
end parallel_counter_4;

architecture Structural of parallel_counter_4 is

	component full_adder
		Port (	add_1		: 	in STD_LOGIC;
				add_2 		: 	in STD_LOGIC;
				carry_in 	: 	in STD_LOGIC;
				carry_out 	: 	out STD_LOGIC;
				sum 		:	out STD_LOGIC);
	end component;

	signal tmp_cout_0, tmp_cout_1,tmp_cout_2, tmp_sum_0, tmp_sum_1, tmp_sum_2: std_logic := '0';

begin

full_adder_Inst_0: full_adder
	Port Map (	add_1 		=> 	X(2),
				add_2 		=> 	X(1),
				carry_in 	=> 	X(0),
				carry_out 	=> 	tmp_cout_0,
				sum 		=> 	tmp_sum_0);

full_adder_Inst_1: full_adder
	Port Map (	add_1 		=> 	tmp_sum_0,
				add_2 		=> 	X(3),
				carry_in 	=> 	'0',
				carry_out 	=> 	tmp_cout_1,
				sum 		=> 	tmp_sum_1);

full_adder_Inst_2: full_adder
	Port Map (	add_1 		=> 	tmp_cout_0,
				add_2 		=> 	tmp_cout_1,
				carry_in 	=> 	'0',
				carry_out 	=> 	tmp_cout_2,
				sum 		=> 	tmp_sum_2);

C0 <= tmp_sum_1;
C1 <= tmp_sum_2;
C2 <= tmp_cout_2;

end Structural;

--! @}
