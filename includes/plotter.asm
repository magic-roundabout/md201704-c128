;
; UNROLLED 64 POINT PLOTTER CODE
;


plotter

; Clear cycle
		lda #$00
plot_clr_000	sta $07f7
plot_clr_001	sta $07f7
plot_clr_002	sta $07f7
plot_clr_003	sta $07f7
plot_clr_004	sta $07f7
plot_clr_005	sta $07f7
plot_clr_006	sta $07f7
plot_clr_007	sta $07f7
plot_clr_008	sta $07f7
plot_clr_009	sta $07f7
plot_clr_00a	sta $07f7
plot_clr_00b	sta $07f7
plot_clr_00c	sta $07f7
plot_clr_00d	sta $07f7
plot_clr_00e	sta $07f7
plot_clr_00f	sta $07f7

plot_clr_010	sta $07f7
plot_clr_011	sta $07f7
plot_clr_012	sta $07f7
plot_clr_013	sta $07f7
plot_clr_014	sta $07f7
plot_clr_015	sta $07f7
plot_clr_016	sta $07f7
plot_clr_017	sta $07f7
plot_clr_018	sta $07f7
plot_clr_019	sta $07f7
plot_clr_01a	sta $07f7
plot_clr_01b	sta $07f7
plot_clr_01c	sta $07f7
plot_clr_01d	sta $07f7
plot_clr_01e	sta $07f7
plot_clr_01f	sta $07f7

plot_clr_020	sta $07f7
plot_clr_021	sta $07f7
plot_clr_022	sta $07f7
plot_clr_023	sta $07f7
plot_clr_024	sta $07f7
plot_clr_025	sta $07f7
plot_clr_026	sta $07f7
plot_clr_027	sta $07f7
plot_clr_028	sta $07f7
plot_clr_029	sta $07f7
plot_clr_02a	sta $07f7
plot_clr_02b	sta $07f7
plot_clr_02c	sta $07f7
plot_clr_02d	sta $07f7
plot_clr_02e	sta $07f7
plot_clr_02f	sta $07f7

plot_clr_030	sta $07f7
plot_clr_031	sta $07f7
plot_clr_032	sta $07f7
plot_clr_033	sta $07f7
plot_clr_034	sta $07f7
plot_clr_035	sta $07f7
plot_clr_036	sta $07f7
plot_clr_037	sta $07f7
plot_clr_038	sta $07f7
plot_clr_039	sta $07f7
plot_clr_03a	sta $07f7
plot_clr_03b	sta $07f7
plot_clr_03c	sta $07f7
plot_clr_03d	sta $07f7
plot_clr_03e	sta $07f7
plot_clr_03f	sta $07f7

; Update cycle :: calculate X positions
		lda cos_at_1
		clc
		adc #cos_speed_1
		sta cos_at_1
		tax
		lda cos_at_2
		clc
		adc #cos_speed_2
		sta cos_at_2
		tay
		lda plot_x_cosinus,x
		clc
		adc plot_x_cosinus,y
		sta plot_work_x+$00

!set plot_cnt=$01
!do {
		txa
		clc
		adc #cos_offset_1
		tax
		tya
		clc
		adc #cos_offset_2
		tay
		lda plot_x_cosinus,x
		clc
		adc plot_x_cosinus,y
		sta plot_work_x+plot_cnt

		!set plot_cnt=plot_cnt+$01
} until plot_cnt=$40

; Update cycle :: calculate Y positions
		lda cos_at_3
		clc
		adc #cos_speed_3
		sta cos_at_3
		tay
		lda plot_y_cosinus,y
		sta plot_work_y+$00

!set plot_cnt=$01
!do {
		tya
		clc
		adc #cos_offset_3
		tay
		lda plot_y_cosinus,y
		sta plot_work_y+plot_cnt

		!set plot_cnt=plot_cnt+$01
} until plot_cnt=$40

; Render cycle
		lda plot_work_x+$000
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$000
		sta plot_read_000+$01
		sta plot_write_000+$01
		sta plot_clr_000+$01
		lda plot_col_high,x
		sta plot_read_000+$02
		sta plot_write_000+$02
		sta plot_clr_000+$02
		lda plot_work_x+$000
		and #$07
		tax
