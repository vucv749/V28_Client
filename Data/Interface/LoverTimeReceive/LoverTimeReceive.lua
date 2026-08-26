--ÀÛ¼ÆÊ »¨½±Àø½çÃæ

local g_LoverTimeReceive_UnifiedPosition;

local g_ObjCareID		 = -1
local g_ServerCareID	 = -1

local g_LoverTimeReceive_Value = 0
local g_LoverTimeReceive_ValueGet = {0,0,0,0,0,0}
local g_LoverTimeReceive_214Day = 0
local g_LoverTimeReceive_DiffVDay = -1

local g_LoverTimeReceive_ActionList = {}
local g_LoverTimeReceive_TextList = {}
local g_LoverTimeReceive_AnimateList = {}

local g_LoverTimeReceive_214Value = 99
local g_LoverTimeReceive_214Item = 38002473

local g_LoverTimeReceive_InfoList = {
[1] = { itemid = 10124698, value = 11, itemnum = 1 },
[2] = { itemid = 10141875, value = 33, itemnum = 1 },
[3] = { itemid = 30503140, value = 99, itemnum = 5 },
[4] = { itemid = 39920126, value = 188, itemnum = 1 },
[5] = { itemid = 30008224, value = 520, itemnum = 1 },
[6] = { itemid = 20307238, value = 999, itemnum = 1 },
}

--=========================================================
-- ×¢²á´°¿Ú¹ØÐÄµÄËùÓÐÊÂ¼þ
--=========================================================
function LoverTimeReceive_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function LoverTimeReceive_OnLoad()

	g_LoverTimeReceive_ActionList[1] = LoverTimeReceive_Award1 
	g_LoverTimeReceive_ActionList[2] = LoverTimeReceive_Award2 
	g_LoverTimeReceive_ActionList[3] = LoverTimeReceive_Award3 
	g_LoverTimeReceive_ActionList[4] = LoverTimeReceive_Award4 
	g_LoverTimeReceive_ActionList[5] = LoverTimeReceive_Award5 
	g_LoverTimeReceive_ActionList[6] = LoverTimeReceive_Award6 
	
	g_LoverTimeReceive_TextList[1] = LoverTimeReceive_Award1Text
	g_LoverTimeReceive_TextList[2] = LoverTimeReceive_Award2Text
	g_LoverTimeReceive_TextList[3] = LoverTimeReceive_Award3Text
	g_LoverTimeReceive_TextList[4] = LoverTimeReceive_Award4Text
	g_LoverTimeReceive_TextList[5] = LoverTimeReceive_Award5Text
	g_LoverTimeReceive_TextList[6] = LoverTimeReceive_Award6Text
	
	g_LoverTimeReceive_AnimateList = {
	[1] = {LoverTimeReceive_Award1Animate, LoverTimeReceive_Award1OK},
	[2] = {LoverTimeReceive_Award2Animate, LoverTimeReceive_Award2OK},
	[3] = {LoverTimeReceive_Award3Animate, LoverTimeReceive_Award3OK},
	[4] = {LoverTimeReceive_Award4Animate, LoverTimeReceive_Award4OK},
	[5] = {LoverTimeReceive_Award5Animate, LoverTimeReceive_Award5OK},
	[6] = {LoverTimeReceive_Award6Animate, LoverTimeReceive_Award6OK},
	}
	
	g_LoverTimeReceive_UnifiedPosition = LoverTimeReceive_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function LoverTimeReceive_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89297101) then --????
		
		if Get_XParam_INT( 0 ) <= 0 then
			LoverTimeReceive_Close()
			return
		end
		
		--¹ØÐÄµ±Ç°¶Ô»°µÄNPC
		g_ServerCareID = Get_XParam_INT(1)
		g_ObjCareID = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if (g_ObjCareID == -1) then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
			return
		end
		LoverTimeReceive_BeginCareObject()
		
		g_LoverTimeReceive_Value = Get_XParam_INT( 2 )
		g_LoverTimeReceive_214Day = Get_XParam_INT( 3 )
		g_LoverTimeReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_LoverTimeReceive_ValueGet) do
			g_LoverTimeReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = "#{QRZM_211119_35}"  --Get_XParam_STR(0)
		if strTime ~= nil then
			LoverTimeReceive_TakeOnBtn:SetText(strTime)
		end
		
		LoverTimeReceive_OnShow()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89297102 and this:IsVisible()) then --????
				
		g_LoverTimeReceive_Value = Get_XParam_INT( 2 )
		g_LoverTimeReceive_214Day = Get_XParam_INT( 3 )
		g_LoverTimeReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_LoverTimeReceive_ValueGet) do
			g_LoverTimeReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = "#{QRZM_211119_35}"  --Get_XParam_STR(0)
		if strTime ~= nil then
			LoverTimeReceive_TakeOnBtn:SetText(strTime)
		end
		
		LoverTimeReceive_OnShow()
		
	elseif event == "HIDE_ON_SCENE_TRANSED"  then	
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		LoverTimeReceive_Frame_On_ResetPos()
		
	end
	
