
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
    cc.FileUtils:getInstance():addSearchPath("res/CSres/main/MainUI")
     cc.FileUtils:getInstance():addSearchPath("res/CSres/main")
    self:enterScene("debrisScene")
end

return MyApp
