--盟会材料转化

local g_ShenFen_CaiLiaoZhuanHua_UnifiedPosition

local g_ShenFen_CaiLiaoZhuanHua_BagIndex={-1,-1,-1}
local g_ShenFen_CaiLiaoZhuanHua_ItemIndex={-1,-1,-1}
local g_ShenFen_CaiLiaoQual={-1,-1,-1}
local g_ShenFen_CaiLiaoZhuanHua_Ctrl={}

local g_ShenFen_CaiLiaoZhuanHuaComboQual=-1
local g_ShenFen_CaiLiaoZhuanHua_targetId = -1
local g_Object = -1
local g_ShenFen_CaiLiaoZhuanHua_CommonPiece =
{
	21000000,
	21000001,
	21000002,
	21000003,
	21000004,
	21000005,
	21000006,
	21000007,
	21000008,
	21000009,
	21000010,
	21000011,
	21000016,
	21000017,
	21000018,
	21000019,
}
local g_ShenFen_CaiLiaoZhuanHua_Quality =
{
	[21000000] = 1,
	[21000001] = 2,
	[21000002] = 3,
	[21000003] = 4,
	[21000004] = 1,
	[21000005] = 2,
	[21000006] = 3,
	[21000007] = 4,
	[21000008] = 1,
	[21000009] = 2,
	[21000010] = 3,
	[21000011] = 4,
	[21000016] = 1,
	[21000017] = 2,
	[21000018] = 3,
	[21000019] = 4,
}

local g_ShenFen_CaiLiaoZhuanHua_Qual_Dest=
{
	[1] = {
		[1] ="粳稻",
		[2] ="香蒲",
		[3] ="青铜",
		[4] ="桦枝",
	},
	[2] = {
		[1] ="茭白",
		[2] ="芝兰",
		[3] ="玄铁",
		[4] ="霜竹",
	},
	[3] = {
		[1] ="盈月笋",
		[2] ="血茯苓",
		[3] ="锻月银",
		[4] ="贞云松",
	},
	[4] = {
		[1] ="流华松露",
		[2] ="彼岸灵花",
		[3] ="霄华鎏金",
		[4] ="怀雅檀木",
	},
}

function ShenFen_CaiLiaoZhuanHua_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("MENGHUI_ZHUANHUA_UPDATE")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变需要判断
end

function ShenFen_CaiLiaoZhuanHua_OnLoad()
	g_ShenFen_CaiLiaoZhuanHua_UnifiedPosition=ShenFen_CaiLiaoZhuanHua_Frame:GetProperty("UnifiedPosition")
	g_ShenFen_CaiLiaoZhuanHua_Ctrl[1] = ShenFen_CaiLiaoZhuanHua_Icon1
	g_ShenFen_CaiLiaoZhuanHua_Ctrl[2] = ShenFen_CaiLiaoZhuanHua_Icon2
	g_ShenFen_CaiLiaoZhuanHua_Ctrl[3] = ShenFen_CaiLiaoZhuanHua_Icon3
end

function ShenFen_CaiLiaoZhuanHua_On_ResetPos()
	ShenFen_CaiLiaoZhuanHua_Frame:SetProperty("UnifiedPosition", g_ShenFen_CaiLiaoZhuanHua_UnifiedPosition)
  end

function ShenFen_CaiLiaoZhuanHua_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2024040301 ) then
		
		g_ShenFen_CaiLiaoZhuanHua_targetId = Get_XParam_INT(0)
		if tonumber(g_ShenFen_CaiLiaoZhuanHua_targetId) == -1 then
			return
		end
	
		local objCared = DataPool : GetNPCIDByServerID(g_ShenFen_CaiLiaoZhuanHua_targetId);
		if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
			return
		end
		this:Show()
		ShenFen_CaiLiaoZhuanHua_BeginCareObject(objCared)
	elseif event == "MENGHUI_ZHUANHUA_UPDATE" and this:IsVisible() then
		if arg0 ~= nil and arg1 ~= nil then
			ShenFen_CaiLiaoZhuanHua_Update( tonumber(arg0), tonumber(arg1), 0)
		end
	elseif event == "ADJEST_UI_POS" then
		ShenFen_CaiLiaoZhuanHua_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		ShenFen_CaiLiaoZhuanHua_On_ResetPos()
		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		ShenFen_CaiLiaoZhuanHua_Update( 0, g_ShenFen_CaiLiaoZhuanHua_BagIndex[1], 1 )
		ShenFen_CaiLiaoZhuanHua_Update( 1, g_ShenFen_CaiLiaoZhuanHua_BagIndex[2], 1 )
		ShenFen_CaiLiaoZhuanHua_Update( 2, g_ShenFen_CaiLiaoZhuanHua_BagIndex[3], 1 )
	end

