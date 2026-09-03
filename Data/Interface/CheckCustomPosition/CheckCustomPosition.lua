-------------------------------------------------------
--"²é¿´×Ô¶¨Òå°ï»áÖ°Î»"½çÃæ½Å±¾
--create by xindefeng
-------------------------------------------------------

local g_CustomPosition = nil	--????????

--±ê×¼°ï»áÖ°Î»Ãû³Æ
local g_StdPositionName = {
	" Bang Chü",			--9
	" Bang Phó",		--8
	" Nµi Vø SÑ",		--7
	" Công Vø SÑ",		--6
	" Hoang Hoa SÑ",		--5
	" Thß½ng Nhân",			--4
	" Tinh Anh",			--3
	" Bang Chúng"			--2
}


--ÊÂ¼þ×¢²á
function CheckCustomPosition_PreLoad()
	this:RegisterEvent("GUILD_CHECK_CUSTOMPOSITION")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	
end

function CheckCustomPosition_OnLoad()	
end

--ÊÂ¼þÏìÓ¦
function CheckCustomPosition_OnEvent(event)	
	if( event == "GUILD_CHECK_CUSTOMPOSITION" ) then
		CheckCustomPosition_SetCtls()	--????
				
		CheckCustomPosition_Update()
		CheckCustomPosition_Show()
	elseif( event == "GUILD_FORCE_CLOSE" ) then	
		CheckCustomPosition_Ok()
	end
end

--ÉèÖÃ¿Ø¼þ±í
function CheckCustomPosition_SetCtls()
	g_CustomPosition = {
												CheckCustomPosition_CurPos1,
												CheckCustomPosition_CurPos2,
												CheckCustomPosition_CurPos3,
												CheckCustomPosition_CurPos4,
												CheckCustomPosition_CurPos5,
												CheckCustomPosition_CurPos6,
												CheckCustomPosition_CurPos7,
												CheckCustomPosition_CurPos8							
										}
end


--Ë¢ÐÂ½çÃæÏÔÊ¾µÄÊý¾Ý
function CheckCustomPosition_Update()
	local szMsg = nil
	
	CheckCustomPosition_Title:SetText("#gFF0FA0Tñ l§p chÑc v¸ ")
	
	--ÏÔÊ¾µ±Ç°"×Ô¶¨ÒåÖ°Î»Ãû³Æ"
	for i=1,8 do
		szMsg = Guild:GetCurCustomPositionName(10-i)
		if((szMsg == "") or (szMsg == g_StdPositionName[i]))then
			szMsg = g_StdPositionName[i]			
		else
			szMsg = szMsg.."("..g_StdPositionName[i]..")"			
		end
		
		--ÉèÖÃµ±Ç°×Ô¶¨ÒåÖ°Î»Ãû³Æ
		g_CustomPosition[i]:SetText(szMsg)
		
	end
end

--´ò¿ª½çÃæ
function CheckCustomPosition_Show()	
	this:Show()
end

--È·¶¨
function CheckCustomPosition_Ok()	
	--¹Ø± ´°¿Ú
	this:Hide()	
end
