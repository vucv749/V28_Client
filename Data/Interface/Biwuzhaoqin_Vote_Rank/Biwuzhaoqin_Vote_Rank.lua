local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_Vote_Rank_TargetId = -1

local g_Biwuzhaoqin_VR_listctrl = {}

local g_Biwuzhaoqin_Vote_Rank_ButtonLastTime = 0
local g_Biwuzhaoqin_Vote_Rank_ButtonCDTime = 3000 --3s


function Biwuzhaoqin_Vote_Rank_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_BWZQ_VOTERLIST10",false)
	this:RegisterEvent("SCENE_TRANSED",false)

end

function Biwuzhaoqin_Vote_Rank_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_Vote_Rank_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_Vote_Rank_Frame:GetProperty("UnifiedYPosition");
	g_Biwuzhaoqin_VR_listctrl = {
		{frame=Biwuzhaoqin_Vote_Rank_List1,	rank=Biwuzhaoqin_Vote_Rank_List1_Num,	name=Biwuzhaoqin_Vote_Rank_List1_1,	level=Biwuzhaoqin_Vote_Rank_List1_2,	votecount=Biwuzhaoqin_Vote_Rank_List1_3},
		{frame=Biwuzhaoqin_Vote_Rank_List2,	rank=Biwuzhaoqin_Vote_Rank_List2_Num,	name=Biwuzhaoqin_Vote_Rank_List2_1,	level=Biwuzhaoqin_Vote_Rank_List2_2,	votecount=Biwuzhaoqin_Vote_Rank_List2_3},
		{frame=Biwuzhaoqin_Vote_Rank_List3,	rank=Biwuzhaoqin_Vote_Rank_List3_Num,	name=Biwuzhaoqin_Vote_Rank_List3_1,	level=Biwuzhaoqin_Vote_Rank_List3_2,	votecount=Biwuzhaoqin_Vote_Rank_List3_3},
		{frame=Biwuzhaoqin_Vote_Rank_List4,	rank=Biwuzhaoqin_Vote_Rank_List4_Num,	name=Biwuzhaoqin_Vote_Rank_List4_1,	level=Biwuzhaoqin_Vote_Rank_List4_2,	votecount=Biwuzhaoqin_Vote_Rank_List4_3},
		{frame=Biwuzhaoqin_Vote_Rank_List5,	rank=Biwuzhaoqin_Vote_Rank_List5_Num,	name=Biwuzhaoqin_Vote_Rank_List5_1,	level=Biwuzhaoqin_Vote_Rank_List5_2,	votecount=Biwuzhaoqin_Vote_Rank_List5_3},
		{frame=Biwuzhaoqin_Vote_Rank_List6,	rank=Biwuzhaoqin_Vote_Rank_List6_Num,	name=Biwuzhaoqin_Vote_Rank_List6_1,	level=Biwuzhaoqin_Vote_Rank_List6_2,	votecount=Biwuzhaoqin_Vote_Rank_List6_3},
		{frame=Biwuzhaoqin_Vote_Rank_List7,	rank=Biwuzhaoqin_Vote_Rank_List7_Num,	name=Biwuzhaoqin_Vote_Rank_List7_1,	level=Biwuzhaoqin_Vote_Rank_List7_2,	votecount=Biwuzhaoqin_Vote_Rank_List7_3},
		{frame=Biwuzhaoqin_Vote_Rank_List8,	rank=Biwuzhaoqin_Vote_Rank_List8_Num,	name=Biwuzhaoqin_Vote_Rank_List8_1,	level=Biwuzhaoqin_Vote_Rank_List8_2,	votecount=Biwuzhaoqin_Vote_Rank_List8_3},
		{frame=Biwuzhaoqin_Vote_Rank_List9,	rank=Biwuzhaoqin_Vote_Rank_List9_Num,	name=Biwuzhaoqin_Vote_Rank_List9_1,	level=Biwuzhaoqin_Vote_Rank_List9_2,	votecount=Biwuzhaoqin_Vote_Rank_List9_3},
		{frame=Biwuzhaoqin_Vote_Rank_List10,	rank=Biwuzhaoqin_Vote_Rank_List10_Num,	name=Biwuzhaoqin_Vote_Rank_List10_1,	level=Biwuzhaoqin_Vote_Rank_List10_2,	votecount=Biwuzhaoqin_Vote_Rank_List10_3},
	}
end

function Biwuzhaoqin_Vote_Rank_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Biwuzhaoqin_Vote_Rank_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		Biwuzhaoqin_Vote_Rank_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 79210705) then
		local bShow = Get_XParam_INT(0)
		if bShow == 1 then
			g_Biwuzhaoqin_Vote_Rank_TargetId = Get_XParam_INT(1);

			local ObjCaredID = DataPool : GetNPCIDByServerID(g_Biwuzhaoqin_Vote_Rank_TargetId);
			if ObjCaredID == -1 then
				return;
			end
			this:CareObject(ObjCaredID, 1, "Biwuzhaoqin_Vote_Rank");
			local name = Get_XParam_STR(0)
			Biwuzhaoqin_Vote_Rank_PageHeader_Name:SetText( ScriptGlobal_Format("#{BWZQ_20230329_305}",name) )

			CloseWindow("Biwuzhaoqin_appearance", true)
			this:Show()
		end
	elseif (event == "UPDATE_BWZQ_VOTERLIST10") then
		Biwuzhaoqin_Vote_Rank_Update()
	elseif( event == "SCENE_TRANSED" ) then		
		Biwuzhaoqin_Vote_Rank_OnClose()
	end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_Vote_Rank_ResetPos()
	Biwuzhaoqin_Vote_Rank_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_Vote_Rank_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_Vote_Rank_OnClose()
	this:Hide()
end

function Biwuzhaoqin_Vote_Rank_Update()

	local tblinfo = BWZQ:LuaFnGetVoterList()

	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
	end

	for i = 1, table.getn(tblinfo) do

		local id 	    = tblinfo[i].id
		local guid 	    = tblinfo[i].guid
		local name      = tblinfo[i].name
		local level     = tblinfo[i].level
		local votecount    = tblinfo[i].votecount
		if guid == GetSelfGUID() then
			id = "#G"..(id+1)
			name = "#G"..name
			level = "#G"..level
			votecount = "#G"..votecount
		else
			id = "#cfff263"..(id+1)
			name = "#cfff263"..name
			level = "#cfff263"..level
			votecount = "#cfff263"..votecount
		end
	
		g_Biwuzhaoqin_VR_listctrl[i].frame:Show()
		g_Biwuzhaoqin_VR_listctrl[i].rank:SetText(id)
		g_Biwuzhaoqin_VR_listctrl[i].name:SetText(name)
		g_Biwuzhaoqin_VR_listctrl[i].level:SetText(level)
		g_Biwuzhaoqin_VR_listctrl[i].votecount:SetText(votecount)
  end
     
	for i=table.getn(tblinfo)+1, 10 do
		g_Biwuzhaoqin_VR_listctrl[i].frame:Hide()
	end
end

function Biwuzhaoqin_Vote_Rank_CloseClicked()
	this:Hide()
end
