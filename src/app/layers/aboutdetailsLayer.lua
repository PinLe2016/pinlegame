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
function aboutdetailsLayer:ctor(_type)
       self:setNodeEventEnabled(true)--layer添加监听
       self._type=_type
       self:init()
end
function aboutdetailsLayer:init(  )
          self.aboutdetails = cc.CSLoader:createNode("aboutdetails.csb");
          self:addChild(self.aboutdetails)
          self.aboutdetails:setScale(0.7)
          self.aboutdetails:setAnchorPoint(0.5,0.5)
          self.aboutdetails:setPosition(320, 568)
          -- local actionTo = cc.ScaleTo:create(0.3, 1.1)
          -- local actionTo1 = cc.ScaleTo:create(0.1, 1)
          -- self.aboutdetails:runAction(cc.Sequence:create(actionTo,actionTo1  ))
          Util:layer_action(self.aboutdetails,self,"open")

          --  --提交建议
          self.advice_bg=self.aboutdetails:getChildByTag(200)  --提交建议界面
          self.advice_bg:setVisible(false)
          self.advice_bg:getChildByTag(172):getChildByTag(132):loadTexture("resources/com/chengzhangshu-1-touming.png")
          local adviceback_bt=self.advice_bg:getChildByTag(3071)  --提交建议界面返回
          adviceback_bt:addTouchEventListener((function(sender, eventType  )

                  
                  if eventType ~= ccui.TouchEventType.ended then
                       -- sender:setScale(1.2)
                       return
                  end
                  -- sender:setScale(1)
                    -- local function stopAction()
                    -- self:removeFromParent()
                    -- end
                    -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
                    -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
                    -- local callfunc = cc.CallFunc:create(stopAction)
                    -- self.aboutdetails:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
                    Util:layer_action(self.aboutdetails,self,"close")

             end))
          self.advicedata_bg=self.advice_bg:getChildByTag(204)  --提交数据建议界面
           local submit_bt=self.advicedata_bg:getChildByTag(210)  --提交界面
           submit_bt:addTouchEventListener((function(sender, eventType  )
                   self:touch_btCallback(sender, eventType)
             end))
          self.Zcontent_text=self.advicedata_bg:getChildByTag(207)  --提交内容
          Util:function_advice_keyboard(self.advicedata_bg,self.Zcontent_text,10)
          self.Zname_text=self.advicedata_bg:getChildByTag(214)  --输入姓名
          self.Zphone_text=self.advicedata_bg:getChildByTag(215)  --输入手机号
          self.content_text=self.Zcontent_text
          self.Zname_text:setVisible(false)
          self.Zphone_text:setVisible(false)
          -- --   --商务合作
          self.business_bg=self.aboutdetails:getChildByTag(305)  --商务合作界面
          self.business_bg:setVisible(false)
          self.business_bg:getChildByTag(214):getChildByTag(132):loadTexture("resources/com/chengzhangshu-1-touming.png")
           local businessback_bt=self.business_bg:getChildByTag(3069)  --商务合作界面返回
          businessback_bt:addTouchEventListener((function(sender, eventType  )
                        if eventType ~= ccui.TouchEventType.ended then
                              sender:setScale(1.2)
                            return
                        end
                        sender:setScale(1)

                        Util:all_layer_backMusic()
                        -- local function stopAction()
                        -- self:removeFromParent()
                        -- end
                        -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
                        -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
                        -- local callfunc = cc.CallFunc:create(stopAction)
                        -- self.aboutdetails:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
                        Util:layer_action(self.aboutdetails,self,"close")

             end))
          self.businessback_bg=self.business_bg:getChildByTag(308)  --商务数据建议界面
          self._businessname=self.businessback_bg:getChildByTag(354)  --商务名称
           local business_bt=self.businessback_bg:getChildByTag(364)  --商务界面提交
           business_bt:addTouchEventListener((function(sender, eventType  )
                   self:touch_btCallback(sender, eventType)
             end))
          self.Xcontent_text=self.businessback_bg:getChildByTag(365)  --提交内容
          Util:function_advice_keyboard(self.businessback_bg,self.Xcontent_text,10)
          self.Xcompanyname_text=self.businessback_bg:getChildByTag(366)  --公司名称
          self.Xname_text=self.businessback_bg:getChildByTag(367)  --联系人姓名
          self.Xphone_text=self.businessback_bg:getChildByTag(368)  --联系方式
          self.contenttext =self.Xcontent_text
          self.Xcompanyname_text:setVisible(false)
          self.Xname_text:setVisible(false)
          self.Xphone_text:setVisible(false)
          local describe_t=self.aboutdetails:getChildByTag(171)  --类型
           local back_bt=self.aboutdetails:getChildByTag(3070)  --返回
           back_bt:addTouchEventListener((function(sender, eventType  )
                   
                  if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                  end
                  sender:setScale(1)

                  Util:all_layer_backMusic()
                  -- local function stopAction()
                  -- self:removeFromParent()
                  -- end
                  -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
                  -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
                  -- local callfunc = cc.CallFunc:create(stopAction)
                  -- self.aboutdetails:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
                  Util:layer_action(self.aboutdetails,self,"close")

             end))
            if self._type == 1 then  --提交建议
                  self.advice_bg:setVisible(true)
                  self.Zcontent_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
                  self:inputbox()
                  self.content_text:setString("")
            elseif self._type == 2 then  --  商务合作
                  self.business_bg:setVisible(true)
                  self.Xcontent_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
                  self:businesscooperation()
                  self.contenttext:setString("")
            end
             

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

              

           elseif  tag==1294 then--提交建议
        self.advice_bg:setVisible(true)
        self.Zcontent_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
        self:inputbox()
         self.content_text:setString("")

            elseif  tag==1295 then --商务合作
                  self.business_bg:setVisible(true)
                  self.Xcontent_text:setPlaceHolder("请输入您的宝贵建议(200字以内)")
                  self:businesscooperation()
                   self.contenttext:setString("")
            elseif  tag==1296 then --扫描二维码
                   print("扫描二维码")
                   self.qr_code:setVisible(true)
            elseif  tag==202 then --扫描二维码
                   
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
                  
            elseif tag==99 then  --商务合作返回
              self.business_bg:setVisible(false)
              self.companyname_text:setVisible(false)
                        self.nametext:setVisible(false)
                       self.phonetext:setVisible(false)
                       self.contenttext:setVisible(false)
                       self.cooperation_ListView:setVisible(false)
                       
            elseif tag==364 then  --商务合作提交  
                  local _name=self.nametext:getText()--getString()  --
                  local _tel= self.phonetext:getText()  --self.phonetext
                  local _content=self.contenttext:getString()  --self.contenttext
                  local _company=self.companyname_text:getText()  --self.companyname_text
                   if (_name=="请输入联系人姓名"  or  _name== "") or (_tel=="请输入联系方式"  or  _tel== "")  or (_content=="请输入您的宝贵建议(200字以内)"  or  _content== "") or (_company=="请输入公司名称"  or  _company== "")  then
                            LocalData:Instance():set_back("0")
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                  if not string.find(_tel,"^[+-]?%d+$")  then
                      Server:Instance():prompt("手机号格式不正确")
                      return
                  end
                  LocalData:Instance():set_back("1") 
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
    local width = 370
    local height = 40
    --公司名称
    self.companyname_text = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.companyname_text)
    self.companyname_text:setPosition(cc.p(self.Xcompanyname_text:getPositionX(),self.Xcompanyname_text:getPositionY()))--( cc.p(130,438 ))  
    self.companyname_text:setPlaceHolder("请输入公司名称")
    self.companyname_text:setAnchorPoint(0.5,0.5)  
    self.companyname_text:setMaxLength(14)
    self.companyname_text:setFontColor(cc.c3b(255,255,255))
    self.companyname_text:setFontName("resources/com/huakangfangyuan.ttf")
    --联系人姓名
    self.nametext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.nametext)
    self.nametext:setPosition(cc.p(self.Xname_text:getPositionX(),self.Xname_text:getPositionY()))--( cc.p(130,323 ))  
    self.nametext:setPlaceHolder("请输入联系人姓名")
    self.nametext:setAnchorPoint(0.5,0.5) 
    self.nametext:setFontColor(cc.c3b(255,255,255))
    self.nametext:setMaxLength(14)
     --联系方式
    self.phonetext = ccui.EditBox:create(cc.size(width,height),res)
    self.businessback_bg:addChild(self.phonetext)
    self.phonetext:setPosition(cc.p(self.Xphone_text:getPositionX(),self.Xphone_text:getPositionY()))--( cc.p(130,323 ))  
    self.phonetext:setPlaceHolder("请输入联系方式")
    self.phonetext:setAnchorPoint(0.5,0.5) 
    self.phonetext:setFontColor(cc.c3b(255,255,255))
    self.phonetext:setMaxLength(11)
end
-- 提交内容
function aboutdetailsLayer:inputbox(  )
  
    local res = " "
    local width = 370
    local height = 40
    --手机号
    self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.phone_text)
    self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX(),self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text:setPlaceHolder("请输入手机号码")
    self.phone_text:setAnchorPoint(0.5,0.5)  
    self.phone_text:setMaxLength(11)
    self.phone_text:setFontColor(cc.c3b(255,255,255))
    -- 姓名
    self.name_text = ccui.EditBox:create(cc.size(width,height),res)
    self.advicedata_bg:addChild(self.name_text)
    self.name_text:setPosition(cc.p(self.Zname_text:getPositionX(),self.Zname_text:getPositionY()))--( cc.p(130,323 ))  
    self.name_text:setPlaceHolder("请输入姓名")
    self.name_text:setAnchorPoint(0.5,0.5) 
    self.name_text:setFontColor(cc.c3b(255,255,255))
    self.name_text:setMaxLength(14)
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
      cc.Director:getInstance():getTextureCache():removeAllTextures() 
end


return aboutdetailsLayer



