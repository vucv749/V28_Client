local SuperToolTip_AttrCompare2_y_offset = -25
local SuperToolTip_AttrCompare2_g_WidthOfCompare2 = 0

--=========
--PreLoad==
--=========
function SuperToolTip_AttrCompare2_PreLoad()
	this:RegisterEvent("SHOW_SP_CMP2")
	this:RegisterEvent("CLOSE_SP_CMP2")
end

--=========
--OnLoad
--=========
function SuperToolTip_AttrCompare2_OnLoad()
end

--=========
--OnEvent
--=========
function SuperToolTip_AttrCompare2_OnEvent(event)

	if (event == "SHOW_SP_CMP2") then
		--arg0 supertooltip's posx
		--arg1 supertooltip's posy
		--arg2 width
		--arg3 supertooltip's isright

		--context update
		SuperToolTip_AttrCompare2_Update()--!!! must before pos Set
		--pos set
		SuperToolTip_AttrCompare2_Frame:PositionSelf(0, 0, 1, 1)
		SuperToolTip_AttrCompare2_Frame:SetProperty("AbsoluteXPosition", 0)
		SuperToolTip_AttrCompare2_Frame:SetProperty("AbsoluteYPosition", 0)
		local posX = SuperToolTip_AttrCompare2_Frame:SetXAttachPos(arg0, arg2, tonumber(arg3))
		SuperToolTip_AttrCompare2_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip_AttrCompare2_y_offset))

		this:Show()
	elseif event == "CLOSE_SP_CMP2" then
		SuperToolTip_AttrCompare2_y_offset = -25
		this:Hide()
	end

end

--=========
--Update UI
--=========
function SuperToolTip_AttrCompare2_Update()
	-- 先清繝以前显示的文字
	SuperToolTip_AttrCompare2_ClearText()

	local cmptype = SuperTooltips_Cmp2:LuaFnGetCmpType()--enum EQUIPCOMPARE_TYPE
	local toDisplay = "SuperToolTip_AttrCompare2_Title;SuperToolTip_AttrCompare2_Property"
	if cmptype == 1 then
		toDisplay = toDisplay..";SuperToolTip_AttrCompare2_Title2;SuperToolTip_AttrCompare2_Property2"
	end
	SuperToolTip_AttrCompare2_Frame:SetProperty("PageElements", toDisplay)
	
	--equiping's attributa
	local szPropertys = SuperTooltips_Cmp2:LuaFnGetBaseAttrCmp()
	if( szPropertys ~= nil) then
		SuperToolTip_AttrCompare2_Property:SetText(szPropertys)
	else
		SuperToolTip_AttrCompare2_Property:SetText("#{ZBBJ_250313_6}")
	end

	--attribute detail
	local AttrStr = AttrCompare1_2:GetAttrCmpStr()
	if AttrStr ~= nil then
		SuperToolTip_AttrCompare2_Property2:SetText(AttrStr)
	else
		SuperToolTip_AttrCompare2_Property2:SetText("#{ZBBJ_250313_6}")
	end

	--count yoffset (dependon supertooltip.layout.xml supertooltip.lua)
	local firstpartyoffset = 0
	SuperToolTip_AttrCompare2_y_offset = -25
	if SuperTooltips:IsPresent() then
		local typeDesc = SuperTooltips:GetTypeDesc()
		local nGemHoleCounts = SuperTooltips:GetGemHoleCounts()
		local nMoney1,_ = SuperTooltips:GetMoney1()
		local nMoney2,_ = SuperTooltips:GetMoney2()
		local unLockingElapsedTime	=SuperTooltips:GetPUnlockElapsedTime()
		local IsProtectd	=SuperTooltips:GetDesc5()
		local nYuanbaotrade = SuperTooltips:GetYuanbaoTradeFlag()
		local nGoodsProtect = SuperTooltips:GetGoodsProtect_Goods()

		if SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="" then
			firstpartyoffset = firstpartyoffset + 106
		end
		if IsProtectd == "1" and unLockingElapsedTime ~= 0 then
			firstpartyoffset = firstpartyoffset + 32
		end
		if( typeDesc ~= nil) then 
			firstpartyoffset = firstpartyoffset + 18
		end
		if nYuanbaotrade == 0 or nYuanbaotrade == 2 then
			firstpartyoffset = firstpartyoffset + 30
		end
		if type(nGemHoleCounts) == "number" and nGemHoleCounts>0 then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nMoney1 ~= nil then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nMoney2 ~= nil then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nGoodsProtect == 1 then
			firstpartyoffset = firstpartyoffset + 18
		end
	end
	SuperToolTip_AttrCompare2_y_offset = SuperToolTip_AttrCompare2_y_offset + firstpartyoffset + SuperTooltips:LuaFnGetCmpYOffset()
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清繝显示文本
--
function SuperToolTip_AttrCompare2_ClearText()
	SuperToolTip_AttrCompare2_Property:SetText("")
	SuperToolTip_AttrCompare2_Property2:SetText("")
end
