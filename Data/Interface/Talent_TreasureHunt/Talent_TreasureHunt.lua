
local g_Talent_TreasureHunt_Frame_UnifiedXPosition = 0
local g_Talent_TreasureHunt_Frame_UnifiedYPosition = 0

local g_Talent_TreasureHunt_SceneIdAndPos =
{
	[1] = {sceneId = 6,posX=96,posZ=160,Image="set:Talent_TreasureHunt01 image:wuliangshan_1"},
	[2] = {sceneId = 6,posX=160,posZ=160,Image="set:Talent_TreasureHunt01 image:wuliangshan_2"},
	[3] = {sceneId = 6,posX=160,posZ=224,Image="set:Talent_TreasureHunt01 image:wuliangshan_3"},

	[4] = {sceneId = 5,posX=96,posZ=160,Image="set:Talent_TreasureHunt01 image:jinghu_1"},
	[5] = {sceneId = 5,posX=160,posZ=160,Image="set:Talent_TreasureHunt01 image:jinghu_2"},
	[6] = {sceneId = 5,posX=224,posZ=160,Image="set:Talent_TreasureHunt01 image:jinghu_3"},

	[7] = {sceneId = 4,posX=96,posZ=160,Image="set:Talent_TreasureHunt01 image:taihu_1"},
	[8] = {sceneId = 4,posX=160,posZ=160,Image="set:Talent_TreasureHunt01 image:taihu_2"},
	[9] = {sceneId = 4,posX=160,posZ=224,Image="set:Talent_TreasureHunt01 image:taihu_3"},

	[10] = {sceneId = 3,posX=96,posZ=160,Image="set:Talent_TreasureHunt01 image:songshan_1"},
	[11] = {sceneId = 3,posX=160,posZ=160,Image="set:Talent_TreasureHunt01 image:songshan_2"},
	[12] = {sceneId = 3,posX=224,posZ=160,Image="set:Talent_TreasureHunt01 image:songshan_3"},

	[13] = {sceneId = 7,posX=96,posZ=160,Image="set:Talent_TreasureHunt01 image:jiange_1"},
	[14] = {sceneId = 7,posX=160,posZ=160,Image="set:Talent_TreasureHunt01 image:jiange_2"},
	[15] = {sceneId = 7,posX=160,posZ=224,Image="set:Talent_TreasureHunt01 image:jiange_3"},

	[16] = {sceneId = 8,posX=96,posZ=160,Image="set:Talent_TreasureHunt02 image:dunhuang_1"},
	[17] = {sceneId = 8,posX=160,posZ=160,Image="set:Talent_TreasureHunt02 image:dunhuang_2"},
	[18] = {sceneId = 8,posX=224,posZ=160,Image="set:Talent_TreasureHunt02 image:dunhuang_3"},
}


--===============================================
-- OnLoad()
--===============================================
function Talent_TreasureHunt_PreLoad()

    this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");--???

end

--===============================================
-- OnLoad()
--===============================================
function Talent_TreasureHunt_OnLoad()

	g_Talent_TreasureHunt_Frame_UnifiedXPosition = Talent_TreasureHunt_Frame:GetProperty("UnifiedXPosition")
	g_Talent_TreasureHunt_Frame_UnifiedYPosition = Talent_TreasureHunt_Frame:GetProperty("UnifiedYPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Talent_TreasureHunt_OnEvent(event)
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Talent_TreasureHunt_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Talent_TreasureHunt_Frame_On_ResetPos()
		--切场景
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89319101 ) then

		local nIndex =  Get_XParam_INT(0)

		Talent_TreasureHunt_Show(nIndex)

	end
end

function Talent_TreasureHunt_Show(nIndex)
	Talent_TreasureHunt_Image:SetProperty("Image",g_Talent_TreasureHunt_SceneIdAndPos[nIndex].Image)
	--PushDebugMessage(g_Talent_TreasureHunt_SceneIdAndPos[nIndex].Image)
	this:Show();
end



function Talent_TreasureHunt_OnHide()
	this:Hide()
end


function Talent_TreasureHuntGift_OnClose()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Talent_TreasureHunt_Frame_On_ResetPos()
	Talent_TreasureHunt_Frame : SetProperty("UnifiedXPosition", g_Talent_TreasureHunt_Frame_UnifiedXPosition);
	Talent_TreasureHunt_Frame : SetProperty("UnifiedYPosition", g_Talent_TreasureHunt_Frame_UnifiedYPosition);
end
