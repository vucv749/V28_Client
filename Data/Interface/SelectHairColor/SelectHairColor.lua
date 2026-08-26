--!!!reloadscript =SelectHairColor
local g_SelectHairColor_YuanbaoPay = 1
local g_SelectHairColor_Frame_UnifiedPosition

local g_CurRed = 0
local g_CurGreen = 0
local g_CurBlue = 0
local g_CurAlpha = 255

local g_ChangeBy = 0

local g_Original_Red = 0
local g_Original_Green = 0
local g_Original_Blue = 0
local g_Original_Alpha = 0

local g_clientNpcId = -1

local g_GXHHairColorText = {}

local g_Red = {}
local g_Green = {}
local g_Blue = {}
local g_Alpha = {}
local g_Color = {}

local g_MaxColorCount = 20
local g_CurIndex = -1

local SelectHairColor_CameraHeight = 2		--?????
local SelectHairColor_CameraDistance = 2		--?????
local g_SelectHairColor_CameraLevel = 0
local g_SelectHairColor_CameraPosition =
{
	[0] = {fHeight = 1.09, fDistance = 1.30, },
	[1] = {fHeight = 0.90, fDistance = 2.30, },
	[2] = {fHeight = 0.63, fDistance = 3.30, }, 
}

local g_YB_Clicked = 0

