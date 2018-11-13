### This file is a general .xdc for the Nexys Video Rev. A
### To use it in a project:
### - uncomment the lines corresponding to used pins
### - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock Signal
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports CLK_IN]
create_clock -period 10.000 -name CLK_IN [get_ports CLK_IN]

## FMC Transceiver clocks (Must be set to value provided by Mezzanine card, currently set to 156.25 MHz)
## Note: This clock is attached to a MGTREFCLK pin
#set_property -dict { PACKAGE_PIN E6 } [get_ports { GTP_CLK_N }];
#set_property -dict { PACKAGE_PIN F6 } [get_ports { GTP_CLK_P }];
#create_clock -add -name gtpclk0_pin -period 6.400 -waveform {0 3.200} [get_ports {GTP_CLK_P}];
#set_property -dict { PACKAGE_PIN E10 } [get_ports { FMC_MGT_CLK_N }];
#set_property -dict { PACKAGE_PIN F10 } [get_ports { FMC_MGT_CLK_P }];
#create_clock -add -name mgtclk1_pin -period 6.400 -waveform {0 3.200} [get_ports {FMC_MGT_CLK_P}];


## LEDs
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS25} [get_ports {led_out[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS25} [get_ports {led_out[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports {led_out[2]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS25} [get_ports {led_out[3]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS25} [get_ports {led_out[4]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS25} [get_ports {led_out[5]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS25} [get_ports {led_out[6]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS25} [get_ports {led_out[7]}]


## Buttons
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS12} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS12} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS12} [get_ports {btn[2]}]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS12} [get_ports {btn[3]}]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS12} [get_ports {btn[4]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS15} [get_ports btnCpuReset]


## Switches
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS12} [get_ports {sw_in[0]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS12} [get_ports {sw_in[1]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS12} [get_ports {sw_in[2]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS12} [get_ports {sw_in[3]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS12} [get_ports {sw_in[4]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS12} [get_ports {sw_in[5]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS12} [get_ports {sw_in[6]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS12} [get_ports {sw_in[7]}]


## OLED Display
#set_property -dict { PACKAGE_PIN W22   IOSTANDARD LVCMOS33 } [get_ports { oled_dc }]; #IO_L7N_T1_D10_14 Sch=oled_dc
#set_property -dict { PACKAGE_PIN U21   IOSTANDARD LVCMOS33 } [get_ports { oled_res }]; #IO_L4N_T0_D05_14 Sch=oled_res
#set_property -dict { PACKAGE_PIN W21   IOSTANDARD LVCMOS33 } [get_ports { oled_sclk }]; #IO_L7P_T1_D09_14 Sch=oled_sclk
#set_property -dict { PACKAGE_PIN Y22   IOSTANDARD LVCMOS33 } [get_ports { oled_sdin }]; #IO_L9N_T1_DQS_D13_14 Sch=oled_sdin
#set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { oled_vbat }]; #IO_0_14 Sch=oled_vbat
#set_property -dict { PACKAGE_PIN V22   IOSTANDARD LVCMOS33 } [get_ports { oled_vdd }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=oled_vdd


## HDMI in
#set_property -dict { PACKAGE_PIN AA5   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_cec }]; #IO_L10P_T1_34 Sch=hdmi_rx_cec
#set_property -dict { PACKAGE_PIN W4    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_n }]; #IO_L12N_T1_MRCC_34 Sch=hdmi_rx_clk_n
#set_property -dict { PACKAGE_PIN V4    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_p }]; #IO_L12P_T1_MRCC_34 Sch=hdmi_rx_clk_p
#set_property -dict { PACKAGE_PIN AB12  IOSTANDARD LVCMOS25 } [get_ports { hdmi_rx_hpa }]; #IO_L7N_T1_13 Sch=hdmi_rx_hpa
#set_property -dict { PACKAGE_PIN Y4    IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_scl }]; #IO_L11P_T1_SRCC_34 Sch=hdmi_rx_scl
#set_property -dict { PACKAGE_PIN AB5   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_sda }]; #IO_L10N_T1_34 Sch=hdmi_rx_sda
#set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_txen }]; #IO_L3P_T0_DQS_34 Sch=hdmi_rx_txen
#set_property -dict { PACKAGE_PIN AA3   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_n[0] }]; #IO_L9N_T1_DQS_34 Sch=hdmi_rx_n[0]
#set_property -dict { PACKAGE_PIN Y3    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_p[0] }]; #IO_L9P_T1_DQS_34 Sch=hdmi_rx_p[0]
#set_property -dict { PACKAGE_PIN Y2    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_n[1] }]; #IO_L4N_T0_34 Sch=hdmi_rx_n[1]
#set_property -dict { PACKAGE_PIN W2    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_p[1] }]; #IO_L4P_T0_34 Sch=hdmi_rx_p[1]
#set_property -dict { PACKAGE_PIN V2    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_n[2] }]; #IO_L2N_T0_34 Sch=hdmi_rx_n[2]
#set_property -dict { PACKAGE_PIN U2    IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_p[2] }]; #IO_L2P_T0_34 Sch=hdmi_rx_p[2]


## HDMI out
#set_property -dict { PACKAGE_PIN AA4   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]; #IO_L11N_T1_SRCC_34 Sch=hdmi_tx_cec
#set_property -dict { PACKAGE_PIN U1    IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_n }]; #IO_L1N_T0_34 Sch=hdmi_tx_clk_n
#set_property -dict { PACKAGE_PIN T1    IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_p }]; #IO_L1P_T0_34 Sch=hdmi_tx_clk_p
#set_property -dict { PACKAGE_PIN AB13  IOSTANDARD LVCMOS25 } [get_ports { hdmi_tx_hpd }]; #IO_L3N_T0_DQS_13 Sch=hdmi_tx_hpd
#set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_rscl }]; #IO_L6P_T0_34 Sch=hdmi_tx_rscl
#set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_rsda }]; #IO_L6N_T0_VREF_34 Sch=hdmi_tx_rsda
#set_property -dict { PACKAGE_PIN Y1    IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_red_n }]; #IO_L5N_T0_34 Sch=hdmi_tx_n[0]
#set_property -dict { PACKAGE_PIN W1    IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_red_p }]; #IO_L5P_T0_34 Sch=hdmi_tx_p[0]
#set_property -dict { PACKAGE_PIN AB1   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_green_n }]; #IO_L7N_T1_34 Sch=hdmi_tx_n[1]
#set_property -dict { PACKAGE_PIN AA1   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_green_p }]; #IO_L7P_T1_34 Sch=hdmi_tx_p[1]
#set_property -dict { PACKAGE_PIN AB2   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_blue_n }]; #IO_L8N_T1_34 Sch=hdmi_tx_n[2]
#set_property -dict { PACKAGE_PIN AB3   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_blue_p }]; #IO_L8P_T1_34 Sch=hdmi_tx_p[2]


## Display Port
#set_property -dict { PACKAGE_PIN AB10  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_n }]; #IO_L8N_T1_13 Sch=dp_tx_aux_n
#set_property -dict { PACKAGE_PIN AA11  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_n }]; #IO_L9N_T1_DQS_13 Sch=dp_tx_aux_n
#set_property -dict { PACKAGE_PIN AA9   IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_p }]; #IO_L8P_T1_13 Sch=dp_tx_aux_p
#set_property -dict { PACKAGE_PIN AA10  IOSTANDARD TMDS_33  } [get_ports { dp_tx_aux_p }]; #IO_L9P_T1_DQS_13 Sch=dp_tx_aux_p
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { dp_tx_hpd }]; #IO_25_14 Sch=dp_tx_hpd


## Audio Codec
#set_property -dict { PACKAGE_PIN T4    IOSTANDARD LVCMOS33 } [get_ports { ac_adc_sdata }]; #IO_L13N_T2_MRCC_34 Sch=ac_adc_sdata
#set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { ac_bclk }]; #IO_L14P_T2_SRCC_34 Sch=ac_bclk
#set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports { ac_dac_sdata }]; #IO_L15P_T2_DQS_34 Sch=ac_dac_sdata
#set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports { ac_lrclk }]; #IO_L14N_T2_SRCC_34 Sch=ac_lrclk
#set_property -dict { PACKAGE_PIN U6    IOSTANDARD LVCMOS33 } [get_ports { ac_mclk }]; #IO_L16P_T2_34 Sch=ac_mclk


## Pmod header JA
set_property -dict { PACKAGE_PIN AB22  IOSTANDARD LVCMOS33 } [get_ports { jalo[1] }]; #IO_L10N_T1_D15_14 Sch=ja[1]
set_property -dict { PACKAGE_PIN AB21  IOSTANDARD LVCMOS33 } [get_ports { jalo[2] }]; #IO_L10P_T1_D14_14 Sch=ja[2]
set_property -dict { PACKAGE_PIN AB20  IOSTANDARD LVCMOS33 } [get_ports { jalo[3] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=ja[3]
set_property -dict { PACKAGE_PIN AB18  IOSTANDARD LVCMOS33 } [get_ports { jalo[4] }]; #IO_L17N_T2_A13_D29_14 Sch=ja[4]
set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports { jahi[7] }]; #IO_L9P_T1_DQS_14 Sch=ja[7]
set_property -dict { PACKAGE_PIN AA21  IOSTANDARD LVCMOS33 } [get_ports { jahi[8] }]; #IO_L8N_T1_D12_14 Sch=ja[8]
set_property -dict { PACKAGE_PIN AA20  IOSTANDARD LVCMOS33 } [get_ports { jahi[9] }]; #IO_L8P_T1_D11_14 Sch=ja[9]
set_property -dict { PACKAGE_PIN AA18  IOSTANDARD LVCMOS33 } [get_ports { jahi[10] }]; #IO_L17P_T2_A14_D30_14 Sch=ja[10]


## Pmod header JB
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports {vga_red_out[0]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {vga_red_out[1]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {vga_red_out[2]}]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {vga_red_out[3]}]
set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {vga_blue_out[0]}]
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {vga_blue_out[1]}]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {vga_blue_out[2]}]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS33} [get_ports {vga_blue_out[3]}]


## Pmod header JC
set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {vga_green_out[0]}]
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {vga_green_out[1]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {vga_green_out[2]}]
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {vga_green_out[3]}]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS33} [get_ports vga_hsync_out]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS33} [get_ports vga_vsync_out]
set_property -dict { PACKAGE_PIN AB7   IOSTANDARD LVCMOS33 } [get_ports { jc[9] }]; #IO_L20P_T3_34 Sch=jc_p[4]
set_property -dict { PACKAGE_PIN AB6   IOSTANDARD LVCMOS33 } [get_ports { jc[10] }]; #IO_L20N_T3_34 Sch=jc_n[4]


## XADC Header
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { xa_p[0] }]; #IO_L3P_T0_DQS_AD1P_15 Sch=xa_p[1]
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { xa_n[0] }]; #IO_L3N_T0_DQS_AD1N_15 Sch=xa_n[1]
#set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports { xa_p[1] }]; #IO_L1P_T0_AD0P_15 Sch=xa_p[2]
#set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { xa_n[1] }]; #IO_L1N_T0_AD0N_15 Sch=xa_n[2]
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { xa_p[2] }]; #IO_L2P_T0_AD8P_15 Sch=xa_p[3]
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { xa_n[2] }]; #IO_L2N_T0_AD8N_15 Sch=xa_n[3]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { xa_p[3] }]; #IO_L5P_T0_AD9P_15 Sch=xa_p[4]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { xa_n[3] }]; #IO_L5N_T0_AD9N_15 Sch=xa_n[4]


## UART
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS33} [get_ports UART_TXD]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports RsRx]


