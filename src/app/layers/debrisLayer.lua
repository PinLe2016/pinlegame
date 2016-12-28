--
-- Author: peter
-- Date: 2016-06-07 11:13:42
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:45:58
--
--[[--传入必要参数
    params.filename   图片名
     params.row          图片切割竖行
     params.col            图片切割横
     params._size         图片大小
]]
local debrisLayer = class("debrisLayer", function()
    return display.newLayer()
end)
function debrisLayer:ctor(params)
    -- dump(params)
       self:setNodeEventEnabled(true)--layer添加监听
        self.filename=  params.filename
        self.point=params.point
        self._size=params._size
        self.row=params.row
        self.adid=params.adid
        self.col=params.col
        self.count=params.row * params.col
        local path=cc.FileUtils:getInstance():getWritablePath()
        if params.adownerid then
          self.adownerid=params.adownerid
          self.goldspoolcount=params.goldspoolcount
        end  
           if params.pintuid then
          self.pintuid=params.pintuid 
        end  
       
        
        --math.randomseed(tostring(os.time()):reverse():sub(1, 7))--随机种子
        math.randomseed(os.time()) 

        self.content_size = self._size
         self.tp=params.tp
         self.type=params.type
        print("开心  ",self.tp)


        self.fragment_table={}
        self.fragment_poins={}
        self.fragment_success={}
        self.fragment_col={}
        self.fragment_row={}
         self:sort_sure()--正确排序加载
         self:refresh_table()
         self.count_time=0  --时间
         self.theycount =0  --步数
         schedulHandledeb=nil
         schedulHandledeb =  cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )                              
                                     self.count_time=self.count_time+1    
              end,1, false)
end


function debrisLayer:refresh_table()

    local row_rand=self:RandomIndex(self.row,self.row)
    local col_rand=self:RandomIndex(self.col,self.col)

    local pos_x, pos_y =self.point.x,self.point.y
    local row ,col =self.row,self.col 
     local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
   for i=1,row do
        for j=1,col do
                -- local fragment_sprite = display.newScale9Sprite(path..self.filename, 0,0, cc.size(self._size.width,self._size.height))
                local fragment_sprite = display.newSprite(path..self.filename)
                fragment_sprite:setScaleX(0.703)
                fragment_sprite:setScaleY(0.703)

                fragment_sprite:setAnchorPoint(0, 0)
                local po = self._size
                local rect = cc.rect(0,0, po.width/row-3, po.height/col-3)
                --创建一个裁剪区域用于裁剪图块
                local clipnode = cc.ClippingRegionNode:create()
                clipnode:setClippingRegion(rect)--设置裁剪区域的大小
                clipnode:setContentSize(self.content_size.width/row-3, self.content_size.height/col-3)
                clipnode:addChild(fragment_sprite)--添加图片
                -- clipnode:setAnchorPoint(0.5,0.5)
                fragment_sprite:setPosition(0 - (i-1)*self.content_size.width/row, 0 - (j-1)*self.content_size.height/col)--设置图片显示的部分
                self:addChild(clipnode)
               
                clipnode:setTag(#self.fragment_table + 1)
                self.fragment_poins[#self.fragment_table + 1]=cc.p(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                self.fragment_table[#self.fragment_table + 1] = clipnode

                clipnode:setPosition(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                --clipnode:setPosition(pos_x + (i-1)*po.width/row, pos_y + (j-1)*po.height/col)


                clipnode:setTouchEnabled(true)
                clipnode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                                        --self:touch_event(clipnode,event)--监听回调
                                        local position = cc.p(clipnode:getPosition())
                                        local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

                                        if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                                
                                                clipnode:setTouchSwallowEnabled(false)
                                                return false
                                        end

                                        if "began" == event.name then
                                                clipnode:setTouchSwallowEnabled(false)--吞噬触摸，防止响应下层的图块。
                                                clipnode:setLocalZOrder(4)
                                                return true
                                        elseif "moved" == event.name then
                                              self:touch_event_move(event,clipnode)
                                        elseif "ended" == event.name then
                                                self:touchEnd(event,clipnode)

                                        end
                            end)

                end
       end  
end
function debrisLayer:RandomIndex(indexNum, tabNum)

    indexNum = indexNum or tabNum

    local t = {}

    local rt = {}

    for i = 1,indexNum do
        math.randomseed(os.time()) 
        local ri = math.random(1,tabNum + 1 - i)

        local v = ri

        for j = 1,tabNum do

            if not t[j] then

                ri = ri - 1

                if ri == 0 then

                    table.insert(rt,j)

                    t[j] = true

                end

            end

        end
   end
    --dump(rt)
    return rt
  
end

function debrisLayer:touch_event_move(event,clipnode)
        local pos_x, pos_y = clipnode:getPosition()
        pos_x = pos_x + event.x - event.prevX
        pos_y = pos_y + event.y - event.prevY
        if pos_x < display.left or pos_x > display.right + self.content_size.width/self.row then
            pos_x = pos_x - event.x + event.prevX
        end
        if pos_y < display.bottom or pos_y > display.top + self.content_size.height/self.col then
            pos_y = pos_y - event.y + event.prevY
        end
        clipnode:setPosition(pos_x, pos_y)        
end
function debrisLayer:sort_sure()
    local po =self._size
    -- dump(po)
    local pos_x, pos_y = self.point.x,self.point.y
    local dex = 1
    for i=1,self.row do --
        for j=1,self.col do --hang
            self.fragment_success[dex]=cc.p(pos_x + (i-1)*po.width/self.row, pos_y + (j-1)*po.height/self.col)
            dex=dex+1
        end
    end
     
end
function debrisLayer:touchEnd(event,clipnode,pos)
       
        -- dump(clipnode:getPosition())
        clipnode:setLocalZOrder(3)
        -- dump(tonumber(clipnode:getTag()))
        
    for i=1,#self.fragment_table do
        local clipnode_1=self.fragment_table[i]
        local position = cc.p(clipnode_1:getPosition())
        local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col)
        if cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) and tonumber(clipnode:getTag())~= tonumber(clipnode_1:getTag()) then
            -- dump(self.fragment_poins[tonumber(clipnode_1:getTag())])
            -- dump(self.fragment_poins[tonumber(clipnode:getTag())])
             self.theycount=self.theycount+1
             clipnode:setPosition(self.fragment_poins[tonumber(clipnode_1:getTag())])
             clipnode_1:setPosition(self.fragment_poins[tonumber(clipnode:getTag())])
           
            self.fragment_poins[tonumber(clipnode:getTag())]=cc.p(clipnode:getPosition())
            self.fragment_poins[tonumber(clipnode_1:getTag())]=cc.p(clipnode_1:getPosition())
            -- return
        end
    end

    clipnode:setPosition(self.fragment_poins[tonumber(clipnode:getTag())])

    self:saw_issuccess()
