--g_DWJinJie_GiftBox_Less_Frame

--变量
local g_DWJinJie_GiftBox_Less_Frame_UnifiedPosition = ""
local g_DWJinJie_GiftBox_Less_CurBagPos = -1
local g_DWJinJie_GiftBox_Less_CurSelIdx = -1
local g_DWJinJie_GiftBox_Less_CurItemIndex = {}
--UI
local g_DWJinJie_GiftBox_Less_BK = {}
local g_DWJinJie_GiftBox_Less_UI_ActionItem = {}
local g_DWJinJie_GiftBox_Less_UI_ActionMask = {}
local g_DWJinJie_GiftBox_Less_UI_ItemName = {}
local g_DWJinJie_GiftBox_Less_UI_DragTitle = ""
local g_DWJinJie_GiftBox_Less_UI_Info = ""

--常量
local g_DWJinJie_GiftBox_Less_MainScript = 998832
local g_DWJinJie_GiftBox_Less_UIC = 99883201
local g_DWJinJie_GiftBox_Less_TotalNum = 0
local g_DWJinJie_GiftBox_Less_MaxItemNum = {3}
local g_DWJinJie_GiftBox_Less_curBK = 0
local g_DWJinJie_GiftBox_Less_start = {1}

function DWJinJie_GiftBox_Less_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function DWJinJie_GiftBox_Less_OnLoad()

	g_DWJinJie_GiftBox_Less_Frame_UnifiedPosition = DWJinJie_GiftBox_Less_Frame_BK:GetProperty("UnifiedPosition")
	
	g_DWJinJie_GiftBox_Less_UI_DragTitle = DWJinJie_GiftBox_Less_DragTitle		
	g_DWJinJie_GiftBox_Less_UI_Info = DWJinJie_GiftBox_Less_Info
	--g_DWJinJie_GiftBox_Less_UI_Remark = DWJinJie_GiftBox_Less_Remark
	g_DWJinJie_GiftBox_Less_BK[1] = DWJinJie_GiftBox_Less_Three_ItemBK
	--g_DWJinJie_GiftBox_Less_BK[2] = DWJinJie_GiftBox_Less_Four_ItemBK
	
	for i = 1, 3 do
		if i >= 1 and i <= 3 then
			g_DWJinJie_GiftBox_Less_UI_ActionItem[i] = _G["DWJinJie_GiftBox_Less_Three_Item"..i]
			g_DWJinJie_GiftBox_Less_UI_ActionMask[i] = _G["DWJinJie_GiftBox_Less_Three_Item"..i.."_Mask"]
			g_DWJinJie_GiftBox_Less_UI_ItemName[i] = _G["DWJinJie_GiftBox_Less_Three_Item"..i.."_Name"]
		--elseif i >= 4 and i <= 7 then
		--	g_DWJinJie_GiftBox_Less_UI_ActionItem[i] = _G["DWJinJie_GiftBox_Less_Four_Item"..(i-3)]
		--	g_DWJinJie_GiftBox_Less_UI_ActionMask[i] = _G["DWJinJie_GiftBox_Less_Four_Item"..(i-3).."_Mask"]
		--	g_DWJinJie_GiftBox_Less_UI_ItemName[i] = _G["DWJinJie_GiftBox_Less_Four_Item"..(i-3).."_Name"]
		end
	end

end										

function DWJinJie_GiftBox_Less_OnEvent(event)
	
	if event == "UI_COMMAND" and (tonumber(arg0) == g_DWJinJie_GiftBox_Less_UIC) then		
		DWJinJie_GiftBox_Less_CleanUp()
		g_DWJinJie_GiftBox_Less_CurBagPos = Get_XParam_INT(0)
		g_DWJinJie_GiftBox_Less_TotalNum = Get_XParam_INT(1)
		for i = 1, g_DWJinJie_GiftBox_Less_TotalNum do
			g_DWJinJie_GiftBox_Less_CurItemIndex[i] = Get_XParam_INT(1+i)
		end
		
		for i = 1, table.getn(g_DWJinJie_GiftBox_Less_MaxItemNum) do
			if g_DWJinJie_GiftBox_Less_TotalNum == g_DWJinJie_GiftBox_Less_MaxItemNum[i] then
				g_DWJinJie_GiftBox_Less_curBK = i
				break;
			end
		end
		LifeAbility:Lock_Packet_Item(g_DWJinJie_GiftBox_Less_CurBagPos,1)
		this:Show()		
		DWJinJie_GiftBox_Less_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		DWJinJie_GiftBox_Less_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == g_DWJinJie_GiftBox_Less_CurBagPos then
		this:Hide()
		return
	end
	
end

