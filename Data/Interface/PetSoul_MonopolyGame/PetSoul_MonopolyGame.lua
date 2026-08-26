--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_PetSoul_MonopolyGame_Frame_UnifiedPosition;

local g_PetSoul_MonopolyGame_ACBCtr={}
local g_PetSoul_MonopolyGame_AniCtr={}
local g_PetSoul_MonopolyGame_BtnCtr={}
local g_PSM_GetIdx = -1

local g_PetSoule_NormalImg = {}
local g_PetSoule_HorImg = {}

local g_PSM_ItemList = {
[1] ={id=38002515, radnum=5},--ÇàÁú»êÓñ
[2] ={id=38002516, radnum=10},--ÐþÎä»êÓñ
[3] ={id=38002517, radnum=15},--°×»¢»êÓñ
[4] ={id=38002518, radnum=20},--ÖìÈ¸»êÓñ
[5] ={id=38002519, radnum=28},--¾ÅÎ²»êÓñ
[6] ={id=38002520, radnum=41},--½õÁÛ»êÓñ
[7] ={id=38002521, radnum=54},--»Ãµû»êÓñ
[8] ={id=38002522, radnum=67},--Ëªº×»êÓñ
[9] ={id=38002523, radnum=80},--½ðÎÚ»êÓñ
[10]={id=38002524, radnum=100},--Â¹Êñ»êÓñ
}

--×ªÅÌ¿ØÖÆ
--local g_Step = -1		--Æô¶¯ÆðÊ¼²½Êý
--local m_Rates = {50,50,100,200,500}
local g_MaxStep = 10

local g_InRoll = 0
-- OnLoad
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGame_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_MonopolyGame_OnLoad()
	g_PetSoul_MonopolyGame_Frame_UnifiedPosition=PetSoul_MonopolyGame_Frame:GetProperty("UnifiedPosition");
	g_PetSoul_MonopolyGame_ACBCtr={
		PetSoul_MonopolyGame_List1,PetSoul_MonopolyGame_List2,PetSoul_MonopolyGame_List3,PetSoul_MonopolyGame_List4,PetSoul_MonopolyGame_List5,
		PetSoul_MonopolyGame_List6,PetSoul_MonopolyGame_List7,PetSoul_MonopolyGame_List8,PetSoul_MonopolyGame_List9,PetSoul_MonopolyGame_List10
	}
	g_PetSoul_MonopolyGame_AniCtr={
		PetSoul_MonopolyGame_List1_Image,PetSoul_MonopolyGame_List2_Image,PetSoul_MonopolyGame_List3_Image,PetSoul_MonopolyGame_List4_Image,
		PetSoul_MonopolyGame_List5_Image,PetSoul_MonopolyGame_List6_Image,PetSoul_MonopolyGame_List7_Image,PetSoul_MonopolyGame_List8_Image,
		PetSoul_MonopolyGame_List9_Image,PetSoul_MonopolyGame_List10_Image
	}
	g_PetSoul_MonopolyGame_BtnCtr={
		PetSoul_MonopolyGame_List1Btn,PetSoul_MonopolyGame_List2Btn,PetSoul_MonopolyGame_List3Btn,PetSoul_MonopolyGame_List4Btn,
		PetSoul_MonopolyGame_List5Btn,PetSoul_MonopolyGame_List6Btn,PetSoul_MonopolyGame_List7Btn,PetSoul_MonopolyGame_List8Btn,
		PetSoul_MonopolyGame_List9Btn,PetSoul_MonopolyGame_List10Btn
	}
	g_PetSoule_NormalImg = {
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHnormal",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHnormal",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHnormal",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHnormal",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHnormal",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNnormal",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNnormal",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNnormal",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNnormal",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNnormal",
	}
	g_PetSoule_HorImg = {
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHhover",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHhover",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHhover",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHhover",
		"set:PetSoul_Fenghunlu image:PetSoul_MonopolyGameHhover",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNhover",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNhover",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNhover",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNhover",
		"set:PetSoul_MonopolyGame image:PetSoul_MonopolyGameNhover",
	}
end


--***********************************************************************************************************************************************
--
-- ÊÂ¼þÏìÓ¦º¯Êý
--
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGame_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89307802 ) then
		local clientNpcId = Get_XParam_INT(0)
		if clientNpcId==-1 then
			this:Hide()
			return
		end
		if clientNpcId==-2 then
			--²¥·ÅÌØÐ§
			PetSoul_MonopolyGame_UpdateText(Get_XParam_INT(1),Get_XParam_INT(2))
			g_PSM_GetIdx = Get_XParam_INT(3)
			g_InRoll = 1
			PetSoul_MonopolyGame_LotteryStart()
		else
			g_clientNpcId = clientNpcId
			local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
			if objId == -1 then
				return
			end
			PetSoul_MonopolyGame_Update(Get_XParam_INT(1),Get_XParam_INT(2))
			this : CareObject( objId, 1, "PetSoul_MonopolyGame" )
			this : Show()
		end

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_MonopolyGame_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_MonopolyGame_Frame_On_ResetPos()
	end
end

function PetSoul_MonopolyGame_AHTick()
	if g_PSM_GetIdx > 0 then
		local itemname = PlayerPackage:GetItemName( g_PSM_ItemList[g_PSM_GetIdx].id )
		PushDebugMessage(ScriptGlobal_Format( "#{ZSPVP_211231_50}", 1, itemname))
		g_PetSoul_MonopolyGame_AniCtr[g_PSM_GetIdx]:Hide()
		g_PetSoul_MonopolyGame_AniCtr[g_PSM_GetIdx]:Play(false)
	end
	g_PSM_GetIdx = -1
	g_InRoll = 0
	KillTimer("PetSoul_MonopolyGame_AHTick()")
