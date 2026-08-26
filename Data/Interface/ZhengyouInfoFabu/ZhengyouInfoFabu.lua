--  ÷ÓÑÆ½Ì¨ : ·¢²¼ÐÅÏ¢£¬¹ÜÀíÐÅÏ¢£¬³·ÏúÐÅÏ¢µÈµÄÑ¡Ôñ½çÃæ cuiyinjie 2008.10.23

local g_strWndName = "ZhengyouInfoFabu";

local g_dlgctrls = {}; --????

-- ¶Ô»°¿òÑ¡Ïî
local dlgoptions = { "fabu",  "chexiao", "guanli",};

-- ¶Ô»°¿ò±êÌâ
local strDlgCaptions = {"#{ZYPT_081103_056}", "#{ZYPT_081103_067}", "#{ZYPT_081103_072}"}; --{"Tuyên b¯ tin tÑc", "HuÖ bö tin tÑc", "Quän lý tin tÑc",};

-- ¶Ô»°¿òÌáÊ¾ÎÄ±¾
local strDlgText = {
	"#{ZYPT_081103_057}", --"Thïnh lña ch÷n Nhî Yêu tuyên b¯ Ðích loÕi hình: (chú ý: Cùng loÕi hình Ðích tin tÑc TÕi cùng th¶i gian Nµi chï có th¬ tuyên b¯ mµt cái. )",
	"#{ZYPT_081103_102}",--"Thïnh lña ch÷n Nhçm Yêu huÖ bö Ðích tin tÑc loÕi hình:",
	"#{ZYPT_081103_103}",--"Thïnh lña ch÷n Nhçm mu¯n xen vào Lý Ðích tin tÑc loÕi hình:",
};

-- µ±Ç°²Ù×÷×´Ì¬
local g_OperationStatus = 4;     -- ??PlayerZhengyouPT.lua?????,??????

-- µ±Ç°Ñ¡ÔñµÄÀàÐÍ
local g_curSelType = 1;

function ZhengyouInfoFabu_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
end

function ZhengyouInfoFabu_OnLoad()
   Initg_dlgctrls();
   g_dlgctrls.OptBtns[1]:SetCheck(1);
   --<Property Name="AlwaysOnTop" Value="True" />
   ZhengyouInfoFabu_Frame:SetProperty("AlwaysOnTop","True");
end

function Initg_dlgctrls()
   g_dlgctrls = {
		Caption = ZhengyouInfoFabu_DragTitle,
		DlgText = ZhengyouInfoFabuTishi,
		OptBtns = {
		                ZhengyouInfoFabu_BtnCheck_Type1,
		                ZhengyouInfoFabu_BtnCheck_Type2,
		                ZhengyouInfoFabu_BtnCheck_Type3,
		                ZhengyouInfoFabu_BtnCheck_Type4,
				  },
   };
end

function ZhengyouInfoFabu_OnEvent(event)

	if(event == "OPEN_WINDOW") then
		ZhengyouInfoFabu_OnOpen( arg0 );

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouInfoFabu") then
			this:Hide();
		end	
	end

end

function ZhengyouInfoFabu_GetSelectFriendType()
  local i = 1;
  for i = 1, 4 do
    if ( 1 == g_dlgctrls.OptBtns[i]:GetCheck() ) then
      return i;
		end
  end
  return 0;
end

function ZhengyouInfoFabu_Choose_Click()
 
	-- ·¢ËÍ¾ßÌå²éÑ¯ÇëÇó
	local curSel = ZhengyouInfoFabu_GetSelectFriendType();
	if ( 0 == curSel ) then
	   PushDebugMessage("#{ZYPT_081103_104}"); --("Thïnh lña ch÷n Chinh Hæu loÕi hình");
	   return;
	end
    g_curSelType = curSel;

	-- ·¢²¼£¬¹ÜÀí£¬³·Ïú¶¼Òª¾­·þÎñÆ÷ÑéÖ¤
	FindFriendQuery(g_OperationStatus, g_curSelType);
	
	this:Hide();
end

-- ×¢Òâ£º Ö»ÓÐ´°¿ÚÃû·ûºÏµÄ²ÅÊÇ â¸ö´°¿Ú£¬ËùÒÔÄ¬ÈÏÑ¡ÖÐµÚÒ»Ïî·ÅÑ­»·ÀïÁË£¬·ÅÍâ±ß»áµ¼ÖÂ´ò¿ª±ðµÄ´°¿ÚÊ±´Ë´°¿ÚÒ²Ñ¡ÔñµÚÒ»Ïî 
function ZhengyouInfoFabu_OnOpen(strOpt)
	local i = 1;

  for i = 1, 3 do
     if( strOpt == g_strWndName .. "_" .. dlgoptions[i] ) then
     	 CloseWindow("ZhengyouSearch");
     	 CloseWindow("ZhengyouYaoqiu");
     	 CloseWindow("VotedPlayer");
        this:Show();
        g_dlgctrls.Caption:SetText(strDlgCaptions[i]);
        g_dlgctrls.DlgText:SetText(strDlgText[i]);
        g_OperationStatus = i + 3;
        
       -- Ä¬ÈÏÑ¡ÖÐµÚÒ»Ïî
  		 for i = 1, 4 do
       	if (1 == i) then
  				g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
	    	g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
  		 end
  		--      
        break;
     end
  end
end


function ZhengyouInfoFabu_Close_Click()
   this:Hide();
end

function ZhengyouInfoFabu_BtnCheck_OnClicked(iType)
   local i = 1;
   for i = 1, 4 do
        if (iType == i) then
   			g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
		    g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
   end
end
