local Redenvelope_HistoryList_Frame_UnifiedPosition;

local ChannelImage =
{
	[0] =  "set:Redenvelope image:History_World",
	[1] =  "set:Redenvelope image:History_City",
	[2] =  "set:Redenvelope image:History_Union",
}

--0是定额,1是拼手气
local DistributeImage =
{
	[0] =  "set:Redenvelope image:History_Fixed",
    [1] =  "set:Redenvelope image:History_Fortune",
}

local CurrencyUnitImage =
{
	[1] =  {PushedImage = "set:Redenvelope image:HistoryButton_Goled_Pushed",NormalImage = "set:Redenvelope image:HistoryButton_Goled_Normal",HoverImage = "set:Redenvelope image:HistoryButton_Goled_Hover"},
    [2] =  {PushedImage = "set:Redenvelope image:HistoryButton_Yuanbao_Pushed",NormalImage = "set:Redenvelope image:HistoryButton_Yuanbao_Normal",HoverImage = "set:Redenvelope image:HistoryButton_Yuanbao_Hover"},
}

local CurrencyUnitOpenImage =
{
	[1] =  {PushedImage = "set:Redenvelope image:HistoryButton_GoledOpen_Pushed",NormalImage = "set:Redenvelope image:HistoryButton_GoledOpen_Normal",HoverImage = "set:Redenvelope image:HistoryButton_GoledOpen_Hover"},
    [2] =  {PushedImage = "set:Redenvelope image:HistoryButton_YuanbaoOpen_Pushed",NormalImage = "set:Redenvelope image:HistoryButton_YuanbaoOpen_Normal",HoverImage = "set:Redenvelope image:HistoryButton_YuanbaoOpen_Hover"},
}

function Redenvelope_HistoryList_PreLoad()
    this:RegisterEvent("REDENVELOPE_HISTORY");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
    --玩家切场景
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
end

function Redenvelope_HistoryList_OnLoad()
	Redenvelope_HistoryList_Frame_UnifiedPosition = Redenvelope_HistoryList_Frame:GetProperty("UnifiedPosition");

end

function Redenvelope_HistoryList_OnEvent(event)

    if event == "REDENVELOPE_HISTORY" then
        Redenvelope_HistoryList_Show()
        
    -- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		Redenvelope_HistoryList_Frame_On_ResetPos();

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Redenvelope_HistoryList_Frame_On_ResetPos();

    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        Redenvelope_HistoryList_OnClose();
	end
    
end

function Redenvelope_HistoryList_Frame_On_ResetPos()

    Redenvelope_HistoryList_Frame:SetProperty("UnifiedPosition", Redenvelope_HistoryList_Frame_UnifiedPosition);

end

function Redenvelope_HistoryList_OnClose()
	this:Hide();
    Redenvelope_HistoryList:Clear()
end

function Redenvelope_HistoryList_OnHidden()
end


function Redenvelope_HistoryList_Show()
    Redenvelope_HistoryList:Clear()

    for i = 1, 100 do
        local ret,nGuid,uTime,nChannel,nChannelParam,nDistributeType,nCurrencyUnit,nAmount,nIsTake,uRedEnvelopePosIndex,nIsEmpty,szCharName  = Lua_GetRedEnvelopeDataByIndex(i - 1);
        if ret > 0 then
            local bar = Redenvelope_HistoryList:AddChild("Redenvelope_HistoryList_Item");
            if not bar then
                break;
            end
            bar:GetSubItem("Redenvelope_HistoryList_Type"):SetProperty("Image",DistributeImage[nDistributeType])
            bar:GetSubItem("Redenvelope_HistoryList_WideRange"):SetProperty("Image",ChannelImage[nChannel])

            bar:GetSubItem("Redenvelope_HistoryList_Name"):SetText(szCharName)
            bar:GetSubItem("Redenvelope_HistoryList_Type"):SetProperty("AlwaysOnTop", "True");
            bar:GetSubItem("Redenvelope_HistoryList_WideRange"):SetProperty("AlwaysOnTop", "True");
            bar:GetSubItem("Redenvelope_HistoryList_Name"):SetProperty("AlwaysOnTop", "True");
            if nIsTake == 1 then
                bar:GetSubItem("Redenvelope_HistoryList_Received"):Show();
                bar:GetSubItem("Redenvelope_HistoryList_Empty"):Hide();

                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("PushedImage",CurrencyUnitOpenImage[nCurrencyUnit].PushedImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("NormalImage",CurrencyUnitOpenImage[nCurrencyUnit].NormalImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("HoverImage",CurrencyUnitOpenImage[nCurrencyUnit].HoverImage)

            elseif nIsEmpty == 1 and nIsTake == 0 then
                bar:GetSubItem("Redenvelope_HistoryList_Received"):Hide();
                bar:GetSubItem("Redenvelope_HistoryList_Empty"):Show();
                
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("PushedImage",CurrencyUnitOpenImage[nCurrencyUnit].PushedImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("NormalImage",CurrencyUnitOpenImage[nCurrencyUnit].NormalImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("HoverImage",CurrencyUnitOpenImage[nCurrencyUnit].HoverImage)
            else
                bar:GetSubItem("Redenvelope_HistoryList_Received"):Hide();
                bar:GetSubItem("Redenvelope_HistoryList_Empty"):Hide();

                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("PushedImage",CurrencyUnitImage[nCurrencyUnit].PushedImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("NormalImage",CurrencyUnitImage[nCurrencyUnit].NormalImage)
                bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetProperty("HoverImage",CurrencyUnitImage[nCurrencyUnit].HoverImage)
            end
            bar:GetSubItem("Redenvelope_HistoryList_GetBtn"):SetEvent( "Clicked", string.format("Redenvelope_HistoryList_ItemClicked(%d)", i));
        else
            break;
        end
	end
    this:Show();

end

function Redenvelope_HistoryList_ItemClicked(index)

    local ret,nGuid,uTime,nChannel,nChannelParam,nDistributeType,nCurrencyUnit,nAmount,nIsTake,uRedEnvelopePosIndex,nIsEmpty,szCharName = Lua_GetRedEnvelopeDataByIndex(index - 1);
    if ret > 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("TakeRedEnvelope");
            Set_XSCRIPT_ScriptID(890253);
            Set_XSCRIPT_Parameter(0,uRedEnvelopePosIndex);
            Set_XSCRIPT_Parameter(1,nGuid);
            Set_XSCRIPT_Parameter(2,uTime);
            Set_XSCRIPT_Parameter(3,nChannel);
            Set_XSCRIPT_Parameter(4,nChannelParam);
            Set_XSCRIPT_Parameter(5,nCurrencyUnit);
            Set_XSCRIPT_Parameter(6,nIsTake);
            Set_XSCRIPT_Parameter(7,nIsEmpty);
            Set_XSCRIPT_ParamCount(8);
        Send_XSCRIPT()
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("QueryRedEnvelope");
        Set_XSCRIPT_ScriptID(890253);
        Set_XSCRIPT_Parameter(0,2);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT()

end


function Redenvelope_HistoryList_RefreshClicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("QueryRedEnvelope");
		Set_XSCRIPT_ScriptID(890253);
        Set_XSCRIPT_Parameter(0,1);
        Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end
