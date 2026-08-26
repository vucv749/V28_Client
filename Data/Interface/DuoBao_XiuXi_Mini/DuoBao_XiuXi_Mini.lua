local g_DuoBao_XiuXi_Mini_Frame_UnifiedPosition = nil 

function DuoBao_XiuXi_Mini_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("DUOBAO_XIUXI_SWITCH")

end 

-- DuoBao_XiuXi_Mini => TLBB_ButtonNULL
function DuoBao_XiuXi_Mini_OnLoad()


	g_DuoBao_XiuXi_Mini_Frame_UnifiedPosition = DuoBao_XiuXi_Mini_Frame:GetProperty("UnifiedPosition");
end

function DuoBao_XiuXi_Mini_OnEvent(event)

	if(event == "ADJEST_UI_POS") then
		DuoBao_XiuXi_Mini_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		DuoBao_XiuXi_Mini_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		DuoBao_XiuXi_Mini_On_Hide()
	elseif(event == "DUOBAO_XIUXI_SWITCH") then
		local opType = tonumber(arg0)
		if opType == 1 then
			this:Show()
		else
			this:Hide()
		end
	end
end


function DuoBao_XiuXi_Mini_On_ResetPos()
	DuoBao_XiuXi_Mini_Frame:SetProperty("UnifiedPosition", g_DuoBao_XiuXi_Mini_Frame_UnifiedPosition)
end


function DuoBao_XiuXi_Mini_Clicked()
	PushEvent("DUOBAO_XIUXI_SWITCH",2)
end


function DuoBao_XiuXi_Mini_On_Hide()
	this:Hide()
end

function DuoBao_XiuXi_Mini_Click()
end

