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

    	      --提交建议
            self.advice_bg=self.aboutdetails:getChildByTag(200)  --提交建议界面
            self.advice_bg:setVisible(false)
            local adviceback_bt=self.advice_bg:getChildByTag(202)  --提交建议界面返回
            adviceback_bt:addTouchEventListener((function(sender, eventType  )
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
            --商务合作
            self.business_bg=self.aboutdetails:getChildByTag(305)  --商务合作界面
            self.business_bg:setVisible(false)
             local businessback_bt=self.business_bg:getChildByTag(307)  --商务合作界面返回
            businessback_bt:addTouchEventListener((function(sender, eventType  )
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
             local cooperation_bt=self.businessback_bg:getChildByTag(356)  --运营合作条件
             cooperation_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             self.cooperation_ListView=self.businessback_bg:getChildByTag(369)--惊喜吧列表
             self.cooperation_ListView:setVisible(false)
             self.cooperation_ListView:setItemModel(self.cooperation_ListView:getItem(0))
   	      self.cooperation_ListView:removeAllItems()

             local describe_text=self.aboutdetails:getChildByTag(1293)  --返回

             if  device.platform  ==  "android" then
                     describe_text:setString("拼乐 for android  版本号v"..tostring(PINLE_VERSION))
            elseif device.platform  ==  "mac"  or    device.platform  ==  "ios" then
                     describe_text:setString("拼乐 for iphone  版本号v"..tostring(PINLE_VERSION))
             end
             

             local back_bt=self.aboutdetails:getChildByTag(1290)  --返回
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local advice_bt=self.aboutdetails:getChildByTag(1294)  --提交建议
             advice_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local business_bt=self.aboutdetails:getChildByTag(1295)  --商务合作
             business_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
             local qrcode_bt=self.aboutdetails:getChildByTag(1296)  --扫描二维码
             qrcode_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))

end
function aboutdetailsLayer:touch_btCallback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
           if tag==1290 then  --返回
           	   if self.aboutdetails then
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
           	      self.advice_bg:setVisible(false)
           	      self.phone_text:setVisible(false)
           	      self.name_text:setVisible(false)
           	      self.content_text:setVisible(false)
           	elseif  tag==210 then   --提交  记住在正确时候消息这界面消失   
           		print("提交", self.phone_text:getText())     
                  local _name=self.name_text:getText()
                  local _tel=self.phone_text:getText()
                  local _content=self.content_text:getText()
                  --type    0为建议反馈，1为商务合作   
                  print("1111",_name,_tel,_content)

                  if (_name=="请输入姓名"  or  _name== "")  or  (_tel=="请输入手机号码"  or  _tel== "")  or  (_content=="请输入您的宝贵建议(200字以内)"  or  _content== "") then  --
                            LocalData:Instance():set_back("1")
                            self.content_text:setVisible(false)
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                  LocalData:Instance():set_back("1") 
                  Server:Instance():setfeedback({type="0",company="北京拼乐",name=_name,tel=_tel,content=_content})

           	elseif tag==307 then  --商务合作返回
           		self.business_bg:setVisible(false)
           		self.companyname_text:setVisible(false)
           	            self.nametext:setVisible(false)
           	            self.phonetext:setVisible(false)
           	           self.contenttext:setVisible(false)
           	           self.cooperation_ListView:setVisible(false)

           	elseif tag==364 then  --商务合作提交  
           		print("商务提交")
                  local _name=self.nametext:getText()
                  local _tel=self.phonetext:getText()
                  local _content=self.contenttext:getText()
                  local _company=self.companyname_text:getText()
                   if (_name=="请输入联系人姓名"  or  _name== "") or (_tel=="请输入联系方式"  or  _tel== "")  or (_content=="请输入您的宝贵建议(200字以内)"  or  _content== "") or (_company=="请输入公司名称"  or  _company== "")  then
                            LocalData:Instance():set_back("1")
                            self.contenttext:setVisible(false)
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                  LocalData:Instance():set_back("1")
                  --type    0为建议反馈，1为商务合作    
                  Server:Instance():setfeedback({type="1",company=_company,name=_name,tel=_tel,content=_content})

           	elseif tag==356 then  --商务合作条件
           		print("条件")
           		self:cooperationlist()
            elseif tag==68 then
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

    local res = "res/png/guanyuchangkuang.png"
    local width = 333
    local height = 40
    --公司名称
    self.companyname_text = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.companyname_text)
    self.companyname_text:setPosition(cc.p(self.Xcompanyname_text:getPositionX(),self.Xcompanyname_text:getPositionY()))--( cc.p(130,438 ))  
    self.companyname_text:setPlaceHolder("请输入公司名称")
    self.companyname_text:setAnchorPoint(0.5,0.5)  
    self.companyname_text:setMaxLength(14)
    self.companyname_text:setFontColor(cc.c3b(35,149,200))
    -- 联系人姓名
    self.nametext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.nametext)
    self.nametext:setPosition(cc.p(self.Xname_text:getPositionX(),self.Xname_text:getPositionY()))--( cc.p(130,323 ))  
    self.nametext:setPlaceHolder("请输入联系人姓名")
    self.nametext:setAnchorPoint(0.5,0.5) 
    self.nametext:setFontColor(cc.c3b(35,149,200))
    self.nametext:setMaxLength(14)
     -- 联系方式
    self.phonetext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.phonetext)
    self.phonetext:setPosition(cc.p(self.Xphone_text:getPositionX(),self.Xphone_text:getPositionY()))--( cc.p(130,323 ))  
    self.phonetext:setPlaceHolder("请输入联系方式")
    self.phonetext:setAnchorPoint(0.5,0.5) 
    self.phonetext:setFontColor(cc.c3b(35,149,200))
    self.phonetext:setMaxLength(11)


    --  内容
    local _res = "res/png/guanyukuang.png"  
    self.contenttext = ccui.EditBox:create(cc.size(489,227),_res)
    self.contenttext:setFont("Arial",22)
    self.contenttext:setFontColor(cc.c3b(35,149,200))
    self.contenttext:setPlaceholderFont("Arial",22)
    self.businessback_bg:addChild(self.contenttext)
    self.contenttext:setPosition(cc.p(self.Xcontent_text:getPositionX(),self.Xcontent_text:getPositionY()))--( cc.p(130,438 ))  
    self.contenttext:setPlaceHolder("请输入您的宝贵建议(200字以内)")

    self.contenttext:setAnchorPoint(0.5,0.5)  
    self.contenttext:setMaxLength(200)