plot_read_000	lda plot_ram
		ora plot_pixels,x
plot_write_000	sta plot_ram

		lda plot_work_x+$001
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$001
		sta plot_read_001+$01
		sta plot_write_001+$01
		sta plot_clr_001+$01
		lda plot_col_high,x
		sta plot_read_001+$02
		sta plot_write_001+$02
		sta plot_clr_001+$02
		lda plot_work_x+$001
		and #$07
		tax
plot_read_001	lda plot_ram
		ora plot_pixels,x
plot_write_001	sta plot_ram

		lda plot_work_x+$002
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$002
		sta plot_read_002+$01
		sta plot_write_002+$01
		sta plot_clr_002+$01
		lda plot_col_high,x
		sta plot_read_002+$02
		sta plot_write_002+$02
		sta plot_clr_002+$02
		lda plot_work_x+$002
		and #$07
		tax
plot_read_002	lda plot_ram
		ora plot_pixels,x
plot_write_002	sta plot_ram

		lda plot_work_x+$003
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$003
		sta plot_read_003+$01
		sta plot_write_003+$01
		sta plot_clr_003+$01
		lda plot_col_high,x
		sta plot_read_003+$02
		sta plot_write_003+$02
		sta plot_clr_003+$02
		lda plot_work_x+$003
		and #$07
		tax
plot_read_003	lda plot_ram
		ora plot_pixels,x
plot_write_003	sta plot_ram

		lda plot_work_x+$004
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$004
		sta plot_read_004+$01
		sta plot_write_004+$01
		sta plot_clr_004+$01
		lda plot_col_high,x
		sta plot_read_004+$02
		sta plot_write_004+$02
		sta plot_clr_004+$02
		lda plot_work_x+$004
		and #$07
		tax
plot_read_004	lda plot_ram
		ora plot_pixels,x
plot_write_004	sta plot_ram

		lda plot_work_x+$005
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$005
		sta plot_read_005+$01
		sta plot_write_005+$01
		sta plot_clr_005+$01
		lda plot_col_high,x
		sta plot_read_005+$02
		sta plot_write_005+$02
		sta plot_clr_005+$02
		lda plot_work_x+$005
		and #$07
		tax
plot_read_005	lda plot_ram
		ora plot_pixels,x
plot_write_005	sta plot_ram

		lda plot_work_x+$006
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$006
		sta plot_read_006+$01
		sta plot_write_006+$01
		sta plot_clr_006+$01
		lda plot_col_high,x
		sta plot_read_006+$02
		sta plot_write_006+$02
		sta plot_clr_006+$02
		lda plot_work_x+$006
		and #$07
		tax
plot_read_006	lda plot_ram
		ora plot_pixels,x
plot_write_006	sta plot_ram

		lda plot_work_x+$007
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$007
		sta plot_read_007+$01
		sta plot_write_007+$01
		sta plot_clr_007+$01
		lda plot_col_high,x
		sta plot_read_007+$02
		sta plot_write_007+$02
		sta plot_clr_007+$02
		lda plot_work_x+$007
		and #$07
		tax
plot_read_007	lda plot_ram
		ora plot_pixels,x
plot_write_007	sta plot_ram

lda plot_work_x+$008
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$008
		sta plot_read_008+$01
		sta plot_write_008+$01
		sta plot_clr_008+$01
		lda plot_col_high,x
		sta plot_read_008+$02
		sta plot_write_008+$02
		sta plot_clr_008+$02
		lda plot_work_x+$008
		and #$07
		tax
plot_read_008	lda plot_ram
		ora plot_pixels,x
plot_write_008	sta plot_ram

		lda plot_work_x+$009
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$009
		sta plot_read_009+$01
		sta plot_write_009+$01
		sta plot_clr_009+$01
		lda plot_col_high,x
		sta plot_read_009+$02
		sta plot_write_009+$02
		sta plot_clr_009+$02
		lda plot_work_x+$009
		and #$07
		tax
