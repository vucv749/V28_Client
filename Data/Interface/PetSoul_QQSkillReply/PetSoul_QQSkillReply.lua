--qiongqi reply
local g_PetSoul_QQSkillReply_Frame_UnifiedPosition;
local g_BagIndex = -1
local g_TargetId = -1;
local g_CaredNpc = -1;
local MAX_OBJ_DISTANCE = 3.0
function PetSoul_QQSkillReply_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_QIONGQI_REPLY", false);
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OBJECT_CARED_EVENT" ,false)

end

function PetSoul_QQSkillReply_OnLoad()

	g_PetSoul_QQSkillReply_Frame_UnifiedPosition = PetSoul_QQSkillReply_Frame:GetProperty("UnifiedPosition");
	
end

-- OnEvent
function PetSoul_QQSkillReply_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99852203 ) then 

		g_TargetId = Get_XParam_INT(0);
		g_CaredNpc = DataPool : GetNPCIDByServerID(g_TargetId);
		AxTrace(0,1,"g_TargetId="..g_TargetId .. " g_CaredNpc="..g_CaredNpc)
		if g_CaredNpc == -1 then
			PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
			return;
		end
		BeginCareObject_PetSoul_QQSkillReply()
		PetSoul_QQSkillReply_OnShow()
	
	elseif ( event == "UPDATE_QIONGQI_REPLY" ) then
		if g_BagIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_BagIndex,0);
		end
		g_BagIndex = tonumber(arg0)
		if g_BagIndex == nil or g_BagIndex < 0 then
			return
		end
		LifeAbility:Lock_Packet_Item(g_BagIndex,1);
		local theAction = EnumAction(g_BagIndex, "packageitem")
		if theAction:GetID() ~= 0 then
			if Pet:LuaFnIsPetSoul(g_BagIndex) ~= 1 then
				PushDebugMessage("#{QQJG_20230815_10}")
				return
			end
			PetSoul_QQSkillReply_Icon1:SetActionItem(theAction:GetID());
		end

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		PetSoul_QQSkillReply_OnHiden()

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_QQSkillReply_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_QQSkillReply_ResetPos()

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			PetSoul_QQSkillReply_OnHiden()
		end
	end
end

function BeginCareObject_PetSoul_QQSkillReply()

	this:CareObject(g_CaredNpc, 1, "PetSoul_QQSkillReply")
	return

end

function StopCareObject_PetSoul_QQSkillReply()
	this:CareObject(g_CaredNpc, 0, "PetSoul_QQSkillReply")
	g_CaredNpc = -1
	return
end
 

function PetSoul_QQSkillReply_OnShow()
	if g_BagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BagIndex,0);
	end
	PetSoul_QQSkillReply_Icon1:SetActionItem(-1)
	g_BagIndex = -1
	this:Show()
end

function PetSoul_QQSkillReply_Buttons_Clicked()
	
	if g_BagIndex < 0 then
		PushDebugMessage("#{QQJG_20230815_34}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Restore")
		Set_XSCRIPT_ScriptID(998522)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, g_BagIndex)
		Set_XSCRIPT_Parameter(2, 0)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()	
	
end

function PetSoul_QQSkillReply_Resume()
	if g_BagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BagIndex,0);
	end
	PetSoul_QQSkillReply_Icon1:SetActionItem(-1)
	g_BagIndex = -1
	
end

function PetSoul_QQSkillReply_OnHiden()
	if g_BagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BagIndex,0);
	end
	StopCareObject_PetSoul_QQSkillReply()
	PetSoul_QQSkillReply_Icon1:SetActionItem(-1)
	g_BagIndex = -1
	PushEvent("CLOSE_COMFIRM_QQSKILL")
	this:Hide()
	
end

function PetSoul_QQSkillReply_ResetPos()

  PetSoul_QQSkillReply_Frame:SetProperty("UnifiedPosition", g_PetSoul_QQSkillReply_Frame_UnifiedPosition);
  
end

