--!!!reloadscript =ShiZhuang_ZhanShiFitting
local g_ShiZhuang_ZhanShiFitting_UnifiedPosition = ""

--=========
--PreLoad==
--=========
function ShiZhuang_ZhanShiFitting_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("OPEN_FASHION_LOTTERY_PREVIEW")
	this:RegisterEvent("REFRESH_FASHION_LOTTERY")
end

--=========
--OnLoad
--=========
function ShiZhuang_ZhanShiFitting_OnLoad()
	g_ShiZhuang_ZhanShiFitting_UnifiedPosition = ShiZhuang_ZhanShiFitting_Frame:GetProperty("UnifiedPosition")	
end
--=========
--OnEvent
--=========
function ShiZhuang_ZhanShiFitting_OnEvent(event)

	if event == "OPEN_FASHION_LOTTERY_PREVIEW" then
		if this:IsVisible() then
			if tonumber(arg1) == 0 then
				this:Hide()
			end
		else
			this:Show()
			ShiZhuang_ZhanShiFitting_Show()
		end

		return
	end
		
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ShiZhuang_ZhanShiFitting_Frame:SetProperty("UnifiedPosition", g_ShiZhuang_ZhanShiFitting_UnifiedPosition)
	end

end

function ShiZhuang_ZhanShiFitting_Show()	
	ShiZhuang_ZhanShiFitting_CleanUp()	
	ShiZhuang_ZhanShiFitting_FakeObject:SetFakeObject("FashionLotteryPlayer")
end


function ShiZhuang_ZhanShiFitting_CloseClick()
	this:Hide()
end

function ShiZhuang_ZhanShiFitting_OnHidden()
	ShiZhuang_ZhanShiFitting_CleanUp()
end

function ShiZhuang_ZhanShiFitting_CleanUp()
	ShiZhuang_ZhanShiFitting_FakeObject:SetFakeObject("")
end

function ShiZhuang_ZhanShiFitting_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		ShiZhuang_ZhanShiFitting_FakeObject:RotateBegin(-0.3)
	else
		ShiZhuang_ZhanShiFitting_FakeObject:RotateEnd()
	end
end

function ShiZhuang_ZhanShiFitting_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
			ShiZhuang_ZhanShiFitting_FakeObject:RotateBegin(0.3)
		else
		ShiZhuang_ZhanShiFitting_FakeObject:RotateEnd()
	end
end
--缩小
function ShiZhuang_ZhanShiFitting_ZoomOut()
	if g_Distance == 1 then
		return
	end
	g_Distance = g_Distance - 1		
	ShiZhuang_ZhanShiFitting_UpdateCamera()
end
--放大
function ShiZhuang_ZhanShiFitting_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1	
	ShiZhuang_ZhanShiFitting_UpdateCamera()
end

--!!!reloadscript =ShiZhuang_ZhanShiFitting