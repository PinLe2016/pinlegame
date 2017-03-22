--
-- Author: peter
-- Date: 2016-08-18 11:02:04
--
--邮箱
local mailLayer = class("mailLayer", function()
            return display.newLayer("mailLayer")
end)
function mailLayer:move_layer(_layer)   
   local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end
function mailLayer:ctor()

         self:setNodeEventEnabled(true)--layer添加监听
         self.sur_pageno=1
          LocalData:Instance():set_getaffiche(nil)
         Server:Instance():getaffichelist(self.sur_pageno) 
          self.tablecout  =  0  
          self.sup_data_num =0 

        self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        self.fragment_sprite:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
        self:addChild(self.fragment_sprite)


           self.mailLayer = cc.CSLoader:createNode("mailLayer.csb")
            self:addChild(self.mailLayer)

            self:move_layer(self.mailLayer)

            local back_bt=self.mailLayer:getChildByTag(46)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
                    return
                end
                Util:all_layer_backMusic()
                  self:removeFromParent()
                  LocalData:Instance():set_getaffiche(nil)
                   Util:scene_control("MainInterfaceScene")   --  目的是刷新金币
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







end

function mailLayer:init(  )
  print("fadsjfhdsjfhdshf dsfjksafkjds ")
	local affiche=LocalData:Instance():get_getaffiche()
  dump(affiche)
	local affichelist=affiche["affichelist"]
	-- self.mailLayer = cc.CSLoader:createNode("mailLayer.csb")
 --            self:addChild(self.mailLayer)

 --            local back_bt=self.mailLayer:getChildByTag(46)--返回
 --            back_bt:addTouchEventListener(function(sender, eventType  )
 --                                    if eventType ~= ccui.TouchEventType.ended then
	-- 	                return
	-- 	            end
	-- 		self:removeFromParent()
 --                  LocalData:Instance():set_getaffiche(nil)
 --                  Util:scene_control("MainInterfaceScene")   --  目的是刷新金币
 --                        end)
            local delete_bt=self.mailLayer:getChildByTag(54)--删除
            delete_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                             return
		                        end
			local affiche=LocalData:Instance():get_getaffiche()
	                        local affichelist=affiche["affichelist"]
	                        for i=1,#affichelist do
	                        	 if tonumber(affichelist[i]["isread"]) == 1   then  --1已读  0未读 
                              self.tablecout=0
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

            -- self.mail_list=self.mailLayer:getChildByTag(47)--邮箱列表
            -- self.mail_list:setItemModel(self.mail_list:getItem(0))
            -- --self.mail_list:removeAllItems()
            -- self.mail_list:addScrollViewEventListener((function(sender, eventType  )
            --           if eventType  ==6 then
            --             self.sur_pageno=self.sur_pageno+1
            --             Server:Instance():getaffichelist(self.sur_pageno)   --下拉刷新功能
            --                      return
            --           end
            --  end))

              -- if self.tablecout  ==  0  then
              --    self.mail_list:removeAllItems() 
              -- end
              
              self.sup_data_num   =   #affichelist
           if self.tablecout<self.sup_data_num then
                   print("小于",self.tablecout ,"  ",self.sup_data_num)
                   
           elseif self.tablecout>self.sup_data_num then
                 print("大于")
                self.mail_list:removeAllItems()
            else
                 --return
           end


             for i=self.tablecout+1, #affichelist  do

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
              if tonumber(self.tablecout)~=0 then

             self.mail_list:jumpToPercentVertical(120)
           else
             self.mail_list:jumpToPercentVertical(0)
          end
             self.tablecout=self.sup_data_num

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
  dump(affichedetail)
    self.fragment_sprite1 = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
     self.fragment_sprite1:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
        self:addChild(self.fragment_sprite1)
	self.emailcontentlayer = cc.CSLoader:createNode("emailcontentlayer.csb")
            self:addChild(self.emailcontentlayer)
              self:move_layer(self.emailcontentlayer)

             local back_bt=self.emailcontentlayer:getChildByTag(62)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
            		                return
            		            end
		            if self.emailcontentlayer then
                  self.sur_pageno=1
                  self.tablecout=0
                              Server:Instance():getaffichelist(self.sur_pageno)
                              LocalData:Instance():set_getaffiche(nil)

                            self.mail_list:removeAllItems() 
                            self.fragment_sprite1:removeFromParent()
                            self.emailcontentlayer:removeFromParent()
                            Util:all_layer_backMusic()
		            end
			
                        end)

            local title_text=self.emailcontentlayer:getChildByTag(63)--标题
            title_text:setString(tostring(affichedetail["title"]))
            local time_text=self.emailcontentlayer:getChildByTag(65)--时间
            time_text:setString(tostring(affichedetail["createtime"]))
            self.rewardgolds=self.emailcontentlayer:getChildByTag(55)--领取金币
            self.rewardgolds:setString("X" ..  tostring(affichedetail["rewardgolds"]))
             self.rewardquan=self.emailcontentlayer:getChildByTag(1230)--领取juan
            self.rewardquan:setString("X" ..  tostring(affichedetail["rewardcount"]))

            local _text=self.emailcontentlayer:getChildByTag(71):getChildByTag(72)--内容
            _text:setString(tostring(affichedetail["content"]))
            local _image_corde=self.emailcontentlayer:getChildByTag(1228):getChildByTag(1229)--更改道具图片
            if tonumber(affichedetail["rewardcount"])  >0  then
              _image_corde:loadTexture("png/"   .. tostring(affichedetail["rewardimage"])  )
            end
            local receive_bt=self.emailcontentlayer:getChildByTag(66)--领取
            local receive_bt1=self.emailcontentlayer:getChildByTag(67)--领取
            if tonumber(affichedetail["rewardgolds"])  <= 0   and  tonumber(affichedetail["rewardcount"])  <= 0  then
               receive_bt:setVisible(false)
               receive_bt1:setVisible(false)
            else
               receive_bt:setVisible(true)
               receive_bt1:setVisible(true)
            end
            if tonumber(affichedetail["rewardgolds"])  <= 0 then
               local receive_icogold=self.emailcontentlayer:getChildByTag(61)--
               receive_icogold:setVisible(false)
               self.rewardgolds:setVisible(false)
            end
             if tonumber(affichedetail["rewardcount"])  <= 0 then
               local receive_icocard=self.emailcontentlayer:getChildByTag(1228)--
               receive_icocard:setVisible(false)
               self.rewardquan:setVisible(false)
            end

            receive_bt:addTouchEventListener(function(sender, eventType  )
                        if eventType ~= ccui.TouchEventType.ended then
                      return
                end
                local affichedetail=LocalData:Instance():get_getaffichedetail()
                if tonumber(affichedetail["rewardgolds"])  <= 0 and tonumber(affichedetail["rewardcount"])  <= 0 then
                  Server:Instance():prompt("没有可领取的金币")
                  return
                end
              Server:Instance():getuserinfo()
             Server:Instance():getaffichereward(affichedetail["id"])
              local userdt = LocalData:Instance():get_userdata()
             userdt["golds"]=userdt["golds"] + tonumber(affichedetail["rewardgolds"])
             LocalData:Instance():set_userdata(userdt)

                        end)

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
                        affichedetail["rewardcount"] = 0  
                        LocalData:Instance():set_getaffichedetail(affichedetail)
                        self.rewardgolds:setString("X0")
                        self.rewardquan:setString("X0")--
                      end)

	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DELAFFICHEBYID, self,
                       function()
                        self.sur_pageno=1
                        Server:Instance():getaffichelist(self.sur_pageno)
                        self.mail_list:removeAllItems() 
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