

local XiaLv_PldgeLove_Frame_UnifiedPosition;
local Item_index = -1
function XiaLv_PldgeLove_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ON_SCENE_TRANS");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
    this:RegisterEvent("PUT_PLDGELOVE_ITEM")
    this:RegisterEvent("RESUME_ENCHASE_GEM")
end

function XiaLv_PldgeLove_OnLoad()

	XiaLv_PldgeLove_Frame_UnifiedPosition = XiaLv_PldgeLove_Frame:GetProperty("UnifiedPosition");

    XiaLv_PldgeLove_OK:SetText("提交")
    XiaLv_PldgeLove_Pass:SetText("跳过")

    XiaLv_PldgeLove_Text:SetText("#{JHYH_230330_186}");
end

function XiaLv_PldgeLove_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 40103002 then

        local parm = Get_XParam_INT( 0 )
        if parm == 1 then
            XiaLv_PldgeLove_Text:SetText("#{JHYH_230330_186}");
            XiaLv_PldgeLove_OK:Show();
            XiaLv_PldgeLove_Pass:Show();

            if(IsWindowShow("Packet")) then
                CloseWindow("Packet", true);
            end

            if(IsWindowShow("BigBank")) then
                CloseWindow("BigBank", true);
            end

            if(IsWindowShow("Exchange")) then
                CloseWindow("Exchange", true);
            end

            if(IsWindowShow("Exchange")) then
                CloseWindow("Exchange", true);
            end

            if(IsWindowShow("YuanbaoShop")) then
                CloseWindow("YuanbaoShop", true);
            end

            this:Show()
        elseif parm == 2 then
            if Item_index ~= -1 then
                LifeAbility:Lock_Packet_Item(Item_index,0);
            end
            Item_index = tonumber(Get_XParam_INT(1));
            XiaLv_PldgeLove_SetItem(Item_index);
        elseif parm == 3 then
            XiaLv_PldgeLove_Wait();
        elseif parm == 4 then
            this:Hide();
        end

	elseif event == "PUT_PLDGELOVE_ITEM" then

        if arg0~= nil then
            XiaLv_PldgeLove_CheckItem(tonumber(arg0));
		end

	elseif (event == "ADJEST_UI_POS" ) then
        XiaLv_PldgeLove_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        XiaLv_PldgeLove_Frame_On_ResetPos();

    elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
        if tonumber(arg0) == 43 then
            LifeAbility:Lock_Packet_Item(Item_index,0);
            XiaLv_PldgeLove_Icon:SetActionItem(-1);
            Item_index = -1;
        end
    elseif (event == "ON_SCENE_TRANS") or (event == "PLAYER_LEAVE_WORLD") then
        this:Hide();
	end

end


function XiaLv_PldgeLove_CheckItem(arg0)
    Clear_XSCRIPT();
        Set_XSCRIPT_Function_Name("CheckItem");
        Set_XSCRIPT_ScriptID(401030);
        Set_XSCRIPT_Parameter(0,arg0);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();
end

function XiaLv_PldgeLove_SetItem(index)
	local itemid = PlayerPackage : GetItemTableIndex( index )
    local theShowAction = DataPool:CreateActionItemForShow(itemid, 1)
	if theAction:GetID() ~= 0 then
        XiaLv_PldgeLove_Icon:SetActionItem(theShowAction:GetID());
        LifeAbility:Lock_Packet_Item(index,1);
    else
        XiaLv_PldgeLove_Icon:SetActionItem(-1);
        LifeAbility:Lock_Packet_Item(index,0);
        Item_index = -1;
    end
end


function XiaLv_PldgeLove_Finish_Clicked()
    if Item_index < 0 then
		PushDebugMessage( "#{JHYH_230330_258}" )
        return
    end
    PushEvent("PLDGELOVE_CONFIRM",Item_index);
end

function XiaLv_PldgeLove_Finish_Skip()

    --跳过清
    LifeAbility:Lock_Packet_Item(Item_index,0);
    XiaLv_PldgeLove_Icon:SetActionItem(-1);
    Item_index = -1;

    Clear_XSCRIPT();
        Set_XSCRIPT_Function_Name("SaveItemData");
        Set_XSCRIPT_ScriptID(401030);
        Set_XSCRIPT_Parameter(0,-1);
        Set_XSCRIPT_Parameter(1,0);
        Set_XSCRIPT_ParamCount(2);
    Send_XSCRIPT();
end

function XiaLv_PldgeLove_Wait()
    XiaLv_PldgeLove_Text:SetText("#{JHYH_230330_193}");
    XiaLv_PldgeLove_OK:Hide();
    XiaLv_PldgeLove_Pass:Hide();
end

function XiaLv_PldgeLove_OnHiden()
    XiaLv_PldgeLove_Icon:SetActionItem(-1);
    LifeAbility:Lock_Packet_Item(Item_index,0);
    Item_index = -1;
    XiaLv_PldgeLove_Finish_Skip()
end

function XiaLv_PldgeLove_Frame_On_ResetPos()
    XiaLv_PldgeLove_Frame:SetProperty("UnifiedPosition", XiaLv_PldgeLove_Frame_UnifiedPosition);
end