%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	LOADER_STACK_TOP equ LOADER_BASE_ADDR
	jmp loader_start

	GDT_BASE: dd 0x00000000
						dd 0x00000000

	CODE_DESC: dd 0x0000ffff
						 dd (0x00 << 24) + DESC_G_4K + DESC_DB_32 + \
						  	 DESC_L + DESC_AVL + DESC_LIMIT_CODE2 + \
								 DESC_P + DESC_DPL_0 + DESC_S_CODE + \
								 DESC_TYPE_CODE + 0X00
	
	DATA_STACK_DESC: dd 0x0000ffff
									 dd (0x00 << 24) + DESC_G_4K + DESC_DB_32 + \
								 			DESC_L + DESC_AVL + DESC_LIMIT_DATA2 + \
										  DESC_P + DESC_DPL_0 + DESC_S_DATA + \
										  DESC_TYPE_DATA + 0X00
	

	VIDEO_DESC: dd 0x80000007
							dd (0x00 << 24) + DESC_G_4K + DESC_DB_32 + \
								 DESC_L + DESC_AVL + DESC_LIMIT_VIDEO2 + \
								 DESC_P + DESC_DPL_0 + DESC_S_DATA + \
								 DESC_TYPE_DATA + 0X0b
	
;	mov byte [gs:0x00],'L'
;	mov byte [gs:0x01],0xA4

;	mov byte [gs:0x02],'O'
;	mov byte [gs:0x03],0xA4

;	mov byte [gs:0x04],'A'
;	mov byte [gs:0x05],0xA4

;	mov byte [gs:0x06],'D'
;	mov byte [gs:0x07],0xA4

;	jmp $
