local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_Name_TargetId = -1

local g_Biwuzhaoqin_Name_listctrl = {}
local g_Biwuzhaoqin_Name_checkctrl = {}

local g_Biwuzhaoqin_Name_ButtonLastTime = 0
local g_Biwuzhaoqin_Name_ButtonCDTime = 3000 --3s

local g_Biwuzhaoqin_Name_LoveGUID = -1
local g_Biwuzhaoqin_Name_Select = 0

function Biwuzhaoqin_Name_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_BWZQ_VOTERLIST16",false)
	this:RegisterEvent("SCENE_TRANSED")

end

function Biwuzhaoqin_Name_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_Name_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_Name_Frame:GetProperty("UnifiedYPosition");
	g_Biwuzhaoqin_Name_listctrl = {
		Biwuzhaoqin_Name_List1_1,Biwuzhaoqin_Name_List2_1,Biwuzhaoqin_Name_List3_1,Biwuzhaoqin_Name_List4_1,
		Biwuzhaoqin_Name_List5_1,Biwuzhaoqin_Name_List6_1,Biwuzhaoqin_Name_List7_1,Biwuzhaoqin_Name_List8_1,
		Biwuzhaoqin_Name_List9_1,Biwuzhaoqin_Name_List10_1,Biwuzhaoqin_Name_List11_1,Biwuzhaoqin_Name_List12_1,
		Biwuzhaoqin_Name_List13_1,Biwuzhaoqin_Name_List14_1,Biwuzhaoqin_Name_List15_1,Biwuzhaoqin_Name_List16_1,
	}
	g_Biwuzhaoqin_Name_checkctrl = {
		Biwuzhaoqin_Name_List1,Biwuzhaoqin_Name_List2,Biwuzhaoqin_Name_List3,Biwuzhaoqin_Name_List4,
		Biwuzhaoqin_Name_List5,Biwuzhaoqin_Name_List6,Biwuzhaoqin_Name_List7,Biwuzhaoqin_Name_List8,
		Biwuzhaoqin_Name_List9,Biwuzhaoqin_Name_List10,Biwuzhaoqin_Name_List11,Biwuzhaoqin_Name_List12,
		Biwuzhaoqin_Name_List13,Biwuzhaoqin_Name_List14,Biwuzhaoqin_Name_List15,Biwuzhaoqin_Name_List16,
	}
end

function Biwuzhaoqin_Name_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Biwuzhaoqin_Name_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		Biwuzhaoqin_Name_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 79210201) then
		local bShow = Get_XParam_INT(0)
		if bShow == 1 then
			g_Biwuzhaoqin_Name_TargetId = Get_XParam_INT(1);

			local ObjCaredID = DataPool : GetNPCIDByServerID(g_Biwuzhaoqin_Name_TargetId);
			if ObjCaredID == -1 then
				return;
			end
			this:CareObject(ObjCaredID, 1, "Biwuzhaoqin_Name");
			g_Biwuzhaoqin_Name_LoveGUID = Get_XParam_INT(2)
			g_Biwuzhaoqin_Name_Select = 0
			this:Show()
		elseif bShow == 2 then
			g_Biwuzhaoqin_Name_LoveGUID = Get_XParam_INT(1)
			Biwuzhaoqin_Name_Update()
		elseif bShow == 0 then
			Biwuzhaoqin_Name_OnClose()
		end
	elseif (event == "UPDATE_BWZQ_VOTERLIST16") then
		Biwuzhaoqin_Name_Update()
	elseif( event == "SCENE_TRANSED" ) then		
		Biwuzhaoqin_Name_OnClose()
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Name_ResetPos()
	Biwuzhaoqin_Name_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_Name_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_Name_OnClose()
	this:Hide()
end

function Biwuzhaoqin_Name_Update()

	local tblinfo = BWZQ:LuaFnGetVoterList()

	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end
--PushDebugMessage("g_Biwuzhaoqin_Name_LoveGUID="..g_Biwuzhaoqin_Name_LoveGUID)
	local tbCount = table.getn(tblinfo)
	local bFindIdx = 0
	for i = 1, tbCount do
		local id 	    = tblinfo[i].id
		local guid 	    = tblinfo[i].guid
		local name      = tblinfo[i].name
		g_Biwuzhaoqin_Name_listctrl[i]:Show()
		g_Biwuzhaoqin_Name_checkctrl[i]:Show()
		if guid == g_Biwuzhaoqin_Name_LoveGUID then
			bFindIdx = i
			g_Biwuzhaoqin_Name_listctrl[i]:SetText("#G"..name)
			g_Biwuzhaoqin_Name_checkctrl[i]:SetCheck(1)
		else
			g_Biwuzhaoqin_Name_listctrl[i]:SetText("#cfff263"..name)
			g_Biwuzhaoqin_Name_checkctrl[i]:SetCheck(0)
		end
  end
  for i=1,tbCount do
  	if bFindIdx > 0 then
  		g_Biwuzhaoqin_Name_checkctrl[i]:Disable()
  	else
  		g_Biwuzhaoqin_Name_checkctrl[i]:Enable()
  	end
  end

	for i=tbCount+1, 16 do
		g_Biwuzhaoqin_Name_checkctrl[i]:Hide()
		g_Biwuzhaoqin_Name_listctrl[i]:Hide()
	end
	if bFindIdx > 0 then
		Biwuzhaoqin_Name_OK_Button:Disable()
	elseif g_Biwuzhaoqin_Name_Select == 0 then
		Biwuzhaoqin_Name_OK_Button:Disable()
	else
		Biwuzhaoqin_Name_OK_Button:Enable()
	end
end

function Biwuzhaoqin_Name_OnItemClick(idx)
--	for i=1,16 do
--		g_Biwuzhaoqin_Name_checkctrl[i]:SetCheck(0)
--	end
--
--	g_Biwuzhaoqin_Name_checkctrl[idx]:SetCheck(1)
	g_Biwuzhaoqin_Name_Select = idx

	Biwuzhaoqin_Name_OK_Button:Enable()
end
function Biwuzhaoqin_Name_Ok_Clicked()
	if g_Biwuzhaoqin_Name_Select == 0 then
		return
	end
	local tblinfo = BWZQ:LuaFnGetVoterList()
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end  
	local guid 	    = tblinfo[g_Biwuzhaoqin_Name_Select].guid
	PushEvent("CONFIRM_BWZQ_SELECTLOVE", guid)
end

function Biwuzhaoqin_Name_CloseClicked()
	CloseWindow("MessageBox_Self",true)
	this:Hide()
end