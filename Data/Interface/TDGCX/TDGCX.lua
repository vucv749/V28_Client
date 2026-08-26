--2023Q1版本稳活-天灯共辰星
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 890227
local g_UICOMMAND = 89022701
local g_ChooseItemNum = 6
local g_SpaceNumMax = 8
local g_UI_Items = {}
local g_GameTime = 90
local g_objCared = -1
local g_GameLevel = {
    [1] = { --Solo Game

		[1]={
			chooseTexts = {
				"#{TDCX_221220_210}",
				"#{TDCX_221220_195}",
				"#{TDCX_221220_202}",
				"#{TDCX_221220_235}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_222}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_1 image:TDGCX_Day1_06",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_2 image:TDGCX_Day5_02",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_01",
							"set:TDGCX_1 image:TDGCX_Day1_02",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_1 image:TDGCX_Day1_04",
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_1 image:TDGCX_Day1_08",
						},
			answer = {2,}

		},
		[2]={
			chooseTexts = {
				"#{TDCX_221220_206}",
				"#{TDCX_221220_237}",
				"#{TDCX_221220_235}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_202}",
				"#{TDCX_221220_191}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_03",
							"set:TDGCX_3 image:TDGCX_Day6_08",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_1 image:TDGCX_Day1_02",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_01",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_1 image:TDGCX_Day1_04",
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"set:TDGCX_1 image:TDGCX_Day1_06",
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_1 image:TDGCX_Day1_08",
						},
			answer = {6,}
		},
		[3]={
			chooseTexts = {
				"#{TDCX_221220_199}",
				"#{TDCX_221220_216}",
				"#{TDCX_221220_210}",
				"#{TDCX_221220_235}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_222}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_2 image:TDGCX_Day5_02",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_01",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_1 image:TDGCX_Day2_04",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_1 image:TDGCX_Day2_07",
							"set:TDGCX_1 image:TDGCX_Day2_08",
						},
			answer = {1,}
		},
		[4]={
			chooseTexts = {
				"#{TDCX_221220_206}",
				"#{TDCX_221220_237}",
				"#{TDCX_221220_235}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_203}",
				"#{TDCX_221220_213}",
						},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_03",
							"set:TDGCX_3 image:TDGCX_Day6_08",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_1 image:TDGCX_Day2_07",
							"set:TDGCX_2 image:TDGCX_Day4_02",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_01",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_1 image:TDGCX_Day2_04",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_08",
						},
			answer = {5,}

		},
		[5]={
			chooseTexts = {
				"#{TDCX_221220_196}",
				"#{TDCX_221220_233}",
				"#{TDCX_221220_200}",
				"#{TDCX_221220_210}",
				"#{TDCX_221220_212}",
				"#{TDCX_221220_231}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_2 image:TDGCX_Day4_01",
							"set:TDGCX_3 image:TDGCX_Day6_02",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_01",
							"set:TDGCX_2 image:TDGCX_Day3_02",
							"set:TDGCX_2 image:TDGCX_Day3_03",
							"set:TDGCX_2 image:TDGCX_Day3_04",
							"set:TDGCX_2 image:TDGCX_Day3_05",
							"set:TDGCX_2 image:TDGCX_Day3_06",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_08",
						},
			answer = {4,}

		},
		[6]={
			chooseTexts = {
				"#{TDCX_221220_239}",
				"#{TDCX_221220_192}",
				"#{TDCX_221220_201}",
				"#{TDCX_221220_231}",
				"#{TDCX_221220_244}",
				"#{TDCX_221220_206}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_02",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_2 image:TDGCX_Day3_03",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_01",
							"set:TDGCX_2 image:TDGCX_Day3_02",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_04",
							"set:TDGCX_2 image:TDGCX_Day3_05",
							"set:TDGCX_2 image:TDGCX_Day3_06",
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_2 image:TDGCX_Day3_08",
						},
			answer = {6,}

		},
		[7]={
			chooseTexts = {
				"#{TDCX_221220_240}",
				"#{TDCX_221220_192}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_201}",
				"#{TDCX_221220_222}",
				"#{TDCX_221220_210}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"set:TDGCX_2 image:TDGCX_Day3_07",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_01",
							"set:TDGCX_2 image:TDGCX_Day4_02",
							"",
							"set:TDGCX_2 image:TDGCX_Day4_04",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_2 image:TDGCX_Day4_06",
							"set:TDGCX_2 image:TDGCX_Day4_07",
							"set:TDGCX_2 image:TDGCX_Day4_08",
						},
			answer = {3,}

		},
		[8]={
			chooseTexts = {
				"#{TDCX_221220_194}",
				"#{TDCX_221220_244}",
				"#{TDCX_221220_228}",
				"#{TDCX_221220_231}",
				"#{TDCX_221220_215}",
				"#{TDCX_221220_198}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"set:TDGCX_2 image:TDGCX_Day4_04",
							"set:TDGCX_1 image:TDGCX_Day2_01",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_01",
							"set:TDGCX_2 image:TDGCX_Day4_02",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_2 image:TDGCX_Day4_06",
							"set:TDGCX_2 image:TDGCX_Day4_07",
							"set:TDGCX_2 image:TDGCX_Day4_08",
						},
			answer = {5,}

		},
		[9]={
			chooseTexts = {
				"#{TDCX_221220_243}",
				"#{TDCX_221220_235}",
				"#{TDCX_221220_228}",
				"#{TDCX_221220_196}",
				"#{TDCX_221220_240}",
				"#{TDCX_221220_191}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"set:TDGCX_1 image:TDGCX_Day1_02",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_01",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_2 image:TDGCX_Day5_04",
							"set:TDGCX_2 image:TDGCX_Day5_05",
							"set:TDGCX_2 image:TDGCX_Day5_06",
							"",
							"set:TDGCX_2 image:TDGCX_Day5_08",
						},
			answer = {3,}

		},
		[10]={
			chooseTexts = {
				"#{TDCX_221220_202}",
				"#{TDCX_221220_233}",
				"#{TDCX_221220_234}",
				"#{TDCX_221220_243}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_229}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_2 image:TDGCX_Day5_08",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_01",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_2 image:TDGCX_Day5_04",
							"set:TDGCX_2 image:TDGCX_Day5_05",
							"set:TDGCX_2 image:TDGCX_Day5_06",
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"",
						},
			answer = {6,}

		},
		[11]={
			chooseTexts = {
				"#{TDCX_221220_235}",
				"#{TDCX_221220_200}",
				"#{TDCX_221220_199}",
				"#{TDCX_221220_229}",
				"#{TDCX_221220_191}",
				"#{TDCX_221220_208}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_2 image:TDGCX_Day5_08",
							"set:TDGCX_1 image:TDGCX_Day1_02",
							"set:TDGCX_2 image:TDGCX_Day3_05",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"set:TDGCX_3 image:TDGCX_Day6_03",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"set:TDGCX_3 image:TDGCX_Day6_08",
						},
			answer = {1,}

		},
		[12]={
			chooseTexts = {
				"#{TDCX_221220_215}",
				"#{TDCX_221220_228}",
				"#{TDCX_221220_203}",
				"#{TDCX_221220_199}",
				"#{TDCX_221220_232}",
				"#{TDCX_221220_222}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_04",
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_1 image:TDGCX_Day2_07",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_3 image:TDGCX_Day6_03",
							"set:TDGCX_2 image:TDGCX_Day5_02",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"set:TDGCX_3 image:TDGCX_Day6_08",
						},
			answer = {5,}

		},
		[13]={
			chooseTexts = {
				"#{TDCX_221220_200}",
				"#{TDCX_221220_240}",
				"#{TDCX_221220_213}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_230}",
				"#{TDCX_221220_195}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"set:TDGCX_2 image:TDGCX_Day4_02",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_1 image:TDGCX_Day1_06",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_01",
							"set:TDGCX_3 image:TDGCX_Day7_02",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_04",
							"set:TDGCX_3 image:TDGCX_Day7_05",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_3 image:TDGCX_Day7_08",
						},
			answer = {2,}

		},
		[14]={
			chooseTexts = {
				"#{TDCX_221220_192}",
				"#{TDCX_221220_223}",
				"#{TDCX_221220_236}",
				"#{TDCX_221220_213}",
				"#{TDCX_221220_216}",
				"#{TDCX_221220_241}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"set:TDGCX_2 image:TDGCX_Day4_02",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_3 image:TDGCX_Day7_04",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_01",
							"set:TDGCX_3 image:TDGCX_Day7_02",
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_05",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_3 image:TDGCX_Day7_08",
						},
			answer = {6,}

		},
		
	},
    [2] = { --Team Game

		[1]={
			chooseTexts = {
				"#{TDCX_221220_217}",
				"#{TDCX_221220_195}",
				"#{TDCX_221220_223}",
				"#{TDCX_221220_198}",
				"#{TDCX_221220_192}",
				"#{TDCX_221220_191}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_06",
							"set:TDGCX_1 image:TDGCX_Day1_06",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_1 image:TDGCX_Day2_01",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_1 image:TDGCX_Day1_02",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_01",
							"",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_04",
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_1 image:TDGCX_Day1_08",
						},
			answer = {6,5,2,}

		},
		[2]={
			chooseTexts = {
				"#{TDCX_221220_228}",
				"#{TDCX_221220_194}",
				"#{TDCX_221220_234}",
				"#{TDCX_221220_191}",
				"#{TDCX_221220_230}",
				"#{TDCX_221220_196}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"set:TDGCX_1 image:TDGCX_Day1_02",
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_1 image:TDGCX_Day1_07",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_01",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_03",
							"set:TDGCX_1 image:TDGCX_Day1_04",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_06",
							"",
							"set:TDGCX_1 image:TDGCX_Day1_08",
						},
			answer = {4,2,6,}

		},
		[3]={
			chooseTexts = {
				"#{TDCX_221220_191}",
				"#{TDCX_221220_203}",
				"#{TDCX_221220_219}",
				"#{TDCX_221220_201}",
				"#{TDCX_221220_199}",
				"#{TDCX_221220_208}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_02",
							"set:TDGCX_1 image:TDGCX_Day2_07",
							"set:TDGCX_2 image:TDGCX_Day4_08",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_2 image:TDGCX_Day3_05",
						},
			spaceImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_01",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_1 image:TDGCX_Day2_04",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_08",
						},
			answer = {5,4,2,}

		},
		[4]={
			chooseTexts = {
				"#{TDCX_221220_232}",
				"#{TDCX_221220_198}",
				"#{TDCX_221220_222}",
				"#{TDCX_221220_202}",
				"#{TDCX_221220_241}",
				"#{TDCX_221220_200}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_03",
							"set:TDGCX_1 image:TDGCX_Day2_01",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_3 image:TDGCX_Day7_04",
							"set:TDGCX_1 image:TDGCX_Day2_03",
						},
			spaceImgs = {
							"",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_04",
							"set:TDGCX_1 image:TDGCX_Day2_05",
							"",
							"set:TDGCX_1 image:TDGCX_Day2_07",
							"set:TDGCX_1 image:TDGCX_Day2_08",
						},
			answer = {2,6,4,}
 
		},
		[5]={
			chooseTexts = {
				"#{TDCX_221220_208}",
				"#{TDCX_221220_218}",
				"#{TDCX_221220_199}",
				"#{TDCX_221220_210}",
				"#{TDCX_221220_195}",
				"#{TDCX_221220_206}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_05",
							"set:TDGCX_2 image:TDGCX_Day4_07",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_1 image:TDGCX_Day1_06",
							"set:TDGCX_2 image:TDGCX_Day3_03",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_01",
							"set:TDGCX_2 image:TDGCX_Day3_02",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_04",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_06",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_08",
						},
			answer = {6,1,4,}

		},
		[6]={
			chooseTexts = {
				"#{TDCX_221220_194}",
				"#{TDCX_221220_211}",
				"#{TDCX_221220_196}",
				"#{TDCX_221220_208}",
				"#{TDCX_221220_202}",
				"#{TDCX_221220_207}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day1_05",
							"set:TDGCX_2 image:TDGCX_Day3_08",
							"set:TDGCX_1 image:TDGCX_Day1_07",
							"set:TDGCX_2 image:TDGCX_Day3_05",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_2 image:TDGCX_Day3_04",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_01",
							"set:TDGCX_2 image:TDGCX_Day3_02",
							"set:TDGCX_2 image:TDGCX_Day3_03",
							"",
							"",
							"set:TDGCX_2 image:TDGCX_Day3_06",
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"",
						},
			answer = {6,4,2,}

		},
		[7]={
			chooseTexts = {
				"#{TDCX_221220_214}",
				"#{TDCX_221220_204}",
				"#{TDCX_221220_218}",
				"#{TDCX_221220_199}",
				"#{TDCX_221220_200}",
				"#{TDCX_221220_213}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_2 image:TDGCX_Day3_01",
							"set:TDGCX_2 image:TDGCX_Day4_07",
							"set:TDGCX_1 image:TDGCX_Day2_02",
							"set:TDGCX_1 image:TDGCX_Day2_03",
							"set:TDGCX_2 image:TDGCX_Day4_02",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day4_01",
							"",
							"",
							"set:TDGCX_2 image:TDGCX_Day4_04",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_2 image:TDGCX_Day4_06",
							"",
							"set:TDGCX_2 image:TDGCX_Day4_08",
						},
			answer = {6,1,3,}

		},
		[8]={
			chooseTexts = {
				"#{TDCX_221220_228}",
				"#{TDCX_221220_219}",
				"#{TDCX_221220_244}",
				"#{TDCX_221220_215}",
				"#{TDCX_221220_232}",
				"#{TDCX_221220_212}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_2 image:TDGCX_Day4_08",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_2 image:TDGCX_Day4_04",
							"set:TDGCX_3 image:TDGCX_Day6_03",
							"set:TDGCX_2 image:TDGCX_Day4_01",
						},
			spaceImgs = {
							"",
							"set:TDGCX_2 image:TDGCX_Day4_02",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"",
							"set:TDGCX_2 image:TDGCX_Day4_05",
							"set:TDGCX_2 image:TDGCX_Day4_06",
							"set:TDGCX_2 image:TDGCX_Day4_07",
							"",
						},
			answer = {6,4,2,}

		},
		[9]={
			chooseTexts = {
				"#{TDCX_221220_227}",
				"#{TDCX_221220_229}",
				"#{TDCX_221220_240}",
				"#{TDCX_221220_237}",
				"#{TDCX_221220_222}",
				"#{TDCX_221220_235}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_06",
							"set:TDGCX_2 image:TDGCX_Day5_08",
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"set:TDGCX_3 image:TDGCX_Day6_08",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"set:TDGCX_3 image:TDGCX_Day6_06",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_01",
							"",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_2 image:TDGCX_Day5_04",
							"set:TDGCX_2 image:TDGCX_Day5_05",
							"",
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"",
						},
			answer = {5,1,2,}

		},
		[10]={
			chooseTexts = {
				"#{TDCX_221220_228}",
				"#{TDCX_221220_223}",
				"#{TDCX_221220_233}",
				"#{TDCX_221220_202}",
				"#{TDCX_221220_227}",
				"#{TDCX_221220_214}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_07",
							"set:TDGCX_2 image:TDGCX_Day5_03",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_2 image:TDGCX_Day5_06",
							"set:TDGCX_2 image:TDGCX_Day4_03",
						},
			spaceImgs = {
							"set:TDGCX_2 image:TDGCX_Day5_01",
							"set:TDGCX_2 image:TDGCX_Day5_02",
							"",
							"set:TDGCX_2 image:TDGCX_Day5_04",
							"set:TDGCX_2 image:TDGCX_Day5_05",
							"",
							"",
							"set:TDGCX_2 image:TDGCX_Day5_08",
						},
			answer = {2,5,1,}

		},
		[11]={
			chooseTexts = {
				"#{TDCX_221220_235}",
				"#{TDCX_221220_224}",
				"#{TDCX_221220_233}",
				"#{TDCX_221220_244}",
				"#{TDCX_221220_245}",
				"#{TDCX_221220_237}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"set:TDGCX_2 image:TDGCX_Day5_04",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_3 image:TDGCX_Day7_08",
							"set:TDGCX_3 image:TDGCX_Day6_08",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"set:TDGCX_3 image:TDGCX_Day6_03",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"",
						},
			answer = {3,1,6,}

		},
		[12]={
			chooseTexts = {
				"#{TDCX_221220_210}",
				"#{TDCX_221220_234}",
				"#{TDCX_221220_229}",
				"#{TDCX_221220_236}",
				"#{TDCX_221220_243}",
				"#{TDCX_221220_232}",
			},
			chooseImgs = {
							"set:TDGCX_2 image:TDGCX_Day3_07",
							"set:TDGCX_3 image:TDGCX_Day6_05",
							"set:TDGCX_2 image:TDGCX_Day5_08",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_3 image:TDGCX_Day6_03",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_3 image:TDGCX_Day6_02",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_04",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_06",
							"",
							"set:TDGCX_3 image:TDGCX_Day6_08",
						},
			answer = {6,2,4,}

		},
		[13]={
			chooseTexts = {
				"#{TDCX_221220_202}",
				"#{TDCX_221220_243}",
				"#{TDCX_221220_230}",
				"#{TDCX_221220_245}",
				"#{TDCX_221220_208}",
				"#{TDCX_221220_240}",
			},
			chooseImgs = {
							"set:TDGCX_1 image:TDGCX_Day2_06",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"set:TDGCX_3 image:TDGCX_Day6_01",
							"set:TDGCX_3 image:TDGCX_Day7_08",
							"set:TDGCX_2 image:TDGCX_Day3_05",
							"set:TDGCX_3 image:TDGCX_Day7_03",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_01",
							"set:TDGCX_3 image:TDGCX_Day7_02",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_04",
							"set:TDGCX_3 image:TDGCX_Day7_05",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"",
						},
			answer = {6,2,4,}

		},
		[14]={
			chooseTexts = {
				"#{TDCX_221220_241}",
				"#{TDCX_221220_236}",
				"#{TDCX_221220_214}",
				"#{TDCX_221220_227}",
				"#{TDCX_221220_244}",
				"#{TDCX_221220_239}",
			},
			chooseImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_04",
							"set:TDGCX_3 image:TDGCX_Day6_07",
							"set:TDGCX_2 image:TDGCX_Day4_03",
							"set:TDGCX_2 image:TDGCX_Day5_06",
							"set:TDGCX_3 image:TDGCX_Day7_07",
							"set:TDGCX_3 image:TDGCX_Day7_02",
						},
			spaceImgs = {
							"set:TDGCX_3 image:TDGCX_Day7_01",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_03",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_05",
							"set:TDGCX_3 image:TDGCX_Day7_06",
							"",
							"set:TDGCX_3 image:TDGCX_Day7_08",
						},
			answer = {6,1,5,}

        },
        

	}
}
local TDGCX_MAX_OBJ_DISTANCE = 10.0; --lua??objcare???? ?care?CObjectManager::Tick?
local g_GameData = {
	--0:invalid 1:solo 2:team
	gameType = 0,  
	--游戏的关卡号 每次随机一个关卡
	gameLevelIndex = 0,
	-- [solo] 0:未开始 1:狚在填词 4倒计时结束 5游戏结束 
	-- [team] 0:未开始 1:玩家1号在填词 2:玩家2号在填词 3:玩家3号在填词 4:倒计时结束 5游戏结束
	gameState = 0, 
	--需要被填繝的item序号
	gameSpaceIndexs = {0,0,0},
	--诗句条目数量 
	gameWordsItemsNum = 0,
	--玩家序号
	playerIndex = 0,
	--玩家已填充诗句的序号
	playerChoose = {0,0,0},
	playerNameThisTurn = "",

	playerIsTeamLeader = 0,
	
	--Fade阶段牴示一个item所需要的时间
	showingOneItemSec = 1, 
	showingIndex = 0,
	from_to_alpha_Showing = "",
	from_to_alpha_Disppering = "",
	from_to_alpha_FadeIn = "",
}