function DWJinJie_GiftBox_Less_Update()

	if g_DWJinJie_GiftBox_Less_CurBagPos < 0 then
		return
	end
	
	if g_DWJinJie_GiftBox_Less_curBK < 1 or g_DWJinJie_GiftBox_Less_curBK > 2 then
		return
	end
	
	for i = 1, table.getn(g_DWJinJie_GiftBox_Less_BK) do
		if g_DWJinJie_GiftBox_Less_curBK == i then
			g_DWJinJie_GiftBox_Less_BK[i]:Show()
		else
			g_DWJinJie_GiftBox_Less_BK[i]:Hide()
		end
	end

	--当前打开的礼包id
	local item_table_index = PlayerPackage:GetItemTableIndex(g_DWJinJie_GiftBox_Less_CurBagPos)	
	local strName = DataPool:Lua_GetItemNameByIndex(item_table_index)
	g_DWJinJie_GiftBox_Less_UI_DragTitle:SetText("#gFF0FA0"..strName)
	g_DWJinJie_GiftBox_Less_UI_Info:SetText("#{DWJJ_240329_326}")
		
	for i = 1, g_DWJinJie_GiftBox_Less_TotalNum do
		local idx = g_DWJinJie_GiftBox_Less_CurItemIndex[i]
		if idx ~= nil and idx > 0 then
			local itemid, itemnum, itemname = Lua_GetZXGiftInfo(idx-1)
			if itemid ~= nil and itemid > 0 then
				local itemAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
				local ActBtnIdx = g_DWJinJie_GiftBox_Less_start[g_DWJinJie_GiftBox_Less_curBK]+i-1
				if itemAction:GetID() ~= 0 then
					g_DWJinJie_GiftBox_Less_UI_ActionItem[ActBtnIdx]:SetActionItem(itemAction:GetID())
				end
				--local strName = DataPool:Lua_GetItemNameByIndex(itemid)
				g_DWJinJie_GiftBox_Less_UI_ItemName[ActBtnIdx]:SetText(ScriptGlobal_Format("#{TYLB_20220809_13}", itemname))
			end
		end
	end
	
end

function DWJinJie_GiftBox_Less_OnItemClicked(index)
	if g_DWJinJie_GiftBox_Less_curBK < 1 or g_DWJinJie_GiftBox_Less_curBK > 2 then
		return
	end

	for i = 1, g_DWJinJie_GiftBox_Less_TotalNum do
		local ActBtnIdx = g_DWJinJie_GiftBox_Less_start[g_DWJinJie_GiftBox_Less_curBK]+i-1
		g_DWJinJie_GiftBox_Less_UI_ActionItem[ActBtnIdx]:SetPushed(0)
		g_DWJinJie_GiftBox_Less_UI_ActionMask[ActBtnIdx]:Hide()
	end	
	
	local ActBtnIdx = g_DWJinJie_GiftBox_Less_start[g_DWJinJie_GiftBox_Less_curBK]+index-1
	g_DWJinJie_GiftBox_Less_UI_ActionItem[ActBtnIdx]:SetPushed(1)
	g_DWJinJie_GiftBox_Less_UI_ActionMask[ActBtnIdx]:Show()
	g_DWJinJie_GiftBox_Less_CurSelIdx = index
					
end

function DWJinJie_GiftBox_Less_CleanUp()	
	
	for i = 1, 3 do	
		g_DWJinJie_GiftBox_Less_UI_ActionItem[i]:SetActionItem(-1)
		g_DWJinJie_GiftBox_Less_UI_ItemName[i]:SetText("")
		g_DWJinJie_GiftBox_Less_UI_ActionMask[i]:Hide()
	end 
	
	if g_DWJinJie_GiftBox_Less_CurBagPos >= 0 then
		LifeAbility:Lock_Packet_Item(g_DWJinJie_GiftBox_Less_CurBagPos,0)
	end
	
	g_DWJinJie_GiftBox_Less_CurBagPos = -1
	g_DWJinJie_GiftBox_Less_CurSelIdx = -1

end

function DWJinJie_GiftBox_Less_OnHidden()
	DWJinJie_GiftBox_Less_CleanUp()
	this:Hide()
end

function DWJinJie_GiftBox_Less_OnGetClicked()
	if g_DWJinJie_GiftBox_Less_curBK < 1 or g_DWJinJie_GiftBox_Less_curBK > 2 then
		return
	end

	if g_DWJinJie_GiftBox_Less_CurSelIdx < 1 or g_DWJinJie_GiftBox_Less_CurSelIdx > g_DWJinJie_GiftBox_Less_TotalNum then
		PushDebugMessage("#{DWJJ_240329_328}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnClientGetGift")
		Set_XSCRIPT_ScriptID(g_DWJinJie_GiftBox_Less_MainScript)
		Set_XSCRIPT_Parameter(0, g_DWJinJie_GiftBox_Less_CurBagPos)
		Set_XSCRIPT_Parameter(1, g_DWJinJie_GiftBox_Less_CurSelIdx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function DWJinJie_GiftBox_Less_Frame_On_ResetPos()
	if g_DWJinJie_GiftBox_Less_Frame_UnifiedPosition ~= nil then
		DWJinJie_GiftBox_Less_Frame_BK:SetProperty("UnifiedPosition", g_DWJinJie_GiftBox_Less_Frame_UnifiedPosition)
	end
end
