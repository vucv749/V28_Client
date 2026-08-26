local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Biwuzhaoqin_appearance_TargetId = -1

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????
local g_CameraPosition =
{
	--女性相关位置
	[0] = 
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.2},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.2},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.20},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.20}
	},
	--男性相关位置
	[1] = 
	{
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_Sex = 0

function Biwuzhaoqin_appearance_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("SHOW_BWZQ_SPONSOR_DETAIL")
	this:RegisterEvent("SCENE_TRANSED",false)

end

function Biwuzhaoqin_appearance_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Biwuzhaoqin_appearance_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Biwuzhaoqin_appearance_Frame:GetProperty("UnifiedYPosition");
end

function Biwuzhaoqin_appearance_OnEvent(event)
		if( event == "ADJEST_UI_POS" ) then
			Biwuzhaoqin_appearance_ResetPos()
		elseif( event == "VIEW_RESOLUTION_CHANGED") then
			Biwuzhaoqin_appearance_ResetPos()
		elseif( event == "SHOW_BWZQ_SPONSOR_DETAIL" ) then
			g_Biwuzhaoqin_appearance_TargetId = tonumber(arg0)
			local ObjCaredID = DataPool : GetNPCIDByServerID(g_Biwuzhaoqin_appearance_TargetId);
			if ObjCaredID == -1 then
				return;
			end
			this:CareObject(ObjCaredID, 1, "Biwuzhaoqin_appearance");
			Biwuzhaoqin_appearance_Update()

			this:Show()
		elseif( event == "SCENE_TRANSED" ) then		
			Biwuzhaoqin_appearance_OnClose()
		end
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Biwuzhaoqin_appearance_ResetPos()
	Biwuzhaoqin_appearance_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Biwuzhaoqin_appearance_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end


function Biwuzhaoqin_appearance_OnClose()
	this:Hide()
end

function Biwuzhaoqin_appearance_Update()

		g_Distance = g_Distance_Ori

		Biwuzhaoqin_appearance_FakeObject:SetFakeObject("")
		local sex, name= BWZQ:LuaFnGetBWZQSponsorInfo()
		if sex == -1 then
				return
		end
		g_Sex     = sex

		BWZQ:LuaFnUpdateSponsorExterior()
		
		Biwuzhaoqin_appearance_PageHeader_Name:SetText( ScriptGlobal_Format("#{BWZQ_20230329_106}",name) )
		Biwuzhaoqin_appearance_FakeObject:SetFakeObject("BWZQSponsorPlayer")
		
		Biwuzhaoqin_appearance_UpdateCamera()
end

--左转
function Biwuzhaoqin_appearance_TurnLeft(idx)

	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Biwuzhaoqin_appearance_FakeObject:RotateBegin(-0.3)
	else
		Biwuzhaoqin_appearance_FakeObject:RotateEnd()
	end
	
end

--右转
function Biwuzhaoqin_appearance_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Biwuzhaoqin_appearance_FakeObject:RotateBegin(0.3)
	else
		Biwuzhaoqin_appearance_FakeObject:RotateEnd()
	end
	
end


--放大
function Biwuzhaoqin_appearance_ZoomIn()
	if g_Distance == g_Distance_Max then
		return
	end
	
	g_Distance = g_Distance + 1	
	
	Biwuzhaoqin_appearance_UpdateCamera()
end
--缩小
function Biwuzhaoqin_appearance_ZoomOut()

	if g_Distance == 1 then
		return
	end
	
	g_Distance = g_Distance - 1	

	Biwuzhaoqin_appearance_UpdateCamera()
	
end

function Biwuzhaoqin_appearance_UpdateCamera()

	if g_Sex ~= 0 and g_Sex ~= 1 then
		return
	end
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end

	fHeight = g_CameraPosition[g_Sex][g_Distance].fHeight
	fDistance = g_CameraPosition[g_Sex][g_Distance].fDistance
	fPitch = g_CameraPosition[g_Sex][g_Distance].fPitch

	FakeObj_SetCamera("BWZQSponsorPlayer", g_CameraHeight, fHeight)
	FakeObj_SetCamera("BWZQSponsorPlayer", g_CameraDistance, fDistance)
	FakeObj_SetCamera("BWZQSponsorPlayer", g_CameraPitch, fPitch)

end