function SelectHairColor_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("SEX_CHANGED", false)	
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("UPDATE_EXTERIOR_HAIR_COLOR", false)
	this:RegisterEvent("PLAYER_HAIR_COLOR_CHANGED", false)
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function SelectHairColor_OnLoad()
	SelectHairColor_Red:SetProperty("DocumentSize","1")
	SelectHairColor_Red:SetProperty("PageSize","0.1")
	SelectHairColor_Red:SetProperty("StepSize","0.1")
	
	SelectHairColor_Green:SetProperty("DocumentSize","1")
	SelectHairColor_Green:SetProperty("PageSize","0.1")
	SelectHairColor_Green:SetProperty("StepSize","0.1")
	
	SelectHairColor_Blue:SetProperty("DocumentSize","1")
	SelectHairColor_Blue:SetProperty("PageSize","0.1")
	SelectHairColor_Blue:SetProperty("StepSize","0.1")
	
	SelectHairColor_Brightness:SetProperty("DocumentSize","1")
	SelectHairColor_Brightness:SetProperty("PageSize","0.1")
	SelectHairColor_Brightness:SetProperty("StepSize","0.1")
	
	g_GXHHairColorText[1] = 
	{
		Icon = SelectHairColor_OneIcon;
		Push = SelectHairColor_Item_One;
		Lock = SelectHairColor_ItemLock1;
		EquipImage = SelectHairColor_SuperListItemActionDef1;
		TryImage = SelectHairColor_SuperListItemActionTry1
	}	
	g_GXHHairColorText[2] = 
	{
		Icon = SelectHairColor_TwoIcon;
		Push = SelectHairColor_Item_Two;
		Lock = SelectHairColor_ItemLock2;
		EquipImage = SelectHairColor_SuperListItemActionDef2;
		TryImage = SelectHairColor_SuperListItemActionTry2
	}
	g_GXHHairColorText[3] = 
	{
		Icon = SelectHairColor_ThreeIcon;
		Push = SelectHairColor_Item_Three;
		Lock = SelectHairColor_ItemLock3;
		EquipImage = SelectHairColor_SuperListItemActionDef3;
		TryImage = SelectHairColor_SuperListItemActionTry3
	}
	g_GXHHairColorText[4] = 
	{
		Icon = SelectHairColor_FourIcon;
		Push = SelectHairColor_Item_Four;
		Lock = SelectHairColor_ItemLock4;
		EquipImage = SelectHairColor_SuperListItemActionDef4;
		TryImage = SelectHairColor_SuperListItemActionTry4
	}
	g_GXHHairColorText[5] = 
	{
		Icon = SelectHairColor_FiveIcon;
		Push = SelectHairColor_Item_Five;
		Lock = SelectHairColor_ItemLock5;
		EquipImage = SelectHairColor_SuperListItemActionDef5;
		TryImage = SelectHairColor_SuperListItemActionTry5
	}
	g_GXHHairColorText[6] = 
	{
		Icon = SelectHairColor_SixIcon;
		Push = SelectHairColor_Item_Six;
		Lock = SelectHairColor_ItemLock6;
		EquipImage = SelectHairColor_SuperListItemActionDef6;
		TryImage = SelectHairColor_SuperListItemActionTry6
	}	
	g_GXHHairColorText[7] = 
	{
		Icon = SelectHairColor_SevenIcon;
		Push = SelectHairColor_Item_Seven;
		Lock = SelectHairColor_ItemLock7;
		EquipImage = SelectHairColor_SuperListItemActionDef7;
		TryImage = SelectHairColor_SuperListItemActionTry7
	}
	g_GXHHairColorText[8] = 
	{
		Icon = SelectHairColor_EightIcon;
		Push = SelectHairColor_Item_Eight;
		Lock = SelectHairColor_ItemLock8;
		EquipImage = SelectHairColor_SuperListItemActionDef8;
		TryImage = SelectHairColor_SuperListItemActionTry8
	}
	g_GXHHairColorText[9] = 
	{
		Icon = SelectHairColor_NineIcon;
		Push = SelectHairColor_Item_Nine;
		Lock = SelectHairColor_ItemLock9;
		EquipImage = SelectHairColor_SuperListItemActionDef9;
		TryImage = SelectHairColor_SuperListItemActionTry9
	}
	g_GXHHairColorText[10] = 
	{
		Icon = SelectHairColor_TenIcon;
		Push = SelectHairColor_Item_Ten;
		Lock = SelectHairColor_ItemLock10;
		EquipImage = SelectHairColor_SuperListItemActionDef10;
		TryImage = SelectHairColor_SuperListItemActionTry10
	}
	g_GXHHairColorText[11] = 
	{
		Icon = SelectHairColor_ElevenIcon;
		Push = SelectHairColor_Item_Eleven;
		Lock = SelectHairColor_ItemLock11;
		EquipImage = SelectHairColor_SuperListItemActionDef11;
		TryImage = SelectHairColor_SuperListItemActionTry11
	}	
	g_GXHHairColorText[12] = 
	{
		Icon = SelectHairColor_TwelveIcon;
		Push = SelectHairColor_Item_Twelve;
		Lock = SelectHairColor_ItemLock12;
		EquipImage = SelectHairColor_SuperListItemActionDef12;
		TryImage = SelectHairColor_SuperListItemActionTry12
	}
	g_GXHHairColorText[13] = 
	{
		Icon = SelectHairColor_ThirteenIcon;
		Push = SelectHairColor_Item_Thirteen;
		Lock = SelectHairColor_ItemLock13;
		EquipImage = SelectHairColor_SuperListItemActionDef13;
		TryImage = SelectHairColor_SuperListItemActionTry13
	}
	g_GXHHairColorText[14] = 
	{
		Icon = SelectHairColor_FourteenIcon;
		Push = SelectHairColor_Item_Fourteen;
		Lock = SelectHairColor_ItemLock14;
		EquipImage = SelectHairColor_SuperListItemActionDef14;
		TryImage = SelectHairColor_SuperListItemActionTry14
	}
	g_GXHHairColorText[15] = 
	{
		Icon = SelectHairColor_FifteenIcon;
		Push = SelectHairColor_Item_Fifteen;
		Lock = SelectHairColor_ItemLock15;
		EquipImage = SelectHairColor_SuperListItemActionDef15;
		TryImage = SelectHairColor_SuperListItemActionTry15
	}
	g_GXHHairColorText[16] = 
	{
		Icon = SelectHairColor_SixteenIcon;
		Push = SelectHairColor_Item_Sixteen;
		Lock = SelectHairColor_ItemLock16;
		EquipImage = SelectHairColor_SuperListItemActionDef16;
		TryImage = SelectHairColor_SuperListItemActionTry16
	}	
	g_GXHHairColorText[17] = 
	{
		Icon = SelectHairColor_SeventeenIcon;
		Push = SelectHairColor_Item_Seventeen;
		Lock = SelectHairColor_ItemLock17;
		EquipImage = SelectHairColor_SuperListItemActionDef17;
		TryImage = SelectHairColor_SuperListItemActionTry17
	}
	g_GXHHairColorText[18] = 
	{
		Icon = SelectHairColor_EighteenIcon;
		Push = SelectHairColor_Item_Eighteen;
		Lock = SelectHairColor_ItemLock18;
		EquipImage = SelectHairColor_SuperListItemActionDef18;
		TryImage = SelectHairColor_SuperListItemActionTry18
	}
	g_GXHHairColorText[19] = 
	{
		Icon = SelectHairColor_NineteenIcon;
		Push = SelectHairColor_Item_Nineteen;
		Lock = SelectHairColor_ItemLock19;
		EquipImage = SelectHairColor_SuperListItemActionDef19;
		TryImage = SelectHairColor_SuperListItemActionTry19
	}
	g_GXHHairColorText[20] = 
	{
		Icon = SelectHairColor_TwentyIcon;
		Push = SelectHairColor_Item_Twenty;
		Lock = SelectHairColor_ItemLock20;
		EquipImage = SelectHairColor_SuperListItemActionDef20;
		TryImage = SelectHairColor_SuperListItemActionTry20
	}
	
	g_SelectHairColor_Frame_UnifiedPosition = SelectHairColor_Frame:GetProperty("UnifiedPosition")