local g_StateEnum = {
	INVALID =  0,
	PLAYING1 = 1,
	PLAYING2 = 2,
	PLAYING3 = 3,
	COMPLETED = 4,
	TIMEOUT =  5,
	GAMEOVER = 6
}

local g_LineImgs = {
	currentUp = "set:TDGCX_2 image:TDGCX_Blank1_Hover",
	currentDown = "set:TDGCX_2 image:TDGCX_Blank2_Hover",
	spaceUp = "set:TDGCX_1 image:TDGCX_Blank1_Disabled",
	spaceDown = "set:TDGCX_1 image:TDGCX_Blank2_Disabled",
}

local g_FadeSetting = {
	FadeInSec = 2,
	ShowingSec = 10,
	idleSec = 2,
	DispperingSec = 2,
}

local function CheckGamePlaying()
	if g_GameData.gameType < 1 or g_GameData.gameType > 2 then
		return false
	end
	if not g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex] then
		return false
	end
	if  g_GameData.gameState < g_StateEnum.PLAYING1 or g_GameData.gameState > g_StateEnum.PLAYING3   then
		return false
	end
	if  g_GameData.playerIndex <= 0 then
		return false
	end
	return true
end

local function JudgeAnswer()
	--检查答案 错的标记出来
	local result = 1
	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	if not levelInfo then
		return 0
	end
	
	for i = 1, 3 do
		local  playerChoosed =  g_GameData.playerChoose[i]
		if playerChoosed ~= 0 then
			if levelInfo.answer[i] ~= playerChoosed then
				--填错了
				result = 0
				local spaceIndex = g_GameData.gameSpaceIndexs[i]
				local chooseImg = levelInfo.chooseImgs[playerChoosed]
				if chooseImg then
					g_UI_Items.spaceItems[spaceIndex].textImg:SetProperty("Image", chooseImg.."_Red" )
				end
				g_UI_Items.spaceItems[spaceIndex].errImg:Show()
				
			end
		end
	end
	return result
