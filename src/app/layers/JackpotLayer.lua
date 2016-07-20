--
-- Author: peter
-- Date: 2016-06-02 10:39:24
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--   奖池界面
local JackpotLayer = class("JackpotLayer", function()
            return display.newLayer("JackpotLayer")
end)

GameScene = require("app.scenes.GameScene")--惊喜吧

--标题 活动类型 
function JackpotLayer:ctor(params) 

        dump(params)
         self.is_cooltime=true
         self.id=params.id
         self.adownerid=params.adownerid
          LocalData:Instance():set_user_oid(self.id)
         --Server:Instance():getgoldspoolbyid(self.id)  --删除
         Server:Instance():getgoldspoollist({pagesize=params.goldspoolcount,pageno=1,adownerid = self.adownerid})
         Server:Instance():getrecentgoldslist(10)-- 中奖信息
         self:setNodeEventEnabled(true)--layer添加监听
         self.is_bright=true
         LocalData:Instance():set_setgamerecord({})
         self.secondOne = 0
         self.time=0
          self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
            self:update(dt)
      end)
end
function JackpotLayer:init(  )

      self.JackpotScene = cc.CSLoader:createNode("JackpotScene.csb")
        self:addChild(self.JackpotScene)
        self.roleAction = cc.CSLoader:createTimeline("JackpotScene.csb")
        self.JackpotScene:runAction(self.roleAction)
        self.roleAction:setTimeSpeed(5)

         local reward_bt=self.JackpotScene:getChildByTag(777)  -- 是否选择幸运卡
         self._rewardbt=reward_bt
         
        reward_bt:addEventListener(function(sender, eventType  )
                     if self._doublecardamount <=0 then
                         reward_bt:setSelected(false)
                         return
                     end
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.is_double=1   --翻倍
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            self.is_double=2  --普通
                            
                     end
        end)

         self.shuiguo1=self.JackpotScene:getChildByTag(771):getChildByTag(773)
         self.shuiguo1:setVisible(false)
         self.shuiguo2=self.JackpotScene:getChildByTag(771):getChildByTag(774)
         self.shuiguo2:setVisible(false)
         self.shuiguo3=self.JackpotScene:getChildByTag(771):getChildByTag(775)
      

        self.advertiPv=self.JackpotScene:getChildByTag(151)
        local advertiPa=self.advertiPv:getChildByTag(152)

       
        local  list_table=LocalData:Instance():get_getgoldspoollist()
        --以下三个禁
        self._dian1=self.JackpotScene:getChildByTag(810)  
        self._dian2=self.JackpotScene:getChildByTag(811)
        self._dian3=self.JackpotScene:getChildByTag(812)

        self._jiliang=self.JackpotScene:getChildByTag(951)

        
        local  jaclayer_data=list_table["goldspools"]
        self.advertiPv:addEventListener(function(sender, eventType  )
                
                 if eventType == ccui.PageViewEventType.turning then

                    self.tpid=jaclayer_data[self.advertiPv:getCurPageIndex()+1]["id"]

                    self._jiliang:setString( tostring(self.advertiPv:getCurPageIndex()+1)  ..  "/" ..  tostring(#jaclayer_data))
                    self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex())
                      if self.advertiPv:getCurPageIndex()==0 then
                           self._dian1:setSelected(true)
                           self._dian2:setSelected(false)
                           self._dian3:setSelected(false)

                       elseif self.advertiPv:getCurPageIndex()==1 then
                           self._dian1:setSelected(false)
                           self._dian2:setSelected(true)
                           self._dian3:setSelected(false)
                         elseif self.advertiPv:getCurPageIndex()==2 then
                          self._dian1:setSelected(false)
                           self._dian2:setSelected(false)
                           self._dian3:setSelected(true)
                      end
                end
        end)

 print("11118989898989  999")
        local _advertiImg=advertiPa:getChildByTag(155)
        local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
        _advertiImg:loadTexture(path..tostring(Util:sub_str(jaclayer_data[1]["imageurl"], "/",":")))--
         self.tpid=jaclayer_data[1]["id"]
        Server:Instance():getgoldspoolbyid(self.tpid)
        LocalData:Instance():set_user_oid(self.tpid)
         self._jiliang:setString("1/"  ..  tostring(#jaclayer_data))
        --现在注销是因为后台返回一个图片
        if #jaclayer_data>=2 then
             for i=2, #jaclayer_data  do  --
                  local  call=advertiPa:clone() 
                  local advertiImg=call:getChildByTag(155)
                  advertiImg:loadTexture(path .. tostring(Util:sub_str(jaclayer_data[i]["imageurl"], "/",":")))--imgurl
                  self.advertiPv:addPage(call)   
            end
        end
          
         local left_bt=self.JackpotScene:getChildByTag(154)  --减
         left_bt:setTouchSwallowEnabled(true)

         left_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()-1)
              
        end)
        local right_bt=self.JackpotScene:getChildByTag(153)  --加
        right_bt:setTouchSwallowEnabled(true)
        right_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                 self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()+1)
                
        end)
         local back=self.JackpotScene:getChildByTag(137)  --返回
         back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                  if self._Xscnum then
                     print("11118989898989")
                     dump(self._Xscnum)
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._Xscnum)
                  end
                  if self._slowdown then
                       print("8989898989")
                       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._slowdown)--停止水果机定时器
                   end
                   -- self:removeFromParent()
                 Util:scene_control("GoldprizeScene")
                   
                   
        end)
 print("11118989898989  9997777")
         --中奖信息排行
        self._ListView=self.JackpotScene:getChildByTag(31):getChildByTag(35)--中奖信息排行
        self._ListView:setItemModel(self._ListView:getItem(0))
        self._ListView:removeAllItems()
          
           self:wininformation()
