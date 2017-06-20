--
-- Author: peter
-- Date: 2016-08-24 14:24:11   taskLayer
-- Author: peter
-- Date: 2016-05-09 16:51:38
--  任务拼乐界面
local taskLayer = class("taskLayer", function()
            return display.newLayer("taskLayer")
end)
function taskLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
       self.sur_pageno=1
       self.task_state={"普通种子","中级种子","高级种子","钻石种子","惊喜种子","普通化肥","中级化肥","高级化肥"}
       self.task_stateimage={"resources/com/rewardImage2.png","resources/com/rewardImage3.png","resources/com/rewardImage4.png","resources/com/rewardImage5.png","resources/com/rewardImage6.png","resources/com/rewardImage7.png","resources/com/rewardImage8.png","resources/com/rewardImage9.png"}
       LocalData:Instance():set_gettasklist(nil)
       self.share = nil
       self.Act_fragment_sprite=nil
       Server:Instance():gettasklist()
       self:init(  )

end
function taskLayer:fun_share_friend()--update(dt)
      self.Act_fragment_sprite =display.newSprite()
      self:addChild(self.Act_fragment_sprite)
      local function stopAction()
           if self.share then
                       if self.share:getIs_Share()  and  LocalData:Instance():get_tasktable()    then   --  判断分享是否做完任务
                           Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
                            LocalData:Instance():set_tasktable(nil)--制空
                            self.share=nil
                            self.Act_fragment_sprite:stopAllActions()
                            Server:Instance():gettasklist()
                     end
           end
      end
      local callfunc = cc.CallFunc:create(stopAction)
      self.Act_fragment_sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(callfunc,cc.DelayTime:create(1))))

         
end



function taskLayer:init(  )

        if not self.taskLayer then
            LocalData:Instance():set_sign(2)
            local fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
            self:addChild(fragment_sprite_bg)
            self.taskLayer = cc.CSLoader:createNode("taskLayer.csb")
            self:addChild(self.taskLayer)
            self.taskLayer:setScale(0.7)
            self.taskLayer:setAnchorPoint(0.5,0.5)
            self.taskLayer:setPosition(320, 568)

           --  local actionTo = cc.ScaleTo:create(0.3, 1.1)
           -- local actionTo1 = cc.ScaleTo:create(0.1, 1)
           --  self.taskLayer:runAction(cc.Sequence:create(actionTo,actionTo1  ))
           Util:layer_action(self.taskLayer,self,"open")



            local back_bt=self.taskLayer:getChildByTag(3242)  --返回
            back_bt:addTouchEventListener((function(sender, eventType  )
                    if eventType == 3 then
                       sender:setScale(1)
                       return
                     end
                     if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                  end
                  sender:setScale(1)
                  Util:all_layer_backMusic()
                  LocalData:Instance():set_sign(1)
                  local function stopAction()
                  self:removeFromParent()
                  end
                  local actionTo = cc.ScaleTo:create(0.1, 1.1)
                  local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
                  local callfunc = cc.CallFunc:create(stopAction)
                  self.taskLayer:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))


               end))
            self.task_list=self.taskLayer:getChildByTag(143)--邮箱列表
            self.task_list:setItemModel(self.task_list:getItem(0))
            self.task_list:removeAllItems()
            self.task_list:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        --Server:Instance():getaffichelist(self.sur_pageno)   --下拉刷新功能
                                 return
                      end
             end))          
          else
            self.task_list:removeAllItems()
        end
        

         

            -- self:data_init()  --测试
