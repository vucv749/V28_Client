--g_DWJinJie_GiftBox_More_Frame

--变量
local g_DWJinJie_GiftBox_More_Frame_UnifiedPosition = ""
local g_DWJinJie_GiftBox_More_CurBagPos = -1
local g_DWJinJie_GiftBox_More_CurSelIdx = -1
local g_DWJinJie_GiftBox_More_CurItemIndex = {}
--UI
local g_DWJinJie_GiftBox_More_BK = {}
local g_DWJinJie_GiftBox_More_UI_ActionItem = {}
local g_DWJinJie_GiftBox_More_UI_ActionMask = {}
local g_DWJinJie_GiftBox_More_UI_ItemName = {}
local g_DWJinJie_GiftBox_More_UI_DragTitle = ""
local g_DWJinJie_GiftBox_More_UI_Info = ""

--常量
local g_DWJinJie_GiftBox_More_MainScript = 998832
local g_DWJinJie_GiftBox_More_UIC = 99883202
local g_DWJinJie_GiftBox_More_TotalNum = 0
local g_DWJinJie_GiftBox_More_MaxItemNum = {6,9,12}
local g_DWJinJie_GiftBox_More_curBK = 0
local g_DWJinJie_GiftBox_More_start = {1,7,16}

function DWJinJie_GiftBox_More_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function DWJinJie_GiftBox_More_OnLoad()

	g_DWJinJie_GiftBox_More_Frame_UnifiedPosition = DWJinJie_GiftBox_More_Frame_BK:GetProperty("UnifiedPosition")
	
	g_DWJinJie_GiftBox_More_UI_DragTitle = DWJinJie_GiftBox_More_DragTitle		
	g_DWJinJie_GiftBox_More_UI_Info = DWJinJie_GiftBox_More_Info
	--g_DWJinJie_GiftBox_More_UI_Remark = DWJinJie_GiftBox_More_Remark
	g_DWJinJie_GiftBox_More_BK[1] = DWJinJie_GiftBox_More_Six_ItemBK
	g_DWJinJie_GiftBox_More_BK[2] = DWJinJie_GiftBox_More_Nine_ItemBK
	g_DWJinJie_GiftBox_More_BK[3] = DWJinJie_GiftBox_More_Twelne_ItemBK
	
	for i = 1, 27 do
		if i >= 1 and i <= 6 then
			g_DWJinJie_GiftBox_More_UI_ActionItem[i] = _G["DWJinJie_GiftBox_More_Six_Item"..i]
			g_DWJinJie_GiftBox_More_UI_ActionMask[i] = _G["DWJinJie_GiftBox_More_Six_Item"..i.."_Mask"]
			g_DWJinJie_GiftBox_More_UI_ItemName[i] = _G["DWJinJie_GiftBox_More_Six_Item"..i.."_Name"]
		elseif i >= 7 and i <= 15 then
			g_DWJinJie_GiftBox_More_UI_ActionItem[i] = _G["DWJinJie_GiftBox_More_Nine_Item"..(i-6)]
			g_DWJinJie_GiftBox_More_UI_ActionMask[i] = _G["DWJinJie_GiftBox_More_Nine_Item"..(i-6).."_Mask"]
			g_DWJinJie_GiftBox_More_UI_ItemName[i] = _G["DWJinJie_GiftBox_More_Nine_Item"..(i-6).."_Name"]
		elseif i >= 16 and i <= 27 then
			g_DWJinJie_GiftBox_More_UI_ActionItem[i] = _G["DWJinJie_GiftBox_More_Twelne_Item"..(i-15)]
			g_DWJinJie_GiftBox_More_UI_ActionMask[i] = _G["DWJinJie_GiftBox_More_Twelne_Item"..(i-15).."_Mask"]
			g_DWJinJie_GiftBox_More_UI_ItemName[i] = _G["DWJinJie_GiftBox_More_Twelne_Item"..(i-15).."_Name"]
		end
	end

end										

function DWJinJie_GiftBox_More_OnEvent(event)
	
	if event == "UI_COMMAND" and (tonumber(arg0) == g_DWJinJie_GiftBox_More_UIC) then		
		DWJinJie_GiftBox_More_CleanUp()
		g_DWJinJie_GiftBox_More_CurBagPos = Get_XParam_INT(0)
		g_DWJinJie_GiftBox_More_TotalNum = Get_XParam_INT(1)
		for i = 1, g_DWJinJie_GiftBox_More_TotalNum do
			g_DWJinJie_GiftBox_More_CurItemIndex[i] = Get_XParam_INT(1+i)
		end
		
		for i = 1, table.getn(g_DWJinJie_GiftBox_More_MaxItemNum) do
			if g_DWJinJie_GiftBox_More_TotalNum == g_DWJinJie_GiftBox_More_MaxItemNum[i] then
				g_DWJinJie_GiftBox_More_curBK = i
				break;
			end
		end
		LifeAbility:Lock_Packet_Item(g_DWJinJie_GiftBox_More_CurBagPos,1)
		this:Show()		
		DWJinJie_GiftBox_More_Update()

		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		DWJinJie_GiftBox_More_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED_EX" and tonumber(arg0) == g_DWJinJie_GiftBox_More_CurBagPos then
		this:Hide()
		return
	end
	