end
--中奖信息排行
function  JackpotLayer:wininformation(  )
            self._ListView:removeAllItems() 
            local _table=LocalData:Instance():get_getrecentgoldslist()
             print("11118989898989  99911111  ")
             dump(_table)
            local goldslist=_table["goldslist"]
            if goldslist==0 then
               return
            end

             for i=1,#goldslist do
                  self._ListView:pushBackDefaultItem()
                  local  cell = self._ListView:getItem(i-1)
                  cell:setTag(i)
                  local name=cell:getChildByTag(38)
                  name:setString(goldslist[i]["nickname"])
                  local _gold=cell:getChildByTag(39)
                  _gold:setString(goldslist[i]["golds"])
          end

end
function JackpotLayer:information( )
             local  list_table=LocalData:Instance():get_getgoldspoolbyid()
             if not list_table  or  not self.JackpotScene then
               return
             end
             local title=self.JackpotScene:getChildByTag(138)  --标题
             title:setString(tostring(list_table["title"]))

             local gold=self.JackpotScene:getChildByTag(140)  --剩余金币
             gold:setString(list_table["remaingolds"])

             self.car_num=self.JackpotScene:getChildByTag(33)  --翻倍卡数量
             self._carnum=tonumber(list_table["doublecardamount"])  
             self._doublecardamount=tonumber(list_table["doublecardamount"])  
             self.car_num:setString(self._carnum)


             self.began_bt=self.JackpotScene:getChildByTag(46)  --开始

             self.began_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
             self.end_bt=self.JackpotScene:getChildByTag(155)  --结束
             self.end_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
             --新的冷却倒计时
             self.coll_bg=self.JackpotScene:getChildByTag(373)  -- 新的冷却时间
             self.coll_text=self.coll_bg:getChildByTag(374)

             self.ordinary_bt=self.JackpotScene:getChildByTag(44)  --普通
             self.ordinary_bt:setBright(false)
             self.curr_bright=self.ordinary_bt
             self.ordinary_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              self.special_bt=self.JackpotScene:getChildByTag(45)  --翻倍
             self.special_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
             self._obtainbt=self.JackpotScene:getChildByTag(47)  --获取参与卷
             self._obtainbt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)

             self.be_num=self.JackpotScene:getChildByTag(999)  --参与卷
             self.playcardamount=tonumber(list_table["playcardamount"])
             self.be_num:setString(list_table["playcardamount"])  --
             self.coolingtime=list_table["coolingtime"]   --  0 可以玩  -1  今天不能玩
             self._obtainbt:setVisible(true)

             self.getcardamount  =  tonumber(list_table["getcardamount"])   --初始化 还可以得到几张参与卷

             local _table=LocalData:Instance():get_setgamerecord()
             local goldspool=_table["goldspool"]
             if goldspool  then
               self:vouchers(  ) --真正的刷新
              else
                  if tonumber(self.coolingtime) ~=  0   and  tonumber(self.coolingtime)~= -1  and  self.getcardamount~=2   then  --当coolingtime 不为-1  或 0 时开始进入倒计时
                         print("888888888    ")
                         self:Xfun_countdown()
                         self._obtainbt:setVisible(false)
                  end
             end
             

        

