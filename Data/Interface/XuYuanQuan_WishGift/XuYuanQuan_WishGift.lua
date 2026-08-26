--2022周年稳活 许愿泉 累计许愿奖励领取界面
--!!!reloadscript =XuYuanQuan_WishGift

local g_XuYuanQuan_WishGift_Frame_UnifiedPosition = 0

local MAX_OBJ_DISTANCE = 3.0
local g_XuYuanQuan_WishGift_NpcId = -1
local g_XuYuanQuan_WishGift_NpcId_index = -1

local g_XuYuanQuan_WishGift_TotalNum = 0
local g_XuYuanQuan_WishGift_NumLimit ={
	[1] = 3,
	[2] = 6,
	[3] = 10,
}
local g_XuYuanQuan_WishGift_Flag = {}
local g_XuYuanQuan_WishGift_Item = {}
local g_XuYuanQuan_WishGift_Mask = {}
local g_XuYuanQuan_WishGift_Animate = {}
local g_XuYuanQuan_WishGift_PaoPaoAnimate = {}
local g_XuYuanQuan_WishGift_PaoPaoAnimateBK = {}
--===============================================
-- PreLoad()
--===============================================
function XuYuanQuan_WishGift_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--????
	this:RegisterEvent("ADJEST_UI_POS",false)				-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- ??????????

	this:RegisterEvent("OBJECT_CARED_EVENT");           --????????????,????NPC???????
	
end
--===============================================
-- OnLoad()
--===============================================
function XuYuanQuan_WishGift_OnLoad()
	g_XuYuanQuan_WishGift_Frame_UnifiedPosition = XuYuanQuan_WishGift_Frame:GetProperty("UnifiedPosition")

	g_XuYuanQuan_WishGift_Item[1] = XuYuanQuan_WishGift_Item1
	g_XuYuanQuan_WishGift_Item[2] = XuYuanQuan_WishGift_Item2
	g_XuYuanQuan_WishGift_Item[3] = XuYuanQuan_WishGift_Item3

	g_XuYuanQuan_WishGift_Mask[1] = XuYuanQuan_WishGift_ItemOK1
	g_XuYuanQuan_WishGift_Mask[2] = XuYuanQuan_WishGift_ItemOK2
	g_XuYuanQuan_WishGift_Mask[3] = XuYuanQuan_WishGift_ItemOK3

	g_XuYuanQuan_WishGift_Animate[1] = XuYuanQuan_WishGift_ItemAnimate1
	g_XuYuanQuan_WishGift_Animate[2] = XuYuanQuan_WishGift_ItemAnimate2
	g_XuYuanQuan_WishGift_Animate[3] = XuYuanQuan_WishGift_ItemAnimate3

	g_XuYuanQuan_WishGift_PaoPaoAnimate[1] = XuYuanQuan_WishGift_Item1_Anima
	g_XuYuanQuan_WishGift_PaoPaoAnimate[2] = XuYuanQuan_WishGift_Item2_Anima
	g_XuYuanQuan_WishGift_PaoPaoAnimate[3] = XuYuanQuan_WishGift_Item3_Anima

	g_XuYuanQuan_WishGift_PaoPaoAnimateBK[1] = XuYuanQuan_WishGift_Item1_Anima_BK
	g_XuYuanQuan_WishGift_PaoPaoAnimateBK[2] = XuYuanQuan_WishGift_Item2_Anima_BK
	g_XuYuanQuan_WishGift_PaoPaoAnimateBK[3] = XuYuanQuan_WishGift_Item3_Anima_BK
end

--===============================================
-- OnEvent()
--===============================================
function XuYuanQuan_WishGift_OnEvent(event)

	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		this:Hide();
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		XuYuanQuan_WishGift_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		XuYuanQuan_WishGift_On_ResetPos()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89330401 ) then

		g_XuYuanQuan_WishGift_TotalNum = Get_XParam_INT(1)

		g_XuYuanQuan_WishGift_Flag[1] = Get_XParam_INT(2)
		g_XuYuanQuan_WishGift_Flag[2] = Get_XParam_INT(3)
		g_XuYuanQuan_WishGift_Flag[3] = Get_XParam_INT(4)

		g_XuYuanQuan_WishGift_NpcId = Get_XParam_INT( 5 )

		local OpenOrUpdate = Get_XParam_INT(0)
		if(OpenOrUpdate == 1)then
			XuYuanQuan_WishGift_Open()
		elseif(OpenOrUpdate == 2)then
			XuYuanQuan_WishGift_Update(2)
		end
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_XuYuanQuan_WishGift_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			XuYuanQuan_WishGiftn_Close()
		end

        return
	end

end

