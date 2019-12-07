LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MYPACK.ALL;

ENTITY DigitalClock1 IS
	PORT(
	clk			: IN STD_LOGIC;
	ledhour_h	: OUT SSD;
	ledhour_l	: OUT SSD;
	ledmnt_h	: OUT SSD;
	ledmnt_l	: OUT SSD;
	ledsec_h	: OUT SSD;
	ledsec_l	: OUT SSD
	);
END DigitalClock1;

ARCHITECTURE str OF DigitalClock1 IS
  COMPONENT bcdcnt IS
  PORT( clk : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';		
	    en	: IN STD_LOGIC := '1';
	    q: OUT BCD;
        cout : OUT STD_LOGIC);
  END COMPONENT;
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
	COMPONENT freq_div IS
		GENERIC(
		FREQ_IN	: NATURAL := 50E6;
		FREQ_OUT: NATURAL := 4);
		PORT(
		clk_in	: IN STD_LOGIC;
		clk_out	: OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL clk_8Hz		: STD_LOGIC;
	SIGNAL hour_en, minute_en, second_en	: STD_LOGIC;
	SIGNAL hour_h, hour_l : BCD;
	SIGNAL mnt_h, mnt_l : BCD;
	SIGNAL sec_h, sec_l : BCD;
	SIGNAL m_cout, s_cout				: STD_LOGIC;
	SIGNAL cnt8_cout					: STD_LOGIC;
	SIGNAL cnt8q					: BCD;

BEGIN
	-- for simulation
	--clk_4Hz <= clk;
	-- for real hardware
	freqdiv_inst : freq_div
		GENERIC MAP(50E6, 8)
		PORT MAP(
			clk_in => clk,
			clk_out => clk_8Hz);

	cnt8: bcdcnt
		PORT MAP(
			clk => clk_8Hz,
			reset => cnt8_cout,
			en => '1', 
			q => cnt8q);
	cnt8_cout <= '1' WHEN cnt8q=8-1 ELSE '0';

	cnt_second	: bcdcnt_2symbol
		GENERIC MAP(60)
		PORT MAP(
			clk => clk_8Hz,
			en => second_en,
			cout => s_cout,
			cnth => sec_h,
			cntl => sec_l);
			
	second_en <= cnt8_cout;	

	cnt_minute	: bcdcnt_2symbol
		GENERIC MAP(60)
		PORT MAP(
			clk => clk_8Hz,
			en => minute_en,
			cout => m_cout,
			cnth => mnt_h,
			cntl => mnt_l);
			
	minute_en <= cnt8_cout AND s_cout;

	cnt_hour	: bcdcnt_2symbol
		GENERIC MAP(24)
		PORT MAP(
			clk => clk_8Hz,
			en => hour_en, 
			cnth => hour_h,
			cntl => hour_l);
			
	hour_en <= minute_en AND m_cout;				


	hourh_47		: bcdto7segp PORT MAP(
						n => hour_h,
						leds => ledhour_h);
	hourl_47		: bcdto7segp PORT MAP(
						n => hour_l,
						leds => ledhour_l);
	minuteh_47		: bcdto7segp PORT MAP(
						n => mnt_h,
						leds => ledmnt_h);
	minutel_47		: bcdto7segp PORT MAP(
						n => mnt_l,
						leds => ledmnt_l);
	secondh_47		: bcdto7segp PORT MAP(
						n => sec_h,
						leds => ledsec_h);
	secondl_47		: bcdto7segp PORT MAP(
						n => sec_l,
						leds => ledsec_l);
		
END str;