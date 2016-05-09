
--
-- 
local SurpriseScene = class("SurpriseScene", function()
            return display.newScene("SurpriseScene")
end)

local GameScene = require("app.scenes.GameScene")

function SurpriseScene:ctor()
	self.time=0
	self.secondOne = 0
	self.list_table={}
	self.floating_layer = FloatingLayerEx.new()
	self.floating_layer:addTo(self,100000)
	self:Surpriseinit()


	 self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        		self:update(dt)
    	end)


end
 function SurpriseScene:Instance()  
    if self.instance == nil then  
        self.instance =  self:new()

    end
    return self.instance
end
function SurpriseScene:Surpriseinit()  --floatingLayer_init

  -- self.time=0
  -- self.secondOne = 0
  -- self.list_table={}
  -- self.floating_layer = FloatingLayerEx.new()
  -- self.floating_layer:addTo(self,100000)
  -- self:Surpriseinit()


  --  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
  --           self:update(dt)
  --     end)

    ActivitymainnterfaceiScene = cc.CSLoader:createNode("ActivitymainnterfaceiScene.csb");
    self:addChild(ActivitymainnterfaceiScene)
    local function Soon_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("即将")
           Server:Instance():getactivitylist(0)
           activity_ListView:removeAllItems()
        end
    end
     local function activity_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("本期")
         Server:Instance():getactivitylist(1)
         activity_ListView:removeAllItems()
        end
    end
     local function Reviewpast_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("回顾")
           Server:Instance():getactivitylist(2)
           activity_ListView:removeAllItems()
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

  function SurpriseScene:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
            local  sup_data=self.list_table["game"]
            for i=1,#sup_data do
         	local  cell = activity_ListView:getItem(i-1)
            local _table=Util:FormatTime_colon(sup_data[i]["finishtime"]-sup_data[i]["begintime"]-self.time)
            local dayText=cell:getChildByTag(38)
            dayText:setString(tostring(_table[1]))
            local hoursText=cell:getChildByTag(39)
            hoursText:setString(tostring(_table[2]))
            local pointsText=cell:getChildByTag(40)
            pointsText:setString(tostring(_table[3]))
            local secondsText=cell:getChildByTag(41)
            secondsText:setString(tostring(_table[4]))
        end
  end

        
function SurpriseScene:Surprise_list(  )--Util:sub_str(command["command"], "/") 
          activity_ListView:removeAllItems()
          local  function onImageViewClicked(sender, eventType)
                    if eventType == ccui.TouchEventType.ended then
                          print("列表TOUCH事件")
                           --display.replaceScene(GameScene:new())
                           cc.Director:getInstance():pushScene(GameScene:new())
                    end
          end  

          self.list_table=LocalData:Instance():get_getactivitylist()
          local  sup_data=self.list_table["game"]
          dump(sup_data)
          for i=1,#sup_data do
          	activity_ListView:pushBackDefaultItem()
          	local  cell = activity_ListView:getItem(i-1)
            local activity_Panel=cell:getChildByTag(36)
            activity_Panel:addTouchEventListener(onImageViewClicked)
            activity_Panel:loadTexture(tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            local Nameprize_text=cell:getChildByTag(42)
            Nameprize_text:setString(tostring(sup_data[i]["gsname"]))
          end
          self:scheduleUpdate()
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