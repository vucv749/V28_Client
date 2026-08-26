local g_ConfraternityPKStart_Frame_UnifiedPosition;

function ConfraternityPKStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDENEMY_DLG");		

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityPKStart_OnLoad()
	g_ConfraternityPKStart_Frame_UnifiedPosition=ConfraternityPKStart_Frame:GetProperty("UnifiedPosition");
end


function ConfraternityPKStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDENEMY_DLG") then
		ConfraternityPKStart_InitDlg()
		this:Show()
	end
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPKStart_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPKStart_Frame_On_ResetPos()
	end
end

function ConfraternityPKStart_InitDlg()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityPKStart_Input:SetText("");
end


function ConfraternityPKStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityPKStart_OnHide()
end

function ConfraternityPKStart_OnHide()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityPKStart_Accept_BtnClick()
	if DataPool:Lua_IsInTServer() == 1 then
		PushDebugMessage("#{HSLJ_190919_268}")
		return
	end
	local guid = ConfraternityPKStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("帮会id不能为空！");
		return;
	end
	City:SendAddEnemyMsg(tonumber(guid));
	this:Hide();
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function ConfraternityPKStart_Frame_On_ResetPos()
  ConfraternityPKStart_Frame:SetProperty("UnifiedPosition", g_ConfraternityPKStart_Frame_UnifiedPosition);
end