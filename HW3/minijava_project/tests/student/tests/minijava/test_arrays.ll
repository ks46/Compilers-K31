@.test_arrays_vtable = global [0 x i8*] []


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
	%size = alloca i32

	%index = alloca i32

	%sum = alloca i32

	%int_array = alloca i32*

	%int_array_ref = alloca i32*

	%flag = alloca i1

	store i32 1024, i32* %size

	%_6 = load i32, i32* %size
	%_7 = add i32 %_6, 1
	%_8 = sub i32 %_7, 1
	%_3 = icmp slt i32 %_8, 0
	br i1 %_3, label %arr_alloc4, label %arr_alloc5

arr_alloc4:
	call void @throw_oob()
	br label %arr_alloc5

arr_alloc5:
	%_0 = add i32 %_8, 1
	%_1 = call i8* @calloc(i32 4, i32 %_0)
	%_2 = bitcast i8* %_1 to i32*
	store i32 %_8, i32* %_2
	store i32* %_2, i32** %int_array

	%_14 = load i32*, i32** %int_array
	%_13 = load i32, i32* %_14
	%_15 = load i32, i32* %size
	%_16 = icmp slt i32 %_13, %_15
	%_12 = xor i1 1, %_16
	br label %andclause18

andclause18:
	br i1 %_12, label %andclause19, label %andclause21

andclause19:
	%_23 = load i32, i32* %size
	%_25 = load i32*, i32** %int_array
	%_24 = load i32, i32* %_25
	%_26 = icmp slt i32 %_23, %_24
	%_22 = xor i1 1, %_26
	br label %andclause20

andclause20:
	br label %andclause21

andclause21:
	%_17 = phi i1 [ 0, %andclause18 ], [ %_22, %andclause20 ]
	br i1 %_17, label %if9, label %if10

if9:
	%_28 = load i32*, i32** %int_array
	%_27 = load i32, i32* %_28
	call void (i32) @print_int(i32 %_27)

	br label %if11

if10:

	call void (i32) @print_int(i32 2020)

	br label %if11

if11:

	store i32 0, i32* %index

	br label %loop29

loop29:
	%_32 = load i32, i32* %index
	%_34 = load i32*, i32** %int_array
	%_33 = load i32, i32* %_34
	%_35 = icmp slt i32 %_32, %_33
	br i1 %_35, label %loop30, label %loop31

loop30:
	%_44 = load i32*, i32** %int_array
	%_45 = load i32, i32* %index
	%_36 = load i32, i32* %_44
	%_37 = icmp ult i32 %_45, %_36
	br i1 %_37, label %oob41, label %oob42

oob41:
	%_38 = add i32 %_45, 1
	%_39 = getelementptr i32, i32* %_44, i32 %_38
	%_46 = load i32, i32* %index
	%_47 = mul i32 %_46, 2
	store i32 %_47, i32* %_39
	br label %oob43

oob42:
	call void @throw_oob()
	br label %oob43

oob43:

	%_48 = load i32, i32* %index
	%_49 = add i32 %_48, 1
	store i32 %_49, i32* %index

	br label %loop29

loop31:

	store i32 0, i32* %index

	%_50 = load i32*, i32** %int_array
	store i32* %_50, i32** %int_array_ref

	store i32 0, i32* %sum

	br label %loop51

loop51:
	%_54 = load i32, i32* %index
	%_56 = load i32*, i32** %int_array_ref
	%_55 = load i32, i32* %_56
	%_57 = icmp slt i32 %_54, %_55
	br i1 %_57, label %loop52, label %loop53

loop52:
	%_67 = load i32*, i32** %int_array_ref
	%_68 = load i32, i32* %index
	%_58 = load i32, i32* %_67
	%_59 = icmp ult i32 %_68, %_58
	br i1 %_59, label %oob64, label %oob65

oob64:
	%_60 = add i32 %_68, 1
	%_61 = getelementptr i32, i32* %_67, i32 %_60
	%_62 = load i32, i32* %_61
	br label %oob66

oob65:
	call void @throw_oob()
	br label %oob66

oob66:
	%_69 = load i32, i32* %sum
	%_70 = add i32 %_62, %_69
	store i32 %_70, i32* %sum

	%_71 = load i32, i32* %index
	%_72 = add i32 %_71, 1
	store i32 %_72, i32* %index

	br label %loop51

loop53:

	%_73 = load i32, i32* %sum
	call void (i32) @print_int(i32 %_73)

	store i32 0, i32* %index

	store i1 1, i1* %flag

	store i32 0, i32* %index

	store i32 0, i32* %sum

	%_74 = load i32, i32* %sum
	call void (i32) @print_int(i32 %_74)

	ret i32 0
}