end

function SelectHairColor_OnEvent(event)
	if event == "UI_COMMAND" then
	
		if tonumber(arg0) == 80101101 then
		
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "SelectHairColor")
			end

			if IsWindowShow("SelectHairstyle") then
				CloseWindow("SelectHairstyle", true)
			end

			if IsWindowShow("SelectFacestyle") then
				CloseWindow("SelectFacestyle", true)
			end
			
			PushEvent( "CLOSE_DRESSPREVIEW") 
			PushEvent( "CLOSE_GEMEFFECTPREVIEW")

			if this:IsVisible() and tonumber(g_Original_Red) and tonumber(g_Original_Green) and tonumber(g_Original_Blue) and tonumber(g_Original_Alpha) then
				DataPool:Change_MyHairColor(g_Original_Red, g_Original_Green, g_Original_Blue, g_Original_Alpha)
			end	

			-- local nExteriorHairColorIndex = Exterior:LuaFnGetExteriorHairColorIndex()
			-- g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha = Exterior:LuaFnEnumExteriorHairColor(nExteriorHairColorIndex)
			
			this:Show()
			SelectHairColor_OnShown()
			
		elseif tonumber(arg0) == 201203141 then
			if not this:IsVisible() then
				return
			end
			
			g_Original_Red = g_CurRed
			g_Original_Green = g_CurGreen
			g_Original_Blue  = g_CurBlue
			g_Original_Alpha = g_CurAlpha
			return
		end		
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
		SelectHairColor_Model:Hide()
		SelectHairColor_Model:Show()
		SelectHairColor_Model:SetFakeObject("Player_Head")
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SelectHairColor_Frame_On_ResetPos()
	end
			
	if event == "UPDATE_EXTERIOR_HAIR_COLOR" and this:IsVisible() then
		SelectHairColor_Refresh_HairColor()
	end
	
	if event == "PLAYER_HAIR_COLOR_CHANGED" and this:IsVisible() then
		SelectHairColor_Refresh_HairColor()
	end
	
	-- FakeObject模型界面互斥
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --????
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end			
	
end

function SelectHairColor_Frame_On_ResetPos()
	SelectHairColor_Frame:SetProperty("UnifiedPosition", g_SelectHairColor_Frame_UnifiedPosition)
end

