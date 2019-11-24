library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity funky_appliance is
    port (
        clock_50    : in  std_logic;
        KEY         : in  std_logic_vector(3 downto 0);
        SW          : in  std_logic_vector(9 downto 0);
        LEDR        : out std_logic_vector(9 downto 0);
        LEDG        : out std_logic_vector(7 downto 0);
        HEX0        : out std_logic_vector(6 downto 0);
        HEX1        : out std_logic_vector(6 downto 0);
        HEX2        : out std_logic_vector(6 downto 0);
        HEX3        : out std_logic_vector(6 downto 0));
end entity; -- funky_appliance


architecture arch of funky_appliance is

    subtype t_7segm is std_logic_vector(7 downto 0);
    type t_array7segm is array(natural range <>) of t_7segm;

    signal sys_reset : std_logic;
    signal half_second : std_logic;
    signal second : std_logic;
    signal seven_segment : t_array7segm(0 to 3);
    signal kitchcount1 : std_logic_vector(7 downto 0);
    signal kitchcount2 : std_logic_vector(7 downto 0);
    signal kitchcount3 : std_logic_vector(7 downto 0);
    signal kitchcount4 : std_logic_vector(7 downto 0);
    signal f_keys : std_logic_vector(3 downto 0);
    signal decrement_signal : std_logic;
    signal keyo : std_logic_vector(3 downto 0);
    signal hex : std_logic_vector(27 downto 0);

begin

    main_process : process( sys_reset, clock_50, key, sw )
    begin
        if sys_reset = '0' then
            seven_segment(0) <= kitchcount1;
            seven_segment(1) <= kitchcount2;
            seven_segment(2) <= kitchcount3;
            seven_segment(3) <= kitchcount4;
        end if;
    end process; -- main_process

    keysg : for i in 0 to 3 generate
        k_c_i : entity work.key_controller 
        port map(
            clock  => clock_50,
            reset  => sys_reset,
            sec_pulse => decrement_signal,
            keyin    => key( i ),
            keyout  => keyo( i ),
            led    => ledg( i ));
    end generate ; -- keys
    
    f_d_1 : entity work.frequency_divider
        port map(
            fin    => clock_50,
            reset  => sys_reset,
            fout   => half_second);

    f_d_2 : entity work.second_tick
        port map(
            fin    => clock_50,
            reset  => sys_reset,
            fout   => second);

    sevsegmg : for i in 0 to 3 generate
        ss_g_i : entity work.lcd_control 
        port map(
            clock  => clock_50,
            reset  => sys_reset,
            char   => seven_segment(i),
            value  => hex(6+i*7 downto i*7));    
    end generate ; -- lcd

    sec_pulse : entity work.second_pulse
        port map(
            fin    => clock_50,
            reset  => sys_reset,
            fout   => decrement_signal);

    kitchen : entity work.kitchen_counter
        port map(
            clock_50 => clock_50,
            clock => second,
            decrement => decrement_signal,
            reset => sys_reset,
            minplus => keyo( 3 downto 0 ),
            play => sw( 0 ),
            char1 => kitchcount1,
            char2 => kitchcount2,
            char3 => kitchcount3,
            char4 => kitchcount4,
            led   => ledr(9 downto 2));

    sys_reset <= sw(9);

    ledr(0) <= half_second;

    hex3(6 downto 0) <= hex(27 downto 21);
    hex2(6 downto 0) <= hex(20 downto 14);
    hex1(6 downto 0) <= hex(13 downto 7);
    hex0(6 downto 0) <= hex(6 downto 0);

end architecture; -- arch