end


function TDGCX_CleanUp()
	g_GameData.gameType = 0
	g_GameData.gameLevelIndex = 0
	g_GameData.gameState = 0
	g_GameData.gameSpaceIndexs = {0,0,0}
	g_GameData.gameWordsItemsNum = 0
	g_GameData.playerIndex = 0
	g_GameData.playerChoose = {0,0,0}
	g_GameData.playerNameThisTurn = ""
	g_GameData.playerIsTeamLeader = 0
	g_GameData.showingOneItemSec = 1
	g_GameData.showingIndex = 0
	g_objCared = -1
end


function TDGCX_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false) 
end

function TDGCX_OnLoad()
    g_Frame_UnifiedPosition = TDGCX_Frame:GetProperty("UnifiedPosition")
	g_UI_Items.chooseItems = {}
	for i=1,g_ChooseItemNum do
        g_UI_Items.chooseItems[i] = {
            btn = _G["TDGCX_Btn"..i],
            text = _G["TDGCX_Btn"..i],
        }
	end
	g_UI_Items.spaceItems = {}
	for i=1,g_SpaceNumMax do
        g_UI_Items.spaceItems[i] = {
			line = _G[string.format( "TDGCX_Text%d_BK",i)], 
			textImg = _G[string.format( "TDGCX_Text%d_line",i)],
			errImg = _G[string.format( "TDGCX_Text%d_Wrony",i)],
        }
	end

	g_UI_Items.SubmitBtn = TDGCX_Btn_OK
	g_UI_Items.watch = TDGCX_Time
	g_UI_Items.remainText = TDGCX_Info2_Text
	g_UI_Items.teamLeaderText = TDGCX_OK_Text

	g_UI_Items.PlayingPage = TDGCX_Window1
	g_UI_Items.FadePage = TDGCX_Window2
	g_UI_Items.FadeItems = {}
	for i=1,g_SpaceNumMax do
        g_UI_Items.FadeItems[i] = {
            FadeImg = _G[string.format( "TDGCX_Window2_Text%d_line",i)],
        }
	end
