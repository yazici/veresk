--
--  Copyright 2015 Oleg Belousov <belousov.oleg@gmail.com>,
--
--  All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--    1. Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
-- 
--    2. Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
-- NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
-- THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation are
-- those of the authors and should not be interpreted as representing official
-- policies, either expressed or implied, of the copyright holder.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.veresk_pkg.all;

entity ram is
    generic (
	addr_bits	: integer := 5;
	data_bits	: integer := 16
    );
    port (
	clk	: in std_logic;
	rst	: in std_logic;

	a_addr	: in std_logic_vector(addr_bits-1 downto 0);
	a_din	: in std_logic_vector(data_bits-1 downto 0);
	a_dout	: out std_logic_vector(data_bits-1 downto 0);
        a_we	: in std_logic;

	b_en	: in std_logic;
	b_addr	: in std_logic_vector(addr_bits-1 downto 0);
	b_din	: in std_logic_vector(data_bits-1 downto 0);
	b_dout	: out std_logic_vector(data_bits-1 downto 0);
        b_we	: in std_logic_vector(3 downto 0)
    );
end ram;

architecture rtl of ram is

type ram_type is array(natural range 0 to (2**(addr_bits))-1) of std_logic_vector(data_bits-1 downto 0);

signal a_addr_word	: std_logic_vector(addr_bits-1 downto 2) := (others => '0');
signal b_addr_word	: std_logic_vector(addr_bits-1 downto 2) := (others => '0');

signal ram : ram_type :=
(

x"00000117",
x"17410113",
x"020000ef",
x"0000006f",
x"80000737",
x"10472783",
x"0017f793",
x"fe079ce3",
x"10a72023",
x"00008067",
x"ff010113",
x"00812423",
x"00000437",
x"00112623",
x"06440413",
x"00044503",
x"00051a63",
x"00c12083",
x"00812403",
x"01010113",
x"00008067",
x"00000097",
x"fbc080e7",
x"00140413",
x"fddff06f",
x"6c6c6548",
x"57202c6f",
x"646c726f",
x"00000021",

others => x"00000013"

);

begin

    a_addr_word <= a_addr(addr_bits-1 downto 2);
    b_addr_word <= b_addr(addr_bits-1 downto 2);

    process (clk, rst, a_addr_word, a_we, b_addr_word, b_we) begin
	if rising_edge(clk) then
	    if rst = '1' then
		a_dout <= (others => '0');
		b_dout <= (others => '0');
	    else
		-- Port A

		a_dout <= ram(to_integer(unsigned(a_addr_word)));

		-- Port B

		if b_we(0) = '1' then
		    ram(to_integer(unsigned(b_addr_word)))(7 downto 0) <= b_din(7 downto 0);
		end if;

		if b_we(1) = '1' then
		    ram(to_integer(unsigned(b_addr_word)))(15 downto 8) <= b_din(15 downto 8);
		end if;

		if b_we(2) = '1' then
		    ram(to_integer(unsigned(b_addr_word)))(23 downto 16) <= b_din(23 downto 16);
		end if;

		if b_we(3) = '1' then
		    ram(to_integer(unsigned(b_addr_word)))(31 downto 24) <= b_din(31 downto 24);
		end if;

		b_dout <= ram(to_integer(unsigned(b_addr_word)));

	    end if;
	end if;
    end process;

end;
