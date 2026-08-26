
local g_Item_DJS_Confirm_FrameInfo = -1;
local g_Item_DJS_Confirm_Frame_UnifiedPosition;

local FrameInfoList =
{
	DJTS_CONFIRM_SETPOS = 265,						--	确认彻地符箓重新定位	
	DJTS_CONFIRM_CHUANSONG = 267,					--	确认彻地符箓传送	
	DJTS_CONFIRM_BUCHONG = 269,						--	确认彻地符箓补充符咒	
		
	DJTS_CONFIRM_BUCHONG_ITEM_BIND = 272,		--用绑定道具增加彻地符箓的符咒
	
	DJTS_CONFIRM_BUCHONG_YUANBAO_BIND = 273,		--用绑定元宝增加彻地符箓的符咒
	DJTS_CONFIRM_BUCHONG_YUANBAO = 274,				--用元宝增加彻地符箓的符咒
};

local Client_ItemIndex = -1
local CDFL_SelIndex = -1
local g_Item_DJS_msgFrameVar = {}

function Item_DJS_Confirm_CancelLastOp(str)

	if(this:IsVisible() and str ~= g_Item_DJS_Confirm_FrameInfo) then
		this:Hide()
	end
	
end

--===============================================
-- OnLoad()
--===============================================
function Item_DJS_Confirm_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--离开游戏
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);

	--彻地符箓定位确认
	this:RegisterEvent( "CONFIRM_SETPOS_CDFL" );	
	--彻地符箓传送确认
	this:RegisterEvent( "CONFIRM_CHUANSONG_CDFL" );	
	--彻地符箓补充符咒确认
	this:RegisterEvent( "CONFIRM_BUCHONG_CDFL" );
	
	this:RegisterEvent( "UI_COMMAND" );

end

--===============================================
-- OnLoad()
--===============================================
function Item_DJS_Confirm_OnLoad()

	g_Item_DJS_Confirm_Frame_UnifiedPosition = Item_DJS_Confirm_Frame:GetProperty("UnifiedPosition");
  
end

function  Item_DJS_Confirm_UpdateRect()

	local nWidth, nHeight = Item_DJS_Confirm_Info:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	
end

