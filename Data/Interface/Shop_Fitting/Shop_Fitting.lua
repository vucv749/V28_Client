local g_ItemMax = 0;
local g_ItemIdx = -1;

local CU_MONEY			= 1	-- 钱

local objCared = -1;

local g_CameraHeight = 1;     --摄影机高度
local g_CameraDistance = 2;   --摄影机距离
local g_CameraPitch = 3;      --摄影机角度

-- 需要为一些在坐骑上的试穿效果单独设置摄像机位置

local g_MountXueYuID = 39;	--座骑雪羽的id
local g_MountMingYuID = 44;	--座骑冥羽的id
local g_MountHuanYuID = 62;	--座骑幻羽的id
local g_MountJuYuanID = 52;	--座骑巨猿的id
local g_MountDaFengID = 41; --座骑大风的id
local g_MountYunXiaoID = 80; --云霄羽翼的id

--鹤，金翼鹤，瑞莲鹤
local g_MountWuDang = {5,14,55}
--雕，白雕，鹜影雕
local g_MountTianShan = {3,12,53}
--青凤，红白凤，琉璃凤
local g_MountEMei = {6,15,54}
-- 秦始皇马车 六合舆
local g_MountQSHMC = 86
-- 兵马俑马 蹑景
local g_MountBMYM = 85
--赤魅鹰,暗魅鹰,紫魅鹰
local g_MountAFanDa = {73,74,75}

-- 垂云翼
local g_MountCYY = 91

-- 清客摇
local g_MountQKY = 93

-- 银汉浮梁
local g_MountYHFL = 97

-- 情人节坐骑
local g_MountQRJ = {126, 127}

-- 争霸赛坐骑
local g_MountZBSJY = 105
local g_MountZBSQY = 107
local g_MountZBSBS = 109

-- 2021.03.10 经典时装染色移植
local g_Shop_Fitting_CurDressID=0
-- 染色风格最大数量, 这个先写死吧，经典这么多年没变过
local g_Shop_Fitting_DressNum = 9
--2021.03.10 经典时装染色移植 end
local g_Shop_Fitting_Frame_UnifiedPosition;

--新增需要调整的坐骑，在这个里列表里添加
local g_MountNeedAdjustCamera = {
	[1] = {mountId = 195, distance = 15, height = 4},
	[2] = {mountId = 196, distance = 15, height = 4},
	[3] = {mountId = 197, distance = 15, height = 4},
	[4] = {mountId = 198, distance = 15, height = 4},
	[5] = {mountId = 199, distance = 15, height = 3},
	[6] = {mountId = 203, distance = 16, height = 5.5},
	[7] = {mountId = 204, distance = 16, height = 5.5},
	[8] = {mountId = 211, distance = 22, height = 3},
}

--!!!reloadscript =Shop_Fitting
function Shop_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("CLOSE_SHOP_FITTING");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");

	-- FakeObject模型界面互斥
	this:RegisterEvent("OPEN_EQUIP");										-- 角色资料界面
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");			-- 时装染色试衣间
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");		-- 时装镶嵌试衣间
	
	this:RegisterEvent("YIGUI_OPEN",false);				-- 衣柜
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OPEN_DRESSPREVIEW")
	
end

function Shop_Fitting_OnLoad()
g_Shop_Fitting_Frame_UnifiedPosition= Shop_Fitting_Frame:GetProperty("UnifiedPosition");
end


function ShopFitting_OnHiden()
	SetDefaultMouse();
	RestoreShopFitting();
	this:Hide();
end