end

--=========================================================
-- ÏÔÊ¾ÐÅÏ¢
--=========================================================
function LoverTimeReceive_OnShow()

	for i = 1, table.getn(g_LoverTimeReceive_InfoList) do				
		local theAction = DataPool:CreateBindActionItemForShow(g_LoverTimeReceive_InfoList[i].itemid, g_LoverTimeReceive_InfoList[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_LoverTimeReceive_ActionList[i]:SetActionItem(theAction:GetID())
		end
		local strRose = ScriptGlobal_Format("#{QRZM_211119_194}", tostring(g_LoverTimeReceive_InfoList[i].value))
		g_LoverTimeReceive_TextList[i]:SetText(strRose)
		
		if g_LoverTimeReceive_AnimateList[i] ~= nil and g_LoverTimeReceive_ValueGet[i] ~= nil then
			g_LoverTimeReceive_AnimateList[i][1]:Hide()
			g_LoverTimeReceive_AnimateList[i][2]:Hide()
			if g_LoverTimeReceive_Value >= g_LoverTimeReceive_InfoList[i].value then
				-- ÊÇ·ñÒÑÁì½±
				if g_LoverTimeReceive_ValueGet[i] == 1 then
					-- ÒÑ´ï³É ÒÑÁì½±
					g_LoverTimeReceive_AnimateList[i][2]:Show()
				else
					-- ÒÑ´ï³É Î´Áì½±
					g_LoverTimeReceive_AnimateList[i][1]:Show()
				end
			else
				-- Î´´ï³É
			end
		end
	end
	
	local theAction = DataPool:CreateBindActionItemForShow(g_LoverTimeReceive_214Item, 1)
	if theAction:GetID() ~= 0 then
		LoverTimeReceive_TakeOnIcon:SetActionItem(theAction:GetID())
	end
	
	LoverTimeReceive_TakeOnIconAnimate:Hide()
	LoverTimeReceive_TakeOnIconOK:Hide()
	if g_LoverTimeReceive_Value >= g_LoverTimeReceive_214Value then
		if g_LoverTimeReceive_214Day == 1 then
			LoverTimeReceive_TakeOnIconOK:Show()
		else
			if g_LoverTimeReceive_DiffVDay <= 0 then
				LoverTimeReceive_TakeOnIconAnimate:Show()
			end
		end
	end
		
	local str = ScriptGlobal_Format("#{QRZM_211119_193}", tostring(g_LoverTimeReceive_Value))
	LoverTimeReceive_TakeOn_Text2:SetText(str)
	
	LoverTimeReceive_TakeOn_Text:Hide()

	this:Show()

end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function LoverTimeReceive_Clear()

	for i = 1, table.getn(g_LoverTimeReceive_ActionList) do
		g_LoverTimeReceive_ActionList[i]:SetActionItem(-1)
	end
	
	LoverTimeReceive_StopCareObject()
	
end

--=========================================================
-- ÁìÈ¡½±Àø
--=========================================================
function LoverTimeReceive_Award_Item_Clicked( nIdx )
	if g_LoverTimeReceive_ActionList[nIdx] == nil then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReceiveAccGift")
		Set_XSCRIPT_ScriptID( 892971 )
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_Parameter( 1, nIdx )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
end

--=========================================================
-- ²é¿´°ïÖú
--=========================================================
function LoverTimeReceive_214_Item_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetAcc214Gift")
		Set_XSCRIPT_ScriptID( 892971 )
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
end

--*************************************************
--¿ªÊ¼¹ØÐÄNPC£¬¾ÍÊÇÈ·ÈÏÍæ¼Òµ±Ç°²Ù×÷µÄNPC£¬Èç¹ûÀëNPC
--Ì«Ô¶¾Í»á¹Ø± ´°¿ÚÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæ
--ÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­
--ÓÐµÄ¡°¹ØÐÄ¡±
--*************************************************
function LoverTimeReceive_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "LoverTimeReceive");
end


--*************************************************
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--*************************************************
function LoverTimeReceive_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "LoverTimeReceive");
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function LoverTimeReceive_OnHiden()

	LoverTimeReceive_Clear()
	
	this:Hide()
	
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function LoverTimeReceive_Close()

	LoverTimeReceive_Clear()
	
	this:Hide()
	
end

function LoverTimeReceive_Frame_On_ResetPos()

  LoverTimeReceive_Frame:SetProperty("UnifiedPosition", g_LoverTimeReceive_UnifiedPosition);
  
end


