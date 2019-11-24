library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity second_pulse is
    port (
        fin    : in  std_logic; 
        reset  : in  std_logic;
        fout   : out std_logic);
end entity ; -- second_pulse

architecture arch of second_pulse is

    signal count : natural range 0 to 50000000;
    signal temp : std_logic;

begin

    main : process( fin, reset )
    begin
        if ( reset = '1' ) then
            temp <= '0';
        elsif( rising_edge( fin ) ) then
            if ( count = 50000000 ) then
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if ;
    end process ; -- main 

    fout <= '1' when count = 0 else '0';

end architecture ; -- arch