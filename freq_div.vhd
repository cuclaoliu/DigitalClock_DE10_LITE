LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY freq_div IS
	GENERIC(
		FREQ_IN	: NATURAL := 50E6;
		FREQ_OUT: NATURAL := 4);
	PORT(
	clk_in	: IN STD_LOGIC;
	clk_out	: OUT STD_LOGIC
	);
END freq_div;

ARCHITECTURE str OF freq_div IS
	SIGNAL cnt	: INTEGER RANGE 0 TO FREQ_IN/FREQ_OUT-1 := 0;
BEGIN
	PROCESS(clk_in)
	BEGIN
		IF RISING_EDGE(clk_in) THEN
			IF cnt < FREQ_IN/FREQ_OUT-1 THEN
			  cnt <= cnt + 1;
			ELSE
			  cnt <= 0;
			END IF;
			IF cnt < FREQ_IN/FREQ_OUT/2-1 THEN
				clk_out <= '0';
			ELSE
				clk_out <= '1';
			END IF;
		END IF;
	END PROCESS;
END str;