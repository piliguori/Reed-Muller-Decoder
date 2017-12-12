--! @author	Salvatore Barone <salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino <alf.dimartino@studenti.unina.it>
--!			Pietro Liguori <pi.liguori@studenti.unina.it>
--! @date 13-04-2017
--! @file RMEncoder.vhd - implementazione VHDL del codificatore utilizzabile per la codifica dei codici di Reed-Muller RM(1, m).
--! @copyright
--! This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
--! published by the Free Software Foundation; either version 3 of the License, or any later version.
--! This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
--! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--! You should have received a copy of the GNU General Public License along with this program; if not, write to the Free
--! Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

--! @addtogroup RMEncoder
--! @{

-- Changelog
-- 13-04-2017:  Creazione del file e prima implementazione
-- 02-05-2017: Semplificazione generale del codice, volta ad abbassare il numero di dipendenze
--				- il componente Generic2to1Mux e' stato sostituito con l'equivalente codice VHDL, inserito in questo file
--				- l'array di componenti ParityCheck e' stato sostituito con una xor tra i vettori std_logic_vector che
--				  compongono la matrice attraverso la quale viene calcolato il bit piu' significativo dell'output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief Implementazione VHDL del codificatore per codici di Reed-Muller(1,m)
--!
--! Il seguente esempio istanzia un encoder ed un decoder. L'output dell'encoder viene posto in ingresso al decoder. L'input
--! dell'encoder viene controllato attraverso un VIO. Lo stesso VIO viene usato anche per monitorare l'uscita dell'encoder e
--! l'uscita del decoder, oltre che per controllare il segnale di reset di quest'ultimo.
--!
--!		encoder : RMEncoder
--!			Generic map (	m 					=> m,
--!							generator_matrix_01 => generator_matrix_01)
--!			Port map (		data_in 			=> encoder_data_in,
--!							data_out 			=> encoder_data_out);
--!
--!		decoder : RMDecoder
--!			Generic map (	m 					=> m,
--!							generator_matrix_01 => generator_matrix_01)
--!			Port map (		clock 				=> clock,
--!							reset_n 			=> reset_n,
--!							data_in 			=> encoder_data_out,
--!							data_out 			=> decoder_data_out);
--!
--!		vio : vio_0
--!			Port map (	clk 			=> clock,
--!						probe_in0 		=> encoder_data_out,
--!						probe_in1 		=> decoder_data_out,
--!						probe_out0 		=> encoder_data_in,
--!						probe_out1(0) 	=> reset_n);
--!
--! @warning	I codici devono essere stati ottenuti con una matrice di generazione in forma canonica.
--!				Vedi il parametro generator_matrix_01.
--!
--! @param m[in]					parametro "m" del codice di Reed-Muller; incide sulla dimensione, in bit, dell'input e dell'
--!									output del componente: l'input sara' m+1 bit, mentre l'output 2^m bit.
--! @param generator_matrix_01[in]	permette di scegliere la matrice di generazione da usare in fase di decodifica.
--!									Scegliendo generator_matrix_01 => true, verra' usata una matrice<br>
--! 								1111111111111111<br>
--! 								0000000011111111<br>
--! 								0000111100001111<br>
--! 								0011001100110011<br>
--! 								0101010101010101<br>
--!									Se, invece, generator_matrix_01 => false, verra' usata una matrice<br>
--! 								1111111111111111<br>
--! 								1111111100000000<br>
--! 								1111000011110000<br>
--! 								1100110011001100<br>
--! 								1010101010101010
--! @param data_in[in]				stringa di bit, di lunghezza m+1 bit, da codificare come codice di Reed-Muller RM(1, m)
--! @param data_out[out]			stringa di bit corrispondente al codice di Reed-Muller RM(1, m) decodificato, di lunghezza
--!									pari a 2^m bit
--! @test
--!	RM(1,m), m=3<br>
--! <table>
--! <tr><th>data_in</th><th>data_out</th></tr>
--! <tr><td>x"0"</td><td>x"00"</td></tr>
--! <tr><td>x"1"</td><td>x"55"</td></tr>
--! <tr><td>x"2"</td><td>x"33"</td></tr>
--! <tr><td>x"3"</td><td>x"66"</td></tr>
--! <tr><td>x"4"</td><td>x"0f"</td></tr>
--! <tr><td>x"5"</td><td>x"5a"</td></tr>
--! <tr><td>x"6"</td><td>x"3c"</td></tr>
--! <tr><td>x"7"</td><td>x"69"</td></tr>
--! <tr><td>x"8"</td><td>x"ff"</td></tr>
--! <tr><td>x"9"</td><td>x"aa"</td></tr>
--! <tr><td>x"a"</td><td>x"cc"</td></tr>
--! <tr><td>x"b"</td><td>x"99"</td></tr>
--! <tr><td>x"c"</td><td>x"f0"</td></tr>
--! <tr><td>x"d"</td><td>x"a5"</td></tr>
--! <tr><td>x"e"</td><td>x"c3"</td></tr>
--! <tr><td>x"f"</td><td>x"96"</td></tr>
--! </table>
--! RM(1,m), m=4<br>
--! <table>
--! <tr><th>data_in</th><th>data_out</th></tr>
--! <tr><td>x"00"</td><td>x"0000"</td></tr>
--! <tr><td>x"01"</td><td>x"5555"</td></tr>
--! <tr><td>x"02"</td><td>x"3333"</td></tr>
--! <tr><td>x"03"</td><td>x"6666"</td></tr>
--! <tr><td>x"04"</td><td>x"0f0f"</td></tr>
--! <tr><td>x"05"</td><td>x"5a5a"</td></tr>
--! <tr><td>x"06"</td><td>x"3c3c"</td></tr>
--! <tr><td>x"07"</td><td>x"6969"</td></tr>
--! <tr><td>x"08"</td><td>x"00ff"</td></tr>
--! <tr><td>x"09"</td><td>x"55aa"</td></tr>
--! <tr><td>x"0a"</td><td>x"33cc"</td></tr>
--! <tr><td>x"0b"</td><td>x"6699"</td></tr>
--! <tr><td>x"0c"</td><td>x"0ff0"</td></tr>
--! <tr><td>x"0d"</td><td>x"5aa5"</td></tr>
--! <tr><td>x"0e"</td><td>x"3cc3"</td></tr>
--! <tr><td>x"0f"</td><td>x"6996"</td></tr>
--! <tr><td>x"10"</td><td>x"ffff"</td></tr>
--! <tr><td>x"11"</td><td>x"aaaa"</td></tr>
--! <tr><td>x"12"</td><td>x"cccc"</td></tr>
--! <tr><td>x"13"</td><td>x"9999"</td></tr>
--! <tr><td>x"14"</td><td>x"f0f0"</td></tr>
--! <tr><td>x"15"</td><td>x"a5a5"</td></tr>
--! <tr><td>x"16"</td><td>x"c3c3"</td></tr>
--! <tr><td>x"17"</td><td>x"9696"</td></tr>
--! <tr><td>x"18"</td><td>x"ff00"</td></tr>
--! <tr><td>x"19"</td><td>x"aa55"</td></tr>
--! <tr><td>x"1a"</td><td>x"cc33"</td></tr>
--! <tr><td>x"1b"</td><td>x"9966"</td></tr>
--! <tr><td>x"1c"</td><td>x"f00f"</td></tr>
--! <tr><td>x"1d"</td><td>x"a55a"</td></tr>
--! <tr><td>x"1e"</td><td>x"c33c"</td></tr>
--! <tr><td>x"1f"</td><td>x"9669"</td></tr>
--! </table>
--!
entity RMEncoder is
	Generic (	m 					: 		natural := 6;
				generator_matrix_01 : 		boolean := true);
    Port (		data_in 			: in 	std_logic_vector (m downto 0);
           		data_out 			: out 	std_logic_vector (2**m-1 downto 0));
end RMEncoder;

architecture Structural of RMEncoder is

	-- tipi matrice usati nel seguito
	type std_logic_matrix1 is array (natural range <>) of std_logic_vector(2**m-1 downto 0);
	type std_logic_matrix2 is array (natural range <>) of std_logic_vector(2**(m-1)-1 downto 0);

	-- matrice di generazione dei codici di Reed-Muller
	signal generation_matrix : std_logic_matrix1(0 to m);

	-- segnale tutti zero, costituisce l'ingresso "data_in0" dei mux usati per il calcolo di am
	constant zero :  std_logic_vector(2**m-1 downto 0) := (others => '0');

	-- matrice le cui righe da 0 a m costituiscono, in ordine
	-- riga i : data_in(i) and generation_matrix(m-i)
	signal am_matrix : std_logic_matrix1(0 to m);

	-- matrice le cui righe sono costituite dalle xor delle righe della matrice am_matrix
	signal am_xored_matrix : std_logic_matrix1(0 to m-1);

begin

	-- generazione della matrice di...generazione
	-- Nota: Vivado non consente l'uso del costrutto
	-- label : if condition generate
	-- ...
	-- else generate
	-- ...
	-- end generate;
	generator_matrix_choice_01 : if generator_matrix_01 = true generate
		generator_matrix_generation : for i in 0 to 2**m-1 generate
			signal_assignment : for j in 0 to m generate
				generation_matrix(j)(2**m-i-1) <=  std_logic(to_unsigned(i+2**m, m+1)(m-j));
			end generate;
		end generate;
	end generate;
	generator_matrix_choice_10 : if generator_matrix_01 = false generate
		generator_matrix_generation : for i in 0 to 2**m-1 generate
			signal_assignment : for j in 0 to m generate
				generation_matrix(j)(i) <=  std_logic(to_unsigned(i+2**m, m+1)(m-j));
			end generate;
		end generate;
	end generate;

	-- riga i : data_in(i) and generation_matrix(m-i)
	am_matrix_generation : for i in 0 to m generate
		with data_in(i) select
			am_matrix(i) <= generation_matrix(m-i) when '1',
							zero when others;
	end generate;

	am_xored_matrix(0) <= am_matrix(0) xor am_matrix(1);
	data_out <= am_xored_matrix(m-1);
	xor_matrix : for i in 1 to m-1 generate
		am_xored_matrix(i) <= am_xored_matrix(i-1) xor am_matrix(i+1);
	end generate;

end Structural;

--! @}
