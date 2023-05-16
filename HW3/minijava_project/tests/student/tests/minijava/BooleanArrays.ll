@.BooleanArrays_vtable = global [0 x i8*] []


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
	%x = alloca i8*

	%y = alloca i1

	%len = alloca i32

	store null, i8** %x

	%_8 = load i8*, i8** %x
	%_0 = load i32, i8* %_8
	%_1 = icmp ult i32 0, %_0
	br i1 %_1, label %oob5, label %oob6

oob5:
	%_2 = add i32 0, 1
	%_3 = getelementptr i32, i8* %_8, i32 %_2
	store i1 1, i32* %_3
	br label %oob7

oob6:
	call void @throw_oob()
	br label %oob7

oob7:

	%_17 = load i8*, i8** %x
	%_9 = load i32, i8* %_17
	%_10 = icmp ult i32 1, %_9
	br i1 %_10, label %oob14, label %oob15

oob14:
	%_11 = add i32 1, 1
	%_12 = getelementptr i32, i8* %_17, i32 %_11
	store i1 0, i32* %_12
	br label %oob16

oob15:
	call void @throw_oob()
	br label %oob16

oob16:

	%_30 = load i8*, i8** %x
	%_21 = load i32, i8* %_30
	%_22 = icmp ult i32 0, %_21
	br i1 %_22, label %oob27, label %oob28

oob27:
	%_23 = add i32 0, 1
	%_24 = getelementptr i32, i8* %_30, i32 %_23
	%_25 = load i32, i32* %_24
	br label %oob29

oob28:
	call void @throw_oob()
	br label %oob29

oob29:
	br label %andclause32

andclause32:
	br i32 %_25, label %andclause33, label %andclause35

andclause33:
	%_45 = load i8*, i8** %x
	%_36 = load i32, i8* %_45
	%_37 = icmp ult i32 1, %_36
	br i1 %_37, label %oob42, label %oob43

oob42:
	%_38 = add i32 1, 1
	%_39 = getelementptr i32, i8* %_45, i32 %_38
	%_40 = load i32, i32* %_39
	br label %oob44

oob43:
	call void @throw_oob()
	br label %oob44

oob44:
	br label %andclause34

andclause34:
	br label %andclause35

andclause35:
	%_31 = phi i1 [ 0, %andclause32 ], [ %_40, %andclause34 ]
	br i1 %_31, label %if18, label %if19

if18:
	call void (i32) @print_int(i32 1)

	br label %if20

if19:

	call void (i32) @print_int(i32 0)

	br label %if20

if20:

	%_47 = load i8*, i8** %x
	%_46 = load i32, i8* %_47
	store i32 %_46, i32* %len

	%_48 = load i32, i32* %len
	call void (i32) @print_int(i32 %_48)

	%_58 = load i8*, i8** %x
	%_49 = load i32, i8* %_58
	%_50 = icmp ult i32 1, %_49
	br i1 %_50, label %oob55, label %oob56

oob55:
	%_51 = add i32 1, 1
	%_52 = getelementptr i32, i8* %_58, i32 %_51
	%_53 = load i32, i32* %_52
	br label %oob57

oob56:
	call void @throw_oob()
	br label %oob57

oob57:
	store i32 %_53, i1* %y

	%_62 = load i1, i1* %y
	br i1 %_62, label %if59, label %if60

if59:
	call void (i32) @print_int(i32 1)

	br label %if61

if60:

	call void (i32) @print_int(i32 0)

	br label %if61

if61:

	ret i32 0
}

