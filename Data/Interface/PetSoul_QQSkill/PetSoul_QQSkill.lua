--qiongqi
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_TargetId = -1
local g_PetSoul_QQSkill_Frame_UnifiedPosition;
local g_QBagIndex = -1
local g_SBagIndex = -1
local g_QiongQiDesc1 = ""
local g_QiongQiDesc2 = ""
local g_ShenDesc1 = ""
local g_ShenDesc2 = ""
local g_CheckButton = {}
local g_SelectButton = 0
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function PetSoul_QQSkill_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_QIONGQI_ITEM" ,false)
	this:RegisterEvent("UPDATE_SHEN_ITEM" ,false)
	this:RegisterEvent("OBJECT_CARED_EVENT" ,false)
	this:RegisterEvent("ADJEST_UI_POS" ,false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED" ,false)
	this:RegisterEvent("UNIT_MONEY" ,false)					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE" ,false)					--交子变化
end

--=========================================================
-- 载入初始化
--=========================================================
function PetSoul_QQSkill_OnLoad()

	g_PetSoul_QQSkill_Frame_UnifiedPosition = PetSoul_QQSkill_Frame:GetProperty("UnifiedPosition");
	
	g_CheckButton[1] = PetSoul_QQSkill_SelectQQ1
	g_CheckButton[2] = PetSoul_QQSkill_SelectQQ2
end

--=========================================================
-- 事件处理
--=========================================================
function PetSoul_QQSkill_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 99852201) then
		
		g_TargetId = Get_XParam_INT(0);
		g_CaredNpc = DataPool : GetNPCIDByServerID(g_TargetId);
		AxTrace(0,1,"g_TargetId="..g_TargetId .. " g_CaredNpc="..g_CaredNpc)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。");
			return;
		end

		BeginCareObject_PetSoul_QQSkill()

		PetSoul_QQSkill_Clear() 

		PetSoul_QQSkill_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		PetSoul_QQSkill_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

		this:Show()
		
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			PetSoul_QQSkill_OnHiden()
		end

	elseif (event == "UPDATE_QIONGQI_ITEM") then
		PetSoul_QQSkill_UpdateQPetSoul(tonumber(arg0)) 

	elseif (event == "UPDATE_SHEN_ITEM") then
		PetSoul_QQSkill_UpdateSPetSoul(tonumber(arg0))

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_QQSkill_Frame_On_ResetPos() 

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_QQSkill_Frame_On_ResetPos()

	elseif event == "UNIT_MONEY" and this:IsVisible() then
		PetSoul_QQSkill_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		PetSoul_QQSkill_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	end
end
 
--=========================================================
-- 重置界面
--=========================================================
function PetSoul_QQSkill_Clear() 
	if g_QBagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_QBagIndex,0);
	end
	if g_SBagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_SBagIndex,0);
	end
	g_SelectButton = 0
	PetSoul_QQSkill_BeforeIcon:SetActionItem(-1)
	PetSoul_QQSkill_AfterIcon:SetActionItem(-1)
	PetSoul_QQSkill_SelectQQ1:SetCheck(0)
	PetSoul_QQSkill_SelectQQ2:SetCheck(0)
	PetSoul_QQSkill_QQ_1:SetText("")
	PetSoul_QQSkill_QQ_2:SetText("")
	PetSoul_QQSkill_SS2:SetText("")
	PetSoul_QQSkill_AfterAttrFirst:SetText("")
	PetSoul_QQSkill_SelectQQ1:Hide()
	PetSoul_QQSkill_SelectQQ2:Hide()
	g_QBagIndex = -1
	g_SBagIndex = -1
	g_QiongQiDesc1 = ""
	g_QiongQiDesc2 = ""
	g_ShenDesc1 = ""
	g_ShenDesc2 = ""

	PetSoul_QQSkill_Money:SetProperty("MoneyNumber", tostring(0))
	PetSoul_QQSkill_SelfJiaozi:SetProperty("MoneyNumber", tostring(0))
	PetSoul_QQSkill_SelfMoney:SetProperty("MoneyNumber", tostring(0))

