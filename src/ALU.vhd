----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        i_A      : in  std_logic_vector(7 downto 0);
        i_B      : in  std_logic_vector(7 downto 0);
        i_op     : in  std_logic_vector(2 downto 0);
        o_result : out std_logic_vector(7 downto 0);
        o_flags  : out std_logic_vector(3 downto 0)   -- N Z C V
    );
end entity;

architecture behavior of ALU is
    signal result  : std_logic_vector(7 downto 0);
    signal carry   : std_logic := '0';
    signal flags   : std_logic_vector(3 downto 0); -- N Z C V
begin
    process(i_A, i_B, i_op)
        variable temp_sum : unsigned(8 downto 0);
        variable temp_diff : unsigned(8 downto 0);
        variable a_signed, b_signed, res_signed : signed(7 downto 0);
    begin
        carry := '0';
        flags := (others => '0');

        a_signed := signed(i_A);
        b_signed := signed(i_B);

        case i_op is
            when "000" =>  -- ADD
                temp_sum := unsigned('0' & i_A) + unsigned('0' & i_B);
                result   <= std_logic_vector(temp_sum(7 downto 0));
                carry    := temp_sum(8);
                if (i_A(7) = i_B(7)) and (temp_sum(7) /= i_A(7)) then
                    flags(0) := '1';  -- V
                else
                    flags(0) := '0';
                end if;

            when "001" =>  -- SUB
                temp_diff := unsigned('0' & i_A) - unsigned('0' & i_B);
                result    <= std_logic_vector(temp_diff(7 downto 0));
                carry     := not temp_diff(8);  -- Carry = 1 means no borrow
                if (i_A(7) /= i_B(7)) and (temp_diff(7) /= i_A(7)) then
                    flags(0) := '1';  -- V
                else
                    flags(0) := '0';
                end if;

            when "010" =>  -- AND
                result <= i_A and i_B;
                carry  := '0';
                flags(0) := '0';  -- V = 0

            when "011" =>  -- OR
                result <= i_A or i_B;
                carry  := '0';
                flags(0) := '0';  -- V = 0

            when others =>
                result <= (others => '0');
                carry  := '0';
                flags  := (others => '0');
        end case;

        -- Flags assignment: N Z C V
        flags(3) := result(7);                                 -- N
        flags(2) := '1' when result = x"00" else '0';          -- Z
        flags(1) := carry;                                     -- C
        -- V is already assigned in each case above

        o_result <= result;
        o_flags  <= flags;
    end process;
end architecture;
