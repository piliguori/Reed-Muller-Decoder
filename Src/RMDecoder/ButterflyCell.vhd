--! @author	Salvatore Barone <salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino <alf.dimartino@studenti.unina.it>
--!			Pietro Liguori <pi.liguori@studenti.unina.it>
--! @date 13 04 2017
--! @file ButterflyCell.vhd
--! @copyright
--! This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
--! published by the Free Software Foundation; either version 3 of the License, or any later version.
--! This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
--! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--! You should have received a copy of the GNU General Public License along with this program; if not, write to the Free
--! Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

--! @addtogroup RMDecoder
--! @{

library ieee;
use ieee.std_logic_1164.all;

--! @brief  implementazione VHDL dello swap usato nel decodificatore di Reed-Muller
--!
--! Il componente ButterflyCell implementa la rete di swap necessarie al'implementazione del decodificatore a maggioranza
--! per i codici di Reed-Muller RM(1, m).
--! Il componente ha un'implementazione parametrica, il che permette di usare lo stesso componente qualsiasi sia il parametro "m".
--!
--! @param m				parametro "m" del codice di Reed-Muller usato.
--! @param data_in[in]		vettore contenente il codice di Reed-Muller da swappare. Il parallelismo e' 2^m - 1
--! @param swapped[out]		vettore che conterra' il risultato delle operazioni di swapping del vettore data_in
entity ButterflyCell is
	Generic (	m 			: 		natural := 3);
    Port (		data_in 	: in 	std_logic_vector (2**m-1 downto 0);
           		swapped 	: out 	std_logic_vector (2**m-1 downto 0));
end ButterflyCell;

architecture Structural of ButterflyCell is
	signal cell0_swapped : std_logic_vector(2**(m-1)-1 downto 0) := (others => '0');
	signal cell1_swapped : std_logic_vector(2**(m-1)-1 downto 0) := (others => '0');
begin

	signal_assignment : for i in 2**(m-1)-1 downto 0 generate
		-- generazione dei segnali di ingresso per le due celle interne
		cell0_swapped(i) <= data_in(2*i);
		cell1_swapped(i) <= data_in(2*i+1);
	end generate;
	swapped <= cell1_swapped & cell0_swapped;

end Structural;

--! @}
