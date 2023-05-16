@.And2_vtable = global [0 x i8*] []
@.A_vtable = global [3 x i8*] [i8* bitcast (i1 (i8*,i1,i1,i1)* @A.foo to i8*), i8* bitcast (i1 (i8*,i1,i1)* @A.bar to i8*), i8* bitcast (i1 (i8*,i1)* @A.print to i8*)]
@.B_vtable = global [2 x i8*] [i8* bitcast (i1 (i8*,i32)* @B.foo to i8*), i8* bitcast (i1 (i8*,i32,i32,i1,i1)* @B.t to i8*)]


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
	%dummy = alloca i1

	%a = alloca i8*

	%_0 = call i8* @calloc(i32 1, i32 8)
	%_1 = bitcast i8* %_0 to i8***
	%_2 = getelementptr [3 x i8*], [3 x i8*]* @.A_vtable, i32 0, i32 0
	store i8** %_2, i8*** %_1
	store i8* %_0, i8** %a

	%_3 = load i8*, i8** %a
	; A.print : 2
	%_4 = bitcast i8* %_3 to i8***
	%_5 = load i8**, i8*** %_4
	%_6 = getelementptr i8*, i8** %_5, i32 2
	%_7 = load i8*, i8** %_6
	%_8 = bitcast i8* %_7 to i1 (i8*,i1)*
	%_10 = load i8*, i8** %a
	; A.foo : 0
	%_11 = bitcast i8* %_10 to i8***
	%_12 = load i8**, i8*** %_11
	%_13 = getelementptr i8*, i8** %_12, i32 0
	%_14 = load i8*, i8** %_13
	%_15 = bitcast i8* %_14 to i1 (i8*,i1,i1,i1)*
	%_16 = call i1 %_15(i8* %_10, i1 0,i1 0,i1 0)
	%_9 = call i1 %_8(i8* %_3, i1 %_16)
	store i1 %_9, i1* %dummy

	%_17 = load i8*, i8** %a
	; A.print : 2
	%_18 = bitcast i8* %_17 to i8***
	%_19 = load i8**, i8*** %_18
	%_20 = getelementptr i8*, i8** %_19, i32 2
	%_21 = load i8*, i8** %_20
	%_22 = bitcast i8* %_21 to i1 (i8*,i1)*
	%_24 = load i8*, i8** %a
	; A.foo : 0
	%_25 = bitcast i8* %_24 to i8***
	%_26 = load i8**, i8*** %_25
	%_27 = getelementptr i8*, i8** %_26, i32 0
	%_28 = load i8*, i8** %_27
	%_29 = bitcast i8* %_28 to i1 (i8*,i1,i1,i1)*
	%_30 = call i1 %_29(i8* %_24, i1 0,i1 0,i1 1)
	%_23 = call i1 %_22(i8* %_17, i1 %_30)
	store i1 %_23, i1* %dummy

	%_31 = load i8*, i8** %a
	; A.print : 2
	%_32 = bitcast i8* %_31 to i8***
	%_33 = load i8**, i8*** %_32
	%_34 = getelementptr i8*, i8** %_33, i32 2
	%_35 = load i8*, i8** %_34
	%_36 = bitcast i8* %_35 to i1 (i8*,i1)*
	%_38 = load i8*, i8** %a
	; A.foo : 0
	%_39 = bitcast i8* %_38 to i8***
	%_40 = load i8**, i8*** %_39
	%_41 = getelementptr i8*, i8** %_40, i32 0
	%_42 = load i8*, i8** %_41
	%_43 = bitcast i8* %_42 to i1 (i8*,i1,i1,i1)*
	%_44 = call i1 %_43(i8* %_38, i1 0,i1 1,i1 0)
	%_37 = call i1 %_36(i8* %_31, i1 %_44)
	store i1 %_37, i1* %dummy

	%_45 = load i8*, i8** %a
	; A.print : 2
	%_46 = bitcast i8* %_45 to i8***
	%_47 = load i8**, i8*** %_46
	%_48 = getelementptr i8*, i8** %_47, i32 2
	%_49 = load i8*, i8** %_48
	%_50 = bitcast i8* %_49 to i1 (i8*,i1)*
	%_52 = load i8*, i8** %a
	; A.foo : 0
	%_53 = bitcast i8* %_52 to i8***
	%_54 = load i8**, i8*** %_53
	%_55 = getelementptr i8*, i8** %_54, i32 0
	%_56 = load i8*, i8** %_55
	%_57 = bitcast i8* %_56 to i1 (i8*,i1,i1,i1)*
	%_58 = call i1 %_57(i8* %_52, i1 0,i1 1,i1 1)
	%_51 = call i1 %_50(i8* %_45, i1 %_58)
	store i1 %_51, i1* %dummy

	%_59 = load i8*, i8** %a
	; A.print : 2
	%_60 = bitcast i8* %_59 to i8***
	%_61 = load i8**, i8*** %_60
	%_62 = getelementptr i8*, i8** %_61, i32 2
	%_63 = load i8*, i8** %_62
	%_64 = bitcast i8* %_63 to i1 (i8*,i1)*
	%_66 = load i8*, i8** %a
	; A.foo : 0
	%_67 = bitcast i8* %_66 to i8***
	%_68 = load i8**, i8*** %_67
	%_69 = getelementptr i8*, i8** %_68, i32 0
	%_70 = load i8*, i8** %_69
	%_71 = bitcast i8* %_70 to i1 (i8*,i1,i1,i1)*
	%_72 = call i1 %_71(i8* %_66, i1 1,i1 0,i1 0)
	%_65 = call i1 %_64(i8* %_59, i1 %_72)
	store i1 %_65, i1* %dummy

	%_73 = load i8*, i8** %a
	; A.print : 2
	%_74 = bitcast i8* %_73 to i8***
	%_75 = load i8**, i8*** %_74
	%_76 = getelementptr i8*, i8** %_75, i32 2
	%_77 = load i8*, i8** %_76
	%_78 = bitcast i8* %_77 to i1 (i8*,i1)*
	%_80 = load i8*, i8** %a
	; A.foo : 0
	%_81 = bitcast i8* %_80 to i8***
	%_82 = load i8**, i8*** %_81
	%_83 = getelementptr i8*, i8** %_82, i32 0
	%_84 = load i8*, i8** %_83
	%_85 = bitcast i8* %_84 to i1 (i8*,i1,i1,i1)*
	%_86 = call i1 %_85(i8* %_80, i1 1,i1 0,i1 1)
	%_79 = call i1 %_78(i8* %_73, i1 %_86)
	store i1 %_79, i1* %dummy

	%_87 = load i8*, i8** %a
	; A.print : 2
	%_88 = bitcast i8* %_87 to i8***
	%_89 = load i8**, i8*** %_88
	%_90 = getelementptr i8*, i8** %_89, i32 2
	%_91 = load i8*, i8** %_90
	%_92 = bitcast i8* %_91 to i1 (i8*,i1)*
	%_94 = load i8*, i8** %a
	; A.foo : 0
	%_95 = bitcast i8* %_94 to i8***
	%_96 = load i8**, i8*** %_95
	%_97 = getelementptr i8*, i8** %_96, i32 0
	%_98 = load i8*, i8** %_97
	%_99 = bitcast i8* %_98 to i1 (i8*,i1,i1,i1)*
	%_100 = call i1 %_99(i8* %_94, i1 1,i1 1,i1 0)
	%_93 = call i1 %_92(i8* %_87, i1 %_100)
	store i1 %_93, i1* %dummy

	%_101 = load i8*, i8** %a
	; A.print : 2
	%_102 = bitcast i8* %_101 to i8***
	%_103 = load i8**, i8*** %_102
	%_104 = getelementptr i8*, i8** %_103, i32 2
	%_105 = load i8*, i8** %_104
	%_106 = bitcast i8* %_105 to i1 (i8*,i1)*
	%_108 = load i8*, i8** %a
	; A.foo : 0
	%_109 = bitcast i8* %_108 to i8***
	%_110 = load i8**, i8*** %_109
	%_111 = getelementptr i8*, i8** %_110, i32 0
	%_112 = load i8*, i8** %_111
	%_113 = bitcast i8* %_112 to i1 (i8*,i1,i1,i1)*
	%_114 = call i1 %_113(i8* %_108, i1 1,i1 1,i1 1)
	%_107 = call i1 %_106(i8* %_101, i1 %_114)
	store i1 %_107, i1* %dummy

	%_115 = load i8*, i8** %a
	; A.print : 2
	%_116 = bitcast i8* %_115 to i8***
	%_117 = load i8**, i8*** %_116
	%_118 = getelementptr i8*, i8** %_117, i32 2
	%_119 = load i8*, i8** %_118
	%_120 = bitcast i8* %_119 to i1 (i8*,i1)*
	%_122 = load i8*, i8** %a
	; A.bar : 1
	%_123 = bitcast i8* %_122 to i8***
	%_124 = load i8**, i8*** %_123
	%_125 = getelementptr i8*, i8** %_124, i32 1
	%_126 = load i8*, i8** %_125
	%_127 = bitcast i8* %_126 to i1 (i8*,i1,i1)*
	%_128 = call i1 %_127(i8* %_122, i1 1,i1 1)
	%_121 = call i1 %_120(i8* %_115, i1 %_128)
	store i1 %_121, i1* %dummy

	%_129 = load i8*, i8** %a
	; A.print : 2
	%_130 = bitcast i8* %_129 to i8***
	%_131 = load i8**, i8*** %_130
	%_132 = getelementptr i8*, i8** %_131, i32 2
	%_133 = load i8*, i8** %_132
	%_134 = bitcast i8* %_133 to i1 (i8*,i1)*
	%_136 = load i8*, i8** %a
	; A.bar : 1
	%_137 = bitcast i8* %_136 to i8***
	%_138 = load i8**, i8*** %_137
	%_139 = getelementptr i8*, i8** %_138, i32 1
	%_140 = load i8*, i8** %_139
	%_141 = bitcast i8* %_140 to i1 (i8*,i1,i1)*
	%_142 = call i1 %_141(i8* %_136, i1 0,i1 1)
	%_135 = call i1 %_134(i8* %_129, i1 %_142)
	store i1 %_135, i1* %dummy

	%_143 = load i8*, i8** %a
	; A.print : 2
	%_144 = bitcast i8* %_143 to i8***
	%_145 = load i8**, i8*** %_144
	%_146 = getelementptr i8*, i8** %_145, i32 2
	%_147 = load i8*, i8** %_146
	%_148 = bitcast i8* %_147 to i1 (i8*,i1)*
	%_150 = call i8* @calloc(i32 1, i32 8)
	%_151 = bitcast i8* %_150 to i8***
	%_152 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_152, i8*** %_151
	; B.foo : 0
	%_153 = bitcast i8* %_150 to i8***
	%_154 = load i8**, i8*** %_153
	%_155 = getelementptr i8*, i8** %_154, i32 0
	%_156 = load i8*, i8** %_155
	%_157 = bitcast i8* %_156 to i1 (i8*,i32)*
	%_158 = call i1 %_157(i8* %_150, i32 1)
	%_149 = call i1 %_148(i8* %_143, i1 %_158)
	store i1 %_149, i1* %dummy

	%_159 = load i8*, i8** %a
	; A.print : 2
	%_160 = bitcast i8* %_159 to i8***
	%_161 = load i8**, i8*** %_160
	%_162 = getelementptr i8*, i8** %_161, i32 2
	%_163 = load i8*, i8** %_162
	%_164 = bitcast i8* %_163 to i1 (i8*,i1)*
	%_166 = call i8* @calloc(i32 1, i32 8)
	%_167 = bitcast i8* %_166 to i8***
	%_168 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_168, i8*** %_167
	; B.foo : 0
	%_169 = bitcast i8* %_166 to i8***
	%_170 = load i8**, i8*** %_169
	%_171 = getelementptr i8*, i8** %_170, i32 0
	%_172 = load i8*, i8** %_171
	%_173 = bitcast i8* %_172 to i1 (i8*,i32)*
	%_174 = call i1 %_173(i8* %_166, i32 2)
	%_165 = call i1 %_164(i8* %_159, i1 %_174)
	store i1 %_165, i1* %dummy

	%_175 = load i8*, i8** %a
	; A.print : 2
	%_176 = bitcast i8* %_175 to i8***
	%_177 = load i8**, i8*** %_176
	%_178 = getelementptr i8*, i8** %_177, i32 2
	%_179 = load i8*, i8** %_178
	%_180 = bitcast i8* %_179 to i1 (i8*,i1)*
	%_182 = call i8* @calloc(i32 1, i32 8)
	%_183 = bitcast i8* %_182 to i8***
	%_184 = getelementptr [2 x i8*], [2 x i8*]* @.B_vtable, i32 0, i32 0
	store i8** %_184, i8*** %_183
	; B.t : 1
	%_185 = bitcast i8* %_182 to i8***
	%_186 = load i8**, i8*** %_185
	%_187 = getelementptr i8*, i8** %_186, i32 1
	%_188 = load i8*, i8** %_187
	%_189 = bitcast i8* %_188 to i1 (i8*,i32,i32,i1,i1)*
	%_190 = call i1 %_189(i8* %_182, i32 2,i32 2,i1 1,i1 1)
	%_181 = call i1 %_180(i8* %_175, i1 %_190)
	store i1 %_181, i1* %dummy

	ret i32 0
}