function SelectHairColor_OnShown()
	
	if g_SelectHairColor_YuanbaoPay == 1 or g_SelectHairColor_YuanbaoPay == 0 then
		SelectHairColor_Expendable_Queren:SetCheck(g_SelectHairColor_YuanbaoPay)
	end	
	
	g_Original_Red, g_Original_Green, g_Original_Blue, g_Original_Alpha = DataPool:Get_MyHairColor()	
	
	g_CurRed = g_Original_Red
	g_CurGreen = g_Original_Green
	g_CurBlue = g_Original_Blue

	SelectHairColor_UpdateColorList()
	
	SelectHairColor_Update()
	
end

function SelectHairColor_UpdateColorList()
	
	for i = 1, g_MaxColorCount do
		g_GXHHairColorText[i].Icon:SetImageColor("00FFFFFF")
		g_GXHHairColorText[i].Push:SetPushed(0)
		g_GXHHairColorText[i].TryImage:Hide()
		g_GXHHairColorText[i].EquipImage:Hide()
	end

	local count = Exterior:LuaFnGetExteriorHairColorCount()

	for i = 1, count do		
		g_Red[i], g_Green[i], g_Blue[i], g_Alpha[i],g_Color[i] = Exterior:LuaFnEnumExteriorHairColor(i - 1)
		local curIcon = string.format("%02X", 255)..string.format("%02X", g_Red[i])..string.format("%02X", g_Green[i])..string.format("%02X", g_Blue[i])
		g_GXHHairColorText[i].Icon:SetImageColor(curIcon)
		g_GXHHairColorText[i].Lock:Hide()
		g_GXHHairColorText[i].TryImage:Hide()		
		if g_Red[i] == g_Original_Red and g_Green[i] == g_Original_Green and g_Blue[i] == g_Original_Blue then
			g_GXHHairColorText[i].EquipImage:Show()
			g_CurIndex = i
		else
			g_GXHHairColorText[i].EquipImage:Hide()
		end
	end
	
	if g_CurIndex ~= 0 then
		g_GXHHairColorText[g_CurIndex].Push:SetPushed(1)
	end
end

function SelectHairColor_YB_Clicked()
	g_YB_Clicked = 1
	g_SelectHairColor_YuanbaoPay = SelectHairColor_Expendable_Queren:GetCheck()
end

function SelectHairColor_YB_MouseButtonUp()
	if g_YB_Clicked == 1 then
		g_YB_Clicked = 0
	end
	
	if g_SelectHairColor_YuanbaoPay == 1 or g_SelectHairColor_YuanbaoPay == 0 then
		SelectHairColor_Expendable_Queren:SetCheck(g_SelectHairColor_YuanbaoPay)
	end
end

function SelectHairColor_Update()

	if g_ChangeBy == 0 then
		g_ChangeBy = 1
	else
		return
	end

	SelectHairColor_Red_NumericalValue:SetText(g_CurRed)
	SelectHairColor_Red:SetPosition(g_CurRed / 200)
	
	SelectHairColor_Green_NumericalValue:SetText(g_CurGreen)
	SelectHairColor_Green:SetPosition(g_CurGreen / 200)

	SelectHairColor_Blue_NumericalValue:SetText(g_CurBlue)
	SelectHairColor_Blue:SetPosition(g_CurBlue / 200)

	SelectHairColor_Model:SetFakeObject("")
	SelectHairColor_Model:SetFakeObject("Player_Head")

	local Lumination = DataPool:Change_MyHairColor(g_CurRed, g_CurGreen, g_CurBlue, g_CurAlpha)
	
	SelectHairColor_Brightness_NumericalValue:SetText(Lumination)
	SelectHairColor_Brightness:SetPosition(Lumination / 240)
	
	g_ChangeBy = 0
end

