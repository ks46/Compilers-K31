@.shadow_vtable = global [0 x i8*] []
@.A_vtable = global [3 x i8*] [i8* bitcast (i1 (i8*)* @A.set_x to i8*), i8* bitcast (i32 (i8*)* @A.x to i8*), i8* bitcast (i32 (i8*)* @A.y to i8*)]
@.B_vtable = global [3 x i8*] [i8* bitcast (i1 (i8*)* @B.set_x to i8*), i8* bitcast (i32 (i8*)* @B.x to i8*), i8* bitcast (i32 (i8*)* @A.y to i8*)]
@.C_vtable = global [3 x i8*] [i8* bitcast (i32 (i8*)* @C.get_class_x to i8*), i8* bitcast (i32 (i8*)* @C.get_method_x to i8*), i8* bitcast (i1 (i8*)* @C.set_int_x to i8*)]
@.D_vtable = global [4 x i8*] [i8* bitcast (i32 (i8*)* @C.get_class_x to i8*), i8* bitcast (i32 (i8*)* @C.get_method_x to i8*), i8* bitcast (i1 (i8*)* @C.set_int_x to i8*), i8* bitcast (i1 (i8*)* @D.get_class_x2 to i8*)]
@.E_vtable = global [6 x i8*] [i8* bitcast (i32 (i8*)* @C.get_class_x to i8*), i8* bitcast (i32 (i8*)* @C.get_method_x to i8*), i8* bitcast (i1 (i8*)* @C.set_int_x to i8*), i8* bitcast (i1 (i8*)* @D.get_class_x2 to i8*), i8* bitcast (i1 (i8*)* @E.set_bool_x to i8*), i8* bitcast (i1 (i8*)* @E.get_bool_x to i8*)]


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
	%a = alloca i8*

	%c = alloca i8*

	%d = alloca i8*

	%e = alloca i8*

	%dummy = alloca i1

	%_0 = call i8* @calloc(i32 1, i32 16)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [3 x i8*], [3 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %a

	%_3 = load i8*, i8** %a
	; A.set_x : 0
	%_4 = bitcast i8* %_3 to i8***
	%_5 = load i8**, i8*** %_4
	%_6 = getelementptr i8*, i8** %_5, i32 0
	%_7 = load i8*, i8** %_6
	%_8 = bitcast i8* %_7 to i1 (i8*)*
	%_9 = call i1 %_8(i8* %_3)
	store i1 %_9, i1* %dummy

	%_10 = load i8*, i8** %a
	; A.x : 1
	%_11 = bitcast i8* %_10 to i8***
	%_12 = load i8**, i8*** %_11
	%_13 = getelementptr i8*, i8** %_12, i32 1
	%_14 = load i8*, i8** %_13
	%_15 = bitcast i8* %_14 to i32 (i8*)*
	%_16 = call i32 %_15(i8* %_10)
	call void (i32) @print_int(i32 %_16)

	%_17 = load i8*, i8** %a
	; A.y : 2
	%_18 = bitcast i8* %_17 to i8***
	%_19 = load i8**, i8*** %_18
	%_20 = getelementptr i8*, i8** %_19, i32 2
	%_21 = load i8*, i8** %_20
	%_22 = bitcast i8* %_21 to i32 (i8*)*
	%_23 = call i32 %_22(i8* %_17)
	call void (i32) @print_int(i32 %_23)

	%_24 = call i8* @calloc(i32 1, i32 20)
	%_25 = bitcast i8* %_24 to i8***
	%_26 = getelementptr [3 x i8*], [3 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_26, i8*** %_25
	store i8* %_24, i8** %a

	%_27 = load i8*, i8** %a
	; A.set_x : 0
	%_28 = bitcast i8* %_27 to i8***
	%_29 = load i8**, i8*** %_28
	%_30 = getelementptr i8*, i8** %_29, i32 0
	%_31 = load i8*, i8** %_30
	%_32 = bitcast i8* %_31 to i1 (i8*)*
	%_33 = call i1 %_32(i8* %_27)
	store i1 %_33, i1* %dummy

	%_34 = load i8*, i8** %a
	; A.x : 1
	%_35 = bitcast i8* %_34 to i8***
	%_36 = load i8**, i8*** %_35
	%_37 = getelementptr i8*, i8** %_36, i32 1
	%_38 = load i8*, i8** %_37
	%_39 = bitcast i8* %_38 to i32 (i8*)*
	%_40 = call i32 %_39(i8* %_34)
	call void (i32) @print_int(i32 %_40)

	%_41 = load i8*, i8** %a
	; A.y : 2
	%_42 = bitcast i8* %_41 to i8***
	%_43 = load i8**, i8*** %_42
	%_44 = getelementptr i8*, i8** %_43, i32 2
	%_45 = load i8*, i8** %_44
	%_46 = bitcast i8* %_45 to i32 (i8*)*
	%_47 = call i32 %_46(i8* %_41)
	call void (i32) @print_int(i32 %_47)

	%_48 = call i8* @calloc(i32 1, i32 12)
	%_49 = bitcast i8* %_48 to i8***
	%_50 = getelementptr [3 x i8*], [3 x i8*]* @.C_vtable, i32 0, i32 0
	store i8** %_50, i8*** %_49
	store i8* %_48, i8** %c

	%_51 = load i8*, i8** %c
	; C.get_method_x : 1
	%_52 = bitcast i8* %_51 to i8***
	%_53 = load i8**, i8*** %_52
	%_54 = getelementptr i8*, i8** %_53, i32 1
	%_55 = load i8*, i8** %_54
	%_56 = bitcast i8* %_55 to i32 (i8*)*
	%_57 = call i32 %_56(i8* %_51)
	call void (i32) @print_int(i32 %_57)

	%_58 = load i8*, i8** %c
	; C.get_class_x : 0
	%_59 = bitcast i8* %_58 to i8***
	%_60 = load i8**, i8*** %_59
	%_61 = getelementptr i8*, i8** %_60, i32 0
	%_62 = load i8*, i8** %_61
	%_63 = bitcast i8* %_62 to i32 (i8*)*
	%_64 = call i32 %_63(i8* %_58)
	call void (i32) @print_int(i32 %_64)

	%_65 = call i8* @calloc(i32 1, i32 13)
	%_66 = bitcast i8* %_65 to i8***
	%_67 = getelementptr [4 x i8*], [4 x i8*]* @.D_vtable, i32 0, i32 0
	store i8** %_67, i8*** %_66
	store i8* %_65, i8** %d

	%_68 = load i8*, i8** %d
	; D.set_int_x : 2
	%_69 = bitcast i8* %_68 to i8***
	%_70 = load i8**, i8*** %_69
	%_71 = getelementptr i8*, i8** %_70, i32 2
	%_72 = load i8*, i8** %_71
	%_73 = bitcast i8* %_72 to i1 (i8*)*
	%_74 = call i1 %_73(i8* %_68)
	store i1 %_74, i1* %dummy

	%_78 = load i8*, i8** %d
	; D.get_class_x2 : 3
	%_79 = bitcast i8* %_78 to i8***
	%_80 = load i8**, i8*** %_79
	%_81 = getelementptr i8*, i8** %_80, i32 3
	%_82 = load i8*, i8** %_81
	%_83 = bitcast i8* %_82 to i1 (i8*)*
	%_84 = call i1 %_83(i8* %_78)
	br i1 %_84, label %if75, label %if76

if75:
	call void (i32) @print_int(i32 1)

	br label %if77

if76:

	call void (i32) @print_int(i32 0)

	br label %if77

if77:

	%_85 = call i8* @calloc(i32 1, i32 14)
	%_86 = bitcast i8* %_85 to i8***
	%_87 = getelementptr [6 x i8*], [6 x i8*]* @.E_vtable, i32 0, i32 0
	store i8** %_87, i8*** %_86
	store i8* %_85, i8** %e

	%_88 = load i8*, i8** %e
	; E.set_int_x : 2
	%_89 = bitcast i8* %_88 to i8***
	%_90 = load i8**, i8*** %_89
	%_91 = getelementptr i8*, i8** %_90, i32 2
	%_92 = load i8*, i8** %_91
	%_93 = bitcast i8* %_92 to i1 (i8*)*
	%_94 = call i1 %_93(i8* %_88)
	store i1 %_94, i1* %dummy

	%_98 = load i8*, i8** %e
	; E.get_class_x2 : 3
	%_99 = bitcast i8* %_98 to i8***
	%_100 = load i8**, i8*** %_99
	%_101 = getelementptr i8*, i8** %_100, i32 3
	%_102 = load i8*, i8** %_101
	%_103 = bitcast i8* %_102 to i1 (i8*)*
	%_104 = call i1 %_103(i8* %_98)
	br i1 %_104, label %if95, label %if96

if95:
	call void (i32) @print_int(i32 1)

	br label %if97

if96:

	call void (i32) @print_int(i32 0)

	br label %if97

if97:

	%_105 = load i8*, i8** %e
	; E.set_bool_x : 4
	%_106 = bitcast i8* %_105 to i8***
	%_107 = load i8**, i8*** %_106
	%_108 = getelementptr i8*, i8** %_107, i32 4
	%_109 = load i8*, i8** %_108
	%_110 = bitcast i8* %_109 to i1 (i8*)*
	%_111 = call i1 %_110(i8* %_105)
	store i1 %_111, i1* %dummy

	%_115 = load i8*, i8** %e
	; E.get_bool_x : 5
	%_116 = bitcast i8* %_115 to i8***
	%_117 = load i8**, i8*** %_116
	%_118 = getelementptr i8*, i8** %_117, i32 5
	%_119 = load i8*, i8** %_118
	%_120 = bitcast i8* %_119 to i1 (i8*)*
	%_121 = call i1 %_120(i8* %_115)
	br i1 %_121, label %if112, label %if113

if112:
	call void (i32) @print_int(i32 1)

	br label %if114

if113:

	call void (i32) @print_int(i32 0)

	br label %if114

if114:

	ret i32 0
}

define i1 @A.set_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 8
	%_1 = bitcast i8* %_0 to i32*
	store i32 1, i32* %_1

	ret i1 1
}

