--活动坐骑预览
--!!!reloadscript =Mount_Auction_Exterior
local g_Mount_Auction_Exterior_Frame_UnifiedPosition = ""

local g_Distance = 1
local g_Distance_Ori = 1
local g_Distance_Max = 3

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度


local g_ExteriorRideId = 0

--PreLoad
function Mount_Auction_Exterior_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_RIDE_PREVIEW")

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("ON_SCENE_TRANS", false)
	this:RegisterEvent("ON_SERVER_TRANS", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	
	this:RegisterEvent("OPEN_STALL_SALE", false)
	this:RegisterEvent("PROGRESSBAR_SHOW", false)
	this:RegisterEvent("MODELID_CHANGE", false)

	this:RegisterEvent("FASHION_DEPOT_OP")				-- 华裳阁

	this:RegisterEvent("OPEN_EQUIP")
	this:RegisterEvent("YIGUI_OPEN")
	
	this:RegisterEvent("OPEN_EXTERIOR_FASHION")
	this:RegisterEvent("OPEN_EXTERIOR_COUPLEFASHION")
	
end

--OnLoad
function Mount_Auction_Exterior_OnLoad() 
	g_Mount_Auction_Exterior_Frame_UnifiedPosition = Mount_Auction_Exterior_Frame:GetProperty("UnifiedPosition")
end

--OnEvent
function Mount_Auction_Exterior_OnEvent(event) 

	if (event == "UI_COMMAND" and tonumber(arg0) == 120203161) or (event == "UI_COMMAND" and tonumber(arg0) == 2024082101) then
		if this:IsVisible() then 

			return
		end
		return
	end
	
	if event == "OPEN_RIDE_PREVIEW" then
		g_ExteriorRideId = tonumber(arg0)
		Mount_Auction_Exterior_CloseSomeWindow()
		this:Show()
		Mount_Auction_Exterior_Show()
		Mount_Auction_Exterior_Frame:SetForce()
	end
	
	--不能和变性同时存在
	if event == "UI_COMMAND" and tonumber(arg0) == 20120406 then
		if this:IsVisible() then 
			this:Hide()
		end		
	end	

	-- 试衣的时候不能打开衣柜
	if event == "YIGUI_OPEN" then
		if this:IsVisible() then
			this:Hide()
		end
	end
		
	if event == "OPEN_EQUIP" then
		if this:IsVisible() then 
			this:Hide()
		end
	end
	
	if event == "FASHION_DEPOT_OP" and tonumber(arg0) == 1 then --华裳阁
		if this:IsVisible() then 
			this:Hide()
		end
	end
	
	if event == "OPEN_STALL_SALE"			-- 开始摆摊，还原试穿
		or event == "PROGRESSBAR_SHOW"		-- 读进度条中，还原试穿
		or event == "MODELID_CHANGE" 		-- 变身 关闭界面
		then
		if this:IsVisible() then
			this:Hide()
		end
		return
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Mount_Auction_Exterior_Frame_On_ResetPos()
		return
	end
end

function Mount_Auction_Exterior_OnHidden()
	Mount_Auction_Exterior_FakeObject:SetFakeObject("")	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(8)
	Exterior:LuaFnExteriorRidePreviewUpdateAvatar(-1)
end

function Mount_Auction_Exterior_Frame_On_ResetPos()
	Mount_Auction_Exterior_Frame:SetProperty("UnifiedPosition", g_Mount_Auction_Exterior_Frame_UnifiedPosition)
end

function Mount_Auction_Exterior_Show()	
	Mount_Auction_Exterior_FakeObject:SetFakeObject("")
	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(8)
	local nMountId = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "MountId")
	Exterior:LuaFnExteriorRidePreviewUpdateAvatar(nMountId)
	
	Mount_Auction_Exterior_FakeObject:SetFakeObject("Exterior_Player")
	
	local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 0)
	FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
end

--左转
function Mount_Auction_Exterior_FakeObject_TurnLeft(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Mount_Auction_Exterior_FakeObject:RotateBegin(-0.3)
	else
		Mount_Auction_Exterior_FakeObject:RotateEnd()
	end
end

--右转
function Mount_Auction_Exterior_FakeObject_TurnRight(idx)
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Mount_Auction_Exterior_FakeObject:RotateBegin(0.3)
	else
		Mount_Auction_Exterior_FakeObject:RotateEnd()
	end
end

--缩小
function Mount_Auction_Exterior_FakeObject_ZoomOut()

end

--放大
function Mount_Auction_Exterior_FakeObject_ZoomIn()

end

function Mount_Auction_Exterior_CloseClick()
	this:Hide()
end

function Mount_Auction_Exterior_CloseSomeWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
end
