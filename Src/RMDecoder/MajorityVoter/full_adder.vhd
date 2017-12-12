--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 12/19/2015  17:27:35
--! @file full_adder.vhd
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

entity full_adder is
    Port (	add_1 		: 	in  STD_LOGIC;
           	add_2 		: 	in  STD_LOGIC;
           	carry_in 	: 	in  STD_LOGIC;
           	carry_out 	: 	out  STD_LOGIC;
			sum 		: 	out  STD_LOGIC);
end full_adder;

architecture DataFlow of full_adder is

begin

	carry_out <= (add_1 and add_2 ) or (carry_in and (add_1 xor add_2));
	sum <= add_1 xor add_2 xor carry_in;

end DataFlow;

--! @}
