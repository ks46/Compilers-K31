@.ops_vtable = global [0 x i8*] []
@.A_vtable = global [7 x i8*] [i8* bitcast (i1 (i8*)* @A.t to i8*), i8* bitcast (i32 (i8*)* @A.t2 to i8*), i8* bitcast (i32 (i8*,i32*)* @A.lispy to i8*), i8* bitcast (i1 (i8*)* @A.t3 to i8*), i8* bitcast (i1 (i8*,i32,i32*)* @A.t4 to i8*), i8* bitcast (i32 (i8*,i32*)* @A.t5 to i8*), i8* bitcast (i1 (i8*,i1,i32*)* @A.t6 to i8*)]
@.C_vtable = global [1 x i8*] [i8* bitcast (i32* (i8*,i1)* @C.test to i8*)]
@.B_vtable = global [2 x i8*] [i8* bitcast (i32* (i8*,i1)* @C.test to i8*), i8* bitcast (i32* (i8*,i32)* @B.test2 to i8*)]


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
	ret i32 0
}

define i1 @A.t(i8* %this) {
	%_1 = icmp slt i32 1, 2
	%_0 = xor i1 1, %_1
	br label %andclause3

andclause3:
	br i1 %_0, label %andclause4, label %andclause6

andclause4:
	br label %andclause8

andclause8:
	br i1 1, label %andclause9, label %andclause11

andclause9:
	br label %andclause10

andclause10:
	br label %andclause11

andclause11:
	%_7 = phi i1 [ 0, %andclause8 ], [ 0, %andclause10 ]
	br label %andclause5

andclause5:
	br label %andclause6

andclause6:
	%_2 = phi i1 [ 0, %andclause3 ], [ %_7, %andclause5 ]
	ret i1 %_2
}

define i32 @A.t2(i8* %this) {
	%_0 = add i32 1, 2
	%_1 = add i32 %_0, 3
	%_2 = add i32 %_1, 4
	ret i32 %_2
}

define i32 @A.lispy(i8* %this, i32* %.a) {
	%a = alloca i32*
	store i32* %.a, i32** %a
	%_0 = add i32 1, 2
	%_10 = load i32*, i32** %a
	%_1 = load i32, i32* %_10
	%_2 = icmp ult i32 3, %_1
	br i1 %_2, label %oob7, label %oob8

oob7:
	%_3 = add i32 3, 1
	%_4 = getelementptr i32, i32* %_10, i32 %_3
	%_5 = load i32, i32* %_4
	br label %oob9

oob8:
	call void @throw_oob()
	br label %oob9

oob9:
	%_11 = add i32 %_0, %_5
	ret i32 %_11
}

define i1 @A.t3(i8* %this) {
	%a = alloca i32

	%b = alloca i32

	store i32 2, i32* %a

	store i32 2, i32* %b

	%_0 = add i32 349, 908
	%_1 = load i32, i32* %a
	%_2 = mul i32 23, %_1
	%_3 = load i32, i32* %b
	%_4 = sub i32 %_3, 2
	%_5 = sub i32 %_2, %_4
	%_6 = icmp slt i32 %_0, %_5
	ret i1 %_6
}

