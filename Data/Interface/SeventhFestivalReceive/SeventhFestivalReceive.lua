--ÀÛ¼ÆÊ »¨½±Àø½çÃæ

local g_SeventhFestivalReceive_UnifiedPosition;

local g_ObjCareID		 = -1
local g_ServerCareID	 = -1

local g_SeventhFestivalReceive_Value = 0
local g_SeventhFestivalReceive_ValueGet = {0,0,0,0,0,0}
local g_SeventhFestivalReceive_77Day = 0
local g_SeventhFestivalReceive_DiffVDay = -1

local g_SeventhFestivalReceive_ActionList = {}
local g_SeventhFestivalReceive_TextList = {}
local g_SeventhFestivalReceive_AnimateList = {}

local g_SeventhFestivalReceive_77Value = 99

local g_SeventhFestivalReceive_InfoList = {
[1] = { itemid = 10124698, value = 11, itemnum = 1 },
[2] = { itemid = 10141875, value = 33, itemnum = 1 },
[3] = { itemid = 30503140, value = 99, itemnum = 5 },
[4] = { itemid = 39920123, value = 188, itemnum = 1 },
[5] = { itemid = 30008237, value = 520, itemnum = 1 },
[6] = { itemid = 20307252, value = 999, itemnum = 1 },
}

local g_SeventhFestivalReceive_77 = 38002632

--=========================================================
-- ×¢²á´°¿Ú¹ØÐÄµÄËùÓÐÊÂ¼þ
--=========================================================
function SeventhFestivalReceive_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--=========================================================
-- ÔØÈë³õÊ¼»¯
--=========================================================
function SeventhFestivalReceive_OnLoad()

	g_SeventhFestivalReceive_ActionList[1] = SeventhFestivalReceive_Award1 
	g_SeventhFestivalReceive_ActionList[2] = SeventhFestivalReceive_Award2 
	g_SeventhFestivalReceive_ActionList[3] = SeventhFestivalReceive_Award3 
	g_SeventhFestivalReceive_ActionList[4] = SeventhFestivalReceive_Award4 
	g_SeventhFestivalReceive_ActionList[5] = SeventhFestivalReceive_Award5 
	g_SeventhFestivalReceive_ActionList[6] = SeventhFestivalReceive_Award6 
	
	g_SeventhFestivalReceive_TextList[1] = SeventhFestivalReceive_Award1Text
	g_SeventhFestivalReceive_TextList[2] = SeventhFestivalReceive_Award2Text
	g_SeventhFestivalReceive_TextList[3] = SeventhFestivalReceive_Award3Text
	g_SeventhFestivalReceive_TextList[4] = SeventhFestivalReceive_Award4Text
	g_SeventhFestivalReceive_TextList[5] = SeventhFestivalReceive_Award5Text
	g_SeventhFestivalReceive_TextList[6] = SeventhFestivalReceive_Award6Text
	
	g_SeventhFestivalReceive_AnimateList = {
	[1] = {SeventhFestivalReceive_Award1Animate, SeventhFestivalReceive_Award1OK},
	[2] = {SeventhFestivalReceive_Award2Animate, SeventhFestivalReceive_Award2OK},
	[3] = {SeventhFestivalReceive_Award3Animate, SeventhFestivalReceive_Award3OK},
	[4] = {SeventhFestivalReceive_Award4Animate, SeventhFestivalReceive_Award4OK},
	[5] = {SeventhFestivalReceive_Award5Animate, SeventhFestivalReceive_Award5OK},
	[6] = {SeventhFestivalReceive_Award6Animate, SeventhFestivalReceive_Award6OK},
	}
	
	g_SeventhFestivalReceive_UnifiedPosition = SeventhFestivalReceive_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- ÊÂ¼þ´¦Àí
--=========================================================
function SeventhFestivalReceive_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89116401) then --????
		
		if Get_XParam_INT( 0 ) <= 0 then
			SeventhFestivalReceive_Close()
			return
		end
		
		--¹ØÐÄµ±Ç°¶Ô»°µÄNPC
		g_ServerCareID = Get_XParam_INT(1)
		g_ObjCareID = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if (g_ObjCareID == -1) then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
			return
		end
		SeventhFestivalReceive_BeginCareObject()
		
		g_SeventhFestivalReceive_Value = Get_XParam_INT( 2 )
		g_SeventhFestivalReceive_77Day = Get_XParam_INT( 3 )
		g_SeventhFestivalReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_SeventhFestivalReceive_ValueGet) do
			g_SeventhFestivalReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			SeventhFestivalReceive_TakeOnBtn:SetText(strTime)
		end
		
		SeventhFestivalReceive_OnShow()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89116402 and this:IsVisible()) then --????
				
		g_SeventhFestivalReceive_Value = Get_XParam_INT( 2 )
		g_SeventhFestivalReceive_77Day = Get_XParam_INT( 3 )
		g_SeventhFestivalReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_SeventhFestivalReceive_ValueGet) do
			g_SeventhFestivalReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			SeventhFestivalReceive_TakeOnBtn:SetText(strTime)
		end
		
		SeventhFestivalReceive_OnShow()
		
	elseif event == "HIDE_ON_SCENE_TRANSED"  then	
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalReceive_Frame_On_ResetPos()
		
	end
	
