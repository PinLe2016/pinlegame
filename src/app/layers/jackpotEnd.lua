--
-- Author: peter
-- Date: 2016-10-12 17:19:13

--  奖池结束界面
local jackpotEnd = class("jackpotEnd", function()
            return display.newScene("jackpotEnd")
end)



function jackpotEnd:pushFloating(text)
    if is_resource then
        self.floating_layer:showFloat(text)  
        
    else
        if self.barrier_bg then 
            self.barrier_bg:setVisible(false)
        end
        self.floating_layer:showFloat(text)
    end
end 

function jackpotEnd:push_buffer(is_buffer)

       self.floating_layer:show_http(is_buffer) 
       
end 
function jackpotEnd:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end

function jackpotEnd:ctor(params)
  self._dtid=params._dtid
  self.choose=params.choose   
  self.image_name=params.image_name   
  self:setNodeEventEnabled(true)--layer添加监听     
  self.floating_layer = require("app.layers.FloatingLayer").new()
  self.floating_layer:addTo(self,100000)
  -- Server:Instance():getgoldspoolreward(self._dtid)  --   发送请求
     local _table=LocalData:Instance():get_getgoldspoolreward()--保存数据
     local goldspool=_table["goldspool"]  --
    self.choose  = tonumber(goldspool["gametype"])   --gametype  1-打地鼠 2-拼图
  if self.choose==2  then
        self.puzzleEndLayer = cc.CSLoader:createNode("puzzleEndLayer.csb")
        self:addChild(self.puzzleEndLayer)
        self.roleAction = cc.CSLoader:createTimeline("puzzleEndLayer.csb")
        self.puzzleEndLayer:runAction(self.roleAction)
        self.roleAction:setTimeSpeed(0.3)
        self.roleAction:gotoFrameAndPlay(0,31, true)
        self:function_puzzle()
   else
        self.HitVolesEndLayer = cc.CSLoader:createNode("HitVolesEndLayer.csb")
        self:addChild(self.HitVolesEndLayer)
        self.roleAction = cc.CSLoader:createTimeline("HitVolesEndLayer.csb")
        self.HitVolesEndLayer:runAction(self.roleAction)
        self.roleAction:gotoFrameAndPlay(0,31, true)
        self.roleAction:setTimeSpeed(0.3)
        self:function_HitVolesEnd()
   end
       
end


--打地鼠结束界面self.Points
function jackpotEnd:function_HitVolesEnd(  )
            local _bt=self.HitVolesEndLayer:getChildByTag(69) 
            _bt:setTouchEnabled(false)
            _bt:setVisible(false)
             --_bt:setVisible(false)
             local _bt1=_bt:getChildByTag(71)
             _bt1:setVisible(false) 
             local _bt2=_bt:getChildByTag(70) 
             _bt2:setVisible(false)
               local back=self.HitVolesEndLayer:getChildByTag(776)  --  返回
               back:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
               local show=self.HitVolesEndLayer:getChildByTag(258)  --  炫耀
               show:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
               local secondcount=self.HitVolesEndLayer:getChildByTag(256)  --  再来一局
               secondcount:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
                local _table=LocalData:Instance():get_getgoldspoolreward()--保存数据
                local goldspool=_table["goldspool"]

                 local _advertiImg=self.HitVolesEndLayer:getChildByTag(201)  --  上面广告图
                _advertiImg:loadTexture(self.image_name) 
                _advertiImg:setTouchEnabled(false)
                _bt:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
                if goldspool["addetailurl"] then
                  _bt:setTouchEnabled(true)
                  _bt:setVisible(true)
                  self.addetailurl=goldspool["addetailurl"]
                end

               local labelAtlas=self.HitVolesEndLayer:getChildByTag(255) --分数
               labelAtlas:setVisible(false)
              local  dishu_score = ccui.TextAtlas:create()
              self.dadishujinbi=dishu_score
              dishu_score:setAnchorPoint(0,0.5)
              dishu_score:setPosition(cc.p(labelAtlas:getPositionX(),labelAtlas:getPositionY()))  
              dishu_score:setProperty( tostring(goldspool["poolgolds"]),"png/dadishufenshu.png", 24, 26, "0")  --tostring(self.friendlist_num["friendcount"]),
              self.HitVolesEndLayer:addChild(dishu_score) 

              local _jinbitupian=self.HitVolesEndLayer:getChildByTag(196):getChildByTag(254)  
              local ranking=self.HitVolesEndLayer:getChildByTag(272)  --  %数
              ranking:setString(goldspool["myscore"])
               local _score=self.HitVolesEndLayer:getChildByTag(78)  --   分数
              _score:setString(tostring(goldspool["gamescore"]))
              self:star_action()
end

