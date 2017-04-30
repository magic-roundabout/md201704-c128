;
; MD201704 - 2MHZ VERTICAL SPLITTER
;

; Coding and graphics by T.M.R/Cosine
; Music by ?????


; Select an output filename
		!to "md201704.prg",cbm


; Yank in binary data
		* = $3200
music		!binary "data/dozey.prg",,2

		* = $5000
		!binary "data/charset.chr"

		* = $5c00
		!binary "data/logo_colour.raw"

		* = $6000
		!binary "data/logo_bitmap.raw"


; Constants
rstr1p		= $02
rstr2p		= $99
rstr3p		= $f3

; Label assignments
rn		= $06
sync		= $07

cos_at_1	= $08		; for the plotter
cos_speed_1	= $03		; constant
cos_offset_1	= $05		; constant
cos_at_2	= $09
cos_speed_2	= $01		; constant
cos_offset_2	= $fc		; constant
cos_at_3	= $0a
cos_speed_3	= $03		; constant
cos_offset_3	= $0c		; constant

cos_at_4	= $0b		; for the raster bars
cos_offset_4	= $e2		; constant

char_width	= $0c		; for the scroller
d016_mirror	= $0d
scroll_x	= $0e
scroll_spd	= $0f

colours_1	= $10		; work spaces for the rasters
colours_2	= $38
colours_3	= $60

plot_work_x	= $4780		; work spaces for the plotter
plot_work_y	= $47c0
plot_ram	= $4800

screen_ram	= $5c00		; screen RAM


; Add a BASIC startline
		* = $1c01
		!word entry-2
		!byte $00,$00,$9e
		!text "7186"
		!byte $00,$00,$00


; Main code start
		* = $1c12
entry		sei

; Bank everything out!
		lda #$3e
		sta $ff00

		lda #$34
		sta $01

; IRQ and NMI interrupt init
		lda #<nmi
		sta $fffa
		lda #>nmi
		sta $fffb

		lda #<int
		sta $fffe
		lda #>int
		sta $ffff

		lda #$7f
		sta $dc0d
		sta $dd0d

		lda $dc0d
		lda $dd0d

		lda #rstr1p
		sta $d012
		lda #$0b
		sta $d011
		lda #$01
		sta $d019
		sta $d01a

; Clear zero page and initialise a few labels
		ldx #$50
		lda #$00
nuke_zp		sta $00,x
		inx
		bne nuke_zp

		lda #$01
		sta rn

; Invert the bitmapped logo (it was drawn in an older version of P1)
		ldx #$00
bitmap_invert	lda $6000,x
		eor #$ff
		sta $6000,x
		inx
		bne bitmap_invert

		inc bitmap_invert+$02
		inc bitmap_invert+$07
		lda bitmap_invert+$02
		cmp #$70
		bne bitmap_invert-$02

; Set all of the colour RAM to the background colour
		ldx #$00
		lda #$0b
colour_nuke	sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne colour_nuke

; Masks around the logo
		ldx #$00
		lda #($0b*$10)+$0b
bitmap_mask	sta screen_ram+$000,x
		sta screen_ram+$1e0,x
		inx
		cpx #$28
		bne bitmap_mask

; Set up the scroller's area
		ldx #$00
scroll_init	lda #$00
		sta screen_ram+$208,x
		lda #$00
		sta $da08,x
		inx
		cpx #$50
		bne scroll_init

; Set up the plotter's area (vertical columns of characters)
		ldx #$00
		lda #$00
plot_scrn_init	clc
		sta screen_ram+$0284,x
		adc #$01
		sta screen_ram+$02ac,x
		adc #$01
		sta screen_ram+$02d4,x
		adc #$01
		sta screen_ram+$02fc,x
		adc #$01
		sta screen_ram+$0324,x
		adc #$01
		sta screen_ram+$034c,x
		adc #$01
		sta screen_ram+$0374,x
		adc #$01
		sta screen_ram+$039c,x
		adc #$01
		inx
		cpx #$1f
		bne plot_scrn_init

		ldx #$00
		lda #$0f
