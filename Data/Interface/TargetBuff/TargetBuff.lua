local TARGET_BUFF_MAX = 6;
local TARGET_IMPACT_CTL = {};

local TARGET_IMPACT_NUM = 30; --?????20???????????6?

function TargetBuff_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("MAINTARGET_OPEN");
	this:RegisterEvent("MAINTARGET_BUFF_REFRESH");
	this:RegisterEvent("CHANGE_DIYFRAME");
end

function TargetBuff_OnLoad()
	TARGET_IMPACT_CTL[1] = TargetBuff_Image1;
	TARGET_IMPACT_CTL[2] = TargetBuff_Image2;
	TARGET_IMPACT_CTL[3] = TargetBuff_Image3;
	TARGET_IMPACT_CTL[4] = TargetBuff_Image4;
	TARGET_IMPACT_CTL[5] = TargetBuff_Image5;
	TARGET_IMPACT_CTL[6] = TargetBuff_Image6;
end

function TargetBuff_OnEvent( event )

	if(0 == TargetBuff_IsTargetValid()) then
		TargetBuff_Clear();
		this:Hide();
		return;
	end

	--检测DIY头像，设置窗口位置
	local ct = Target:GetData("CHAR_TYPE");
	-- 不是玩家的角色
	if (ct == 0 or ct == 1) then
		-- 获取DIY头像的id
		local styleId = Target:GetData("DIYFRAME");
		if styleId > 0 then
			local posX, posY = Target : GetDIYFrameBuffPos(styleId);
			TargetBuff_Frame : SetProperty("UnifiedXPosition", posX);
			TargetBuff_Frame : SetProperty("UnifiedYPosition", posY);
		else
			ct = 2;
		end;
	end;
	if ct ~= 0 and ct ~= 1 then
		TargetBuff_Frame : SetProperty("UnifiedPosition", "{{0.0,278},{0.0,55}}");
	end;

	if (event == "CHANGE_DIYFRAME") then
		return;
	elseif(event == "MAINTARGET_OPEN") then
		--AxTrace(0,0,"event1:"..event);
		TargetBuff_Update();
		this:Show();
	elseif(event == "MAINTARGET_CHANGED") then
		if(-1 ~= tonumber(arg0)) then
			--AxTrace(0,0,"event2.1:"..event);
			TargetBuff_Update();
			this:Show();
		else
			--AxTrace(0,0,"event2.2:"..event);
			TargetBuff_Clear();
			this:Hide();
		end
	elseif(event == "MAINTARGET_BUFF_REFRESH") then
		--AxTrace(0,0,"event3:"..event);
		TargetBuff_Update();
		this:Show();
	end
end

-- 返回0，不显示。返回1，显示。
function TargetBuff_IsTargetValid()
	if(Target:IsPresent()) then
		return 1;
	elseif(Target:IsTargetTeamMember()) then
		return 1;
	else
		return 0;
	end
end

function TargetBuff_Update()
	local nBuffNum = Target:GetBuffNumber();
	if(0 == nBuffNum) then
		TargetBuff_Clear();
		this:Hide();
	end
	local nFindNum = nBuffNum --???nBuffNum???????
	if(nFindNum > TARGET_IMPACT_NUM) then nFindNum = TARGET_IMPACT_NUM; end
	if(nBuffNum > TARGET_BUFF_MAX) then nBuffNum = TARGET_BUFF_MAX; end

	--从最多20个里面选取6个
	local BUFFINDEX_LIST = {} --??list???????
	do
		for jj=1,TARGET_BUFF_MAX do
			BUFFINDEX_LIST[jj] = -1;
		end

		local BuffPriority = {}
		for jj=1,nFindNum do --??20
			BuffPriority[jj] = {}
			BuffPriority[jj].key = jj-1;
			BuffPriority[jj].val = Target:GetBuffPriorityByIndex(jj-1);
		end

		for jj=nFindNum,1,-1 do --??20
			for kk=1,jj-1 do --??20
				if BuffPriority[kk].val < BuffPriority[kk+1].val then
					BuffPriority[kk],BuffPriority[kk+1] = BuffPriority[kk+1],BuffPriority[kk]
				end
			end
		end

		for jj=1,nBuffNum do --??6
			BUFFINDEX_LIST[jj] = BuffPriority[jj].key;
		end
	end

	local i = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;

		szIconName,szTipInfo = Target:GetBuffIconNameByIndex(BUFFINDEX_LIST[i+1]);
		TARGET_IMPACT_CTL[i+1]:SetProperty("ShortImage", szIconName);
		TARGET_IMPACT_CTL[i+1]:Show();
		TARGET_IMPACT_CTL[i+1]:SetToolTip(szTipInfo);
		i = i + 1;
	end

	while i < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[i+1]:SetToolTip("");
		TARGET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
end

function TargetBuff_Clear()
	local i = 0;
	while i < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[i+1]:SetToolTip("");
		TARGET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
end
