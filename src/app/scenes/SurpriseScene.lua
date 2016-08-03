
--
-- 
local SurpriseScene = class("SurpriseScene", function()
            return display.newScene("SurpriseScene")
end)

local GameScene = require("app.scenes.GameScene")
local DetailsLayer = require("app.layers.DetailsLayer")

function SurpriseScene:ctor()
  
      self.floating_layer = FloatingLayerEx.new()
      self.floating_layer:addTo(self,100000)
      --self:addChild(SurpriseOverLayer.new())
      self.sur_pageno=1
      self.ser_status =1
      self.time=0
      self.secondOne = 0
      self.list_table={}
      -- self.floating_layer = FloatingLayerEx.new()
      -- self.floating_layer:addTo(self,100000)
      self:Surpriseinit()
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
      	self:update(dt)
      end)
      self.tablecout=1

      -- local pinle_loclation=cc.PinLe_platform:Instance()
      --   local city=pinle_loclation:getCity()
      --   dump(city)

      self:listener_home() --注册安卓返回键

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
    -- Server:Instance():validateactivitycode("123456")

    ActivitymainnterfaceiScene = cc.CSLoader:createNode("ActivitymainnterfaceiScene.csb");
    self:addChild(ActivitymainnterfaceiScene)

    local Soon_bt=ActivitymainnterfaceiScene:getChildByTag(29)--即将
    Soon_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     local activity_bt=ActivitymainnterfaceiScene:getChildByTag(30)-- 本期
    activity_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     activity_bt:setBright(false)
     self.curr_bright=activity_bt--记录当前高亮
     local Reviewpast_bt=ActivitymainnterfaceiScene:getChildByTag(31)--回顾
    Reviewpast_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     local mysurprise_bt=ActivitymainnterfaceiScene:getChildByTag(117)--回顾
    mysurprise_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end)
    )
    local back_bt=ActivitymainnterfaceiScene:getChildByTag(28)--回顾
    back_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))

    activity_ListView=ActivitymainnterfaceiScene:getChildByTag(33)--惊喜吧列表
    activity_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)   --下拉刷新功能
                        self:scheduleUpdate()
                                 return
                      end
     end))
    activity_ListView:setItemModel(activity_ListView:getItem(0))
    activity_ListView:removeAllItems()
    return  self
