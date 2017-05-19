--
-- Author: peter
-- Date: 2017-05-18 17:30:10
--
--  新版惊喜吧  活动详情

local SurpriseNode_Detail = class("SurpriseNode_Detail", function()
            return display.newLayer("SurpriseNode_Detail")
end)

function SurpriseNode_Detail:ctor(params)
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
       Server:Instance():getactivitybyid(params.id,0)
       Server:Instance():getactivityadlist(params.id)
end

function SurpriseNode_Detail:fun_init( ... )
	self.SurpriseNode_Detail = cc.CSLoader:createNode("SurpriseNode_Detail.csb");
	self:addChild(self.SurpriseNode_Detail)
	self:fun_radio()
	--  事件初始化
	--  返回按钮
	local btn_Back=self.SurpriseNode_Detail:getChildByName("btn_Back")
          	btn_Back:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              self:removeFromParent()
            end)
            --  点击查看更多
            local btn_Link=self.SurpriseNode_Detail:getChildByName("btn_Link")
          	btn_Link:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("点击查看更多")
            end)
            --  合成
            local btn_Fit=self.SurpriseNode_Detail:getChildByName("btn_Fit")
          	btn_Fit:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("合成")
            end)
            --  奖项预览
            local btn_Gift=self.SurpriseNode_Detail:getChildByName("btn_Gift")
          	btn_Gift:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("奖项预览")
            end)
            --  GO
            local btn_Start=self.SurpriseNode_Detail:getChildByName("btn_Start")
          	btn_Start:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("GO")
            end)
            --  好友助力
            local btn_Share=self.SurpriseNode_Detail:getChildByName("btn_Share")
          	btn_Share:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("好友助力")
            end)
end
--  广播 跑马灯
function SurpriseNode_Detail:fun_radio( ... )
     local braodWidth = 150 --跑马灯的长度   
    local label = cc.Label:createWithSystemFont("跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯跑马灯","Microsoft YaHei",25)   
     label:setPosition(cc.p(0, 0))   
     label:setAnchorPoint(cc.p(0,0))   
    local labelWidth = label:getContentSize().width   
    local time = 3 -- 这里可以根据label多长动态计算时间   
    local scrollViewLayer = cc.Layer:create()
    scrollViewLayer:setPosition(cc.p(0,0))   
    scrollViewLayer:setContentSize(label:getContentSize())   
  
    local scrollView1 = cc.ScrollView:create()   
    if nil ~= scrollView1 then   
        scrollView1:setViewSize(cc.size(braodWidth, 100))   
        scrollView1:setPosition(cc.p(display.cx, display.cy))   
        scrollView1:setDirection(cc.SCROLLVIEW_DIRECTION_NONE )   
        scrollView1:setClippingToBounds(true)   
        scrollView1:setBounceable(true)  
         scrollView1:setTouchEnabled(false)   
    end   
    scrollView1:addChild(label)   
    self:addChild(scrollView1)   
  
    if nil ~= scrollViewLayer_ then   
        scrollView1:setContainer(scrollViewLayer)   
        scrollView1:updateInset()   
    end   
  
    if labelWidth > braodWidth  then   
     local leftAction = cc.MoveBy:create(time,cc.p(braodWidth -labelWidth ,0))   
     local rightAction = cc.MoveBy:create(time,cc.p(labelWidth - braodWidth ,0))   
     local seqAction = cc.Sequence:create(leftAction,rightAction)   
     label:runAction(cc.RepeatForever:create(seqAction))   
    end   

end
function SurpriseNode_Detail:onEnter()
   
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
  --                      function()
  --                                 self:data_init()
  --                     end)
end

function SurpriseNode_Detail:onExit()
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      
end

return SurpriseNode_Detail