define i32 @A.x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 8
	%_1 = bitcast i8* %_0 to i32*
	%_2 = load i32, i32* %_1
	ret i32 %_2
}

define i32 @A.y(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 12
	%_1 = bitcast i8* %_0 to i32*
	%_2 = load i32, i32* %_1
	ret i32 %_2
}

define i1 @B.set_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 16
	%_1 = bitcast i8* %_0 to i32*
	store i32 2, i32* %_1

	ret i1 1
}

define i32 @B.x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 16
	%_1 = bitcast i8* %_0 to i32*
	%_2 = load i32, i32* %_1
	ret i32 %_2
}

define i32 @C.get_class_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 8
	%_1 = bitcast i8* %_0 to i32*
	%_2 = load i32, i32* %_1
	ret i32 %_2
}

define i32 @C.get_method_x(i8* %this) {
	%x = alloca i32

	store i32 3, i32* %x

	%_0 = load i32, i32* %x
	ret i32 %_0
}

define i1 @C.set_int_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 8
	%_1 = bitcast i8* %_0 to i32*
	store i32 20, i32* %_1

	ret i1 1
}

define i1 @D.get_class_x2(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 12
	%_1 = bitcast i8* %_0 to i1*
	%_2 = load i1, i1* %_1
	ret i1 %_2
}

define i1 @E.set_bool_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 13
	%_1 = bitcast i8* %_0 to i1*
	store i1 1, i1* %_1

	ret i1 1
}

define i1 @E.get_bool_x(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 13
	%_1 = bitcast i8* %_0 to i1*
	%_2 = load i1, i1* %_1
	ret i1 %_2
}