end
  function SurpriseScene:list_btCallback( sender, eventType )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
              
              if self.curr_bright:getTag()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)
              if tag==29 then   

                       LocalData:Instance():set_getactivitylist(nil)--数据制空
                       self.tablecout=0
                       self.ser_status=0
                       self.sur_pageno=1
                       Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                       activity_ListView:removeAllItems()
                       self:unscheduleUpdate()

              elseif tag==30 then
                      LocalData:Instance():set_getactivitylist(nil)--数据制空
                      self.tablecout=0
                      self.ser_status=1
                      self.sur_pageno=1
                      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==31 then
                      LocalData:Instance():set_getactivitylist(nil)--数据制空
                      self.tablecout=0
                      self.ser_status=2
                      self.sur_pageno=1
                      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==117 then
                       LocalData:Instance():set_getactivitylist(nil)--数据制空
                       self.tablecout=0
                       self.ser_status=3
                       self.sur_pageno=1
                       Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                       activity_ListView:removeAllItems()
                       self:unscheduleUpdate()
              elseif tag==28 then
                       self:unscheduleUpdate()
                        Util:scene_control("MainInterfaceScene")
              end
             self.curr_bright=sender
  end
  function SurpriseScene:update(dt)

	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
            local  sup_data=self.list_table["game"]
            if not sup_data then return end
            for i=1,#sup_data do
         	local  cell = activity_ListView:getItem(i-1)
            local   _table={}
            if self.ser_status==0 then
                _table=Util:FormatTime_colon((sup_data[i]["begintime"]-sup_data[i]["nowtime"])-self.time)
            else
                _table=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
            end
           
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
          
          self.list_table=LocalData:Instance():get_getactivitylist()
          local  sup_data=self.list_table["game"]
           self.sup_data_num= #sup_data
           --activity_ListView:removeAllItems() 
           if self.tablecout<self.sup_data_num then
                   print("小于",self.tablecout ,"  ",self.sup_data_num)
           elseif self.tablecout>self.sup_data_num then
                 print("大于")
                 activity_ListView:removeAllItems() 
            else
                 return
           end

          
           
          local  function onImageViewClicked(sender, eventType)
                   if eventType ~= ccui.TouchEventType.ended then
                               return
                    end

                   local i=sender:getTag()
                   local  sup_data=self.list_table["game"]
                   local  _table1={}
                    if self.ser_status==0 then
                             _table1=Util:FormatTime_colon((sup_data[i]["begintime"]-sup_data[i]["nowtime"])-self.time)
                   else
                             _table1=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
                  end
                    if  self.ser_status==2   or self.ser_status==3 and tonumber(_table1) < 0  then
                          local  win_id=  sup_data[sender:getTag()]["id"]
                            Server:Instance():getactivitywinners(win_id)
                            self:_winners( )
                            return
                   end

                    if eventType == ccui.TouchEventType.ended then
                           self:unscheduleUpdate()
                           self.act_id=sup_data[sender:getTag()]["id"]
                           self. act_image=tostring(Util:sub_str(sup_data[sender:getTag()]["ownerurl"], "/",":"))
                          self:addChild(DetailsLayer.new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"],_ky="sup"}))
                    end
          end  
          --活动列表进行排序
          local type_table={}
          
          -- for i=self.tablecout+1,#sup_data do
          --          print("hhh  ",sup_data[i]["type"])
          --         type_table[i]=sup_data[i]["type"]
          -- end
          -- dump(type_table)
          -- for i=self.tablecout+1,#type_table do
          --         for j=self.tablecout+1,#type_table-i do
          --              if type_table[j]>type_table[j+1] then 
          --                     local  _data=sup_data[j]
          --                     sup_data[j]=sup_data[j+1]
          --                     sup_data[j+1]=_data
          --              end
          --         end
          -- end

          --self.list_table=LocalData:Instance():get_getactivitylist()
          local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
          --local  sup_data=self.list_table["game"]
          for i=self.tablecout+1,#sup_data do
        
          	activity_ListView:pushBackDefaultItem()
          	local  cell = activity_ListView:getItem(i-1)
            cell:setTag(i)
            local activity_Panel=cell:getChildByTag(36)
            cell:addTouchEventListener(onImageViewClicked)
            activity_Panel:loadTexture(path..tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            -- print("777777   ",Util:sub_str(sup_data[i]["ownerurl"], "/",":"),i,#sup_data)
            local Nameprize_text=cell:getChildByTag(42)
            Nameprize_text:setString(tostring(sup_data[i]["gsname"]))
            local type=cell:getChildByTag(133)
            local type_image="png/J_" .. sup_data[i]["type"] .. ".png"
            local huojiang_bg=cell:getChildByTag(336)
            type:loadTexture(type_image)
              if self.ser_status==0 then
                local activity_acttie=cell:getChildByTag(37)
             activity_acttie:setString("距离活动开始还有:")
              end
            

            local _table1=(sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])
            if  self.ser_status==2 then   --往期获奖名单
               
                 huojiang_bg:setVisible(true)
                 local huojiang_bt=huojiang_bg:getChildByTag(337)--获奖名单按钮
                 if tonumber(sup_data[i]["isswardprize"])==0 then  --1是已经发奖  0是未发
                    cell:setTouchEnabled(false)  --禁止点击
                    activity_Panel:setTouchEnabled(true)
                    huojiang_bg:setColor(cc.c3b(100, 100, 100))
                    huojiang_bg:setTouchEnabled(false)
                 end
                 
                 huojiang_bt:setTag(i)
                 huojiang_bt:addTouchEventListener((function(sender, eventType  )
                      if eventType ~= ccui.TouchEventType.ended then
                           return
                     end
                      local  win_id=  sup_data[sender:getTag()]["id"]
                            Server:Instance():getactivitywinners(win_id)
                            self:_winners( )

               end))
            elseif self.ser_status==0 then
                    cell:setTouchEnabled(false)  --禁止点击
                    activity_Panel:setTouchEnabled(true)
            elseif self.ser_status==3 and tonumber(_table1) < 0 then  --我的活动获奖名单
                    huojiang_bg:setVisible(true)
                     local huojiang_bt=huojiang_bg:getChildByTag(337)--获奖名单按钮
                     huojiang_bt:setTag(i)
                      if tonumber(sup_data[i]["isswardprize"])==0 then  --1是已经发奖  0是未发
                         cell:setTouchEnabled(false)  --禁止点击
                          activity_Panel:setTouchEnabled(true)
                        huojiang_bg:setColor(cc.c3b(100, 100, 100))
                        huojiang_bg:setTouchEnabled(false)
                     end

                    huojiang_bt:addTouchEventListener((function(sender, eventType  )
                         if eventType ~= ccui.TouchEventType.ended then
                               return
                       end
                    local  win_id=  sup_data[sender:getTag()]["id"]
                    Server:Instance():getactivitywinners(win_id)
               end))


            else
              huojiang_bg:setVisible(false)
            end

          end

          self:scheduleUpdate()
          self.tablecout=self.sup_data_num
end
--初始化获奖名单
function SurpriseScene:_winners( )
    self.Winners = cc.CSLoader:createNode("Winners.csb");
    self:addChild(self.Winners)

    local back_bt= self.Winners:getChildByTag(63)--返回
    back_bt:addTouchEventListener((function(sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                       return
            end
            if self.Winners then
               self.Winners:removeFromParent()
            end
                         
     end))

    self.win_ListView=self.Winners:getChildByTag(69)--获奖列表
    self.win_ListView:setItemModel(self.win_ListView:getItem(0))
    self.win_ListView:removeAllItems()

    self:winners_init()  --更新数据

end
--获奖名单中数据更新
function SurpriseScene:winners_init( )
          self.win_table= LocalData:Instance():get_getactivitywinners()
          local  sup_data=self.win_table["winnerlist"]
          if not sup_data then
            return
          end
        self.win_ListView:removeAllItems()
          for i=1, #sup_data do  --#sup_data
            self.win_ListView:pushBackDefaultItem()

            local  cell = self.win_ListView:getItem(i-1)

            local name_text=cell:getChildByTag(72)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local paiming_tex=cell:getChildByTag(71)--排名
            paiming_tex:setString(tostring(i))

             local points_text=cell:getChildByTag(73)--积分
            points_text:setString(tostring(sup_data[i]["points"]))

            local goodsname_text=cell:getChildByTag(74) --获奖物品
            goodsname_text:setString(tostring(sup_data[i]["goodsname"]))
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
       
         	Server:Instance():request_pic(sup_data[i]["ownerurl"],com_) --下载图片
         end
end
function SurpriseScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function SurpriseScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function SurpriseScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end

function SurpriseScene:onEnter()
      --audio.playMusic(G_SOUND["PERSONALCHAGE"],true)
      Util:player_music("PERSONALCHAGE",true )
      LocalData:Instance():set_getactivitylist(nil)
      self.tablecout=0
     Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)

	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()

                       self:Surpriseimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()

                       self:Surprise_list()
                      end)
      NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.WINNERS, self,
                       function()

                       --self:_winners( )-- 获奖名单
                       self:winners_init()  --更新数据
                      end)
end

function SurpriseScene:onExit()
      --audio.stopMusic(G_SOUND["PERSONALCHAGE"])
      Util:stop_music("PERSONALCHAGE")
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.WINNERS, self)

end
--android 返回键 响应
function SurpriseScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              self:unscheduleUpdate()
              Util:scene_control("MainInterfaceScene")
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end



return SurpriseScene