end

function PetSoul_MonopolyGame_ShowAni()
	if g_PSM_GetIdx > 0 then
		g_PetSoul_MonopolyGame_AniCtr[g_PSM_GetIdx]:Show()
		g_PetSoul_MonopolyGame_AniCtr[g_PSM_GetIdx]:Play(true)
		KillTimer("PetSoul_MonopolyGame_AHTick()")
		SetTimer("PetSoul_MonopolyGame","PetSoul_MonopolyGame_AHTick()", 1100)
	end
end
function PetSoul_MonopolyGame_LotteryStart()
	KillTimer("PetSoul_MonopolyGame_LotteryTick()")
	g_Step = 0
	for i=1,10 do
		g_PetSoul_MonopolyGame_AniCtr[i]:Hide()
		g_PetSoul_MonopolyGame_BtnCtr[i]:SetProperty("NormalImage", g_PetSoule_NormalImg[i])
	end
	SetTimer("PetSoul_MonopolyGame","PetSoul_MonopolyGame_LotteryTick()", 200)
end

function PetSoul_MonopolyGame_LotteryTick()
	KillTimer("PetSoul_MonopolyGame_LotteryTick()")
	g_Step = g_Step + 1
	if g_Step > 0 and g_Step <= 10 then
		if g_Step-1 > 0 then
			g_PetSoul_MonopolyGame_BtnCtr[g_Step-1]:SetProperty("NormalImage", g_PetSoule_NormalImg[g_Step-1])
		end
		g_PetSoul_MonopolyGame_BtnCtr[g_Step]:SetProperty("NormalImage", g_PetSoule_HorImg[g_Step])
		SetTimer("PetSoul_MonopolyGame","PetSoul_MonopolyGame_LotteryTick()", 200)
	else
		local nIdx = g_Step - 10
		local nLastIdx = nIdx - 1
		if nLastIdx == 0 then
			nLastIdx = 10
		end
		g_PetSoul_MonopolyGame_BtnCtr[nLastIdx]:SetProperty("NormalImage", g_PetSoule_NormalImg[nLastIdx])
		g_PetSoul_MonopolyGame_BtnCtr[nIdx]:SetProperty("NormalImage", g_PetSoule_HorImg[nIdx])
		if nIdx == g_PSM_GetIdx then
			PetSoul_MonopolyGame_ShowAni()
		else
			SetTimer("PetSoul_MonopolyGame","PetSoul_MonopolyGame_LotteryTick()", 300)
		end
	end
end

function PetSoul_MonopolyGame_UpdateText(nShouHunDian, nLeftCount)
	PetSoul_MonopolyGame_Text:SetText(ScriptGlobal_Format( "#{ZSPVP_211231_44}", nShouHunDian))
	PetSoul_MonopolyGame_Text2:SetText(ScriptGlobal_Format( "#{ZSPVP_211231_92}", nLeftCount))
end
function PetSoul_MonopolyGame_Update(nShouHunDian, nLeftCount)

	for i=1,10 do
--		local showAction = DataPool:CreateActionItemForShow(g_PSM_ItemList[i].id, 1)
		local showAction = DataPool:CreateBindActionItemForShow(g_PSM_ItemList[i].id, 1)
		if showAction:GetID() ~= 0 then
			g_PetSoul_MonopolyGame_ACBCtr[i]:SetActionItem(showAction:GetID())
		end
	end

	for i=1,10 do
		g_PetSoul_MonopolyGame_AniCtr[i]:Hide()
		g_PetSoul_MonopolyGame_AniCtr[i]:Play(false)
		g_PetSoul_MonopolyGame_BtnCtr[i]:SetProperty("NormalImage", g_PetSoule_NormalImg[i])
	end
	PetSoul_MonopolyGame_Text:SetText(ScriptGlobal_Format( "#{ZSPVP_211231_44}", nShouHunDian))
	PetSoul_MonopolyGame_Text2:SetText(ScriptGlobal_Format( "#{ZSPVP_211231_92}", nLeftCount))
end


function PetSoul_MonopolyGame_OnClose()
	this:Hide()
end


function PetSoul_MonopolyGame_Frame_On_ResetPos()
  PetSoul_MonopolyGame_Frame:SetProperty("UnifiedPosition", g_PetSoul_MonopolyGame_Frame_UnifiedPosition);
end

function PetSoul_MonopolyGame_OnHiden()
	KillTimer("PetSoul_MonopolyGame_LotteryTick()")
	KillTimer("PetSoul_MonopolyGame_AHTick()")
--	g_Step = -1
--	if g_PSM_GetIdx > 0 then
--		local itemname = PlayerPackage:GetItemName( g_PSM_ItemList[g_PSM_GetIdx].id )
--		PushDebugMessage(ScriptGlobal_Format( "#{ZSPVP_211231_50}", g_PSM_ItemList[g_PSM_GetIdx].num, itemname))
--	end
	g_PSM_GetIdx = -1
	g_InRoll = 0
end

function PetSoul_MonopolyGame_RollDice()
	if g_InRoll==1 then
		PushDebugMessage("#{ZSPVP_211231_77}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnPetSoulPrizeDraw")
		Set_XSCRIPT_ScriptID(893078)
		Set_XSCRIPT_Parameter(0,g_clientNpcId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
function PetSoul_MonopolyGame_HelpClick()
	PushEvent("QUEST_HELPINFO","#{ZSPVP_211231_78}")
end