plot_read_009	lda plot_ram
		ora plot_pixels,x
plot_write_009	sta plot_ram

		lda plot_work_x+$00a
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00a
		sta plot_read_00a+$01
		sta plot_write_00a+$01
		sta plot_clr_00a+$01
		lda plot_col_high,x
		sta plot_read_00a+$02
		sta plot_write_00a+$02
		sta plot_clr_00a+$02
		lda plot_work_x+$00a
		and #$07
		tax
plot_read_00a	lda plot_ram
		ora plot_pixels,x
plot_write_00a	sta plot_ram

		lda plot_work_x+$00b
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00b
		sta plot_read_00b+$01
		sta plot_write_00b+$01
		sta plot_clr_00b+$01
		lda plot_col_high,x
		sta plot_read_00b+$02
		sta plot_write_00b+$02
		sta plot_clr_00b+$02
		lda plot_work_x+$00b
		and #$07
		tax
plot_read_00b	lda plot_ram
		ora plot_pixels,x
plot_write_00b	sta plot_ram

		lda plot_work_x+$00c
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00c
		sta plot_read_00c+$01
		sta plot_write_00c+$01
		sta plot_clr_00c+$01
		lda plot_col_high,x
		sta plot_read_00c+$02
		sta plot_write_00c+$02
		sta plot_clr_00c+$02
		lda plot_work_x+$00c
		and #$07
		tax
plot_read_00c	lda plot_ram
		ora plot_pixels,x
plot_write_00c	sta plot_ram

		lda plot_work_x+$00d
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00d
		sta plot_read_00d+$01
		sta plot_write_00d+$01
		sta plot_clr_00d+$01
		lda plot_col_high,x
		sta plot_read_00d+$02
		sta plot_write_00d+$02
		sta plot_clr_00d+$02
		lda plot_work_x+$00d
		and #$07
		tax
plot_read_00d	lda plot_ram
		ora plot_pixels,x
plot_write_00d	sta plot_ram

		lda plot_work_x+$00e
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00e
		sta plot_read_00e+$01
		sta plot_write_00e+$01
		sta plot_clr_00e+$01
		lda plot_col_high,x
		sta plot_read_00e+$02
		sta plot_write_00e+$02
		sta plot_clr_00e+$02
		lda plot_work_x+$00e
		and #$07
		tax
plot_read_00e	lda plot_ram
		ora plot_pixels,x
plot_write_00e	sta plot_ram

		lda plot_work_x+$00f
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$00f
		sta plot_read_00f+$01
		sta plot_write_00f+$01
		sta plot_clr_00f+$01
		lda plot_col_high,x
		sta plot_read_00f+$02
		sta plot_write_00f+$02
		sta plot_clr_00f+$02
		lda plot_work_x+$00f
		and #$07
		tax
plot_read_00f	lda plot_ram
		ora plot_pixels,x
plot_write_00f	sta plot_ram

		lda plot_work_x+$010
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$010
		sta plot_read_010+$01
		sta plot_write_010+$01
		sta plot_clr_010+$01
		lda plot_col_high,x
		sta plot_read_010+$02
		sta plot_write_010+$02
		sta plot_clr_010+$02
		lda plot_work_x+$010
		and #$07
		tax
plot_read_010	lda plot_ram
		ora plot_pixels,x
plot_write_010	sta plot_ram

		lda plot_work_x+$011
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$011
		sta plot_read_011+$01
		sta plot_write_011+$01
		sta plot_clr_011+$01
		lda plot_col_high,x
		sta plot_read_011+$02
		sta plot_write_011+$02
		sta plot_clr_011+$02
		lda plot_work_x+$011
		and #$07
		tax
plot_read_011	lda plot_ram
		ora plot_pixels,x
plot_write_011	sta plot_ram

		lda plot_work_x+$012
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$012
		sta plot_read_012+$01
		sta plot_write_012+$01
		sta plot_clr_012+$01
		lda plot_col_high,x
		sta plot_read_012+$02
		sta plot_write_012+$02
		sta plot_clr_012+$02
		lda plot_work_x+$012
		and #$07
		tax
