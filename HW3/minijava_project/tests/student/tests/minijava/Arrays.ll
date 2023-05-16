@.Arrays_vtable = global [0 x i8*] []


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
	%x = alloca i32*

	%_3 = icmp slt i32 2, 0
	br i1 %_3, label %arr_alloc4, label %arr_alloc5

arr_alloc4:
	call void @throw_oob()
	br label %arr_alloc5

arr_alloc5:
	%_0 = add i32 2, 1
	%_1 = call i8* @calloc(i32 4, i32 %_0)
	%_2 = bitcast i8* %_1 to i32*
	store i32 2, i32* %_2
	store i32* %_2, i32** %x

	%_14 = load i32*, i32** %x
	%_6 = load i32, i32* %_14
	%_7 = icmp ult i32 0, %_6
	br i1 %_7, label %oob11, label %oob12

oob11:
	%_8 = add i32 0, 1
	%_9 = getelementptr i32, i32* %_14, i32 %_8
	store i32 1, i32* %_9
	br label %oob13

oob12:
	call void @throw_oob()
	br label %oob13

oob13:

	%_23 = load i32*, i32** %x
	%_15 = load i32, i32* %_23
	%_16 = icmp ult i32 1, %_15
	br i1 %_16, label %oob20, label %oob21

oob20:
	%_17 = add i32 1, 1
	%_18 = getelementptr i32, i32* %_23, i32 %_17
	store i32 2, i32* %_18
	br label %oob22

oob21:
	call void @throw_oob()
	br label %oob22

oob22:

	%_33 = load i32*, i32** %x
	%_24 = load i32, i32* %_33
	%_25 = icmp ult i32 0, %_24
	br i1 %_25, label %oob30, label %oob31

oob30:
	%_26 = add i32 0, 1
	%_27 = getelementptr i32, i32* %_33, i32 %_26
	%_28 = load i32, i32* %_27
	br label %oob32

oob31:
	call void @throw_oob()
	br label %oob32

oob32:
	%_43 = load i32*, i32** %x
	%_34 = load i32, i32* %_43
	%_35 = icmp ult i32 1, %_34
	br i1 %_35, label %oob40, label %oob41

oob40:
	%_36 = add i32 1, 1
	%_37 = getelementptr i32, i32* %_43, i32 %_36
	%_38 = load i32, i32* %_37
	br label %oob42

oob41:
	call void @throw_oob()
	br label %oob42

oob42:
	%_44 = add i32 %_28, %_38
	call void (i32) @print_int(i32 %_44)

	ret i32 0
}