define i1 @A.t4(i8* %this, i32 %.a, i32* %.b) {
	%a = alloca i32
	store i32 %.a, i32* %a
	%b = alloca i32*
	store i32* %.b, i32** %b
	%arr = alloca i32*

	%_3 = icmp slt i32 10, 0
	br i1 %_3, label %arr_alloc4, label %arr_alloc5

arr_alloc4:
	call void @throw_oob()
	br label %arr_alloc5

arr_alloc5:
	%_0 = add i32 10, 1
	%_1 = call i8* @calloc(i32 4, i32 %_0)
	%_2 = bitcast i8* %_1 to i32*
	store i32 10, i32* %_2
	store i32* %_2, i32** %arr

	; A.t2 : 1
	%_6 = bitcast i8* %this to i8***
	%_7 = load i8**, i8*** %_6
	%_8 = getelementptr i8*, i8** %_7, i32 1
	%_9 = load i8*, i8** %_8
	%_10 = bitcast i8* %_9 to i32 (i8*)*
	%_11 = call i32 %_10(i8* %this)
	%_12 = add i32 29347, %_11
	%_13 = icmp slt i32 %_12, 12
	br label %andclause15

andclause15:
	br i1 %_13, label %andclause16, label %andclause18

andclause16:
	%_19 = load i32, i32* %a
	%_29 = load i32*, i32** %arr
	%_20 = load i32, i32* %_29
	%_21 = icmp ult i32 0, %_20
	br i1 %_21, label %oob26, label %oob27

oob26:
	%_22 = add i32 0, 1
	%_23 = getelementptr i32, i32* %_29, i32 %_22
	%_24 = load i32, i32* %_23
	br label %oob28

oob27:
	call void @throw_oob()
	br label %oob28

oob28:
	%_30 = icmp slt i32 %_19, %_24
	br label %andclause32

andclause32:
	br i1 %_30, label %andclause33, label %andclause35

andclause33:
	; A.t3 : 3
	%_36 = bitcast i8* %this to i8***
	%_37 = load i8**, i8*** %_36
	%_38 = getelementptr i8*, i8** %_37, i32 3
	%_39 = load i8*, i8** %_38
	%_40 = bitcast i8* %_39 to i1 (i8*)*
	%_41 = call i1 %_40(i8* %this)
	br label %andclause34

andclause34:
	br label %andclause35

andclause35:
	%_31 = phi i1 [ 0, %andclause32 ], [ %_41, %andclause34 ]
	br label %andclause43

andclause43:
	br i1 %_31, label %andclause44, label %andclause46

andclause44:
	; A.t4 : 4
	%_47 = bitcast i8* %this to i8***
	%_48 = load i8**, i8*** %_47
	%_49 = getelementptr i8*, i8** %_48, i32 4
	%_50 = load i8*, i8** %_49
	%_51 = bitcast i8* %_50 to i1 (i8*,i32,i32*)*
	; A.t2 : 1
	%_53 = bitcast i8* %this to i8***
	%_54 = load i8**, i8*** %_53
	%_55 = getelementptr i8*, i8** %_54, i32 1
	%_56 = load i8*, i8** %_55
	%_57 = bitcast i8* %_56 to i32 (i8*)*
	%_58 = call i32 %_57(i8* %this)
	%_59 = load i32*, i32** %arr
	%_52 = call i1 %_51(i8* %this, i32 %_58,i32* %_59)
	br label %andclause45

andclause45:
	br label %andclause46

andclause46:
	%_42 = phi i1 [ 0, %andclause43 ], [ %_52, %andclause45 ]
	br label %andclause17

andclause17:
	br label %andclause18

andclause18:
	%_14 = phi i1 [ 0, %andclause15 ], [ %_42, %andclause17 ]
	ret i1 %_14
}

