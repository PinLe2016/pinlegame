--
-- Author: peter
-- Date: 2016-08-18 11:02:04
--
--邮箱
local mailLayer = class("mailLayer", function()
            return display.newLayer("mailLayer")
end)

function mailLayer:ctor()

         self:setNodeEventEnabled(true)--layer添加监听
         self.sur_pageno=1
         Server:Instance():getaffichelist(self.sur_pageno)
          LocalData:Instance():set_getaffiche(nil)

end
function mailLayer:init(  )
	local affiche=LocalData:Instance():get_getaffiche()
	local affichelist=affiche["affichelist"]
	self.mailLayer = cc.CSLoader:createNode("mailLayer.csb")
            self:addChild(self.mailLayer)

            local back_bt=self.mailLayer:getChildByTag(46)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
			self:removeFromParent()
                        end)
            local delete_bt=self.mailLayer:getChildByTag(54)--删除
            delete_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
			local affiche=LocalData:Instance():get_getaffiche()
	                        local affichelist=affiche["affichelist"]
	                        for i=1,#affichelist do
	                        	 if tonumber(affichelist[i]["isread"]) == 1   then  --1已读  0未读 
                  	                   		Server:Instance():delaffichebyid(tostring(affichelist[i]["id"]))  --依次删除
                  	                   		return
                          		 end
                          		 if i == #affichelist    then
                          		 	Server:Instance():prompt("没有可删除的邮件")
                          		 	return
                          		 end
	                        end
	                        if 0 == #affichelist    then
                          		 	Server:Instance():prompt("没有可删除的邮件")
                          		 end
			
                        end)
            local receive_bt=self.mailLayer:getChildByTag(56)--快速领取
            receive_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
			print("领取")
                        end)

            self.mail_list=self.mailLayer:getChildByTag(47)--邮箱列表
            self.mail_list:setItemModel(self.mail_list:getItem(0))
            self.mail_list:removeAllItems()
            self.mail_list:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        Server:Instance():getaffichelist(self.sur_pageno)   --下拉刷新功能
                                 return
                      end
             end))

             for i=1,#affichelist do
                  self.mail_list:pushBackDefaultItem()
                  local  cell = self.mail_list:getItem(i-1)
                  local  touch_image=cell:getChildByTag(49)--点击事件
                  touch_image:setTag(i)
                  touch_image:addTouchEventListener(function(sender, eventType  )

                                    self:touch_back(sender, eventType)
                        end)
                  local  tag_image=cell:getChildByTag(51)--是否读取标记
                  if tonumber(affichelist[i]["isread"]) == 1   then  --1已读  0未读 
                  	tag_image:setVisible(false)
                  end
                  local  mail_title=cell:getChildByTag(52)--邮件标题
                  mail_title:setString(tostring(affichelist[i]["title"]))
                  local  mail_content=cell:getChildByTag(53)--邮件内容
                  mail_content:setString(tostring(affichelist[i]["createtime"]))
            end

end

function mailLayer:touch_back(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          print("事件")
          local affiche=LocalData:Instance():get_getaffiche()
          local affichelist=affiche["affichelist"]
          Server:Instance():getaffichedetail(affichelist[tag]["id"])
          

end
function mailLayer:fun_emailcontentlayer( )
	local affichedetail=LocalData:Instance():get_getaffichedetail()
	self.emailcontentlayer = cc.CSLoader:createNode("emailcontentlayer.csb")
            self:addChild(self.emailcontentlayer)

             local back_bt=self.emailcontentlayer:getChildByTag(62)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
		            if self.emailcontentlayer then
		            	--todo
		            end
			self.emailcontentlayer:removeFromParent()
                        end)
            local receive_bt=self.emailcontentlayer:getChildByTag(66)--领取
            receive_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
		            local affichedetail=LocalData:Instance():get_getaffichedetail()
		            if tonumber(affichedetail["rewardgolds"])  <= 0  then
		            	Server:Instance():prompt("没有可领取的金币")
		            	return
		            end
			Server:Instance():getaffichereward(affichedetail["id"])
                        end)
            local title_text=self.emailcontentlayer:getChildByTag(63)--标题
            title_text:setString(tostring(affichedetail["title"]))
            local time_text=self.emailcontentlayer:getChildByTag(65)--时间
            time_text:setString(tostring(affichedetail["createtime"]))
            self.rewardgolds=self.emailcontentlayer:getChildByTag(55)--领取金币
            self.rewardgolds:setString("X" ..  tostring(affichedetail["rewardgolds"]))
            local _text=self.emailcontentlayer:getChildByTag(71):getChildByTag(72)--内容
            _text:setString(tostring(affichedetail["content"]))


end
function mailLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        self:init()
                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHDETAIL, self,
                       function()
                        self:fun_emailcontentlayer( )
                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.TAFFICHEDETAIL, self,
                       function()
                        local  affichedetail=LocalData:Instance():get_getaffichedetail()
                        affichedetail["rewardgolds"] = 0  
                        LocalData:Instance():set_getaffichedetail(affichedetail)
                        self.rewardgolds:setString("X0")
                      end)

	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DELAFFICHEBYID, self,
                       function()
                        Server:Instance():getaffichelist(self.sur_pageno)
                        LocalData:Instance():set_getaffiche(nil)
                      end)
end

function mailLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHDETAIL, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DELAFFICHEBYID, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.TAFFICHEDETAIL, self)
end


return mailLayer