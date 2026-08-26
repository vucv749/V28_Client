local g_Frame_UnifiedPosition
local g_Index = 1
local g_GameType = 1
local g_Image = {
    [1] = "set:CJ_Guide1 image:CJ_Guide_Image1",
    [2] = "set:CJ_Guide1 image:CJ_Guide_Image2",
    [3] = "set:CJ_Guide2 image:CJ_Guide_Image3",
    [4] = "set:CJ_Guide2 image:CJ_Guide_Image4",
    [5] = "set:CJ_Guide3 image:CJ_Guide_Image5",
    [6] = "set:CJ_Guide3 image:CJ_Guide_Image6",
    [7] = "set:CJ_Guide4 image:CJ_Guide_Image7",
}

local g_Image_Team = {
    [1] = "set:CJ_Image7 image:CJ_Guide_Image13",
    [2] = "set:CJ_Image image:CJ_Guide_Image1",
    [3] = "set:CJ_Image8 image:CJ_Guide_Image14",
    [4] = "set:CJ_Image2 image:CJ_Guide_Image2",
    [5] = "set:CJ_Image2 image:CJ_Guide_Image3",
    [6] = "set:CJ_Image6 image:CJ_Guide_Image11",
    [7] = "set:CJ_Image3 image:CJ_Guide_Image4",
    [8] = "set:CJ_Image3 image:CJ_Guide_Image5",
    [9] = "set:CJ_Image5 image:CJ_Guide_Image9",
    [10] = "set:CJ_Image6 image:CJ_Guide_Image10",
    [11] = "set:CJ_Image7 image:CJ_Guide_Image12",
    [12] = "set:CJ_Image5 image:CJ_Guide_Image8",
    [13] = "set:CJ_Image4 image:CJ_Guide_Image6",
    [14] = "set:CJ_Image4 image:CJ_Guide_Image7",
}

local g_Image_Max_Single = 7
local g_Image_Max_Team = 14

function CJ_Guide_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    -- 游戏窗口尺寸发生了变化
    this:RegisterEvent("ADJEST_UI_POS",false)
    -- 游戏分辨率发生了变化
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

end
function CJ_Guide_OnLoad()
    g_Index = 1
    g_GameType = 1
    g_Frame_UnifiedPosition = CJ_Guide_Frame:GetProperty("UnifiedPosition")
end

function CJ_Guide_OnEvent(event)

    if event == "UI_COMMAND" and tonumber(arg0) == 99932801 then
        CJ_Guide_OnShow()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		CJ_Guide_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		CJ_Guide_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
    end
end

function CJ_Guide_OnShow()
    g_Index = 1
    g_GameType = Get_XParam_INT(0)
    CJ_Guide_OnImageRefresh()
    this:Show()
end


function CJ_Guide_OnClose()
    g_Index = 1
    g_GameType = 1
    CJ_Guide_OnImageRefresh()
    this:Hide()
end

function CJ_Guide_OnImageRefresh()
    local guideImage = nil
    if g_GameType > 0 then
        guideImage = g_Image[g_Index]
    else
        guideImage = g_Image_Team[g_Index]
    end

    if guideImage ~= nil then
        CJ_Guide_ImageBk_01:SetProperty("Image", guideImage)
    else
        g_Index = 1
        CJ_Guide_ImageBk_01:SetProperty("Image", g_Image[g_Index])
    end
end

function CJ_Guide_Page_Left()

    if g_Index <= 1 then
        g_Index = 1
    else
        g_Index = g_Index - 1
    end

    CJ_Guide_OnImageRefresh()
end

function CJ_Guide_Page_Right()
    
    local indexMax = g_Image_Max_Team
    if g_GameType > 0 then
        indexMax = g_Image_Max_Single
    end

    if g_Index >= indexMax then
        g_Index = indexMax
    else
        g_Index = g_Index + 1
    end

    CJ_Guide_OnImageRefresh()
end


function CJ_Guide_ResetPos()
	CJ_Guide_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end