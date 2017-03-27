--
-- Author: peter
-- Date: 2016-06-22 21:47:44
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--  活动吗
local activitycodeLayer = class("activitycodeLayer", function()
            return display.newScene("activitycodeLayer")
end)
-- 标题 活动类型 
function activitycodeLayer:ctor()
         --audio.stopMusic("ACTIVITY")
          self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
         -- Util:stop_music("ACTIVITY")
         self.sur_pageno=1
         --Server:Instance():getactivitypointsdetail(self.id," ")  --个人记录排行榜HTTP
         self.tablecout=1
         self:setNodeEventEnabled(true)--layer添加监听
         self.time=0
         self.secondOne = 0
         self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        		self:update(dt)
    	end)
          self._typeevt=4
         self:init()
         self.image={}
end
function activitycodeLayer:init(  )
	self.inputcodeLayer = cc.CSLoader:createNode("inputcodeLayer.csb");
    	self:addChild(self.inputcodeLayer)

      self.roleAction = cc.CSLoader:createTimeline("inputcodeLayer.csb")
      self.inputcodeLayer:runAction(self.roleAction)
      self.roleAction:setTimeSpeed(0.3)
      self.roleAction:gotoFrameAndPlay(0,122, true)

      self.act_loading=self.inputcodeLayer:getChildByTag(1273)  --  加载标记

            
             local hongdong_bt=self.inputcodeLayer:getChildByTag(115)--输入活动吗
             hongdong_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
            if _table and tonumber(_table["gameIsused"])==0 then  --  0 苹果测试  1  正式
              hongdong_bt:setVisible(false)
            else
               hongdong_bt:setVisible(true)
            end
          
              local back_bt=self.inputcodeLayer:getChildByTag(744)--输入活动吗
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))


    	
            self.activity_ListView=self.inputcodeLayer:getChildByTag(748)--惊喜吧列表
            self.activity_ListView:setItemModel(self.activity_ListView:getItem(0))
            self.activity_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                       

                          if self.sur_pageno==1 then
                          self.activity_ListView:jumpToPercentVertical(100)   
                        else
                          self.activity_ListView:jumpToPercentVertical(100)
                        end
                        
                        self.act_loading:setVisible(true)
                        
                         local function stopAction()
                               self.sur_pageno=self.sur_pageno+1
                              Server:Instance():getactivitylist(tostring(self._typeevt),self.sur_pageno)   --下拉刷新功能
                              self:unscheduleUpdate()
                        end 
                        local callfunc = cc.CallFunc:create(stopAction)
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),callfunc  ))


                                 return
                      end
            end))

            self.activity_ListView:removeAllItems()



	      local true_bt1=self.inputcodeLayer:getChildByTag(916)--关注活动
             true_bt1:setBright(false)
            self.curr_bright=true_bt1--记录当前高亮
             true_bt1:addTouchEventListener((function(sender, eventType  )
                     self:_touchbak(sender, eventType)
              end))

             local end_bt1=self.inputcodeLayer:getChildByTag(917)--结束活动
             end_bt1:addTouchEventListener((function(sender, eventType  )
                     self:_touchbak(sender, eventType)
              end))


            --  true_bt:addEventListener(function(sender, eventType  )
            --          if eventType == ccui.CheckBoxEventType.selected then
            --                 LocalData:Instance():set_getactivitylist(nil)--数据制空
	           --       self.tablecout=0  
	           --       Server:Instance():getactivitylist(tostring(5),1)
	           --       self.activity_ListView:removeAllItems()
	           --       self:unscheduleUpdate()

            --          elseif eventType == ccui.CheckBoxEventType.unselected then
            --                  print("关闭")
            --          end
            -- end)

	 

 
end
function activitycodeLayer:Onerecord_init(  )
	
