@.nested_loops_vtable = global [0 x i8*] []


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

	%z = alloca i32

	%x = alloca i32

	%sum = alloca i32

	%flag = alloca i1

	store i32 0, i32* %sum

	store i32 0, i32* %i

	br label %loop0

loop0:
	%_3 = load i32, i32* %i
	%_4 = icmp slt i32 %_3, 6
	br i1 %_4, label %loop1, label %loop2

loop1:
	store i32 0, i32* %j

	br label %loop5

loop5:
	%_8 = load i32, i32* %j
	%_9 = icmp slt i32 %_8, 5
	br i1 %_9, label %loop6, label %loop7

loop6:
	store i32 0, i32* %z

	br label %loop10

loop10:
	%_13 = load i32, i32* %z
	%_14 = icmp slt i32 %_13, 4
	br i1 %_14, label %loop11, label %loop12

loop11:
	store i32 0, i32* %x

	br label %loop15

loop15:
	%_18 = load i32, i32* %x
	%_19 = icmp slt i32 %_18, 4
	br i1 %_19, label %loop16, label %loop17

loop16:
	%_20 = load i32, i32* %sum
	%_21 = load i32, i32* %i
	%_22 = load i32, i32* %j
	%_23 = add i32 %_21, %_22
	%_24 = load i32, i32* %z
	%_25 = add i32 %_23, %_24
	%_26 = load i32, i32* %x
	%_27 = add i32 %_25, %_26
	%_28 = add i32 %_20, %_27
	store i32 %_28, i32* %sum

	%_29 = load i32, i32* %x
	%_30 = add i32 %_29, 1
	store i32 %_30, i32* %x

	br label %loop15

loop17:

	%_31 = load i32, i32* %z
	%_32 = add i32 %_31, 1
	store i32 %_32, i32* %z

	br label %loop10

loop12:

	%_33 = load i32, i32* %j
	%_34 = add i32 %_33, 1
	store i32 %_34, i32* %j

	br label %loop5

loop7:

	%_35 = load i32, i32* %i
	%_36 = add i32 %_35, 1
	store i32 %_36, i32* %i

	br label %loop0

loop2:

	%_37 = load i32, i32* %sum
	call void (i32) @print_int(i32 %_37)

	store i32 0, i32* %sum

	store i32 0, i32* %i

	store i1 1, i1* %flag

	br label %loop38

loop38:
	%_41 = load i32, i32* %i
	%_42 = icmp slt i32 %_41, 6
	br i1 %_42, label %loop39, label %loop40

loop39:
	store i32 0, i32* %j

	%_46 = load i1, i1* %flag
	br i1 %_46, label %if43, label %if44

if43:
	br label %loop47

loop47:
	%_50 = load i32, i32* %j
	%_51 = icmp slt i32 %_50, 5
	br i1 %_51, label %loop48, label %loop49

loop48:
	store i32 0, i32* %z

	br label %loop52

loop52:
	%_55 = load i32, i32* %z
	%_56 = icmp slt i32 %_55, 4
	br i1 %_56, label %loop53, label %loop54

loop53:
	store i32 0, i32* %x

	br label %loop57

loop57:
	%_60 = load i32, i32* %x
	%_61 = icmp slt i32 %_60, 4
	br i1 %_61, label %loop58, label %loop59

loop58:
	%_62 = load i32, i32* %sum
	%_63 = load i32, i32* %i
	%_64 = load i32, i32* %j
	%_65 = add i32 %_63, %_64
	%_66 = load i32, i32* %z
	%_67 = add i32 %_65, %_66
	%_68 = load i32, i32* %x
	%_69 = add i32 %_67, %_68
	%_70 = add i32 %_62, %_69
	store i32 %_70, i32* %sum

	%_71 = load i32, i32* %x
	%_72 = add i32 %_71, 1
	store i32 %_72, i32* %x

	br label %loop57

loop59:

	%_73 = load i32, i32* %z
	%_74 = add i32 %_73, 1
	store i32 %_74, i32* %z

	br label %loop52

loop54:

	%_75 = load i32, i32* %j
	%_76 = add i32 %_75, 1
	store i32 %_76, i32* %j

	br label %loop47

loop49:

	store i1 0, i1* %flag

	br label %if45

if44:

	br label %loop77

loop77:
	%_80 = load i32, i32* %j
	%_81 = icmp slt i32 %_80, 4
	br i1 %_81, label %loop78, label %loop79

loop78:
	store i32 0, i32* %z

	br label %loop82

loop82:
	%_85 = load i32, i32* %z
	%_86 = icmp slt i32 %_85, 10
	br i1 %_86, label %loop83, label %loop84

loop83:
	store i32 0, i32* %x

	br label %loop87

loop87:
	%_90 = load i32, i32* %x
	%_91 = icmp slt i32 %_90, 4
	br i1 %_91, label %loop88, label %loop89

loop88:
	%_92 = load i32, i32* %sum
	%_93 = load i32, i32* %i
	%_94 = load i32, i32* %j
	%_95 = mul i32 %_93, %_94
	%_96 = load i32, i32* %z
	%_97 = add i32 %_95, %_96
	%_98 = load i32, i32* %x
	%_99 = add i32 %_97, %_98
	%_100 = add i32 %_92, %_99
	store i32 %_100, i32* %sum

	%_101 = load i32, i32* %x
	%_102 = add i32 %_101, 1
	store i32 %_102, i32* %x

	br label %loop87

loop89:

	%_103 = load i32, i32* %z
	%_104 = add i32 %_103, 1
	store i32 %_104, i32* %z

	br label %loop82

loop84:

	%_105 = load i32, i32* %j
	%_106 = add i32 %_105, 1
	store i32 %_106, i32* %j

	br label %loop77

loop79:

	store i1 0, i1* %flag

	br label %if45

if45:

	%_107 = load i32, i32* %i
	%_108 = add i32 %_107, 1
	store i32 %_108, i32* %i

	br label %loop38

loop40:

	%_109 = load i32, i32* %sum
	call void (i32) @print_int(i32 %_109)

	ret i32 0
}

