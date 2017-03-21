--
-- Author: peter
-- Date: 2016-08-10 10:17:21
--
--
-- Author: peter
-- Date: 2016-06-22 21:47:44
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--  关于拼乐界面
local aboutdetailsLayer = class("aboutdetailsLayer", function()
            return display.newLayer("aboutdetailsLayer")
end)
function aboutdetailsLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听

       self:init()
end
function aboutdetailsLayer:init(  )
	self.aboutdetails = cc.CSLoader:createNode("aboutdetails.csb");
    	self:addChild(self.aboutdetails)

            --二维码
            self.qr_code=self.aboutdetails:getChildByTag(67)  --二维码界面
            self.qr_code:setVisible(false)
            local qrcode_bt=self.qr_code:getChildByTag(68)
            qrcode_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local qrcode_bt1=self.qr_code:getChildByTag(97)
            qrcode_bt1:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))

    	     --  --提交建议
            self.advice_bg=self.aboutdetails:getChildByTag(200)  --提交建议界面
            self.advice_bg:setVisible(false)
            local adviceback_bt=self.advice_bg:getChildByTag(202)  --提交建议界面返回
            adviceback_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local adviceback_bt1=self.advice_bg:getChildByTag(204):getChildByTag(98)  --提交建议界面返回
            adviceback_bt1:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            self.advicedata_bg=self.advice_bg:getChildByTag(204)  --提交数据建议界面
             local submit_bt=self.advicedata_bg:getChildByTag(210)  --提交界面
             submit_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            self.Zcontent_text=self.advicedata_bg:getChildByTag(207)  --提交内容
            self.Zname_text=self.advicedata_bg:getChildByTag(214)  --输入姓名
            self.Zphone_text=self.advicedata_bg:getChildByTag(215)  --输入手机号
            --self.Zcontent_text:setVisible(false)
            self.content_text=self.Zcontent_text
           -- Util:function_keyboard(self.advicedata_bg,self.Zcontent_text,17) 
            self.Zname_text:setVisible(false)
            self.Zphone_text:setVisible(false)
          --   --商务合作
            self.business_bg=self.aboutdetails:getChildByTag(305)  --商务合作界面
            self.business_bg:setVisible(false)
             local businessback_bt=self.business_bg:getChildByTag(307)  --商务合作界面返回
            businessback_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local businessback_bt1=self.business_bg:getChildByTag(308):getChildByTag(99)  --商务合作界面返回
            businessback_bt1:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            self.businessback_bg=self.business_bg:getChildByTag(308)  --商务数据建议界面
            self._businessname=self.businessback_bg:getChildByTag(354)  --商务名称
             local business_bt=self.businessback_bg:getChildByTag(364)  --商务界面提交
             business_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            self.Xcontent_text=self.businessback_bg:getChildByTag(365)  --提交内容
            self.Xcompanyname_text=self.businessback_bg:getChildByTag(366)  --公司名称
            self.Xname_text=self.businessback_bg:getChildByTag(367)  --联系人姓名
            self.Xphone_text=self.businessback_bg:getChildByTag(368)  --联系方式

            --self.Xcontent_text:setVisible(false)
            self.contenttext =self.Xcontent_text
            --Util:function_keyboard(self.businessback_bg,self.Xcontent_text,17) 

            self.Xcompanyname_text:setVisible(false)
            self.Xname_text:setVisible(false)
            self.Xphone_text:setVisible(false)
          --    local cooperation_bt=self.businessback_bg:getChildByTag(356)  --运营合作条件
          --    cooperation_bt:addTouchEventListener((function(sender, eventType  )
          --            self:touch_btCallback(sender, eventType)
          --      end))
          --    self.cooperation_ListView=self.businessback_bg:getChildByTag(369)--惊喜吧列表
          --    self.cooperation_ListView:setVisible(false)
          --    self.cooperation_ListView:setItemModel(self.cooperation_ListView:getItem(0))
   	      -- self.cooperation_ListView:removeAllItems()

            local describe_t=self.aboutdetails:getChildByTag(171)  --类型

             if  device.platform  ==  "android" then
                     describe_t:loadTexture("png/guanyu-zi-3.png")
            elseif device.platform  ==  "mac"  or    device.platform  ==  "ios" then
                     describe_t:loadTexture("png/guanyu-zi-1.png")
             end

             --  建议
              local _bt1=self.advice_bg:getChildByTag(203)  --提交建议按钮
             _bt1:addTouchEventListener((function(sender, eventType  )
                     self:fun_back(sender, eventType)
               end))
             _bt1:setBright(false)
             self.curr_bright=_bt1--记录当前高亮

              local _bt2=self.advice_bg:getChildByTag(186)  --建议回复按钮
              _bt2:setTouchEnabled(false)
             _bt2:addTouchEventListener((function(sender, eventType  )
                     self:fun_back(sender, eventType)
               end))
             --合作
              local _bt3=self.business_bg:getChildByTag(377)  --商务合作按钮
             _bt3:addTouchEventListener((function(sender, eventType  )
                     self:fun_callback(sender, eventType)
               end))
             _bt3:setBright(false)
             self.curr_bright1=_bt3--记录当前高亮

              local _bt4=self.business_bg:getChildByTag(268)  --回复按钮
              _bt4:setTouchEnabled(false)
             _bt4:addTouchEventListener((function(sender, eventType  )
                     self:fun_callback(sender, eventType)
               end))

             

             local back_bt=self.aboutdetails:getChildByTag(1290)  --返回
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local advice_bt=self.aboutdetails:getChildByTag(1294)  --提交建议
             advice_bt:addTouchEventListener((function(sender, eventType  )
                     _bt1:setBright(false)
                     _bt2:setBright(true)
                     self.curr_bright=_bt1--记录当前高亮
                     self:touch_btCallback(sender, eventType)
               end))
             local business_bt=self.aboutdetails:getChildByTag(1295)  --商务合作
             business_bt:addTouchEventListener((function(sender, eventType  )
                     _bt3:setBright(false)
                     _bt4:setBright(true)
                    self.curr_bright1=_bt3--记录当前高亮
                     self:touch_btCallback(sender, eventType)
               end))
             local qrcode_bt=self.aboutdetails:getChildByTag(1296)  --扫描二维码
             qrcode_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             