end
function activitycodeLayer:_touchbak( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
            end
             local tag=sender:getTag()
             if self.curr_bright:getTag()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)

            
           if tag==916 then

                       LocalData:Instance():set_getactivitylist(nil)--数据制空
                        self.tablecout=0  
                        self._typeevt=4
                        Server:Instance():getactivitylist(tostring(self._typeevt),1)
                        self.activity_ListView:removeAllItems()
                        self:unscheduleUpdate()
                        self.image={nil}

              elseif tag==917 then

                 LocalData:Instance():set_getactivitylist(nil)--数据制空
                   self.tablecout=0  
                   self._typeevt=5
                   Server:Instance():getactivitylist(tostring(self._typeevt),1)
                   self.activity_ListView:removeAllItems()
                   self:unscheduleUpdate()
                   self.image={nil}
            end
             self.curr_bright=sender
end
function activitycodeLayer:touch_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
 	 local tag=sender:getTag()
              if tag==115 then   
                    self:huodong(  )
              elseif tag==761 then
              	if self.ActivitycodeLayer then
                            self:unscheduleUpdate()
                            self.fragment_sprite:removeFromParent()
              	            self.ActivitycodeLayer:removeFromParent()
                            Util:all_layer_backMusic()
              	end
              elseif  tag==764 then
              	Server:Instance():validateactivitycode(self. _sing:getString())
              	if self.ActivitycodeLayer then
                  self.fragment_sprite:removeFromParent()
              	     self.ActivitycodeLayer:removeFromParent()
              	end
              elseif tag==916 then

              	       LocalData:Instance():set_getactivitylist(nil)--数据制空
                        self.tablecout=0  
                        self._typeevt=4
                        Server:Instance():getactivitylist(tostring(self._typeevt),1)
                        self.activity_ListView:removeAllItems()
                        self:unscheduleUpdate()

              elseif tag==917 then

              	 LocalData:Instance():set_getactivitylist(nil)--数据制空
                   self.tablecout=0  
                   self._typeevt=5
                   Server:Instance():getactivitylist(tostring(self._typeevt),1)
                   self.activity_ListView:removeAllItems()
                   self:unscheduleUpdate()

              elseif tag==744 then
              	if self.inputcodeLayer then
                   -- Util:stop_music("GAMEBG")
                   -- Util:player_music_hit("ACTIVITY",true )
                  self:unscheduleUpdate()
              	     --self:removeFromParent()
                     display.replaceScene(cc.TransitionProgressInOut:create(0.3, require("app.scenes.MainInterfaceScene"):new()))
                     Util:all_layer_backMusic()
              	end
              end
            
            

end
function activitycodeLayer:move_layer(_layer)
    local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end
function activitycodeLayer:huodong(  )
       self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        self.fragment_sprite:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
        self:addChild(self.fragment_sprite)

	self.ActivitycodeLayer = cc.CSLoader:createNode("ActivitycodeLayer.csb");
    	self:addChild(self.ActivitycodeLayer)
    	self. _sing=self.ActivitycodeLayer:getChildByTag(765)--活动码输入框
      self:move_layer(self.ActivitycodeLayer)
    
    	local back_bt=self.ActivitycodeLayer:getChildByTag(761)--关闭
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))


             local true_bt=self.ActivitycodeLayer:getChildByTag(764)--确定
             true_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)

               end))


            


