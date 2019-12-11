library ieee;
use ieee.std_logic_1164.all;
use work.mypack.all;

entity ctrl3 is
	port
	(
		clk		: in	std_logic;
		set	 	: in	std_logic;

        hour_adj		: out	std_logic;
		mnt_adj	: out	std_logic;
        sec_adj	: out	std_logic;
        
        time_nalarm : out std_logic;

		disp_hour	: out	std_logic;
		disp_minute	: out	std_logic;
		disp_second	: out	std_logic
	);
end entity;

architecture rtl of ctrl3 is
	type STATE_TYPE is (NORMAL, ADJ_HOUR, 
		ADJ_MINUTE, ADJ_SECOND, ALARM_H, ALARM_M);
	signal state : STATE_TYPE;
	SIGNAL disp_h, disp_m, disp_s : STD_LOGIC;
begin
	disp_hour <= disp_h;
	disp_minute <= disp_m;
	disp_second <= disp_s;
	
--	process (clk)
--	begin
--		if (rising_edge(clk)) then
--			case state is
--				when NORMAL=>
--					if set = '0' then
--						state <= ADJ_HOUR;
--					end if;
--				when ADJ_HOUR=>
--					if set = '0' then
--						state <= ADJ_MINUTE;
--					end if;
--				when ADJ_MINUTE=>
--					if set = '0' then
--						state <= ADJ_SECOND;
--					end if;
--                when ADJ_SECOND =>
--					if set = '0' then
--						state <= ALARM_H;
--					end if;
--				when ALARM_H =>
--					if set = '0' then
--						state <= ALARM_M;
--					end if;
--				when ALARM_M =>
--					if set = '0' then
--						state <= NORMAL;
--					end if;
--				when others =>
--					state <= normal;
--			end case;
--		end if;
--	end process;
	
	process (set)
	begin
		if (rising_edge(set)) then
			case state is
				when NORMAL=>
					state <= ADJ_HOUR;
				when ADJ_HOUR=>
					state <= ADJ_MINUTE;
				when ADJ_MINUTE=>
					state <= ADJ_SECOND;
                when ADJ_SECOND =>
					state <= ALARM_H;
				when ALARM_H =>
					state <= ALARM_M;
				when ALARM_M =>
					state <= NORMAL;
				when others =>
					state <= normal;
			end case;
		end if;
	end process;
	
	process (state,clk)
	begin
		case state is
			when NORMAL=>
				hour_adj <= '0';
				mnt_adj <= '0';
                sec_adj <= '0';
                time_nalarm <= '1';
            when ADJ_HOUR=>
				hour_adj <= '1';
				mnt_adj <= '0';
				sec_adj <= '0';
                time_nalarm <= '1';
			when ADJ_MINUTE=>
				hour_adj <= '0';
				mnt_adj <= '1';
				sec_adj <= '0';
                time_nalarm <= '1';
			when ADJ_SECOND=>
				hour_adj <= '0';
				mnt_adj <= '0';
				sec_adj <= '1';
                time_nalarm <= '1';
			when ALARM_H =>
                hour_adj <= '1';
                mnt_adj <= '0';
                sec_adj <= '0';
                time_nalarm <= '0';
            when ALARM_M =>
                hour_adj <= '0';
                mnt_adj <= '1';
                sec_adj <= '0';
                time_nalarm <= '0';
			when others =>
                hour_adj <= '0';
                mnt_adj <= '0';
                sec_adj <= '0';
                time_nalarm <= '1';
        end case;
	end process;

	process (clk)
	begin
		if (rising_edge(clk)) then
			case state is
				when NORMAL=>
					disp_h <= '1';
					disp_m <= '1';
					disp_s <= '1';
				when ADJ_HOUR=>
					disp_h <= NOT disp_h;
					disp_m <= '1';
					disp_s <= '1';
				when ADJ_MINUTE=>
					disp_h <= '1';
					disp_m <= NOT disp_m;
					disp_s <= '1';
				when ADJ_SECOND =>
					disp_h <= '1';
					disp_m <= '1';
					disp_s <= NOT disp_s;
				when ALARM_H =>
					disp_h <= NOT disp_h;
					disp_m <= '1';
					disp_s <= '0';
				when ALARM_M =>
					disp_h <= '1';
					disp_m <= NOT disp_m;
					disp_s <= '0';
				when others =>
					disp_h <= '1';
					disp_m <= '1';
					disp_s <= '1';
			end case;
		end if;
	end process;

end rtl;