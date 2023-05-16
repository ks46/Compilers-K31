@.subtype_vtable = global [0 x i8*] []
@.Receiver_vtable = global [8 x i8*] [i8* bitcast (i1 (i8*,i8*)* @Receiver.A to i8*), i8* bitcast (i1 (i8*,i8*)* @Receiver.B to i8*), i8* bitcast (i1 (i8*,i8*)* @Receiver.C to i8*), i8* bitcast (i1 (i8*,i8*)* @Receiver.D to i8*), i8* bitcast (i8* (i8*)* @Receiver.alloc_B_for_A to i8*), i8* bitcast (i8* (i8*)* @Receiver.alloc_C_for_A to i8*), i8* bitcast (i8* (i8*)* @Receiver.alloc_D_for_A to i8*), i8* bitcast (i8* (i8*)* @Receiver.alloc_D_for_B to i8*)]
@.A_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @A.bar to i8*), i8* bitcast (i32 (i8*)* @A.test to i8*)]
@.B_vtable = global [5 x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @B.bar to i8*), i8* bitcast (i32 (i8*)* @A.test to i8*), i8* bitcast (i32 (i8*)* @B.not_overriden to i8*), i8* bitcast (i32 (i8*)* @B.another to i8*)]
@.C_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @C.bar to i8*), i8* bitcast (i32 (i8*)* @A.test to i8*)]
@.D_vtable = global [6 x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @B.bar to i8*), i8* bitcast (i32 (i8*)* @A.test to i8*), i8* bitcast (i32 (i8*)* @B.not_overriden to i8*), i8* bitcast (i32 (i8*)* @D.another to i8*), i8* bitcast (i32 (i8*)* @D.stef to i8*)]


declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
define void @print_int(i32 %i) {
	%_str = bitcast [4 x i8]* @_cint to i8*
	call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
	ret void
}

define void @throw_oob() {
	%_str = bitcast [15 x i8]* @_cOOB to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}

