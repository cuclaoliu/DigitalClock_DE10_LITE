LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MYPACK.ALL;

ENTITY DigitalClock2 IS
	PORT(
	clk			: IN STD_LOGIC;
	set			: IN STD_LOGIC;
	adj			: IN STD_LOGIC;
	ledhour_h	: OUT SSD;
	ledhour_l	: OUT SSD;
	ledmnt_h	: OUT SSD;
	ledmnt_l	: OUT SSD;
	ledsec_h	: OUT SSD;
	ledsec_l	: OUT SSD
	);
END DigitalClock2;

ARCHITECTURE str OF DigitalClock2 IS
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
		en: IN STD_LOGIC := '1';
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
	
	component ctrl2 is
		port(
			clk		: in	std_logic;
			set	 	: in	std_logic;
			hour_adj		: out	std_logic;
			mnt_adj	: out	std_logic;
			sec_adj	: out	std_logic;	
			disp_hour	: out	std_logic;
			disp_minute	: out	std_logic;
			disp_second	: out	std_logic);
	end component;
	SIGNAL clk_8Hz		: STD_LOGIC;
	SIGNAL hour_en, minute_en, second_en	: STD_LOGIC;
	SIGNAL hour_h, hour_l : BCD;
	SIGNAL mnt_h, mnt_l : BCD;
	SIGNAL sec_h, sec_l : BCD;
	SIGNAL m_cout, s_cout				: STD_LOGIC;
	SIGNAL cnt8_cout					: STD_LOGIC;
	SIGNAL cnt8q					: BCD;

	constant	FREQUENCY	:		BCD			:= 8;
	SIGNAL hour_adj, mnt_adj, sec_adj, stop_time	: STD_LOGIC;
	SIGNAL disp_hour, disp_minute, disp_second	: STD_LOGIC;
BEGIN
	-- for simulation
	--clk_4Hz <= clk;
	-- for real hardware
	freqdiv_inst : freq_div
		GENERIC MAP(50E6, FREQUENCY)
		PORT MAP(
			clk_in => clk,
			clk_out => clk_8Hz);

	cnt8: bcdcnt
		PORT MAP(
			clk => clk_8Hz,
			reset => cnt8_cout,
			en => '1', 
			q => cnt8q);
	cnt8_cout <= '1' WHEN cnt8q=FREQUENCY-1 ELSE '0';

	cnt_second	: bcdcnt_2symbol
		GENERIC MAP(60)
		PORT MAP(
			clk => clk_8Hz,
			en => second_en,
			cout => s_cout,
			cnth => sec_h,
			cntl => sec_l);
			
	second_en <= NOT adj WHEN sec_adj='1' ELSE '0' WHEN stop_time='1' ELSE cnt8_cout;	

	cnt_minute	: bcdcnt_2symbol
		GENERIC MAP(60)
		PORT MAP(
			clk => clk_8Hz,
			en => minute_en,
			cout => m_cout,
			cnth => mnt_h,
			cntl => mnt_l);
			
	minute_en <= NOT adj WHEN mnt_adj='1' ELSE '0' WHEN stop_time='1' ELSE cnt8_cout AND s_cout;

	cnt_hour	: bcdcnt_2symbol
		GENERIC MAP(24)
		PORT MAP(
			clk => clk_8Hz,
			en => hour_en, 
			cnth => hour_h,
			cntl => hour_l);
			
	hour_en <= NOT adj WHEN hour_adj='1' ELSE '0' WHEN stop_time='1' ELSE minute_en AND m_cout;				

	hourh_47	: bcdto7segp 
		PORT MAP(
			n => hour_h,
			en => disp_hour,
			leds => ledhour_h);
	hourl_47	: bcdto7segp 
		PORT MAP(
			n => hour_l,
			en => disp_hour,
			leds => ledhour_l);
	minuteh_47	: bcdto7segp 
		PORT MAP(
			n => mnt_h,
			en => disp_minute,
			leds => ledmnt_h);
	minutel_47	: bcdto7segp 
		PORT MAP(
			n => mnt_l,
			en => disp_minute,
			leds => ledmnt_l);
	secondh_47	: bcdto7segp 
		PORT MAP(
			n => sec_h,
			en => disp_second,
			leds => ledsec_h);
	secondl_47	: bcdto7segp 
		PORT MAP(
			n => sec_l,
			en => disp_second,
			leds => ledsec_l);
	ctrl_inst : ctrl2
		port map(
			
			set,--clk,
			'0',
			hour_adj,
			mnt_adj,
			sec_adj,	
			disp_hour,
			disp_minute,
			disp_second	);
	stop_time <= '1' WHEN (hour_adj OR mnt_adj OR sec_adj) = '1' ELSE '0';
END str;