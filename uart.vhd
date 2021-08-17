-- uart.vhd: UART controller - receiving part
-- Author(s): xkiril01 
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std.standard.boolean.all;

-------------------------------------------------
entity UART_RX is
port(	
   CLK: 	      in std_logic;
   RST: 	      in std_logic;
   DIN: 	      in std_logic;
   DOUT: 	    out std_logic_vector(7 downto 0);
   DOUT_VLD: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
  signal cnt		   : integer range 0 to 100;
  signal cnt2 	  : integer range 0 to 100;
  signal rx_en	  : std_logic;
  signal cnt_en	 : std_logic;
  signal DVLD		  : std_logic;
begin
  FSM: entity work.UART_FSM(behavioral)
  port map (
    CLK		    => CLK,
    RST		    => RST,
    DIN		    => DIN,
    CNT		    => cnt, 
    CNT2		   => cnt2,
    RX_EN		  => rx_en,
    CNT_EN   => cnt_en,
    DOUT_VLD => DVLD
  );
  DOUT_VLD <= DVLD;
  process (CLK) begin
    if rising_edge(CLK) then
      if cnt_en = '1' then 
          cnt <= (cnt + 1);
      else 
          cnt <= (0);	
          cnt2 <= (0);		
      end if;
      if rx_en = '1' then
        if (cnt >= (15)) then
          cnt <= (0);
          case cnt2 is
             when (0) => DOUT(0) <= DIN;
             when (1) => DOUT(1) <= DIN;
             when (2) => DOUT(2) <= DIN;
             when (3) => DOUT(3) <= DIN;
             when (4) => DOUT(4) <= DIN;
             when (5) => DOUT(5) <= DIN;
             when (6) => DOUT(6) <= DIN;
             when (7) => DOUT(7) <= DIN;
             when others => null;
          end case;
          cnt2 <= (cnt2 + 1);
        end if;
      end if;
    end if;
  end process;
end behavioral;

