
local g_PetEgg_Frame_UnifiedPosition = ""
local g_PetEgg_nBagIndex = -1    		--背包中的位置 
local g_PetEgg_nItemIndex = -1   		--物品ID 
local g_PetEgg_nCanSelectTotal = 0     	--可选按钮个数 
local g_PetEgg_strPetName = ""

local g_PetEgg_nScriptID = -1

function SeventhFestival_PetEgg_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");

end

function SeventhFestival_PetEgg_OnLoad()

end

function SeventhFestival_PetEgg_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 998515001) then

		g_PetEgg_nBagIndex = Get_XParam_INT(0)
		g_PetEgg_nItemIndex = Get_XParam_INT(1)
        g_PetEgg_nCanSelectTotal = Get_XParam_INT(2)
        g_PetEgg_strPetName = Get_XParam_STR(0)
        
        SeventhFestival_PetEgg_UpdateFrame()
        this:Show();
				
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 998545001) then

		g_PetEgg_nBagIndex = Get_XParam_INT(0)
		g_PetEgg_nItemIndex = Get_XParam_INT(1)
        g_PetEgg_nCanSelectTotal = Get_XParam_INT(2)
        g_PetEgg_nScriptID = Get_XParam_INT(3)
        g_PetEgg_strPetName = Get_XParam_STR(0)
        
        SeventhFestival_PetEgg_UpdateFrame()
        this:Show();
		
    elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
			
end

function SeventhFestival_PetEgg_UpdateFrame()
	
	if g_PetEgg_nCanSelectTotal == 4 then

		SeventhFestival_PetEgg_OK1:Show()
		SeventhFestival_PetEgg_OK2:Show()
		SeventhFestival_PetEgg_OK3:Show()
		SeventhFestival_PetEgg_OK4:Show()
			
		SeventhFestival_PetEgg_OK1:SetText("#{ZSLZ_XML_7}")--65
		SeventhFestival_PetEgg_OK2:SetText("#{ZSLZ_XML_8}")--75
		SeventhFestival_PetEgg_OK3:SetText("#{ZSLZ_XML_9}")--85
		SeventhFestival_PetEgg_OK4:SetText("#{VIPBS_201126_11}")--95
			
		SeventhFestival_PetEgg_Text:SetText("#{ZSLZ_XML_2}"..g_PetEgg_strPetName.."#{ZSLZ_XML_3}")

	else
	
		this:Hide()
		
	end 
end

function SeventhFestival_PetEgg_Close()

	this:Hide();
	
end

function SeventhFestival_PetEgg_Select(nIndex)
	
	local nRealSelect = nIndex
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("SpecialPetEggChoosePet")
		if g_PetEgg_nScriptID == -1 then
			Set_XSCRIPT_ScriptID(998515)
		else
			Set_XSCRIPT_ScriptID(g_PetEgg_nScriptID)
		end
		Set_XSCRIPT_Parameter(0,g_PetEgg_nBagIndex)
		Set_XSCRIPT_Parameter(1,g_PetEgg_nItemIndex)
		Set_XSCRIPT_Parameter(2,nRealSelect)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	this:Hide()
end