end

function debrisLayer:saw_issuccess()

    for i=1,#self.fragment_poins do
        local pos=self.fragment_poins[i]
        local pos_suss=self.fragment_success[i]
        if (math.floor(pos.x)~=math.floor(pos_suss.x) or math.floor(pos.y)~=math.floor(pos_suss.y) ) then 

                 --  local _originalimage = cc.CSLoader:createNode("originalimage.csb")
                 --  _originalimage:setPosition(cc.p(self.point.x,self.point.y))
                 -- local original=_originalimage:getChildByTag(118)
                 -- local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
                 -- original:loadTexture(path .. tostring(self.filename))-- 任性的记住更换原图
                 -- self:addChild(_originalimage,900)

                 --   local function stopAction()
                 --             if self.type=="surprise" then
                 --                        Util:scene_controlid("SurpriseOverScene",{id=self.adid,tp=" "})
                 --                         return
                 --            end
                 --            print("jdfjskdjf  ",self.adid)
                 --          Server:Instance():setgamerecord(self.adid)  
                 --            -- local jackpotlayer= jackpotlayer.new({id=self.adid,  adownerid=self.adownerid,goldspoolcount= self.goldspoolcount })
                 --            -- self:addChild(jackpotlayer)   --  奖池详情

                 --   end
                 --  local callfunc = cc.CallFunc:create(stopAction)
                 -- self:runAction(cc.Sequence:create(cc.DelayTime:create(2),callfunc  ))
                 

            return
        end
    end
    print("成功")  --self.adid
                 -- self:fun_endanimation()
                   cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulHandledeb)
                     LocalData:Instance():setTheycount(self.theycount)
                 local _originalimage = cc.CSLoader:createNode("originalimage.csb")
                  _originalimage:setPosition(cc.p(self.point.x,self.point.y))
                 local original=_originalimage:getChildByTag(118)
                 local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
                 original:loadTexture(path .. tostring(self.filename))-- 任性的记住更换原图
                 self:addChild(_originalimage,900)

                   local function stopAction()
                             LocalData:Instance():setpuzzletime(self.count_time)
                             if self.type=="surprise" then
                                        Util:scene_controlid("SurpriseOverScene",{id=self.adid,tp=" "})
                                         return
                            end
                          Server:Instance():setgamerecord(self.adid,0,0,self.count_time)  
                   end
                  local callfunc = cc.CallFunc:create(stopAction)
                 self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),callfunc  ))
                 