plot_col_init	sta $da84,x
		sta $daac,x
		sta $dad4,x
		sta $dafc,x
		sta $db24,x
		sta $db4c,x
		sta $db74,x
		sta $db9c,x
		inx
		cpx #$1f
		bne plot_col_init

; Reset the scrolling message
		jsr reset
		lda #$03
		sta scroll_spd
		lda #$01
		sta char_width
		sta d016_mirror

; Set up the music
		lda #$00
		jsr music+$00

		cli


; Main loop
main_loop	lda #$00
		sta sync
ml_sync_wait	cmp sync
		beq ml_sync_wait

; Update the plotter
		jsr plotter

		jmp main_loop


; IRQ interrupt
int		pha
		txa
		pha
		tya
		pha

		lda $d019
		and #$01
		sta $d019
		bne ya
		jmp ea31


ya		lda rn
		cmp #$01
		bne *+$05
		jmp rout1

		cmp #$02
		bne *+$05
		jmp rout2

		cmp #$03
		bne *+$05
		jmp rout3


; Raster split 1
		* = ((*/$100)+$01)*$100

rout1		lda #$00
		sta $d030

		ldx #$12		; raster sync - scanline 1
		dex
		bne *-$01
		lda $d012
		cmp #rstr1p+$01
		beq *+$02
;		sta $d020

		ldx #$0a		; raster sync - scanline 2
		dex
		bne *-$01
		nop
		nop
		nop
		lda $d012
		cmp #rstr1p+$02
		beq *+$02
;		sta $d020

		ldx #$0a		; raster sync - scanline 3
		dex
		bne *-$01
		nop
		nop
		lda $d012
		cmp #rstr1p+$03
		beq *+$02
;		sta $d020

		ldx #$0a		; raster sync - scanline 4
		dex
		bne *-$01
		bit $ea
		lda $d012
		cmp #rstr1p+$04
		beq *+$02
;		sta $d020

		ldx #$0a		; raster sync - scanline 5
		dex
		bne *-$01
		nop
		nop
		lda $d012
		cmp #rstr1p+$05
		beq *+$02
;		sta $d020

		ldx #$0a		; raster sync - scanline 6
		dex
		bne *-$01
		bit $ea
		lda $d012
		cmp #rstr1p+$06
		beq *+$02
;		sta $d020

		ldx #$04
		dex
		bne *-$01
		nop
		nop
		nop

; Set up the bitmapped logo
		lda #$3b
		sta $d011
		lda #$00
		sta $d016
		lda #$78
		sta $d018

		lda #$c6
		sta $dd00

; Enable 2MHz mode, call the splitter and disable 2MHz.
		lda #$01
		sta $d030

		jsr splitter

		lda #$00
		sta $d030

; Set up for the next raster split
		lda #$02
		sta rn
		lda #rstr2p
		sta $d012

		jmp ea31


; Raster split 2
		* = ((*/$100)+$01)*$100

rout2		nop
		nop
		nop

		lda #$1b
		ldx d016_mirror
		ldy #$74
		sta $d011
		stx $d016
		sty $d018

; Scroller's colour split
		ldx #$0a
		dex
		bne *-$01
		lda #$00
		sta $d021

		ldx #$02
		dex
		bne *-$01
		nop
		lda #$06
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$0b
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$04
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$0e
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$05
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$03
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$0d
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$07
		sta $d021

		ldx #$02
		dex
		bne *-$01
		nop
		lda #$0f
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$0a
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$0c
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$08
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$02
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$09
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		nop
		lda #$00
		sta $d021

		ldx #$0b
		dex
		bne *-$01
		lda #$0b
		sta $d021

; Change font and hardware scroll register for the plotter's area
		lda #$04
		sta $d016
		lda #$72
		sta $d018

; Update the colour splits
		jsr splitter_update

; Move the scrolling message
		ldy scroll_spd
scroll_upd	ldx scroll_x
		inx
		cpx #$08
		beq *+$05
		jmp sx_xb

