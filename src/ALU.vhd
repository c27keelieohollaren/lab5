library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        i_A      : in  STD_LOGIC_VECTOR(7 downto 0);
        i_B      : in  STD_LOGIC_VECTOR(7 downto 0);
        i_op     : in  STD_LOGIC_VECTOR(2 downto 0);
        o_result : out STD_LOGIC_VECTOR(7 downto 0);
        o_flags  : out STD_LOGIC_VECTOR(3 downto 0)   -- N Z C V
    );
end ALU;

architecture Behavioral of ALU is
    signal result : STD_LOGIC_VECTOR(7 downto 0);
    signal flags  : STD_LOGIC_VECTOR(3 downto 0); -- N Z C V
begin
    process(i_A, i_B, i_op)
        variable sum      : unsigned(8 downto 0);
        variable diff     : unsigned(8 downto 0);
        variable a_signed : signed(7 downto 0);
        variable b_signed : signed(7 downto 0);
        variable res_signed : signed(7 downto 0);
    begin
        result <= (others => '0');
        flags  <= (others => '0');

        case i_op is
            when "000" =>  --
