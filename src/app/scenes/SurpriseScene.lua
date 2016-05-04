
--
local SurpriseScene = class("SurpriseScene", function()
    return display.newScene("SurpriseScene")
end)
require("app.model.NotificationCenter")
require("app.model.Server.Server")
require("app.model.LocalData.LocalData")
local FloatingLayerEx = require("app.layers.FloatingLayer")
function SurpriseScene:ctor()
          self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,100000)
    self:Surpriseinit()
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

    activity_ListView=ActivitymainnterfaceiScene:getChildByTag(33)--惊喜吧列表
    activity_ListView:setItemModel(activity_ListView:getItem(0))
    activity_ListView:removeAllItems()
    return  self
end

function SurpriseScene:Surprise_list(  )
        activity_ListView:removeAllItems()
         
         local list_table=LocalData:Instance():get_getactivitylist()
         local  sup_data=list_table["game"]
         for i=1,#sup_data do
         	activity_ListView:pushBackDefaultItem()
         	local  cell = activity_ListView:getItem(i-1);
         end
end
function SurpriseScene:Surpriseimages_list(  )
         local list_table=LocalData:Instance():get_getactivitylist()
         local  sup_data=list_table["game"]
         for i=1,#sup_data do
         	local com_={}
         	com_["command"]=sup_data[i]["ownerurl"]
         	com_["max_pic_idx"]=#sup_data
         	com_["curr_pic_idx"]=i
       
         	Server:Instance():request_pic(sup_data[i]["ownerurl"],com_)
         end
end
function SurpriseScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function SurpriseScene:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
                       self:Surpriseimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
                       self:Surprise_list()
                      end)
end

function SurpriseScene:onExit()
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
end

return SurpriseScene