library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        i_A      : in  STD_LOGIC_VECTOR(7 downto 0);
        i_B      : in  STD_LOGIC_VECTOR(7 downto 0);
        i_op     : in  STD_LOGIC_VECTOR(2 downto 0);
        o_result : out STD_LOGIC_VECTOR(7 downto 0);
        o_flags  : out STD_LOGIC_VECTOR(3 downto 0)  -- N Z C V
    );
end ALU;

architecture Behavioral of ALU is
    signal result  : STD_LOGIC_VECTOR(7 downto 0);
    signal flags   : STD_LOGIC_VECTOR(3 downto 0);  -- N Z C V
    signal A_u     : UNSIGNED(7 downto 0);
    signal B_u     : UNSIGNED(7 downto 0);
    signal A_s     : SIGNED(7 downto 0);
    signal B_s     : SIGNED(7 downto 0);
    signal sum9    : UNSIGNED(8 downto 0);
    signal diff9   : SIGNED(8 downto 0);
    signal temp    : STD_LOGIC_VECTOR(7 downto 0);
begin

    A_u <= unsigned(i_A);
    B_u <= unsigned(i_B);
    A_s <= signed(i_A);
    B_s <= signed(i_B);

    process(i_A, i_B, i_op)
    begin
        result <= (others => '0');
        flags  <= (others => '0');

        case i_op is
            when "000" =>  -- ADD
                sum9   <= ('0' & A_u) + ('0' & B_u);
                temp   <= std_logic_vector(sum9(7 downto 0));
                result <= temp;
                -- Flags
                flags(3) <= temp(7);  -- N
                if temp = x"00" then
                    flags(2) <= '1';  -- Z
                end if;
                flags(1) <= sum9(8);  -- C
                if (i_A(7) = i_B(7)) and (temp(7) /= i_A(7)) then
                    flags(0) <= '1';  -- V
                end if;

            when "001" =>  -- SUB
                diff9  <= ('0' & A_s) - ('0' & B_s);
                temp   <= std_logic_vector(diff9(7 downto 0));
                result <= temp;
                -- Flags
                flags(3) <= temp(7);  -- N
                if temp = x"00" then
                    flags(2) <= '1';  -- Z
                end if;
                if A_u >= B_u then
                    flags(1) <= '1';  -- C = no borrow
                else
                    flags(1) <= '0';
                end if;
                if (i_A(7) /= i_B(7)) and (temp(7) /= i_A(7)) then
                    flags(0) <= '1';  -- V
                end if;

            when "010" =>  -- AND
                result <= i_A and i_B;
                flags(3) <= (i_A and i_B)(7);
                if (i_A and i_B) = x"00" then
                    flags(2) <= '1';
                end if;

            when "011" =>  -- OR
                result <= i_A or i_B;
                flags(3) <= (i_A or i_B)(7);
                if (i_A or i_B) = x"00" then
                    flags(2) <= '1';
                end if;

            when others =>
                result <= (others => '0');
                flags  <= (others => '0');
        end case;
    end process;

    o_result <= result;
    o_flags  <= flags;

end Behavioral;