end
--  零时加的  
function aboutdetailsLayer:fun_showtip(bt_obj,_x,_y )
          if self.showtip_image~=nil then
            return
          end
          self.showtip_image= display.newSprite("png/jingqingqidai-zi.png")
          self.showtip_image:setScale(0)
          self.showtip_image:setAnchorPoint(0, 0)
          self:addChild(self.showtip_image)
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

function aboutdetailsLayer:fun_callback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
             if self.curr_bright1:getTag()==tag then
                  return
              end
              self.curr_bright1:setBright(true)
              sender:setBright(false)

           if tag==377 then
             --todo
            elseif tag==268 then
               self:fun_showtip(sender,sender:getPositionX(),sender:getPositionY() )
           end
           self.curr_bright1=sender
end
function aboutdetailsLayer:fun_back( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
             if self.curr_bright:getTag()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)

           if tag==203 then
              print("111")
           elseif tag==186 then
             self:fun_showtip(sender,sender:getPositionX(),sender:getPositionY() )
           end
           self.curr_bright=sender
end
function aboutdetailsLayer:touch_btCallback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
           if tag==1290 then  --返回
           	   if self.aboutdetails then
                Util:all_layer_backMusic()
           	   	self:removeFromParent()
           	   end
           elseif  tag==1294 then--提交建议
 	      self.advice_bg:setVisible(true)
 	      self:inputbox()
           	elseif  tag==1295 then --商务合作
                  self.business_bg:setVisible(true)
                  self:businesscooperation()
           	elseif  tag==1296 then --扫描二维码
           	       print("扫描二维码")
                   self.qr_code:setVisible(true)
           	elseif  tag==202 then --扫描二维码
           	      -- self.advice_bg:setVisible(false)
           	      self.phone_text:setVisible(false)
           	      self.name_text:setVisible(false)
           	      self.content_text:setVisible(false)
                 self.advice_bg:setVisible(false)
            elseif  tag==98 then --扫描二维码
                  self.advice_bg:setVisible(false)
                  --self.phone_text:setVisible(false)
                  --self.name_text:setVisible(false)
                  --self.content_text:setVisible(false)
           	elseif  tag==210 then   --提交  记住在正确时候消息这界面消失   
           		print("提交", self.phone_text:getText())     --self.phone_text
                  local _name=self.name_text:getText()   --self.name_text  
                  local _tel=self.phone_text:getText()
                  local _content=self.content_text:getString()   --getText()  self.content_text
                  --type    0为建议反馈，1为商务合作   
                  print("1111",_name,_tel,_content)

                  if (_name=="请输入姓名"  or  _name== "")  or  (_tel=="请输入手机号码"  or  _tel== "")  or  (_content=="请输入您的宝贵建议(200字以内)"  or  _content== "") then  --
                            LocalData:Instance():set_back("0")
                            --self.content_text:setVisible(false)
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                   if not string.find(_tel,"^[+-]?%d+$")  then
                      Server:Instance():prompt("手机号格式不正确")
                      return
                  end

                  LocalData:Instance():set_back("1") 
                  Server:Instance():setfeedback({type="0",company="北京拼乐",name=_name,tel=_tel,content=_content})

           	elseif tag==307 then  --商务合作返回
           		-- self.business_bg:setVisible(false)
                   Util:all_layer_backMusic()
                  -- audio.playMusic("sound/effect/guanbi.mp3",false)
           		 self.companyname_text:setVisible(false)
           	            self.nametext:setVisible(false)
           	            self.phonetext:setVisible(false)
           	           self.contenttext:setVisible(false)
           	           --self.cooperation_ListView:setVisible(false)
             self.business_bg:setVisible(false)
            elseif tag==99 then  --商务合作返回
              self.business_bg:setVisible(false)
              self.companyname_text:setVisible(false)
                        self.nametext:setVisible(false)
                       self.phonetext:setVisible(false)
                       self.contenttext:setVisible(false)
                       self.cooperation_ListView:setVisible(false)
                       
           	elseif tag==364 then  --商务合作提交  
           		print("商务提交")
                  local _name=self.nametext:getText()--getString()  --
                  local _tel= self.phonetext:getText()  --self.phonetext
                  local _content=self.contenttext:getString()  --self.contenttext
                  local _company=self.companyname_text:getText()  --self.companyname_text
                   if (_name=="请输入联系人姓名"  or  _name== "") or (_tel=="请输入联系方式"  or  _tel== "")  or (_content=="请输入您的宝贵建议(200字以内)"  or  _content== "") or (_company=="请输入公司名称"  or  _company== "")  then
                            LocalData:Instance():set_back("0")
                            --self.contenttext:setVisible(false)
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                  if not string.find(_tel,"^[+-]?%d+$")  then
                      Server:Instance():prompt("手机号格式不正确")
                      return
                  end



                  LocalData:Instance():set_back("1")
                  --type    0为建议反馈，1为商务合作    
                  Server:Instance():setfeedback({type="1",company=_company,name=_name,tel=_tel,content=_content})

           	elseif tag==356 then  --商务合作条件
           		print("条件")
           		self:cooperationlist()
            elseif tag==68 then
              Util:all_layer_backMusic()
              self:removeFromParent()
            elseif tag==97 then
              self.qr_code:setVisible(false)
           end

