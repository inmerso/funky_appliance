library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity key_controller is
    port (
        clock : in std_logic;
        reset : in std_logic;
        sec_pulse : in std_logic;  
        keyin : in std_logic;
        keyout : out std_logic;
        led : out std_logic
    ) ;
end entity ; -- key_controller

architecture arch of key_controller is

signal counter : natural range 0 to 50000000;

begin

    main_process : process( clock, reset )
    begin
        if ( reset = '1' ) then
            led <= '0';
            keyout <= '1';
            counter <= 0;
        elsif ( rising_edge( clock ) ) then
            if(keyin = '0') then
                led <= '1';
                if (counter = 50000000) then
                    counter <= 0;
                    keyout <= '1';
                else
                    counter <= counter + 1;
                    if (counter = 0) then
                        keyout <= '0';
                    else
                        keyout <= '1';
                    end if;
                end if;
            else
                led <= '0';
                counter <= 0;
                keyout <= '1';    
            end if;
        end if ;
    end process ; -- main_process

end architecture ; -- arch