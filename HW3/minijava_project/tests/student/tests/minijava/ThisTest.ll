@.ThisTest_vtable = global [0 x i8*] []
@.A_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*,i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @A.bar to i8*)]
@.B_vtable = global [2 x i8*] [i8* bitcast (i32 (i8*,i8*)* @A.foo to i8*), i8* bitcast (i32 (i8*)* @A.bar to i8*)]


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
	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [2 x i8*], [2 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	; A.foo : 0
	%_3 = bitcast i8* %_0 to i8***
	%_4 = load i8**, i8*** %_3
	%_5 = getelementptr i8*, i8** %_4, i32 0
	%_6 = load i8*, i8** %_5
	%_7 = bitcast i8* %_6 to i32 (i8*,i8*)*
	%_9 = call i8* @calloc(i32 1, i32 8)
	%_10 = bitcast i8* %_9 to i8***
	%_11 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_11, i8*** %_10
	%_8 = call i32 %_7(i8* %_0, i8* %_9)
	call void (i32) @print_int(i32 %_8)

	ret i32 0
}

define i32 @A.foo(i8* %this, i8* %.a1) {
	%a1 = alloca i8*
	store i8* %.a1, i8** %a1
	store i8* %this, i8** %a1

	; A.bar : 1
	%_0 = bitcast i8* %this to i8***
	%_1 = load i8**, i8*** %_0
	%_2 = getelementptr i8*, i8** %_1, i32 1
	%_3 = load i8*, i8** %_2
	%_4 = bitcast i8* %_3 to i32 (i8*)*
	%_5 = call i32 %_4(i8* %this)
	ret i32 %_5
}

define i32 @A.bar(i8* %this) {
	ret i32 5
}

