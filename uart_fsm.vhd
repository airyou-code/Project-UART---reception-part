-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): 
--
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std.standard.boolean.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK      : in std_logic;
   RST      : in std_logic;
   DIN      : in std_logic;
   CNT      : in integer range 0 to 100;
   CNT2     : in integer range 0 to 100;
   RX_EN    : out std_logic;
   CNT_EN   : out std_logic;
   DOUT_VLD : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type STATE_TYPE is (WAIT_START_BIT, WAIT_FIRST_BIT, RECEIVE_DATA, WAIT_STOP_BIT, DATA_VALID);
signal state : STATE_TYPE := WAIT_START_BIT;
begin
      --process (CLK) begin
     -- if rising_edge(CLK) then
    RX_EN <= '1' when state = RECEIVE_DATA else '0';
    CNT_EN <= '1' when state = WAIT_FIRST_BIT or state = RECEIVE_DATA else '0';
    DOUT_VLD <= '1' when state = DATA_VALID else '0';
    process (CLK) begin
    if rising_edge(CLK) then
        if RST = '1' then
            state <= WAIT_START_BIT;
        else
            case state  is 
            when WAIT_START_BIT => if (DIN = '0') then
                                    state <= WAIT_FIRST_BIT;
                                   end if;
            when WAIT_FIRST_BIT => if CNT = (23) then
                                    state <= RECEIVE_DATA;
                                   end if;
            when RECEIVE_DATA   => if CNT2 = (8) then
                                    state <= WAIT_STOP_BIT;
                                   end if;
            when WAIT_STOP_BIT  => if (DIN = '1') then
                                     state <= DATA_VALID;
                                   end if;
            when DATA_VALID     =>  state <= WAIT_START_BIT;
                               
            when others         => null;
            end case;
        end if;
      end if;
    end process;
end behavioral;