function Shop_Fitting_OnEvent(event)

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Shop_Fitting_Booth_Close();
	end

	-- FakeObject模型界面互斥
	if ( event == "OPEN_EQUIP" ) or												-- 角色资料界面
		 ( event == "OPEN_DRESS_PAINT_FITTING" ) or					-- 时装染色试衣间
		 ( event == "OPEN_DRESS_ENCHASE_FITTING" ) or	-- 时装镶嵌试衣间
		 ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or --变性
		 ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or  -- 时装预览
		 ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) or 
		 ( event == "OPEN_DRESSPREVIEW") or 
		 ( event == "YIGUI_OPEN") then			
		if (this:IsVisible()) then
			RestoreShopFitting();
			this:Hide();
		end
	end

	if(event == "OPEN_SHOP_FITTING") then
		this:Show();
		
		PushEvent( "CLOSE_DRESSPREVIEW") 
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")
		
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "Shop_Fitting");
	
		Shop_Fitting_FakeObject:SetFakeObject("");	
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
		
		local nMountID = GetMountID();
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --翅膀的试骑比较特殊，单独设置摄像机的位置
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[1] or nMountID == g_MountWuDang[2]  then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[3] or nMountID == g_MountTianShan[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountTianShan[1] or nMountID == g_MountTianShan[2] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountEMei[1] or nMountID == g_MountEMei[2] or nMountID == g_MountEMei[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountDaFengID then     --大风坐骑
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountYunXiaoID then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--赤魅鹰,暗魅鹰,紫魅鹰
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,15);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountQSHMC then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
		elseif nMountID == g_MountBMYM then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountCYY then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountQKY then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,14);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 95 then	--翎月椅
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == 96 then	--雁门风华
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountYHFL then	--银汉浮梁
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,21);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 102 then	--寄居蟹
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 99 then	--鹄1
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 100 then	--鹄2
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 101 then	--鹄3
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 103 then	--昆仑雪猿
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountZBSJY then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,5);
		elseif nMountID == g_MountZBSQY then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountZBSBS then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == 116 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == 119 or nMountID == 120 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == 125 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,16);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == 133 or nMountID == 134 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,30);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountQRJ[1] or nMountID == g_MountQRJ[2] then	--情人节坐骑
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,16);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == 190 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,16);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end
		
		for i = 1, table.getn(g_MountNeedAdjustCamera) do
			if nMountID == g_MountNeedAdjustCamera[i].mountId then
				if g_MountNeedAdjustCamera[i].distance > 0 then
					FakeObj_SetCamera("EquipChange_Player", g_CameraDistance, g_MountNeedAdjustCamera[i].distance)
				end
				
				if g_MountNeedAdjustCamera[i].height > 0 then
					FakeObj_SetCamera("EquipChange_Player", g_CameraHeight, g_MountNeedAdjustCamera[i].height)
				end
			end
		end
		-- 刷新可能存在的时装样式
		Shop_Fitting_UpdateDressStyle(arg0)
	end
		
	if(event == "CLOSE_SHOP_FITTING") then
		RestoreShopFitting();
		this:Hide();
	end
		
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			RestoreShopFitting();
			this:CareObject(objCared, 0, "Shop_Fitting");
			this:Hide();			
		end
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
		Shop_Fitting_FakeObject : Hide();
		PushEvent( "CLOSE_DRESSPREVIEW") 
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")		
		
		Shop_Fitting_FakeObject : Show();
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");

		local nMountID = GetMountID();
		if g_MountXueYuID == nMountID or g_MountMingYuID == nMountID or g_MountHuanYuID == nMountID or g_MountJuYuanID == nMountID then   --翅膀的试骑比较特殊，单独设置摄像机的位置
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[1] or nMountID == g_MountWuDang[2]  then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountWuDang[3] or nMountID == g_MountTianShan[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountTianShan[1] or nMountID == g_MountTianShan[2] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountEMei[1] or nMountID == g_MountEMei[2] or nMountID == g_MountEMei[3] then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountDaFengID then     --大风坐骑
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountYunXiaoID then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountAFanDa[1] or nMountID == g_MountAFanDa[2] or nMountID == g_MountAFanDa[3] then
			--赤魅鹰,暗魅鹰,紫魅鹰
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,15);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == g_MountQSHMC then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
		elseif nMountID == g_MountBMYM then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountCYY then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,18);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID == g_MountZBSJY then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,5);
		elseif nMountID == g_MountZBSQY then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,4);
		elseif nMountID == g_MountZBSBS then	-- 争霸赛
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,23);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID == 116 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,22);
			FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,3);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end

	end
	
	if (event == "ADJEST_UI_POS" ) then
		Shop_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Shop_Fitting_Frame_On_ResetPos()
	end
		

end

function Shop_Fitting_Booth_Close()
	-- 值重置
	g_Shop_Fitting_CurDressID = 0
	--取消关心
	this:CareObject(objCared, 0, "Shop_Fitting");
	RestoreShopFitting();
	CloseShopFitting();
	this:Hide();
end


function Shop_Fitting_Accept_Clicked()

	this:Hide();
end

function Shop_Fitting_TextChanged()

	
end


----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function Shop_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function Shop_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

