//------ PERIFERICOS

//-- DIRECCIONES
#define LEDS_ADDR              ((volatile uint16_t*)0x00200000)
#define UART_BUFFER_ADDRESS    ((volatile uint8_t*)0x00210000)
#define UART_RX_STATUS_ADDRESS ((volatile uint8_t*)0x00210002)
#define UART_TX_STATUS_ADDRESS ((volatile uint8_t*)0x00210003)

//-- ACCESO A PERIFERICOS
#define LEDS            *LEDS_ADDR
#define UART_BUFFER     *UART_BUFFER_ADDRESS
#define UART_RX_STATUS  *UART_RX_STATUS_ADDRESS
#define UART_TX_STATUS  *UART_TX_STATUS_ADDRESS


//-- Indices de acceso a los bits de la UART
#define UART_RX_STATUS_IDX_ER     0
#define UART_RX_STATUS_IDX_IE     1
#define UART_RX_STATUS_IDX_FULL   2
#define UART_TX_STATUS_IDX_ER     0
#define UART_TX_STATUS_IDX_IE     1
#define UART_TX_STATUS_IDX_EMPTY  2

//-- Mascaras
#define UART_TX_STATUS_EMPTY_MASK (1 << UART_TX_STATUS_IDX_EMPTY)
