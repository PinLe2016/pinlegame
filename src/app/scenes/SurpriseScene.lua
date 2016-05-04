
--
local SurpriseScene = class("SurpriseScene", function()
    return display.newScene("SurpriseScene")
end)
--require("app.model.Server.Server")
local FloatingLayerEx = require("app.layers.FloatingLayer")
function SurpriseScene:ctor()
          self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,100000)
    
end
 function SurpriseScene:Instance()  
    if self.instance == nil then  
        self.instance =  self:new()

    end
    return self.instance
end
function SurpriseScene:Surpriseinit()  --floatingLayer_init
    ActivitymainnterfaceiScene = cc.CSLoader:createNode("ActivitymainnterfaceiScene.csb");
    self:addChild(ActivitymainnterfaceiScene)
    local function Soon_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("即将")
           Server:Instance():getactivitylist(1)


        end
    end
     local function activity_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("本期")
         local list_table=LocalData:Instance():get_getactivitylist()
         local  sup_data=list_table["game"]
         for i=1,#sup_data do
         	Server:Instance():request_pic(sup_data[i]["ownerurl"],sup_data[i]["ownerurl"])
         end
         print("hdshfdsfh  ",list_table)
        end
    end
     local function Reviewpast_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("回顾")
           --registered:removeFromParent()
        end
    end
    local Soon_bt=ActivitymainnterfaceiScene:getChildByTag(29)--即将
    Soon_bt:addTouchEventListener(Soon_btCallback)
     local activity_bt=ActivitymainnterfaceiScene:getChildByTag(30)-- 本期
    activity_bt:addTouchEventListener(activity_btCallback)
     local Reviewpast_bt=ActivitymainnterfaceiScene:getChildByTag(31)--回顾
    Reviewpast_bt:addTouchEventListener(Reviewpast_btCallback)

    return  self
end

function SurpriseScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function SurpriseScene:onEnter()
end

function SurpriseScene:onExit()
end

return SurpriseScene