end
function debrisLayer:fun_endanimation()
      self._endanimation = cc.CSLoader:createNode("endanimation.csb")
      self._endanimation:setPosition(cc.p(self.point.x,self.point.y))
      self:addChild(self._endanimation)
      self.endanimation = cc.CSLoader:createTimeline("endanimation.csb")
      self.endanimation:setTimeSpeed(0.2)
      self._endanimation:runAction(self.endanimation)
      self.endanimation:gotoFrameAndPlay(0,60, true)

      local  cliper = cc.ClippingNode:create()
      local  _content=self._endanimation:getChildByTag(263)
      _content:setVisible(false)
      local content = display.newSprite("png/end_biaoti.png")
      content:setPosition(cc.p(_content:getPositionX(),_content:getPositionY()))
      local  stencil = content

      local spark = display.newSprite("png/endguang.png")
      spark:setPosition(cc.p(_content:getPositionX()-content:getContentSize().width/2,_content:getPositionY()));
     -- spark:setColor(cc.c3b(250,100,30))
      cliper:setAlphaThreshold(0.5)
      cliper:setStencil(stencil)
      cliper:addChild(content)
      cliper:addChild(spark)

      self._endanimation:addChild(cliper)

      local moveTo = cc.MoveTo:create(4,cc.p(_content:getPositionX()+content:getContentSize().width/2,_content:getPositionY()))
      local moveBack = cc.MoveTo:create(4,cc.p(_content:getPositionX()-content:getContentSize().width/2,_content:getPositionY()))  --moveTo:reverse()  --
      local seq1=cc.Sequence:create(cc.FadeIn:create(4),cc.FadeOut:create(4))  --FadeOut
      local seq = cc.Sequence:create(moveTo,moveBack)
      local spawn = cc.Spawn:create( seq,seq1)
      local SpeedTest_action1 = cc.Speed:create(cc.RepeatForever:create(spawn), 2.0)
      spark:runAction(SpeedTest_action1)
end  
--增加幸运卡
function debrisLayer:add_reward( )
        self.Rewardvouchers = cc.CSLoader:createNode("Rewardvouchers.csb")
        self.Rewardvouchers:setPosition(cc.p(-150000,10))
        self.Rewardvouchers:setVisible(false)
        self:addChild(self.Rewardvouchers,10000)
        local jique=self.Rewardvouchers:getChildByTag(421)
        local jinyan=self.Rewardvouchers:getChildByTag(102)
        

        


         self.began_bt=self.Rewardvouchers:getChildByTag(421):getChildByTag(425)  --立即参与
         self.began_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

        self.again_bt=self.Rewardvouchers:getChildByTag(421):getChildByTag(426)  --再来一局
         self.again_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)


         self.jbegan_bt=self.Rewardvouchers:getChildByTag(102):getChildByTag(106)  --返回奖池
         self.jbegan_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

        self.jagain_bt=self.Rewardvouchers:getChildByTag(102):getChildByTag(107)  --经验再来一局
         self.jagain_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

         local _table=LocalData:Instance():get_setgamerecord()--保存数据
         if   not _table["goldspool"] then
             return
         end
          local goldspool=_table["goldspool"]
         --  print("开始",tonumber(goldspool["coolingtime"]))
         -- if tonumber(goldspool["coolingtime"]) ==  -1 then
         --       jique:setVisible(false)
         --       jinyan:setVisible(true)
         -- else
         --       jique:setVisible(true)
         --       jinyan:setVisible(false)
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS)  --发送消息  进入奖项详情 
               
         --end
end


function debrisLayer:touch_callback( sender, eventType )
          local tag=sender:getTag()

      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      if tag==425 then --立即参与

          if self.Rewardvouchers then
              self.Rewardvouchers:removeFromParent()
          end
              cc.Director:getInstance():popScene()
              Server:Instance():getgoldspoolbyid(LocalData:Instance():get_user_oid())
              Server:Instance():sceneinformation()            
      elseif tag==426 then   --再来一局
         local _table=LocalData:Instance():get_actid()--保存数
         local scene=GameScene.new({adid=_table["act_id"],type="audition",image=_table["image"]})
         cc.Director:getInstance():popScene()
         cc.Director:getInstance():pushScene(scene)
       elseif tag==106 then   --返回奖池
           if self.Rewardvouchers then
              self.Rewardvouchers:removeFromParent()
              Util:all_layer_backMusic()
          end
           -- cc.Director:getInstance():popScene()
           -- Server:Instance():sceneinformation()
           Util:scene_control("GoldprizeScene")     --  返回奖池首图列表
          
       elseif tag==107 then   --再来一局
        --Server:Instance():setgamerecord(self.adid) 
         -- local _table=LocalData:Instance():get_actid()--保存数
         -- local scene=GameScene.new({adid=self.adid,type="audition",image= ""})
         --  local scene=GameScene.new({adid= LocalData:Instance():get_user_oid(),type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount})--拼图
         -- cc.Director:getInstance():popScene()
         -- cc.Director:getInstance():pushScene(scene)
--Util:scene_controlid("GameScene",{adid= self.adid,type="audition",img=self.image_name,image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose})

         GameScene = require("app.scenes.GameScene")--惊喜吧
          local scene=GameScene.new({adid=self.pintuid,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=1})--拼图
          cc.Director:getInstance():replaceScene(scene)
          LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
             
     end

end
function debrisLayer:onEnter()

              NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self,
                       function()
                              
                               self:add_reward( )
                      end)


end

function debrisLayer:onExit()

                NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self)
end

return debrisLayer