end
function aboutdetailsLayer:cooperationlist(  )
	self.cooperation_ListView:removeAllItems() 
	self.cooperation_ListView:setVisible(true)
	for i=1,6 do
	          	self.cooperation_ListView:pushBackDefaultItem()
	          	local  cell = self.cooperation_ListView:getItem(i-1)
	          	cell:addTouchEventListener((function(sender, eventType  )
	                     self:touch_Callback(sender, eventType)
	               end))
	            cell:setTag(i)
	             local name=cell:getChildByTag(371)  --商务名称
	             name:setString("text"  ..  i)
	           
            end

end
function aboutdetailsLayer:touch_Callback( sender, eventType )
	 if eventType ~= ccui.TouchEventType.ended then
                return
             end 
             local tag=sender:getTag()
             self.cooperation_ListView:setVisible(false)
             local name=sender:getChildByTag(371)  --商务名称 
             self._businessname:setString(name:getString())
	
end
function aboutdetailsLayer:businesscooperation( )

    local res = "  "
    local width = 200
    local height = 27
    --公司名称
    self.companyname_text = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.companyname_text)
    self.companyname_text:setPosition(cc.p(self.Xcompanyname_text:getPositionX(),self.Xcompanyname_text:getPositionY()))--( cc.p(130,438 ))  
    self.companyname_text:setPlaceHolder("请输入公司名称")
    self.companyname_text:setAnchorPoint(0.5,0.5)  
    self.companyname_text:setMaxLength(14)
    self.companyname_text:setFontColor(cc.c3b(137,39,9))
    --联系人姓名
    self.nametext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.nametext)
    self.nametext:setPosition(cc.p(self.Xname_text:getPositionX(),self.Xname_text:getPositionY()))--( cc.p(130,323 ))  
    self.nametext:setPlaceHolder("请输入联系人姓名")
    self.nametext:setAnchorPoint(0.5,0.5) 
    self.nametext:setFontColor(cc.c3b(137,39,9))
    self.nametext:setMaxLength(14)
     --联系方式
    self.phonetext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.phonetext)
    self.phonetext:setPosition(cc.p(self.Xphone_text:getPositionX(),self.Xphone_text:getPositionY()))--( cc.p(130,323 ))  
    self.phonetext:setPlaceHolder("请输入联系方式")
    self.phonetext:setAnchorPoint(0.5,0.5) 
    self.phonetext:setFontColor(cc.c3b(137,39,9))
    self.phonetext:setMaxLength(11)


     --内容
    -- local _res = "  "  
    -- self.contenttext = ccui.EditBox:create(cc.size(475,270),_res)
    -- self.contenttext:setFont("Arial",22)
    -- self.contenttext:setFontColor(cc.c3b(137,39,9))
    -- self.contenttext:setPlaceholderFont("Arial",22)
    -- self.businessback_bg:addChild(self.contenttext)
    -- self.contenttext:setPosition(cc.p(self.Xcontent_text:getPositionX(),self.Xcontent_text:getPositionY()))--( cc.p(130,438 ))  
    -- self.contenttext:setPlaceHolder("请输入您的宝贵建议(200字以内)")

    -- self.contenttext:setAnchorPoint(0.5,0.5)  
    -- self.contenttext:setMaxLength(200)
    -- self.contenttext:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)