end
function activitycodeLayer:actimages_list( )
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
function activitycodeLayer:act_list()
	
          self.list_table=LocalData:Instance():get_getactivitylist()
         self.act_loading:setVisible(false)
          if #self.list_table  == 0  then
                      activity_ListView:jumpToPercentVertical(100)   
          end
          self.activity_ListView:removeAllItems() 
          local  sup_data=self.list_table["game"]
           self.sup_data_num= #sup_data
           if self.tablecout<self.sup_data_num then
                   print("小于",self.tablecout ,"  ",self.sup_data_num)
           elseif self.tablecout>=self.sup_data_num then
                 print("大于")
                 self.activity_ListView:removeAllItems() 
           end
            self:unscheduleUpdate()
          
           
          local  function onImageViewClicked(sender, eventType)
                    
                    if eventType == ccui.TouchEventType.ended then
                           -- if self._typeevt  == 5 then
                           --    Server:Instance():prompt("活动已结束")
                           --    return
                           -- end
                             local  _time=sup_data[sender:getTag()]["nowtime"]-sup_data[sender:getTag()]["begintime"]
                                if _time <=  0 then
                                  Server:Instance():prompt("活动未开始")
                                 return
                            end

                             if self._typeevt  == 5  then     --获奖名单
                                      local  win_id=  sup_data[sender:getTag()]["id"]
                                      Server:Instance():getactivitywinners(win_id)
                                      self:_winners( )
                                      return
                             end

                           --self:unscheduleUpdate()
                           self.act_id=sup_data[sender:getTag()]["id"]
                           self. act_image=tostring(Util:sub_str(sup_data[sender:getTag()]["ownerurl"], "/",":"))
                            local  l_time=sup_data[sender:getTag()]["nowtime"]-sup_data[sender:getTag()]["begintime"]
                            if tonumber(l_time) <=  0 then
                              self:addChild(require("app.layers.DetailsLayer").new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"],_ky="act",ser_status=0}))
                              return
                            end

                          self:addChild(require("app.layers.DetailsLayer").new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"],_ky="act",ser_status=1}))
                 
                    end
          end  
          --活动列表进行排序
          local type_table={}
          -- for i=1,#sup_data do
          --         type_table[i]=sup_data[i]["type"]
          -- end

          -- for i=1,#type_table do
          --         for j=1,#type_table-i do
          --              if type_table[j]>type_table[j+1] then 
          --                     local  _data=sup_data[j]
          --                     sup_data[j]=sup_data[j+1]
          --                     sup_data[j+1]=_data
          --              end
          --         end
          -- end

          --self.list_table=LocalData:Instance():get_getactivitylist()
          -- dump(self.list_table)
          -- self.activity_ListView:removeAllItems()
         -- local  sup_data=self.list_table["game"]
          for i=1,#sup_data do  --self.tablecout+
          	self.activity_ListView:pushBackDefaultItem()
          	local  cell = self.activity_ListView:getItem(i-1)
            cell:setTag(i)
            local activity_Panel=cell:getChildByTag(750)
            cell:addTouchEventListener(onImageViewClicked)
            local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
            -- print("99999   ",tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            -- activity_Panel:loadTexture(tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            if not  file then
              table.insert(self.image,{obj =  cell ,name=path..tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":"))})
             else
                activity_Panel:loadTexture(path..tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            end

            local type=cell:getChildByTag(751)
            local type_image=  "png/huodongma-type-" .. sup_data[i]["type"] .. ".png"   --sup_data[i]["type"] .. ".png"  
            type:loadTexture(type_image)
             local _table=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
                         --prizewinning   无为没有中奖
            local own_win=cell:getChildByName("Button_30")   --自己是否中奖
            if   own_win:isVisible() then
              own_win:setVisible(false)
            end
            
            own_win:setTag(i)
            if sup_data[i]["prizewinning"] then
               own_win:setVisible(true)
            end
            own_win:addTouchEventListener((function(sender, eventType  )
                      if eventType ~= ccui.TouchEventType.ended then
                           return
                     end
                     print("我中奖了")
                     self:fun_theirwin(sup_data[sender:getTag()]["gsname"])
            end))

            local dayText=cell:getChildByTag(756)
              local  _time12=sup_data[i]["finishtime"]-sup_data[i]["nowtime"]
            if _time12>0 then
                 local time_label=cell:getChildByTag(753)
                  time_label:setVisible(true)
                  
            end
            local  _time=sup_data[i]["nowtime"]-sup_data[i]["begintime"]
            if _time <=  0 then
              local time_text=cell:getChildByTag(780)
              local time_label=cell:getChildByTag(753)
              time_label:setVisible(false)
              local time_label2=cell:getChildByTag(752)
              time_label2:setVisible(false)
              time_text:setString("距离活动开始还有:")
            end
          
            print("sdf ",_time12,"  ",self._typeevt)
            dayText:setString(tostring(_table[1] .. _table[2] .. _table[3] .. _table[4] ))

            if self._typeevt  == 5  then  --影藏标记
               local _tag=cell:getChildByTag(753)
               _tag:setVisible(false)
               local time_bg=cell:getChildByTag(754)
               time_bg:setVisible(false)
               local time_=cell:getChildByTag(756)
               time_:setVisible(false)
               local time_string=cell:getChildByTag(780)
               time_string:setVisible(false)
               local huojiang_bg=cell:getChildByTag(781)
               huojiang_bg:setVisible(true)
                if tonumber(sup_data[i]["isswardprize"])==0 then  --1是已经发奖  0是未发
                        cell:setTouchEnabled(false)  --禁止点击
                        activity_Panel:setTouchEnabled(true)
                        huojiang_bg:setColor(cc.c3b(100, 100, 100))
                        huojiang_bg:setTouchEnabled(false)
             end


            end
          end

          if tonumber(self.tablecout)~=0 then
            -- dump(self.tablecout)
             self.activity_ListView:jumpToPercentVertical(120)
           else
             self.activity_ListView:jumpToPercentVertical(0)
          end

           --self:scheduleUpdate()
            local function stopAction()
                   self:scheduleUpdate()

          end

          local callfunc = cc.CallFunc:create(stopAction)
         self:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))

          self.tablecout=self.sup_data_num   

end
--初始化获奖名单
function activitycodeLayer:_winners( )

    self.fragment_sprite1 = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        self:addChild(self.fragment_sprite1)


    self.Winners = cc.CSLoader:createNode("Winners.csb");
    self:addChild(self.Winners)

    local back_bt= self.Winners:getChildByTag(63)--返回
    back_bt:addTouchEventListener((function(sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                       return
            end
            if self.Winners then
              self.fragment_sprite1:removeFromParent()
               self.Winners:removeFromParent()
            end
                         
     end))

    self.win_ListView=self.Winners:getChildByTag(69)--获奖列表
    self.win_ListView:setItemModel(self.win_ListView:getItem(0))
    self.win_ListView:removeAllItems()

    self:winners_init()  --更新数据

end
--获奖名单中数据更新
function activitycodeLayer:winners_init( )
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
--  自己获奖名单
function activitycodeLayer:fun_theirwin( _text)
      self.theirwin = cc.CSLoader:createNode("Theirwin.csb")
      self:addChild(self.theirwin)

      local theirwin_name=self.theirwin:getChildByTag(312)--获奖名称
      theirwin_name:setString("恭喜你获得一个" .. _text)
      local _getconsignee = LocalData:Instance():get_getconsignee()
      -- --收货人
      -- local name=self.theirwin:getChildByTag(345)
      -- self:fun_EditBox(280,40,name,_getconsignee["name"],13)
      --   --手机号
      -- local phone=self.theirwin:getChildByTag(346)
      -- self:fun_EditBox(280,40,phone,_getconsignee["phone"],11)
      --   --所在地区
      -- local region=self.theirwin:getChildByTag(347)
      -- self:fun_EditBox(280,40,region,_getconsignee["provincename"]  ..  _getconsignee["cityname"] ,14)
      --   --详细地址
      -- local address=self.theirwin:getChildByTag(348)
      -- self:fun_EditBox(280,100,address,_getconsignee["address"],30)

       --收货人
      local name=self.theirwin:getChildByTag(350)
      name:setString(_getconsignee["name"])
        --手机号
      local phone=self.theirwin:getChildByTag(351)
      phone:setString(_getconsignee["phone"])
        --所在地区
      local region=self.theirwin:getChildByTag(352)
      region:setString(_getconsignee["provincename"]  ..  _getconsignee["cityname"])
        --详细地址
      local address=self.theirwin:getChildByTag(353)
      address:setString(_getconsignee["address"])


      local back_bt= self.theirwin:getChildByTag(311)--返回
      back_bt:addTouchEventListener((function(sender, eventType)
              if eventType ~= ccui.TouchEventType.ended then
                         return
              end
              if self.theirwin then
                Util:all_layer_backMusic()
                 self.theirwin:removeFromParent()
              end
                   
      end))

      local determine_bt= self.theirwin:getChildByTag(349)--确定
      determine_bt:addTouchEventListener((function(sender, eventType)
                if eventType ~= ccui.TouchEventType.ended then
                           return
                end

                 if self.theirwin then
                     self.theirwin:removeFromParent()
                end
  
      end))

end


  function activitycodeLayer:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
            local  sup_data=self.list_table["game"]
            if not sup_data then return end
            for i=1,#sup_data do
         	local  cell = self.activity_ListView:getItem(i-1)
            local  _time=sup_data[i]["nowtime"]-sup_data[i]["begintime"]
             local _table={}
            if _time <=  0 then
               _table=Util:FormatTime_colon(sup_data[i]["begintime"]-sup_data[i]["nowtime"]-self.time)
            else
               _table=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
            end
          
            local dayText=cell:getChildByTag(756)
            dayText:setString(tostring(_table[1] .. _table[2] .. _table[3] .. _table[4] ))
        end


         if #self.image~=0 then
               -- dump(self.image)
               local next_num=0
              for i=1,#self.image do
                  local file=cc.FileUtils:getInstance():isFileExist(self.image[i].name)
                  if file and self.image[i].obj then
                      local activity_Panel=self.image[i].obj:getChildByTag(750)
                      activity_Panel:loadTexture(self.image[i].name)
                      -- table.remove(self.image, {})
                      self.image[i].obj=nil
                      next_num=next_num+1
                  end
              end
              if next_num == #self.image then
                 self.image={}
              end
          end


  end
function activitycodeLayer:onEnter()
      --audio.playMusic(G_SOUND["GAMEBG"],true)
      -- Util:player_music_hit("GAMEBG",true )

       local function stopAction()
                                Util:player_music_hit("PERSONALCHAGE",true )    
        end
        local callfunc = cc.CallFunc:create(stopAction)
       self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),callfunc  ))

	self.tablecout=0
      LocalData:Instance():set_getactivitylist(nil)
      self._typeevt=4
	Server:Instance():getactivitylist(tostring(self._typeevt),1)  --self.ser_status   self.sur_pageno
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
                         --print("7-------------")  --下载图片
                        
                       self:actimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
                         --print("下拉刷新")   --获得图片
                       self:act_list()
                       

                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYCODE, self,
                       function()
                        self:unscheduleUpdate()
                        LocalData:Instance():set_getactivitylist(nil)
                        self._typeevt=4
                         Server:Instance():getactivitylist(tostring(self._typeevt),1)   --再次刷新
                      end)--
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.WINNERS, self,
                       function()

                       --self:_winners( )-- 获奖名单
                       self:winners_init()  --更新数据
                      end)

end

function activitycodeLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.WINNERS, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYCODE, self)

      cc.Director:getInstance():getTextureCache():removeAllTextures() 
end
function activitycodeLayer:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
       self.barrier_bg:setVisible(false)
       self.kuang:setVisible(false)
   else
    self.barrier_bg:setVisible(false)
  self.kuang:setVisible(false)
       self.floating_layer:showFloat(text) 
   end
end 

function activitycodeLayer:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
end 
function activitycodeLayer:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end 
function activitycodeLayer:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end



return activitycodeLayer