function Shop_Fitting_Frame_On_ResetPos()
  Shop_Fitting_Frame:SetProperty("UnifiedPosition", g_Shop_Fitting_Frame_UnifiedPosition);
end

-----------------------------------------------------------------------------
--2021.03.10 经典时装染色移植
function Shop_Fitting_UpdateComboList(itemindex)
	if itemindex <= 0 then
		Shop_Fitting_DressReset()
		return
	end
	-- 重复，直接返回
	--if g_Shop_Fitting_CurDressID == itemindex then
	--	-- 相同的进来也要初始化排序风格
	--	if DressReplaceColor:DressIsCanColour(itemindex) == 1 then
	--		DressReplaceColor :StoreDressByIndex(itemindex)
	--	end
	--	return
	--end

	g_Shop_Fitting_CurDressID=0

	Shop_Fitting_ALLChoice:ResetList()
	Shop_Fitting_ALLChoice:Show()
	Shop_Fitting_DressPrint:Show()

	if itemindex <= 0 then
		return
	end

	g_Shop_Fitting_CurDressID = itemindex

	if DressReplaceColor:DressIsCanColour(itemindex) == 1 then
		DressReplaceColor :StoreDressByIndex(itemindex)

		Shop_Fitting_ALLChoice:Enable()
		Shop_Fitting_ALLChoice:SetProperty("Visible", "True")
		Shop_Fitting_ALLChoice:AddTextItem("#{SZRSYH_210315_01}",1)
		--Shop_Fitting_ALLChoice_Pic:Hide()
		local cnt = g_Shop_Fitting_DressNum - 1
		for i=1 , cnt do
			local nVisual,ndesc,nRate = DressReplaceColor:GetDressDesc(i-1)
			if nVisual <= 0 then
				continue
			end

			local DressNames =""

			if nRate == 23000 then
				DressNames = ScriptGlobal_Format("#{SZRSYH_120912_07}", ndesc)
			elseif nRate == 14000 then
				DressNames = ScriptGlobal_Format("#{SZRSYH_120912_08}", ndesc)
			elseif nRate == 1000 then
				DressNames = ScriptGlobal_Format("#{SZRSYH_120912_09}", ndesc)
			elseif nRate == -1 then
				DressNames = ndesc
			end

			Shop_Fitting_ALLChoice:AddTextItem(DressNames,i+1)
		end
		Shop_Fitting_DressPrint:SetText("#{MZXB_200609_100}")
	else
		Shop_Fitting_ALLChoice:Disable()
		Shop_Fitting_ALLChoice:AddTextItem("#{MZXB_200609_101}",0)
		--Shop_Fitting_ALLChoice_Pic:Show()
		Shop_Fitting_DressPrint:SetText("#{MZXB_200609_100}")
	end
	Shop_Fitting_ALLChoice:SetCurrentSelect(0)
	Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player")
	Shop_Fitting_ComboList_Changed()
end

function Shop_Fitting_ComboList_Changed()

	if g_Shop_Fitting_CurDressID == 0 then
		return
	end

	local _, Index = Shop_Fitting_ALLChoice:GetCurrentSelect()

	if Index > g_Shop_Fitting_DressNum or Index < 1 then
		return
	end

	if Index == 1 then --默认风格
		Index = g_Shop_Fitting_DressNum
	else
		Index = Index -1
	end

	local nVisual,ndesc,nRate = DressReplaceColor:GetDressDesc(Index-1)
	if nVisual <= 0 then
		return
	end

	--DressReplaceColor : FittingOnDressByYuanBaoShop(g_Shop_Fitting_CurDressID,nVisual)
	DressReplaceColor:ShopFittingOnDress(g_Shop_Fitting_CurDressID,nVisual)
end

function Shop_Fitting_UpdateDressStyle(param)
	if param == nil then
		Shop_Fitting_DressReset()
	else
		Shop_Fitting_UpdateComboList(tonumber(param))
	end
end

function Shop_Fitting_DressReset()
	g_Shop_Fitting_CurDressID = 0
	Shop_Fitting_DressPrint:Hide()
	-- 下拉框箭头
	--Shop_Fitting_ALLChoice_Pic:Hide()
	-- 下拉框
	Shop_Fitting_ALLChoice:Hide()
end
-----------------------------------------------------------------------------
--2021.03.10 经典时装染色移植 end
----------------------------------------------------------------------------