end

function PetSoul_QQSkill_ShowFrame() 


end
--=========================================================
-- 更新界面
--=========================================================
function PetSoul_QQSkill_UpdateQPetSoul(BagIndex)

	PetSoul_QQSkill_CancelQQItem() 

	if BagIndex == nil or BagIndex < 0 then
		return
	end

	g_QBagIndex = BagIndex
	LifeAbility : Lock_Packet_Item(g_QBagIndex,1);
	local theAction = EnumAction(g_QBagIndex, "packageitem")
	if theAction:GetID() ~= 0 then
		PetSoul_QQSkill_BeforeIcon:SetActionItem(theAction:GetID());
		if Pet:LuaFnIsPetSoul(g_QBagIndex) ~= 1 then
			PushDebugMessage("#{QQJG_20230815_10}")
			return
		end

		local szSkill1, szSkill2 = Pet:LuaFnGetPetSoulData(g_QBagIndex, "POSSSKILL")

		if szSkill1 ~= nil and szSkill2 ~= nil then
			PetSoul_QQSkill_QQ_1:SetText("#cfff263"..szSkill1)
			PetSoul_QQSkill_QQ_2:SetText("#cfff263"..szSkill2)
			g_QiongQiDesc1 = szSkill1
			g_QiongQiDesc2 = szSkill2
		end

		PetSoul_QQSkill_SelectQQ1:Show()
		PetSoul_QQSkill_SelectQQ2:Show()

		if g_SBagIndex >= 0 then
			local szSkill11, szSkill21 = Pet:LuaFnGetPetSoulSwallowData(g_SBagIndex, g_QBagIndex)
			if szSkill11 ~= nil and szSkill21 ~= nil then
				PetSoul_QQSkill_SS2:SetText("#cfff263"..szSkill11.."\n"..szSkill21)
				g_ShenDesc1 = szSkill11
				g_ShenDesc2 = szSkill21
			end
		end
	end

end

function PetSoul_QQSkill_UpdateSPetSoul(BagIndex)

	PetSoul_QQSkill_CancelSItem() 

	if BagIndex == nil or BagIndex < 0 then
		return
	end
	g_SBagIndex = BagIndex
	LifeAbility : Lock_Packet_Item(g_SBagIndex,1);
	local theAction = EnumAction(g_SBagIndex, "packageitem")
	if theAction:GetID() ~= 0 then
		PetSoul_QQSkill_AfterIcon:SetActionItem(theAction:GetID());
		if Pet:LuaFnIsPetSoul(g_SBagIndex) ~= 1 then
			PushDebugMessage("#{QQJG_20230815_10}")
			return
		end
		local szSkill1, szSkill2
		if g_QBagIndex < 0 then
			szSkill1, szSkill2 = Pet:LuaFnGetPetSoulData(g_SBagIndex, "POSSSKILL")
		else
			szSkill1, szSkill2 = Pet:LuaFnGetPetSoulSwallowData(g_SBagIndex, g_QBagIndex)
		end
		if szSkill1 ~= nil and szSkill2 ~= nil then
			PetSoul_QQSkill_SS2:SetText("#cfff263"..szSkill1.."\n"..szSkill2)
			g_ShenDesc1 = szSkill1
			g_ShenDesc2 = szSkill2
		end
	end

end

--=========================================================
-- 确定执行功能
--=========================================================
function PetSoul_QQSkill_OK_Clicked() 

	if g_QBagIndex < 0 then
		PushDebugMessage("#{QQJG_20230815_19}")
		return
	end

	if g_SBagIndex < 0 then
		PushDebugMessage("#{QQJG_20230815_20}")
		return
	end

	if g_SelectButton <= 0 then
		PushDebugMessage("#{QQJG_20230815_35}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Swallow")
		Set_XSCRIPT_ScriptID(998522)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, g_QBagIndex)
		Set_XSCRIPT_Parameter(2, g_SBagIndex)
		Set_XSCRIPT_Parameter(3, g_SelectButton)
		Set_XSCRIPT_Parameter(4, 0)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()	
	 
	
