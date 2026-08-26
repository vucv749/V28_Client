--!!!reloadscript =TargetShop_Dresser
local g_TargetShop_Dresser_Frame_UnifiedPosition
local g_clientNpcId = -1

--相机
local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????
local g_CameraPosition =
{
	--女性相关位置
	[0] = {
			{fHeight = 0.82,	fDistance = 8, },
			{fHeight = 0.82,	fDistance = 6.5, },
			{fHeight = 1.5,		fDistance = 2.5, },
			{fHeight = 1.57,	fDistance = 1.7, },
		},
	--男性相关位置
	[1] = {
			{fHeight = 0.91,	fDistance = 8.8, },
			{fHeight = 0.91,	fDistance = 7.1, },
			{fHeight = 1.67,	fDistance = 2.5, },
			{fHeight = 1.745,	fDistance = 1.7, },
		},
}


function TargetShop_Dresser_PreLoad()
	this:RegisterEvent("TARGET_DRESS")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--????????
	this:RegisterEvent("CLOSE_TARGET_EQUIP");
end


function TargetShop_Dresser_OnLoad() 
	g_TargetShop_Dresser_Frame_UnifiedPosition = TargetShop_Dresser_Frame:GetProperty("UnifiedPosition")
end

function TargetShop_Dresser_OnEvent(event)
	if event == "TARGET_DRESS" then
		
		TargetShop_Dresser_FakeObject:SetFakeObject("")
		TargetShop_Dresser_CleanUp()		
		g_clientNpcId = tonumber(arg0)
		this:CareObject( g_clientNpcId, 1, "TargetShop_Dresser" )
		TargetShop_Dresser_Update()
		this:Show()
		TargetShop_Dresser_FakeObject:SetFakeObject("Exterior_Target")
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		TargetShop_Dresser_Frame_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()		
	elseif "CLOSE_TARGET_EQUIP" == event then
		this:Hide()
end
end

function TargetShop_Dresser_Frame_On_ResetPos()
  TargetShop_Dresser_Frame:SetProperty("UnifiedPosition", g_TargetShop_Dresser_Frame_UnifiedPosition)
end

function TargetShop_Dresser_OnClose()
	this:Hide()
end

function TargetShop_Dresser_OnHiden()
	this:CareObject( g_clientNpcId, 0, "TargetShop_Dresser" )
	g_clientNpcId = -1
	
	TargetShop_Dresser_CleanUp()	
end

function TargetShop_Dresser_CleanUp()
	TargetShop_Dresser_FakeObject:SetFakeObject("")
	TargetShop_Dresser_ItemActionLuxury:Hide()
end

function TargetShop_Dresser_Update()
	
	local strName = CachedTarget:GetData("NAME", 1)
	if strName == nil then
		return
	end
	local Title = ScriptGlobal_Format( "#{DECOW_160126_123}", strName )
	TargetShop_Dresser_DragTitle:SetText(Title)

	Exterior:LuaFnUpdateOtherExteriorAvatar()
	
	g_Distance = g_Distance_Ori
	TargetShop_Dresser_UpdateCamera()
	 
	local sex = CachedTarget:GetData("RACE")
	
	--时装
	TargetShop_Dresser_DecorateCloth_Item:SetActionItem(-1)
	local ActionDress = EnumAction(16, "targetequip")
	if ActionDress:GetID() == 0 then
		TargetShop_Dresser_DecorateCloth_Item:Hide()
		TargetShop_Dresser_DecorateCloth_Null:Show()
	else
		TargetShop_Dresser_DecorateCloth_Item:Show()
		TargetShop_Dresser_DecorateCloth_Null:Hide()	
		TargetShop_Dresser_DecorateCloth_Item:SetActionItem(ActionDress:GetID())
		
		TargetShop_Dresser_ItemActionLuxury:Hide()
		local nFashionId = Exterior:LuaFnGetOtherFashionInUse()
		if nFashionId > 0 then	
			local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
			if nFashionNumber ~= nil and nFashionNumber > 0 then
				TargetShop_Dresser_ItemActionLuxury:Show()
			end
		end	
	end	
	
	--坐骑
	local edType = 3	
	local nExteriorID = Exterior:LuaFnGetOtherExteriorInUse(edType)
	if nExteriorID ~= nil and nExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		TargetShop_Dresser_Ride_Item:SetProperty("Image", strImage)
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		TargetShop_Dresser_Ride_Item:SetToolTip(strTemp)
	else
		TargetShop_Dresser_Ride_Item:SetProperty("Image", "")
		TargetShop_Dresser_Ride_Item:SetToolTip("#{WGTJ_201222_52}")
	end
	
	--脸型
	edType = 0
	nExteriorID = Exterior:LuaFnGetOtherExteriorInUse(edType)
	if nExteriorID ~= nil and nExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(nExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		
		TargetShop_Dresser_Face_Name:SetText(strName)
	end
	
	--发型
	edType = 1
	nExteriorID = Exterior:LuaFnGetOtherExteriorInUse(edType)
	if nExteriorID ~= nil and nExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(nExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(nExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
	
		TargetShop_Dresser_Hair_Name:SetText(strName)
	end
	
	--头像
	edType = 2
	local strHeadTip = ""
	nExteriorID = Exterior:LuaFnGetOtherExteriorInUse(edType)
	if nExteriorID ~= nil and nExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPortraitInfo(nExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPortraitInfo(nExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		
		TargetShop_Dresser_Head_Item:SetProperty("Image", strImage)	
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		TargetShop_Dresser_Head_Item:SetToolTip(strTemp)
	end
	
	--发色
	local _, uRed, uGreee, uBlue, _ = CachedTarget:GetData("HairInfo")
	local imgColor = string.format("%02X%02X%02X%02X", 255, uRed, uGreee, uBlue)
	TargetShop_Dresser_ColorHair_ItemMask:SetImageColor(imgColor)	

end

function TargetShop_Dresser_UpdateCamera()
	local sex = 0
	if sex ~= 0 and sex ~= 1 then 
		return
	end
	
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	local fHeight = g_CameraPosition[sex][g_Distance].fHeight
	local fDistance = g_CameraPosition[sex][g_Distance].fDistance
	
	FakeObj_SetCamera("Exterior_Target", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Target", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_Target", g_CameraPitch, 0.2)
end

--玩家左旋转
function TargetShop_Dresser_TurnLeft(Index)
	if Index == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		TargetShop_Dresser_FakeObject:RotateBegin(-0.3)
	else
		TargetShop_Dresser_FakeObject:RotateEnd()
	end
end

--玩家右旋转
function TargetShop_Dresser_TurnRight(Index)
	if Index == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		TargetShop_Dresser_FakeObject:RotateBegin(0.3)
	else
		TargetShop_Dresser_FakeObject:RotateEnd()
	end
end

--玩家放大
function TargetShop_Dresser_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end	
	g_Distance = g_Distance + 1
	TargetShop_Dresser_UpdateCamera()	
end

--玩家缩小
function TargetShop_Dresser_ZoomOut()
	if g_Distance == 1 then
		return
	end	
	g_Distance = g_Distance - 1
	TargetShop_Dresser_UpdateCamera()
end