plot_read_012	lda plot_ram
		ora plot_pixels,x
plot_write_012	sta plot_ram

		lda plot_work_x+$013
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$013
		sta plot_read_013+$01
		sta plot_write_013+$01
		sta plot_clr_013+$01
		lda plot_col_high,x
		sta plot_read_013+$02
		sta plot_write_013+$02
		sta plot_clr_013+$02
		lda plot_work_x+$013
		and #$07
		tax
plot_read_013	lda plot_ram
		ora plot_pixels,x
plot_write_013	sta plot_ram

		lda plot_work_x+$014
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$014
		sta plot_read_014+$01
		sta plot_write_014+$01
		sta plot_clr_014+$01
		lda plot_col_high,x
		sta plot_read_014+$02
		sta plot_write_014+$02
		sta plot_clr_014+$02
		lda plot_work_x+$014
		and #$07
		tax
plot_read_014	lda plot_ram
		ora plot_pixels,x
plot_write_014	sta plot_ram

		lda plot_work_x+$015
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$015
		sta plot_read_015+$01
		sta plot_write_015+$01
		sta plot_clr_015+$01
		lda plot_col_high,x
		sta plot_read_015+$02
		sta plot_write_015+$02
		sta plot_clr_015+$02
		lda plot_work_x+$015
		and #$07
		tax
plot_read_015	lda plot_ram
		ora plot_pixels,x
plot_write_015	sta plot_ram

		lda plot_work_x+$016
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$016
		sta plot_read_016+$01
		sta plot_write_016+$01
		sta plot_clr_016+$01
		lda plot_col_high,x
		sta plot_read_016+$02
		sta plot_write_016+$02
		sta plot_clr_016+$02
		lda plot_work_x+$016
		and #$07
		tax
plot_read_016	lda plot_ram
		ora plot_pixels,x
plot_write_016	sta plot_ram

		lda plot_work_x+$017
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$017
		sta plot_read_017+$01
		sta plot_write_017+$01
		sta plot_clr_017+$01
		lda plot_col_high,x
		sta plot_read_017+$02
		sta plot_write_017+$02
		sta plot_clr_017+$02
		lda plot_work_x+$017
		and #$07
		tax
plot_read_017	lda plot_ram
		ora plot_pixels,x
plot_write_017	sta plot_ram

		lda plot_work_x+$018
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$018
		sta plot_read_018+$01
		sta plot_write_018+$01
		sta plot_clr_018+$01
		lda plot_col_high,x
		sta plot_read_018+$02
		sta plot_write_018+$02
		sta plot_clr_018+$02
		lda plot_work_x+$018
		and #$07
		tax
plot_read_018	lda plot_ram
		ora plot_pixels,x
plot_write_018	sta plot_ram

		lda plot_work_x+$019
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$019
		sta plot_read_019+$01
		sta plot_write_019+$01
		sta plot_clr_019+$01
		lda plot_col_high,x
		sta plot_read_019+$02
		sta plot_write_019+$02
		sta plot_clr_019+$02
		lda plot_work_x+$019
		and #$07
		tax
plot_read_019	lda plot_ram
		ora plot_pixels,x
plot_write_019	sta plot_ram

		lda plot_work_x+$01a
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01a
		sta plot_read_01a+$01
		sta plot_write_01a+$01
		sta plot_clr_01a+$01
		lda plot_col_high,x
		sta plot_read_01a+$02
		sta plot_write_01a+$02
		sta plot_clr_01a+$02
		lda plot_work_x+$01a
		and #$07
		tax
plot_read_01a	lda plot_ram
		ora plot_pixels,x
plot_write_01a	sta plot_ram

		lda plot_work_x+$01b
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01b
		sta plot_read_01b+$01
		sta plot_write_01b+$01
		sta plot_clr_01b+$01
		lda plot_col_high,x
		sta plot_read_01b+$02
		sta plot_write_01b+$02
		sta plot_clr_01b+$02
		lda plot_work_x+$01b
		and #$07
		tax
plot_read_01b	lda plot_ram
		ora plot_pixels,x
