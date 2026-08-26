local g_DuoBao_Shop_Frame_UnifiedPosition = nil 

local g_UI_Items = {}
local g_Object = -1
local g_objCared = -1
local g_DuoBao_Shop_CurShopID = -1

local g_DuoBao_Shop_ShopInfo = {} 
local g_DuoBao_Shop_PriceFormat = {

    [100] = {price="#{DDDB_20240711_274}",show="#{DDDB_20240711_273}"},
}


function DuoBao_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("UPDATE_MUMMY_SHOP",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

end 

local g_PageItem_Num = 12

-- DuoBao_Shop_Help => TLBB_ButtonHelp
-- DuoBao_Shop_Background_Frame1 => DefaultWindow
-- DuoBao_Shop_Close => TLBB_ButtonClose
-- DuoBao_Shop_DragTitle => TLBB_DragTitle
function DuoBao_Shop_OnLoad()
	g_DuoBao_Shop_Frame_UnifiedPosition = DuoBao_Shop_Frame:GetProperty("UnifiedPosition");

    g_UI_Items.ItemInfo  = {}
    for i=1,g_PageItem_Num do
        g_UI_Items.ItemInfo[i]={}
        g_UI_Items.ItemInfo[i].actionBtn = _G["DuoBao_Shop_Item"..i]
        g_UI_Items.ItemInfo[i].itemName = _G[string.format("DuoBao_Shop_ItemInfo%d_Text",i )]
        g_UI_Items.ItemInfo[i].itemPrice = _G[string.format("DuoBao_Shop_ItemInfo%d_Price",i )]
        --g_UI_Items.ItemInfo[i].quota = _G[string.format("DuoBao_Shop_Item%d_Quota",i )]
    end
    g_UI_Items.Daibi = DuoBao_Shop_Num_Text	
end

function DuoBao_Shop_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		DuoBao_Shop_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		DuoBao_Shop_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		DuoBao_Shop_CloseShop()
	elseif event == "UPDATE_MUMMY_SHOP" and this:IsVisible() then
		DuoBao_Shop_AskOpenShop()		
	elseif(event == "UI_COMMAND") and tonumber(arg0) == 20241226 then
		local shopId = Get_XParam_INT(0)
		local daibiNum = Get_XParam_INT(1)
		g_Object = Get_XParam_INT(2)
		g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_Object))
        DuoBao_Shop_CleanShop()
        DuoBao_Shop_OpenShop(shopId,daibiNum)
		OpenWindow("Packet")
	end
end

function DuoBao_Shop_OpenShop(shopId,daibiNum)
	if g_DuoBao_Shop_PriceFormat[shopId] == nil then
		return
	end
	--DiGong_Shop_F5_Text:Hide()
	--PushDebugMessage("daibiNum="..daibiNum)
    g_DuoBao_Shop_CurShopID = shopId
    g_UI_Items.Daibi:SetText(ScriptGlobal_Format(g_DuoBao_Shop_PriceFormat[shopId].show,daibiNum))
	g_DuoBao_Shop_ShopInfo = Lua_GetMummyShop(tonumber(shopId))
	--PushDebugMessage("g_DuoBao_Shop_ShopInfo="..type(g_DuoBao_Shop_ShopInfo))

    local cnt = table.getn(g_DuoBao_Shop_ShopInfo)
    for i = 1, g_PageItem_Num do
        if i <= cnt then
            local itemInfo = g_DuoBao_Shop_ShopInfo[i]
            if itemInfo.shopID == shopId then
                local itemID = itemInfo.itemID
                local itemName = itemInfo.itemName
                local countLimit = itemInfo.countLimit
                local countNow = itemInfo.countNow
                local needNum = itemInfo.needNum
                local onceNum = itemInfo.onceNum
                if countLimit == -1 then
                    --不限量
                   --g_UI_Items.ItemInfo[i].quota:Hide()
                    local theAction = DataPool:CreateBindActionItemForShow(itemID,onceNum)
                    if theAction:GetID() ~= 0 then
                        g_UI_Items.ItemInfo[i].actionBtn:SetActionItem(theAction:GetID())
                    end
                else
                    --g_UI_Items.ItemInfo[i].quota:Show()
                    local countLeft = countLimit-countNow --????
                    if countLeft < 0 or countLeft > 255 then
                        countLeft = 0
                    end
                    --图标以及剩余数量
                    local theAction = DataPool:CreateBindActionItemForShowWithMaxNum(itemID,onceNum,countLeft)
                    if theAction:GetID() ~= 0 then
                        g_UI_Items.ItemInfo[i].actionBtn:SetActionItem(theAction:GetID())
                    end
                    if countLeft == 0 then
                        g_UI_Items.ItemInfo[i].actionBtn:SetProperty("Gloom", "true")
                    else
                        g_UI_Items.ItemInfo[i].actionBtn:SetProperty("Gloom", "False")
                        g_UI_Items.ItemInfo[i].actionBtn:SetProperty("CornerChar","TopLeft "..countLeft )
                    end
                end
                --价格
                g_UI_Items.ItemInfo[i].itemPrice:SetText(ScriptGlobal_Format(g_DuoBao_Shop_PriceFormat[shopId].price,needNum))
                --商品名
                g_UI_Items.ItemInfo[i].itemName:SetText(itemName)
            end
        else
            --繝btn
            g_UI_Items.ItemInfo[i].itemPrice:SetText("")
            g_UI_Items.ItemInfo[i].itemName:SetText("")
            --g_UI_Items.ItemInfo[i].quota:Hide()
        end
    end
    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 1, "DuoBao_Shop")
    end
    this:Show()
end

function DuoBao_Shop_CleanShop()
    g_DuoBao_Shop_CurShopID = 0
    g_DuoBao_Shop_ShopInfo = {}
    for k, v in pairs(g_UI_Items.ItemInfo) do
        v.actionBtn:SetActionItem(-1)
    end
end


function DuoBao_Shop_ItemClicked(index)
    if g_DuoBao_Shop_ShopInfo[index] ~= nil then
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(714303)
        Set_XSCRIPT_Function_Name("BuyItem")
        Set_XSCRIPT_Parameter(0, g_DuoBao_Shop_ShopInfo[index].itemIndex)
        Set_XSCRIPT_Parameter(1, g_DuoBao_Shop_ShopInfo[index].itemID)
        Set_XSCRIPT_Parameter(2, g_DuoBao_Shop_ShopInfo[index].shopID)
        Set_XSCRIPT_Parameter(3, g_Object)
        Set_XSCRIPT_ParamCount(4)
        Send_XSCRIPT()
    end

end

function DuoBao_Shop_AskOpenShop()
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID(714303)
    Set_XSCRIPT_Function_Name("OpenShop")
    Set_XSCRIPT_Parameter(0, g_DuoBao_Shop_CurShopID)
    Set_XSCRIPT_Parameter(1, g_Object)
    Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end


function DuoBao_Shop_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "DuoBao_Shop");
end

function DuoBao_Shop_On_ResetPos()
	DuoBao_Shop_Frame:SetProperty("UnifiedPosition", g_DuoBao_Shop_Frame_UnifiedPosition)
end

function DuoBao_Shop_CloseShop()
	this:Hide()
end

function DuoBao_Shop_Help_Click()
end

function DuoBao_Shop_Close_Click()
end

