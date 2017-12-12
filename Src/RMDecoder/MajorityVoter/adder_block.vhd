--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 15.04.2017 19:51:29
--! @file adder_block.vhd
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

--!	@brief	Implementazione VHDL Structural di un generico livello del componente generic_adder.
--!			Tale livello è costituito da 2^level addizionatori che lavorano in parallelo, di dimensione dipendente dal livello corrente:
--!				N = number_bit_for_operand + log2(number_operand)-level-1
--!
--!	@param	number_operand[in]			parametro che determina il numero di operandi dell' addizionatore
--!	@param	number_bit_for_operand[in]	parametro che determina il numero di bit di ogni operando
--! @param	level						parametro che determina il livello dell'addizionatore che si sta costruendo
--!
--! @param	data_in[in]					stringa di bit di input di dimensione (number_operand * number_bit_for_operand) che è la concatenzaione
--!										delle somme parziali del livello precedente
--!	@param	data_out[out]				stringa di bit di uscita di dimensione (number_operand * number_bit_for_operand)
--!										che è la concatenzaione delle somme parziali per il livello successivo
--!

entity adder_block is
	Generic (	number_operand 			: 	NATURAL;
			  	number_bit_for_operand 	: 	NATURAL;
			  	level 					: 	NATURAL);
	Port 	( 	data_in 				: 	in STD_LOGIC_VECTOR (number_operand * number_bit_for_operand-1 downto 0);
		   		data_out 				: 	out STD_LOGIC_VECTOR(number_operand * number_bit_for_operand-1 downto 0));
end adder_block;

architecture Structural of adder_block is

	component ripple_carry_adder
		Generic 	(	N 			:	NATURAL);
		Port 		( 	x 			: 	in  STD_LOGIC_VECTOR (N-1 downto 0);
						y 			: 	in  STD_LOGIC_VECTOR (N-1 downto 0);
						carry_in 	: 	in  STD_LOGIC;
						carry_out 	: 	out  STD_LOGIC;
						sum 		: 	out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;

	signal tmp_in, tmp_out : std_logic_vector (number_operand * number_bit_for_operand-1 downto 0) := (others =>'0');
	constant N : natural := number_bit_for_operand + natural(log2(real(number_operand)))-level-1;

begin

tmp_in <= data_in;

-- Genera 2^level addizionatori
adder_block_Inst: for adder in 2**level-1 downto 0 generate
		adder_Inst: ripple_carry_adder
			Generic Map	(	N			=>	N)
			Port Map 	(	x 			=> 	tmp_in (2*N*adder+N-1 downto 2*N*adder), 		-- (N*adder) è lo spiazzamento
							y 			=> 	tmp_in (2*N*adder+2*N-1 downto 2*N*adder+N),
							carry_in	=>	'0',
							carry_out 	=> 	tmp_out ((N+1)*adder+N), 						-- (N+1)*adder è lo spiazzamento
							sum 		=> 	tmp_out ((N+1)*adder+N-1 downto (N+1)*adder)); 	-- (N+1)*adder è lo spiazzamento
	end generate;

data_out <= tmp_out;

end Structural;

--! @}
