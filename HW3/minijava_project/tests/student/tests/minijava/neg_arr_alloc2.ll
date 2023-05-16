@.neg_arr_alloc2_vtable = global [0 x i8*] []


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
	%b = alloca i32*

	%x = alloca i32

	%_0 = sub i32 1, 2
	store i32 %_0, i32* %x

	%_7 = load i32, i32* %x
	%_4 = icmp slt i32 %_7, 0
	br i1 %_4, label %arr_alloc5, label %arr_alloc6

arr_alloc5:
	call void @throw_oob()
	br label %arr_alloc6

arr_alloc6:
	%_1 = add i32 %_7, 1
	%_2 = call i8* @calloc(i32 4, i32 %_1)
	%_3 = bitcast i8* %_2 to i32*
	store i32 %_7, i32* %_3
	store i32* %_3, i32** %b

	ret i32 0
}

