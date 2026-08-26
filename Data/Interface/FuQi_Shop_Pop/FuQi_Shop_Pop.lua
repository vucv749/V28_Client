-- fuqishop double check

local FuQi_Shop_Pop_UnifiedPosition = nil
-- 关注NPC
local FuQi_Shop_Pop_CareObjId = -1
local FuQi_Shop_Pop_CareObjSvrId = -1
local FuQi_Shop_Pop_MAX_OBJ_DISTANCE = 5.0

-- 当前激活UI的游戏类型
local FuQi_Shop_Pop_CurGameType = 0
-- 逻辑已处理标记
local FuQi_Shop_Pop_DealFlag = 0
-- 临时数据
local FuQi_Shop_Pop_Data = {0, 0, 0, 0}

-- 游戏类型
local FuQi_Shop_Pop_GameType =
{
    fuqishop_confirm = 1,--fuqishop
} -- end FuQi_Shop_Pop_GameType



function FuQi_Shop_Pop_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
    this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
    this:RegisterEvent("FUQISHOP_CONFIRM_HIDE",false)
end -- end func FuQi_Shop_Pop_PreLoad()

function FuQi_Shop_Pop_OnEvent(event)
    if (event == "UI_COMMAND") then
        FuQi_Shop_Pop_DealUICommand(tonumber(arg0))
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        if (this:IsVisible()) then
            FuQi_Shop_Pop_Cancel_Clicked(0)
            FuQi_Shop_Pop_Frame_OnHiden()
        end
    elseif (event == "OBJECT_CARED_EVENT") then
        if(FuQi_Shop_Pop_CareObjId < 0 or tonumber(arg0) ~= FuQi_Shop_Pop_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            FuQi_Shop_Pop_Frame_OnHiden()
        end
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        FuQi_Shop_Pop_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        FuQi_Shop_Pop_UnifiedPos()
    elseif (event == "FUQISHOP_CONFIRM_HIDE") then
        FuQi_Shop_Pop_Frame_OnHiden()
	end
end -- end func FuQi_Shop_Pop_OnEvent()

function FuQi_Shop_Pop_OnLoad()
	FuQi_Shop_Pop_UnifiedPosition = FuQi_Shop_Pop_Frame:GetProperty("UnifiedPosition")
end -- end func FuQi_Shop_Pop_OnLoad()

function FuQi_Shop_Pop_UnifiedPos()
    if (FuQi_Shop_Pop_UnifiedPosition ~= nil) then
	   FuQi_Shop_Pop_Frame:SetProperty("UnifiedPosition", FuQi_Shop_Pop_UnifiedPosition)
	end
end -- end func FuQi_Shop_Pop_UnifiedPos()

function FuQi_Shop_Pop_Show(objId)
    if (this:IsVisible()) then
        return
    end

    if (objId ~= nil and objId > 0) then
        FuQi_Shop_Pop_BeginCareObject(objId)
    end

    this:Show()
end -- end func FuQi_Shop_Pop_Show()

function FuQi_Shop_Pop_Frame_OnHiden()
    if (this:IsVisible()) then
        this:Hide()
    end
end -- end func FuQi_Shop_Pop_Frame_OnHiden()

-- 开启NPC关注
function FuQi_Shop_Pop_BeginCareObject(objSvrId)
	FuQi_Shop_Pop_CareObjId = DataPool:GetNPCIDByServerID(objSvrId)
    if (FuQi_Shop_Pop_CareObjId >= 0) then
        FuQi_Shop_Pop_CareObjSvrId = objSvrId
        FuQi_Shop_Pop_TargetNPC = objSvrId
		this:CareObject(FuQi_Shop_Pop_CareObjId, 1, "FuQi_Shop_Pop")
	end
end -- end func FuQi_Shop_Pop_BeginCareObject()

-- 取消NPC关注
function FuQi_Shop_Pop_StopCareObject()
	if (FuQi_Shop_Pop_CareObjId >= 0) then
		this:CareObject(FuQi_Shop_Pop_CareObjId, 0, "FuQi_Shop_Pop")
		FuQi_Shop_Pop_CareObjId = -1
		FuQi_Shop_Pop_CareObjSvrId = -1
	end
end -- end func FuQi_Shop_Pop_StopCareObject()

-- 确定按钮事件
function FuQi_Shop_Pop_OK_Clicked()

    if FuQi_Shop_Pop_CurGameType == FuQi_Shop_Pop_GameType.fuqishop_confirm then
        Clear_XSCRIPT();
            Set_XSCRIPT_Function_Name("BuyItem")
            Set_XSCRIPT_ScriptID(998337)
            Set_XSCRIPT_Parameter(0, FuQi_Shop_Pop_Data[1]);         
            Set_XSCRIPT_Parameter(1, FuQi_Shop_Pop_Data[2]);
            Set_XSCRIPT_Parameter(2, 1);
            Set_XSCRIPT_ParamCount(3)
        Send_XSCRIPT();
    end

    FuQi_Shop_Pop_Frame_OnHiden()
end -- end func FuQi_Shop_Pop_OK_Clicked()

-- 取消、关睜按钮事件
function FuQi_Shop_Pop_Cancel_Clicked(arg)

    FuQi_Shop_Pop_StopCareObject()
    if (arg > 0) then
        FuQi_Shop_Pop_Frame_OnHiden()
    end
end -- end func FuQi_Shop_Pop_Cancel_Clicked()

function FuQi_Shop_Pop_DealUICommand(cmdIndex)
    for i=1, 4, 1 do
        FuQi_Shop_Pop_Data[i] = 0
    end -- end for

    if (cmdIndex == 99833702) then
        FuQi_Shop_Pop_Data[1] = Get_XParam_INT(0)
        FuQi_Shop_Pop_Data[2] = Get_XParam_INT(1)
        FuQi_Shop_Pop_Data[3] = Get_XParam_INT(2)
        FuQi_Shop_Pop_CurGameType = FuQi_Shop_Pop_GameType.fuqishop_confirm

        FuQi_Shop_Pop_DragTitle:SetText("#{FQSD_230328_39}")
        local msg = ScriptGlobal_Format("#{FQSD_230328_30}", DataPool:LuaFnGetItemNameByTableIndex(FuQi_Shop_Pop_Data[2]),FuQi_Shop_Pop_Data[3])
        FuQi_Shop_Pop_Text:SetText(msg)
        FuQi_Shop_Pop_Show(-1)
    end

end -- end func FuQi_Shop_Pop_DealUICommand()
