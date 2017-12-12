--! @author	Salvatore Barone	<salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino 	<alf.dimartino@studenti.unina.it>
--!			Pietro Liguori 		<pi.liguori@studenti.unina.it>
--! @date 14.04.2017 00:12:12
--! @file majority_voter.vhd
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
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;

--!	@brief	Implementazione VHDL Structural del majority voter.
--!
--!	@param	width[in]		parametro che determina la dimensione dell'input del componente, width >= 4
--!
--!	@param	clk[in]			segnale di clock
--!	@param	reset_n[in]		segnale di reset asincrono, attivo basso
--! @param	data_in[in]		stringa di bit di input su cui il componente lavora
--!	@param	majority[out]	bit di uscita :
--!											majority = "0" => nella stringa di input #bit = 1 >= #bit = 0
--!											majority = "1" => nella stringa di input #bit = 1 > #bit = 0
--!


entity majority_voter is
	Generic	(	width 		:	NATURAL := 64);
    Port 	(	clk 		:	in STD_LOGIC;
				reset_n 	:	in STD_LOGIC;
    			data_in 	:	in STD_LOGIC_VECTOR (width-1 downto 0);
           		majority 	:	out STD_LOGIC);
end majority_voter;

architecture Structural of majority_voter is

	component parallel_counter_block
		Generic	(	width 	: NATURAL);
		Port	(	data_in : in STD_LOGIC_VECTOR (width-1 downto 0);
			   		data_out: out STD_LOGIC_VECTOR ((width-(width/4))-1 downto 0));
	end component;

	component generic_adder_pipelined
		Generic (	number_operand 			:	NATURAL;
				  	number_bit_for_operand 	:	NATURAL);
		Port	(	clk 					: 	in STD_LOGIC;
					reset_n 				: 	in STD_LOGIC;
					data_in 				:	in STD_LOGIC_VECTOR ((number_operand * number_bit_for_operand)-1 downto 0);
			   		data_out 				:	out STD_LOGIC_VECTOR ((number_bit_for_operand + natural(log2(real(number_operand))))-1 downto 0));
	end component;

	component generic_comparator
		Generic (	width 		:	NATURAL);
		Port	( 	data_in 	:	in STD_LOGIC_VECTOR (width-1 downto 0);
			   		data_cmp 	:	in STD_LOGIC_VECTOR (width-1 downto 0);
			   		data_out 	:	out STD_LOGIC);
	end component;

-- Segnali di collegamento dei tre moduli di cui il componente è costituito:
	-- input e output del modulo parallel_counter;
	signal parallel_counter_block_in : std_logic_vector (width-1 downto 0) := (others => '0');
	signal parallel_counter_block_out :  std_logic_vector ((width-(width/4))-1 downto 0) := (others => '0');
	-- input e output del modulo generic_adder;
	signal generic_adder_in : std_logic_vector ((width-(width/4))-1 downto 0) := (others => '0');
	signal generic_adder_out : std_logic_vector (3+natural(log2(real((width/4))))-1 downto 0) := (others => '0');
	-- input e output del modulo genericComparator
	signal data_compare_in : std_logic_vector (3+natural(log2(real((width/4))))-1 downto 0) := (others => '0');
	signal data_compare_cmp : std_logic_vector (3+natural(log2(real((width/4))))-1 downto 0) := (others => '0');
	signal data_compare_out : std_logic := '0';

begin

-- Modulo 1 :	prende in iput una stringa di bit multipla di 4; "parallel_counter_block_in"
--				restituisce in output il #bit = 1 per ogni nibble codificato in binario. "parallel_counter_block_out"
--
parallel_counter_block_in <= data_in;

parallel_counter_block_Inst: parallel_counter_block
		Generic Map (	width		=>	width)
		Port Map 	(	data_in 	=> parallel_counter_block_in,
						data_out 	=> parallel_counter_block_out);

-- Modulo 2 :	prende in input una stringa di bit che è la concatenazione di addendi da sommare; "generic_adder_in"
--				restituisce la somma totale. "generic_adder_in"

	generic_adder_in <= parallel_counter_block_out;

generic_adder_pipelined_Inst: generic_adder_pipelined
		Generic Map	(	number_operand 			=>	width/4,
						number_bit_for_operand 	=>	3)
		Port Map 	(	clk						=> 	clk,
						reset_n					=>	reset_n,
						data_in 				=> 	generic_adder_in,
						data_out 				=> 	generic_adder_out);

-- Modulo 3 :	prende in input una stringa di bit che è la somma totale di bit = 1; "data_comapre_in"
--				prende in input una stringa di bit che è la codifica binaria di width/2; "data compare_cmp"
--				restituisce in output :	"data_compare_out"
--										"1" se data_compare_in > data_compare_cmp
--										"0" altrimenti
	data_compare_in <= generic_adder_out;
	data_compare_cmp <= std_logic_vector(to_unsigned(width/2, 3+natural(log2(real((width/4)))))); --data_compare_cmp vale width/2

generic_comparator_Inst: generic_comparator
		Generic Map	(	width 		=> 3+natural(log2(real((width/4))))) --#bit_operando + #livelli_adder
		Port Map 	(	data_in		=> data_compare_in,
						data_cmp	=> data_compare_cmp,
						data_out 	=> data_compare_out);

majority <= data_compare_out;

end Structural;

--! @}