end

function DWJinJie_GiftBox_More_Update()

	if g_DWJinJie_GiftBox_More_CurBagPos < 0 then
		return
	end
	
	if g_DWJinJie_GiftBox_More_curBK < 1 or g_DWJinJie_GiftBox_More_curBK > 3 then
		return
	end
	
	for i = 1, table.getn(g_DWJinJie_GiftBox_More_BK) do
		if g_DWJinJie_GiftBox_More_curBK == i then
			g_DWJinJie_GiftBox_More_BK[i]:Show()
		else
			g_DWJinJie_GiftBox_More_BK[i]:Hide()
		end
	end

	--当前打开的礼包id
	local item_table_index = PlayerPackage:GetItemTableIndex(g_DWJinJie_GiftBox_More_CurBagPos)	
	local strName = DataPool:Lua_GetItemNameByIndex(item_table_index)
	g_DWJinJie_GiftBox_More_UI_DragTitle:SetText("#gFF0FA0"..strName)
	g_DWJinJie_GiftBox_More_UI_Info:SetText("#{DWJJ_240329_326}")
		
	for i = 1, g_DWJinJie_GiftBox_More_TotalNum do
		local idx = g_DWJinJie_GiftBox_More_CurItemIndex[i]
		if idx ~= nil and idx > 0 then
			local itemid, itemnum, itemname = Lua_GetZXGiftInfo(idx-1)
			if itemid ~= nil and itemid > 0 then
				local itemAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
				local ActBtnIdx = g_DWJinJie_GiftBox_More_start[g_DWJinJie_GiftBox_More_curBK]+i-1
				if itemAction:GetID() ~= 0 then
					g_DWJinJie_GiftBox_More_UI_ActionItem[ActBtnIdx]:SetActionItem(itemAction:GetID())
				end
				--local strName = DataPool:Lua_GetItemNameByIndex(itemid)
				g_DWJinJie_GiftBox_More_UI_ItemName[ActBtnIdx]:SetText(ScriptGlobal_Format("#{TYLB_20220809_13}", itemname))
			end
		end
	end
	
end

function DWJinJie_GiftBox_More_OnItemClicked(index)
	if g_DWJinJie_GiftBox_More_curBK < 1 or g_DWJinJie_GiftBox_More_curBK > 3 then
		return
	end

	for i = 1, g_DWJinJie_GiftBox_More_TotalNum do
		local ActBtnIdx = g_DWJinJie_GiftBox_More_start[g_DWJinJie_GiftBox_More_curBK]+i-1
		g_DWJinJie_GiftBox_More_UI_ActionItem[ActBtnIdx]:SetPushed(0)
		g_DWJinJie_GiftBox_More_UI_ActionMask[ActBtnIdx]:Hide()
	end	
	
	local ActBtnIdx = g_DWJinJie_GiftBox_More_start[g_DWJinJie_GiftBox_More_curBK]+index-1
	g_DWJinJie_GiftBox_More_UI_ActionItem[ActBtnIdx]:SetPushed(1)
	g_DWJinJie_GiftBox_More_UI_ActionMask[ActBtnIdx]:Show()
	g_DWJinJie_GiftBox_More_CurSelIdx = index
					
end

function DWJinJie_GiftBox_More_CleanUp()	
	
	for i = 1, 27 do	
		g_DWJinJie_GiftBox_More_UI_ActionItem[i]:SetActionItem(-1)
		g_DWJinJie_GiftBox_More_UI_ItemName[i]:SetText("")
		g_DWJinJie_GiftBox_More_UI_ActionMask[i]:Hide()
	end 
	
	if g_DWJinJie_GiftBox_More_CurBagPos >= 0 then
		LifeAbility:Lock_Packet_Item(g_DWJinJie_GiftBox_More_CurBagPos,0)
	end
	
	g_DWJinJie_GiftBox_More_CurBagPos = -1
	g_DWJinJie_GiftBox_More_CurSelIdx = -1

end

function DWJinJie_GiftBox_More_OnHidden()
	DWJinJie_GiftBox_More_CleanUp()
	this:Hide()
end

function DWJinJie_GiftBox_More_OnGetClicked()
	if g_DWJinJie_GiftBox_More_curBK < 1 or g_DWJinJie_GiftBox_More_curBK > 3 then
		return
	end

	if g_DWJinJie_GiftBox_More_CurSelIdx < 1 or g_DWJinJie_GiftBox_More_CurSelIdx > g_DWJinJie_GiftBox_More_TotalNum then
		PushDebugMessage("#{DWJJ_240329_328}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnClientGetGift")
		Set_XSCRIPT_ScriptID(g_DWJinJie_GiftBox_More_MainScript)
		Set_XSCRIPT_Parameter(0, g_DWJinJie_GiftBox_More_CurBagPos)
		Set_XSCRIPT_Parameter(1, g_DWJinJie_GiftBox_More_CurSelIdx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

	this:Hide()
end

function DWJinJie_GiftBox_More_Frame_On_ResetPos()
	if g_DWJinJie_GiftBox_More_Frame_UnifiedPosition ~= nil then
		DWJinJie_GiftBox_More_Frame_BK:SetProperty("UnifiedPosition", g_DWJinJie_GiftBox_More_Frame_UnifiedPosition)
	end
end