end


function TDGCX_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		local nOpt = Get_XParam_INT(0)
		if nOpt == 1 then
			-- open ui in solo mode
			TDGCX_CleanUp()
			g_GameData.gameType = 1
			g_GameData.gameLevelIndex = Get_XParam_INT(1)
			g_GameData.playerIndex = 1
			g_GameData.gameState = 1
			g_objCared = DataPool : GetNPCIDByServerID(Get_XParam_INT(2));
			this:CareObject(g_objCared, 1, "TDGCX");	
			g_UI_Items.PlayingPage:Show()
			g_UI_Items.FadePage:Hide()
			this:Show()
			TDGCX_Begin()
		elseif nOpt == 2 then
			-- open ui in team mode
			TDGCX_CleanUp()
			g_GameData.gameType = 2
			g_GameData.gameLevelIndex = Get_XParam_INT(1)
			g_GameData.playerIndex = Get_XParam_INT(2)
			g_GameData.gameState = 1
			g_GameData.playerNameThisTurn = Get_XParam_STR(0)
			g_objCared = DataPool : GetNPCIDByServerID(Get_XParam_INT(3));
			g_GameData.playerIsTeamLeader = Get_XParam_INT(4)
			this:CareObject(g_objCared, 1, "TDGCX");
			g_UI_Items.PlayingPage:Show()
			g_UI_Items.FadePage:Hide()
			this:Show()
			TDGCX_Begin()
		elseif nOpt == 3 then
			--state transfer
			if(IsWindowShow("TDGCX")) then
				TDGCX_PlayingStateTransfer()
			end
			
		elseif nOpt == 4 then
			if(IsWindowShow("TDGCX")) then
				TDGCX_OnGameOver()
			end
		end

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        TDGCX_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		TDGCX_OnClose()

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>TDGCX_MAX_OBJ_DISTANCE or arg1=="destroy") then
			TDGCX_OnClose()
			--取消关心
			this:CareObject(-1, 1, "TDGCX");
		end	
	end