; Shift the character lines
!set char_cnt=$00
!do {
		lda screen_ram+$209+char_cnt
		sta screen_ram+$208+char_cnt
		ora #$80
		sta screen_ram+$230+char_cnt

		!set char_cnt=char_cnt+$01
} until char_cnt=$26

		dec char_width
		beq mread

; Bump the current character value by one
		lda screen_ram+$208+$26
		clc
		adc #$01
		sta screen_ram+$208+$26
		ora #$80
		sta screen_ram+$230+$26
		jmp no_fetch

; Fetch a new character
mread		ldx scroll_text
		bne okay
		jsr reset
		jmp mread

okay		cpx #$81
		bcc okay_2
		txa
		and #$0f
		sta scroll_spd
		ldx #$20

okay_2		txa
		asl
		sta screen_ram+$208+$26
		ora #$80
		sta screen_ram+$230+$26
		lda char_width_dcd,x
		sta char_width

		inc mread+$01
		bne *+$05
		inc mread+$02

no_fetch	ldx #$00
sx_xb		stx scroll_x

		dey
		beq *+$05
		jmp scroll_upd

		txa
		and #$07
		eor #$07
		sta d016_mirror

; Play the music
		jsr music+$03

; Set up for the next raster split
		lda #$03
		sta rn
		lda #rstr3p
		sta $d012

		jmp ea31


; Raster split 3
		* = ((*/$100)+$01)*$100

rout3		ldx #$00
fli_loop	lda $d012
		and #$07
		ora #$18
		sta $d011
		nop
		nop
		inx
		cpx #$07
		bne fli_loop
		lda #$1b
		sta $d011

		ldx #$21
		dex
		bne *-$01
		bit $ea

; Enable 2MHz mode, call the splitter and leave 2MHz on.
		lda #$01
		sta $d030

		jsr splitter

; Let the runtime code know where we are
		lda #$01
		sta sync

; Set up for the first raster split
		lda #$01
		sta rn
		lda #rstr1p
		sta $d012

; Exit interrupt
ea31		pla
		tay
		pla
		tax
		pla
nmi		rti


; Reset the self mod for the scroller
reset		lda #<scroll_text
		sta mread+$01
		lda #>scroll_text
		sta mread+$02
		rts


		* = $8000
; Include the unrolled plotter and splitter code
		!src "includes/plotter.asm"
		!src "includes/splitter.asm"


; Colour table for the splits
		* = ((*/$100)+$01)*$100
colour_table	!byte $00,$09,$02,$00,$09,$02,$08,$00
		!byte $09,$02,$08,$0a,$00,$09,$02,$08
		!byte $0a,$0f,$00,$09,$02,$08,$0a,$0f
		!byte $07,$00,$09,$02,$08,$0a,$0f,$07
		!byte $0f,$0a,$08,$02,$09,$00,$07,$0f
		!byte $0a,$08,$02,$09,$00,$0f,$0a,$08
		!byte $02,$09,$00,$0a,$08,$02,$09,$00
		!byte $08,$02,$09,$00,$02,$09,$00,$00

		!byte $00,$09,$0b,$00,$09,$0b,$08,$00
		!byte $09,$0b,$08,$05,$00,$09,$0b,$08
		!byte $05,$0f,$00,$09,$0b,$08,$05,$0f
		!byte $0d,$00,$09,$0b,$08,$05,$0f,$0d
		!byte $0f,$05,$08,$0b,$09,$00,$0d,$0f
		!byte $05,$08,$0b,$09,$00,$0f,$05,$08
		!byte $0b,$09,$00,$05,$08,$0b,$09,$00
		!byte $08,$0b,$09,$00,$0b,$09,$00,$00

		!byte $00,$06,$0b,$00,$06,$0b,$04,$00
		!byte $06,$0b,$04,$0e,$00,$06,$0b,$04
		!byte $0e,$03,$00,$06,$0b,$04,$0e,$03
		!byte $0d,$00,$06,$0b,$04,$0e,$03,$0d
		!byte $03,$0e,$04,$0b,$06,$00,$0d,$03
		!byte $0e,$04,$0b,$06,$00,$03,$0e,$04
		!byte $0b,$06,$00,$0e,$04,$0b,$06,$00
		!byte $04,$0b,$06,$00,$0b,$06,$00,$00

