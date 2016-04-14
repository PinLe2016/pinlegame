
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()

   cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 960, cc.ResolutionPolicy.FIXED_WIDTH)

    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

return MyApp