end

function TDGCX_OnChooseWordClick(index)
	if index < 1 or index > g_ChooseItemNum then
		return 
	end
	if not CheckGamePlaying() then
		return 
	end
	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	local result = 0
	if g_GameData.gameType == 1 then
		--solo mode
		if g_GameData.gameState == g_StateEnum.PLAYING1 and g_GameData.playerChoose[1] == 0 then
			if index == levelInfo.answer[1] then
				result = 1
			end
			--先存上自己的选择 避免有人用脚本一下点6个按钮全发给server
			g_GameData.playerChoose[1] = index
		else
			PushDebugMessage("#{TDCX_221220_126}")
			return 
		end
	elseif g_GameData.gameType == 2 then
		--Team Mode
		--检查是否该自己填
		local spaceStep = g_GameData.gameState
		if g_GameData.playerIndex ~= spaceStep or g_GameData.playerChoose[spaceStep] ~= 0 then
			PushDebugMessage("#{TDCX_221220_117}")
			return 
		end
		if index == levelInfo.answer[spaceStep] then
			result = 1
		end
		g_GameData.playerChoose[spaceStep] = index
	end
	--同步服务器
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnPlayerChoosed")
	Set_XSCRIPT_ScriptID(g_ExeScript)
	Set_XSCRIPT_Parameter(0,g_GameData.gameType);      -- Team mode
	Set_XSCRIPT_Parameter(1,index);  -- PlayerChoose
	Set_XSCRIPT_Parameter(2,result); -- reult
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end