; Cosine table for the splits
split_cosinus	!byte $97,$97,$97,$97,$97,$97,$97,$96
		!byte $96,$96,$95,$95,$94,$94,$93,$92
		!byte $92,$91,$90,$8f,$8f,$8e,$8d,$8c
		!byte $8b,$8a,$89,$87,$86,$85,$84,$82
		!byte $81,$80,$7e,$7d,$7c,$7a,$79,$77
		!byte $76,$74,$72,$71,$6f,$6e,$6c,$6a
		!byte $68,$67,$65,$63,$61,$60,$5e,$5c
		!byte $5a,$58,$57,$55,$53,$51,$4f,$4d

		!byte $4b,$49,$48,$46,$44,$42,$40,$3e
		!byte $3d,$3b,$39,$37,$35,$34,$32,$30
		!byte $2e,$2d,$2b,$29,$28,$26,$24,$23
		!byte $21,$20,$1e,$1d,$1b,$1a,$18,$17
		!byte $16,$14,$13,$12,$11,$0f,$0e,$0d
		!byte $0c,$0b,$0a,$09,$08,$08,$07,$06
		!byte $05,$05,$04,$03,$03,$02,$02,$01
		!byte $01,$01,$00,$00,$00,$00,$00,$00

		!byte $00,$00,$00,$00,$00,$00,$00,$01
		!byte $01,$01,$02,$02,$03,$03,$04,$05
		!byte $05,$06,$07,$08,$09,$0a,$0a,$0b
		!byte $0c,$0e,$0f,$10,$11,$12,$13,$15
		!byte $16,$17,$19,$1a,$1c,$1d,$1f,$20
		!byte $22,$23,$25,$26,$28,$2a,$2b,$2d
		!byte $2f,$30,$32,$34,$36,$38,$39,$3b
		!byte $3d,$3f,$41,$43,$44,$46,$48,$4a

		!byte $4c,$4e,$50,$52,$53,$55,$57,$59
		!byte $5b,$5d,$5e,$60,$62,$64,$66,$67
		!byte $69,$6b,$6c,$6e,$70,$71,$73,$75
		!byte $76,$78,$79,$7b,$7c,$7d,$7f,$80
		!byte $82,$83,$84,$85,$87,$88,$89,$8a
		!byte $8b,$8c,$8d,$8e,$8f,$90,$90,$91
		!byte $92,$93,$93,$94,$94,$95,$95,$96
		!byte $96,$96,$97,$97,$97,$97,$97,$97

