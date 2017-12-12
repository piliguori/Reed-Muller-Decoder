--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 14.04.2017 00:32:13
--! @file parallel_counter_block.vhd
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

--!	@brief	Implementazione VHDL Structural del Modulo 1 : genera width/4 contatori paralleli a 4 bit.
--!			Data una stringa di input di width bit, multipla di 4, assegna a ogni contatore un nibble.
--!			Ogni contatore parallelo a 4 bit codifica in binario il numero di 1 presente nel nibble di competenza.
--!
--!	@param	width[in]		parametro che determina la dimensione dell'input del componente, width multiplo di 4
--!
--! @param	data_in[in]		stringa di bit di input di dimensione width su cui il componente lavora
--!	@param	data_out[out]	stringa di bit di uscita di dimensione width-(width/4) che è la concatenazione degli
--!							output dei singoli contatori paralleli a 4 bit => concatenzaione di stringhe da 3 bit.
--!

entity parallel_counter_block is
	Generic	(	width 	: 	NATURAL := 8);
    Port 	( 	data_in : 	in STD_LOGIC_VECTOR (width-1 downto 0);
           		data_out : 	out STD_LOGIC_VECTOR ((width-(width/4))-1 downto 0));
end parallel_counter_block;

architecture Structural of parallel_counter_block is

	signal tmp_in_parallel_conter4 : std_logic_vector(width-1 downto 0);
	signal tmp_out_parellel_counter4 : std_logic_vector((width-(width/4))-1 downto 0) := (others => '0');

	component parallel_counter_4
		Port ( 	X 	: 	in STD_LOGIC_VECTOR (3 downto 0);
			   	C0 	: 	out STD_LOGIC;
			   	C1 	: 	out STD_LOGIC;
			   	C2 	: 	out STD_LOGIC);
	end component;

begin

tmp_in_parallel_conter4 <= data_in;

parallel_adder_block_Inst: for i in 0 to (width/4)-1 generate
	parallel_counter4_inst : parallel_counter_4
		port map	(	X 	=> 	tmp_in_parallel_conter4(4*(i+1)-1 downto 4*i),
						C0 	=> 	tmp_out_parellel_counter4(3*i),
						C1 	=> 	tmp_out_parellel_counter4(3*i+1),
						C2 	=> 	tmp_out_parellel_counter4(3*i+2));
	end generate;

data_out <= tmp_out_parellel_counter4;

end Structural;

--! @}
