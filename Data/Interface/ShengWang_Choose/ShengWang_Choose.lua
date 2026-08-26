local g_ShengWang_Choose_Frame_UnifiedXPosition;
local g_ShengWang_Choose_Frame_UnifiedYPosition;

local g_ShengWang_AutoRunList=
{
	[1]={PosX=63,PosZ=53,SceneId=613,NPCName="墨知愁"},
	[2]={PosX=37,PosZ=119,SceneId=614,NPCName="江行云"},
	[3]={PosX=65,PosZ=52,SceneId=615,NPCName="阮枫眠"},
}



function ShengWang_Choose_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("OPEN_SHENGWANG_CHOOSE")
end

function ShengWang_Choose_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		ShengWang_Choose_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ShengWang_Choose_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShengWang_Choose_Close()
	elseif event == "PLAYER_LEAVE_WORLD" then
		ShengWang_Choose_Close()
	elseif event == "OPEN_SHENGWANG_CHOOSE" then
       ShengWang_Choose_OnShow()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89016101 ) then
       ShengWang_Choose_OnShow()
	end
end

function ShengWang_Choose_OnLoad()
	-- 保存界面的默认相对位置
	g_ShengWang_Choose_Frame_UnifiedXPosition	= ShengWang_Choose_Frame:GetProperty("UnifiedXPosition");
    g_ShengWang_Choose_Frame_UnifiedYPosition	= ShengWang_Choose_Frame:GetProperty("UnifiedYPosition");
end

function ShengWang_Choose_OnShow()

--	ShengWang_Choose_DragTitle:SetText("#{ZYXZ_230104_1}")
--	ShengWang_Choose_Text:SetText("#{ZYXZ_230104_8}")
--	ShengWang_Choose_NPC1Go:SetText("#{ZYXZ_230104_7}")
--	ShengWang_Choose_NPC2Go:SetText("#{ZYXZ_230104_7}")
--	ShengWang_Choose_NPC3Go:SetText("#{ZYXZ_230104_7}")

--	ShengWang_Choose_NPC1Info:SetText("#{ZYXZ_230104_5}")
--	ShengWang_Choose_NPC1Info:SetToolTip("#{ZYXZ_230104_6}")

--	ShengWang_Choose_NPC2Info:SetText("#{ZYXZ_230104_5}")
--	ShengWang_Choose_NPC2Info:SetToolTip("#{ZYXZ_230104_6}")

--	ShengWang_Choose_NPC3Info:SetText("#{ZYXZ_230104_5}")
--	ShengWang_Choose_NPC3Info:SetToolTip("#{ZYXZ_230104_6}")


	this:Show();
end

function ShengWang_Choose_NPCGo_Click(nIndex)
--PushDebugMessage("nIndex="..nIndex)
	local AutoRun = g_ShengWang_AutoRunList[nIndex]
	if AutoRun == nil then
		return
	end
	--AutoRunToTargetEx(AutoRun.PosX,AutoRun.PosZ,AutoRun.SceneId)
	AutoRuntoTargetExWithName(AutoRun.PosX,AutoRun.PosZ,AutoRun.SceneId,AutoRun.NPCName)


end

function ShengWang_Choose_NPCInfo_Click(nIndex)

	PushEvent("SHENGWANG_CHOOSE_CONFIRM",nIndex)

end

--================================================
-- 界面的默认相对位置
--================================================
function ShengWang_Choose_ResetPos()
	ShengWang_Choose_Frame:SetProperty("UnifiedXPosition", g_ShengWang_Choose_Frame_UnifiedXPosition);
	ShengWang_Choose_Frame:SetProperty("UnifiedYPosition", g_ShengWang_Choose_Frame_UnifiedYPosition);
end

function ShengWang_Choose_Close()
	this:Hide();
end