function XuYuanQuan_WishGift_Open()
	if(this:IsVisible())then
		this:Hide()
		return
	end

    XuYuanQuan_WishGift_BeginCareObject( g_XuYuanQuan_WishGift_NpcId )

	XuYuanQuan_WishGift_Update(1)

	this:Show()
end

function XuYuanQuan_WishGift_Update(OpenOrUpdate)

	for i=1,3 do
		g_XuYuanQuan_WishGift_Item[i]:Hide()
		g_XuYuanQuan_WishGift_Mask[i]:Hide()
		g_XuYuanQuan_WishGift_Animate[i]:Hide()
		g_XuYuanQuan_WishGift_PaoPaoAnimateBK[i]:Show()

		if(OpenOrUpdate == 1)then
			g_XuYuanQuan_WishGift_PaoPaoAnimate[i]:Hide()
		end

		--g_XuYuanQuan_WishGift_Text[i]:SetText(ScriptGlobal_Format("#{SDXY_211103_24}", g_XuYuanQuan_WishGift_NumLimit[i]))

		if(g_XuYuanQuan_WishGift_NumLimit[i] <= g_XuYuanQuan_WishGift_TotalNum)then
			if(g_XuYuanQuan_WishGift_Flag[i] == 0)then
				g_XuYuanQuan_WishGift_Animate[i]:Show()
			elseif(g_XuYuanQuan_WishGift_Flag[i] == 1)then
				g_XuYuanQuan_WishGift_Mask[i]:Show()
				g_XuYuanQuan_WishGift_PaoPaoAnimateBK[i]:Hide()
			end
		end
	end

	local Action1 = nil
	local Action2 = nil
	local Action3 = nil
	Action1 = DataPool:CreateActionItemForShow(38002598, 1)
	Action2 = DataPool:CreateActionItemForShow(38002599, 1)
	Action3 = DataPool:CreateActionItemForShow(38002600, 1)

	if(Action1 ~= nil and Action1:GetID() ~= 0)then
		g_XuYuanQuan_WishGift_Item[1]:SetActionItem(Action1:GetID())
		g_XuYuanQuan_WishGift_Item[1]:Show()
	end

	if(Action2 ~= nil and Action2:GetID() ~= 0)then
		g_XuYuanQuan_WishGift_Item[2]:SetActionItem(Action2:GetID())
		g_XuYuanQuan_WishGift_Item[2]:Show()
	end

	if(Action3 ~= nil and Action3:GetID() ~= 0)then
		g_XuYuanQuan_WishGift_Item[3]:SetActionItem(Action3:GetID())
		g_XuYuanQuan_WishGift_Item[3]:Show()
	end

	XuYuanQuan_WishGift_WishPointNum:SetText(ScriptGlobal_Format("#{ZNSC_220624_98}", g_XuYuanQuan_WishGift_TotalNum))
end


function XuYuanQuan_WishGift_OnHiden()
	XuYuanQuan_WishGift_StopCareObject()
	this:Hide();
end

function XuYuanQuan_WishGift_Close()
	XuYuanQuan_WishGift_OnHiden()
end

function XuYuanQuan_WishGift_ItemClicked(index)
	if(index > 0 and index < 4)then
		if(g_XuYuanQuan_WishGift_Flag[index] == 0 and g_XuYuanQuan_WishGift_NumLimit[index] <= g_XuYuanQuan_WishGift_TotalNum)then
			g_XuYuanQuan_WishGift_PaoPaoAnimateBK[index]:Hide()
			g_XuYuanQuan_WishGift_PaoPaoAnimate[index]:Show()
			g_XuYuanQuan_WishGift_PaoPaoAnimate[index]:Play(true)
		end
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AddAward_LeiJi")
		Set_XSCRIPT_ScriptID(893304);
		Set_XSCRIPT_Parameter(0,g_XuYuanQuan_WishGift_NpcId);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function XuYuanQuan_WishGift_WishPonitNum_HelpClick()
	PushEvent("QUEST_HELPINFO", "#{ZNSC_220624_10}")
end

function XuYuanQuan_WishGift_On_ResetPos()
	XuYuanQuan_WishGift_Frame:SetProperty("UnifiedPosition", g_XuYuanQuan_WishGift_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function XuYuanQuan_WishGift_BeginCareObject( objCaredId )
	g_XuYuanQuan_WishGift_NpcId_index = DataPool : GetNPCIDByServerID( objCaredId )
	if g_XuYuanQuan_WishGift_NpcId_index == -1 then
		this : Hide()
		return
	end

	this:CareObject( g_XuYuanQuan_WishGift_NpcId_index, 1, "XuYuanQuan_WishGift" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function XuYuanQuan_WishGift_StopCareObject()
	this:CareObject( g_XuYuanQuan_WishGift_NpcId_index, 0, "XuYuanQuan_WishGift" )
	g_XuYuanQuan_WishGift_NpcId_index = -1
end
