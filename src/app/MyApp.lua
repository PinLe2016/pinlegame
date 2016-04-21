
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
   --生成DEVICE_ID
   self:init_userdefault()



	cc.FileUtils:getInstance():addSearchPath("res/")
	cc.FileUtils:getInstance():addSearchPath("res/CSres/main/MainUI")
	cc.FileUtils:getInstance():addSearchPath("res/CSres/main")
  self:enterScene("MainScene")
end


function MyApp:init_userdefault()

   local device_id = cc.UserDefault:getInstance():getStringForKey("device_id")
   if device_id == "" then
    -- create random number
    -- math.newrandomseed()
    local rand = math.random(9999999)
    -- get os time
    local t = os.time()
    -- put them together
    -- device_id = crypto.md5( device.getOpenUDID() ..  rand  .. t )
    device_id = crypto.md5( rand  .. t .. os.clock())
    cc.UserDefault:getInstance():setStringForKey("device_id" , device_id)
   end
   print("create device_id " .. device_id)
end

return MyApp
