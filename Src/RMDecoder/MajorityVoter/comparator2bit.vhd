--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 13.04.2017 20:27:06
--! @file comparator2bit.vhd
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

--!	@brief	Implementazione VHDL Data Flow di un comparatore a 2 bit che tiene conto anche del risutato di un confronto precedente.
--!
--! @param	a[in]		ingresso 1
--! @param	b[in]		ingresso 2
--! @param	res_in[in]	risultato del confronto precedente
--! @param	res_out[in]	risultato del confronto
--!

entity comparator2bit is
    Port (	a 		: in STD_LOGIC;
           	b 		: in STD_LOGIC;
           	res_in 	: in STD_LOGIC;
           	res_out : out STD_LOGIC);
end comparator2bit;

architecture DataFlow of comparator2bit is

	signal tmp1, tmp2, tmp3 : std_logic := '0';
begin

	tmp1 <= a and res_in;
	tmp2 <= (not b) and a;
	tmp3 <= (not b) and res_in;

res_out <= tmp1 or tmp2 or tmp3;

end DataFlow;

--! @}
