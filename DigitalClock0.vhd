LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MYPACK.ALL;

ENTITY DigitalClock0 IS
	PORT(
	clk			: IN STD_LOGIC;
	ledhour_h	: OUT SSD;
	ledhour_l	: OUT SSD;
	ledmnt_h	: OUT SSD;
	ledmnt_l	: OUT SSD;
	ledsec_h	: OUT SSD;
	ledsec_l	: OUT SSD
	);
END DigitalClock0;

ARCHITECTURE str OF DigitalClock0 IS
	COMPONENT bcdcnt_2symbol is
		generic(MAX : natural);
		port(
			clk		: in std_logic;
			reset	: in std_logic := '0';
			en		: in std_logic;
			cnth	: out BCD;
			cntl	: out BCD;
			cout	: out std_logic
		);
	END COMPONENT;
	COMPONENT bcdto7segp is port(
		n: IN BCD;
	  leds: OUT SSD);
	END COMPONENT;
	
	SIGNAL hour_h, hour_l : BCD;
	SIGNAL hour_en				: STD_LOGIC;
BEGIN
	cnt_hour	: bcdcnt_2symbol
		GENERIC MAP(24)
		PORT MAP(
			clk => clk,
			en => hour_en, 
			cnth => hour_h,
			cntl => hour_l);
			
	hour_en <= '1';				


	hourh_47		: bcdto7segp
		PORT MAP(
			n => hour_h,
			leds => ledhour_h);
	hourl_47		: bcdto7segp 
		PORT MAP(
			n => hour_l,
			leds => ledhour_l);
			
	ledmnt_h <= dim;
	ledmnt_l <= dim;
	ledsec_h <= dim;
	ledsec_l <= dim;	
		
END str;