plot_write_01b	sta plot_ram

		lda plot_work_x+$01c
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01c
		sta plot_read_01c+$01
		sta plot_write_01c+$01
		sta plot_clr_01c+$01
		lda plot_col_high,x
		sta plot_read_01c+$02
		sta plot_write_01c+$02
		sta plot_clr_01c+$02
		lda plot_work_x+$01c
		and #$07
		tax
plot_read_01c	lda plot_ram
		ora plot_pixels,x
plot_write_01c	sta plot_ram

		lda plot_work_x+$01d
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01d
		sta plot_read_01d+$01
		sta plot_write_01d+$01
		sta plot_clr_01d+$01
		lda plot_col_high,x
		sta plot_read_01d+$02
		sta plot_write_01d+$02
		sta plot_clr_01d+$02
		lda plot_work_x+$01d
		and #$07
		tax
plot_read_01d	lda plot_ram
		ora plot_pixels,x
plot_write_01d	sta plot_ram

		lda plot_work_x+$01e
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01e
		sta plot_read_01e+$01
		sta plot_write_01e+$01
		sta plot_clr_01e+$01
		lda plot_col_high,x
		sta plot_read_01e+$02
		sta plot_write_01e+$02
		sta plot_clr_01e+$02
		lda plot_work_x+$01e
		and #$07
		tax
plot_read_01e	lda plot_ram
		ora plot_pixels,x
plot_write_01e	sta plot_ram

		lda plot_work_x+$01f
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$01f
		sta plot_read_01f+$01
		sta plot_write_01f+$01
		sta plot_clr_01f+$01
		lda plot_col_high,x
		sta plot_read_01f+$02
		sta plot_write_01f+$02
		sta plot_clr_01f+$02
		lda plot_work_x+$01f
		and #$07
		tax
plot_read_01f	lda plot_ram
		ora plot_pixels,x
plot_write_01f	sta plot_ram

		lda plot_work_x+$020
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$020
		sta plot_read_020+$01
		sta plot_write_020+$01
		sta plot_clr_020+$01
		lda plot_col_high,x
		sta plot_read_020+$02
		sta plot_write_020+$02
		sta plot_clr_020+$02
		lda plot_work_x+$020
		and #$07
		tax
plot_read_020	lda plot_ram
		ora plot_pixels,x
plot_write_020	sta plot_ram

		lda plot_work_x+$021
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$021
		sta plot_read_021+$01
		sta plot_write_021+$01
		sta plot_clr_021+$01
		lda plot_col_high,x
		sta plot_read_021+$02
		sta plot_write_021+$02
		sta plot_clr_021+$02
		lda plot_work_x+$021
		and #$07
		tax
plot_read_021	lda plot_ram
		ora plot_pixels,x
plot_write_021	sta plot_ram

		lda plot_work_x+$022
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$022
		sta plot_read_022+$01
		sta plot_write_022+$01
		sta plot_clr_022+$01
		lda plot_col_high,x
		sta plot_read_022+$02
		sta plot_write_022+$02
		sta plot_clr_022+$02
		lda plot_work_x+$022
		and #$07
		tax
plot_read_022	lda plot_ram
		ora plot_pixels,x
plot_write_022	sta plot_ram

		lda plot_work_x+$023
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$023
		sta plot_read_023+$01
		sta plot_write_023+$01
		sta plot_clr_023+$01
		lda plot_col_high,x
		sta plot_read_023+$02
		sta plot_write_023+$02
		sta plot_clr_023+$02
		lda plot_work_x+$023
		and #$07
		tax
plot_read_023	lda plot_ram
		ora plot_pixels,x
plot_write_023	sta plot_ram

		lda plot_work_x+$024
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$024
		sta plot_read_024+$01
		sta plot_write_024+$01
		sta plot_clr_024+$01
		lda plot_col_high,x
		sta plot_read_024+$02
		sta plot_write_024+$02
		sta plot_clr_024+$02
		lda plot_work_x+$024
		and #$07
		tax
plot_read_024	lda plot_ram
		ora plot_pixels,x