## Ethernet
#set_property -dict { PACKAGE_PIN Y14   IOSTANDARD LVCMOS25 } [get_ports { eth_int_b }]; #IO_L6N_T0_VREF_13 Sch=eth_int_b
set_property -dict { PACKAGE_PIN AA16  IOSTANDARD LVCMOS25 } [get_ports { eth_mdc }]; #IO_L1N_T0_13 Sch=eth_mdc
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS25 } [get_ports { eth_mdio }]; #IO_L1P_T0_13 Sch=eth_mdio
#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS25 } [get_ports { eth_pme_b }]; #IO_L6P_T0_13 Sch=eth_pme_b
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports { eth_reset }]; #IO_25_34 Sch=eth_rst_b
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS25 } [get_ports { eth_rxck }]; #IO_L13P_T2_MRCC_13 Sch=eth_rxck
#set_property -dict { PACKAGE_PIN W10   IOSTANDARD LVCMOS25 } [get_ports { eth_rxctl }]; #IO_L10N_T1_13 Sch=eth_rxctl
set_property -dict { PACKAGE_PIN AB16  IOSTANDARD LVCMOS25 } [get_ports { eth_rxd[0] }]; #IO_L2P_T0_13 Sch=eth_rxd[0]
set_property -dict { PACKAGE_PIN AA15  IOSTANDARD LVCMOS25 } [get_ports { eth_rxd[1] }]; #IO_L4P_T0_13 Sch=eth_rxd[1]
#set_property -dict { PACKAGE_PIN AB15  IOSTANDARD LVCMOS25 } [get_ports { eth_rxd[2] }]; #IO_L4N_T0_13 Sch=eth_rxd[2]
#set_property -dict { PACKAGE_PIN AB11  IOSTANDARD LVCMOS25 } [get_ports { eth_rxd[3] }]; #IO_L7P_T1_13 Sch=eth_rxd[3]
#set_property -dict { PACKAGE_PIN AA14  IOSTANDARD LVCMOS25 } [get_ports { eth_txck }]; #IO_L5N_T0_13 Sch=eth_txck
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS25 } [get_ports { eth_txctl }]; #IO_L10P_T1_13 Sch=eth_txctl
set_property -dict { PACKAGE_PIN Y12   IOSTANDARD LVCMOS25 } [get_ports { eth_txd[0] }]; #IO_L11N_T1_SRCC_13 Sch=eth_txd[0]
set_property -dict { PACKAGE_PIN W12   IOSTANDARD LVCMOS25 } [get_ports { eth_txd[1] }]; #IO_L12N_T1_MRCC_13 Sch=eth_txd[1]
#set_property -dict { PACKAGE_PIN W11   IOSTANDARD LVCMOS25 } [get_ports { eth_txd[2] }]; #IO_L12P_T1_MRCC_13 Sch=eth_txd[2]
#set_property -dict { PACKAGE_PIN Y11   IOSTANDARD LVCMOS25 } [get_ports { eth_txd[3] }]; #IO_L11P_T1_SRCC_13 Sch=eth_txd[3]


## Fan PWM
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS25 } [get_ports { fan_pwm }]; #IO_L14P_T2_SRCC_13 Sch=fan_pwm


## DPTI/DSPI
#set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { prog_clko }]; #IO_L13P_T2_MRCC_14 Sch=prog_clko
#set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { prog_d[0]}]; #IO_L11P_T1_SRCC_14 Sch=prog_d0/sck
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[1] }]; #IO_L19P_T3_A10_D26_14 Sch=prog_d1/mosi
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { prog_d[2] }]; #IO_L22P_T3_A05_D21_14 Sch=prog_d2/miso
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[3]}]; #IO_L18P_T2_A12_D28_14 Sch=prog_d3/ss
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { prog_d[4] }]; #IO_L24N_T3_A00_D16_14 Sch=prog_d[4]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { prog_d[5] }]; #IO_L24P_T3_A01_D17_14 Sch=prog_d[5]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { prog_d[6] }]; #IO_L20P_T3_A08_D24_14 Sch=prog_d[6]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { prog_d[7] }]; #IO_L23N_T3_A02_D18_14 Sch=prog_d[7]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { prog_oen }]; #IO_L16P_T2_CSI_B_14 Sch=prog_oen
#set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports { prog_rdn }]; #IO_L5P_T0_D06_14 Sch=prog_rdn
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { prog_rxen }]; #IO_L21P_T3_DQS_14 Sch=prog_rxen
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { prog_siwun }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=prog_siwun
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { prog_spien }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=prog_spien
#set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { prog_txen }]; #IO_L13N_T2_MRCC_14 Sch=prog_txen
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { prog_wrn }]; #IO_L5N_T0_D07_14 Sch=prog_wrn


## HID port
set_property PACKAGE_PIN W17 [get_ports ps2clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2clk]
set_property PULLUP true [get_ports ps2clk]
set_property PACKAGE_PIN N13 [get_ports ps2data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2data]
set_property PULLUP true [get_ports ps2data]


## QSPI
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports QspiCSn]
set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports {QspiDB[0]}]
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports {QspiDB[1]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports {QspiDB[2]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports {QspiDB[3]}]


## SD card
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports sdClock]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { sd_cd }]; #IO_L20N_T3_A07_D23_14 Sch=sd_cd
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports sdMOSI]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports sdMISO]
#set_property -dict { PACKAGE_PIN T21   IOSTANDARD LVCMOS33 } [get_ports { sd_d[1] }]; #IO_L4P_T0_D04_14 Sch=sd_d[1]
#set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { sd_d[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sd_d[2]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { sd_d[3] }]; #IO_L18N_T2_A11_D27_14 Sch=sd_d[3]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports sdReset]


## I2C
#set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports { scl }]; #IO_L15N_T2_DQS_34 Sch=scl
#set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports { sda }]; #IO_L16N_T2_34 Sch=sda


## Voltage Adjust
#set_property -dict { PACKAGE_PIN AA13  IOSTANDARD LVCMOS25 } [get_ports { set_vadj[0] }]; #IO_L3P_T0_DQS_13 Sch=set_vadj[0]
#set_property -dict { PACKAGE_PIN AB17  IOSTANDARD LVCMOS25 } [get_ports { set_vadj[1] }]; #IO_L2N_T0_13 Sch=set_vadj[1]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS25 } [get_ports { vadj_en }]; #IO_L13N_T2_MRCC_13 Sch=vadj_en


## FMC
#set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk0_m2c_n }]; #IO_L12N_T1_MRCC_15 Sch=fmc_clk0_m2c_n
#set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk0_m2c_p }]; #IO_L12P_T1_MRCC_15 Sch=fmc_clk0_m2c_p
#set_property -dict { PACKAGE_PIN C19   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk1_m2c_n }]; #IO_L13N_T2_MRCC_16 Sch=fmc_clk1_m2c_n
#set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVCMOS12 } [get_ports { fmc_clk1_m2c_p }]; #IO_L13P_T2_MRCC_16 Sch=fmc_clk1_m2c_p

# For Addr1, on J1 1-35 odd pins, POD 1
#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[0]}]
#set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[1]}]
#set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[2]}]
#set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[3]}]
#set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[4]}]
#set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[5]}]
#set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[6]}]
#set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[7]}]
#set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[8]}]
#set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[9]}]
#set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[10]}]
#set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[11]}]
#set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[12]}]
#set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[13]}]
#set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[14]}]
#set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS12} [get_ports {addr_o_dbg[15]}]

#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la00_cc_p }]; #IO_L13P_T2_MRCC_15 Sch=fmc_la00_cc_p
#set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la00_cc_n }]; #IO_L13N_T2_MRCC_15 Sch=fmc_la00_cc_n
#set_property -dict { PACKAGE_PIN J20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la01_cc_p }]; #IO_L11P_T1_SRCC_15 Sch=fmc_la01_cc_p
#set_property -dict { PACKAGE_PIN J21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la01_cc_n }]; #IO_L11N_T1_SRCC_15 Sch=fmc_la01_cc_n
#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[02] }]; #IO_L16P_T2_A28_15 Sch=fmc_la_p[02]
#set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[02] }]; #IO_L16N_T2_A27_15 Sch=fmc_la_n[02]
#set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[03] }]; #IO_L17P_T2_A26_15 Sch=fmc_la_p[03]
#set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[03] }]; #IO_L17N_T2_A25_15 Sch=fmc_la_n[03]
#set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[04] }]; #IO_L18P_T2_A24_15 Sch=fmc_la_p[04]
#set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[04] }]; #IO_L18N_T2_A23_15 Sch=fmc_la_n[04]
#set_property -dict { PACKAGE_PIN M21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[05] }]; #IO_L10P_T1_AD11P_15 Sch=fmc_la_p[05]
#set_property -dict { PACKAGE_PIN L21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[05] }]; #IO_L10N_T1_AD11N_15 Sch=fmc_la_n[05]
#set_property -dict { PACKAGE_PIN N22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[06] }]; #IO_L15P_T2_DQS_15 Sch=fmc_la_p[06]
#set_property -dict { PACKAGE_PIN M22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[06] }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=fmc_la_n[06]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[07] }]; #IO_L20P_T3_A20_15 Sch=fmc_la_p[07]
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[07] }]; #IO_L20N_T3_A19_15 Sch=fmc_la_n[07]

# 8-bits of CPU state on J1 connector.  Low bits on odd pins, high bits on even pins.    Low bits POD 4  8-11, High bits POD 4 12-15
#set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS12} [get_ports {cpu_state[0]}]
#set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS12} [get_ports {cpu_state[1]}]
#set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS12} [get_ports {cpu_state[2]}]
#set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS12} [get_ports {cpu_state[3]}]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS12} [get_ports {cpu_state[4]}]
#set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS12} [get_ports {cpu_state[5]}]
#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS12} [get_ports {cpu_state[6]}]
#set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS12} [get_ports {cpu_state[7]}]

# For Addr2, on J1, pins 2-36 even, POD 2
#set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[0]}]
#set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[1]}]
#set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[2]}]
#set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[3]}]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[4]}]
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[5]}]
#set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[6]}]
#set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[7]}]
#set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[8]}]
#set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[9]}]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[10]}]
#set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[11]}]
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[12]}]
#set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[13]}]
#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[14]}]
#set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS12} [get_ports {addr_i_dbg[15]}]

#set_property -dict { PACKAGE_PIN K21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[10] }]; #IO_L9P_T1_DQS_AD3P_15 Sch=fmc_la_p[10]
#set_property -dict { PACKAGE_PIN K22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[10] }]; #IO_L9N_T1_DQS_AD3N_15 Sch=fmc_la_n[10]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[11] }]; #IO_L22P_T3_A17_15 Sch=fmc_la_p[11]
#set_property -dict { PACKAGE_PIN L15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[11] }]; #IO_L22N_T3_A16_15 Sch=fmc_la_n[11]
#set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[12] }]; #IO_L14P_T2_SRCC_15 Sch=fmc_la_p[12]
#set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[12] }]; #IO_L14N_T2_SRCC_15 Sch=fmc_la_n[12]
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[13] }]; #IO_L21P_T3_DQS_15 Sch=fmc_la_p[13]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[13] }]; #IO_L21N_T3_DQS_A18_15 Sch=fmc_la_n[13]
#set_property -dict { PACKAGE_PIN J22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[14] }]; #IO_L7P_T1_AD2P_15 Sch=fmc_la_p[14]
#set_property -dict { PACKAGE_PIN H22   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[14] }]; #IO_L7N_T1_AD2N_15 Sch=fmc_la_n[14]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[15] }]; #IO_L23P_T3_FOE_B_15 Sch=fmc_la_p[15]
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[15] }]; #IO_L23N_T3_FWE_B_15 Sch=fmc_la_n[15]
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[16] }]; #IO_L4P_T0_15 Sch=fmc_la_p[16]
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[16] }]; #IO_L4N_T0_15 Sch=fmc_la_n[16]
#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la17_cc_p }]; #IO_L11P_T1_SRCC_16 Sch=fmc_la17_cc_p
#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la17_cc_n }]; #IO_L11N_T1_SRCC_16 Sch=fmc_la17_cc_n

#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la18_cc_p }]; #IO_L12P_T1_MRCC_16 Sch=fmc_la18_cc_p
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la18_cc_n }]; #IO_L12N_T1_MRCC_16 Sch=fmc_la18_cc_n
#set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[19] }]; #IO_L17P_T2_16 Sch=fmc_la_p[19]
#set_property -dict { PACKAGE_PIN A19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[19] }]; #IO_L17N_T2_16 Sch=fmc_la_n[19]

