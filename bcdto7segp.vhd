LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MYPACK.ALL;
ENTITY bcdto7segp IS
PORT (n: IN BCD;
	  en: IN STD_LOGIC := '1';
	  leds: OUT SSD);
END bcdto7segp;

ARCHITECTURE rtl0 OF bcdto7segp IS
	--
	signal leds_int : SSD := dim;
BEGIN
	leds <= SSD_DATA(n) when en='1' and n<10 else SSD_DATA(10);
END rtl0;

ARCHITECTURE rtl1 OF bcdto7segp IS
	--
	signal leds_int : SSD := dim;
BEGIN
	leds <= leds_int when en='1' else dim;
	with n select leds_int <= 
		char0 when 0,
		char1 when 1,
		char2 when 2,
		char3 when 3,
		char4 when 4,
		char5 when 5,
		char6 when 6,
		char7 when 7,
		char8 when 8,
		char9 when 9,
		dim   when others;
END rtl1;

ARCHITECTURE rtl2 OF bcdto7segp IS
BEGIN
	PROCESS (n, en)
	BEGIN
		IF en='1' THEN
			CASE n IS
				WHEN 0		=>	leds<=char0;
				WHEN 1		=>	leds<=char1;
				WHEN 2		=>	leds<=char2;
				WHEN 3		=>	leds<=char3;
				WHEN 4		=>	leds<=char4;
				WHEN 5		=>	leds<=char5;
				WHEN 6		=>	leds<=char6;
				WHEN 7		=>	leds<=char7;
				WHEN 8		=>	leds<=char8;
				WHEN 9		=>	leds<=char9;
				WHEN OTHERS	=>	leds<=dim;
			END CASE;
		ELSE
			leds <= dim;
		END IF;
	END PROCESS;
END rtl2;

configuration con of bcdto7segp is
	for rtl0
	end for;
end con;