end
-- 提交内容
function aboutdetailsLayer:inputbox(  )
	
    local res = " "
    local width = 200
    local height = 27
    --手机号
    self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.phone_text)
    self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX(),self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text:setPlaceHolder("请输入手机号码")
    self.phone_text:setAnchorPoint(0.5,0.5)  
    self.phone_text:setMaxLength(11)
    self.phone_text:setFontColor(cc.c3b(137,39,9))
    -- 姓名
    self.name_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.name_text)
    self.name_text:setPosition(cc.p(self.Zname_text:getPositionX(),self.Zname_text:getPositionY()))--( cc.p(130,323 ))  
    self.name_text:setPlaceHolder("请输入姓名")
    self.name_text:setAnchorPoint(0.5,0.5) 
    self.name_text:setFontColor(cc.c3b(137,39,9))
    self.name_text:setMaxLength(14)

     --内容
    -- local _res ="  "  
    -- self.content_text = ccui.EditBox:create(cc.size(470,165),_res)
    -- self.content_text:setFontName("Arial")
    -- self.content_text:setFontColor(cc.c3b(137,39,9))
    -- self.content_text:setFontSize(22)
    -- self.content_text:setPlaceholderFont("Arial",22)
    -- self.advicedata_bg:addChild(self.content_text)
    -- self.content_text:setPosition(cc.p(self.Zcontent_text:getPositionX(),self.Zcontent_text:getPositionY()))--( cc.p(130,438 ))  
    -- self.content_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
    -- self.content_text:setAnchorPoint(0.5,0.5)  
    -- self.content_text:setMaxLength(200)
    -- self.content_text:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)




end

function aboutdetailsLayer:onEnter()
  --  提交建议  
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FEEDBACK, self,
                       function()

                       Server:Instance():prompt("提交成功！！！")

                       if self.content_text then  
                         self.content_text:setVisible(false)
                       end
                        if self.contenttext then 
                         self.contenttext:setVisible(false)
                       end

                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.TFEDBACK, self,
                       function()
                        LocalData:Instance():set_back("0")  
                        self.business_bg:setVisible(false)
                        self:init()

                       if self.advice_bg:isVisible()  and  self.content_text then  
                         self.content_text:setVisible(true)
                       end
                        if self.business_bg:isVisible()  and  self.contenttext then 
                         self.contenttext:setVisible(true)
                       end
                      end)

end

function aboutdetailsLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FEEDBACK, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.TFEDBACK, self)
     	
end


return aboutdetailsLayer



