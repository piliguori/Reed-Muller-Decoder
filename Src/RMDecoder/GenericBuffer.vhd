--! @author	Salvatore Barone <salvator.barone@studenti.unina.it>
--!			Alfonso Di Martino <alf.dimartino@studenti.unina.it>
--!			Pietro Liguori <pi.liguori@studenti.unina.it>
--! @date 17-04-2017
--! @copyright
--! This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as
--! published by the Free Software Foundation; either version 3 of the License, or any later version.
--! This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
--! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
--! You should have received a copy of the GNU General Public License along with this program; if not, write to the Free
--! Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

--! @addtogroup RMDecoder
--! @{

-- Changelog
-- 17-04-2017: creazione del file e prima implementazione
-- 27-4-2017: Implementazione di architettura Falling Edge su clock
-- 09-05-2017: Unione delle architetture in una sola
--				- Aggiunto parametro di configurazione "edge", che permette di scegliere quale sia il fronte attivo del clock

library ieee;
use ieee.std_logic_1164.all;

--! @brief Registro di dimensione generica
--!
--! @param width[in]		numero di bit del registro
--! @param edge[in]			fronte di attivo del clock:
--!							- '1': fronte di salita
--!							- '0': fronte di discesa
--! @param clock[in]		segnale di clock
--! @param reset_n[in]		reset asincrono, attivo basso
--! @param load[in]			segnale di load, quando '1' l'uscita (data_out) segue l'ingresso (data_in)
--! @param data_in[in]		ingresso del registro
--! @param data_out[out] 	uscita del registro
entity GenericBuffer is
	Generic (	width 		:		natural := 8;
				edge		:		std_logic := '1');
	Port (		clock 		: in	std_logic;
				reset_n 	: in	std_logic;
				load 		: in	std_logic;
				data_in 	: in	std_logic_vector(width-1 downto 0);
				data_out	: out	std_logic_vector(width-1 downto 0));
end GenericBuffer;

architecture Behavioral of GenericBuffer is
	signal tmp : std_logic_vector(width-1 downto 0) := (others => '0');
begin
	data_out <= tmp;
	process(clock, reset_n, load, data_in)
	begin
		if reset_n = '0' then
			tmp <= (others => '0');
		elsif clock'event and clock = edge then
			if (load = '1') then
				tmp <= data_in;
			end if;
		end if;
	end process;
end Behavioral;

--! @}