define i32 @A.t5(i8* %this, i32* %.a) {
	%a = alloca i32*
	store i32* %.a, i32** %a
	%b = alloca i32

	; A.t2 : 1
	%_30 = bitcast i8* %this to i8***
	%_31 = load i8**, i8*** %_30
	%_32 = getelementptr i8*, i8** %_31, i32 1
	%_33 = load i8*, i8** %_32
	%_34 = bitcast i8* %_33 to i32 (i8*)*
	%_35 = call i32 %_34(i8* %this)
	; A.lispy : 2
	%_36 = bitcast i8* %this to i8***
	%_37 = load i8**, i8*** %_36
	%_38 = getelementptr i8*, i8** %_37, i32 2
	%_39 = load i8*, i8** %_38
	%_40 = bitcast i8* %_39 to i32 (i8*,i32*)*
	%_57 = load i32*, i32** %a
	%_48 = load i32, i32* %_57
	%_49 = icmp ult i32 0, %_48
	br i1 %_49, label %oob54, label %oob55

oob54:
	%_50 = add i32 0, 1
	%_51 = getelementptr i32, i32* %_57, i32 %_50
	%_52 = load i32, i32* %_51
	br label %oob56

oob55:
	call void @throw_oob()
	br label %oob56

oob56:
	%_45 = icmp slt i32 %_52, 0
	br i1 %_45, label %arr_alloc46, label %arr_alloc47

arr_alloc46:
	call void @throw_oob()
	br label %arr_alloc47

arr_alloc47:
	%_42 = add i32 %_52, 1
	%_43 = call i8* @calloc(i32 4, i32 %_42)
	%_44 = bitcast i8* %_43 to i32*
	store i32 %_52, i32* %_44
	%_41 = call i32 %_40(i8* %this, i32* %_44)
	%_58 = add i32 %_35, %_41
	%_27 = icmp slt i32 %_58, 0
	br i1 %_27, label %arr_alloc28, label %arr_alloc29

arr_alloc28:
	call void @throw_oob()
	br label %arr_alloc29

arr_alloc29:
	%_24 = add i32 %_58, 1
	%_25 = call i8* @calloc(i32 4, i32 %_24)
	%_26 = bitcast i8* %_25 to i32*
	store i32 %_58, i32* %_26
	%_15 = load i32, i32* %_26
	%_16 = icmp ult i32 0, %_15
	br i1 %_16, label %oob21, label %oob22

oob21:
	%_17 = add i32 0, 1
	%_18 = getelementptr i32, i32* %_26, i32 %_17
	%_19 = load i32, i32* %_18
	br label %oob23

oob22:
	call void @throw_oob()
	br label %oob23

oob23:
	%_59 = add i32 %_19, 10
	%_12 = icmp slt i32 %_59, 0
	br i1 %_12, label %arr_alloc13, label %arr_alloc14

arr_alloc13:
	call void @throw_oob()
	br label %arr_alloc14

arr_alloc14:
	%_9 = add i32 %_59, 1
	%_10 = call i8* @calloc(i32 4, i32 %_9)
	%_11 = bitcast i8* %_10 to i32*
	store i32 %_59, i32* %_11
	%_0 = load i32, i32* %_11
	%_1 = icmp ult i32 2, %_0
	br i1 %_1, label %oob6, label %oob7

oob6:
	%_2 = add i32 2, 1
	%_3 = getelementptr i32, i32* %_11, i32 %_2
	%_4 = load i32, i32* %_3
	br label %oob8

oob7:
	call void @throw_oob()
	br label %oob8

oob8:
	store i32 %_4, i32* %b

	%_69 = load i32*, i32** %a
	%_70 = load i32, i32* %b
	%_60 = load i32, i32* %_69
	%_61 = icmp ult i32 %_70, %_60
	br i1 %_61, label %oob66, label %oob67

oob66:
	%_62 = add i32 %_70, 1
	%_63 = getelementptr i32, i32* %_69, i32 %_62
	%_64 = load i32, i32* %_63
	br label %oob68

oob67:
	call void @throw_oob()
	br label %oob68

oob68:
	ret i32 %_64
}