end

--=========================================================
-- ÏÔÊ¾ÐÅÏ¢
--=========================================================
function SeventhFestivalReceive_OnShow()

	for i = 1, table.getn(g_SeventhFestivalReceive_InfoList) do				
		local theAction = DataPool:CreateBindActionItemForShow(g_SeventhFestivalReceive_InfoList[i].itemid, g_SeventhFestivalReceive_InfoList[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_SeventhFestivalReceive_ActionList[i]:SetActionItem(theAction:GetID())
		end
		local strRose = ScriptGlobal_Format("#{QXHB_20210701_194}", tostring(g_SeventhFestivalReceive_InfoList[i].value))
		g_SeventhFestivalReceive_TextList[i]:SetText(strRose)
		
		if g_SeventhFestivalReceive_AnimateList[i] ~= nil and g_SeventhFestivalReceive_ValueGet[i] ~= nil then
			g_SeventhFestivalReceive_AnimateList[i][1]:Hide()
			g_SeventhFestivalReceive_AnimateList[i][2]:Hide()
			if g_SeventhFestivalReceive_Value >= g_SeventhFestivalReceive_InfoList[i].value then
				-- ÊÇ·ñÒÑÁì½±
				if g_SeventhFestivalReceive_ValueGet[i] == 1 then
					-- ÒÑ´ï³É ÒÑÁì½±
					g_SeventhFestivalReceive_AnimateList[i][2]:Show()
				else
					-- ÒÑ´ï³É Î´Áì½±
					g_SeventhFestivalReceive_AnimateList[i][1]:Show()
				end
			else
				-- Î´´ï³É
			end
		end
	end
	
	local theAction = DataPool:CreateBindActionItemForShow(g_SeventhFestivalReceive_77, 1)
	if theAction:GetID() ~= 0 then
		SeventhFestivalReceive_TakeOnIcon:SetActionItem(theAction:GetID())
	end
	
	SeventhFestivalReceive_TakeOnIconAnimate:Hide()
	SeventhFestivalReceive_TakeOnIconOK:Hide()
	if g_SeventhFestivalReceive_Value >= g_SeventhFestivalReceive_77Value and g_SeventhFestivalReceive_DiffVDay == 0 then
		if g_SeventhFestivalReceive_77Day == 1 then
			SeventhFestivalReceive_TakeOnIconOK:Show()
		else
			SeventhFestivalReceive_TakeOnIconAnimate:Show()
		end
	end
		
	local str = ScriptGlobal_Format("#{QXHB_20210701_193}", tostring(g_SeventhFestivalReceive_Value))
	SeventhFestivalReceive_TakeOn_Text2:SetText(str)

	this:Show()

end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function SeventhFestivalReceive_Clear()

	for i = 1, table.getn(g_SeventhFestivalReceive_ActionList) do
		g_SeventhFestivalReceive_ActionList[i]:SetActionItem(-1)
	end
	
	SeventhFestivalReceive_StopCareObject()
	
end

--=========================================================
-- ÁìÈ¡½±Àø
--=========================================================
function SeventhFestivalReceive_Award_Item_Clicked( nIdx )
	if g_SeventhFestivalReceive_ActionList[nIdx] == nil then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReceiveAccGift")
		Set_XSCRIPT_ScriptID(891164)
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_Parameter( 1, nIdx )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
end

--=========================================================
-- ²é¿´°ïÖú
--=========================================================
function SeventhFestivalReceive_77_Item_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetAcc77Gift")
		Set_XSCRIPT_ScriptID(891164)
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
function SeventhFestivalReceive_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "SeventhFestivalReceive");
end


--*************************************************
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--*************************************************
function SeventhFestivalReceive_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "SeventhFestivalReceive");
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function SeventhFestivalReceive_OnHiden()

	SeventhFestivalReceive_Clear()
	
	this:Hide()
	
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function SeventhFestivalReceive_Close()

	SeventhFestivalReceive_Clear()
	
	this:Hide()
	
end

function SeventhFestivalReceive_Frame_On_ResetPos()

  SeventhFestivalReceive_Frame:SetProperty("UnifiedPosition", g_SeventhFestivalReceive_UnifiedPosition);
  
end


