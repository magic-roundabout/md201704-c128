;
; UNROLLED FOUR CYCLE COLOUR SPLITTER
;

splitter

!set line_cnt=$00
!do {
		lda colours_1+line_cnt
		ldx colours_2+line_cnt
		ldy colours_3+line_cnt
		sta $d020
		nop
		nop
		nop
		stx $d020
		sty $d020
		stx $d020

		sta $d020
		stx $d020
		sty $d020
		stx $d020

		sta $d020
		stx $d020
		sty $d020
		stx $d020

		sta $d020
		stx $d020
		sty $d020
		stx $d020

		sta $d020
		stx $d020
		sty $d020
		stx $d020

		sta $d020
		stx $d020
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		!set line_cnt=line_cnt+$01
} until line_cnt=$28

		lda #$0b
		sta $d021
		sta $d020

		rts


; Splitter colour table updater
splitter_update	ldx cos_at_4
		inx
		stx cos_at_4

!set line_cnt=$00
!do {
		ldy split_cosinus,x
		lda colour_table+line_cnt,y
		sta colours_1+line_cnt

		!set line_cnt=line_cnt+$01
} until line_cnt=$28

		txa
		clc
		adc #cos_offset_4
		tax

!set line_cnt=$00
!do {
		ldy split_cosinus,x
		lda colour_table+line_cnt,y
		sta colours_2+line_cnt

		!set line_cnt=line_cnt+$01
} until line_cnt=$28

		txa
		clc
		adc #cos_offset_4
		tax

!set line_cnt=$00
!do {
		ldy split_cosinus,x
		lda colour_table+line_cnt,y
		sta colours_3+line_cnt

		!set line_cnt=line_cnt+$01
} until line_cnt=$28

		rts