# shadow read data - J20 odd pinds - POD 3, bits 0-7
#set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS12} [get_ports {addr_read[0]}]
#set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS12} [get_ports {addr_read[1]}]
#set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS12} [get_ports {addr_read[2]}]
#set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS12} [get_ports {addr_read[3]}]
#set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS12} [get_ports {addr_read[4]}]
#set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS12} [get_ports {addr_read[5]}]
#set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS12} [get_ports {addr_read[6]}]
#set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS12} [get_ports {addr_read[7]}]

#set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[20] }]; #IO_L18P_T2_16 Sch=fmc_la_p[20]
#set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[20] }]; #IO_L18N_T2_16 Sch=fmc_la_n[20]
#set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[21] }]; #IO_L14P_T2_SRCC_16 Sch=fmc_la_p[21]
#set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[21] }]; #IO_L14N_T2_SRCC_16 Sch=fmc_la_n[21]
#set_property -dict { PACKAGE_PIN E21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[22] }]; #IO_L23P_T3_16 Sch=fmc_la_p[22]
#set_property -dict { PACKAGE_PIN D21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[22] }]; #IO_L23N_T3_16 Sch=fmc_la_n[22]
#set_property -dict { PACKAGE_PIN B21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[23] }]; #IO_L21P_T3_DQS_16 Sch=fmc_la_p[23]
#set_property -dict { PACKAGE_PIN A21   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[23] }]; #IO_L21N_T3_DQS_16 Sch=fmc_la_n[23]

#set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS12} [get_ports {addr_write[0]}]
#set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS12} [get_ports {addr_write[1]}]
#set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS12} [get_ports {addr_write[2]}]
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS12} [get_ports {addr_write[3]}]
#set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS12} [get_ports {addr_write[4]}]
#set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS12} [get_ports {addr_write[5]}]
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS12} [get_ports {addr_write[6]}]
#set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS12} [get_ports {addr_write[7]}]

#set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[24] }]; #IO_L7P_T1_16 Sch=fmc_la_p[24]
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[24] }]; #IO_L7N_T1_16 Sch=fmc_la_n[24]
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[25] }]; #IO_L2P_T0_16 Sch=fmc_la_p[25]
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[25] }]; #IO_L2N_T0_16 Sch=fmc_la_n[25]
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[26] }]; #IO_L15P_T2_DQS_16 Sch=fmc_la_p[26]
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[26] }]; #IO_L15N_T2_DQS_16 Sch=fmc_la_n[26]
#set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[27] }]; #IO_L16P_T2_16 Sch=fmc_la_p[27]
#set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[27] }]; #IO_L16N_T2_16 Sch=fmc_la_n[27]

#set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS12} [get_ports addr_r_dbg]
#set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS12} [get_ports addr_w_dbg]
#set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS12} [get_ports proceed_dbg_out]
#set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS12} [get_ports addr_clk]

#set_property -dict { PACKAGE_PIN C13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[28] }]; #IO_L8P_T1_16 Sch=fmc_la_p[28]
#set_property -dict { PACKAGE_PIN B13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[28] }]; #IO_L8N_T1_16 Sch=fmc_la_n[28]
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[29] }]; #IO_L3P_T0_DQS_16 Sch=fmc_la_p[29]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[29] }]; #IO_L3N_T0_DQS_16 Sch=fmc_la_n[29]

#set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS12} [get_ports {addr_state[0]}]
#set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS12} [get_ports {addr_state[1]}]
#set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS12} [get_ports {addr_state[2]}]
#set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS12} [get_ports {addr_state[3]}]

#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[30] }]; #IO_L10P_T1_16 Sch=fmc_la_p[30]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[30] }]; #IO_L10N_T1_16 Sch=fmc_la_n[30]
#set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[31] }]; #IO_L4P_T0_16 Sch=fmc_la_p[31]
#set_property -dict { PACKAGE_PIN E14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[31] }]; #IO_L4N_T0_16 Sch=fmc_la_n[31]

#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[32] }]; #IO_L9P_T1_DQS_16 Sch=fmc_la_p[32]
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[32] }]; #IO_L9N_T1_DQS_16 Sch=fmc_la_n[32]
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_p[33] }]; #IO_L1P_T0_16 Sch=fmc_la_p[33]
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS12 } [get_ports { fmc_la_n[33] }]; #IO_L1N_T0_16 Sch=fmc_la_n[33]




connect_debug_port u_ila_0/probe17 [get_nets [list {machine0/cpuport/cpuport_ddr[0]} {machine0/cpuport/cpuport_ddr[1]} {machine0/cpuport/cpuport_ddr[2]} {machine0/cpuport/cpuport_ddr[3]} {machine0/cpuport/cpuport_ddr[4]} {machine0/cpuport/cpuport_ddr[5]} {machine0/cpuport/cpuport_ddr[6]} {machine0/cpuport/cpuport_ddr[7]}]]
connect_debug_port u_ila_0/probe18 [get_nets [list {machine0/cpuport/cpuport_value[0]} {machine0/cpuport/cpuport_value[1]} {machine0/cpuport/cpuport_value[2]} {machine0/cpuport/cpuport_value[3]} {machine0/cpuport/cpuport_value[4]} {machine0/cpuport/cpuport_value[5]} {machine0/cpuport/cpuport_value[6]} {machine0/cpuport/cpuport_value[7]}]]
connect_debug_port u_ila_0/probe19 [get_nets [list {machine0/cpuport/data_o[0]} {machine0/cpuport/data_o[1]} {machine0/cpuport/data_o[2]} {machine0/cpuport/data_o[3]} {machine0/cpuport/data_o[4]} {machine0/cpuport/data_o[5]} {machine0/cpuport/data_o[6]} {machine0/cpuport/data_o[7]}]]
connect_debug_port u_ila_0/probe69 [get_nets [list machine0/arbiter0/cpu_ready]]
connect_debug_port u_ila_0/probe72 [get_nets [list machine0/cpuport/cs]]
connect_debug_port u_ila_0/probe106 [get_nets [list machine0/phi_step_toggle]]