plot_write_024	sta plot_ram

		lda plot_work_x+$025
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$025
		sta plot_read_025+$01
		sta plot_write_025+$01
		sta plot_clr_025+$01
		lda plot_col_high,x
		sta plot_read_025+$02
		sta plot_write_025+$02
		sta plot_clr_025+$02
		lda plot_work_x+$025
		and #$07
		tax
plot_read_025	lda plot_ram
		ora plot_pixels,x
plot_write_025	sta plot_ram

		lda plot_work_x+$026
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$026
		sta plot_read_026+$01
		sta plot_write_026+$01
		sta plot_clr_026+$01
		lda plot_col_high,x
		sta plot_read_026+$02
		sta plot_write_026+$02
		sta plot_clr_026+$02
		lda plot_work_x+$026
		and #$07
		tax
plot_read_026	lda plot_ram
		ora plot_pixels,x
plot_write_026	sta plot_ram

		lda plot_work_x+$027
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$027
		sta plot_read_027+$01
		sta plot_write_027+$01
		sta plot_clr_027+$01
		lda plot_col_high,x
		sta plot_read_027+$02
		sta plot_write_027+$02
		sta plot_clr_027+$02
		lda plot_work_x+$027
		and #$07
		tax
plot_read_027	lda plot_ram
		ora plot_pixels,x
plot_write_027	sta plot_ram

		lda plot_work_x+$028
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$028
		sta plot_read_028+$01
		sta plot_write_028+$01
		sta plot_clr_028+$01
		lda plot_col_high,x
		sta plot_read_028+$02
		sta plot_write_028+$02
		sta plot_clr_028+$02
		lda plot_work_x+$028
		and #$07
		tax
plot_read_028	lda plot_ram
		ora plot_pixels,x
plot_write_028	sta plot_ram

		lda plot_work_x+$029
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$029
		sta plot_read_029+$01
		sta plot_write_029+$01
		sta plot_clr_029+$01
		lda plot_col_high,x
		sta plot_read_029+$02
		sta plot_write_029+$02
		sta plot_clr_029+$02
		lda plot_work_x+$029
		and #$07
		tax
plot_read_029	lda plot_ram
		ora plot_pixels,x
plot_write_029	sta plot_ram

		lda plot_work_x+$02a
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02a
		sta plot_read_02a+$01
		sta plot_write_02a+$01
		sta plot_clr_02a+$01
		lda plot_col_high,x
		sta plot_read_02a+$02
		sta plot_write_02a+$02
		sta plot_clr_02a+$02
		lda plot_work_x+$02a
		and #$07
		tax
plot_read_02a	lda plot_ram
		ora plot_pixels,x
plot_write_02a	sta plot_ram

		lda plot_work_x+$02b
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02b
		sta plot_read_02b+$01
		sta plot_write_02b+$01
		sta plot_clr_02b+$01
		lda plot_col_high,x
		sta plot_read_02b+$02
		sta plot_write_02b+$02
		sta plot_clr_02b+$02
		lda plot_work_x+$02b
		and #$07
		tax
plot_read_02b	lda plot_ram
		ora plot_pixels,x
plot_write_02b	sta plot_ram

		lda plot_work_x+$02c
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02c
		sta plot_read_02c+$01
		sta plot_write_02c+$01
		sta plot_clr_02c+$01
		lda plot_col_high,x
		sta plot_read_02c+$02
		sta plot_write_02c+$02
		sta plot_clr_02c+$02
		lda plot_work_x+$02c
		and #$07
		tax
plot_read_02c	lda plot_ram
		ora plot_pixels,x
plot_write_02c	sta plot_ram

		lda plot_work_x+$02d
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02d
		sta plot_read_02d+$01
		sta plot_write_02d+$01
		sta plot_clr_02d+$01
		lda plot_col_high,x
		sta plot_read_02d+$02
		sta plot_write_02d+$02
		sta plot_clr_02d+$02
		lda plot_work_x+$02d
		and #$07
		tax
plot_read_02d	lda plot_ram
		ora plot_pixels,x