function TDGCX_PlayingStateTransfer()

	--先同步上一个状态的结果
	if not CheckGamePlaying() then
		return 
	end

	local nextGameState = Get_XParam_INT(1)
	local playerChoose = Get_XParam_INT(2)
	local nextPlayerName = Get_XParam_STR(0)

	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	local spaceStepIndex = g_GameData.gameState
	local spaceIndexNow = g_GameData.gameSpaceIndexs[spaceStepIndex]
	if spaceIndexNow == nil then
		return 
	end
	--同步填繝
	if spaceIndexNow > 0 and spaceIndexNow <= g_GameData.gameWordsItemsNum  then
		g_UI_Items.chooseItems[playerChoose].btn:Disable() -- ???? ??
		g_UI_Items.spaceItems[spaceIndexNow].textImg:Show()
		g_UI_Items.spaceItems[spaceIndexNow].textImg:SetProperty("Image", levelInfo.chooseImgs[playerChoose] )
		g_UI_Items.spaceItems[spaceIndexNow].line:Hide()
		g_GameData.playerChoose[spaceStepIndex] = playerChoose
	end

	--转移为下一个状态
	g_GameData.gameState = nextGameState
	spaceStepIndex = g_GameData.gameState
	spaceIndexNow = g_GameData.gameSpaceIndexs[spaceStepIndex]
	if g_GameData.gameState < g_StateEnum.COMPLETED then
		--继续填词
		if spaceStepIndex == g_GameData.playerIndex then
			--轮到我填了
			g_UI_Items.spaceItems[spaceIndexNow].line:Show()
			if math.mod(spaceIndexNow,2) == 1 then
				g_UI_Items.spaceItems[spaceIndexNow].line:SetProperty("Image", g_LineImgs.currentUp )
			else
				g_UI_Items.spaceItems[spaceIndexNow].line:SetProperty("Image", g_LineImgs.currentDown )
			end
		end
		if g_GameData.gameType == 2 then
			g_GameData.playerNameThisTurn = nextPlayerName
			PushDebugMessage(ScriptGlobal_Format("#{TDCX_221220_115}",g_GameData.playerNameThisTurn))
			g_UI_Items.remainText:SetText(ScriptGlobal_Format("#{TDCX_221220_116}",g_GameData.playerNameThisTurn))
		end
	else
		--都填完了
		if g_GameData.gameType == 2 then
			PushDebugMessage("#{TDCX_221220_122}")
			g_UI_Items.remainText:Hide()
			g_UI_Items.teamLeaderText:SetText("#{TDCX_221220_121}")
		end
		--绘制完成按钮可点击

		if g_GameData.gameType == 1 or g_GameData.playerIsTeamLeader == 1 then
			g_UI_Items.SubmitBtn:SetToolTip("")
		end
	end
end

function TDGCX_Begin()
	-- KillTimer("TDGCX_TimeOut()")
	-- SetTimer("TDGCX","TDGCX_TimeOut()", g_GameTime*1000)
	g_UI_Items.watch:SetProperty("Timer",g_GameTime)
	--g_UI_Items.watch:SetProperty("TextColor","ff00ff00")-- 直接变色

	if not CheckGamePlaying() then
		return 
	end
	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	--根据配置初始化 
	g_GameData.gameWordsItemsNum = table.getn(levelInfo.spaceImgs)
	local tempIndex = 1
	for i = 1, g_GameData.gameWordsItemsNum do
		if levelInfo.spaceImgs[i] == "" then
			if tempIndex <= 3 then
				g_GameData.gameSpaceIndexs[tempIndex] = i --?tempIndex?player ??i??
				tempIndex = tempIndex + 1
			end
		end
	end

	--队长 或犨 单人模式下 显示绘制完成按钮
	if g_GameData.gameType == 1 then
		g_UI_Items.remainText:Hide()
		g_UI_Items.teamLeaderText:SetText("")
		g_UI_Items.SubmitBtn:Show()
		g_UI_Items.SubmitBtn:SetToolTip("#{TDCX_221220_111}")
	elseif g_GameData.gameType == 2 then
		PushDebugMessage(ScriptGlobal_Format("#{TDCX_221220_115}",g_GameData.playerNameThisTurn))
		g_UI_Items.remainText:Show()
		g_UI_Items.remainText:SetText(ScriptGlobal_Format("#{TDCX_221220_116}",g_GameData.playerNameThisTurn))
		g_UI_Items.teamLeaderText:SetText("")
		if g_GameData.playerIsTeamLeader == 1 then
			g_UI_Items.SubmitBtn:Show()
			g_UI_Items.SubmitBtn:SetToolTip("#{TDCX_221220_178}")
		else
			g_UI_Items.SubmitBtn:Hide()
		end
	end
	--填充可选词条
	for i=1,g_ChooseItemNum do
		g_UI_Items.chooseItems[i].text:SetText("#c6a3906"..levelInfo.chooseTexts[i])
		g_UI_Items.chooseItems[i].btn:Enable()
		g_UI_Items.chooseItems[i].btn:SetToolTip("#{TDCX_221220_186}")
	end
	--填充题目 
	for i=1,g_SpaceNumMax do
		if i <= g_GameData.gameWordsItemsNum then
			if levelInfo.spaceImgs[i] == "" then
				g_UI_Items.spaceItems[i].textImg:Hide()
				g_UI_Items.spaceItems[i].line:Show()
				if math.mod(i,2) == 1 then
					g_UI_Items.spaceItems[i].line:SetProperty("Image", g_LineImgs.spaceUp )
				else
					g_UI_Items.spaceItems[i].line:SetProperty("Image", g_LineImgs.spaceDown )
				end
				
			else
				g_UI_Items.spaceItems[i].textImg:Show()
				g_UI_Items.spaceItems[i].textImg:SetProperty("Image", levelInfo.spaceImgs[i] )	
				g_UI_Items.spaceItems[i].line:Hide()
			end
		else
			g_UI_Items.spaceItems[i].line:Hide()
			g_UI_Items.spaceItems[i].textImg:Hide()
		end
		g_UI_Items.spaceItems[i].errImg:Hide()
	end
	local stepIndex = g_GameData.gameState
	if g_GameData.playerIndex == stepIndex then
		--我来填第一个
		local spaceIndex = g_GameData.gameSpaceIndexs[stepIndex]
		if spaceIndex then
			g_UI_Items.spaceItems[spaceIndex].line:Show()
			if math.mod(spaceIndex,2) == 1 then
				g_UI_Items.spaceItems[spaceIndex].line:SetProperty("Image", g_LineImgs.currentUp )
			else
				g_UI_Items.spaceItems[spaceIndex].line:SetProperty("Image", g_LineImgs.currentDown )
			end
		else
			PushDebugMessage("Di畃 Di畁 sai l")
		end
	end