--===============================================
-- OnEvent()
--===============================================
function Item_DJS_Confirm_OnEvent(event)

	if (event == "CONFIRM_SETPOS_CDFL") then
	
		--Item_DJS_Confirm_Title:SetText("#{DJTS_110509_01}")--彻地符箓
		Item_DJS_Confirm_Title:SetProperty("Image","set:Fulu_1 image:DunJiaShu_Title_Index")	--彻地符箓
		
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iSceneId = tonumber(arg2);
		local iPosX = tonumber(arg3);
		local iPosZ = tonumber(arg4);
		local iSelIdx = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_SETPOS)

		g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_SETPOS

		Client_ItemIndex = itemIdx
		CDFL_SelIndex = iSelIdx

		local curSceneName = GetCurrentSceneName()
		local curPosX, curPosZ, _ = Target:GetMyPos()
		curPosX = math.floor(curPosX)
		curPosZ = math.floor(curPosZ)

		local str = "#{DJTS_110509_12}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#r".."#{DJTS_110509_13}"..curSceneName.."（"..curPosX.."，"..curPosZ.."）"

		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str);
			Item_DJS_Confirm_UpdateRect();
			this:Show();
			return
		else
			Item_DJS_Confirm_Queding_Clicked()
			this:Hide()
			return
		end

	end

	if(event == "CONFIRM_CHUANSONG_CDFL") then
	
		--Item_DJS_Confirm_Title:SetText("#{DJTS_110509_01}")--彻地符箓
		Item_DJS_Confirm_Title:SetProperty("Image","set:Fulu_1 image:DunJiaShu_Title_Index")	--彻地符箓
			
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iSceneId = tonumber(arg2);
		local iPosX = tonumber(arg3);
		local iPosZ = tonumber(arg4);
		local iSelIdx = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_CHUANSONG);
		g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_CHUANSONG;

		Client_ItemIndex = itemIdx
		CDFL_SelIndex = iSelIdx

		local str = "#{DJTS_110509_14}".."\n"..szSceneName.."（"..iPosX.."，"..iPosZ.."）";
		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str)
			Item_DJS_Confirm_UpdateRect();
			this:Show();
			return
		else
		   PushDebugMessage("#{DJTS_110509_31}")
		   this:Hide()
		   return
		end
	end

	if(event == "CONFIRM_BUCHONG_CDFL") then
	
		--Item_DJS_Confirm_Title:SetText("#{DJTS_110509_01}") --彻地符箓
		Item_DJS_Confirm_Title:SetProperty("Image","set:Fulu_1 image:DunJiaShu_Title_Index")	--彻地符箓
			
		local itemIdx = tonumber(arg0)
		local iNum = tonumber(arg1);
    		
		Client_ItemIndex = itemIdx

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG);
		g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG;

		local str;
		if (iNum > 40) then
			str= "#{DJTS_110509_11}"
		else
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("AddFuZhou");
				Set_XSCRIPT_ScriptID(893252);
				Set_XSCRIPT_Parameter(0, Client_ItemIndex)
				Set_XSCRIPT_Parameter(1, 1)
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
			return
		end

		Item_DJS_Confirm_Info:SetText(str)
		Item_DJS_Confirm_UpdateRect();
		this:Show()
		return
	end

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		Item_DJS_Confirm_Frame_On_ResetPos()
		return
	end

	if event == "HIDE_ON_SCENE_TRANSED"  then		
		this:Hide() 
	end
	
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20141106 then
					
			--Item_DJS_Confirm_Title:SetText("#{DJTS_110509_01}") --彻地符箓
			Item_DJS_Confirm_Title:SetProperty("Image","set:Fulu_1 image:DunJiaShu_Title_Index")	--彻地符箓

			local str
			g_Item_DJS_msgFrameVar[1] = Get_XParam_INT(0)
			Client_ItemIndex = Get_XParam_INT(1)
			
			if g_Item_DJS_msgFrameVar[1] == 1 then
				Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO_BIND)
				g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO_BIND
				str = "#{WPKC_141107_06}"
			elseif g_Item_DJS_msgFrameVar[1] == 2 then
				Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO)
				g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO
				g_Item_DJS_msgFrameVar[2] = Get_XParam_INT(2)
				g_Item_DJS_msgFrameVar[3] = Get_XParam_INT(3)
				str = ScriptGlobal_Format("#{WPKC_141107_08}", g_Item_DJS_msgFrameVar[2], g_Item_DJS_msgFrameVar[3])
			elseif g_Item_DJS_msgFrameVar[1] == 3 then
				Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG_ITEM_BIND)
				g_Item_DJS_Confirm_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG_ITEM_BIND
				str = "#{DJTS_110509_52}"
			end
			
			Item_DJS_Confirm_Info:SetText(str)
			Item_DJS_Confirm_UpdateRect();
			this:Show()
			
			return
		end
	end
	
end

--===============================================
-- 点击确定（IDOK）
--===============================================
function Item_DJS_Confirm_Queding_Clicked()

	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, CDFL_SelIndex)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end

	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_CHUANSONG) then

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetUISelIdx");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, CDFL_SelIndex)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();

		PlayerPackage:UseItem(Client_ItemIndex)	--彻地符箓的默认使用逻辑为传送....

	end
	
	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_BUCHONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AddFuZhou");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	
	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_BUCHONG_ITEM_BIND) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AddFuZhou");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end

	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO_BIND) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("YuanbaoBind_AddFuZhou");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end

	if (g_Item_DJS_Confirm_FrameInfo == FrameInfoList.DJTS_CONFIRM_BUCHONG_YUANBAO) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Yuanbao_AddFuZhou");
			Set_XSCRIPT_ScriptID(893252);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end

	this:Hide();
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Item_DJS_Confirm_Frame_On_ResetPos()

  Item_DJS_Confirm_Frame:SetProperty("UnifiedPosition", g_Item_DJS_Confirm_Frame_UnifiedPosition);
  
end