end

function ShenFen_CaiLiaoZhuanHua_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "ShenFen_CaiLiaoZhuanHua");
end

function ShenFen_CaiLiaoZhuanHua_IsCommonPiece(nItemTableIndex)
	local nCount=table.getn(g_ShenFen_CaiLiaoZhuanHua_CommonPiece)

	for i=1,nCount do
		if nItemTableIndex == g_ShenFen_CaiLiaoZhuanHua_CommonPiece[i] then
			return 1
		end
	end
	return 0
end

function ShenFen_CaiLiaoZhuanHua_Update(uiPos, bagPos, bItemChanged)
	-- PushDebugMessage("uiPos:"..tostring(uiPos))
	if bItemChanged == nil then
		bItemChanged = 0;
	end
	if uiPos == -1 then
		if g_ShenFen_CaiLiaoZhuanHua_BagIndex[1] < 0 then
			uiPos = 0
		elseif g_ShenFen_CaiLiaoZhuanHua_BagIndex[2] < 0 then
			uiPos = 1
		elseif g_ShenFen_CaiLiaoZhuanHua_BagIndex[3] < 0 then
			uiPos = 2
		else
			uiPos = 0
		end
	end
	uiPos = uiPos + 1
	local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos)
	local nItemCount = PlayerPackage:GetBagItemNum(bagPos)

	if bItemChanged > 0 and g_ShenFen_CaiLiaoZhuanHua_ItemIndex[uiPos] ~= nItemIndex then
		ShenFen_CaiLiaoZhuanHua_Resume( uiPos )
		return
	end
	if nItemIndex == nil or nItemCount == nil or nItemCount<=0 then

		return
	end
	
	-- 仅可放入盟会材料
	if ShenFen_CaiLiaoZhuanHua_IsCommonPiece(nItemIndex) <= 0 or g_ShenFen_CaiLiaoZhuanHua_Quality[nItemIndex] == nil then
		PushDebugMessage("#{SZSW_230402_22}")
		return
	end
	
	

	-- 只能放入同等级盟会材料
	local defaultQuality = g_ShenFen_CaiLiaoZhuanHua_Quality[nItemIndex]
	for i=1,3 do
		if g_ShenFen_CaiLiaoZhuanHua_BagIndex[i] >= 0 and g_ShenFen_CaiLiaoQual[i] ~= defaultQuality then
			PushDebugMessage("#{SZSW_230402_23}")
			return
		end
	end

	--检查是否加锁
	if PlayerPackage:IsLock( bagPos ) == 1 then
		PushDebugMessage("#{SZSW_230402_24}")	--道具已上锁
		return
	end

	ShenFen_CaiLiaoZhuanHua_Bindtip:Hide()

	if g_ShenFen_CaiLiaoZhuanHua_BagIndex[uiPos] ~= -1 then
		LifeAbility : Lock_Packet_Item(g_ShenFen_CaiLiaoZhuanHua_BagIndex[uiPos],0);
	end
		
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
	g_ShenFen_CaiLiaoZhuanHua_Ctrl[uiPos]:SetActionItem(theAction:GetID());
	LifeAbility : Lock_Packet_Item(bagPos,1);
	g_ShenFen_CaiLiaoZhuanHua_BagIndex[uiPos] = bagPos
	g_ShenFen_CaiLiaoZhuanHua_ItemIndex[uiPos] = nItemIndex 
	if g_ShenFen_CaiLiaoZhuanHua_Quality[nItemIndex] ~= nil then
		g_ShenFen_CaiLiaoQual[uiPos] = g_ShenFen_CaiLiaoZhuanHua_Quality[nItemIndex]
	end 

	ShenFen_CaiLiaoZhuanHua_RefreshCombo()