; Plotter X and Y cosine tables
plot_x_cosinus	!byte $7b,$7b,$7b,$7b,$7b,$7b,$7b,$7b
		!byte $7a,$7a,$7a,$79,$79,$78,$78,$77
		!byte $77,$76,$76,$75,$74,$73,$73,$72
		!byte $71,$70,$6f,$6e,$6d,$6c,$6b,$6a
		!byte $69,$68,$67,$66,$65,$64,$62,$61
		!byte $60,$5f,$5d,$5c,$5b,$59,$58,$57
		!byte $55,$54,$52,$51,$4f,$4e,$4c,$4b
		!byte $4a,$48,$46,$45,$43,$42,$40,$3f

		!byte $3d,$3c,$3a,$39,$37,$36,$34,$33
		!byte $31,$30,$2e,$2d,$2b,$2a,$28,$27
		!byte $26,$24,$23,$21,$20,$1f,$1d,$1c
		!byte $1b,$1a,$18,$17,$16,$15,$14,$13
		!byte $12,$10,$0f,$0e,$0d,$0d,$0c,$0b
		!byte $0a,$09,$08,$07,$07,$06,$05,$05
		!byte $04,$04,$03,$03,$02,$02,$01,$01
		!byte $01,$00,$00,$00,$00,$00,$00,$00

		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $01,$01,$01,$02,$02,$03,$03,$04
		!byte $04,$05,$06,$06,$07,$08,$08,$09
		!byte $0a,$0b,$0c,$0d,$0e,$0f,$10,$11
		!byte $12,$13,$14,$15,$16,$18,$19,$1a
		!byte $1b,$1d,$1e,$1f,$21,$22,$23,$25
		!byte $26,$27,$29,$2a,$2c,$2d,$2f,$30
		!byte $32,$33,$35,$36,$38,$39,$3b,$3c

		!byte $3e,$3f,$41,$42,$44,$45,$47,$48
		!byte $4a,$4b,$4d,$4e,$50,$51,$53,$54
		!byte $56,$57,$58,$5a,$5b,$5c,$5e,$5f
		!byte $60,$62,$63,$64,$65,$66,$67,$69
		!byte $6a,$6b,$6c,$6d,$6e,$6f,$70,$70
		!byte $71,$72,$73,$74,$74,$75,$76,$76
		!byte $77,$77,$78,$79,$79,$79,$7a,$7a
		!byte $7a,$7b,$7b,$7b,$7b,$7b,$7b,$7b

plot_y_cosinus	!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
		!byte $3f,$3f,$3f,$3e,$3e,$3e,$3e,$3d
		!byte $3d,$3d,$3c,$3c,$3c,$3b,$3b,$3b
		!byte $3a,$3a,$39,$39,$38,$38,$37,$37
		!byte $36,$36,$35,$34,$34,$33,$33,$32
		!byte $31,$31,$30,$2f,$2f,$2e,$2d,$2c
		!byte $2c,$2b,$2a,$29,$29,$28,$27,$26
		!byte $26,$25,$24,$23,$23,$22,$21,$20

		!byte $1f,$1f,$1e,$1d,$1c,$1c,$1b,$1a
		!byte $19,$18,$18,$17,$16,$15,$15,$14
		!byte $13,$12,$12,$11,$10,$10,$0f,$0e
		!byte $0e,$0d,$0c,$0c,$0b,$0b,$0a,$09
		!byte $09,$08,$08,$07,$07,$06,$06,$05
		!byte $05,$04,$04,$04,$03,$03,$03,$02
		!byte $02,$02,$01,$01,$01,$01,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00

		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$01,$01,$01,$01,$02
		!byte $02,$02,$03,$03,$03,$04,$04,$05
		!byte $05,$05,$06,$06,$07,$07,$08,$08
		!byte $09,$0a,$0a,$0b,$0b,$0c,$0d,$0d
		!byte $0e,$0f,$0f,$10,$11,$11,$12,$13
		!byte $13,$14,$15,$16,$16,$17,$18,$19
		!byte $19,$1a,$1b,$1c,$1d,$1d,$1e,$1f

		!byte $20,$20,$21,$22,$23,$24,$24,$25
		!byte $26,$27,$27,$28,$29,$2a,$2a,$2b
		!byte $2c,$2d,$2d,$2e,$2f,$2f,$30,$31
		!byte $31,$32,$33,$33,$34,$35,$35,$36
		!byte $36,$37,$37,$38,$38,$39,$39,$3a
		!byte $3a,$3b,$3b,$3b,$3c,$3c,$3d,$3d
		!byte $3d,$3d,$3e,$3e,$3e,$3e,$3f,$3f
		!byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f

; Pixels for the plotter
plot_pixels	!byte $80,$40,$20,$10,$08,$04,$02,$01

