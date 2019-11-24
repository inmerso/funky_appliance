library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity second_tick is
    port (
        fin    : in  std_logic; 
        reset  : in  std_logic;
        fout   : out std_logic);
end entity ; -- second_tick

architecture arch of second_tick is

    signal count : natural range 0 to 25000000;
    signal temp : std_logic;

begin

    main : process( fin, reset )
    begin
        if ( reset = '1' ) then
            temp <= '0';
            count <= 0;
        elsif( rising_edge( fin ) ) then
            if ( count = 25000000 ) then
                temp <= not( temp );
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if ;
    end process ; -- main 

    fout <= temp;

end architecture ; -- arch