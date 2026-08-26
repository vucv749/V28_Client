
local objCared = -1;

local g_TestFrame_From = -1;

local g_CameraHeight = 1;
local g_CameraDistance = 2;
local g_CameraPitch = 3;


local g_TestFrame_Frame_UnifiedPosition;

function TestFrame_PreLoad()
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("UI_COMMAND");
	-- this:RegisterEvent("OBJECT_CARED_EVENT",false);


	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");
	this:RegisterEvent("YIGUI_OPEN");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("OPEN_YB_SHOP_FITTING")
	this:RegisterEvent("FASHION_DEPOT_OP", false);

	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end

function TestFrame_OnLoad()
g_TestFrame_Frame_UnifiedPosition= TestFrame_Frame:GetProperty("UnifiedPosition");
end


function TestFrame_OnEvent(event)

	if ( event == "HIDE_ON_SCENE_TRANSED" ) then
		TestFrame_Close();
	end

	if ( event == "OPEN_EQUIP") or
		 (event == "OPEN_DRESS_PAINT_FITTING") or
		 (event == "OPEN_DRESS_ENCHASE_FITTING") or
		 (event == "YIGUI_OPEN") or
		 (event == "OPEN_YB_SHOP_FITTING") or
		 (event == "OPEN_SHOP_FITTING") or
		 (event == "FASHION_DEPOT_OP" and tonumber(arg0) == 1 ) then
		if (this:IsVisible()) then
			TestFrame_Close();
		end
	end

	if(event == "UI_COMMAND" and tonumber(arg0) == 20260121) then
		-- local targetid = Get_XParam_INT(0);
		-- objCared = DataPool : GetNPCIDByServerID(targetid);

		-- if objCared == -1 then
			-- return;
		-- end
		-- this:CareObject(objCared, 1, "CHANGE_SEX_NEW");
		
		g_TestFrame_From = tonumber(arg0)

		this:Show();

		TestFrame_FakeObject_1:SetFakeObject("");
		TuJian:SetModel(1, 1000)
		TestFrame_FakeObject_1:SetFakeObject("TuJian_Model1");
		
		TestFrame_FakeObject_2:SetFakeObject("");
		TuJian:SetModel(2, 1001)
		TestFrame_FakeObject_2:SetFakeObject("TuJian_Model2");
		
		TestFrame_FakeObject_3:SetFakeObject("");
		TuJian:SetModel(3, 1002)
		TestFrame_FakeObject_3:SetFakeObject("TuJian_Model3");
		
		TestFrame_FakeObject_4:SetFakeObject("");
		TuJian:SetModel(4, 1003)
		TestFrame_FakeObject_4:SetFakeObject("TuJian_Model4");
		
		TestFrame_FakeObject_5:SetFakeObject("");
		TuJian:SetModel(5, 1004)
		TestFrame_FakeObject_5:SetFakeObject("TuJian_Model5");
		
		TestFrame_FakeObject_6:SetFakeObject("");
		TuJian:SetModel(6, 1005)
		TestFrame_FakeObject_6:SetFakeObject("TuJian_Model6");
		
		TestFrame_FakeObject_7:SetFakeObject("");
		TuJian:SetModel(7, 1006)
		TestFrame_FakeObject_7:SetFakeObject("TuJian_Model7");
		
		TestFrame_FakeObject_8:SetFakeObject("");
		TuJian:SetModel(8, 1007)
		TestFrame_FakeObject_8:SetFakeObject("TuJian_Model8");
		
		
	end

	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- this:CareObject(objCared, 0, "CHANGE_SEX_NEW");
			-- this:Hide();
		end
	end

	if (event == "ADJEST_UI_POS" ) then
		TestFrame_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TestFrame_Frame_On_ResetPos()
	end


end

function TestFrame_Close()
	-- this:CareObject(objCared, 0, "CHANGE_SEX_NEW");
	-- this:Hide();
end


function TestFrame_Accept_Clicked()
	-- LuaConfirmTestFrame("#{ZXD_20120406_02}", "66", objCared)
	-- this:Hide();
end






----------------------------------------------------------------------------------
--
-- 模型1旋转控制
--
function TestFrame_TurnLeft_1(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_1:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_1:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_1(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_1:RotateBegin(0.3);
		else
			TestFrame_FakeObject_1:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型2旋转控制
--
function TestFrame_TurnLeft_2(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_2:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_2:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_2(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_2:RotateBegin(0.3);
		else
			TestFrame_FakeObject_2:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型3旋转控制
--
function TestFrame_TurnLeft_3(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_3:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_3:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_3(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_3:RotateBegin(0.3);
		else
			TestFrame_FakeObject_3:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型4旋转控制
--
function TestFrame_TurnLeft_4(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_4:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_4:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_4(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_4:RotateBegin(0.3);
		else
			TestFrame_FakeObject_4:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型5旋转控制
--
function TestFrame_TurnLeft_5(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_5:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_5:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_5(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_5:RotateBegin(0.3);
		else
			TestFrame_FakeObject_5:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型6旋转控制
--
function TestFrame_TurnLeft_6(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_6:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_6:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_6(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_6:RotateBegin(0.3);
		else
			TestFrame_FakeObject_6:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型7旋转控制
--
function TestFrame_TurnLeft_7(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_7:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_7:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_7(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_7:RotateBegin(0.3);
		else
			TestFrame_FakeObject_7:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 模型8旋转控制
--
function TestFrame_TurnLeft_8(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_8:RotateBegin(-0.3);
		else
			TestFrame_FakeObject_8:RotateEnd();
		end
	end
end

function TestFrame_TurnRight_8(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			TestFrame_FakeObject_8:RotateBegin(0.3);
		else
			TestFrame_FakeObject_8:RotateEnd();
		end
	end
end

function TestFrame_Frame_On_ResetPos()
  TestFrame_Frame:SetProperty("UnifiedPosition", g_TestFrame_Frame_UnifiedPosition);
end

function TestFrame_DoNothing()
end