plot_write_02d	sta plot_ram

		lda plot_work_x+$02e
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02e
		sta plot_read_02e+$01
		sta plot_write_02e+$01
		sta plot_clr_02e+$01
		lda plot_col_high,x
		sta plot_read_02e+$02
		sta plot_write_02e+$02
		sta plot_clr_02e+$02
		lda plot_work_x+$02e
		and #$07
		tax
plot_read_02e	lda plot_ram
		ora plot_pixels,x
plot_write_02e	sta plot_ram

		lda plot_work_x+$02f
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$02f
		sta plot_read_02f+$01
		sta plot_write_02f+$01
		sta plot_clr_02f+$01
		lda plot_col_high,x
		sta plot_read_02f+$02
		sta plot_write_02f+$02
		sta plot_clr_02f+$02
		lda plot_work_x+$02f
		and #$07
		tax
plot_read_02f	lda plot_ram
		ora plot_pixels,x
plot_write_02f	sta plot_ram

		lda plot_work_x+$030
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$030
		sta plot_read_030+$01
		sta plot_write_030+$01
		sta plot_clr_030+$01
		lda plot_col_high,x
		sta plot_read_030+$02
		sta plot_write_030+$02
		sta plot_clr_030+$02
		lda plot_work_x+$030
		and #$07
		tax
plot_read_030	lda plot_ram
		ora plot_pixels,x
plot_write_030	sta plot_ram

		lda plot_work_x+$031
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$031
		sta plot_read_031+$01
		sta plot_write_031+$01
		sta plot_clr_031+$01
		lda plot_col_high,x
		sta plot_read_031+$02
		sta plot_write_031+$02
		sta plot_clr_031+$02
		lda plot_work_x+$031
		and #$07
		tax
plot_read_031	lda plot_ram
		ora plot_pixels,x
plot_write_031	sta plot_ram

		lda plot_work_x+$032
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$032
		sta plot_read_032+$01
		sta plot_write_032+$01
		sta plot_clr_032+$01
		lda plot_col_high,x
		sta plot_read_032+$02
		sta plot_write_032+$02
		sta plot_clr_032+$02
		lda plot_work_x+$032
		and #$07
		tax
plot_read_032	lda plot_ram
		ora plot_pixels,x
plot_write_032	sta plot_ram

		lda plot_work_x+$033
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$033
		sta plot_read_033+$01
		sta plot_write_033+$01
		sta plot_clr_033+$01
		lda plot_col_high,x
		sta plot_read_033+$02
		sta plot_write_033+$02
		sta plot_clr_033+$02
		lda plot_work_x+$033
		and #$07
		tax
plot_read_033	lda plot_ram
		ora plot_pixels,x
plot_write_033	sta plot_ram

		lda plot_work_x+$034
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$034
		sta plot_read_034+$01
		sta plot_write_034+$01
		sta plot_clr_034+$01
		lda plot_col_high,x
		sta plot_read_034+$02
		sta plot_write_034+$02
		sta plot_clr_034+$02
		lda plot_work_x+$034
		and #$07
		tax
plot_read_034	lda plot_ram
		ora plot_pixels,x
plot_write_034	sta plot_ram

		lda plot_work_x+$035
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$035
		sta plot_read_035+$01
		sta plot_write_035+$01
		sta plot_clr_035+$01
		lda plot_col_high,x
		sta plot_read_035+$02
		sta plot_write_035+$02
		sta plot_clr_035+$02
		lda plot_work_x+$035
		and #$07
		tax
plot_read_035	lda plot_ram
		ora plot_pixels,x
plot_write_035	sta plot_ram

		lda plot_work_x+$036
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$036
		sta plot_read_036+$01
		sta plot_write_036+$01
		sta plot_clr_036+$01
		lda plot_col_high,x
		sta plot_read_036+$02
		sta plot_write_036+$02
		sta plot_clr_036+$02
		lda plot_work_x+$036
		and #$07
		tax
plot_read_036	lda plot_ram
		ora plot_pixels,x