end
function taskLayer:data_init(  )
      self.task_list:removeAllItems()
      local _table=LocalData:Instance():get_gettasklist()
             -- dump(_table)
      local tasklist=_table["tasklist"]
      if #tasklist==0 then
        self.task_list:setVisible(false)
        return
      end

  for i=1,#tasklist do
                  self.task_list:pushBackDefaultItem()
                  local  cell = self.task_list:getItem(i-1)
                  local  task_but=cell:getChildByTag(178)--按钮
                  task_but:setTag(i)
                   local  task_text=cell:getChildByTag(1227)--按钮
                   -- local  task_ico=cell:getChildByTag(200)--按钮
                   -- task_ico:loadTexture("png/task" ..  tonumber(tasklist[i]["targettype"])  ..  ".png")
                   local dt=tonumber(tasklist[i]["targettype"])
                  if    dt==  0  or   dt  ==  1  or    dt  ==  2 then
                       

                        local  LoadingBar_3=cell:getChildByTag(199)--
                         LoadingBar_3:setVisible(false)
                        

                  end

                if  tonumber(tasklist[i]["status"]) == 1   then   --1未完成  2已完成未领取  3已完成所有任务且已领取
                    task_text:setString(tasklist[i]["title"])
                elseif tonumber(tasklist[i]["status"]) == 2 then
                    if tonumber(tasklist[i]["targettype"])  ==  0  then
                         task_text:setVisible(false)
                         task_but:loadTextures("png/taskcomplete2.png","","")
                         task_but:setTouchEnabled(false)
                     --return
                    end
                    task_text:setString("领 取")
                elseif tonumber(tasklist[i]["status"]) == 3 then
                      task_text:setVisible(false)
                       task_but:loadTextures("png/taskcomplete1.png","","")
                       task_but:setTouchEnabled(false)
                end

                 --print("发的是开发商可",task_text:getStringLength())
                

                  
                  task_but:addTouchEventListener(function(sender, eventType  )

                                    self:touch_Callback(sender, eventType)
                   end)

                  local  alert=cell:getChildByTag(196)--描述
                  alert:setVisible(false)
                  local title_bg=cell:getChildByTag(175)--描述=cell:getChildByTag(175)--描述
                  --local title_bg=cell:getChildByTag(175)
                 

                  local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,280,100))
                  crn:setPosition(cc.p(135,50))
                  title_bg:addChild(crn)

                  local title = ccui.Text:create("", "resources/com/huakangfangyuan.ttf", 25)
                  title:setPosition(cc.p(title:getContentSize().width,25))--alert:getPositionX(),alert:getPositionY()
                  title:setAnchorPoint(cc.p(0,0.5))
                  crn:addChild(title)
                  title:setColor(cc.c3b(245, 126, 20))
                  title:setString(tasklist[i]["description"])

                        --描述动画
                    local move = cc.MoveTo:create((title:getContentSize().width)/50, cc.p(-(title:getContentSize().width), 25))
                    --local move_back = move:reverse()
                     local callfunc = cc.CallFunc:create(function(node, value)
                            title:setPosition(cc.p(title:getContentSize().width,25))
                          end, {tag=0})
                     local seq = cc.Sequence:create(move,cc.DelayTime:create(3),callfunc  ) 
                    local rep = cc.RepeatForever:create(seq)
                    title:runAction(rep)
              
                  -- if title:getStringLength() <= 7     then
                  --    title:setFontSize(23)
                  -- elseif  title:getStringLength() >= 7   then
                  --   title:setFontSize(12)
                  -- end


                  local  gold_number=cell:getChildByTag(195)--获得金币   后续的改
                  local  gold_image=cell:getChildByTag(179)  --  奖励图片
                  gold_number:setString(tasklist[i]["rewardamount"])
                  if tasklist[i]["rewardtype"] == 0  then  --0为金币，1为积分，2为道具，3为商品
                     gold_image:loadTexture("resources/youjianjiemian/YJ_icon_1.png")
                  elseif tasklist[i]["rewardtype"] == 1 then
                    gold_image:loadTexture("png/chengzhangshu-touxiang-jingyan-icon.png")
                  elseif tasklist[i]["rewardtype"] == 2 then
                      for k=1,8 do
                           if tostring(tasklist[i]["rewarditemname"])  ==  self.task_state[k] then
                              gold_image:loadTexture(  self.task_stateimage[k])
                           end
                      end
                     
                  else

                  end
                  
                  if tonumber(tasklist[i]["targettype"])  ==  0 then
                     gold_number:setVisible(false)
                     gold_image:setVisible(false)
                  end
                  local  loadingbar_text=cell:getChildByTag(198)--进度条数值
                  loadingbar_text:setString(tasklist[i]["progress"]  ..  "/"   ..   tasklist[i]["targetgoal"])  
                   local loadingbar=cell:getChildByTag(199)-- 进度条
                   if tonumber(tasklist[i]["progress"]) > tonumber(tasklist[i]["targetgoal"])    then
                     tasklist[i]["progress"] =  tonumber(tasklist[i]["targetgoal"])
                   end
               local jindu= tonumber(tasklist[i]["progress"]) /  tonumber(tasklist[i]["targetgoal"])  *100
               loadingbar:setPercent(jindu)

                
                  

            end
end
function taskLayer:touch_btCallback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 

           local tag=sender:getTag()
           if tag==141 then  --返回
              -- Util:scene_control("MainInterfaceScene")
              Util:all_layer_backMusic()
              LocalData:Instance():set_sign(1)
              local function stopAction()
              self:removeFromParent()
              end
              -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
              -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
              -- local callfunc = cc.CallFunc:create(stopAction)
              -- self.taskLayer:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
              Util:layer_action(self.taskLayer,self,"close")
           
           end  
end

function taskLayer:touch_Callback( sender, eventType )
   if eventType ~= ccui.TouchEventType.ended then
                return
       end 
        if self.Act_fragment_sprite ~= nil then
              self.Act_fragment_sprite:stopAllActions()
        end
       local tag=sender:getTag() 
       local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       LocalData:Instance():set_tasktable(tasklist[tag]["targetid"])  --记录
       local targettype=tasklist[tag]["targettype"]  --0为签到，1为邀请好友，2为分享，3为惊喜吧，4为奖池,5为获得金币数，6为获得积分数
       if tonumber(tasklist[tag]["status"]) == 2 then
               
               Server:Instance():settasktargetrecord(tasklist[tag]["targetid"])  --领取奖励
               return
       end
       if  tonumber(targettype) == 0  then
            Server:Instance():getcheckinhistory()
       elseif  tonumber(targettype) == 1 then ---待定
             local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
            self:addChild(FriendrequestLayer.new({switch=1}))  
      elseif  tonumber(targettype) == 2 then  --分享
            --  local FriendrequestLayer = require("app.layers.InvitefriendsLayer")  --邀请好友
            -- self:addChild(FriendrequestLayer.new())
            --self:scheduleUpdate()
            self.share = Util:share()
            self:fun_share_friend()
            
      elseif  tonumber(targettype) == 3 then
            -- Util:scene_control("SurpriseScene")
             local scene=SurpriseScene.new()
            cc.Director:getInstance():pushScene(scene)

      elseif  tonumber(targettype) == 4 then
             --Util:scene_control("GoldprizeScene")
             print("--------e---")
             local GoldprizeScene = require("app.scenes.GoldprizeScene")--主界面
              local scene=GoldprizeScene.new()
            cc.Director:getInstance():pushScene(scene)

       end
       
      Server:Instance():getuserinfo() 

end 


function taskLayer:onEnter()
   
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
                       function()
                                  self:data_init()
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.TASKTARGETRECORD, self,
                       function()
                                  LocalData:Instance():set_gettasklist(nil)
                                  Server:Instance():gettasklist()
                      end)
  
end

function taskLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.TASKTARGETRECORD, self)
     
      
end


return taskLayer