define i1 @A.foo(i8* %this, i1 %.a, i1 %.b, i1 %.c) {
	%a = alloca i1
	store i1 %.a, i1* %a
	%b = alloca i1
	store i1 %.b, i1* %b
	%c = alloca i1
	store i1 %.c, i1* %c
	%_0 = load i1, i1* %a
	br label %andclause2

andclause2:
	br i1 %_0, label %andclause3, label %andclause5

andclause3:
	%_6 = load i1, i1* %b
	br label %andclause4

andclause4:
	br label %andclause5

andclause5:
	%_1 = phi i1 [ 0, %andclause2 ], [ %_6, %andclause4 ]
	br label %andclause8

andclause8:
	br i1 %_1, label %andclause9, label %andclause11

andclause9:
	%_12 = load i1, i1* %c
	br label %andclause10

andclause10:
	br label %andclause11

andclause11:
	%_7 = phi i1 [ 0, %andclause8 ], [ %_12, %andclause10 ]
	ret i1 %_7
}

define i1 @A.bar(i8* %this, i1 %.a, i1 %.b) {
	%a = alloca i1
	store i1 %.a, i1* %a
	%b = alloca i1
	store i1 %.b, i1* %b
	%_0 = load i1, i1* %a
	br label %andclause2

andclause2:
	br i1 %_0, label %andclause3, label %andclause5

andclause3:
	; A.foo : 0
	%_6 = bitcast i8* %this to i8***
	%_7 = load i8**, i8*** %_6
	%_8 = getelementptr i8*, i8** %_7, i32 0
	%_9 = load i8*, i8** %_8
	%_10 = bitcast i8* %_9 to i1 (i8*,i1,i1,i1)*
	%_12 = load i1, i1* %a
	%_13 = load i1, i1* %b
	%_11 = call i1 %_10(i8* %this, i1 %_12,i1 %_13,i1 1)
	br label %andclause4

andclause4:
	br label %andclause5

andclause5:
	%_1 = phi i1 [ 0, %andclause2 ], [ %_11, %andclause4 ]
	br label %andclause15

andclause15:
	br i1 %_1, label %andclause16, label %andclause18

andclause16:
	%_19 = load i1, i1* %b
	br label %andclause17

andclause17:
	br label %andclause18

andclause18:
	%_14 = phi i1 [ 0, %andclause15 ], [ %_19, %andclause17 ]
	ret i1 %_14
}

