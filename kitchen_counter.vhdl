library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std;

entity kitchen_counter is
    port (
        clock_50  : in std_logic;
        clock     : in std_logic;
        decrement : in std_logic;
        reset     : in std_logic;
        minplus   : in std_logic_vector(3 downto 0);
        play      : in std_logic;
        char1     : out std_logic_vector(7 downto 0);
        char2     : out std_logic_vector(7 downto 0);
        char3     : out std_logic_vector(7 downto 0);
        char4     : out std_logic_vector(7 downto 0);
        led       : out std_logic_vector(7 downto 0));
end entity; -- kitchen_counter

architecture arch of kitchen_counter is

    signal minute_h : std_logic_vector(3 downto 0);
    signal minute_l : std_logic_vector(3 downto 0);
    signal second   : std_logic_vector(7 downto 0);
    signal expired  : std_logic;

begin

    main : process( clock_50, reset, minplus )
    begin
        if reset = '1' then
            minute_h <= (others => '0');
            minute_l <= (others => '0');
            second <= (others => '0');
            expired <= '0';
        elsif rising_edge( clock_50 ) then
            if play = '1' then
                if decrement = '1' then
                    if second = "00000000" AND minute_l = "0000" AND minute_h = "0000" then
                        expired <= '1';
                    else
                        expired <= '0';
                        if ( second = "00000000" ) then
                            second <= "01011001";
                            if ( minute_l = "0000" ) then
                                if ((minute_h /= "0000")) then
                                    minute_h <= minute_h - '1';
                                end if;
                                minute_l <= "1001";
                            else
                                -- decrement minute
                                if (minute_l = "0000") then
                                    minute_l <= "1001";
                                    minute_h <= minute_h - '1';
                                else
                                    minute_l <= minute_l - '1';
                                end if;
                            end if;
                        elsif ( second(3 downto 0) = "0000" ) then
                            second(7 downto 4) <= second(7 downto 4) - 1;
                            second(3 downto 0) <= "1001";
                        else
                            second <= second - 1;
                        end if;
                    end if;
                end if;
            else
                if (minute_h < x"9") then
                    if (minplus(0) = '0') then
                        if (minute_l = "1001") then
                            minute_h <= minute_h + '1';
                            minute_l <= "0000";
                        else
                            -- increment minute
                            if (minute_l = "1001") then
                                minute_l <= "0000";
                                minute_h <= minute_h + '1';
                            else
                                minute_l <= minute_l + '1';
                            end if;
                        end if;
                    end if;
                    -- Increment by 2
                    if (minplus(1) = '0') then
                        if (minute_l = "1000") then
                            minute_l <= "0000";
                            minute_h <= minute_h + '1';
                        elsif (minute_l = "1001") then
                            minute_l <= "0001";
                            minute_h <= minute_h + '1';
                        else
                            minute_l <= minute_l + "10";
                        end if;
                    end if;
                    -- Increment by 5
                    if (minplus(2) = '0') then
                        if (minute_l < "0101") then
                            minute_l <= minute_l + "0101";
                        else
                            minute_l <= minute_l - "0101";
                            minute_h <= minute_h + '1';
                        end if;
                    end if;
                    -- Increment by 10
                    if (minplus(3) = '0') then
                        minute_h <= minute_h + '1';
                    end if;
                end if;
                expired <= '0';
            end if;
        end if; -- clock
    end process; -- main

    char4 <= "0000" & minute_h;
    char3 <= "0000" & minute_l;
    char2 <= "0000" & second(7 downto 4);
    char1 <= "0000" & second(3 downto 0);

    led(7 downto 0) <= x"FF" when (expired = '1' and clock = '1' and play = '1' ) else x"00";

end architecture; -- arch