end

--游戏时间结束
function TDGCX_TimeOut()
	--KillTimer("TDGCX_TimeOut()")
	if g_GameData.gameState == g_StateEnum.COMPLETED then
		PushDebugMessage("#{TDCX_221220_170}") 
		return 
	end

	if not CheckGamePlaying() then
		return 
	end

	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	local stepIndex = g_GameData.gameState
	local spaceIndexNow = g_GameData.gameSpaceIndexs[stepIndex]

	if g_GameData.gameType == 1 then
		
		if g_GameData.playerChoose[stepIndex] == 0 then
			--若倒计时结束 玩家没有填入词条 只填一条 因为是单人模式
			local fillIndex = levelInfo.answer[stepIndex]
			if spaceIndexNow > 0 and spaceIndexNow <= g_GameData.gameWordsItemsNum  then
				g_UI_Items.spaceItems[spaceIndexNow].textImg:Show()
				g_UI_Items.spaceItems[spaceIndexNow].textImg:SetProperty("Image", levelInfo.chooseImgs[fillIndex].."_Red" )
				g_UI_Items.spaceItems[spaceIndexNow].line:Hide()	
			end
			PushDebugMessage("#{TDCX_221220_120}") 
			g_UI_Items.teamLeaderText:SetText("#{TDCX_221220_109}") 
		else
			PushDebugMessage("#{TDCX_221220_170}") 
		end
	elseif g_GameData.gameType == 2 then
		if g_GameData.playerChoose[stepIndex] == 0 then
			--若倒计时结束 有队员没有填入 繝多少条就填多少条 stepIndex开始往后肯定都没填
			for i = stepIndex, g_StateEnum.PLAYING3 do
				local fillIndex = levelInfo.answer[i]
				spaceIndexNow = g_GameData.gameSpaceIndexs[i]
				if spaceIndexNow > 0 and spaceIndexNow <= g_GameData.gameWordsItemsNum  then
					g_UI_Items.spaceItems[spaceIndexNow].textImg:Show()
					g_UI_Items.spaceItems[spaceIndexNow].textImg:SetProperty("Image", levelInfo.chooseImgs[fillIndex] )			
					g_UI_Items.spaceItems[spaceIndexNow].line:Hide()
				end
			end
			PushDebugMessage("#{TDCX_221220_120}") 
			g_UI_Items.remainText:Hide()
			g_UI_Items.teamLeaderText:SetText("#{TDCX_221220_121}")
		else
			PushDebugMessage("#{TDCX_221220_170}") 
		end
	end

	if g_GameData.gameType == 1 or g_GameData.playerIsTeamLeader == 1 then
		g_UI_Items.SubmitBtn:SetToolTip("")
	end

	g_GameData.gameState = g_StateEnum.TIMEOUT

	--倒计时结束了 如果犫时候我还没选 那就等于我选错了
	if g_GameData.playerChoose[g_GameData.playerIndex] == 0 then
		Set_XSCRIPT_Function_Name("OnPlayerTimeOut")
		Set_XSCRIPT_ScriptID(g_ExeScript)
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
	

end

--点击绘制按钮
function TDGCX_OnSubmitBtnClicked()
	if g_GameData.gameType < 1 or g_GameData.gameType > 2 then
		return 
	end
	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	if not levelInfo then
		return 
	end
	if  g_GameData.playerIndex <= 0 then
		return 
	end
	if g_GameData.gameType == 2 and g_GameData.playerIsTeamLeader ~= 1 then
		return
	end

	if g_GameData.gameState ~= g_StateEnum.TIMEOUT and g_GameData.gameState ~= g_StateEnum.COMPLETED  then
		--还没画完
		return 
	end
	--同步服务器
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnGameCom")
	Set_XSCRIPT_ScriptID(g_ExeScript)
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()

end

--游戏结束 牴示结果 5s后关睜界面
function TDGCX_OnGameOver()
	
	local ret = JudgeAnswer()
	if  g_GameData.gameState == g_StateEnum.TIMEOUT then
		if g_GameData.gameType == 1 then
			PushDebugMessage("#{TDCX_221220_181}")
		elseif g_GameData.gameType == 2 then
			PushDebugMessage("#{TDCX_221220_180}")
		end
	else
		if ret == 1 then
			PushDebugMessage("#{TDCX_221220_112}")
		else
			PushDebugMessage("#{TDCX_221220_113}")
		end
	end
	

	g_GameData.gameState = g_StateEnum.GAMEOVER
	TDGCX_FiveSecCloseUI()
