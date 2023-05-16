@.And_vtable = global [0 x i8*] []


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
	%b = alloca i1

	%c = alloca i1

	%x = alloca i32

	store i1 0, i1* %b

	store i1 1, i1* %c

	%_3 = load i1, i1* %b
	br label %andclause5

andclause5:
	br i1 %_3, label %andclause6, label %andclause8

andclause6:
	%_9 = load i1, i1* %c
	br label %andclause7

andclause7:
	br label %andclause8

andclause8:
	%_4 = phi i1 [ 0, %andclause5 ], [ %_9, %andclause7 ]
	br i1 %_4, label %if0, label %if1

if0:
	store i32 0, i32* %x

	br label %if2

if1:

	store i32 1, i32* %x

	br label %if2

if2:

	%_10 = load i32, i32* %x
	call void (i32) @print_int(i32 %_10)

	ret i32 0
}