--点击更换按钮
function SelectHairColor_ChangeBtnClicked()
	
	local count = Exterior:LuaFnGetExteriorHairColorCount()
	if g_CurIndex > count or g_CurIndex < 1 then
		return
	end
	  
	if g_Red[g_CurIndex] == g_Original_Red and g_Green[g_CurIndex] == g_Original_Green and g_Blue[g_CurIndex] == g_Original_Blue then
		PushDebugMessage("#{GXHDZ_141121_51}")
		return
	end

	g_CurRed = g_Red[g_CurIndex]
	g_CurGreen = g_Green[g_CurIndex]
	g_CurBlue = g_Blue[g_CurIndex]
	
	SelectHairColor_Update()

  	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ChangeHairColor")
		Set_XSCRIPT_ScriptID(801011)
		Set_XSCRIPT_Parameter(0, g_CurIndex - 1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

-- 点击染色按钮
function SelectHairColor_OK_Clicked()

	--得到玩家的金币和交子数目
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	
	if nMoney + nMoneyJZ < 50000 then
		PushDebugMessage("#{WGYH_210827_06}")
		return
	end
	
	local color_r, color_g, color_b, color_a, Ogre_Color = DataPool:Change_RectifyColor(g_CurRed, g_CurGreen, g_CurBlue, g_CurAlpha)
	-- 得到选择发色的亮度
	local Luminance = SelectHairColor_Brightness_NumericalValue:GetText()
	if Luminance ~= nil and tonumber(Luminance) > 126 then
		PushDebugMessage("#{WGYH_210827_05}")
		return 	
	end
		
	-- 如果选择的发色亮度不超过126（此时，(color_r,color_g,color_b) = (-1,-1,-1)）
	if tonumber(color_r) < 0 then
		local count = Exterior:LuaFnGetExteriorHairColorCount()
		for i = 1, count do
			local iRed, iGreen, iBlue = Exterior:LuaFnEnumExteriorHairColor(i - 1)
			if g_CurRed == iRed and g_CurGreen == iGreen and g_CurBlue == iBlue then
				PushDebugMessage("#{GXHDZ_141121_42}")
				return
			end
		end		

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SaveNewHairColor")
			Set_XSCRIPT_ScriptID(801011)
			Set_XSCRIPT_Parameter(0, Ogre_Color)
			Set_XSCRIPT_Parameter(1, g_SelectHairColor_YuanbaoPay)
			Set_XSCRIPT_Parameter(2, -1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	else
		g_CurRed = color_r
		g_CurGreen = color_g
		g_CurBlue = color_b
		g_CurAlpha = color_a
		SelectHairColor_Update()
		PushDebugMessage("#{WGYH_210827_05}")		
	end
	
end

function SelectHairColor_OnHidden()
	DataPool:Change_MyHairColor(g_Original_Red, g_Original_Green, g_Original_Blue, g_Original_Alpha)
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE")
	SelectHairColor_CleanUp()
end

function SelectHairColor_CleanUp()
	g_CurIndex = 0
	g_Original_Red = 0
	g_Original_Green = 0
	g_Original_Blue = 0
	g_Original_Alpha = 0
	SelectHairColor_Model:SetFakeObject("")
end

function SelectHairColor_OnClose()
	this:Hide()
end

--放大
function SelectHairColor_ZoomIn()
	if g_SelectHairColor_CameraLevel < 1  or g_SelectHairColor_CameraLevel > 2 then
		return
	end
	
	g_SelectHairColor_CameraLevel = g_SelectHairColor_CameraLevel - 1
	SelectHairColor_SetCameraPosition()

end

--缩小
function SelectHairColor_ZoomOut()

	if g_SelectHairColor_CameraLevel < 0  or g_SelectHairColor_CameraLevel > 1 then
		return
	end
	
	g_SelectHairColor_CameraLevel = g_SelectHairColor_CameraLevel + 1
	SelectHairColor_SetCameraPosition()
end

function SelectHairColor_SetCameraPosition()
	if g_SelectHairColor_CameraLevel > -1 and g_SelectHairColor_CameraLevel < 3 then
		FakeObj_SetCamera( "Player_Head", SelectHairColor_CameraHeight, g_SelectHairColor_CameraPosition[g_SelectHairColor_CameraLevel].fHeight )
		FakeObj_SetCamera( "Player_Head", SelectHairColor_CameraDistance, g_SelectHairColor_CameraPosition[g_SelectHairColor_CameraLevel].fDistance )
		FakeObj_RestoreCamera( "Player_Head" )
	end
end

-- 旋转人物头像模型（向左)
function SelectHairColor_Model_OnTurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			SelectHairColor_Model:RotateBegin(-0.3);
		--向左旋转结束
		else
			SelectHairColor_Model:RotateEnd();
		end
	end
end

--旋转人物头像模型（向右)
function SelectHairColor_Model_OnTurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			SelectHairColor_Model:RotateBegin(0.3);
		--向右旋转结束
		else
			SelectHairColor_Model:RotateEnd();
		end
	end