-- 拼图结束界面
function jackpotEnd:function_puzzle(  )
             local _bt=self.puzzleEndLayer:getChildByTag(1324) 
             _bt:setVisible(false)
             _bt:setTouchEnabled(false)
         
             local _bt1=_bt:getChildByTag(1325)
             _bt1:setVisible(false) 
             local _bt2=_bt:getChildByTag(1326) 
             _bt2:setVisible(false)

             local _table=LocalData:Instance():get_getgoldspoolreward()--保存数据
             local goldspool=_table["goldspool"]

              local time=self.puzzleEndLayer:getChildByTag(513)  --  时间
              time:setString(tostring(goldspool["gamescore"]) )

              local _advertiImg=self.puzzleEndLayer:getChildByTag(356)  --  上面广告图
              _bt:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
              _advertiImg:setTouchEnabled(false)
              _advertiImg:loadTexture(self.image_name) 
            if goldspool["addetailurl"] then
                _bt:setTouchEnabled(true)
                    _bt:setVisible(true)
                self.addetailurl=goldspool["addetailurl"]
              end

           local back=self.puzzleEndLayer:getChildByTag(305)  --  返回
             back:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
             local show=self.puzzleEndLayer:getChildByTag(756)  --  炫耀
             show:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
             local secondcount=self.puzzleEndLayer:getChildByTag(755)  --  再来一局
             secondcount:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)

              local labelAtlas =self.puzzleEndLayer:getChildByTag(1332)  --    获得金币数
              labelAtlas:setVisible(false)   
              local  dishu_score = ccui.TextAtlas:create()
              self.pintujinbi=dishu_score
              dishu_score:setAnchorPoint(0,0.5)
              dishu_score:setPosition(cc.p(labelAtlas:getPositionX(),labelAtlas:getPositionY()))  
              dishu_score:setProperty( tostring(goldspool["poolgolds"]),"png/dadishufenshu.png", 24, 26, "0")  --tostring(self.friendlist_num["friendcount"]),
              self.puzzleEndLayer:addChild(dishu_score) 

              local _jinbitupian=self.puzzleEndLayer:getChildByTag(293):getChildByTag(1331)  
              local win_text=self.puzzleEndLayer:getChildByTag(514)  -- 战胜%
              win_text:setString(tostring(goldspool["myscore"]))
              self:star_action()
end

--  结束界面返回按钮
function jackpotEnd:fun_callback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                 return
            end
            local tag=sender:getTag()
            if tag==69 then
               self:fun_storebrowser()
            elseif tag==1324 then 
               self:fun_storebrowser()
            elseif tag==776 then 
               Util:scene_control("GoldprizeScene")
               Util:all_layer_backMusic()
            elseif tag==258 then 
               self.share=Util:share(1)
            elseif tag==305 then 
              Util:all_layer_backMusic()
               Util:scene_control("GoldprizeScene")
            elseif tag==756 then 
               self.share=Util:share(1)
            end
end
--  网页链接
function jackpotEnd:fun_storebrowser(  )
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      self.Storebrowser:setTag(1314)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                  end
                  self:removeChildByTag(1314, true)
            end)
              self.share=cc.UM_Share:create()
              self.Storebrowser:addChild(self.share)
              self.share:add_WebView(tostring(self.addetailurl),cc.size(store_size:getContentSize().width ,store_size:getContentSize().height),
               cc.p(store_size:getPositionX(),store_size:getPositionY()))
             -- self.Storebrowser:setScale(0.1)
end

function jackpotEnd:star_action()
      local _table=LocalData:Instance():get_getgoldspoolreward()--保存数据
      local goldspool=_table["goldspool"]
       local  xingnumber=0
       if self.choose==2 then
            if tonumber(goldspool["gamescore"]) >31  then
              xingnumber=1
            elseif tonumber(goldspool["gamescore"]) >= 0  and  tonumber(goldspool["gamescore"])<10 then
              xingnumber=3
            elseif tonumber(goldspool["gamescore"]) >= 11  and  tonumber(goldspool["gamescore"])<=30 then
              xingnumber=2
             end       
      else
         if tonumber(goldspool["gamescore"]) >= 250  then
          xingnumber=3
        elseif tonumber(goldspool["gamescore"]) >= 0  and  tonumber(goldspool["gamescore"])<100 then
          xingnumber=1
        elseif tonumber(goldspool["gamescore"]) >= 100  and  tonumber(goldspool["gamescore"])<=249 then
          xingnumber=2
         end
      end

      self.star_over_time=xingnumber

              local point_buf={
                cc.p(186.50,1040),
                cc.p(320,1080),
                cc.p(459.50,1040)
              }

              local star_buf={}
            
              for i=1,xingnumber do
                local spr=display.newSprite("dadishu-wanfajieshao-xinxin.png")
                spr:setPosition(point_buf[i].x,point_buf[i].y)
                spr:setScale(1)
                self:addChild(spr)
                star_buf[i]=spr
                if i==1 then
                  spr:setRotation(45)
                elseif i==3 then
                  spr:setRotation(-45)
                end
                
              end

          
                        
                 
end

function jackpotEnd:onEnter()

  -- NotificationCenter:Instance():AddObserver("GETGOLDSPOOLREWARD", self,
  --                      function()
  --                               if self.choose==1  then
  --                                     self:function_puzzle()
  --                               else
  --                                     self:function_HitVolesEnd()
  --                               end
  --                     end)
end

function jackpotEnd:onExit()
     --NotificationCenter:Instance():RemoveObserver("GETGOLDSPOOLREWARD", self)
     
end


return jackpotEnd




