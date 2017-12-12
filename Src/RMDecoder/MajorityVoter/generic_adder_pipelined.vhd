--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 15.04.2017 11:59:47
--! @file generic_adder_pipelined.vhd
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

--!	@brief	Implementazione VHDL Structural di un addizionatore generico pipelined : M operandi di N bit
--!
--!	@param	number_operand[in]			parametro che determina il numero di operandi dell' addizionatore
--!	@param	number_bit_for_operand[in]	parametro che determina il numero di bit di ogni operando
--!
--!	@param	clk[in]						segnale di clock
--!	@param	reset_n[in]					segnale di reset asincrono, attivo basso
--! @param	data_in[in]					stringa di bit di input di dimensione (number_operand * number_bit_for_operand) che è la concatenzaione degli operandi da sommare
--!	@param	data_out[out]				stringa di bit di uscita di dimensione (number_bit_for_operand + natural(log2(real(number_operand))))
--!										che è la somma totale degli operandi di ingresso
--!

entity generic_adder_pipelined is
	Generic (	number_operand 			:	NATURAL := 2;
			  	number_bit_for_operand 	: 	NATURAL := 3);
    Port	(	clk 					: 	in STD_LOGIC;
    			reset_n 				: 	in STD_LOGIC;
    			data_in 				: 	in STD_LOGIC_VECTOR ((number_operand * number_bit_for_operand)-1 downto 0);
           		data_out 				: 	out STD_LOGIC_VECTOR ((number_bit_for_operand + natural(log2(real(number_operand))))-1 downto 0));
end generic_adder_pipelined;

architecture Structural of generic_adder_pipelined is

	component adder_block
		Generic (	number_operand 			: 	NATURAL;
				  	number_bit_for_operand 	: 	NATURAL;
				  	level 					: 	NATURAL);
		Port 	( 	data_in 				: 	in STD_LOGIC_VECTOR (number_operand * number_bit_for_operand-1 downto 0);
			   		data_out 				: 	out STD_LOGIC_VECTOR (number_operand * number_bit_for_operand-1 downto 0));
	end component;

	component GenericBuffer is
		Generic	(	width 		:	NATURAL;
					edge		: std_logic);
		Port	(	clock 		: 	in STD_LOGIC;
					reset_n 	: 	in	STD_LOGIC;
					load 		: 	in	STD_LOGIC;
					data_in 	: 	in	STD_LOGIC_VECTOR (width-1 downto 0);
					data_out	: 	out	STD_LOGIC_VECTOR (width-1 downto 0));
	end component;

-- Matrice di segnali di log2(number_operand) segnali di (number_operand * number_bit_for_operand) bit.
	type tmp_sum_array is array(natural range <>)of std_logic_vector(number_operand * number_bit_for_operand-1 downto 0);
	signal tmp_sum : tmp_sum_array(natural(log2(real(number_operand))) downto 0) ;
	signal tmp_sum_buffer : tmp_sum_array(natural(log2(real(number_operand)))-1 downto 0) ;

begin

tmp_sum(natural(log2(real(number_operand)))) <= data_in;

--	Genera log2(number_operand) livelli, dove ogni livello è costituito da 2^level addizionatori che lavorano in parallelo.
--	Per rendere pipelined il componente, tra ogni livello è istanziato un buffer.
--	Ogni addizionatore preleva i due addendi dalla stringa in uscita dal livello precedente e la somma è fornita al livello successivo.
level_adder_block_Inst: for level in natural(log2(real(number_operand)))-1 downto 0 generate	--level = 0 indica l'ultimo sommatore
	adder_block_Inst: adder_block
		Generic Map	(	number_operand 			=> 	number_operand,
						number_bit_for_operand 	=>	number_bit_for_operand,
						level 					=>	level)
		Port Map 	( 	data_in 				=> 	tmp_sum(level+1),
				   		data_out 				=> 	tmp_sum_buffer (level));

buffer_between_adder_block_inst: GenericBuffer
	Generic map	(	width 		=> 	number_operand * number_bit_for_operand,
					edge		=> '1')
	Port map 	(	clock 		=> 	clk,
					reset_n 	=> 	reset_n,
					load 		=> 	'1',
					data_in 	=> 	tmp_sum_buffer(level),
					data_out	=> 	tmp_sum(level));
	end generate;

data_out <= tmp_sum(0)((number_bit_for_operand + natural(log2(real(number_operand))))-1 downto 0);

end Structural;

--! @}
