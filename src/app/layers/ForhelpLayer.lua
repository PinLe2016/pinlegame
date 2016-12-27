--
-- Author: peter
-- Date: 2016-12-16 18:01:43
-- Date: 2016-12-16 17:57:38
--
--兑换帮助
local ForhelpLayer = class("ForhelpLayer", function()
            return display.newLayer("ForhelpLayer")
end)

function ForhelpLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听

      
            self._tableTitle={"金币如何获取","封号解封方式","在线商城兑换","惊喜吧中奖"}
            self._neirong={"途径1:玩家通过参与奖吃活动获取金币\n途径2:玩家通过邀请好友获取金币\n途径3:玩家通过被邀请人反馈金币\n途径4:玩家通过成长树获取金币\n途径5:玩家通过签到获取金币",
                                      "玩家使用外挂或者第三方软件将被官方永久封禁",
                                      "点击商城，玩家通过消耗游戏内部金币换取",
                                      "惊喜吧活动结束，玩家在我的活动或者结束活动列表点击兑奖名称，可查看自己是否中奖"
                                    }
            self:init()
end

function ForhelpLayer:init(  )

       self.forhelp= cc.CSLoader:createNode("ForhelpLayer.csb")
       self:addChild(self.forhelp)

       self.back_bt=self.forhelp:getChildByTag(672)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self.panel_bg=self.forhelp:getChildByTag(787)   --  面板
       self.panel_bg:setVisible(false)
       self.callback_bt=self.panel_bg:getChildByTag(788)   --  面板返回
       self.callback_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

        self._list=self.forhelp:getChildByTag(543)--列表
        self._list:setItemModel(self._list:getItem(0))
        self._list:removeAllItems()
       for i=1,4 do
            self._list:pushBackDefaultItem()
            local  cell = self._list:getItem(i-1)
            cell:setTag(i) 
            local  _title = cell:getChildByTag(670)
            _title:setString(self._tableTitle[i])
            cell:addTouchEventListener(function(sender, eventType  )
                                    self:callback(sender, eventType)
            end)
       end
end

function ForhelpLayer:callback( sender, eventType )
          local tag=sender:getTag()
          if eventType ~= ccui.TouchEventType.ended then
                 
                 sender:getChildByTag(785):setVisible(true)
                return
          end
          sender:getChildByTag(785):setVisible(false)
          self.panel_bg:setVisible(true)
          local  neitong_text=self.panel_bg:getChildByTag(792):getChildByTag(793)
          neitong_text:setString(self._neirong[tag])
         
end



function ForhelpLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==672 then
            Util:all_layer_backMusic()
            
          	self:removeFromParent()
          elseif tag==788 then
            self.panel_bg:setVisible(false)
          end
end
function ForhelpLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ForhelpLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 
end


return ForhelpLayer