define i1 @A.print(i8* %this, i1 %.res) {
	%res = alloca i1
	store i1 %.res, i1* %res
	%_3 = load i1, i1* %res
	br i1 %_3, label %if0, label %if1

if0:
	call void (i32) @print_int(i32 1)

	br label %if2

if1:

	call void (i32) @print_int(i32 0)

	br label %if2

if2:

	ret i1 1
}

define i1 @B.foo(i8* %this, i32 %.a) {
	%a = alloca i32
	store i32 %.a, i32* %a
	%_1 = load i32, i32* %a
	%_2 = add i32 %_1, 2
	%_3 = icmp slt i32 3, %_2
	%_0 = xor i1 1, %_3
	br label %andclause5

andclause5:
	br i1 %_0, label %andclause6, label %andclause8

andclause6:
	%_9 = xor i1 1, 0
	br label %andclause7

andclause7:
	br label %andclause8

andclause8:
	%_4 = phi i1 [ 0, %andclause5 ], [ %_9, %andclause7 ]
	ret i1 %_4
}

define i1 @B.t(i8* %this, i32 %.a, i32 %.b, i1 %.c, i1 %.d) {
	%a = alloca i32
	store i32 %.a, i32* %a
	%b = alloca i32
	store i32 %.b, i32* %b
	%c = alloca i1
	store i1 %.c, i1* %c
	%d = alloca i1
	store i1 %.d, i1* %d
	%_1 = load i32, i32* %a
	%_2 = load i32, i32* %b
	%_3 = icmp slt i32 %_1, %_2
	%_0 = xor i1 1, %_3
	br label %andclause5

andclause5:
	br i1 %_0, label %andclause6, label %andclause8

andclause6:
	%_9 = load i1, i1* %c
	br label %andclause11

andclause11:
	br i1 %_9, label %andclause12, label %andclause14

andclause12:
	%_15 = load i1, i1* %d
	br label %andclause13

andclause13:
	br label %andclause14

andclause14:
	%_10 = phi i1 [ 0, %andclause11 ], [ %_15, %andclause13 ]
	br label %andclause7

andclause7:
	br label %andclause8

andclause8:
	%_4 = phi i1 [ 0, %andclause5 ], [ %_10, %andclause7 ]
	ret i1 %_4
}