end

--褷色条发生改变
function SelectHairColor_SliderChanged()
	
	local temp
	if g_ChangeBy == 0 then
		g_ChangeBy = 2
	else
		return
	end
	
	if g_ChangeBy == 2 then
		temp = SelectHairColor_Red:GetPosition()
		g_CurRed = temp * 200
		SelectHairColor_Red_NumericalValue:SetText(g_CurRed)
	
		temp = SelectHairColor_Green:GetPosition()
		g_CurGreen = temp * 200
		SelectHairColor_Green_NumericalValue:SetText(g_CurGreen)
	
		temp = SelectHairColor_Blue:GetPosition()
		g_CurBlue = temp * 200
		SelectHairColor_Blue_NumericalValue:SetText(g_CurBlue)
		local Lumination = DataPool:Change_MyHairColor(g_CurRed, g_CurGreen, g_CurBlue, g_CurAlpha)
		
		SelectHairColor_Brightness_NumericalValue:SetText(Lumination)
		SelectHairColor_Brightness:SetPosition(Lumination / 240)
	end
	g_ChangeBy = 0
end

--褷色值输入框中数值变化的事件
function SelectHairColor_ColorText_Change()
	local temp;
	

	if(g_ChangeBy == 0) then
		g_ChangeBy = 3;
	else
		return;
	end
	
	if(g_ChangeBy == 3) then
		temp = SelectHairColor_Red_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		g_CurRed = tonumber(temp);
		SelectHairColor_Red:SetPosition(temp/200);
		
		temp = SelectHairColor_Green_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		g_CurGreen = tonumber(temp);
		SelectHairColor_Green:SetPosition(temp/200);
		
		temp = SelectHairColor_Blue_NumericalValue:GetText();
		if(temp == "" ) then
			g_ChangeBy = 0;
			return;
		end;
		if(tonumber(temp) > 200) then
			temp = 200;
		end
		g_CurBlue = tonumber(temp);
		SelectHairColor_Blue:SetPosition(temp/200);


		local Lumination = DataPool : Change_MyHairColor(g_CurRed,g_CurGreen,g_CurBlue,g_CurAlpha);
		
		SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
		SelectHairColor_Brightness :SetPosition(Lumination / 240);
	end
	
	g_ChangeBy = 0;
end

--失去光标
function SelectHairColor_ColorText_Lost()
	SelectHairColor_Update()
end

--Brightness亮度值输入框的值发生改变
function SelectHairColor_LuminationText_Change()
	
	local temp
	if g_ChangeBy == 0 then
		g_ChangeBy = 4
	else
		return
	end
	
	if g_ChangeBy == 4 then

		temp = SelectHairColor_Brightness_NumericalValue:GetText()
	
		if temp == "" then
			g_ChangeBy = 0
			return
		end
		
		if tonumber(temp) > 240 then
			temp = 240
		end
		
		SelectHairColor_Brightness_NumericalValue:SetText(temp)
		SelectHairColor_Brightness:SetPosition(temp / 240)
				
		local color_r, color_g, color_b, color_a = DataPool:Change_GetColorLumination(g_CurRed, g_CurGreen, g_CurBlue, g_CurAlpha, temp)
		
		color_r, color_g, color_b, color_a, Lumination = SelectHairColor_Restrict_Color(color_r, color_g, color_b, color_a, Lumination)

		g_CurRed = color_r
		g_CurGreen = color_g
		g_CurBlue = color_b
		g_CurAlpha = color_a
		
		SelectHairColor_Red_NumericalValue:SetText(g_CurRed)
		SelectHairColor_Red:SetPosition(g_CurRed / 200)
	
		SelectHairColor_Green_NumericalValue:SetText(g_CurGreen)
		SelectHairColor_Green:SetPosition(g_CurGreen / 200)

		SelectHairColor_Blue_NumericalValue:SetText(g_CurBlue)
		SelectHairColor_Blue:SetPosition(g_CurBlue / 200)
		
		local Lumination = DataPool:Change_MyHairColor(g_CurRed, g_CurGreen, g_CurBlue, g_CurAlpha)

	end
	
	g_ChangeBy = 0
	
