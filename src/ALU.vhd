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
    signal result    : STD_LOGIC_VECTOR(7 downto 0);
    signal flags     : STD_LOGIC_VECTOR(3 downto 0); -- N Z C V
    signal sum9      : UNSIGNED(8 downto 0);
    signal diff9     : UNSIGNED(8 downto 0);
    signal A_signed, B_signed, R_signed : SIGNED(7 downto 0);
begin
    process(i_A, i_B, i_op)
    begin
        -- Default values
        result <= (others => '0');
        flags  <= (others => '0');

        -- Signed versions for overflow detection
        A_signed <= signed(i_A);
        B_signed <= signed(i_B);

        case i_op is
            when "000" =>  -- ADD
                sum9 <= ('0' & unsigned(i_A)) + ('0' & unsigned(i_B));
                result <= std_logic_vector(sum9(7 downto 0));
                flags(1) <= sum9(8); -- C
                -- Overflow: same sign inputs, result sign differs
                if (i_A(7) = i_B(7)) and (sum9(7) /= i_A(7)) then
                    flags(0) <= '1'; -- V
                end if;

            when "001" =>  -- SUB
                diff9 <= ('0' & unsigned(i_A)) - ('0' & unsigned(i_B));
                result <= std_logic_vector(diff9(7 downto 0));
                -- Carry = 1 means no borrow
                if unsigned(i_A) >= unsigned(i_B) then
                    flags(1) <= '1';
                else
                    flags(1) <= '0';
                end if;
                R_signed <= signed(result);
                if (i_A(7) /= i_B(7)) and (R_signed(7) /= i_A(7)) then
                    flags(0) <= '1'; -- V
                end if;

            when "010" =>  -- AND
                result <= i_A and i_B;

            when "011" =>  -- OR
                result <= i_A or i_B;

            when others =>
                result <= (others => '0');
        end case;

        -- N: Negative flag (MSB)
        flags(3) <= result(7);

        -- Z: Zero flag
        if result = "00000000" then
            flags(2) <= '1';
        else
            flags(2) <= '0';
        end if;

        -- Output assignments
        o_result <= result;
        o_flags  <= flags;
    end process;
end Behavioral;