end

function ShenFen_CaiLiaoZhuanHua_RefreshCombo()

	local nTempQual = -1
	for i=1,3 do
		if g_ShenFen_CaiLiaoQual[i] >= 0 then
			nTempQual = g_ShenFen_CaiLiaoQual[i]
		end
	end
	if nTempQual == -1 then
		ShenFen_CaiLiaoZhuanHua_Bindtip:Show()
	end

	if g_ShenFen_CaiLiaoZhuanHuaComboQual ~= nTempQual then
		ShenFen_CaiLiaoZhuanHua_Bind:SetText("")
		ShenFen_CaiLiaoZhuanHua_Bind:ResetList()
	
		g_ShenFen_CaiLiaoZhuanHuaComboQual = nTempQual
		
		local nDestTable = g_ShenFen_CaiLiaoZhuanHua_Qual_Dest[nTempQual]
		if nDestTable == nil then
			return
		end
	
		for i=1, table.getn(nDestTable) do
			ShenFen_CaiLiaoZhuanHua_Bind:ComboBoxAddItem(nDestTable[i], i)
		end
		
	end

end

--下拉列表发生变化的回调
function ShenFen_CaiLiaoZhuanHua_DstChanged()
	ShenFen_CaiLiaoZhuanHua_RefreshCombo()
end


function ShenFen_CaiLiaoZhuanHua_Resume(index)
	if g_ShenFen_CaiLiaoZhuanHua_Ctrl[index] == nil then
		return
	end
	
	if g_ShenFen_CaiLiaoZhuanHua_BagIndex[index] ~= nil and
	g_ShenFen_CaiLiaoZhuanHua_BagIndex[index] >= 0 then
		LifeAbility : Lock_Packet_Item(g_ShenFen_CaiLiaoZhuanHua_BagIndex[index],0)
		g_ShenFen_CaiLiaoZhuanHua_Ctrl[index]:SetActionItem(-1)
		g_ShenFen_CaiLiaoZhuanHua_BagIndex[index] = -1
		g_ShenFen_CaiLiaoZhuanHua_ItemIndex[index] = -1
		g_ShenFen_CaiLiaoQual[index] = -1
		
	end
	
	ShenFen_CaiLiaoZhuanHua_RefreshCombo()
end

function ShenFen_CaiLiaoZhuanHua_Confirm_Clicked()
	--二级密码 电话密保检查
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	
	local nSelName, nSelID = ShenFen_CaiLiaoZhuanHua_Bind:GetCurrentSelect();
	if nSelID <= 0 then
		PushDebugMessage("#{SZSW_230402_30}")
		return
	end
		
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 998783 )
		Set_XSCRIPT_Function_Name( "OnCaiLiaoZhuanHua" )
		Set_XSCRIPT_Parameter(0, g_ShenFen_CaiLiaoZhuanHua_targetId)
		Set_XSCRIPT_Parameter(1, g_ShenFen_CaiLiaoZhuanHua_BagIndex[1])
		Set_XSCRIPT_Parameter(2, g_ShenFen_CaiLiaoZhuanHua_BagIndex[2])
		Set_XSCRIPT_Parameter(3, g_ShenFen_CaiLiaoZhuanHua_BagIndex[3])
		Set_XSCRIPT_Parameter(4, nSelID)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()

end

function ShenFen_CaiLiaoZhuanHua_Bindtip_Click()
	PushDebugMessage("#{SZSW_230402_29}")
end

function ShenFen_CaiLiaoZhuanHua_OnHiden()
	this:CareObject(tonumber(g_Object), 0, "ShenFen_CaiLiaoZhuanHua")
	g_Object = -1
	for i=1,3 do
		ShenFen_CaiLiaoZhuanHua_Resume(i)
	end
	
end