; The start of each column in the plotter's work space
plot_col_low	!byte <plot_ram+$000
		!byte <plot_ram+$040
		!byte <plot_ram+$080
		!byte <plot_ram+$0c0
		!byte <plot_ram+$100
		!byte <plot_ram+$140
		!byte <plot_ram+$180
		!byte <plot_ram+$1c0
		!byte <plot_ram+$200
		!byte <plot_ram+$240
		!byte <plot_ram+$280
		!byte <plot_ram+$2c0
		!byte <plot_ram+$300
		!byte <plot_ram+$340
		!byte <plot_ram+$380
		!byte <plot_ram+$3c0
		!byte <plot_ram+$400
		!byte <plot_ram+$440
		!byte <plot_ram+$480
		!byte <plot_ram+$4c0
		!byte <plot_ram+$500
		!byte <plot_ram+$540
		!byte <plot_ram+$580
		!byte <plot_ram+$5c0
		!byte <plot_ram+$600
		!byte <plot_ram+$640
		!byte <plot_ram+$680
		!byte <plot_ram+$6c0
		!byte <plot_ram+$700
		!byte <plot_ram+$740
		!byte <plot_ram+$780
		!byte <plot_ram+$7c0

plot_col_high	!byte >plot_ram+$000
		!byte >plot_ram+$040
		!byte >plot_ram+$080
		!byte >plot_ram+$0c0
		!byte >plot_ram+$100
		!byte >plot_ram+$140
		!byte >plot_ram+$180
		!byte >plot_ram+$1c0
		!byte >plot_ram+$200
		!byte >plot_ram+$240
		!byte >plot_ram+$280
		!byte >plot_ram+$2c0
		!byte >plot_ram+$300
		!byte >plot_ram+$340
		!byte >plot_ram+$380
		!byte >plot_ram+$3c0
		!byte >plot_ram+$400
		!byte >plot_ram+$440
		!byte >plot_ram+$480
		!byte >plot_ram+$4c0
		!byte >plot_ram+$500
		!byte >plot_ram+$540
		!byte >plot_ram+$580
		!byte >plot_ram+$5c0
		!byte >plot_ram+$600
		!byte >plot_ram+$640
		!byte >plot_ram+$680
		!byte >plot_ram+$6c0
		!byte >plot_ram+$700
		!byte >plot_ram+$740
		!byte >plot_ram+$780
		!byte >plot_ram+$7c0

