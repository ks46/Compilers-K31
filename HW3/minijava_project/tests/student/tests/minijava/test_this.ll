@.test_this_vtable = global [0 x i8*] []
@.A_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*)* @A.InitA to i8*), i8* bitcast (i32 (i8*)* @A.f1 to i8*)]
@.B_vtable = global [4 x i8*] [i8* bitcast (i32 (i8*)* @A.InitA to i8*), i8* bitcast (i32 (i8*)* @A.f1 to i8*), i8* bitcast (i32 (i8*)* @B.InitB to i8*), i8* bitcast (i32 (i8*)* @B.f2 to i8*)]
@.C_vtable = global [6 x i8*] [i8* bitcast (i32 (i8*)* @A.InitA to i8*), i8* bitcast (i32 (i8*)* @A.f1 to i8*), i8* bitcast (i32 (i8*)* @B.InitB to i8*), i8* bitcast (i32 (i8*)* @B.f2 to i8*), i8* bitcast (i32 (i8*)* @C.InitC to i8*), i8* bitcast (i32 (i8*)* @C.f3 to i8*)]
@.D_vtable = global [8 x i8*] [i8* bitcast (i32 (i8*)* @A.InitA to i8*), i8* bitcast (i32 (i8*)* @A.f1 to i8*), i8* bitcast (i32 (i8*)* @B.InitB to i8*), i8* bitcast (i32 (i8*)* @B.f2 to i8*), i8* bitcast (i32 (i8*)* @C.InitC to i8*), i8* bitcast (i32 (i8*)* @C.f3 to i8*), i8* bitcast (i32 (i8*)* @D.InitD to i8*), i8* bitcast (i32 (i8*)* @D.f4 to i8*)]
@.E_vtable = global [10 x i8*] [i8* bitcast (i32 (i8*)* @A.InitA to i8*), i8* bitcast (i32 (i8*)* @A.f1 to i8*), i8* bitcast (i32 (i8*)* @B.InitB to i8*), i8* bitcast (i32 (i8*)* @B.f2 to i8*), i8* bitcast (i32 (i8*)* @C.InitC to i8*), i8* bitcast (i32 (i8*)* @C.f3 to i8*), i8* bitcast (i32 (i8*)* @D.InitD to i8*), i8* bitcast (i32 (i8*)* @D.f4 to i8*), i8* bitcast (i32 (i8*)* @E.InitE to i8*), i8* bitcast (i32 (i8*)* @E.f5 to i8*)]
@.F_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*,i8*)* @F.InitF to i8*)]


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
	%e = alloca i8*

	%f = alloca i8*

	%_0 = call i8* @calloc(i32 1, i32 28)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [10 x i8*], [10 x i8*]* @.E_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %e

	%_3 = call i8* @calloc(i32 1, i32 16)
	%_4 = bitcast i8* %_3 to i8***
	%_5 = getelementptr [1 x i8*], [1 x i8*]* @.F_vtable, i32 0, i32 0
	store i8** %_5, i8*** %_4
	store i8* %_3, i8** %f

	%_6 = load i8*, i8** %e
	; E.InitE : 8
	%_7 = bitcast i8* %_6 to i8***
	%_8 = load i8**, i8*** %_7
	%_9 = getelementptr i8*, i8** %_8, i32 8
	%_10 = load i8*, i8** %_9
	%_11 = bitcast i8* %_10 to i32 (i8*)*
	%_12 = call i32 %_11(i8* %_6)
	call void (i32) @print_int(i32 %_12)

	%_13 = load i8*, i8** %e
	; E.f5 : 9
	%_14 = bitcast i8* %_13 to i8***
	%_15 = load i8**, i8*** %_14
	%_16 = getelementptr i8*, i8** %_15, i32 9
	%_17 = load i8*, i8** %_16
	%_18 = bitcast i8* %_17 to i32 (i8*)*
	%_19 = call i32 %_18(i8* %_13)
	call void (i32) @print_int(i32 %_19)

	%_20 = load i8*, i8** %f
	; F.InitF : 0
	%_21 = bitcast i8* %_20 to i8***
	%_22 = load i8**, i8*** %_21
	%_23 = getelementptr i8*, i8** %_22, i32 0
	%_24 = load i8*, i8** %_23
	%_25 = bitcast i8* %_24 to i32 (i8*,i8*)*
	%_27 = load i8*, i8** %e
	%_26 = call i32 %_25(i8* %_20, i8* %_27)
	call void (i32) @print_int(i32 %_26)

	ret i32 0
}

define i32 @A.InitA(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 8
	%_1 = bitcast i8* %_0 to i32*
	store i32 1024, i32* %_1

	%_2 = getelementptr i8, i8* %this, i32 8
	%_3 = bitcast i8* %_2 to i32*
	%_4 = load i32, i32* %_3
	ret i32 %_4
}

define i32 @A.f1(i8* %this) {
	ret i32 1
}

define i32 @B.InitB(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 12
	%_1 = bitcast i8* %_0 to i32*
	store i32 2048, i32* %_1

	%_2 = getelementptr i8, i8* %this, i32 12
	%_3 = bitcast i8* %_2 to i32*
	%_4 = load i32, i32* %_3
	; B.InitA : 0
	%_5 = bitcast i8* %this to i8***
	%_6 = load i8**, i8*** %_5
	%_7 = getelementptr i8*, i8** %_6, i32 0
	%_8 = load i8*, i8** %_7
	%_9 = bitcast i8* %_8 to i32 (i8*)*
	%_10 = call i32 %_9(i8* %this)
	%_11 = add i32 %_4, %_10
	ret i32 %_11
}