define i32 @main() {
	%dummy = alloca i1

	%a = alloca i8*

	%b = alloca i8*

	%c = alloca i8*

	%d = alloca i8*

	%separator = alloca i32

	%cls_separator = alloca i32

	store i32 1111111111, i32* %separator

	store i32 333333333, i32* %cls_separator

	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	; Receiver.A : 0
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i1 (i8*,i8*)*
	%_9 = call i8* @calloc(i32 1, i32 8)
	%_10 = bitcast i8* %_9 to i8***
	%_11 = getelementptr [3 x i8*], [3 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_11, i8*** %_10
	%_8 = call i1 %_7(i8* %_0, i8* %_9)
	store i1 %_8, i1* %dummy

	%_12 = load i32, i32* %separator
	call void (i32) @print_int(i32 %_12)

	%_13 = call i8* @calloc(i32 1, i32 8)
	%_14 = bitcast i8* %_13 to i8***
	%_15 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_15, i8*** %_14
	; Receiver.A : 0
	%_16 = bitcast i8* %_13 to i8***
	%_17 = load i8**, i8*** %_16
	%_18 = getelementptr i8*, i8** %_17, i32 0
	%_19 = load i8*, i8** %_18
	%_20 = bitcast i8* %_19 to i1 (i8*,i8*)*
	%_22 = call i8* @calloc(i32 1, i32 8)
	%_23 = bitcast i8* %_22 to i8***
	%_24 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_24, i8*** %_23
	; Receiver.alloc_B_for_A : 4
	%_25 = bitcast i8* %_22 to i8***
	%_26 = load i8**, i8*** %_25
	%_27 = getelementptr i8*, i8** %_26, i32 4
	%_28 = load i8*, i8** %_27
	%_29 = bitcast i8* %_28 to i8* (i8*)*
	%_30 = call i8* %_29(i8* %_22)
	%_21 = call i1 %_20(i8* %_13, i8* %_30)
	store i1 %_21, i1* %dummy

	%_31 = load i32, i32* %separator
	call void (i32) @print_int(i32 %_31)

	%_32 = call i8* @calloc(i32 1, i32 8)
	%_33 = bitcast i8* %_32 to i8***
	%_34 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_34, i8*** %_33
	; Receiver.A : 0
	%_35 = bitcast i8* %_32 to i8***
	%_36 = load i8**, i8*** %_35
	%_37 = getelementptr i8*, i8** %_36, i32 0
	%_38 = load i8*, i8** %_37
	%_39 = bitcast i8* %_38 to i1 (i8*,i8*)*
	%_41 = call i8* @calloc(i32 1, i32 8)
	%_42 = bitcast i8* %_41 to i8***
	%_43 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_43, i8*** %_42
	; Receiver.alloc_C_for_A : 5
	%_44 = bitcast i8* %_41 to i8***
	%_45 = load i8**, i8*** %_44
	%_46 = getelementptr i8*, i8** %_45, i32 5
	%_47 = load i8*, i8** %_46
	%_48 = bitcast i8* %_47 to i8* (i8*)*
	%_49 = call i8* %_48(i8* %_41)
	%_40 = call i1 %_39(i8* %_32, i8* %_49)
	store i1 %_40, i1* %dummy

	%_50 = load i32, i32* %separator
	call void (i32) @print_int(i32 %_50)

	%_51 = call i8* @calloc(i32 1, i32 8)
	%_52 = bitcast i8* %_51 to i8***
	%_53 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_53, i8*** %_52
	; Receiver.A : 0
	%_54 = bitcast i8* %_51 to i8***
	%_55 = load i8**, i8*** %_54
	%_56 = getelementptr i8*, i8** %_55, i32 0
	%_57 = load i8*, i8** %_56
	%_58 = bitcast i8* %_57 to i1 (i8*,i8*)*
	%_60 = call i8* @calloc(i32 1, i32 8)
	%_61 = bitcast i8* %_60 to i8***
	%_62 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_62, i8*** %_61
	; Receiver.alloc_D_for_A : 6
	%_63 = bitcast i8* %_60 to i8***
	%_64 = load i8**, i8*** %_63
	%_65 = getelementptr i8*, i8** %_64, i32 6
	%_66 = load i8*, i8** %_65
	%_67 = bitcast i8* %_66 to i8* (i8*)*
	%_68 = call i8* %_67(i8* %_60)
	%_59 = call i1 %_58(i8* %_51, i8* %_68)
	store i1 %_59, i1* %dummy

	%_69 = load i32, i32* %cls_separator
	call void (i32) @print_int(i32 %_69)

	%_70 = call i8* @calloc(i32 1, i32 8)
	%_71 = bitcast i8* %_70 to i8***
	%_72 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_72, i8*** %_71
	; Receiver.B : 1
	%_73 = bitcast i8* %_70 to i8***
	%_74 = load i8**, i8*** %_73
	%_75 = getelementptr i8*, i8** %_74, i32 1
	%_76 = load i8*, i8** %_75
	%_77 = bitcast i8* %_76 to i1 (i8*,i8*)*
	%_79 = call i8* @calloc(i32 1, i32 8)
	%_80 = bitcast i8* %_79 to i8***
	%_81 = getelementptr [5 x i8*], [5 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_81, i8*** %_80
	%_78 = call i1 %_77(i8* %_70, i8* %_79)
	store i1 %_78, i1* %dummy

	%_82 = load i32, i32* %separator
	call void (i32) @print_int(i32 %_82)

	%_83 = call i8* @calloc(i32 1, i32 8)
	%_84 = bitcast i8* %_83 to i8***
	%_85 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_85, i8*** %_84
	; Receiver.B : 1
	%_86 = bitcast i8* %_83 to i8***
	%_87 = load i8**, i8*** %_86
	%_88 = getelementptr i8*, i8** %_87, i32 1
	%_89 = load i8*, i8** %_88
	%_90 = bitcast i8* %_89 to i1 (i8*,i8*)*
	%_92 = call i8* @calloc(i32 1, i32 8)
	%_93 = bitcast i8* %_92 to i8***
	%_94 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_94, i8*** %_93
	; Receiver.alloc_D_for_B : 7
	%_95 = bitcast i8* %_92 to i8***
	%_96 = load i8**, i8*** %_95
	%_97 = getelementptr i8*, i8** %_96, i32 7
	%_98 = load i8*, i8** %_97
	%_99 = bitcast i8* %_98 to i8* (i8*)*
	%_100 = call i8* %_99(i8* %_92)
	%_91 = call i1 %_90(i8* %_83, i8* %_100)
	store i1 %_91, i1* %dummy

	%_101 = load i32, i32* %cls_separator
	call void (i32) @print_int(i32 %_101)

	%_102 = call i8* @calloc(i32 1, i32 8)
	%_103 = bitcast i8* %_102 to i8***
	%_104 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_104, i8*** %_103
	; Receiver.C : 2
	%_105 = bitcast i8* %_102 to i8***
	%_106 = load i8**, i8*** %_105
	%_107 = getelementptr i8*, i8** %_106, i32 2
	%_108 = load i8*, i8** %_107
	%_109 = bitcast i8* %_108 to i1 (i8*,i8*)*
	%_111 = call i8* @calloc(i32 1, i32 8)
	%_112 = bitcast i8* %_111 to i8***
	%_113 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
	store i8** %_113, i8*** %_112
	%_110 = call i1 %_109(i8* %_102, i8* %_111)
	store i1 %_110, i1* %dummy

	%_114 = load i32, i32* %cls_separator
	call void (i32) @print_int(i32 %_114)

	%_115 = call i8* @calloc(i32 1, i32 8)
	%_116 = bitcast i8* %_115 to i8***
	%_117 = getelementptr [8 x i8*], [8 x i8*]* @.Receiver_vtable, i32 0, i32 0
	store i8** %_117, i8*** %_116
	; Receiver.D : 3
	%_118 = bitcast i8* %_115 to i8***
	%_119 = load i8**, i8*** %_118
	%_120 = getelementptr i8*, i8** %_119, i32 3
	%_121 = load i8*, i8** %_120
	%_122 = bitcast i8* %_121 to i1 (i8*,i8*)*
	%_124 = call i8* @calloc(i32 1, i32 8)
	%_125 = bitcast i8* %_124 to i8***
	%_126 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
	store i8** %_126, i8*** %_125
	%_123 = call i1 %_122(i8* %_115, i8* %_124)
	store i1 %_123, i1* %dummy

	ret i32 0
}

define i1 @Receiver.A(i8* %this, i8* %.a) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%_0 = load i8*, i8** %a
	; A.foo : 0
	%_1 = bitcast i8* %_0 to i8***
	%_2 = load i8**, i8*** %_1
	%_3 = getelementptr i8*, i8** %_2, i32 0
	%_4 = load i8*, i8** %_3
	%_5 = bitcast i8* %_4 to i32 (i8*)*
	%_6 = call i32 %_5(i8* %_0)
	call void (i32) @print_int(i32 %_6)

	%_7 = load i8*, i8** %a
	; A.bar : 1
	%_8 = bitcast i8* %_7 to i8***
	%_9 = load i8**, i8*** %_8
	%_10 = getelementptr i8*, i8** %_9, i32 1
	%_11 = load i8*, i8** %_10
	%_12 = bitcast i8* %_11 to i32 (i8*)*
	%_13 = call i32 %_12(i8* %_7)
	call void (i32) @print_int(i32 %_13)

	%_14 = load i8*, i8** %a
	; A.test : 2
	%_15 = bitcast i8* %_14 to i8***
	%_16 = load i8**, i8*** %_15
	%_17 = getelementptr i8*, i8** %_16, i32 2
	%_18 = load i8*, i8** %_17
	%_19 = bitcast i8* %_18 to i32 (i8*)*
	%_20 = call i32 %_19(i8* %_14)
	call void (i32) @print_int(i32 %_20)

	ret i1 1
}

define i1 @Receiver.B(i8* %this, i8* %.b) {
	%b = alloca i8*
	store i8* %.b, i8** %b
	%_0 = load i8*, i8** %b
	; B.foo : 0
	%_1 = bitcast i8* %_0 to i8***
	%_2 = load i8**, i8*** %_1
	%_3 = getelementptr i8*, i8** %_2, i32 0
	%_4 = load i8*, i8** %_3
	%_5 = bitcast i8* %_4 to i32 (i8*)*
	%_6 = call i32 %_5(i8* %_0)
	call void (i32) @print_int(i32 %_6)

	%_7 = load i8*, i8** %b
	; B.bar : 1
	%_8 = bitcast i8* %_7 to i8***
	%_9 = load i8**, i8*** %_8
	%_10 = getelementptr i8*, i8** %_9, i32 1
	%_11 = load i8*, i8** %_10
	%_12 = bitcast i8* %_11 to i32 (i8*)*
	%_13 = call i32 %_12(i8* %_7)
	call void (i32) @print_int(i32 %_13)

	%_14 = load i8*, i8** %b
	; B.test : 2
	%_15 = bitcast i8* %_14 to i8***
	%_16 = load i8**, i8*** %_15
	%_17 = getelementptr i8*, i8** %_16, i32 2
	%_18 = load i8*, i8** %_17
	%_19 = bitcast i8* %_18 to i32 (i8*)*
	%_20 = call i32 %_19(i8* %_14)
	call void (i32) @print_int(i32 %_20)

	%_21 = load i8*, i8** %b
	; B.not_overriden : 3
	%_22 = bitcast i8* %_21 to i8***
	%_23 = load i8**, i8*** %_22
	%_24 = getelementptr i8*, i8** %_23, i32 3
	%_25 = load i8*, i8** %_24
	%_26 = bitcast i8* %_25 to i32 (i8*)*
	%_27 = call i32 %_26(i8* %_21)
	call void (i32) @print_int(i32 %_27)

	%_28 = load i8*, i8** %b
	; B.another : 4
	%_29 = bitcast i8* %_28 to i8***
	%_30 = load i8**, i8*** %_29
	%_31 = getelementptr i8*, i8** %_30, i32 4
	%_32 = load i8*, i8** %_31
	%_33 = bitcast i8* %_32 to i32 (i8*)*
	%_34 = call i32 %_33(i8* %_28)
	call void (i32) @print_int(i32 %_34)

	ret i1 1
}

define i1 @Receiver.C(i8* %this, i8* %.c) {
	%c = alloca i8*
	store i8* %.c, i8** %c
	%_0 = load i8*, i8** %c
	; C.foo : 0
	%_1 = bitcast i8* %_0 to i8***
	%_2 = load i8**, i8*** %_1
	%_3 = getelementptr i8*, i8** %_2, i32 0
	%_4 = load i8*, i8** %_3
	%_5 = bitcast i8* %_4 to i32 (i8*)*
	%_6 = call i32 %_5(i8* %_0)
	call void (i32) @print_int(i32 %_6)

	%_7 = load i8*, i8** %c
	; C.bar : 1
	%_8 = bitcast i8* %_7 to i8***
	%_9 = load i8**, i8*** %_8
	%_10 = getelementptr i8*, i8** %_9, i32 1
	%_11 = load i8*, i8** %_10
	%_12 = bitcast i8* %_11 to i32 (i8*)*
	%_13 = call i32 %_12(i8* %_7)
	call void (i32) @print_int(i32 %_13)

	%_14 = load i8*, i8** %c
	; C.test : 2
	%_15 = bitcast i8* %_14 to i8***
	%_16 = load i8**, i8*** %_15
	%_17 = getelementptr i8*, i8** %_16, i32 2
	%_18 = load i8*, i8** %_17
	%_19 = bitcast i8* %_18 to i32 (i8*)*
	%_20 = call i32 %_19(i8* %_14)
	call void (i32) @print_int(i32 %_20)

	ret i1 1
}

define i1 @Receiver.D(i8* %this, i8* %.d) {
	%d = alloca i8*
	store i8* %.d, i8** %d
	%_0 = load i8*, i8** %d
	; D.foo : 0
	%_1 = bitcast i8* %_0 to i8***
	%_2 = load i8**, i8*** %_1
	%_3 = getelementptr i8*, i8** %_2, i32 0
	%_4 = load i8*, i8** %_3
	%_5 = bitcast i8* %_4 to i32 (i8*)*
	%_6 = call i32 %_5(i8* %_0)
	call void (i32) @print_int(i32 %_6)

	%_7 = load i8*, i8** %d
	; D.bar : 1
	%_8 = bitcast i8* %_7 to i8***
	%_9 = load i8**, i8*** %_8
	%_10 = getelementptr i8*, i8** %_9, i32 1
	%_11 = load i8*, i8** %_10
	%_12 = bitcast i8* %_11 to i32 (i8*)*
	%_13 = call i32 %_12(i8* %_7)
	call void (i32) @print_int(i32 %_13)

	%_14 = load i8*, i8** %d
	; D.test : 2
	%_15 = bitcast i8* %_14 to i8***
	%_16 = load i8**, i8*** %_15
	%_17 = getelementptr i8*, i8** %_16, i32 2
	%_18 = load i8*, i8** %_17
	%_19 = bitcast i8* %_18 to i32 (i8*)*
	%_20 = call i32 %_19(i8* %_14)
	call void (i32) @print_int(i32 %_20)

	%_21 = load i8*, i8** %d
	; D.not_overriden : 3
	%_22 = bitcast i8* %_21 to i8***
	%_23 = load i8**, i8*** %_22
	%_24 = getelementptr i8*, i8** %_23, i32 3
	%_25 = load i8*, i8** %_24
	%_26 = bitcast i8* %_25 to i32 (i8*)*
	%_27 = call i32 %_26(i8* %_21)
	call void (i32) @print_int(i32 %_27)

	%_28 = load i8*, i8** %d
	; D.another : 4
	%_29 = bitcast i8* %_28 to i8***
	%_30 = load i8**, i8*** %_29
	%_31 = getelementptr i8*, i8** %_30, i32 4
	%_32 = load i8*, i8** %_31
	%_33 = bitcast i8* %_32 to i32 (i8*)*
	%_34 = call i32 %_33(i8* %_28)
	call void (i32) @print_int(i32 %_34)

	%_35 = load i8*, i8** %d
	; D.stef : 5
	%_36 = bitcast i8* %_35 to i8***
	%_37 = load i8**, i8*** %_36
	%_38 = getelementptr i8*, i8** %_37, i32 5
	%_39 = load i8*, i8** %_38
	%_40 = bitcast i8* %_39 to i32 (i8*)*
	%_41 = call i32 %_40(i8* %_35)
	call void (i32) @print_int(i32 %_41)

	ret i1 1
}

define i8* @Receiver.alloc_B_for_A(i8* %this) {
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [5 x i8*], [5 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	ret i8* %_0
}

define i8* @Receiver.alloc_C_for_A(i8* %this) {
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	ret i8* %_0
}

define i8* @Receiver.alloc_D_for_A(i8* %this) {
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	ret i8* %_0
}

define i8* @Receiver.alloc_D_for_B(i8* %this) {
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [6 x i8*], [6 x i8*]* @.D_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	ret i8* %_0
}

define i32 @A.foo(i8* %this) {
	ret i32 1
}

define i32 @A.bar(i8* %this) {
	ret i32 2
}

define i32 @A.test(i8* %this) {
	ret i32 3
}

define i32 @B.bar(i8* %this) {
	ret i32 12
}

define i32 @B.not_overriden(i8* %this) {
	ret i32 14
}

define i32 @B.another(i8* %this) {
	ret i32 15
}

define i32 @C.bar(i8* %this) {
	ret i32 22
}

define i32 @D.bar(i8* %this) {
	ret i32 32
}

define i32 @D.another(i8* %this) {
	ret i32 35
}

define i32 @D.stef(i8* %this) {
	ret i32 36
}

