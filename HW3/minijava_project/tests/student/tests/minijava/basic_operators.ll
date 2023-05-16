@.basic_operators_vtable = global [0 x i8*] []
@.A_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*)* @A.getData to i8*)]


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
	%i = alloca i32

	%j = alloca i32

	store i32 10, i32* %i

	store i32 20, i32* %j

	%_0 = add i32 1, 2
	%_1 = add i32 %_0, 3
	%_2 = load i32, i32* %i
	%_3 = add i32 %_1, %_2
	%_4 = load i32, i32* %j
	%_5 = add i32 %_3, %_4
	call void (i32) @print_int(i32 %_5)

	%_6 = mul i32 1, 2
	%_7 = mul i32 %_6, 3
	%_8 = load i32, i32* %i
	%_9 = mul i32 %_7, %_8
	%_10 = load i32, i32* %j
	%_11 = mul i32 %_9, %_10
	call void (i32) @print_int(i32 %_11)

	%_12 = mul i32 1, 2
	%_13 = mul i32 %_12, 3
	%_14 = load i32, i32* %i
	%_15 = sub i32 %_13, %_14
	%_16 = load i32, i32* %j
	%_17 = add i32 %_15, %_16
	call void (i32) @print_int(i32 %_17)

	%_18 = call i8* @calloc(i32 1, i32 8)
	%_19 = bitcast i8* %_18 to i8***
	%_20 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_20, i8*** %_19
	; A.getData : 0
	%_21 = bitcast i8* %_18 to i8***
	%_22 = load i8**, i8*** %_21
	%_23 = getelementptr i8*, i8** %_22, i32 0
	%_24 = load i8*, i8** %_23
	%_25 = bitcast i8* %_24 to i32 (i8*)*
	%_26 = call i32 %_25(i8* %_18)
	%_27 = mul i32 1, %_26
	%_28 = mul i32 %_27, 3
	%_29 = load i32, i32* %i
	%_30 = sub i32 %_28, %_29
	%_31 = add i32 %_30, 20
	call void (i32) @print_int(i32 %_31)

	ret i32 0
}

define i32 @A.getData(i8* %this) {
	ret i32 100
}