end
--  拼完图刷新数据哦 
function JackpotLayer:vouchers(  )
          print("5545645645644    8")
         local _table=LocalData:Instance():get_setgamerecord()--保存数据
         dump(_table)
         local goldspool=_table["goldspool"]    
         self.be_num:setString(goldspool["playcardamount"])  --参与卷  
         self.playcardamount=tonumber(goldspool["playcardamount"])  
         self._carnum=tonumber(goldspool["doublecardamount"])  --翻倍卡
         self._doublecardamount=tonumber(goldspool["doublecardamount"])  
         self.car_num:setString(self._carnum)

         self.coolingtime=goldspool["coolingtime"]  --冷却时间

         --以下由于后台getcardamount  不准  所以毙了
         -- self.getcardamount  = tonumber(goldspool["getcardamount"])
         -- if  self.getcardamount  >=0   then   --如果可以获取参与卷大于0   拼完图就出现开始按钮
         --     self.coll_bg:setVisible(false)   --这时候开始按钮出现
         --     self._obtainbt:setVisible(false)
         --     self.began_bt:setVisible(true)
         -- else    --否则就出现获取参与卷
         --    self._obtainbt:setVisible(true)    
         -- end  


          if  self.coolingtime  >=0   then   --如果冷却时间不为-1  说名拼完图还可以玩   拼完图就出现开始按钮
             self.coll_bg:setVisible(false)   --这时候开始按钮出现
             self._obtainbt:setVisible(false)
             self.began_bt:setVisible(true)
         else    --否则就出现获取参与卷
            self._obtainbt:setVisible(true)    
         end  



         
