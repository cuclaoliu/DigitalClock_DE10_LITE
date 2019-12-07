library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypack.all;

entity bcdcnt_2symbol is
	generic(MAX : natural := 60);
	port(
		clk		: in std_logic;
		reset	: in std_logic;
		en		: in std_logic;
		cnth	: out BCD;
		cntl	: out BCD;
		cout	: out std_logic
	);
end entity;

ARCHITECTURE rtl OF bcdcnt_2symbol IS
  SIGNAL cnth_int, cntl_int : BCD;
  COMPONENT bcdcnt IS
  PORT( clk : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';		
	    en	: IN STD_LOGIC := '1';
	    q: OUT BCD;
        cout : OUT STD_LOGIC);
  END COMPONENT;
  SIGNAL rst_both, cntl_cout: STD_LOGIC;
BEGIN
  one_digit : bcdcnt
    PORT MAP(clk => clk, en => en,
      reset=> rst_both OR reset, q => cntl_int, cout => cntl_cout);
  ten_digit : bcdcnt
    PORT MAP(clk, rst_both OR reset, cntl_cout AND en, cnth_int);

  rst_both <= en WHEN cnth_int=(MAX-1)/10 AND cntl_int=(MAX-1) MOD 10 ELSE '0';
  cout <= rst_both;
  cnth <= cnth_int;
  cntl <= cntl_int;
END rtl;