; Width for each character
char_width_dcd	!byte $01,$02,$02,$02,$02,$02,$02,$02		; @ to G
		!byte $02,$01,$02,$02,$02,$02,$02,$02		; H to O
		!byte $02,$02,$02,$02,$02,$02,$02,$02		; P to W
		!byte $02,$02,$02,$01,$01,$01,$01,$01		; X to Z, 5 * punct.
		!byte $01,$01,$01,$01,$01,$01,$01,$01		; space to '
		!byte $02,$02,$01,$02,$01,$02,$01,$02		; ( to /
		!byte $02,$01,$02,$02,$02,$02,$02,$02		; 0 to 7
		!byte $02,$02,$01,$01,$01,$02,$01,$02		; 8 to ?

scroll_text	!scr $83,"here we go again with   "
		!scr $81,"--- md201704 ---   ",$82
		!scr "for the commodore 128!"
		!scr "         "

		!scr $83,"code and graphics were hammered together by the magic "
		!scr "roundabout but, just for a change, so was the music!"
		!scr "         "

		!scr $82,"my muse this time was rabenauge's revision 2017 release "
		!scr "''elvis copper'' because i was watching the stream when it "
		!scr "appeared and couldn't work out why the colour splits were "
		!scr "eight cycles wide!"
		!scr "      "
		!scr "there are only a couple values being used per scanline so "
		!scr "loading them into two registers and writing one after the "
		!scr "other across the line is far more efficient code."
		!scr "         "

		!scr "so this is my version of their release which uses four cycle "
		!scr "splits; since the prototype was already written to run on "
		!scr "a c128 and was planned to become md201704 anyway, it seemed "
		!scr "a fun idea to keep that as the target platform!"
		!scr "      "

		!scr "there could be more splits on each line but they wouldn't "
		!scr "have been evenly spaced and i'd rather they were "
		!scr "aesthetically pleasing!"
		!scr "         "

		!scr "the music is a previously unused conversion i did twenty "
		!scr "something years ago (and suddenly i feel old) of the "
		!scr "protracker module ''dozey'' which was originally composed "
		!scr "by jozz... although i don't actually remember how it "
		!scr "''escaped'' the cosine dungeon in order to make its way "
		!scr "into the hvsc!"
		!scr "         "

		!scr $83,"in other news, i'm not sure what'll be happening to the "
		!scr "monthly demo series over the next couple of months; i'm "
		!scr "getting married to my beloved in may for starters and there's "
		!scr "a bit of organising which still needs doing so, unless i "
		!scr "come up with a quick and relatively easy release, that month "
		!scr "might have to be skipped."
		!scr "      "

		!scr "there's also the party which isn't called sundown in june "
		!scr "but i haven't a clue as to if there'll be time to churn out "
		!scr "a larger scale release for it or even if i can arrange to "
		!scr "be there!"
		!scr "      "

		!scr "just imagine how much better things would work if i could "
		!scr "actually plan more than one thing in advance...?"
		!scr "         "

		!scr $82,"i seem to be running low on ideas for text so we might "
		!scr "as well get around to blasting through the cosine "
		!scr "greetings list, with c128-flavoured hellos whizzing out "
		!scr "towards...    "

		!scr $85,"absence - "
		!scr "abyss connection - "
		!scr "arkanix labs - "
		!scr "artstate - "
		!scr "ate bit - "
		!scr "atlantis - "
		!scr "booze design - "
		!scr "camelot - "
		!scr "censor design - "
		!scr "chorus - "
		!scr "chrome - "
		!scr "cncd - "
		!scr "cpu - "
		!scr "crescent - "
		!scr "crest - "
		!scr "covert bitops - "
		!scr "defence force - "
		!scr "dekadence - "
		!scr "desire - "
		!scr "dac - "
		!scr "dmagic - "
		!scr "dualcrew - "
		!scr "exclusive on - "
		!scr "fairlight - "
		!scr "f4cg - "
		!scr "fire - "
		!scr "flat 3 - "
		!scr "focus - "
		!scr "french touch - "
		!scr "funkscientist productions - "
		!scr "genesis project - "
		!scr "gheymaid inc. - "
		!scr "hitmen - "
		!scr "hokuto force - "
		!scr "legion of doom - "
		!scr "level64 - "
		!scr "maniacs of noise - "
		!scr "mayday - "
		!scr "meanteam - "
		!scr "metalvotze - "
		!scr "noname - "
		!scr "nostalgia - "
		!scr "nuance - "
		!scr "offence - "
		!scr "onslaught - "
		!scr "orb - "
		!scr "oxyron - "
		!scr "padua - "
		!scr "performers - "
		!scr "plush - "
		!scr "professional protection cracking service - "
		!scr "psytronik - "
		!scr "reptilia - "
		!scr "resource - "
		!scr "rgcd - "
		!scr "secure - "
		!scr "shape - "
		!scr "side b - "
		!scr "singular - "
		!scr "slash - "
		!scr "slipstream - "
		!scr "success and trc - "
		!scr "style - "
		!scr "suicyco industries - "
		!scr "taquart - "
		!scr "tempest - "
		!scr "tek - "
		!scr "triad - "
		!scr "trsi - "
		!scr "viruz - "
		!scr "vision - "
		!scr "wow - "
		!scr "wrath "
		!scr "and xenon."
		!scr "         "

		!scr $82,"finally, a couple of plugs for the cosine website "
		!scr "over at http://cosine.org.uk/ along with my blog which "
		!scr "lurks around the interwebs at http://jasonkelk.me.uk/ and "
		!scr "that's pretty much your lot girls and boys..."
		!scr "         "

		!scr $83,"i've been the magic roundabout of cosine, today is "
		!scr "the 30th of april 2017, this was md201704 and, if you "
		!scr "wait for a little while longer, the scrolling message "
		!scr "will wrap... .. .  .   ."
		!scr "                  "

		!byte $00		; end of text marker