plot_write_036	sta plot_ram

		lda plot_work_x+$037
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$037
		sta plot_read_037+$01
		sta plot_write_037+$01
		sta plot_clr_037+$01
		lda plot_col_high,x
		sta plot_read_037+$02
		sta plot_write_037+$02
		sta plot_clr_037+$02
		lda plot_work_x+$037
		and #$07
		tax
plot_read_037	lda plot_ram
		ora plot_pixels,x
plot_write_037	sta plot_ram

		lda plot_work_x+$038
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$038
		sta plot_read_038+$01
		sta plot_write_038+$01
		sta plot_clr_038+$01
		lda plot_col_high,x
		sta plot_read_038+$02
		sta plot_write_038+$02
		sta plot_clr_038+$02
		lda plot_work_x+$038
		and #$07
		tax
plot_read_038	lda plot_ram
		ora plot_pixels,x
plot_write_038	sta plot_ram

		lda plot_work_x+$039
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$039
		sta plot_read_039+$01
		sta plot_write_039+$01
		sta plot_clr_039+$01
		lda plot_col_high,x
		sta plot_read_039+$02
		sta plot_write_039+$02
		sta plot_clr_039+$02
		lda plot_work_x+$039
		and #$07
		tax
plot_read_039	lda plot_ram
		ora plot_pixels,x
plot_write_039	sta plot_ram

		lda plot_work_x+$03a
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03a
		sta plot_read_03a+$01
		sta plot_write_03a+$01
		sta plot_clr_03a+$01
		lda plot_col_high,x
		sta plot_read_03a+$02
		sta plot_write_03a+$02
		sta plot_clr_03a+$02
		lda plot_work_x+$03a
		and #$07
		tax
plot_read_03a	lda plot_ram
		ora plot_pixels,x
plot_write_03a	sta plot_ram

		lda plot_work_x+$03b
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03b
		sta plot_read_03b+$01
		sta plot_write_03b+$01
		sta plot_clr_03b+$01
		lda plot_col_high,x
		sta plot_read_03b+$02
		sta plot_write_03b+$02
		sta plot_clr_03b+$02
		lda plot_work_x+$03b
		and #$07
		tax
plot_read_03b	lda plot_ram
		ora plot_pixels,x
plot_write_03b	sta plot_ram

		lda plot_work_x+$03c
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03c
		sta plot_read_03c+$01
		sta plot_write_03c+$01
		sta plot_clr_03c+$01
		lda plot_col_high,x
		sta plot_read_03c+$02
		sta plot_write_03c+$02
		sta plot_clr_03c+$02
		lda plot_work_x+$03c
		and #$07
		tax
plot_read_03c	lda plot_ram
		ora plot_pixels,x
plot_write_03c	sta plot_ram

		lda plot_work_x+$03d
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03d
		sta plot_read_03d+$01
		sta plot_write_03d+$01
		sta plot_clr_03d+$01
		lda plot_col_high,x
		sta plot_read_03d+$02
		sta plot_write_03d+$02
		sta plot_clr_03d+$02
		lda plot_work_x+$03d
		and #$07
		tax
plot_read_03d	lda plot_ram
		ora plot_pixels,x
plot_write_03d	sta plot_ram

		lda plot_work_x+$03e
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03e
		sta plot_read_03e+$01
		sta plot_write_03e+$01
		sta plot_clr_03e+$01
		lda plot_col_high,x
		sta plot_read_03e+$02
		sta plot_write_03e+$02
		sta plot_clr_03e+$02
		lda plot_work_x+$03e
		and #$07
		tax
plot_read_03e	lda plot_ram
		ora plot_pixels,x
plot_write_03e	sta plot_ram

		lda plot_work_x+$03f
		lsr
		lsr
		lsr
		tax
		lda plot_col_low,x
		clc
		adc plot_work_y+$03f
		sta plot_read_03f+$01
		sta plot_write_03f+$01
		sta plot_clr_03f+$01
		lda plot_col_high,x
		sta plot_read_03f+$02
		sta plot_write_03f+$02
		sta plot_clr_03f+$02
		lda plot_work_x+$03f
		and #$07
		tax
plot_read_03f	lda plot_ram
		ora plot_pixels,x
plot_write_03f	sta plot_ram

		rts