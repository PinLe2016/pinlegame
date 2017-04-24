--
-- Author: peter
-- Date: 2016-12-16 17:22:33
--
--客服
local CustomerLayer = class("CustomerLayer", function()
            return display.newLayer("CustomerLayer")
end)

function CustomerLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听

            self:init()
end

function CustomerLayer:init(  )
       self.customerLayer = cc.CSLoader:createNode("CustomerLayer.csb")
       self:addChild(self.customerLayer)

       self.back_bt=self.customerLayer:getChildByTag(1063)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

        self.customer_list=self.customerLayer:getChildByTag(969)--列表
        self.customer_list:setItemModel(self.customer_list:getItem(0))
        self.customer_list:removeAllItems()
         for i=1,2 do
         	self.customer_list:pushBackDefaultItem()
            local  cell = self.customer_list:getItem(i-1)
            cell:setTag(i) 
            cell:addTouchEventListener(function(sender, eventType  )
                                    self:callback(sender, eventType)
            end)
            local name_image=cell:getChildByTag(975)--名称
             name_image:loadTexture("png/kefuzhongxing-gonglue-"  ..   i    ..    ".png")
             
             if i==2  and  tonumber(cc.UserDefault:getInstance():getStringForKey("WeChat_landing","0"))  ==  1 then
               cell:setVisible(false)
             end

         end

end
function CustomerLayer:callback( sender, eventType )
          local tag=sender:getTag()
          if eventType ~= ccui.TouchEventType.ended then
                 sender:getChildByTag(975):loadTexture("png/kefuzhongxing-gonglue-1"  ..   tag    ..    ".png")
                 sender:getChildByTag(972):setVisible(true)
                return
          end
          sender:getChildByTag(975):loadTexture("png/kefuzhongxing-gonglue-"  ..   tag    ..    ".png")
          sender:getChildByTag(972):setVisible(false)
          if tag==1 then
          	  print("攻略")
              local ForhelpLayer = require("app.layers.ForhelpLayer") --兑换帮助
              self:addChild(ForhelpLayer.new(),1,12)
          elseif tag==2 then
          	  print("修改密码")
          	   local ChangepasswordLayer = require("app.layers.ChangepasswordLayer") --修改密码
               self:addChild(ChangepasswordLayer.new(),1,12)
          elseif tag==3 then
          	  print("兑换帮助")
              self:fun_showtip(sender,sender:getPositionX()+  sender:getContentSize().width/2   ,sender:getPositionY() + sender:getContentSize().height/2 )
          	  -- local ForhelpLayer = require("app.layers.ForhelpLayer") --兑换帮助
             --   self:addChild(ForhelpLayer.new(),1,12)
          end
         
end
function CustomerLayer:fun_showtip(bt_obj,_x,_y )
          if self.showtip_image~=nil then
            return
          end
          self.showtip_image= display.newSprite("png/jingqingqidai-zi.png")
          self.showtip_image:setScale(0)
          self.showtip_image:setAnchorPoint(0, 0)
          bt_obj:addChild(self.showtip_image)
          self.showtip_image:setPosition(_x, _y)

          local function removeThis()
                if self.showtip_image then
                   self.showtip_image:removeFromParent()
                   self.showtip_image=nil
                end
          end
          local actionTo = cc.ScaleTo:create(0.5, 1)
          self.showtip_image:runAction( cc.Sequence:create(actionTo,cc.DelayTime:create(0.3 ),cc.CallFunc:create(removeThis)))
end

function CustomerLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==1063 then
          	self:removeFromParent()
            Util:all_layer_backMusic()
          end
         
          

end
function CustomerLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function CustomerLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 cc.Director:getInstance():getTextureCache():removeAllTextures() 
end


return CustomerLayer