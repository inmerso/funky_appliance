library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lcd_control is
    port (
        clock : in  std_logic;
        reset : in  std_logic;
        char  : in  std_logic_vector(7 downto 0);
        value : out std_logic_vector(6 downto 0));
end entity; -- lcd_control

architecture arch of lcd_control is

begin

    main_process : process( clock, reset )
    begin
        if ( reset = '1' ) then
            value <= ( others => '1');
        elsif ( rising_edge( clock ) ) then
            case( char ) is
                when b"0000_0000" =>
                    value <= b"100_0000";
                when b"0000_0001" =>
                    value <= b"111_1001";
                when b"0000_0010" =>
                    value <= b"010_0100";
                when b"0000_0011" =>
                    value <= b"011_0000";
                when b"0000_0100" =>
                    value <= b"001_1001";
                when b"0000_0101" =>
                    value <= b"001_0010";
                when b"0000_0110" =>
                    value <= b"000_0010";
                when b"0000_0111" =>
                    value <= b"111_1000";
                when b"0000_1000" =>
                    value <= b"000_0000";
                when b"0000_1001" =>
                    value <= b"001_0000";
                when b"1111_1111" => -- OFF
                    value <= b"1111111";
                when others =>
                    value <= b"000_0110";
            end case;
        end if;
    end process; -- main_process

end architecture; -- arch