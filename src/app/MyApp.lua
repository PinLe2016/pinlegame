
require("config")
require("cocos.init")
require("framework.init")
local MyApp = class("MyApp", cc.mvc.AppBase)
PINLE_CHANNEL_ID="DVE"

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
   cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, cc.ResolutionPolicy.FIXED_WIDTH)
     -- 这边是IPAD
  self:GET_CHANNEL_ID()


	cc.FileUtils:getInstance():addSearchPath("res/")
	cc.FileUtils:getInstance():addSearchPath("res/CSres/main/MainUI")
	cc.FileUtils:getInstance():addSearchPath("res/CSres/main")
    self:enterScene("MainScene")
end


function MyApp:GET_CHANNEL_ID()
   if device.platform ~= "android" then
	  print("please run this on android device")
	  return
   end
   PINLE_CHANNEL_ID=device.getOpenUDID()
end

return MyApp