end
function JackpotLayer:touch_callback( sender, eventType )

      local tag=sender:getTag()
      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      if self.curr_bright:getTag()==tag then
                  return
       end
      if tag==46 then --开始
               
              self:act_began( )   
      elseif tag==44 then
            self.curr_bright=sender
            self.is_double=2
            print("普通")
            self.ordinary_bt:setBright(true)
            self.special_bt:setBright(false)
      elseif tag==45 then
            if self._carnum>0 then
               self.curr_bright=sender
               print("翻倍",self._carnum)
               self._carnum=self._carnum-1
               self.is_double=1
               self.ordinary_bt:setBright(false)
               self.special_bt:setBright(true)
            end
             Server:Instance():prompt("翻倍卡不足")
            self.car_num:setString(tostring(self._carnum) )
      elseif tag==155 then  --劲舞团结束  测试动画 
            self:fun_slowdown()
      elseif tag==47 then  --获取参与卷 
          --由于后端TNND这个字段getcardamount错误  于是乎只能毙了  
           -- if self.getcardamount  >= 2  then    --如果还可以得到两张 参与卷  点击参与卷直接进拼图
           --      local scene=GameScene.new({adid= self.tpid,type="audition",image=""})--拼图
           --     cc.Director:getInstance():pushScene(scene)
           --     LocalData:Instance():set_actid({act_id=self.tpid,image=" "})--保存数

           --       self.coll_bg:setVisible(false)   --这时候开始按钮出现
           --       self._obtainbt:setVisible(false)
           --       self.began_bt:setVisible(true)
           --  elseif self.getcardamount  == 1 then  --如果有一张的时候出现 TNND倒计时  
           --      self.coll_bg:setVisible(false)   --这时候开始按钮出现
           --      self._obtainbt:setVisible(false)
           --      self.began_bt:setVisible(true)
           --      self:Xfun_countdown() 
           --  else                 --如果没有可以得到的参与卷了  就出现提示界面 
           --      LocalData:Instance():set_user_time("1")  --主要是要确定点击后  要自动进入倒计时 
           --      Server:Instance():prompt("获取参与券的机会已经用完啦,继续拼图只能获得积分")  --  然后点击确定于是乎出现倒计时画面

           --  end



            if self.coolingtime  ==   0   and tonumber(self.getcardamount)  == 2 then    --如果冷却时间为0  点击参与卷直接进拼图  playcardamount
                local scene=GameScene.new({adid= self.tpid,type="audition",image=""})--拼图
               cc.Director:getInstance():pushScene(scene)
               LocalData:Instance():set_actid({act_id=self.tpid,image=" "})--保存数

                 self.coll_bg:setVisible(false)   --这时候开始按钮出现
                 self._obtainbt:setVisible(false)
                 self.began_bt:setVisible(true)
            elseif self.coolingtime  ==   10   and tonumber(self.getcardamount)  == 1    then  --如果大于0有一张的时候出现 TNND倒计时  
                self.coll_bg:setVisible(true)   --倒计时
                self._obtainbt:setVisible(false)
                self.coolingtime=10    --好任性的需求
                self:Xfun_countdown() 
            else                 --如果出现-1  说明不能玩了   就出现提示界面 
                LocalData:Instance():set_user_time("1")  --主要是要确定点击后  要自动进入倒计时 
                Server:Instance():prompt("获取参与券的机会已经用完啦,继续拼图只能获得积分")  --  然后点击确定于是乎出现倒计时画面

            end





      elseif tag==780 then
              
      end
      
end
--倒计时时间结束
 function JackpotLayer:Xcountdown()
       
           self._Xtime=self._Xtime-1
           self.coll_text:setString(tostring(self._Xtime) .. "S")
           if self._Xtime==0 then    --倒计时后要进入拼图
    
              local scene=GameScene.new({adid= self.tpid,type="audition",image=""})--拼图
              cc.Director:getInstance():pushScene(scene)
              LocalData:Instance():set_actid({act_id=self.tpid,image=" "})--保存数

             
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._Xscnum)--停止定时器
           end
end
--倒计时时间开始
function JackpotLayer:Xfun_countdown( )
   
        self.coll_text:setString(tostring(self.coolingtime)   ..   "S")
        self._Xtime=tonumber(self.coolingtime)

      self._Xscnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                if   self._Xscnum then
                                   self:Xcountdown()
                                end
                                
              end,1.0, false)
end

--劲舞团减速
 function JackpotLayer:slowdown()
         print("1111112")
               self.slowdown_num=self.slowdown_num-0.5
               self.roleAction:setTimeSpeed(self.slowdown_num)
               if self.slowdown_num<=0.5 then
                     self.slowdown_num=1
                      local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()   --_tablegods["golds"]
              
                     local userdt = LocalData:Instance():get_userdata()
                     userdt["golds"]=_tablegods["playergolds"] 
                    LocalData:Instance():set_userdata(userdt)  --增加金币数

                     if self.roleAction:getCurrentFrame()+2>self.glodreward[tostring(_tablegods["golds"])]  and  self.roleAction:getCurrentFrame()-2<self.glodreward[tostring(_tablegods["golds"])] then
                            self.roleAction:gotoFrameAndPause(self.glodreward[tostring(_tablegods["golds"])])
                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._slowdown)--停止定时器
                            self.shuiguo1:setVisible(false)
                            self.shuiguo2:setVisible(false)                
                         local function removeThis()
                          print("8888888  5555")
                            --出现获取参与卷 
                            self._obtainbt:setVisible(true)
                        end
                         self.shuiguo3:runAction( cc.Sequence:create(cc.Blink:create(3, 3),cc.CallFunc:create(removeThis)))
                     end
               end