end

-- 亮度条发生改变
function SelectHairColor_Lumination_Changed()
	local temp;
	

	if(g_ChangeBy == 0) then
		g_ChangeBy = 5;
	else
		return;
	end
	
	if(g_ChangeBy == 5) then
		temp = SelectHairColor_Brightness:GetPosition();
		local Lumination = temp * 240;

		SelectHairColor_Brightness_NumericalValue : SetText(Lumination);
		SelectHairColor_Brightness:SetPosition(Lumination/240);
	
		local color_r,color_g,color_b,color_a = DataPool:Change_GetColorLumination(g_CurRed,g_CurGreen,g_CurBlue,g_CurAlpha,Lumination);
		
		color_r,color_g,color_b,color_a,Lumination = SelectHairColor_Restrict_Color(color_r,color_g,color_b,color_a,Lumination)
		
	
		g_CurRed = color_r;
		g_CurGreen = color_g;
		g_CurBlue = color_b;
		g_CurAlpha = color_a;
		
		SelectHairColor_Red_NumericalValue : SetText(g_CurRed);
		SelectHairColor_Red : SetPosition(g_CurRed/200);
	
		SelectHairColor_Green_NumericalValue : SetText(g_CurGreen);
		SelectHairColor_Green : SetPosition(g_CurGreen/200);

		SelectHairColor_Blue_NumericalValue : SetText(g_CurBlue);
		SelectHairColor_Blue : SetPosition(g_CurBlue/200);
		
		local Lumination = DataPool : Change_MyHairColor(g_CurRed,g_CurGreen,g_CurBlue,g_CurAlpha);

	end
		
	g_ChangeBy = 0;
	
end

--亮度改变 限制褷色跟随发生改变
function SelectHairColor_Restrict_Color(Red, Green, Blue, Alpha, Lumination)

	if Red > 200 then
		Red = 200
	end
	
	if Green > 200 then
		Green = 200
	end
	
	if Blue > 200 then
		Blue = 200
	end
	
	Lumination = DataPool:Change_MyHairColor(Red, Green, Blue, Alpha)
	
	return Red, Green, Blue, Alpha, Lumination
end

--点击icon
function SelectHairColor_Color_Clicked(nIndex)	
	
	local count = Exterior:LuaFnGetExteriorHairColorCount()
	if nIndex > count or nIndex < 1 then
		return
	end
	
	g_CurIndex = nIndex
	
  	for i = 1, g_MaxColorCount do
		g_GXHHairColorText[i].Push:SetPushed(0)
		g_GXHHairColorText[i].TryImage:Hide()
	end
	g_GXHHairColorText[g_CurIndex].Push:SetPushed(1)
	
	if g_Color[g_CurIndex] ~= Exterior:LuaFnGetExteriorHairColorIndex() then
		g_GXHHairColorText[g_CurIndex].TryImage:Show()
	end

	g_CurRed = g_Red[nIndex]
	g_CurGreen = g_Green[nIndex]
	g_CurBlue = g_Blue[nIndex]
	
	SelectHairColor_Update()
	
end

function SelectHairColor_Refresh_HairColor()
	SelectHairColor_Model:SetFakeObject("")
	SelectHairColor_OnShown()
end