define i32 @B.f2(i8* %this) {
	; B.f1 : 1
	%_0 = bitcast i8* %this to i8***
	%_1 = load i8**, i8*** %_0
	%_2 = getelementptr i8*, i8** %_1, i32 1
	%_3 = load i8*, i8** %_2
	%_4 = bitcast i8* %_3 to i32 (i8*)*
	%_5 = call i32 %_4(i8* %this)
	%_6 = add i32 2, %_5
	ret i32 %_6
}

define i32 @C.InitC(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 16
	%_1 = bitcast i8* %_0 to i32*
	store i32 4096, i32* %_1

	%_2 = getelementptr i8, i8* %this, i32 16
	%_3 = bitcast i8* %_2 to i32*
	%_4 = load i32, i32* %_3
	; C.InitB : 2
	%_5 = bitcast i8* %this to i8***
	%_6 = load i8**, i8*** %_5
	%_7 = getelementptr i8*, i8** %_6, i32 2
	%_8 = load i8*, i8** %_7
	%_9 = bitcast i8* %_8 to i32 (i8*)*
	%_10 = call i32 %_9(i8* %this)
	%_11 = add i32 %_4, %_10
	ret i32 %_11
}

define i32 @C.f3(i8* %this) {
	; C.f2 : 3
	%_0 = bitcast i8* %this to i8***
	%_1 = load i8**, i8*** %_0
	%_2 = getelementptr i8*, i8** %_1, i32 3
	%_3 = load i8*, i8** %_2
	%_4 = bitcast i8* %_3 to i32 (i8*)*
	%_5 = call i32 %_4(i8* %this)
	%_6 = add i32 3, %_5
	ret i32 %_6
}

define i32 @D.InitD(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 20
	%_1 = bitcast i8* %_0 to i32*
	store i32 8192, i32* %_1

	%_2 = getelementptr i8, i8* %this, i32 20
	%_3 = bitcast i8* %_2 to i32*
	%_4 = load i32, i32* %_3
	; D.InitC : 4
	%_5 = bitcast i8* %this to i8***
	%_6 = load i8**, i8*** %_5
	%_7 = getelementptr i8*, i8** %_6, i32 4
	%_8 = load i8*, i8** %_7
	%_9 = bitcast i8* %_8 to i32 (i8*)*
	%_10 = call i32 %_9(i8* %this)
	%_11 = add i32 %_4, %_10
	ret i32 %_11
}

define i32 @D.f4(i8* %this) {
	; D.f3 : 5
	%_0 = bitcast i8* %this to i8***
	%_1 = load i8**, i8*** %_0
	%_2 = getelementptr i8*, i8** %_1, i32 5
	%_3 = load i8*, i8** %_2
	%_4 = bitcast i8* %_3 to i32 (i8*)*
	%_5 = call i32 %_4(i8* %this)
	%_6 = add i32 4, %_5
	ret i32 %_6
}

define i32 @E.InitE(i8* %this) {
	%_0 = getelementptr i8, i8* %this, i32 24
	%_1 = bitcast i8* %_0 to i32*
	store i32 16384, i32* %_1

	%_2 = getelementptr i8, i8* %this, i32 24
	%_3 = bitcast i8* %_2 to i32*
	%_4 = load i32, i32* %_3
	; E.InitD : 6
	%_5 = bitcast i8* %this to i8***
	%_6 = load i8**, i8*** %_5
	%_7 = getelementptr i8*, i8** %_6, i32 6
	%_8 = load i8*, i8** %_7
	%_9 = bitcast i8* %_8 to i32 (i8*)*
	%_10 = call i32 %_9(i8* %this)
	%_11 = add i32 %_4, %_10
	ret i32 %_11
}

define i32 @E.f5(i8* %this) {
	; E.f4 : 7
	%_0 = bitcast i8* %this to i8***
	%_1 = load i8**, i8*** %_0
	%_2 = getelementptr i8*, i8** %_1, i32 7
	%_3 = load i8*, i8** %_2
	%_4 = bitcast i8* %_3 to i32 (i8*)*
	%_5 = call i32 %_4(i8* %this)
	%_6 = add i32 5, %_5
	ret i32 %_6
}

define i32 @F.InitF(i8* %this, i8* %.e) {
	%e = alloca i8*
	store i8* %.e, i8** %e
	%_0 = load i8*, i8** %e
	%_1 = getelementptr i8, i8* %this, i32 8
	%_2 = bitcast i8* %_1 to i8**
	store i8* %_0, i8** %_2

	%_3 = load i8*, i8** %e
	; E.f5 : 9
	%_4 = bitcast i8* %_3 to i8***
	%_5 = load i8**, i8*** %_4
	%_6 = getelementptr i8*, i8** %_5, i32 9
	%_7 = load i8*, i8** %_6
	%_8 = bitcast i8* %_7 to i32 (i8*)*
	%_9 = call i32 %_8(i8* %_3)
	ret i32 %_9
}

