local g_ConfraternityZTStart_Frame_UnifiedPosition;

function ConfraternityZTStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDBATTLE_DLG");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")				
end

function ConfraternityZTStart_OnLoad()
		g_ConfraternityZTStart_Frame_UnifiedPosition=ConfraternityZTStart_Frame:GetProperty("UnifiedPosition");
end


function ConfraternityZTStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDBATTLE_DLG") then
		ConfraternityZTStart_InitDlg()
		this:Show()
	end
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityZTStart_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityZTStart_Frame_On_ResetPos()
	end
end

function ConfraternityZTStart_InitDlg()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityZTStart_Input:SetText("");
end


function ConfraternityZTStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityZTStart_OnHide()
end

function ConfraternityZTStart_OnHide()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityZTStart_Accept_BtnClick()
	local guid = ConfraternityZTStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("帮会id不能为空！");
		return;
	end
	City:SendAddGuildBattleMsg(tonumber(guid));
	this:Hide();
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function ConfraternityZTStart_Frame_On_ResetPos()
  ConfraternityZTStart_Frame:SetProperty("UnifiedPosition", g_ConfraternityZTStart_Frame_UnifiedPosition);
end