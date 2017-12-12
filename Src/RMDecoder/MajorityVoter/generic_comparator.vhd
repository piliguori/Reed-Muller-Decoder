--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 13.04.2017 20:27:06
--! @file generic_comparator.vhd
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

--!	@brief	Implementazione VHDL Structural di un generico comparatore a maggioranza di due stringhe di width bit.
--!			Tale implementazione genera una catena di "width" comparatori a 2 bit
--!
--!	@param	width[in]			parametro che determina la dimensione del comparatore
--!
--! @param	data_in[in]			stringa di bit di input di dimensione width
--! @param	data_cmp[in]		stringa di bit di input di dimensione width
--!	@param	data_out[out]		risultato del confronto:
--!									data_out = 1 se data_in > data_cmp
--!									data_out = 0 altrimenti
--!

entity generic_comparator is
	Generic (	width 		: 	NATURAL := 8);
    Port 	( 	data_in 	: 	in STD_LOGIC_VECTOR (width-1 downto 0);
           		data_cmp 	: 	in STD_LOGIC_VECTOR (width-1 downto 0);
           		data_out 	: 	out STD_LOGIC);
end generic_comparator;

architecture Structural of generic_comparator is

	component comparator2bit
		Port (	a 		: in STD_LOGIC;
			   	b 		: in STD_LOGIC;
			   	res_in 	: in STD_LOGIC;
			   	res_out : out STD_LOGIC);
	end component;

	signal tmp_res : std_logic_vector(width downto 0) := (others => '0');
begin

	tmp_res(0) <= '0';
comparator2bit_Chain: for i in width -1 downto 0 generate
	comparator2bit_Inst : comparator2bit
		Port Map (	a 		=> 	data_in(i),
					b 		=> 	data_cmp(i),
					res_in 	=> 	tmp_res(i),
					res_out => 	tmp_res(i+1));
	end generate;

data_out <= tmp_res(width);

end Structural;

--! @}