end

function JackpotLayer:fun_slowdown( )
      self.glodreward ={["7"]=0,["10"]=5,["1000"]=10,["5"]=15,["15"]=20,["50"]=25,["20"]=30,["200"]=35,
                                ["9"]=40,["11"]=45,["500"]=50,["6"]=55,["19"]=60,["14"]=65,["16"]=70,["100"]=75}
      

      self.slowdown_num=3
      self._slowdown=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:slowdown()
              end,0.1, false)
end

function JackpotLayer:act_began( )

       Server:Instance():getgoldspoolrandomgolds(self.id,self.is_double)  --
       --此时结束按钮出现   
       self.end_bt:setVisible(true)
       self.began_bt:setVisible(false)
       self.coll_bg:setVisible(false)
       self._obtainbt:setVisible(false)

         
end
function JackpotLayer:cool_callback( sender, eventType)
      if eventType ~= ccui.TouchEventType.ended then
            return
      end
      local tag=sender:getTag()
      if tag==54 then --冷却返回
           

      elseif tag==53 then  
         
     
      end

end
function JackpotLayer:update(dt)
    
end
--下载图片
function JackpotLayer:init_pic(  )
        

         --以下是测试
          local  list_table=LocalData:Instance():get_getgoldspoollist()
          local  jac_data=list_table["goldspools"]
          for i=1,#jac_data do
              local _table={}
              _table["imageurl"]=jac_data[i]["imageurl"]
                      _table["max_pic_idx"]=#jac_data
                      _table["curr_pic_idx"]=i
                       Server:Instance():jackpotlayer_pic(jac_data[i]["imageurl"],_table) --下载图片
          end


         

end
function JackpotLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
          

end
function JackpotLayer:onEnter()
      --弹出提示框后出现 确定 进入拼图
      NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JIGSAWCOUNT, self,
                       function()
                         print("888888888    999")
                local scene=GameScene.new({adid= self.tpid,type="audition",image=""})--拼图
               cc.Director:getInstance():pushScene(scene)
               LocalData:Instance():set_actid({act_id=self.tpid,image=" "})--保存数
                      end)


  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self,
                       function()
                       self:init_pic()
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self,
                       function()
                      self:init()

                      end)
NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self,
                       function()
                         print("劲舞团")
                         self:information( )
                               
                      end)
--拼完图刷新的数据   这是个伪消息
NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.BACKSUPPOR, self,
                       function()
                              print("5545645645644    7")
                               --  self:vouchers(  )
                               
                      end)
  --劲舞团开启停止后返回的后台随机金币数量
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self,
                       function()
                           local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()
             
                          if self._doublecardamount>0   and self.is_double==1 then
                              
                             self._doublecardamount= _tablegods["doublecardamount"]  --  翻倍卡刷新
                             self.car_num:setString(tostring(self._doublecardamount))

                          end   
                          self.coolingtime=_tablegods["coolingtime"]
                          self.getcardamount=_tablegods["getcardamount"]
                          self.playcardamount= _tablegods["playcardamount"]  --参与卷
                           self.roleAction:setTimeSpeed(5)
                           self.roleAction:gotoFrameAndPlay(0,75, true)
                           self.be_num:setString(tostring(self.playcardamount))
                           self.shuiguo1:setVisible(false)
                           self.shuiguo2:setVisible(false)
                    
               
                        end)
end
function JackpotLayer:onExit()
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.BACKSUPPOR, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JIGSAWCOUNT, self)
end


return JackpotLayer