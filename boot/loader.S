%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	LOADER_STACK_TOP equ LOADER_BASE_ADDR
	jmp loader_start

	GDT_BASE: dd 0x00000000
						dd 0x00000000

	CODE_DESC: dd 0x0000ffff
						 dd (0x00 << 24) | DESC_G_4K | DESC_DB_32 | \
						  	 DESC_L | DESC_AVL | DESC_LIMIT_CODE2 | \
								 DESC_P | DESC_DPL_0 | DESC_S_CODE | \
								 DESC_TYPE_CODE | 0X00
	
	DATA_STACK_DESC: dd 0x0000ffff
									 dd (0x00 << 24) | DESC_G_4K | DESC_DB_32 | \
								 			DESC_L | DESC_AVL | DESC_LIMIT_DATA2 | \
										  DESC_P | DESC_DPL_0 | DESC_S_DATA | \
										  DESC_TYPE_DATA | 0X00
	

	VIDEO_DESC: dd 0x80000007
							dd (0x00 << 24) | DESC_G_4K | DESC_DB_32 | \
								 DESC_L | DESC_AVL | DESC_LIMIT_VIDEO2 | \
								 DESC_P | DESC_DPL_0 | DESC_S_DATA | \
								 DESC_TYPE_DATA | 0X0b
	
	GDT_SIZE equ $ - GDT_BASE
	GDT_LIMIT equ GDT_SIZE - 1
	times 60 dq 0

	SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0
	SELECTOR_DATA equ (0x0002<<3) + TI_GDT + RPL0
	SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0
	

	gdt_pointer dw GDT_LIMIT
							dd GDT_BASE

	loadermsg db 'loading system...'

	loader_start:
	;打印提示信息
		mov sp,LOADER_BASE_ADDR
		mov bp,loadermsg
		mov cx,17
		mov ax,0x1301
		mov bx,0x001f
		mov dx,0x1800 ;显示在第二行行首
		int 0x10

	;进入保护模式
		in al,0x92	
		or al,0000_0010b	
		out 0x92,al
		
		lgdt [gdt_pointer]	
		
		mov eax,cr0	
		or eax,0x00000001
		mov cr0,eax
	
		jmp dword SELECTOR_CODE:protect_mode_start;刷新流水线

[bits 32]
protect_mode_start:
	mov ax,SELECTOR_DATA
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov esp,LOADER_STACK_TOP
	mov ax,SELECTOR_VIDEO
	mov gs,ax

	mov byte [gs:200],'O'
	mov byte [gs:201],0xA4
	mov byte [gs:202],'K'
	mov byte [gs:203],0xA4


			
;	mov byte [gs:0x00],'L'
;	mov byte [gs:0x01],0xA4

;	mov byte [gs:0x02],'O'
;	mov byte [gs:0x03],0xA4

;	mov byte [gs:0x04],'A'
;	mov byte [gs:0x05],0xA4

;	mov byte [gs:0x06],'D'
;	mov byte [gs:0x07],0xA4

	jmp $
