library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        i_A      : in  STD_LOGIC_VECTOR (7 downto 0);
        i_B      : in  STD_LOGIC_VECTOR (7 downto 0);
        i_op     : in  STD_LOGIC_VECTOR (2 downto 0);
        o_result : out STD_LOGIC_VECTOR (7 downto 0);
        o_flags  : out STD_LOGIC_VECTOR (3 downto 0)  -- N Z C V
    );
end ALU;

architecture Behavioral of ALU is
    signal unsigned_A, unsigned_B : unsigned(7 downto 0);
    signal signed_A, signed_B     : signed(7 downto 0);
    signal sum_u                  : unsigned(8 downto 0);
    signal diff_u                 : unsigned(8 downto 0);
    signal result                 : STD_LOGIC_VECTOR(7 downto 0);
    signal flags                  : STD_LOGIC_VECTOR(3 downto 0);  -- N Z C V
begin
    unsigned_A <= unsigned(i_A);
    unsigned_B <= unsigned(i_B);
    signed_A   <= signed(i_A);
    signed_B   <= signed(i_B);

    process(i_A, i_B, i_op)
    begin
        result <= (others => '0');
        flags  <= (others => '0');

        case i_op is
            when "000" =>  -- ADD
                sum_u <= ('0' & unsigned_A) + ('0' & unsigned_B);
                result <= std_logic_vector(sum_u(7 downto 0));
                flags(1) <= sum_u(8); -- Carry
                -- Overflow: same sign inputs, different sign output
                if (i_A(7) = i_B(7)) and (result(7) /= i_A(7)) then
                    flags(0) <= '1'; -- V
                end if;

            when "001" =>  -- SUB
                diff_u <= ('0' & unsigned_A) - ('0' & unsigned_B);
                result <= std_logic_vector(diff_u(7 downto 0));
                flags(1) <= not diff_u(8); -- Borrow -> no borrow = carry = 1
                -- Overflow: opposite sign inputs, result sign differs from A
                if (i_A(7) /= i_B(7)) and (result(7) /= i_A(7)) then
                    flags(0) <= '1'; -- V
                end if;

            when "010" =>  -- AND
                result <= i_A and i_B;

            when "011" =>  -- OR
                result <= i_A or i_B;

            when others =>
                result <= (others => '0');
        end case;

        -- Set N and Z flags
        flags(3) <= result(7);                        -- N
        if result = "00000000" then
            flags(2) <= '1';                          -- Z
        end if;

        o_result <= result;
        o_flags  <= flags;
    end process;
end Behavioral;
