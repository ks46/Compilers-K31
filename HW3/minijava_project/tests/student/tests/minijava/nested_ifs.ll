@.nested_ifs_vtable = global [0 x i8*] []


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
	%flag = alloca i1

	br i1 1, label %if0, label %if1

if0:
	br i1 1, label %if3, label %if4

if3:
	br i1 1, label %if6, label %if7

if6:
	br i1 1, label %if9, label %if10

if9:
	br i1 1, label %if12, label %if13

if12:
	call void (i32) @print_int(i32 1)

	br label %if14

if13:

	call void (i32) @print_int(i32 0)

	br label %if14

if14:

	call void (i32) @print_int(i32 2)

	br label %if11

if10:

	call void (i32) @print_int(i32 0)

	br label %if11

if11:

	call void (i32) @print_int(i32 3)

	br label %if8

if7:

	call void (i32) @print_int(i32 0)

	br label %if8

if8:

	call void (i32) @print_int(i32 4)

	br label %if5

if4:

	call void (i32) @print_int(i32 0)

	br label %if5

if5:

	call void (i32) @print_int(i32 5)

	br label %if2

if1:

	call void (i32) @print_int(i32 0)

	br label %if2

if2:

	br label %andclause16

andclause16:
	br i1 1, label %andclause17, label %andclause19

andclause17:
	br label %andclause18

andclause18:
	br label %andclause19

andclause19:
	%_15 = phi i1 [ 0, %andclause16 ], [ 1, %andclause18 ]
	br label %andclause21

andclause21:
	br i1 %_15, label %andclause22, label %andclause24

andclause22:
	%_25 = xor i1 1, 0
	br label %andclause27

andclause27:
	br i1 %_25, label %andclause28, label %andclause30

andclause28:
	%_31 = xor i1 1, 0
	br label %andclause29

andclause29:
	br label %andclause30

andclause30:
	%_26 = phi i1 [ 0, %andclause27 ], [ %_31, %andclause29 ]
	br label %andclause23

andclause23:
	br label %andclause24

andclause24:
	%_20 = phi i1 [ 0, %andclause21 ], [ %_26, %andclause23 ]
	br label %andclause33

andclause33:
	br i1 %_20, label %andclause34, label %andclause36

andclause34:
	%_37 = icmp slt i32 100, 1000
	br label %andclause35

andclause35:
	br label %andclause36

andclause36:
	%_32 = phi i1 [ 0, %andclause33 ], [ %_37, %andclause35 ]
	store i1 %_32, i1* %flag

	br label %andclause42

andclause42:
	br i1 1, label %andclause43, label %andclause45

andclause43:
	%_46 = load i1, i1* %flag
	br label %andclause44

andclause44:
	br label %andclause45

andclause45:
	%_41 = phi i1 [ 0, %andclause42 ], [ %_46, %andclause44 ]
	br label %andclause48

andclause48:
	br i1 %_41, label %andclause49, label %andclause51

andclause49:
	%_52 = xor i1 1, 0
	br label %andclause54

andclause54:
	br i1 %_52, label %andclause55, label %andclause57

andclause55:
	%_58 = xor i1 1, 0
	br label %andclause56

andclause56:
	br label %andclause57

andclause57:
	%_53 = phi i1 [ 0, %andclause54 ], [ %_58, %andclause56 ]
	br label %andclause50

andclause50:
	br label %andclause51

andclause51:
	%_47 = phi i1 [ 0, %andclause48 ], [ %_53, %andclause50 ]
	br i1 %_47, label %if38, label %if39

if38:
	br label %andclause63

andclause63:
	br i1 1, label %andclause64, label %andclause66

andclause64:
	%_67 = load i1, i1* %flag
	br label %andclause65

andclause65:
	br label %andclause66

andclause66:
	%_62 = phi i1 [ 0, %andclause63 ], [ %_67, %andclause65 ]
	br label %andclause69

andclause69:
	br i1 %_62, label %andclause70, label %andclause72

andclause70:
	%_73 = xor i1 1, 0
	br label %andclause75

andclause75:
	br i1 %_73, label %andclause76, label %andclause78

andclause76:
	%_79 = xor i1 1, 0
	br label %andclause77

andclause77:
	br label %andclause78