define i1 @A.t6(i8* %this, i1 %.dummy, i32* %.arr) {
	%dummy = alloca i1
	store i1 %.dummy, i1* %dummy
	%arr = alloca i32*
	store i32* %.arr, i32** %arr
	%a = alloca i32

	%c = alloca i8*

	store i32 2, i32* %a

	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [1 x i8*], [1 x i8*]* @.C_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %c

	; A.t2 : 1
	%_3 = bitcast i8* %this to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 1
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i32 (i8*)*
	%_8 = call i32 %_7(i8* %this)
	%_9 = add i32 29347, %_8
	%_10 = icmp slt i32 %_9, 12
	br label %andclause12

andclause12:
	br i1 %_10, label %andclause13, label %andclause15

andclause13:
	%_16 = load i32, i32* %a
	%_26 = load i32*, i32** %arr
	%_17 = load i32, i32* %_26
	%_18 = icmp ult i32 0, %_17
	br i1 %_18, label %oob23, label %oob24

oob23:
	%_19 = add i32 0, 1
	%_20 = getelementptr i32, i32* %_26, i32 %_19
	%_21 = load i32, i32* %_20
	br label %oob25

oob24:
	call void @throw_oob()
	br label %oob25

oob25:
	%_27 = icmp slt i32 %_16, %_21
	br label %andclause29

andclause29:
	br i1 %_27, label %andclause30, label %andclause32

andclause30:
	; A.t3 : 3
	%_33 = bitcast i8* %this to i8***
	%_34 = load i8**, i8*** %_33
	%_35 = getelementptr i8*, i8** %_34, i32 3
	%_36 = load i8*, i8** %_35
	%_37 = bitcast i8* %_36 to i1 (i8*)*
	%_38 = call i1 %_37(i8* %this)
	br label %andclause31

andclause31:
	br label %andclause32

andclause32:
	%_28 = phi i1 [ 0, %andclause29 ], [ %_38, %andclause31 ]
	br label %andclause40

andclause40:
	br i1 %_28, label %andclause41, label %andclause43

andclause41:
	; A.t6 : 6
	%_44 = bitcast i8* %this to i8***
	%_45 = load i8**, i8*** %_44
	%_46 = getelementptr i8*, i8** %_45, i32 6
	%_47 = load i8*, i8** %_46
	%_48 = bitcast i8* %_47 to i1 (i8*,i1,i32*)*
	; A.t4 : 4
	%_50 = bitcast i8* %this to i8***
	%_51 = load i8**, i8*** %_50
	%_52 = getelementptr i8*, i8** %_51, i32 4
	%_53 = load i8*, i8** %_52
	%_54 = bitcast i8* %_53 to i1 (i8*,i32,i32*)*
	%_65 = call i8* @calloc(i32 1, i32 8)
	%_66 = bitcast i8* %_65 to i8***
	%_67 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_67, i8*** %_66
	; B.test : 0
	%_68 = bitcast i8* %_65 to i8***
	%_69 = load i8**, i8*** %_68
	%_70 = getelementptr i8*, i8** %_69, i32 0
	%_71 = load i8*, i8** %_70
	%_72 = bitcast i8* %_71 to i32* (i8*,i1)*
	%_73 = call i32* %_72(i8* %_65, i1 1)
	%_56 = load i32, i32* %_73
	%_57 = icmp ult i32 0, %_56
	br i1 %_57, label %oob62, label %oob63

oob62:
	%_58 = add i32 0, 1
	%_59 = getelementptr i32, i32* %_73, i32 %_58
	%_60 = load i32, i32* %_59
	br label %oob64

oob63:
	call void @throw_oob()
	br label %oob64

oob64:
	%_74 = load i32*, i32** %arr
	%_55 = call i1 %_54(i8* %this, i32 %_60,i32* %_74)
	%_90 = load i32*, i32** %arr
	%_81 = load i32, i32* %_90
	%_82 = icmp ult i32 0, %_81
	br i1 %_82, label %oob87, label %oob88

oob87:
	%_83 = add i32 0, 1
	%_84 = getelementptr i32, i32* %_90, i32 %_83
	%_85 = load i32, i32* %_84
	br label %oob89

oob88:
	call void @throw_oob()
	br label %oob89

oob89:
	%_78 = icmp slt i32 %_85, 0
	br i1 %_78, label %arr_alloc79, label %arr_alloc80

arr_alloc79:
	call void @throw_oob()
	br label %arr_alloc80

arr_alloc80:
	%_75 = add i32 %_85, 1
	%_76 = call i8* @calloc(i32 4, i32 %_75)
	%_77 = bitcast i8* %_76 to i32*
	store i32 %_85, i32* %_77
	%_49 = call i1 %_48(i8* %this, i1 %_55,i32* %_77)
	br label %andclause42

andclause42:
	br label %andclause43

andclause43:
	%_39 = phi i1 [ 0, %andclause40 ], [ %_49, %andclause42 ]
	br label %andclause14

andclause14:
	br label %andclause15

andclause15:
	%_11 = phi i1 [ 0, %andclause12 ], [ %_39, %andclause14 ]
	ret i1 %_11
}

define i32* @C.test(i8* %this, i1 %.a) {
	%a = alloca i1
	store i1 %.a, i1* %a
	%_3 = icmp slt i32 10, 0
	br i1 %_3, label %arr_alloc4, label %arr_alloc5

arr_alloc4:
	call void @throw_oob()
	br label %arr_alloc5

arr_alloc5:
	%_0 = add i32 10, 1
	%_1 = call i8* @calloc(i32 4, i32 %_0)
	%_2 = bitcast i8* %_1 to i32*
	store i32 10, i32* %_2
	ret i32* %_2
}

define i32* @B.test2(i8* %this, i32 %.i) {
	%i = alloca i32
	store i32 %.i, i32* %i
	%_6 = load i32, i32* %i
	%_3 = icmp slt i32 %_6, 0
	br i1 %_3, label %arr_alloc4, label %arr_alloc5

arr_alloc4:
	call void @throw_oob()
	br label %arr_alloc5

arr_alloc5:
	%_0 = add i32 %_6, 1
	%_1 = call i8* @calloc(i32 4, i32 %_0)
	%_2 = bitcast i8* %_1 to i32*
	store i32 %_6, i32* %_2
	ret i32* %_2
}