end

--=========================================================
-- 关闭界面
--=========================================================
--=========================================================
-- 界面隐藏
--=========================================================
function PetSoul_QQSkill_OnHiden()

	PetSoul_QQSkill_Clear() 
	PushEvent("CLOSE_COMFIRM_QQSKILL")
	StopCareObject_PetSoul_QQSkill()
	this:Hide()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_PetSoul_QQSkill()

	this:CareObject(g_CaredNpc, 1, "PetSoul_QQSkill")
	return

end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_PetSoul_QQSkill()
	this:CareObject(g_CaredNpc, 0, "PetSoul_QQSkill")
	g_CaredNpc = -1
	return
end
 

function PetSoul_QQSkill_Frame_On_ResetPos()
  	PetSoul_QQSkill_Frame:SetProperty("UnifiedPosition", g_PetSoul_QQSkill_Frame_UnifiedPosition);
end

function PetSoul_QQSkill_CheckButtonClicked( idx )

	--坑里是否有道具
	if g_QBagIndex < 0 or g_SBagIndex < 0 then
		g_CheckButton[idx]:SetCheck(0)
		return
	end

	local finalstr = ""
	for i = 1, 2 do
		if i == idx then
			g_CheckButton[i]:SetCheck(1)
		else
			g_CheckButton[i]:SetCheck(0)
		end
	end
	
	if idx == 1 then
		finalstr = "#cfff263"..g_QiongQiDesc1.."\n"..g_ShenDesc1.."\n"..g_ShenDesc2
		g_SelectButton = 2
	elseif idx == 2 then
		finalstr = "#cfff263"..g_QiongQiDesc2.."\n"..g_ShenDesc1.."\n"..g_ShenDesc2
		g_SelectButton = 1
	end

	PetSoul_QQSkill_AfterAttrFirst:SetText(finalstr)

	PetSoul_QQSkill_Money:SetProperty("MoneyNumber", tostring(500000))
end

function PetSoul_QQSkill_Help()
	PushEvent("CCSHOP_HELP", 5)
end

function PetSoul_QQSkill_CancelQQItem()
	if g_QBagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_QBagIndex,0);
	end
	PetSoul_QQSkill_AfterAttrFirst:SetText("")
	PetSoul_QQSkill_BeforeIcon:SetActionItem(-1)
	PetSoul_QQSkill_SelectQQ1:SetCheck(0)
	PetSoul_QQSkill_SelectQQ2:SetCheck(0)
	PetSoul_QQSkill_QQ_1:SetText("")
	PetSoul_QQSkill_QQ_2:SetText("")
	PetSoul_QQSkill_SelectQQ1:Hide()
	PetSoul_QQSkill_SelectQQ2:Hide()
	g_QBagIndex = -1
	g_QiongQiDesc1 = ""
	g_QiongQiDesc2 = ""

	if g_SBagIndex >= 0 then
		local szSkill1, szSkill2 = Pet:LuaFnGetPetSoulData(g_SBagIndex, "POSSSKILL")
		if szSkill1 ~= nil and szSkill2 ~= nil then
			PetSoul_QQSkill_SS2:SetText("#cfff263"..szSkill1.."\n"..szSkill2)
			g_ShenDesc1 = szSkill1
			g_ShenDesc2 = szSkill2
		end
	end
end

function PetSoul_QQSkill_CancelSItem()
	if g_SBagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_SBagIndex,0);
	end
	PetSoul_QQSkill_AfterAttrFirst:SetText("")
	PetSoul_QQSkill_AfterIcon:SetActionItem(-1)
	PetSoul_QQSkill_SelectQQ1:SetCheck(0)
	PetSoul_QQSkill_SelectQQ2:SetCheck(0)
	PetSoul_QQSkill_SS2:SetText("")
	g_SBagIndex = -1
	g_ShenDesc1 = ""
	g_ShenDesc2 = ""

end