end
-- 提交内容
function aboutdetailsLayer:inputbox(  )
	
    local res = "res/png/guanyuchangkuang.png"
    local width = 333
    local height = 40
    --手机号
    self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.phone_text)
    self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX(),self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text:setPlaceHolder("请输入手机号码")
    self.phone_text:setAnchorPoint(0.5,0.5)  
    self.phone_text:setMaxLength(11)
    self.phone_text:setFontColor(cc.c3b(35,149,200))
    --  姓名
    self.name_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.name_text)
    self.name_text:setPosition(cc.p(self.Zname_text:getPositionX(),self.Zname_text:getPositionY()))--( cc.p(130,323 ))  
    self.name_text:setPlaceHolder("请输入姓名")
    self.name_text:setAnchorPoint(0.5,0.5) 
    self.name_text:setFontColor(cc.c3b(35,149,200))
    self.name_text:setMaxLength(14)

    --  内容
    local _res = "res/png/guanyukuang.png"  
    self.content_text = ccui.EditBox:create(cc.size(489,227),_res)
    self.content_text:setFontName("Arial")
    self.content_text:setFontColor(cc.c3b(35,149,200))
    self.content_text:setFontSize(22)
    self.content_text:setPlaceholderFont("Arial",22)
    self.advicedata_bg:addChild(self.content_text)
    self.content_text:setPosition(cc.p(self.Zcontent_text:getPositionX(),self.Zcontent_text:getPositionY()))--( cc.p(130,438 ))  
    self.content_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
    self.content_text:setAnchorPoint(0.5,0.5)  
    self.content_text:setMaxLength(200)




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



