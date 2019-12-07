library ieee;
use ieee.std_logic_1164.all;
use work.mypack.all;

entity ctrl2 is
	port
	(
		clk		: in	std_logic;
		set	 	: in	std_logic;

        hour_adj		: out	std_logic;
		mnt_adj	: out	std_logic;
		sec_adj	: out	std_logic;

		disp_hour	: out	std_logic;
		disp_minute	: out	std_logic;
		disp_second	: out	std_logic
	);
end entity;

architecture rtl of ctrl2 is
	type STATE_TYPE is (NORMAL, ADJ_HOUR, 
		ADJ_MINUTE, ADJ_SECOND);
	signal state : STATE_TYPE;
	--SIGNAL disp_h, disp_m, disp_s : STD_LOGIC;
begin
	--disp_hour <= disp_h;
	--disp_minute <= disp_m;
	--disp_second <= disp_s;
	
	process (clk)
	begin
		if (rising_edge(clk)) then
			case state is
				when NORMAL=>
					if set = '0' then
						state <= ADJ_HOUR;
					end if;
				when ADJ_HOUR=>
					if set = '0' then
						state <= ADJ_MINUTE;
					end if;
				when ADJ_MINUTE=>
					if set = '0' then
						state <= ADJ_SECOND;
					end if;
				when ADJ_SECOND =>
					if set = '0' then
						state <= NORMAL;
					end if;
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
                disp_hour <= '1';
                disp_minute <= '1';
                disp_second <= '1';
            when ADJ_HOUR=>
				hour_adj <= '1';
				mnt_adj <= '0';
				sec_adj <= '0';
                disp_hour <= clk;
                disp_minute <= '0';
                disp_second <= '0';
			when ADJ_MINUTE=>
				hour_adj <= '0';
				mnt_adj <= '1';
				sec_adj <= '0';
                disp_hour <= '0';
                disp_minute <= clk;
                disp_second <= '0';
			when ADJ_SECOND=>
				hour_adj <= '0';
				mnt_adj <= '0';
				sec_adj <= '1';
                disp_hour <= '0';
                disp_minute <= '0';
                disp_second <= clk;
			when others =>
                hour_adj <= '0';
                mnt_adj <= '0';
                sec_adj <= '0';
                disp_hour <= '1';
                disp_minute <= '1';
                disp_second <= '1';
        end case;
	end process;
end rtl;