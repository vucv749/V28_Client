local g_unifiedposistion
local g_dir_type = {
	player	= {type=0, x=0, z=0,h=0,p=0,},			-- 主视角
	east	= {type=1, x=112, z=114, h=1050,p=-51,},	-- 东
	north	= {type=2, x=112, z=81,h=750,p=-40,},		-- 北
	west	= {type=3, x=82, z=82,h=680,p=-43,},		-- 西
	south	= {type=4, x=84, z=110,h=893,p=-51,},		-- 南
	center	= {type=5, x=92, z=119,h=2100,p=-87,},		-- 中心
}
function NoDiffMatch_Camera_PreLoad()

	this:RegisterEvent("ZBS_GMVISABLE_SHOW")
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("ZBS_GMVISABLE_TINYSHOW",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_Camera_OnLoad()
	g_unifiedposistion	= NoDiffMatch_Camera_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_Camera_OnEvent(event)

	if( event == "ZBS_GMVISABLE_SHOW" ) then
		NoDiffMatch_Camera_OnShow()
	elseif( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_Camera_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_Camera_ResetPos()
	elseif( event == "SCENE_TRANSED" ) then
		NoDiffMatch_Camera_Close()
	elseif( event == "ZBS_GMVISABLE_TINYSHOW" ) then
		this:Hide()
	end
end


function NoDiffMatch_Camera_OnShow()
	PushEvent("OPEN_NORMAL_WATCH")
	PushEvent("OPEN_MINI_WATCH")

	this:Show()
end

function NoDiffMatch_Camera_Close()
	local bRet = ZBS:CancelGMWatch()
	if bRet > 0 then
		PushEvent("OPEN_MINIMAP")
	end
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_Camera_ResetPos()
	NoDiffMatch_Camera_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

--================================================
--东
function NoDiffMatch_Camera_East_Clicked()
	local data = g_dir_type.east
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z,data.h,data.p)
	end
end

--西
function NoDiffMatch_Camera_West_Clicked()
	local data = g_dir_type.west
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z,data.h,data.p)
	end
end

--南
function NoDiffMatch_Camera_South_Clicked()
	local data = g_dir_type.south
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z,data.h,data.p)
	end
end

--北
function NoDiffMatch_Camera_North_Clicked()
	local data = g_dir_type.north
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z,data.h,data.p)
	end
end

--中心
function NoDiffMatch_Camera_Center_Clicked()
	local data = g_dir_type.center
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z,data.h,data.p)
	end
end

--玩家视角
function NoDiffMatch_Camera_Player_Clicked()
	local data = g_dir_type.player
	if data ~= nil then
		ZBS:SetPlayerWatchPosDirection(data.type,data.x,data.z)
	end
end
--================================================
function NoDiffMatch_Camera_OnShowTinyUI()
	this:Hide()
	PushEvent( "ZBS_GMVISABLE_TINYSHOW" )
end