end








function TDGCX_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            TDGCX_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function TDGCX_OnClose()
	KillTimer("TDGCX_OnFiveSecCloseUI()")
	KillTimer("TDGCX_FadeShowing()")
	KillTimer("TDGCX_OnFadeIn()")
	KillTimer("TDGCX_OnFadeIdle()")
	KillTimer("TDGCX_OnFadeDisappering()")
	--取消关心
	this:CareObject(-1, 1, "TDGCX");
    this:Hide()
end

function TDGCX_Btn_OnHelpClicked()
	
end

function TDGCX_FiveSecCloseUI()
	KillTimer("TDGCX_OnFiveSecCloseUI()")
	SetTimer("TDGCX","TDGCX_OnFiveSecCloseUI()", 2000)
	this:CareObject(-1, 1, "TDGCX");
end

function TDGCX_OnFiveSecCloseUI()
	KillTimer("TDGCX_OnFiveSecCloseUI()")
	g_UI_Items.PlayingPage:Hide()
	g_UI_Items.FadePage:SetProperty("Alpha",0)
	g_UI_Items.FadePage:Show()
	--装载狚确答案
	local levelInfo = g_GameLevel[g_GameData.gameType][g_GameData.gameLevelIndex]
	local spaceIndex = 1
	for i=1,g_SpaceNumMax do
		if i <= g_GameData.gameWordsItemsNum then

			if levelInfo.spaceImgs[i] == "" then
				local answerChooseImgIndex = levelInfo.answer[spaceIndex] or 1
				spaceIndex = spaceIndex + 1
				g_UI_Items.FadeItems[i].FadeImg:SetProperty("Image", levelInfo.chooseImgs[answerChooseImgIndex] )	
			else
				g_UI_Items.FadeItems[i].FadeImg:SetProperty("Image", levelInfo.spaceImgs[i] )	
			end

			g_UI_Items.FadeItems[i].FadeImg:SetProperty("Alpha",0)

			g_UI_Items.FadeItems[i].FadeImg:Show()
		else
			g_UI_Items.FadeItems[i].FadeImg:Hide()
		end
	end

	if g_GameData.gameWordsItemsNum ~= 0 then
		g_GameData.showingOneItemSec = g_FadeSetting.ShowingSec/g_GameData.gameWordsItemsNum
	end

	g_GameData.from_to_alpha_Showing = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",g_GameData.showingOneItemSec)
	g_GameData.from_to_alpha_Disppering = string.format("curve:Liner mode:Once duration:%s startx:1 starty:0 endx:0 endy:0",g_FadeSetting.DispperingSec)
	g_GameData.from_to_alpha_FadeIn = string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:1 endy:0",g_FadeSetting.FadeInSec)
	TDGCX_FadeIn()
end

function TDGCX_FadeIn()
	KillTimer("TDGCX_OnFadeIn()")
	g_UI_Items.FadePage:Tween_SetInfo("Alpha", g_GameData.from_to_alpha_FadeIn)
	g_UI_Items.FadePage:Tween_Play("Alpha", true, true)
	SetTimer("TDGCX","TDGCX_OnFadeIn()", g_FadeSetting.FadeInSec*1000)
end

function TDGCX_OnFadeIn()
	KillTimer("TDGCX_OnFadeIn()")
	TDGCX_FadeShowing()
end

function TDGCX_FadeShowing()
	KillTimer("TDGCX_FadeShowing()")

	local index = g_GameData.showingIndex
	if  g_UI_Items.FadeItems[index] then
		g_UI_Items.FadeItems[index].FadeImg:Tween_SetInfo("Alpha", g_GameData.from_to_alpha_Showing)
		g_UI_Items.FadeItems[index].FadeImg:Tween_Play("Alpha", true, true)
	end
	if index >= g_GameData.gameWordsItemsNum then
		TDGCX_FadeIdle()
		return 
	end
	g_GameData.showingIndex = index + 1

	
	SetTimer("TDGCX","TDGCX_FadeShowing()", math.floor(g_GameData.showingOneItemSec*1000))
end

function TDGCX_FadeIdle()
	KillTimer("TDGCX_OnFadeIdle()")
	SetTimer("TDGCX","TDGCX_OnFadeIdle()", g_FadeSetting.idleSec*1000)
end

function TDGCX_OnFadeIdle()
	KillTimer("TDGCX_OnFadeIdle()")
	TDGCX_FadeDisappering()
end

function TDGCX_FadeDisappering()
	KillTimer("TDGCX_OnFadeDisappering()")
	SetTimer("TDGCX","TDGCX_OnFadeDisappering()", g_FadeSetting.DispperingSec*1000)
	-- for i=1,g_GameData.gameWordsItemsNum do
	-- 	g_UI_Items.FadeItems[i].FadeImg:Tween_SetInfo("Alpha", g_GameData.from_to_alpha_Disppering)
	-- 	g_UI_Items.FadeItems[i].FadeImg:Tween_Play("Alpha", true, true)
	-- end
	g_UI_Items.FadePage:Tween_SetInfo("Alpha", g_GameData.from_to_alpha_Disppering)
	g_UI_Items.FadePage:Tween_Play("Alpha", true, true)
end

function TDGCX_OnFadeDisappering()
	KillTimer("TDGCX_OnFadeDisappering()")
	TDGCX_OnClose()
end



