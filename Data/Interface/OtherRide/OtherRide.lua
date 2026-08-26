--!!!reloadscript =OtherRide
local g_OtherRide_Frame_UnifiedPosition
local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度

function OtherRide_PreLoad()
	
	this:RegisterEvent("TOGLE_OTHERRIDE_PAGE")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function OtherRide_OnLoad()
	g_OtherRide_Frame_UnifiedPosition = OtherRide_Frame:GetProperty("UnifiedPosition")
end

-- OnEvent
function OtherRide_OnEvent(event)
	
	if event == "TOGLE_OTHERRIDE_PAGE" then	
		if this:IsVisible() then			
			this:Hide()
			return
		end
		
		local obj_id = CachedTarget:GetData("NPCID", 1)
		if type(obj_id) ~= "number" then
			PushDebugMessage ("#{JSCK_90507_1}")
			return
		end
		
		this:CareObject(obj_id , 1)

		OtherRide_OnShow()
		this:Show()
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--OtherRide_TargetWuhun:Disable()
		else
			OtherRide_TargetWuhun:Enable()
		end

	end
	
	if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
	end
		
	if event == "VIEW_RESOLUTION_CHANGED" or event == "ADJEST_UI_POS" then
		OtherRide_Frame_On_ResetPos()
	end
		
	return	
end
		
function OtherRide_Frame_On_ResetPos()
	OtherRide_Frame:SetProperty("UnifiedPosition", g_OtherRide_Frame_UnifiedPosition)
	end	

function OtherRide_OnShow()

	OtherRide_Ride:SetCheck(1)
	local selfUnionPos = Variable:GetVariable("OtherUnionPos")
	if selfUnionPos ~= nil then
		OtherRide_Frame:SetProperty("UnifiedPosition", selfUnionPos)
end

	OtherRide_FakeObject:SetFakeObject("")
	
	OtherRide_Equip:SetProperty("Empty", "False")
	OtherRide_Equip:SetProperty("UseDefaultTooltip", "True")
	OtherRide_Equip_Mask:Hide()
	
	local nExteriorID = Exterior:LuaFnGetOtherExteriorInUse(3)
	if nExteriorID ~= nil and nExteriorID > 0 then
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Icon")
		local strName = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")
		local strImage = GetIconFullName(strIcon)
	
		OtherRide_Equip:SetProperty("NormalImage", strImage)
		OtherRide_Equip:SetProperty("HoverImage", strImage)
		OtherRide_Equip:SetToolTip(strName)
		
		local nMountId = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "MountId")
		CachedTarget:SetHorseModel(nMountId)
		OtherRide_FakeObject:SetFakeObject("Other_Horse")
		
		local fHeight, fDistance = Exterior:LuaFnGetExteriorRideCameraParam(nMountId, 1)
		FakeObj_SetCamera("Other_Horse", g_CameraHeight, fHeight)
		FakeObj_SetCamera("Other_Horse", g_CameraDistance, fDistance)
		
	else
		OtherRide_Equip:SetProperty("NormalImage", "")
		OtherRide_Equip:SetProperty("HoverImage", "")
		OtherRide_Equip:SetToolTip("#{INTERFACE_XML_911}")
	end

end

function OtherRide_Model_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向左旋转开始
		if start == 1 then
			OtherRide_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			OtherRide_FakeObject:RotateEnd()
		end
	end
end

function OtherRide_Model_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向右旋转开始
		if start == 1 then
			OtherRide_FakeObject:RotateBegin(0.3)
		--向右旋转结束
		else
			OtherRide_FakeObject:RotateEnd()
		end
	end
end

function OtherRide_TargetEquip_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenEquipFrame("other")
end

function OtherRide_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPrivatePage("other")
end

function OtherRide_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenPetFrame("other");
end

function OtherRide_TargetWuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		OtherRide_TargetWuhun : SetCheck(0)
		return
	end
	
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1)
	SystemSetup:OpenOtherWuhun()
end

function OtherRide_Equip_Click(buttonIn)

end

function OtherRide_Equip_Update()

end


