@.VarDeclDemo_vtable = global [0 x i8*] []
@.A_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*,i8*,i8*)* @A.foo to i8*)]
@.B_vtable = global [1 x i8*] [i8* bitcast (i32 (i8*,i8*,i8*)* @B.foo to i8*)]


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
	%x = alloca i32

	%y = alloca i32

	%z = alloca i1

	%w = alloca i32*

	%a = alloca i8*

	%b = alloca i8*

	ret i32 0
}

define i32 @A.foo(i8* %this, i8* %.a, i8* %.b) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%b = alloca i8*
	store i8* %.b, i8** %b
	%x = alloca i32

	%y = alloca i32

	ret i32 5
}

define i32 @B.foo(i8* %this, i8* %.a, i8* %.b) {
	%a = alloca i8*
	store i8* %.a, i8** %a
	%b = alloca i8*
	store i8* %.b, i8** %b
	%k = alloca i8*

	%l = alloca i8*

	%x = alloca i32*

	ret i32 6
}