connect_debug_port u_ila_0/probe0 [get_nets [list {machine0/monitor_address_resolver0/short_address[0]} {machine0/monitor_address_resolver0/short_address[1]} {machine0/monitor_address_resolver0/short_address[2]} {machine0/monitor_address_resolver0/short_address[3]} {machine0/monitor_address_resolver0/short_address[4]} {machine0/monitor_address_resolver0/short_address[5]} {machine0/monitor_address_resolver0/short_address[6]} {machine0/monitor_address_resolver0/short_address[7]} {machine0/monitor_address_resolver0/short_address[8]} {machine0/monitor_address_resolver0/short_address[9]} {machine0/monitor_address_resolver0/short_address[10]} {machine0/monitor_address_resolver0/short_address[11]} {machine0/monitor_address_resolver0/short_address[12]} {machine0/monitor_address_resolver0/short_address[13]} {machine0/monitor_address_resolver0/short_address[14]} {machine0/monitor_address_resolver0/short_address[15]} {machine0/monitor_address_resolver0/short_address[16]} {machine0/monitor_address_resolver0/short_address[17]} {machine0/monitor_address_resolver0/short_address[18]} {machine0/monitor_address_resolver0/short_address[19]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {machine0/cpu_address_resolver0/cpuport_ddr[0]} {machine0/cpu_address_resolver0/cpuport_ddr[1]} {machine0/cpu_address_resolver0/cpuport_ddr[2]} {machine0/cpu_address_resolver0/cpuport_ddr[3]} {machine0/cpu_address_resolver0/cpuport_ddr[4]} {machine0/cpu_address_resolver0/cpuport_ddr[5]} {machine0/cpu_address_resolver0/cpuport_ddr[6]} {machine0/cpu_address_resolver0/cpuport_ddr[7]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {machine0/cpu_address_resolver0/cpuport_value[0]} {machine0/cpu_address_resolver0/cpuport_value[1]} {machine0/cpu_address_resolver0/cpuport_value[2]} {machine0/cpu_address_resolver0/cpuport_value[3]} {machine0/cpu_address_resolver0/cpuport_value[4]} {machine0/cpu_address_resolver0/cpuport_value[5]} {machine0/cpu_address_resolver0/cpuport_value[6]} {machine0/cpu_address_resolver0/cpuport_value[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {machine0/cpu_address_resolver0/resolved_address[0]} {machine0/cpu_address_resolver0/resolved_address[1]} {machine0/cpu_address_resolver0/resolved_address[2]} {machine0/cpu_address_resolver0/resolved_address[3]} {machine0/cpu_address_resolver0/resolved_address[4]} {machine0/cpu_address_resolver0/resolved_address[5]} {machine0/cpu_address_resolver0/resolved_address[6]} {machine0/cpu_address_resolver0/resolved_address[7]} {machine0/cpu_address_resolver0/resolved_address[8]} {machine0/cpu_address_resolver0/resolved_address[9]} {machine0/cpu_address_resolver0/resolved_address[10]} {machine0/cpu_address_resolver0/resolved_address[11]} {machine0/cpu_address_resolver0/resolved_address[12]} {machine0/cpu_address_resolver0/resolved_address[13]} {machine0/cpu_address_resolver0/resolved_address[14]} {machine0/cpu_address_resolver0/resolved_address[15]} {machine0/cpu_address_resolver0/resolved_address[16]} {machine0/cpu_address_resolver0/resolved_address[17]} {machine0/cpu_address_resolver0/resolved_address[18]} {machine0/cpu_address_resolver0/resolved_address[19]}]]
connect_debug_port u_ila_0/probe49 [get_nets [list machine0/monitor_address_resolver0/ext_sel_resolved]]
connect_debug_port u_ila_0/probe50 [get_nets [list machine0/cpu_address_resolver0/ext_sel_resolved]]
connect_debug_port u_ila_0/probe56 [get_nets [list machine0/cpu_address_resolver0/io_sel_resolved]]
connect_debug_port u_ila_0/probe62 [get_nets [list machine0/monitor_address_resolver0/map_en]]




connect_debug_port u_ila_0/probe0 [get_nets [list {machine0/arbiter0/bus_master_next[0]} {machine0/arbiter0/bus_master_next[1]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {machine0/bus0/system_address_next[0]} {machine0/bus0/system_address_next[1]} {machine0/bus0/system_address_next[2]} {machine0/bus0/system_address_next[3]} {machine0/bus0/system_address_next[4]} {machine0/bus0/system_address_next[5]} {machine0/bus0/system_address_next[6]} {machine0/bus0/system_address_next[7]} {machine0/bus0/system_address_next[8]} {machine0/bus0/system_address_next[9]} {machine0/bus0/system_address_next[10]} {machine0/bus0/system_address_next[11]} {machine0/bus0/system_address_next[12]} {machine0/bus0/system_address_next[13]} {machine0/bus0/system_address_next[14]} {machine0/bus0/system_address_next[15]} {machine0/bus0/system_address_next[16]} {machine0/bus0/system_address_next[17]} {machine0/bus0/system_address_next[18]} {machine0/bus0/system_address_next[19]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list {machine0/bus0/system_wdata_next[0]} {machine0/bus0/system_wdata_next[1]} {machine0/bus0/system_wdata_next[2]} {machine0/bus0/system_wdata_next[3]} {machine0/bus0/system_wdata_next[4]} {machine0/bus0/system_wdata_next[5]} {machine0/bus0/system_wdata_next[6]} {machine0/bus0/system_wdata_next[7]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list {machine0/cpu0/cpu_core/ir_next_mux/ir_next[0]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[1]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[2]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[3]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[4]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[5]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[6]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[7]}]]
connect_debug_port u_ila_0/probe17 [get_nets [list {machine0/cpu0/cpu_core/ir_next_mux/ir[0]} {machine0/cpu0/cpu_core/ir_next_mux/ir[1]} {machine0/cpu0/cpu_core/ir_next_mux/ir[2]} {machine0/cpu0/cpu_core/ir_next_mux/ir[3]} {machine0/cpu0/cpu_core/ir_next_mux/ir[4]} {machine0/cpu0/cpu_core/ir_next_mux/ir[5]} {machine0/cpu0/cpu_core/ir_next_mux/ir[6]} {machine0/cpu0/cpu_core/ir_next_mux/ir[7]}]]
connect_debug_port u_ila_0/probe18 [get_nets [list {machine0/cpu0/cpu_core/pc[0]} {machine0/cpu0/cpu_core/pc[1]} {machine0/cpu0/cpu_core/pc[2]} {machine0/cpu0/cpu_core/pc[3]} {machine0/cpu0/cpu_core/pc[4]} {machine0/cpu0/cpu_core/pc[5]} {machine0/cpu0/cpu_core/pc[6]} {machine0/cpu0/cpu_core/pc[7]} {machine0/cpu0/cpu_core/pc[8]} {machine0/cpu0/cpu_core/pc[9]} {machine0/cpu0/cpu_core/pc[10]} {machine0/cpu0/cpu_core/pc[11]} {machine0/cpu0/cpu_core/pc[12]} {machine0/cpu0/cpu_core/pc[13]} {machine0/cpu0/cpu_core/pc[14]} {machine0/cpu0/cpu_core/pc[15]}]]
connect_debug_port u_ila_0/probe20 [get_nets [list {machine0/cpu0/cpu_core/reg_a[0]} {machine0/cpu0/cpu_core/reg_a[1]} {machine0/cpu0/cpu_core/reg_a[2]} {machine0/cpu0/cpu_core/reg_a[3]} {machine0/cpu0/cpu_core/reg_a[4]} {machine0/cpu0/cpu_core/reg_a[5]} {machine0/cpu0/cpu_core/reg_a[6]} {machine0/cpu0/cpu_core/reg_a[7]}]]
connect_debug_port u_ila_0/probe21 [get_nets [list {machine0/cpu0/cpu_core/reg_b[0]} {machine0/cpu0/cpu_core/reg_b[1]} {machine0/cpu0/cpu_core/reg_b[2]} {machine0/cpu0/cpu_core/reg_b[3]} {machine0/cpu0/cpu_core/reg_b[4]} {machine0/cpu0/cpu_core/reg_b[5]} {machine0/cpu0/cpu_core/reg_b[6]} {machine0/cpu0/cpu_core/reg_b[7]}]]
connect_debug_port u_ila_0/probe22 [get_nets [list {machine0/cpu0/cpu_core/reg_p[0]} {machine0/cpu0/cpu_core/reg_p[1]} {machine0/cpu0/cpu_core/reg_p[2]} {machine0/cpu0/cpu_core/reg_p[3]} {machine0/cpu0/cpu_core/reg_p[4]} {machine0/cpu0/cpu_core/reg_p[5]} {machine0/cpu0/cpu_core/reg_p[6]} {machine0/cpu0/cpu_core/reg_p[7]}]]
connect_debug_port u_ila_0/probe23 [get_nets [list {machine0/cpu0/cpu_core/reg_x[0]} {machine0/cpu0/cpu_core/reg_x[1]} {machine0/cpu0/cpu_core/reg_x[2]} {machine0/cpu0/cpu_core/reg_x[3]} {machine0/cpu0/cpu_core/reg_x[4]} {machine0/cpu0/cpu_core/reg_x[5]} {machine0/cpu0/cpu_core/reg_x[6]} {machine0/cpu0/cpu_core/reg_x[7]}]]
connect_debug_port u_ila_0/probe24 [get_nets [list {machine0/cpu0/cpu_core/reg_y[0]} {machine0/cpu0/cpu_core/reg_y[1]} {machine0/cpu0/cpu_core/reg_y[2]} {machine0/cpu0/cpu_core/reg_y[3]} {machine0/cpu0/cpu_core/reg_y[4]} {machine0/cpu0/cpu_core/reg_y[5]} {machine0/cpu0/cpu_core/reg_y[6]} {machine0/cpu0/cpu_core/reg_y[7]}]]
connect_debug_port u_ila_0/probe25 [get_nets [list {machine0/cpu0/cpu_core/reg_z[0]} {machine0/cpu0/cpu_core/reg_z[1]} {machine0/cpu0/cpu_core/reg_z[2]} {machine0/cpu0/cpu_core/reg_z[3]} {machine0/cpu0/cpu_core/reg_z[4]} {machine0/cpu0/cpu_core/reg_z[5]} {machine0/cpu0/cpu_core/reg_z[6]} {machine0/cpu0/cpu_core/reg_z[7]}]]
connect_debug_port u_ila_0/probe27 [get_nets [list {machine0/cpu0/cpu_core/sp_next[0]} {machine0/cpu0/cpu_core/sp_next[1]} {machine0/cpu0/cpu_core/sp_next[2]} {machine0/cpu0/cpu_core/sp_next[3]} {machine0/cpu0/cpu_core/sp_next[4]} {machine0/cpu0/cpu_core/sp_next[5]} {machine0/cpu0/cpu_core/sp_next[6]} {machine0/cpu0/cpu_core/sp_next[7]} {machine0/cpu0/cpu_core/sp_next[8]} {machine0/cpu0/cpu_core/sp_next[9]} {machine0/cpu0/cpu_core/sp_next[10]} {machine0/cpu0/cpu_core/sp_next[11]} {machine0/cpu0/cpu_core/sp_next[12]} {machine0/cpu0/cpu_core/sp_next[13]} {machine0/cpu0/cpu_core/sp_next[14]} {machine0/cpu0/cpu_core/sp_next[15]}]]
connect_debug_port u_ila_0/probe28 [get_nets [list {machine0/cpu0/cpu_core/t[0]} {machine0/cpu0/cpu_core/t[1]} {machine0/cpu0/cpu_core/t[2]}]]
connect_debug_port u_ila_0/probe30 [get_nets [list {machine0/cpu0/mapper/current_offset[8]} {machine0/cpu0/mapper/current_offset[9]} {machine0/cpu0/mapper/current_offset[10]} {machine0/cpu0/mapper/current_offset[11]} {machine0/cpu0/mapper/current_offset[12]} {machine0/cpu0/mapper/current_offset[13]} {machine0/cpu0/mapper/current_offset[14]} {machine0/cpu0/mapper/current_offset[15]} {machine0/cpu0/mapper/current_offset[16]} {machine0/cpu0/mapper/current_offset[17]} {machine0/cpu0/mapper/current_offset[18]} {machine0/cpu0/mapper/current_offset[19]}]]
connect_debug_port u_ila_0/probe31 [get_nets [list {machine0/cpu0/mapper/map_enable[2][0]} {machine0/cpu0/mapper/map_enable[2][1]} {machine0/cpu0/mapper/map_enable[2][2]} {machine0/cpu0/mapper/map_enable[2][3]}]]
connect_debug_port u_ila_0/probe32 [get_nets [list {machine0/cpu0/mapper/map_enable[0][0]} {machine0/cpu0/mapper/map_enable[0][1]} {machine0/cpu0/mapper/map_enable[0][2]} {machine0/cpu0/mapper/map_enable[0][3]}]]
connect_debug_port u_ila_0/probe33 [get_nets [list {machine0/cpu0/mapper/map_enable[1][0]} {machine0/cpu0/mapper/map_enable[1][1]} {machine0/cpu0/mapper/map_enable[1][2]} {machine0/cpu0/mapper/map_enable[1][3]}]]
connect_debug_port u_ila_0/probe34 [get_nets [list {machine0/cpu0/mapper/map_enable[3][0]} {machine0/cpu0/mapper/map_enable[3][1]} {machine0/cpu0/mapper/map_enable[3][2]} {machine0/cpu0/mapper/map_enable[3][3]}]]
connect_debug_port u_ila_0/probe35 [get_nets [list {machine0/cpu0/mapper/map_offset[0]__0[8]} {machine0/cpu0/mapper/map_offset[0]__0[9]} {machine0/cpu0/mapper/map_offset[0]__0[10]} {machine0/cpu0/mapper/map_offset[0]__0[11]} {machine0/cpu0/mapper/map_offset[0]__0[12]} {machine0/cpu0/mapper/map_offset[0]__0[13]} {machine0/cpu0/mapper/map_offset[0]__0[14]} {machine0/cpu0/mapper/map_offset[0]__0[15]} {machine0/cpu0/mapper/map_offset[0]__0[16]} {machine0/cpu0/mapper/map_offset[0]__0[17]} {machine0/cpu0/mapper/map_offset[0]__0[18]} {machine0/cpu0/mapper/map_offset[0]__0[19]}]]
connect_debug_port u_ila_0/probe36 [get_nets [list {machine0/cpu0/mapper/map_offset[1]__0[8]} {machine0/cpu0/mapper/map_offset[1]__0[9]} {machine0/cpu0/mapper/map_offset[1]__0[10]} {machine0/cpu0/mapper/map_offset[1]__0[11]} {machine0/cpu0/mapper/map_offset[1]__0[12]} {machine0/cpu0/mapper/map_offset[1]__0[13]} {machine0/cpu0/mapper/map_offset[1]__0[14]} {machine0/cpu0/mapper/map_offset[1]__0[15]} {machine0/cpu0/mapper/map_offset[1]__0[16]} {machine0/cpu0/mapper/map_offset[1]__0[17]} {machine0/cpu0/mapper/map_offset[1]__0[18]} {machine0/cpu0/mapper/map_offset[1]__0[19]}]]
connect_debug_port u_ila_0/probe37 [get_nets [list {machine0/cpu0/mapper/map_offset[2]__0[8]} {machine0/cpu0/mapper/map_offset[2]__0[9]} {machine0/cpu0/mapper/map_offset[2]__0[10]} {machine0/cpu0/mapper/map_offset[2]__0[11]} {machine0/cpu0/mapper/map_offset[2]__0[12]} {machine0/cpu0/mapper/map_offset[2]__0[13]} {machine0/cpu0/mapper/map_offset[2]__0[14]} {machine0/cpu0/mapper/map_offset[2]__0[15]} {machine0/cpu0/mapper/map_offset[2]__0[16]} {machine0/cpu0/mapper/map_offset[2]__0[17]} {machine0/cpu0/mapper/map_offset[2]__0[18]} {machine0/cpu0/mapper/map_offset[2]__0[19]}]]
connect_debug_port u_ila_0/probe38 [get_nets [list {machine0/cpu0/mapper/map_offset[3]__0[8]} {machine0/cpu0/mapper/map_offset[3]__0[9]} {machine0/cpu0/mapper/map_offset[3]__0[10]} {machine0/cpu0/mapper/map_offset[3]__0[11]} {machine0/cpu0/mapper/map_offset[3]__0[12]} {machine0/cpu0/mapper/map_offset[3]__0[13]} {machine0/cpu0/mapper/map_offset[3]__0[14]} {machine0/cpu0/mapper/map_offset[3]__0[15]} {machine0/cpu0/mapper/map_offset[3]__0[16]} {machine0/cpu0/mapper/map_offset[3]__0[17]} {machine0/cpu0/mapper/map_offset[3]__0[18]} {machine0/cpu0/mapper/map_offset[3]__0[19]}]]
connect_debug_port u_ila_0/probe39 [get_nets [list {machine0/cpu0/mapper/mapper_address[8]} {machine0/cpu0/mapper/mapper_address[9]} {machine0/cpu0/mapper/mapper_address[10]} {machine0/cpu0/mapper/mapper_address[11]} {machine0/cpu0/mapper/mapper_address[12]} {machine0/cpu0/mapper/mapper_address[13]} {machine0/cpu0/mapper/mapper_address[14]} {machine0/cpu0/mapper/mapper_address[15]} {machine0/cpu0/mapper/mapper_address[16]} {machine0/cpu0/mapper/mapper_address[17]} {machine0/cpu0/mapper/mapper_address[18]} {machine0/cpu0/mapper/mapper_address[19]}]]
connect_debug_port u_ila_0/probe40 [get_nets [list {machine0/cpu0/mapper_fsm/map_state[0]} {machine0/cpu0/mapper_fsm/map_state[1]} {machine0/cpu0/mapper_fsm/map_state[2]}]]
connect_debug_port u_ila_0/probe41 [get_nets [list {machine0/cpu0/mapper_fsm/map_state_next[0]} {machine0/cpu0/mapper_fsm/map_state_next[1]} {machine0/cpu0/mapper_fsm/map_state_next[2]}]]
connect_debug_port u_ila_0/probe42 [get_nets [list {machine0/cpu0/address[0]} {machine0/cpu0/address[1]} {machine0/cpu0/address[2]} {machine0/cpu0/address[3]} {machine0/cpu0/address[4]} {machine0/cpu0/address[5]} {machine0/cpu0/address[6]} {machine0/cpu0/address[7]} {machine0/cpu0/address[8]} {machine0/cpu0/address[9]} {machine0/cpu0/address[10]} {machine0/cpu0/address[11]} {machine0/cpu0/address[12]} {machine0/cpu0/address[13]} {machine0/cpu0/address[14]} {machine0/cpu0/address[15]} {machine0/cpu0/address[16]} {machine0/cpu0/address[17]} {machine0/cpu0/address[18]} {machine0/cpu0/address[19]}]]
connect_debug_port u_ila_0/probe43 [get_nets [list {machine0/cpu0/address_next[0]} {machine0/cpu0/address_next[1]} {machine0/cpu0/address_next[2]} {machine0/cpu0/address_next[3]} {machine0/cpu0/address_next[4]} {machine0/cpu0/address_next[5]} {machine0/cpu0/address_next[6]} {machine0/cpu0/address_next[7]} {machine0/cpu0/address_next[8]} {machine0/cpu0/address_next[9]} {machine0/cpu0/address_next[10]} {machine0/cpu0/address_next[11]} {machine0/cpu0/address_next[12]} {machine0/cpu0/address_next[13]} {machine0/cpu0/address_next[14]} {machine0/cpu0/address_next[15]} {machine0/cpu0/address_next[16]} {machine0/cpu0/address_next[17]} {machine0/cpu0/address_next[18]} {machine0/cpu0/address_next[19]}]]
connect_debug_port u_ila_0/probe45 [get_nets [list {machine0/cpu0/data_o_next[0]} {machine0/cpu0/data_o_next[1]} {machine0/cpu0/data_o_next[2]} {machine0/cpu0/data_o_next[3]} {machine0/cpu0/data_o_next[4]} {machine0/cpu0/data_o_next[5]} {machine0/cpu0/data_o_next[6]} {machine0/cpu0/data_o_next[7]}]]
connect_debug_port u_ila_0/probe47 [get_nets [list {machine0/cpu0/data_o[0]} {machine0/cpu0/data_o[1]} {machine0/cpu0/data_o[2]} {machine0/cpu0/data_o[3]} {machine0/cpu0/data_o[4]} {machine0/cpu0/data_o[5]} {machine0/cpu0/data_o[6]} {machine0/cpu0/data_o[7]}]]
connect_debug_port u_ila_0/probe49 [get_nets [list {machine0/hypervisor/hyper_data_o[0]} {machine0/hypervisor/hyper_data_o[1]} {machine0/hypervisor/hyper_data_o[2]} {machine0/hypervisor/hyper_data_o[3]} {machine0/hypervisor/hyper_data_o[4]} {machine0/hypervisor/hyper_data_o[5]} {machine0/hypervisor/hyper_data_o[6]} {machine0/hypervisor/hyper_data_o[7]}]]
connect_debug_port u_ila_0/probe50 [get_nets [list {machine0/hypervisor/iomode[0]} {machine0/hypervisor/iomode[1]}]]
connect_debug_port u_ila_0/probe52 [get_nets [list {machine0/hypervisor/monitor_char[0]} {machine0/hypervisor/monitor_char[1]} {machine0/hypervisor/monitor_char[2]} {machine0/hypervisor/monitor_char[3]} {machine0/hypervisor/monitor_char[4]} {machine0/hypervisor/monitor_char[5]} {machine0/hypervisor/monitor_char[6]} {machine0/hypervisor/monitor_char[7]}]]
connect_debug_port u_ila_0/probe54 [get_nets [list machine0/arbiter0/arb_cpu_ready]]
connect_debug_port u_ila_0/probe55 [get_nets [list machine0/arb_cpu_ready]]
connect_debug_port u_ila_0/probe56 [get_nets [list machine0/arbiter0/bus_memory_access_io_next]]
connect_debug_port u_ila_0/probe59 [get_nets [list machine0/arbiter0/cpu_memory_access_io_next]]
connect_debug_port u_ila_0/probe60 [get_nets [list machine0/arbiter0/cpu_memory_access_read_next]]
connect_debug_port u_ila_0/probe61 [get_nets [list machine0/hypervisor/cpu_write]]
connect_debug_port u_ila_0/probe66 [get_nets [list machine0/arbiter0/dmagic_ready]]
connect_debug_port u_ila_0/probe68 [get_nets [list machine0/cpu0/hyper_mode]]
connect_debug_port u_ila_0/probe69 [get_nets [list machine0/hypervisor/hyper_mode]]
connect_debug_port u_ila_0/probe74 [get_nets [list machine0/cpu0/irq]]
connect_debug_port u_ila_0/probe76 [get_nets [list machine0/cpu0/load_a]]
connect_debug_port u_ila_0/probe77 [get_nets [list machine0/hypervisor/load_hyper_upgraded]]
connect_debug_port u_ila_0/probe78 [get_nets [list machine0/cpu0/mapper_fsm/load_map_sel]]
connect_debug_port u_ila_0/probe79 [get_nets [list machine0/cpu0/mapper/load_map_sel]]
connect_debug_port u_ila_0/probe80 [get_nets [list machine0/cpu0/load_x]]
connect_debug_port u_ila_0/probe81 [get_nets [list machine0/cpu0/load_y]]
connect_debug_port u_ila_0/probe82 [get_nets [list machine0/cpu0/load_z]]
connect_debug_port u_ila_0/probe83 [get_nets [list machine0/cpu0/map_disable_i]]
connect_debug_port u_ila_0/probe84 [get_nets [list machine0/cpu0/mapper/map_en]]
connect_debug_port u_ila_0/probe85 [get_nets [list machine0/cpu0/map_enable_i]]
connect_debug_port u_ila_0/probe86 [get_nets [list machine0/cpu0/map_next]]
connect_debug_port u_ila_0/probe87 [get_nets [list machine0/cpu0/map_out]]
connect_debug_port u_ila_0/probe88 [get_nets [list machine0/hypervisor/monitor_char_busy]]
connect_debug_port u_ila_0/probe90 [get_nets [list machine0/cpu0/nmi]]
connect_debug_port u_ila_0/probe91 [get_nets [list machine0/hypervisor/ready]]
connect_debug_port u_ila_0/probe92 [get_nets [list machine0/cpu0/ready]]
connect_debug_port u_ila_0/probe93 [get_nets [list machine0/cpu0/reset]]
connect_debug_port u_ila_0/probe94 [get_nets [list machine0/cpu_address_resolver0/rom_at_8000]]
connect_debug_port u_ila_0/probe95 [get_nets [list machine0/cpu_address_resolver0/rom_at_a000]]
connect_debug_port u_ila_0/probe96 [get_nets [list machine0/cpu_address_resolver0/rom_at_c000]]
connect_debug_port u_ila_0/probe97 [get_nets [list machine0/cpu_address_resolver0/rom_at_e000]]
connect_debug_port u_ila_0/probe99 [get_nets [list machine0/cpu0/sync]]
connect_debug_port u_ila_0/probe101 [get_nets [list machine0/bus0/system_read_next]]
connect_debug_port u_ila_0/probe103 [get_nets [list machine0/bus0/system_write_next]]
connect_debug_port u_ila_0/probe106 [get_nets [list machine0/cpu0/write_next]]
connect_debug_port u_ila_0/probe107 [get_nets [list machine0/cpu0/write_out]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list dotclock1/cpuclock]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {machine0/bus0/bus_device[0]} {machine0/bus0/bus_device[1]} {machine0/bus0/bus_device[2]} {machine0/bus0/bus_device[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {machine0/bus0/bus_read_data[0]} {machine0/bus0/bus_read_data[1]} {machine0/bus0/bus_read_data[2]} {machine0/bus0/bus_read_data[3]} {machine0/bus0/bus_read_data[4]} {machine0/bus0/bus_read_data[5]} {machine0/bus0/bus_read_data[6]} {machine0/bus0/bus_read_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {machine0/bus0/cpuport_rdata[0]} {machine0/bus0/cpuport_rdata[1]} {machine0/bus0/cpuport_rdata[2]} {machine0/bus0/cpuport_rdata[3]} {machine0/bus0/cpuport_rdata[4]} {machine0/bus0/cpuport_rdata[5]} {machine0/bus0/cpuport_rdata[6]} {machine0/bus0/cpuport_rdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {machine0/bus0/kickstart_rdata[0]} {machine0/bus0/kickstart_rdata[1]} {machine0/bus0/kickstart_rdata[2]} {machine0/bus0/kickstart_rdata[3]} {machine0/bus0/kickstart_rdata[4]} {machine0/bus0/kickstart_rdata[5]} {machine0/bus0/kickstart_rdata[6]} {machine0/bus0/kickstart_rdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {machine0/bus0/hypervisor_rdata[0]} {machine0/bus0/hypervisor_rdata[1]} {machine0/bus0/hypervisor_rdata[2]} {machine0/bus0/hypervisor_rdata[3]} {machine0/bus0/hypervisor_rdata[4]} {machine0/bus0/hypervisor_rdata[5]} {machine0/bus0/hypervisor_rdata[6]} {machine0/bus0/hypervisor_rdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {machine0/bus0/shadow_rdata[0]} {machine0/bus0/shadow_rdata[1]} {machine0/bus0/shadow_rdata[2]} {machine0/bus0/shadow_rdata[3]} {machine0/bus0/shadow_rdata[4]} {machine0/bus0/shadow_rdata[5]} {machine0/bus0/shadow_rdata[6]} {machine0/bus0/shadow_rdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 20 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {machine0/bus0/system_address[0]} {machine0/bus0/system_address[1]} {machine0/bus0/system_address[2]} {machine0/bus0/system_address[3]} {machine0/bus0/system_address[4]} {machine0/bus0/system_address[5]} {machine0/bus0/system_address[6]} {machine0/bus0/system_address[7]} {machine0/bus0/system_address[8]} {machine0/bus0/system_address[9]} {machine0/bus0/system_address[10]} {machine0/bus0/system_address[11]} {machine0/bus0/system_address[12]} {machine0/bus0/system_address[13]} {machine0/bus0/system_address[14]} {machine0/bus0/system_address[15]} {machine0/bus0/system_address[16]} {machine0/bus0/system_address[17]} {machine0/bus0/system_address[18]} {machine0/bus0/system_address[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 20 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {machine0/bus0/system_address_next[0]} {machine0/bus0/system_address_next[1]} {machine0/bus0/system_address_next[2]} {machine0/bus0/system_address_next[3]} {machine0/bus0/system_address_next[4]} {machine0/bus0/system_address_next[5]} {machine0/bus0/system_address_next[6]} {machine0/bus0/system_address_next[7]} {machine0/bus0/system_address_next[8]} {machine0/bus0/system_address_next[9]} {machine0/bus0/system_address_next[10]} {machine0/bus0/system_address_next[11]} {machine0/bus0/system_address_next[12]} {machine0/bus0/system_address_next[13]} {machine0/bus0/system_address_next[14]} {machine0/bus0/system_address_next[15]} {machine0/bus0/system_address_next[16]} {machine0/bus0/system_address_next[17]} {machine0/bus0/system_address_next[18]} {machine0/bus0/system_address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {machine0/bus0/system_wdata[0]} {machine0/bus0/system_wdata[1]} {machine0/bus0/system_wdata[2]} {machine0/bus0/system_wdata[3]} {machine0/bus0/system_wdata[4]} {machine0/bus0/system_wdata[5]} {machine0/bus0/system_wdata[6]} {machine0/bus0/system_wdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {machine0/bus0/system_wdata_next[0]} {machine0/bus0/system_wdata_next[1]} {machine0/bus0/system_wdata_next[2]} {machine0/bus0/system_wdata_next[3]} {machine0/bus0/system_wdata_next[4]} {machine0/bus0/system_wdata_next[5]} {machine0/bus0/system_wdata_next[6]} {machine0/bus0/system_wdata_next[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {machine0/bus0/vic_rdata[0]} {machine0/bus0/vic_rdata[1]} {machine0/bus0/vic_rdata[2]} {machine0/bus0/vic_rdata[3]} {machine0/bus0/vic_rdata[4]} {machine0/bus0/vic_rdata[5]} {machine0/bus0/vic_rdata[6]} {machine0/bus0/vic_rdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 2 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {machine0/bus0/viciii_iomode[0]} {machine0/bus0/viciii_iomode[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {machine0/hypervisor/hyper_addr[0]} {machine0/hypervisor/hyper_addr[1]} {machine0/hypervisor/hyper_addr[2]} {machine0/hypervisor/hyper_addr[3]} {machine0/hypervisor/hyper_addr[4]} {machine0/hypervisor/hyper_addr[5]} {machine0/hypervisor/hyper_addr[6]} {machine0/hypervisor/hyper_addr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {machine0/hypervisor/hyper_data_o[0]} {machine0/hypervisor/hyper_data_o[1]} {machine0/hypervisor/hyper_data_o[2]} {machine0/hypervisor/hyper_data_o[3]} {machine0/hypervisor/hyper_data_o[4]} {machine0/hypervisor/hyper_data_o[5]} {machine0/hypervisor/hyper_data_o[6]} {machine0/hypervisor/hyper_data_o[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {machine0/hypervisor/hyper_io_data_i[0]} {machine0/hypervisor/hyper_io_data_i[1]} {machine0/hypervisor/hyper_io_data_i[2]} {machine0/hypervisor/hyper_io_data_i[3]} {machine0/hypervisor/hyper_io_data_i[4]} {machine0/hypervisor/hyper_io_data_i[5]} {machine0/hypervisor/hyper_io_data_i[6]} {machine0/hypervisor/hyper_io_data_i[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 2 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {machine0/hypervisor/iomode[0]} {machine0/hypervisor/iomode[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 2 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {machine0/hypervisor/iomode_set[0]} {machine0/hypervisor/iomode_set[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {machine0/hypervisor/monitor_char[0]} {machine0/hypervisor/monitor_char[1]} {machine0/hypervisor/monitor_char[2]} {machine0/hypervisor/monitor_char[3]} {machine0/hypervisor/monitor_char[4]} {machine0/hypervisor/monitor_char[5]} {machine0/hypervisor/monitor_char[6]} {machine0/hypervisor/monitor_char[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 8 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {machine0/hypervisor/user_mapper_reg[0]} {machine0/hypervisor/user_mapper_reg[1]} {machine0/hypervisor/user_mapper_reg[2]} {machine0/hypervisor/user_mapper_reg[3]} {machine0/hypervisor/user_mapper_reg[4]} {machine0/hypervisor/user_mapper_reg[5]} {machine0/hypervisor/user_mapper_reg[6]} {machine0/hypervisor/user_mapper_reg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 16 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {machine0/cpu0/cpu_core/pc[0]} {machine0/cpu0/cpu_core/pc[1]} {machine0/cpu0/cpu_core/pc[2]} {machine0/cpu0/cpu_core/pc[3]} {machine0/cpu0/cpu_core/pc[4]} {machine0/cpu0/cpu_core/pc[5]} {machine0/cpu0/cpu_core/pc[6]} {machine0/cpu0/cpu_core/pc[7]} {machine0/cpu0/cpu_core/pc[8]} {machine0/cpu0/cpu_core/pc[9]} {machine0/cpu0/cpu_core/pc[10]} {machine0/cpu0/cpu_core/pc[11]} {machine0/cpu0/cpu_core/pc[12]} {machine0/cpu0/cpu_core/pc[13]} {machine0/cpu0/cpu_core/pc[14]} {machine0/cpu0/cpu_core/pc[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 16 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {machine0/cpu0/cpu_core/pc_next[0]} {machine0/cpu0/cpu_core/pc_next[1]} {machine0/cpu0/cpu_core/pc_next[2]} {machine0/cpu0/cpu_core/pc_next[3]} {machine0/cpu0/cpu_core/pc_next[4]} {machine0/cpu0/cpu_core/pc_next[5]} {machine0/cpu0/cpu_core/pc_next[6]} {machine0/cpu0/cpu_core/pc_next[7]} {machine0/cpu0/cpu_core/pc_next[8]} {machine0/cpu0/cpu_core/pc_next[9]} {machine0/cpu0/cpu_core/pc_next[10]} {machine0/cpu0/cpu_core/pc_next[11]} {machine0/cpu0/cpu_core/pc_next[12]} {machine0/cpu0/cpu_core/pc_next[13]} {machine0/cpu0/cpu_core/pc_next[14]} {machine0/cpu0/cpu_core/pc_next[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {machine0/cpu0/cpu_core/reg_a[0]} {machine0/cpu0/cpu_core/reg_a[1]} {machine0/cpu0/cpu_core/reg_a[2]} {machine0/cpu0/cpu_core/reg_a[3]} {machine0/cpu0/cpu_core/reg_a[4]} {machine0/cpu0/cpu_core/reg_a[5]} {machine0/cpu0/cpu_core/reg_a[6]} {machine0/cpu0/cpu_core/reg_a[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {machine0/cpu0/cpu_core/reg_b[0]} {machine0/cpu0/cpu_core/reg_b[1]} {machine0/cpu0/cpu_core/reg_b[2]} {machine0/cpu0/cpu_core/reg_b[3]} {machine0/cpu0/cpu_core/reg_b[4]} {machine0/cpu0/cpu_core/reg_b[5]} {machine0/cpu0/cpu_core/reg_b[6]} {machine0/cpu0/cpu_core/reg_b[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 8 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {machine0/cpu0/cpu_core/reg_p[0]} {machine0/cpu0/cpu_core/reg_p[1]} {machine0/cpu0/cpu_core/reg_p[2]} {machine0/cpu0/cpu_core/reg_p[3]} {machine0/cpu0/cpu_core/reg_p[4]} {machine0/cpu0/cpu_core/reg_p[5]} {machine0/cpu0/cpu_core/reg_p[6]} {machine0/cpu0/cpu_core/reg_p[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 8 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {machine0/cpu0/cpu_core/reg_x[0]} {machine0/cpu0/cpu_core/reg_x[1]} {machine0/cpu0/cpu_core/reg_x[2]} {machine0/cpu0/cpu_core/reg_x[3]} {machine0/cpu0/cpu_core/reg_x[4]} {machine0/cpu0/cpu_core/reg_x[5]} {machine0/cpu0/cpu_core/reg_x[6]} {machine0/cpu0/cpu_core/reg_x[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 8 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {machine0/cpu0/cpu_core/reg_y[0]} {machine0/cpu0/cpu_core/reg_y[1]} {machine0/cpu0/cpu_core/reg_y[2]} {machine0/cpu0/cpu_core/reg_y[3]} {machine0/cpu0/cpu_core/reg_y[4]} {machine0/cpu0/cpu_core/reg_y[5]} {machine0/cpu0/cpu_core/reg_y[6]} {machine0/cpu0/cpu_core/reg_y[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {machine0/cpu0/cpu_core/reg_z[0]} {machine0/cpu0/cpu_core/reg_z[1]} {machine0/cpu0/cpu_core/reg_z[2]} {machine0/cpu0/cpu_core/reg_z[3]} {machine0/cpu0/cpu_core/reg_z[4]} {machine0/cpu0/cpu_core/reg_z[5]} {machine0/cpu0/cpu_core/reg_z[6]} {machine0/cpu0/cpu_core/reg_z[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 16 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {machine0/cpu0/cpu_core/sp[0]} {machine0/cpu0/cpu_core/sp[1]} {machine0/cpu0/cpu_core/sp[2]} {machine0/cpu0/cpu_core/sp[3]} {machine0/cpu0/cpu_core/sp[4]} {machine0/cpu0/cpu_core/sp[5]} {machine0/cpu0/cpu_core/sp[6]} {machine0/cpu0/cpu_core/sp[7]} {machine0/cpu0/cpu_core/sp[8]} {machine0/cpu0/cpu_core/sp[9]} {machine0/cpu0/cpu_core/sp[10]} {machine0/cpu0/cpu_core/sp[11]} {machine0/cpu0/cpu_core/sp[12]} {machine0/cpu0/cpu_core/sp[13]} {machine0/cpu0/cpu_core/sp[14]} {machine0/cpu0/cpu_core/sp[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 16 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {machine0/cpu0/cpu_core/sp_next[0]} {machine0/cpu0/cpu_core/sp_next[1]} {machine0/cpu0/cpu_core/sp_next[2]} {machine0/cpu0/cpu_core/sp_next[3]} {machine0/cpu0/cpu_core/sp_next[4]} {machine0/cpu0/cpu_core/sp_next[5]} {machine0/cpu0/cpu_core/sp_next[6]} {machine0/cpu0/cpu_core/sp_next[7]} {machine0/cpu0/cpu_core/sp_next[8]} {machine0/cpu0/cpu_core/sp_next[9]} {machine0/cpu0/cpu_core/sp_next[10]} {machine0/cpu0/cpu_core/sp_next[11]} {machine0/cpu0/cpu_core/sp_next[12]} {machine0/cpu0/cpu_core/sp_next[13]} {machine0/cpu0/cpu_core/sp_next[14]} {machine0/cpu0/cpu_core/sp_next[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 3 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {machine0/cpu0/cpu_core/t[0]} {machine0/cpu0/cpu_core/t[1]} {machine0/cpu0/cpu_core/t[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 3 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {machine0/cpu0/cpu_core/t_next[0]} {machine0/cpu0/cpu_core/t_next[1]} {machine0/cpu0/cpu_core/t_next[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 12 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {machine0/cpu0/mapper/current_offset[8]} {machine0/cpu0/mapper/current_offset[9]} {machine0/cpu0/mapper/current_offset[10]} {machine0/cpu0/mapper/current_offset[11]} {machine0/cpu0/mapper/current_offset[12]} {machine0/cpu0/mapper/current_offset[13]} {machine0/cpu0/mapper/current_offset[14]} {machine0/cpu0/mapper/current_offset[15]} {machine0/cpu0/mapper/current_offset[16]} {machine0/cpu0/mapper/current_offset[17]} {machine0/cpu0/mapper/current_offset[18]} {machine0/cpu0/mapper/current_offset[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 8 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {machine0/cpu0/mapper/data_o[0]} {machine0/cpu0/mapper/data_o[1]} {machine0/cpu0/mapper/data_o[2]} {machine0/cpu0/mapper/data_o[3]} {machine0/cpu0/mapper/data_o[4]} {machine0/cpu0/mapper/data_o[5]} {machine0/cpu0/mapper/data_o[6]} {machine0/cpu0/mapper/data_o[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 4 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {machine0/cpu0/mapper/map_enable[2][0]} {machine0/cpu0/mapper/map_enable[2][1]} {machine0/cpu0/mapper/map_enable[2][2]} {machine0/cpu0/mapper/map_enable[2][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 4 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {machine0/cpu0/mapper/map_enable[0][0]} {machine0/cpu0/mapper/map_enable[0][1]} {machine0/cpu0/mapper/map_enable[0][2]} {machine0/cpu0/mapper/map_enable[0][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 4 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {machine0/cpu0/mapper/map_enable[1][0]} {machine0/cpu0/mapper/map_enable[1][1]} {machine0/cpu0/mapper/map_enable[1][2]} {machine0/cpu0/mapper/map_enable[1][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 4 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {machine0/cpu0/mapper/map_enable[3][0]} {machine0/cpu0/mapper/map_enable[3][1]} {machine0/cpu0/mapper/map_enable[3][2]} {machine0/cpu0/mapper/map_enable[3][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 2 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list {machine0/cpu0/mapper/map_enable_index[0]} {machine0/cpu0/mapper/map_enable_index[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 12 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {machine0/cpu0/mapper/map_offset[0]__0[8]} {machine0/cpu0/mapper/map_offset[0]__0[9]} {machine0/cpu0/mapper/map_offset[0]__0[10]} {machine0/cpu0/mapper/map_offset[0]__0[11]} {machine0/cpu0/mapper/map_offset[0]__0[12]} {machine0/cpu0/mapper/map_offset[0]__0[13]} {machine0/cpu0/mapper/map_offset[0]__0[14]} {machine0/cpu0/mapper/map_offset[0]__0[15]} {machine0/cpu0/mapper/map_offset[0]__0[16]} {machine0/cpu0/mapper/map_offset[0]__0[17]} {machine0/cpu0/mapper/map_offset[0]__0[18]} {machine0/cpu0/mapper/map_offset[0]__0[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 12 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {machine0/cpu0/mapper/map_offset[1]__0[8]} {machine0/cpu0/mapper/map_offset[1]__0[9]} {machine0/cpu0/mapper/map_offset[1]__0[10]} {machine0/cpu0/mapper/map_offset[1]__0[11]} {machine0/cpu0/mapper/map_offset[1]__0[12]} {machine0/cpu0/mapper/map_offset[1]__0[13]} {machine0/cpu0/mapper/map_offset[1]__0[14]} {machine0/cpu0/mapper/map_offset[1]__0[15]} {machine0/cpu0/mapper/map_offset[1]__0[16]} {machine0/cpu0/mapper/map_offset[1]__0[17]} {machine0/cpu0/mapper/map_offset[1]__0[18]} {machine0/cpu0/mapper/map_offset[1]__0[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 12 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {machine0/cpu0/mapper/map_offset[2]__0[8]} {machine0/cpu0/mapper/map_offset[2]__0[9]} {machine0/cpu0/mapper/map_offset[2]__0[10]} {machine0/cpu0/mapper/map_offset[2]__0[11]} {machine0/cpu0/mapper/map_offset[2]__0[12]} {machine0/cpu0/mapper/map_offset[2]__0[13]} {machine0/cpu0/mapper/map_offset[2]__0[14]} {machine0/cpu0/mapper/map_offset[2]__0[15]} {machine0/cpu0/mapper/map_offset[2]__0[16]} {machine0/cpu0/mapper/map_offset[2]__0[17]} {machine0/cpu0/mapper/map_offset[2]__0[18]} {machine0/cpu0/mapper/map_offset[2]__0[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 12 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list {machine0/cpu0/mapper/map_offset[3]__0[8]} {machine0/cpu0/mapper/map_offset[3]__0[9]} {machine0/cpu0/mapper/map_offset[3]__0[10]} {machine0/cpu0/mapper/map_offset[3]__0[11]} {machine0/cpu0/mapper/map_offset[3]__0[12]} {machine0/cpu0/mapper/map_offset[3]__0[13]} {machine0/cpu0/mapper/map_offset[3]__0[14]} {machine0/cpu0/mapper/map_offset[3]__0[15]} {machine0/cpu0/mapper/map_offset[3]__0[16]} {machine0/cpu0/mapper/map_offset[3]__0[17]} {machine0/cpu0/mapper/map_offset[3]__0[18]} {machine0/cpu0/mapper/map_offset[3]__0[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 20 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list {machine0/cpu0/mapper/mapper_address[0]} {machine0/cpu0/mapper/mapper_address[1]} {machine0/cpu0/mapper/mapper_address[2]} {machine0/cpu0/mapper/mapper_address[3]} {machine0/cpu0/mapper/mapper_address[4]} {machine0/cpu0/mapper/mapper_address[5]} {machine0/cpu0/mapper/mapper_address[6]} {machine0/cpu0/mapper/mapper_address[7]} {machine0/cpu0/mapper/mapper_address[8]} {machine0/cpu0/mapper/mapper_address[9]} {machine0/cpu0/mapper/mapper_address[10]} {machine0/cpu0/mapper/mapper_address[11]} {machine0/cpu0/mapper/mapper_address[12]} {machine0/cpu0/mapper/mapper_address[13]} {machine0/cpu0/mapper/mapper_address[14]} {machine0/cpu0/mapper/mapper_address[15]} {machine0/cpu0/mapper/mapper_address[16]} {machine0/cpu0/mapper/mapper_address[17]} {machine0/cpu0/mapper/mapper_address[18]} {machine0/cpu0/mapper/mapper_address[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 20 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list {machine0/cpu0/address[0]} {machine0/cpu0/address[1]} {machine0/cpu0/address[2]} {machine0/cpu0/address[3]} {machine0/cpu0/address[4]} {machine0/cpu0/address[5]} {machine0/cpu0/address[6]} {machine0/cpu0/address[7]} {machine0/cpu0/address[8]} {machine0/cpu0/address[9]} {machine0/cpu0/address[10]} {machine0/cpu0/address[11]} {machine0/cpu0/address[12]} {machine0/cpu0/address[13]} {machine0/cpu0/address[14]} {machine0/cpu0/address[15]} {machine0/cpu0/address[16]} {machine0/cpu0/address[17]} {machine0/cpu0/address[18]} {machine0/cpu0/address[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 20 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list {machine0/cpu0/address_next[0]} {machine0/cpu0/address_next[1]} {machine0/cpu0/address_next[2]} {machine0/cpu0/address_next[3]} {machine0/cpu0/address_next[4]} {machine0/cpu0/address_next[5]} {machine0/cpu0/address_next[6]} {machine0/cpu0/address_next[7]} {machine0/cpu0/address_next[8]} {machine0/cpu0/address_next[9]} {machine0/cpu0/address_next[10]} {machine0/cpu0/address_next[11]} {machine0/cpu0/address_next[12]} {machine0/cpu0/address_next[13]} {machine0/cpu0/address_next[14]} {machine0/cpu0/address_next[15]} {machine0/cpu0/address_next[16]} {machine0/cpu0/address_next[17]} {machine0/cpu0/address_next[18]} {machine0/cpu0/address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 16 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list {machine0/cpu0/core_address_next[0]} {machine0/cpu0/core_address_next[1]} {machine0/cpu0/core_address_next[2]} {machine0/cpu0/core_address_next[3]} {machine0/cpu0/core_address_next[4]} {machine0/cpu0/core_address_next[5]} {machine0/cpu0/core_address_next[6]} {machine0/cpu0/core_address_next[7]} {machine0/cpu0/core_address_next[8]} {machine0/cpu0/core_address_next[9]} {machine0/cpu0/core_address_next[10]} {machine0/cpu0/core_address_next[11]} {machine0/cpu0/core_address_next[12]} {machine0/cpu0/core_address_next[13]} {machine0/cpu0/core_address_next[14]} {machine0/cpu0/core_address_next[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 8 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list {machine0/cpu0/data_o_next[0]} {machine0/cpu0/data_o_next[1]} {machine0/cpu0/data_o_next[2]} {machine0/cpu0/data_o_next[3]} {machine0/cpu0/data_o_next[4]} {machine0/cpu0/data_o_next[5]} {machine0/cpu0/data_o_next[6]} {machine0/cpu0/data_o_next[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 8 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list {machine0/cpu0/data_i[0]} {machine0/cpu0/data_i[1]} {machine0/cpu0/data_i[2]} {machine0/cpu0/data_i[3]} {machine0/cpu0/data_i[4]} {machine0/cpu0/data_i[5]} {machine0/cpu0/data_i[6]} {machine0/cpu0/data_i[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 8 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list {machine0/cpu0/data_o[0]} {machine0/cpu0/data_o[1]} {machine0/cpu0/data_o[2]} {machine0/cpu0/data_o[3]} {machine0/cpu0/data_o[4]} {machine0/cpu0/data_o[5]} {machine0/cpu0/data_o[6]} {machine0/cpu0/data_o[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 8 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list {machine0/cpu0/map_reg_data[0]} {machine0/cpu0/map_reg_data[1]} {machine0/cpu0/map_reg_data[2]} {machine0/cpu0/map_reg_data[3]} {machine0/cpu0/map_reg_data[4]} {machine0/cpu0/map_reg_data[5]} {machine0/cpu0/map_reg_data[6]} {machine0/cpu0/map_reg_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 2 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list {machine0/arbiter0/bus_master_next[0]} {machine0/arbiter0/bus_master_next[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 2 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list {machine0/arbiter0/bus_master[0]} {machine0/arbiter0/bus_master[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 20 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list {machine0/arbiter0/bus_memory_access_address_next[0]} {machine0/arbiter0/bus_memory_access_address_next[1]} {machine0/arbiter0/bus_memory_access_address_next[2]} {machine0/arbiter0/bus_memory_access_address_next[3]} {machine0/arbiter0/bus_memory_access_address_next[4]} {machine0/arbiter0/bus_memory_access_address_next[5]} {machine0/arbiter0/bus_memory_access_address_next[6]} {machine0/arbiter0/bus_memory_access_address_next[7]} {machine0/arbiter0/bus_memory_access_address_next[8]} {machine0/arbiter0/bus_memory_access_address_next[9]} {machine0/arbiter0/bus_memory_access_address_next[10]} {machine0/arbiter0/bus_memory_access_address_next[11]} {machine0/arbiter0/bus_memory_access_address_next[12]} {machine0/arbiter0/bus_memory_access_address_next[13]} {machine0/arbiter0/bus_memory_access_address_next[14]} {machine0/arbiter0/bus_memory_access_address_next[15]} {machine0/arbiter0/bus_memory_access_address_next[16]} {machine0/arbiter0/bus_memory_access_address_next[17]} {machine0/arbiter0/bus_memory_access_address_next[18]} {machine0/arbiter0/bus_memory_access_address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 20 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list {machine0/arbiter0/cpu_memory_access_address_next[0]} {machine0/arbiter0/cpu_memory_access_address_next[1]} {machine0/arbiter0/cpu_memory_access_address_next[2]} {machine0/arbiter0/cpu_memory_access_address_next[3]} {machine0/arbiter0/cpu_memory_access_address_next[4]} {machine0/arbiter0/cpu_memory_access_address_next[5]} {machine0/arbiter0/cpu_memory_access_address_next[6]} {machine0/arbiter0/cpu_memory_access_address_next[7]} {machine0/arbiter0/cpu_memory_access_address_next[8]} {machine0/arbiter0/cpu_memory_access_address_next[9]} {machine0/arbiter0/cpu_memory_access_address_next[10]} {machine0/arbiter0/cpu_memory_access_address_next[11]} {machine0/arbiter0/cpu_memory_access_address_next[12]} {machine0/arbiter0/cpu_memory_access_address_next[13]} {machine0/arbiter0/cpu_memory_access_address_next[14]} {machine0/arbiter0/cpu_memory_access_address_next[15]} {machine0/arbiter0/cpu_memory_access_address_next[16]} {machine0/arbiter0/cpu_memory_access_address_next[17]} {machine0/arbiter0/cpu_memory_access_address_next[18]} {machine0/arbiter0/cpu_memory_access_address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 20 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list {machine0/arbiter0/dmagic_memory_access_address_next[0]} {machine0/arbiter0/dmagic_memory_access_address_next[1]} {machine0/arbiter0/dmagic_memory_access_address_next[2]} {machine0/arbiter0/dmagic_memory_access_address_next[3]} {machine0/arbiter0/dmagic_memory_access_address_next[4]} {machine0/arbiter0/dmagic_memory_access_address_next[5]} {machine0/arbiter0/dmagic_memory_access_address_next[6]} {machine0/arbiter0/dmagic_memory_access_address_next[7]} {machine0/arbiter0/dmagic_memory_access_address_next[8]} {machine0/arbiter0/dmagic_memory_access_address_next[9]} {machine0/arbiter0/dmagic_memory_access_address_next[10]} {machine0/arbiter0/dmagic_memory_access_address_next[11]} {machine0/arbiter0/dmagic_memory_access_address_next[12]} {machine0/arbiter0/dmagic_memory_access_address_next[13]} {machine0/arbiter0/dmagic_memory_access_address_next[14]} {machine0/arbiter0/dmagic_memory_access_address_next[15]} {machine0/arbiter0/dmagic_memory_access_address_next[16]} {machine0/arbiter0/dmagic_memory_access_address_next[17]} {machine0/arbiter0/dmagic_memory_access_address_next[18]} {machine0/arbiter0/dmagic_memory_access_address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 20 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list {machine0/arbiter0/monitor_memory_access_address_next[0]} {machine0/arbiter0/monitor_memory_access_address_next[1]} {machine0/arbiter0/monitor_memory_access_address_next[2]} {machine0/arbiter0/monitor_memory_access_address_next[3]} {machine0/arbiter0/monitor_memory_access_address_next[4]} {machine0/arbiter0/monitor_memory_access_address_next[5]} {machine0/arbiter0/monitor_memory_access_address_next[6]} {machine0/arbiter0/monitor_memory_access_address_next[7]} {machine0/arbiter0/monitor_memory_access_address_next[8]} {machine0/arbiter0/monitor_memory_access_address_next[9]} {machine0/arbiter0/monitor_memory_access_address_next[10]} {machine0/arbiter0/monitor_memory_access_address_next[11]} {machine0/arbiter0/monitor_memory_access_address_next[12]} {machine0/arbiter0/monitor_memory_access_address_next[13]} {machine0/arbiter0/monitor_memory_access_address_next[14]} {machine0/arbiter0/monitor_memory_access_address_next[15]} {machine0/arbiter0/monitor_memory_access_address_next[16]} {machine0/arbiter0/monitor_memory_access_address_next[17]} {machine0/arbiter0/monitor_memory_access_address_next[18]} {machine0/arbiter0/monitor_memory_access_address_next[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 8 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list {machine0/arbiter0/monitor_memory_access_wdata_next[0]} {machine0/arbiter0/monitor_memory_access_wdata_next[1]} {machine0/arbiter0/monitor_memory_access_wdata_next[2]} {machine0/arbiter0/monitor_memory_access_wdata_next[3]} {machine0/arbiter0/monitor_memory_access_wdata_next[4]} {machine0/arbiter0/monitor_memory_access_wdata_next[5]} {machine0/arbiter0/monitor_memory_access_wdata_next[6]} {machine0/arbiter0/monitor_memory_access_wdata_next[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 8 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list {machine0/cpu0/cpu_core/ir_next_mux/ir_next[0]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[1]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[2]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[3]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[4]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[5]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[6]} {machine0/cpu0/cpu_core/ir_next_mux/ir_next[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 8 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list {machine0/cpu0/cpu_core/ir_next_mux/ir[0]} {machine0/cpu0/cpu_core/ir_next_mux/ir[1]} {machine0/cpu0/cpu_core/ir_next_mux/ir[2]} {machine0/cpu0/cpu_core/ir_next_mux/ir[3]} {machine0/cpu0/cpu_core/ir_next_mux/ir[4]} {machine0/cpu0/cpu_core/ir_next_mux/ir[5]} {machine0/cpu0/cpu_core/ir_next_mux/ir[6]} {machine0/cpu0/cpu_core/ir_next_mux/ir[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list machine0/bus0/ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list machine0/cpu0/mapper/active_map]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list machine0/arbiter0/arb_cpu_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list machine0/arbiter0/bus_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list machine0/arbiter0/bus_memory_access_io_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list machine0/bus0/bus_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list machine0/arbiter0/bus_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list machine0/arbiter0/cpu_arb_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list machine0/arbiter0/cpu_memory_access_io_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list machine0/arbiter0/cpu_memory_access_read_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe69]
set_property port_width 1 [get_debug_ports u_ila_0/probe69]
connect_debug_port u_ila_0/probe69 [get_nets [list machine0/hypervisor/cpu_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe70]
set_property port_width 1 [get_debug_ports u_ila_0/probe70]
connect_debug_port u_ila_0/probe70 [get_nets [list machine0/bus0/cpuport_cs_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe71]
set_property port_width 1 [get_debug_ports u_ila_0/probe71]
connect_debug_port u_ila_0/probe71 [get_nets [list machine0/arbiter0/dmagic_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe72]
set_property port_width 1 [get_debug_ports u_ila_0/probe72]
connect_debug_port u_ila_0/probe72 [get_nets [list machine0/arbiter0/dmagic_cpu_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe73]
set_property port_width 1 [get_debug_ports u_ila_0/probe73]
connect_debug_port u_ila_0/probe73 [get_nets [list machine0/bus0/dmagic_cs_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe74]
set_property port_width 1 [get_debug_ports u_ila_0/probe74]
connect_debug_port u_ila_0/probe74 [get_nets [list machine0/arbiter0/dmagic_dma_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe75]
set_property port_width 1 [get_debug_ports u_ila_0/probe75]
connect_debug_port u_ila_0/probe75 [get_nets [list machine0/arbiter0/dmagic_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe76]
set_property port_width 1 [get_debug_ports u_ila_0/probe76]
connect_debug_port u_ila_0/probe76 [get_nets [list machine0/cpu0/hyp]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe77]
set_property port_width 1 [get_debug_ports u_ila_0/probe77]
connect_debug_port u_ila_0/probe77 [get_nets [list machine0/hypervisor/hyp]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe78]
set_property port_width 1 [get_debug_ports u_ila_0/probe78]
connect_debug_port u_ila_0/probe78 [get_nets [list machine0/hypervisor/hyper_cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe79]
set_property port_width 1 [get_debug_ports u_ila_0/probe79]
connect_debug_port u_ila_0/probe79 [get_nets [list machine0/cpu0/hyper_mode]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe80]
set_property port_width 1 [get_debug_ports u_ila_0/probe80]
connect_debug_port u_ila_0/probe80 [get_nets [list machine0/hypervisor/hyper_mode]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe81]
set_property port_width 1 [get_debug_ports u_ila_0/probe81]
connect_debug_port u_ila_0/probe81 [get_nets [list machine0/hypervisor/hyper_upgraded]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe82]
set_property port_width 1 [get_debug_ports u_ila_0/probe82]
connect_debug_port u_ila_0/probe82 [get_nets [list machine0/bus0/hypervisor_cs_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe83]
set_property port_width 1 [get_debug_ports u_ila_0/probe83]
connect_debug_port u_ila_0/probe83 [get_nets [list machine0/cpu0/hypervisor_load_user_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe84]
set_property port_width 1 [get_debug_ports u_ila_0/probe84]
connect_debug_port u_ila_0/probe84 [get_nets [list machine0/bus0/io_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe85]
set_property port_width 1 [get_debug_ports u_ila_0/probe85]
connect_debug_port u_ila_0/probe85 [get_nets [list machine0/bus0/io_sel_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe86]
set_property port_width 1 [get_debug_ports u_ila_0/probe86]
connect_debug_port u_ila_0/probe86 [get_nets [list machine0/hypervisor/iomode_set_toggle]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe87]
set_property port_width 1 [get_debug_ports u_ila_0/probe87]
connect_debug_port u_ila_0/probe87 [get_nets [list machine0/cpu0/irq]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe88]
set_property port_width 1 [get_debug_ports u_ila_0/probe88]
connect_debug_port u_ila_0/probe88 [get_nets [list machine0/bus0/kickstart_cs_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe89]
set_property port_width 1 [get_debug_ports u_ila_0/probe89]
connect_debug_port u_ila_0/probe89 [get_nets [list machine0/cpu0/mapper/load_a]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe90]
set_property port_width 1 [get_debug_ports u_ila_0/probe90]
connect_debug_port u_ila_0/probe90 [get_nets [list machine0/hypervisor/load_hyper_upgraded]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe91]
set_property port_width 1 [get_debug_ports u_ila_0/probe91]
connect_debug_port u_ila_0/probe91 [get_nets [list machine0/cpu0/mapper/load_map_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe92]
set_property port_width 1 [get_debug_ports u_ila_0/probe92]
connect_debug_port u_ila_0/probe92 [get_nets [list machine0/hypervisor/load_user_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe93]
set_property port_width 1 [get_debug_ports u_ila_0/probe93]
connect_debug_port u_ila_0/probe93 [get_nets [list machine0/cpu0/mapper/load_x]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe94]
set_property port_width 1 [get_debug_ports u_ila_0/probe94]
connect_debug_port u_ila_0/probe94 [get_nets [list machine0/cpu0/mapper/load_y]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe95]
set_property port_width 1 [get_debug_ports u_ila_0/probe95]
connect_debug_port u_ila_0/probe95 [get_nets [list machine0/cpu0/mapper/load_z]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe96]
set_property port_width 1 [get_debug_ports u_ila_0/probe96]
connect_debug_port u_ila_0/probe96 [get_nets [list machine0/cpu0/mapper/map_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe97]
set_property port_width 1 [get_debug_ports u_ila_0/probe97]
connect_debug_port u_ila_0/probe97 [get_nets [list machine0/cpu0/mapper/map_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe98]
set_property port_width 1 [get_debug_ports u_ila_0/probe98]
connect_debug_port u_ila_0/probe98 [get_nets [list machine0/cpu0/map_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe99]
set_property port_width 1 [get_debug_ports u_ila_0/probe99]
connect_debug_port u_ila_0/probe99 [get_nets [list machine0/cpu0/mapper/map_offset_index]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe100]
set_property port_width 1 [get_debug_ports u_ila_0/probe100]
connect_debug_port u_ila_0/probe100 [get_nets [list machine0/cpu0/map_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe101]
set_property port_width 1 [get_debug_ports u_ila_0/probe101]
connect_debug_port u_ila_0/probe101 [get_nets [list machine0/arbiter0/monitor_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe102]
set_property port_width 1 [get_debug_ports u_ila_0/probe102]
connect_debug_port u_ila_0/probe102 [get_nets [list machine0/hypervisor/monitor_char_busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe103]
set_property port_width 1 [get_debug_ports u_ila_0/probe103]
connect_debug_port u_ila_0/probe103 [get_nets [list machine0/hypervisor/monitor_char_toggle]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe104]
set_property port_width 1 [get_debug_ports u_ila_0/probe104]
connect_debug_port u_ila_0/probe104 [get_nets [list machine0/arbiter0/monitor_memory_access_io_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe105]
set_property port_width 1 [get_debug_ports u_ila_0/probe105]
connect_debug_port u_ila_0/probe105 [get_nets [list machine0/arbiter0/monitor_memory_access_read_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe106]
set_property port_width 1 [get_debug_ports u_ila_0/probe106]
connect_debug_port u_ila_0/probe106 [get_nets [list machine0/arbiter0/monitor_memory_access_write_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe107]
set_property port_width 1 [get_debug_ports u_ila_0/probe107]
connect_debug_port u_ila_0/probe107 [get_nets [list machine0/arbiter0/monitor_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe108]
set_property port_width 1 [get_debug_ports u_ila_0/probe108]
connect_debug_port u_ila_0/probe108 [get_nets [list machine0/cpu0/nmi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe109]
set_property port_width 1 [get_debug_ports u_ila_0/probe109]
connect_debug_port u_ila_0/probe109 [get_nets [list machine0/cpu0/ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe110]
set_property port_width 1 [get_debug_ports u_ila_0/probe110]
connect_debug_port u_ila_0/probe110 [get_nets [list machine0/hypervisor/ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe111]
set_property port_width 1 [get_debug_ports u_ila_0/probe111]
connect_debug_port u_ila_0/probe111 [get_nets [list machine0/cpu0/reset]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe112]
set_property port_width 1 [get_debug_ports u_ila_0/probe112]
connect_debug_port u_ila_0/probe112 [get_nets [list machine0/bus0/reset]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe113]
set_property port_width 1 [get_debug_ports u_ila_0/probe113]
connect_debug_port u_ila_0/probe113 [get_nets [list machine0/bus0/shadow_write_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe114]
set_property port_width 1 [get_debug_ports u_ila_0/probe114]
connect_debug_port u_ila_0/probe114 [get_nets [list machine0/cpu0/sync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe115]
set_property port_width 1 [get_debug_ports u_ila_0/probe115]
connect_debug_port u_ila_0/probe115 [get_nets [list machine0/bus0/system_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe116]
set_property port_width 1 [get_debug_ports u_ila_0/probe116]
connect_debug_port u_ila_0/probe116 [get_nets [list machine0/bus0/system_read_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe117]
set_property port_width 1 [get_debug_ports u_ila_0/probe117]
connect_debug_port u_ila_0/probe117 [get_nets [list machine0/bus0/system_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe118]
set_property port_width 1 [get_debug_ports u_ila_0/probe118]
connect_debug_port u_ila_0/probe118 [get_nets [list machine0/bus0/system_write_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe119]
set_property port_width 1 [get_debug_ports u_ila_0/probe119]
connect_debug_port u_ila_0/probe119 [get_nets [list machine0/bus0/vic_cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe120]
set_property port_width 1 [get_debug_ports u_ila_0/probe120]
connect_debug_port u_ila_0/probe120 [get_nets [list machine0/bus0/vic_cs_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe121]
set_property port_width 1 [get_debug_ports u_ila_0/probe121]
connect_debug_port u_ila_0/probe121 [get_nets [list machine0/bus0/vic_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe122]
set_property port_width 1 [get_debug_ports u_ila_0/probe122]
connect_debug_port u_ila_0/probe122 [get_nets [list machine0/cpu0/write_next]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe123]
set_property port_width 1 [get_debug_ports u_ila_0/probe123]
connect_debug_port u_ila_0/probe123 [get_nets [list machine0/cpu0/write_out]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets cpuclock]
