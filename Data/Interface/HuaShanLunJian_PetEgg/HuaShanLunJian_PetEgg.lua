
local g_PetEgg_Frame_UnifiedPosition = nil
local g_PetEgg_UICommand_Normal = 999261001
local g_PetEgg_nBagIndex = -1    		--背包中的位置 
local g_PetEgg_nItemIndex = -1   		--物品ID 
local g_PetEgg_nCanSelectTotal = 0     	--可选按钮个数 
local g_PetEgg_strPetName = ""
local g_PetEgg_strBtnName = {}
local g_PetEgg_nScriptID = -1
function HuaShanLunJian_PetEgg_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HuaShanLunJian_PetEgg_OnLoad()
	-- 保存界面的默认相对位置
	g_PetEgg_Frame_UnifiedPosition = HuaShanLunJian_PetEgg_Frame:GetProperty("UnifiedPosition")
end

function HuaShanLunJian_PetEgg_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == g_PetEgg_UICommand_Normal) then
		HuaShanLunJian_PetEgg_Normal()
        HuaShanLunJian_PetEgg_UpdateFrame()
        this:Show()
		
    elseif event == "HIDE_ON_SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ADJEST_UI_POS"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "VIEW_RESOLUTION_CHANGED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
end

function HuaShanLunJian_PetEgg_Normal()
	
	g_PetEgg_strBtnName = {}
	g_PetEgg_nBagIndex = Get_XParam_INT(0)
	g_PetEgg_nItemIndex = Get_XParam_INT(1)
	g_PetEgg_nCanSelectTotal = Get_XParam_INT(2)
	g_PetEgg_nScriptID = Get_XParam_INT(3)
	g_PetEgg_strPetName = Get_XParam_STR(0)

	for i=1, g_PetEgg_nCanSelectTotal do
		g_PetEgg_strBtnName[i] = Get_XParam_STR(i)
	end

end

function HuaShanLunJian_PetEgg_UpdateFrame()
	
	HuaShanLunJian_PetEgg_OK1:Hide()
	HuaShanLunJian_PetEgg_OK2:Hide()
	HuaShanLunJian_PetEgg_OK3:Hide()
	HuaShanLunJian_PetEgg_OK4:Hide()

	if g_PetEgg_nCanSelectTotal == 4 then

		HuaShanLunJian_PetEgg_OK1:Show()
		HuaShanLunJian_PetEgg_OK2:Show()
		HuaShanLunJian_PetEgg_OK3:Show()
		HuaShanLunJian_PetEgg_OK4:Show()
			
		HuaShanLunJian_PetEgg_OK1:SetText(g_PetEgg_strBtnName[1])
		HuaShanLunJian_PetEgg_OK2:SetText(g_PetEgg_strBtnName[2])
		HuaShanLunJian_PetEgg_OK3:SetText(g_PetEgg_strBtnName[3])
		HuaShanLunJian_PetEgg_OK4:SetText(g_PetEgg_strBtnName[4])

		HuaShanLunJian_PetEgg_Text:SetText("#{JZGN_20230710_177}"..g_PetEgg_strPetName.."#{JZGN_20230710_178}")
	elseif g_PetEgg_nCanSelectTotal == 3 then
		HuaShanLunJian_PetEgg_OK1:Show()
		HuaShanLunJian_PetEgg_OK2:Show()
		HuaShanLunJian_PetEgg_OK3:Show()

		HuaShanLunJian_PetEgg_OK1:SetText(g_PetEgg_strBtnName[1])
		HuaShanLunJian_PetEgg_OK2:SetText(g_PetEgg_strBtnName[2])
		HuaShanLunJian_PetEgg_OK3:SetText(g_PetEgg_strBtnName[3])

		HuaShanLunJian_PetEgg_Text:SetText("#{JZGN_20230710_177}"..g_PetEgg_strPetName.."#{JZGN_20230710_178}")
	elseif g_PetEgg_nCanSelectTotal == 2 then
		HuaShanLunJian_PetEgg_OK1:Show()
		HuaShanLunJian_PetEgg_OK2:Show()

		HuaShanLunJian_PetEgg_OK1:SetText(g_PetEgg_strBtnName[1])
		HuaShanLunJian_PetEgg_OK2:SetText(g_PetEgg_strBtnName[2])

		HuaShanLunJian_PetEgg_Text:SetText("#{JZGN_20230710_177}"..g_PetEgg_strPetName.."#{JZGN_20230710_178}")
	else
	
		this:Hide()
		
	end 
end

function HuaShanLunJian_PetEgg_ResetPos()
	if g_PetEgg_Frame_UnifiedPosition ~= nil then
		HuaShanLunJian_PetEgg_Frame:SetProperty("UnifiedPosition", g_PetEgg_Frame_UnifiedPosition)
	else
		this:Hide()
	end
end


function HuaShanLunJian_PetEgg_Close()
	this:Hide()
end

function HuaShanLunJian_PetEgg_Select(nIndex)
	
	if nIndex <= 0 or nIndex > g_PetEgg_nCanSelectTotal then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpecialPetEggChoosePet")
		Set_XSCRIPT_ScriptID(g_PetEgg_nScriptID)
		Set_XSCRIPT_Parameter(0, g_PetEgg_nBagIndex)
		Set_XSCRIPT_Parameter(1, g_PetEgg_nItemIndex)
		Set_XSCRIPT_Parameter(2, nIndex)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	
	this:Hide()
end