andclause78:
	%_74 = phi i1 [ 0, %andclause75 ], [ %_79, %andclause77 ]
	br label %andclause71

andclause71:
	br label %andclause72

andclause72:
	%_68 = phi i1 [ 0, %andclause69 ], [ %_74, %andclause71 ]
	br i1 %_68, label %if59, label %if60

if59:
	br label %andclause84

andclause84:
	br i1 1, label %andclause85, label %andclause87

andclause85:
	%_88 = load i1, i1* %flag
	br label %andclause86

andclause86:
	br label %andclause87

andclause87:
	%_83 = phi i1 [ 0, %andclause84 ], [ %_88, %andclause86 ]
	br label %andclause90

andclause90:
	br i1 %_83, label %andclause91, label %andclause93

andclause91:
	%_94 = xor i1 1, 0
	br label %andclause96

andclause96:
	br i1 %_94, label %andclause97, label %andclause99

andclause97:
	%_100 = xor i1 1, 0
	br label %andclause98

andclause98:
	br label %andclause99

andclause99:
	%_95 = phi i1 [ 0, %andclause96 ], [ %_100, %andclause98 ]
	br label %andclause92

andclause92:
	br label %andclause93

andclause93:
	%_89 = phi i1 [ 0, %andclause90 ], [ %_95, %andclause92 ]
	br i1 %_89, label %if80, label %if81

if80:
	br label %andclause105

andclause105:
	br i1 1, label %andclause106, label %andclause108

andclause106:
	%_109 = load i1, i1* %flag
	br label %andclause107

andclause107:
	br label %andclause108

andclause108:
	%_104 = phi i1 [ 0, %andclause105 ], [ %_109, %andclause107 ]
	br label %andclause111

andclause111:
	br i1 %_104, label %andclause112, label %andclause114

andclause112:
	%_115 = xor i1 1, 0
	br label %andclause117

andclause117:
	br i1 %_115, label %andclause118, label %andclause120

andclause118:
	%_121 = xor i1 1, 0
	br label %andclause119

andclause119:
	br label %andclause120

andclause120:
	%_116 = phi i1 [ 0, %andclause117 ], [ %_121, %andclause119 ]
	br label %andclause113

andclause113:
	br label %andclause114

andclause114:
	%_110 = phi i1 [ 0, %andclause111 ], [ %_116, %andclause113 ]
	br i1 %_110, label %if101, label %if102

if101:
	%_125 = load i1, i1* %flag
	br label %andclause127

andclause127:
	br i1 %_125, label %andclause128, label %andclause130

andclause128:
	%_131 = load i1, i1* %flag
	br label %andclause129

andclause129:
	br label %andclause130

andclause130:
	%_126 = phi i1 [ 0, %andclause127 ], [ %_131, %andclause129 ]
	br label %andclause133

andclause133:
	br i1 %_126, label %andclause134, label %andclause136

andclause134:
	%_137 = xor i1 1, 0
	br label %andclause139

andclause139:
	br i1 %_137, label %andclause140, label %andclause142

andclause140:
	%_143 = xor i1 1, 0
	br label %andclause141

andclause141:
	br label %andclause142

andclause142:
	%_138 = phi i1 [ 0, %andclause139 ], [ %_143, %andclause141 ]
	br label %andclause135

andclause135:
	br label %andclause136

andclause136:
	%_132 = phi i1 [ 0, %andclause133 ], [ %_138, %andclause135 ]
	br i1 %_132, label %if122, label %if123

if122:
	call void (i32) @print_int(i32 1)

	br label %if124

if123:

	call void (i32) @print_int(i32 0)

	br label %if124

if124:

	call void (i32) @print_int(i32 2)

	br label %if103

if102:

	call void (i32) @print_int(i32 0)

	br label %if103

if103:

	call void (i32) @print_int(i32 3)

	br label %if82

if81:

	call void (i32) @print_int(i32 0)

	br label %if82

if82:

	call void (i32) @print_int(i32 4)

	br label %if61

if60:

	call void (i32) @print_int(i32 0)

	br label %if61

if61:

	call void (i32) @print_int(i32 5)

	br label %if40

if39:

	call void (i32) @print_int(i32 0)

	br label %if40

if40:

	ret i32 0
}

