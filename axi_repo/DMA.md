## DMA

* byte_size
    * 8192

|name|offset_address|
|:--|:--|
|[CMD_REG0](#DMA-CMD_REG0)|0x0000|
|[CMD_REG1](#DMA-CMD_REG1)|0x0004|
|[CMD_REG2](#DMA-CMD_REG2)|0x0008|
|[CMD_REG3](#DMA-CMD_REG3)|0x000c|
|[STATIC_REG0](#DMA-STATIC_REG0)|0x0010|
|[STATIC_REG1](#DMA-STATIC_REG1)|0x0014|
|[STATIC_REG2](#DMA-STATIC_REG2)|0x0018|
|[STATIC_REG3](#DMA-STATIC_REG3)|0x001c|
|[STATIC_REG4](#DMA-STATIC_REG4)|0x0020|
|[RESTRICT_REG](#DMA-RESTRICT_REG)|0x002c|
|[READ_OFFSET_REG](#DMA-READ_OFFSET_REG)|0x0030|
|[WRITE_OFFSET_REG](#DMA-WRITE_OFFSET_REG)|0x0034|
|[FIFO_FULLNESS_REG](#DMA-FIFO_FULLNESS_REG)|0x0038|
|[CMD_OUTS_REG](#DMA-CMD_OUTS_REG)|0x003c|
|[CH_ENABLE_REG](#DMA-CH_ENABLE_REG)|0x0040|
|[CH_START_REG](#DMA-CH_START_REG)|0x0044|
|[CH_ACTIVE_REG](#DMA-CH_ACTIVE_REG)|0x0048|
|[COUNT_REG](#DMA-COUNT_REG)|0x0050|
|[INT_RAWSTAT_REG](#DMA-INT_RAWSTAT_REG)|0x00a0|
|[INT_CLEAR_REG](#DMA-INT_CLEAR_REG)|0x00a4|
|[INT_ENABLE_REG](#DMA-INT_ENABLE_REG)|0x00a8|
|[INT_STATUS_REG](#DMA-INT_STATUS_REG)|0x00ac|
|[INT0_STATUS](#DMA-INT0_STATUS)|0x1000|
|[INT1_STATUS](#DMA-INT1_STATUS)|0x1004|
|[INT2_STATUS](#DMA-INT2_STATUS)|0x1008|
|[INT3_STATUS](#DMA-INT3_STATUS)|0x100c|
|[INT4_STATUS](#DMA-INT4_STATUS)|0x1010|
|[INT5_STATUS](#DMA-INT5_STATUS)|0x1014|
|[INT6_STATUS](#DMA-INT6_STATUS)|0x1018|
|[INT7_STATUS](#DMA-INT7_STATUS)|0x101c|
|[CORE0_JOINT_MODE](#DMA-CORE0_JOINT_MODE)|0x1030|
|[CORE1_JOINT_MODE](#DMA-CORE1_JOINT_MODE)|0x1034|
|[CORE0_PRIORITY](#DMA-CORE0_PRIORITY)|0x1038|
|[CORE1_PRIORITY](#DMA-CORE1_PRIORITY)|0x103c|
|[CORE0_CLKDIV](#DMA-CORE0_CLKDIV)|0x1040|
|[CORE1_CLKDIV](#DMA-CORE1_CLKDIV)|0x1044|
|[CORE0_CH_START](#DMA-CORE0_CH_START)|0x1048|
|[CORE1_CH_START](#DMA-CORE1_CH_START)|0x104c|
|[PERIPH_RX_CTRL](#DMA-PERIPH_RX_CTRL)|0x1050|
|[PERIPH_TX_CTRL](#DMA-PERIPH_TX_CTRL)|0x1054|
|[IDLE](#DMA-IDLE)|0x10d0|
|[USER_DEF_STATUS](#DMA-USER_DEF_STATUS)|0x10e0|
|[USER_CORE0_DEF_STATUS0](#DMA-USER_CORE0_DEF_STATUS0)|0x10f0|
|[USER_CORE0_DEF_STATUS1](#DMA-USER_CORE0_DEF_STATUS1)|0x10f4|
|[USER_CORE1_DEF_STATUS0](#DMA-USER_CORE1_DEF_STATUS0)|0x10f8|
|[USER_CORE1_DEF_STATUS1](#DMA-USER_CORE1_DEF_STATUS1)|0x10fc|

### <div id="DMA-CMD_REG0"></div>CMD_REG0

* offset_address
    * 0x0000
* type
    * default
* comment
    * Channel's command, first line out of 4. When using command lists this register will be overwritten by the next command.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_START_ADDR|[31:0]|rw|0x00000000||||

### <div id="DMA-CMD_REG1"></div>CMD_REG1

* offset_address
    * 0x0004
* type
    * rw
* comment
    * Channel's command, second line out of 4. When using command lists this register will be overwritten by the next command.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|WR_START_ADDR|[31:0]|rw|0x00000000||||

### <div id="DMA-CMD_REG2"></div>CMD_REG2

* offset_address
    * 0x0008
* type
    * default
* comment
    * Channel's command, third line out of 4. When using command lists this register will be overwritten by the next command.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|BUFFER_SIZE|[15:0]|rw|0x0000||||

### <div id="DMA-CMD_REG3"></div>CMD_REG3

* offset_address
    * 0x000c
* type
    * default
* comment
    * Channel's command, last line out of 4. When using command lists this register will be overwritten by the next command.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CMD_SET_INT|[0]|rw|0x0||||
|CMD_LAST|[1]|rw|0x0||||
|CMD_NEXT_ADDR|[31:4]|rw|0x0000000||||

### <div id="DMA-STATIC_REG0"></div>STATIC_REG0

* offset_address
    * 0x0010
* type
    * default
* comment
    * Channel's static configuration. These parameters should not be changed while channel is<br>active. These registers are used for both read and write in joint mode.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_BURST_MAX_SIZE|[9:0]|rw|0x000||||
|RD_ALLOW_FULL_BURST|[12]|rw|0x0||||
|RD_ALLOW_FULL_FIFO|[13]|rw|0x0||||
|RD_TOKENS|[21:16]|rw|0x01||||
|RD_OUTS_MAX|[27:24]|rw|0x4||||
|RD_OUTSTANDING|[30]|rw|0x0||||
|RD_INCR|[31]|rw|0x1||||

### <div id="DMA-STATIC_REG1"></div>STATIC_REG1

* offset_address
    * 0x0014
* type
    * default
* comment
    * Channel's static configuration. These parameters should not be changed while channel is<br>active. These registers are used for both read and write in joint mode.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_BURST_MAX_SIZE|[9:0]|rw|0x000||||
|RD_ALLOW_FULL_BURST|[12]|rw|0x0||||
|RD_ALLOW_FULL_FIFO|[13]|rw|0x0||||
|RD_TOKENS|[21:16]|rw|0x01||||
|RD_OUTS_MAX|[27:24]|rw|0x4||||
|RD_OUTSTANDING|[30]|rw|0x0||||
|RD_INCR|[31]|rw|0x1||||

### <div id="DMA-STATIC_REG2"></div>STATIC_REG2

* offset_address
    * 0x0018
* type
    * default
* comment
    * Block mode

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|FRAME_WIDTH|[11:0]|rw|0x000||||
|BLOCK|[15]|rw|0x0||||
|JOINT|[16]|rw|0x0||||
|AUTO_RETRY|[17]|rw|0x0||||
|RD_CMD_PORT_NUM|[20]|rw|0x0||||
|RD_PORT_NUM|[21]|rw|0x0||||
|WR_PORT_NUM|[22]|rw|0x0||||
|INT_NUM|[26:24]|rw|0x0||||
|END_SWAP|[29:28]|rw|0x0||||

### <div id="DMA-STATIC_REG3"></div>STATIC_REG3

* offset_address
    * 0x001c
* type
    * default
* comment
    * Channel's static configuration. These parameters should not be changed while channel is active.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_WAIT_LIMIT|[11:0]|rw|0x000||||
|WR_WAIT_LIMIT|[27:16]|rw|0x000||||

### <div id="DMA-STATIC_REG4"></div>STATIC_REG4

* offset_address
    * 0x0020
* type
    * default
* comment
    * Channel's static configuration. These parameters should not be changed while channel is active.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_PERIPH_NUM|[4:0]|rw|0x00||||
|RD_PERIPH_DELAY|[10:8]|rw|0x0||||
|RD_PERIPH_BLOCK|[15]|rw|0x0||||
|WR_PERIPH_NUM|[20:16]|rw|0x00||||
|WR_PERIPH_DELAY|[26:24]|rw|0x0||||
|WR_PERIPH_BLOCK|[31]|rw|0x0||||

### <div id="DMA-RESTRICT_REG"></div>RESTRICT_REG

* offset_address
    * 0x002c
* type
    * default
* comment
    * Channel's restrictions status register

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_ALLOW_FULL_FIFO|[0]|ro|||||
|WR_ALLOW_FULL_FIFO|[1]|ro|||||
|ALLOW_FULL_FIFO|[2]|ro|||||
|ALLOW_FULL_BURST|[3]|ro|||||
|ALLOW_JOINT_BURST|[4]|ro|||||
|RD_OUTSTANDING_STAT|[5]|ro|||||
|WR_OUTSTANDING_STAT|[6]|ro|||||
|BLOCK_NON_ALIGN_STAT|[7]|ro|||||
|SIMPLE_STAT|[8]|ro|||||

### <div id="DMA-READ_OFFSET_REG"></div>READ_OFFSET_REG

* offset_address
    * 0x0030
* type
    * default
* comment
    * Channel's read offset status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_OFFSET|[15:0]|ro|0x0000||||

### <div id="DMA-WRITE_OFFSET_REG"></div>WRITE_OFFSET_REG

* offset_address
    * 0x0034
* type
    * default
* comment
    * Channel's write offset status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|WR_OFFSET|[15:0]|ro|0x0000||||

### <div id="DMA-FIFO_FULLNESS_REG"></div>FIFO_FULLNESS_REG

* offset_address
    * 0x0038
* type
    * default
* comment
    * FIFO fullness status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_GAP|[9:0]|ro|0x000||||
|WR_FULLNESS|[25:16]|ro|0x000||||

### <div id="DMA-CMD_OUTS_REG"></div>CMD_OUTS_REG

* offset_address
    * 0x003c
* type
    * default
* comment
    * Outstanding commands status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|RD_CMD_OUTS|[5:0]|ro|0x3f||||
|WR_CMD_OUTS|[13:8]|ro|0x3f||||

### <div id="DMA-CH_ENABLE_REG"></div>CH_ENABLE_REG

* offset_address
    * 0x0040
* type
    * default
* comment
    * Channel enable.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CH_ENABLE|[0]|rw|0x1||||

### <div id="DMA-CH_START_REG"></div>CH_START_REG

* offset_address
    * 0x0044
* type
    * default
* comment
    * Channel start.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CH_START|[0]|wo|0x0||||

### <div id="DMA-CH_ACTIVE_REG"></div>CH_ACTIVE_REG

* offset_address
    * 0x0048
* type
    * default
* comment
    * Channel active status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CH_RD_ACTIVE|[0]|ro|0x0||||
|CH_WR_ACTIVE|[1]|ro|0x0||||

### <div id="DMA-COUNT_REG"></div>COUNT_REG

* offset_address
    * 0x0050
* type
    * default
* comment
    * Buffer counter status register.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|BUFF_COUNT|[15:0]|ro|0x0000||||
|INT_COUNT|[21:16]|ro|0x00||||

### <div id="DMA-INT_RAWSTAT_REG"></div>INT_RAWSTAT_REG

* offset_address
    * 0x00a0
* type
    * default
* comment
    * Interrupt raw status

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|INT_RAWSTAT_CH_END|[0]|rw|0x0||||
|INT_RAWSTAT_RD_DECERR|[1]|rw|0x0||||
|INT_RAWSTAT_RD_SLVERR|[2]|rw|0x0||||
|INT_RAWSTAT_WR_DECERR|[3]|rw|0x0||||
|INT_RAWSTAT_WR_SLVERR|[4]|rw|0x0||||
|INT_RAWSTAT_OVERFLOW|[5]|rw|0x0||||
|INT_RAWSTAT_UNDERFLOW|[6]|rw|0x0||||
|INT_RAWSTAT_TIMEOUT_R|[7]|rw|0x0||||
|INT_RAWSTAT_TIMEOUT_AR|[8]|rw|0x0||||
|INT_RAWSTAT_TIMEOUT_B|[9]|rw|0x0||||
|INT_RAWSTAT_TIMEOUT_W|[10]|rw|0x0||||
|INT_RAWSTAT_TIMEOUT_AW|[11]|rw|0x0||||
|INT_RAWSTAT_WDT|[12]|rw|0x0||||

### <div id="DMA-INT_CLEAR_REG"></div>INT_CLEAR_REG

* offset_address
    * 0x00a4
* type
    * default
* comment
    * Interrupt clear

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|INT_CLR_CH_END|[0]|wo|0x0||||
|INT_CLR_RD_DECERR|[1]|wo|0x0||||
|INT_CLR_RD_SLVERR|[2]|wo|0x0||||
|INT_CLR_WR_DECERR|[3]|wo|0x0||||
|INT_CLR_WR_SLVERR|[4]|wo|0x0||||
|INT_CLR_OVERFLOW|[5]|wo|0x0||||
|INT_CLR_UNDERFLOW|[6]|wo|0x0||||
|INT_CLR_TIMEOUT_R|[7]|wo|0x0||||
|INT_CLR_TIMEOUT_AR|[8]|wo|0x0||||
|INT_CLR_TIMEOUT_B|[9]|wo|0x0||||
|INT_CLR_TIMEOUT_W|[10]|wo|0x0||||
|INT_CLR_TIMEOUT_AW|[11]|wo|0x0||||
|INT_CLR_WDT|[12]|wo|0x0||||

### <div id="DMA-INT_ENABLE_REG"></div>INT_ENABLE_REG

* offset_address
    * 0x00a8
* type
    * default
* comment
    * Interrupt enable. Each bit that is set enables its corresponding INT_RAWSTAT register to be present in the INT_STATUS register and outputted on the INT output pin.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|INT_ENABLE_CH_END|[0]|rw|0x1||||
|INT_ENABLE_RD_DECERR|[1]|rw|0x1||||
|INT_ENABLE_RD_SLVERR|[2]|rw|0x1||||
|INT_ENABLE_WR_DECERR|[3]|rw|0x1||||
|INT_ENABLE_WR_SLVERR|[4]|rw|0x1||||
|INT_ENABLE_OVERFLOW|[5]|rw|0x1||||
|INT_ENABLE_UNDERFLOW|[6]|rw|0x1||||
|INT_ENABLE_TIMEOUT_R|[7]|rw|0x1||||
|INT_ENABLE_TIMEOUT_AR|[8]|rw|0x1||||
|INT_ENABLE_TIMEOUT_B|[9]|rw|0x1||||
|INT_ENABLE_TIMEOUT_W|[10]|rw|0x1||||
|INT_ENABLE_TIMEOUT_AW|[11]|rw|0x1||||
|INT_ENABLE_WDT|[12]|rw|0x1||||

### <div id="DMA-INT_STATUS_REG"></div>INT_STATUS_REG

* offset_address
    * 0x00ac
* type
    * default
* comment
    * Interrupt status. Indicates which interrupts are currently outputted on the INT output pin.

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|INT_STATUS_CH_END|[0]|ro|||||
|INT_STATUS_RD_DECERR|[1]|ro|||||
|INT_STATUS_RD_SLVERR|[2]|ro|||||
|INT_STATUS_WR_DECERR|[3]|ro|||||
|INT_STATUS_WR_SLVERR|[4]|ro|||||
|INT_STATUS_OVERFLOW|[5]|ro|||||
|INT_STATUS_UNDERFLOW|[6]|ro|||||
|INT_STATUS_TIMEOUT_R|[7]|ro|||||
|INT_STATUS_TIMEOUT_AR|[8]|ro|||||
|INT_STATUS_TIMEOUT_B|[9]|ro|||||
|INT_STATUS_TIMEOUT_W|[10]|ro|||||
|INT_STATUS_TIMEOUT_AW|[11]|ro|||||
|INT_STATUS_WDT|[12]|ro|||||

### <div id="DMA-INT0_STATUS"></div>INT0_STATUS

* offset_address
    * 0x1000
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[0]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT0_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT0_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT0_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT0_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT0_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT0_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT0_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT0_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT0_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT0_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT0_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT0_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT0_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT0_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT0_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT0_STAT|[15]|ro|0x0||||

### <div id="DMA-INT1_STATUS"></div>INT1_STATUS

* offset_address
    * 0x1004
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[1]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT1_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT1_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT1_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT1_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT1_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT1_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT1_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT1_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT1_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT1_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT1_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT1_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT1_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT1_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT1_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT1_STAT|[15]|ro|0x0||||

### <div id="DMA-INT2_STATUS"></div>INT2_STATUS

* offset_address
    * 0x1008
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[2]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT2_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT2_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT2_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT2_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT2_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT2_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT2_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT2_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT2_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT2_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT2_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT2_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT2_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT2_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT2_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT2_STAT|[15]|ro|0x0||||

### <div id="DMA-INT3_STATUS"></div>INT3_STATUS

* offset_address
    * 0x100c
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[3]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT3_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT3_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT3_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT3_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT3_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT3_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT3_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT3_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT3_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT3_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT3_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT3_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT3_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT3_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT3_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT3_STAT|[15]|ro|0x0||||

### <div id="DMA-INT4_STATUS"></div>INT4_STATUS

* offset_address
    * 0x1010
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[4]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT4_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT4_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT4_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT4_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT4_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT4_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT4_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT4_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT4_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT4_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT4_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT4_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT4_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT4_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT4_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT4_STAT|[15]|ro|0x0||||

### <div id="DMA-INT5_STATUS"></div>INT5_STATUS

* offset_address
    * 0x1014
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[5]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT5_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT5_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT5_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT5_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT5_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT5_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT5_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT5_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT5_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT5_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT5_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT5_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT5_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT5_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT5_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT5_STAT|[15]|ro|0x0||||

### <div id="DMA-INT6_STATUS"></div>INT6_STATUS

* offset_address
    * 0x1018
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[6]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT6_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT6_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT6_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT6_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT6_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT6_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT6_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT6_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT6_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT6_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT6_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT6_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT6_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT6_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT6_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT6_STAT|[15]|ro|0x0||||

### <div id="DMA-INT7_STATUS"></div>INT7_STATUS

* offset_address
    * 0x101c
* type
    * default
* comment
    * Status register indicating which channels caused an interrupt on INT[7]

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CH0_INT7_STAT|[0]|ro|0x0||||
|CORE0_CH1_INT7_STAT|[1]|ro|0x0||||
|CORE0_CH2_INT7_STAT|[2]|ro|0x0||||
|CORE0_CH3_INT7_STAT|[3]|ro|0x0||||
|CORE0_CH4_INT7_STAT|[4]|ro|0x0||||
|CORE0_CH5_INT7_STAT|[5]|ro|0x0||||
|CORE0_CH6_INT7_STAT|[6]|ro|0x0||||
|CORE0_CH7_INT7_STAT|[7]|ro|0x0||||
|CORE1_CH0_INT7_STAT|[8]|ro|0x0||||
|CORE1_CH1_INT7_STAT|[9]|ro|0x0||||
|CORE1_CH2_INT7_STAT|[10]|ro|0x0||||
|CORE1_CH3_INT7_STAT|[11]|ro|0x0||||
|CORE1_CH4_INT7_STAT|[12]|ro|0x0||||
|CORE1_CH5_INT7_STAT|[13]|ro|0x0||||
|CORE1_CH6_INT7_STAT|[14]|ro|0x0||||
|CORE1_CH7_INT7_STAT|[15]|ro|0x0||||

### <div id="DMA-CORE0_JOINT_MODE"></div>CORE0_JOINT_MODE

* offset_address
    * 0x1030
* type
    * default
* comment
    * Core 0 joint mode

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_JOINT_MODE|[0]|rw|0x0||||

### <div id="DMA-CORE1_JOINT_MODE"></div>CORE1_JOINT_MODE

* offset_address
    * 0x1034
* type
    * default
* comment
    * Core 1 joint mode

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE1_JOINT_MODE|[0]|rw|0x0||||

### <div id="DMA-CORE0_PRIORITY"></div>CORE0_PRIORITY

* offset_address
    * 0x1038
* type
    * default
* comment
    * Core 0 priority channels

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_RD_PRIO_TOP_NUM|[2:0]|rw|0x0||||
|CORE0_RD_PRIO_TOP|[3]|rw|0x0||||
|CORE0_RD_PRIO_HIGH_NUM|[6:4]|rw|0x0||||
|CORE0_RD_PRIO_HIGH|[7]|rw|0x0||||
|CORE0_WR_PRIO_TOP_NUM|[10:8]|rw|0x0||||
|CORE0_WR_PRIO_TOP|[11]|rw|0x0||||
|CORE0_WR_PRIO_HIGH_NUM|[14:12]|rw|0x0||||
|CORE0_WR_PRIO_HIGH|[15]|rw|0x0||||

### <div id="DMA-CORE1_PRIORITY"></div>CORE1_PRIORITY

* offset_address
    * 0x103c
* type
    * default
* comment
    * Core 1 priority channels

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE1_RD_PRIO_TOP_NUM|[2:0]|rw|0x0||||
|CORE1_RD_PRIO_TOP|[3]|rw|0x0||||
|CORE1_RD_PRIO_HIGH_NUM|[6:4]|rw|0x0||||
|CORE1_RD_PRIO_HIGH|[7]|rw|0x0||||
|CORE1_WR_PRIO_TOP_NUM|[10:8]|rw|0x0||||
|CORE1_WR_PRIO_TOP|[11]|rw|0x0||||
|CORE1_WR_PRIO_HIGH_NUM|[14:12]|rw|0x0||||
|CORE1_WR_PRIO_HIGH|[15]|rw|0x0||||

### <div id="DMA-CORE0_CLKDIV"></div>CORE0_CLKDIV

* offset_address
    * 0x1040
* type
    * default
* comment
    * Core 0 clock divider

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CLKDIV_RATIO|[3:0]|rw|0x1||||

### <div id="DMA-CORE1_CLKDIV"></div>CORE1_CLKDIV

* offset_address
    * 0x1044
* type
    * default
* comment
    * Core 1 clock divider

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE1_CLKDIV_RATIO|[3:0]|rw|0x1||||

### <div id="DMA-CORE0_CH_START"></div>CORE0_CH_START

* offset_address
    * 0x1048
* type
    * default
* comment
    * Core 0 channel start

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE0_CHANNEL_START|[7:0]|wo|0x00||||

### <div id="DMA-CORE1_CH_START"></div>CORE1_CH_START

* offset_address
    * 0x104c
* type
    * default
* comment
    * Core 1 channel start

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|CORE1_CHANNEL_START|[7:0]|wo|0x00||||

### <div id="DMA-PERIPH_RX_CTRL"></div>PERIPH_RX_CTRL

* offset_address
    * 0x1050
* type
    * default
* comment
    * Direct control of peripheral RX request

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|PERIPH_RX_REQ|[31:1]|rw|0x00000000||||

### <div id="DMA-PERIPH_TX_CTRL"></div>PERIPH_TX_CTRL

* offset_address
    * 0x1054
* type
    * default
* comment
    * Direct control of peripheral TX request

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|PERIPH_TX_REQ|[31:1]|rw|0x00000000||||

### <div id="DMA-IDLE"></div>IDLE

* offset_address
    * 0x10d0
* type
    * default
* comment
    * Idle indication register

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|IDLE|[0]|ro|||||

### <div id="DMA-USER_DEF_STATUS"></div>USER_DEF_STATUS

* offset_address
    * 0x10e0
* type
    * default
* comment
    * Status register indicating user defined configurations

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|USER_DEF_INT_NUM|[3:0]|ro|||||
|USER_DEF_DUAL_CORE|[5]|ro|||||
|USER_DEF_IC|[6]|ro|||||
|USER_DEF_IC_DUAL_PORT|[7]|ro|||||
|USER_DEF_CLKGATE|[8]|ro|||||

### <div id="DMA-USER_CORE0_DEF_STATUS0"></div>USER_CORE0_DEF_STATUS0

* offset_address
    * 0x10f0
* type
    * default
* comment
    * Status register indicating user defined configurations

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|USER_DEF_CORE0_CH_NUM|[3:0]|ro|||||
|USER_DEF_CORE0_FIFO_SIZE|[7:4]|ro|||||
|USER_DEF_CORE0_WCMD_DEPTH|[11:8]|ro|||||
|USER_DEF_CORE0_RCMD_DEPTH|[15:12]|ro|||||
|USER_DEF_CORE0_ADDR_BITS|[21:16]|ro|||||
|USER_DEF_CORE0_AXI_32|[22]|ro|||||
|USER_DEF_CORE0_BUFF_BITS|[28:24]|ro|||||

### <div id="DMA-USER_CORE0_DEF_STATUS1"></div>USER_CORE0_DEF_STATUS1

* offset_address
    * 0x10f4
* type
    * default
* comment
    * Status register indicating user defined configurations

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|USER_DEF_CORE0_WDT|[0]|ro|||||
|USER_DEF_CORE0_TIMEOUT|[1]|ro|||||
|USER_DEF_CORE0_TOKENS|[2]|ro|||||
|USER_DEF_CORE0_PRIO|[3]|ro|||||
|USER_DEF_CORE0_OUTS|[4]|ro|||||
|USER_DEF_CORE0_WAIT|[5]|ro|||||
|USER_DEF_CORE0_BLOCK|[6]|ro|||||
|USER_DEF_CORE0_JOINT|[7]|ro|||||
|USER_DEF_CORE0_INDEPENDENT|[8]|ro|||||
|USER_DEF_CORE0_PERIPH|[9]|ro|||||
|USER_DEF_CORE0_LISTS|[10]|ro|||||
|USER_DEF_CORE0_END|[11]|ro|||||
|USER_DEF_CORE0_CLKDIV|[12]|ro|||||

### <div id="DMA-USER_CORE1_DEF_STATUS0"></div>USER_CORE1_DEF_STATUS0

* offset_address
    * 0x10f8
* type
    * default
* comment
    * Status register indicating user defined configurations

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|USER_DEF_CORE1_CH_NUM|[3:0]|ro|||||
|USER_DEF_CORE1_FIFO_SIZE|[7:4]|ro|||||
|USER_DEF_CORE1_WCMD_DEPTH|[11:8]|ro|||||
|USER_DEF_CORE1_RCMD_DEPTH|[15:12]|ro|||||
|USER_DEF_CORE1_ADDR_BITS|[21:16]|ro|||||
|USER_DEF_CORE1_AXI_32|[22]|ro|||||
|USER_DEF_CORE1_BUFF_BITS|[28:24]|ro|||||

### <div id="DMA-USER_CORE1_DEF_STATUS1"></div>USER_CORE1_DEF_STATUS1

* offset_address
    * 0x10fc
* type
    * default
* comment
    * Status register indicating user defined configurations

|name|bit_assignments|type|initial_value|reference|labels|comment|
|:--|:--|:--|:--|:--|:--|:--|
|USER_DEF_CORE1_WDT|[0]|ro|||||
|USER_DEF_CORE1_TIMEOUT|[1]|ro|||||
|USER_DEF_CORE1_TOKENS|[2]|ro|||||
|USER_DEF_CORE1_PRIO|[3]|ro|||||
|USER_DEF_CORE1_OUTS|[4]|ro|||||
|USER_DEF_CORE1_WAIT|[5]|ro|||||
|USER_DEF_CORE1_BLOCK|[6]|ro|||||
|USER_DEF_CORE1_JOINT|[7]|ro|||||
|USER_DEF_CORE1_INDEPENDENT|[8]|ro|||||
|USER_DEF_CORE1_PERIPH|[9]|ro|||||
|USER_DEF_CORE1_LISTS|[10]|ro|||||
|USER_DEF_CORE1_END|[11]|ro|||||
|USER_DEF_CORE1_CLKDIV|[12]|ro|||||
