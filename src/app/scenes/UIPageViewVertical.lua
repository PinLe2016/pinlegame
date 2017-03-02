--
-- Author: peter
-- Date: 2017-02-27 13:45:06
--

--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--------------------------------
-- @module UIPageView

--[[--

quick page控件

]]

local UIPageViewItem = import("framework/cc/ui/UIPageViewItem")

local UIPageViewVertical = class("UIPageViewVertical", function()
	-- local node = display.newNode()
	local node = display.newClippingRegionNode()
	-- node:setContentSize(display.width, display.height)
	return node
end)

-- start --

--------------------------------
-- UIPageView构建函数
-- @function [parent=#UIPageView] new
-- @param table params 参数表

--[[--

UIPageViewVertical构建函数

可用参数有：

-   column 每一页的列数，默认为1
-   row 每一页的行数，默认为1
-   columnSpace 列之间的间隙，默认为0
-   rowSpace 行之间的间隙，默认为0
-   viewRect 页面控件的显示区域
-   padding 值为一个表，页面控件四周的间隙
    -   left 左边间隙
    -   right 右边间隙
    -   top 上边间隙
    -   bottom 下边间隙
-   bCirc 页面是否循环,默认为false
	contSize--单元格大小
]]
-- end --

function UIPageViewVertical:ctor(params)
	self.items_ = {}
	self.viewRect_ = params.viewRect or cc.rect(0, 0, display.width, display.height)
	self.column_ = params.column or 1
	self.row_ = params.row or 1
	self.columnSpace_ = params.columnSpace or 0
	self.rowSpace_ = params.rowSpace or 0
	self.padding_ = params.padding or {left = 0, right = 0, top = 0, bottom = 0}
	self.bCirc = params.bCirc or false
	self.page_rect_num=params.page_rect_num
	self.page_hight=params.contSize.height
	self.page_width=params.contSize.width
	self.border_pos=0
	self:setClippingRegion(self.viewRect_)

	self._isOver=true
	-- self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
	-- 		self:update_(...)
	-- 	end)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        	return self:onTouch_(event)
    	end)
end

-- start --

--------------------------------
-- 创建一个新的页面控件项
-- @function [parent=#UIPageViewVertical] newItem
-- @return UIPageViewItem#UIPageViewItem 

-- end --

function UIPageViewVertical:newItem()
	local item = UIPageViewItem.new()
	local itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	local itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_
	-- item:setContentSize(self.viewRect_.width/self.column_, self.viewRect_.height/self.row_)
	-- item:setContentSize(108, 108)
	-- item:setContentSize(itemW, itemH)

	return item
end

-- start --

--------------------------------
-- 添加一项到页面控件中
-- @function [parent=#UIPageViewVertical] addItem
-- @param node item 页面控件项
-- @return UIPageView#UIPageViewVertical 

-- end --

function UIPageViewVertical:addItem(item)
	table.insert(self.items_, item)

	return self
end

-- start --

--------------------------------
-- 移除一项
-- @function [parent=#UIPageViewVertical] removeItem
-- @param number idx 要移除项的序号
-- @return UIPageViewVertical#UIPageView 

-- end --

function UIPageViewVertical:removeItem(item)
	local itemIdx
	for i,v in ipairs(self.items_) do
		if v == item then
			itemIdx = i
		end
	end

	if not itemIdx then
		print("ERROR! item isn't exist")
		return self
	end

	if itemIdx then
		table.remove(self.items_, itemIdx)
	end

	self:reload(self.curPageIdx_)

	return self
end

-- start --

--------------------------------
-- 移除所有页面
-- @function [parent=#UIPageView] removeAllItems
-- @return UIPageView#UIPageView 

-- end --

function UIPageViewVertical:removeAllItems()
	self.items_ = {}

	self:reload(self.curPageIdx_)

	return self
end

-- start --

--------------------------------
-- 注册一个监听函数
-- @function [parent=#UIPageView] onTouch
-- @param function listener 监听函数
-- @return UIPageView#UIPageView 

-- end --

function UIPageViewVertical:onTouch(listener)
	self.touchListener = listener

	return self
end

-- start --

--------------------------------
-- 加载数据，各种参数
-- @function [parent=#UIPageView] reload
-- @param number page index加载完成后,首先要显示的页面序号,为空从第一页开始显示
-- @return UIPageView#UIPageView 

-- end --

function UIPageViewVertical:reload(idx)
	local page
	local pageCount
	self.pages_ = {}

	-- retain all items
	for i,v in ipairs(self.items_) do
		v:retain()
	end

	self:removeAllChildren()

	pageCount = self:getPageCount()
	if pageCount < 1 then
		return self
	end
	dump(pageCount)
	if pageCount > 0 then
		for i =1 , pageCount do
			page = self:createPage_(i)
			page:setVisible(true)
			table.insert(self.pages_, page)
			page:setPosition(self.viewRect_.x+self.page_width/2, self.viewRect_.y+70+self.viewRect_.height-self.page_hight*(i))
			self:addChild(page)
		end
	end
	
	if not idx or idx < 1 then
		idx = 1
	elseif idx > pageCount then
		idx = pageCount
	end
	
	self.curPageIdx_ = idx
	-- self.pages_[idx]:setVisible(true)
	-- self.pages_[idx]:setPosition(
	-- 	self.viewRect_.x, self.viewRect_.y)
	self:start_beginPoint(self.pages_[self.curPageIdx_]:getPositionY())
	-- release all items
	for i,v in ipairs(self.items_) do
		v:release()
	end

	return self
end

function UIPageViewVertical:start_beginPoint(point)
	self.star_curPageIdx_point=point
	self.border_pos=point
end

-- start --

--------------------------------
-- 跳转到特定的页面
-- @function [parent=#UIPageView] gotoPage
-- @param integer pageIdx 要跳转的页面的位置
-- @param boolean bSmooth 是否需要跳转动画
-- @param bLeftToRight 移动的方向,在可循环下有效, nil:自动调整方向,false:从右向左,true:从左向右
-- @return UIPageView#UIPageView 

-- end --

function UIPageViewVertical:gotoPage(pageIdx)

	if self.page_rect_num >=#self.pages_ then 
		return
	end

	if not self._isOver then
		return
	end

	self._isOver=false

	-- self:stopAllTransition()
	local page = self.pages_[1]
	local posX, posY = page:getPosition()
	local page_move=self.page_hight*pageIdx

	if posY==self.border_pos and pageIdx<0 then
		self._isOver=true
		return
	end

	if self.pages_[#self.pages_]:getPositionY()==self.border_pos-self.page_hight*(self.page_rect_num-1) and pageIdx>0 then
		self._isOver=true
		return
	end


	if posY+page_move<self.border_pos then
		page_move=self.border_pos-posY
	end

	if self.pages_[#self.pages_]:getPositionY()+page_move>self.border_pos-(self.page_hight*(self.page_rect_num-1)) then
		page_move=self.border_pos-(self.page_hight*(self.page_rect_num-1))-self.pages_[#self.pages_]:getPositionY()
	end


	for i=1,#self.pages_ do
			local page=self.pages_[i]
			transition.moveTo(page,
				{x = posX, y = page:getPositionY()+page_move, time = 0.2,
				onComplete = function()
					self.star_curPageIdx_point=self.pages_[1]:getPositionY()
					self._isOver=true
				end})
	end


	return self
end

-- start --

--------------------------------
-- 得到页面的总数
-- @function [parent=#UIPageView] getPageCount
-- @return number#number 

-- end --

function UIPageViewVertical:getPageCount()
	return math.ceil(table.nums(self.items_)/(self.column_*self.row_))
end

-- start --

--------------------------------
-- 得到当前页面的位置
-- @function [parent=#UIPageView] getCurPageIdx
-- @return number#number 

-- end --

function UIPageViewVertical:getCurPageIdx()
	return self.curPageIdx_
end

-- start --

--------------------------------
-- 设置页面控件是否为循环
-- @function [parent=#UIPageView] setCirculatory
-- @param boolean bCirc 是否循环
-- @return UIPageView#UIPageView 

-- end --

function UIPageViewVertical:setCirculatory(bCirc)
	self.bCirc = bCirc

	return self
end

-- private

function UIPageViewVertical:createPage_(pageNo)
	local page = display.newNode()
	local item
	local beginIdx = pageNo--self.row_*self.column_*(pageNo-1) + 1
	local itemW, itemH

	itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_
	local bBreak = false
	for row=1,self.row_ do
		for column=1,self.column_ do
			item = self.items_[beginIdx]
			beginIdx = beginIdx + 1
			if not item then
				bBreak = true
				break
			end
			page:addChild(item)

			-- item:setAnchorPoint(cc.p(0.5, 0.5))
			-- item:setPosition(
			-- 	self.padding_.left + (column - 1)*self.columnSpace_ + column*itemW - itemW/2,
			-- 	self.viewRect_.height - self.padding_.top - (row - 1)*self.rowSpace_ - row*itemH + itemH/2)
				-- self.padding_.bottom + (row - 1)*self.rowSpace_ + row*itemH - itemH/2)
		end
		if bBreak then
			break
		end
	end

	page:setTag(1500 + pageNo)

	return page
end

function UIPageViewVertical:isTouchInViewRect_(event, rect)
	rect = rect or self.viewRect_
	local viewRect = self:convertToWorldSpace(cc.p(rect.x, rect.y))
	viewRect.width = rect.width
	viewRect.height = rect.height

	return cc.rectContainsPoint(viewRect, cc.p(event.x, event.y))
end

function UIPageViewVertical:onTouch_(event)
	if "began" == event.name
		and self.page_rect_num >=#self.pages_ then
		printInfo("UIPageView - touch didn't in viewRect")
		return false
	end

	if "began" == event.name then
		self:stopAllTransition()
	
		self.bDrag_ = false
	elseif "moved" == event.name then
		self.bDrag_ = true
		-- print("----",event.y, event.prevY)
		self.speed = event.y - event.prevY
		self:scroll(self.speed)
	elseif "ended" == event.name then
		if self.bDrag_ then
			self:scrollAuto()
		else
			-- self:resetPages_()
			-- self:onClick_(event)
		end
	end

	return true
end

--[[--

重置页面,检查当前页面在不在初始位置
用于在动画被stopAllTransition的情况

]]
function UIPageViewVertical:resetPages_()
	local x,y = self.pages_[self.curPageIdx_]:getPosition()

	if y == self.viewRect_.y then
		return
	end
	print("UIPageView - resetPages_")
	-- self.pages_[self.curPageIdx_]:getPosition(self.viewRect_.x, y)
	self:disablePage()
	self:gotoPage(self.curPageIdx_)
end

--[[--

重置相关页面的位置

@param integer pos 要移动到的位置
@param bLeftToRight 移动的方向,在可循环下有效, nil:自动调整方向,false:从右向左,true:从左向右

]]
function UIPageViewVertical:resetPagePos(pos, bLeftToRight)
	local pageIdx = self.curPageIdx_
	local page
	local pageWidth = self.viewRect_.width
	local dis
	local count = #self.pages_

	dis = pos - pageIdx
	if self.bCirc then
		local disL,disR
		if dis > 0 then
			disR = dis
			disL = disR - count
		else
			disL = dis
			disR = disL + count
		end

		if nil == bLeftToRight then
			dis = ((math.abs(disL) > math.abs(disR)) and disR) or disL
		elseif bLeftToRight then
			dis = disR
		else
			dis = disL
		end
	end

	local disABS = math.abs(dis)
	local x = self.pages_[pageIdx]:getPosition()

	for i=1,disABS do
		if dis > 0 then
			pageIdx = pageIdx + 1
			x = x + pageWidth
		else
			pageIdx = pageIdx + count
			pageIdx = pageIdx - 1
			x = x - pageWidth
		end
		pageIdx = pageIdx % count
		if 0 == pageIdx then
			pageIdx = count
		end
		page = self.pages_[pageIdx]
		if page then
			page:setVisible(true)
			page:setPosition(x, self.viewRect_.y)
		end
	end
end

--[[--

移动到相对于当前页的某个位置

@param integer pos 要移动到的位置
@param bLeftToRight 移动的方向,在可循环下有效, nil:自动调整方向,false:从右向左,true:从左向右

]]
function UIPageViewVertical:scrollPagePos(pos, bLeftToRight)
	local pageIdx = self.curPageIdx_
	local page
	local pageWidth = self.viewRect_.width
	local dis
	local count = #self.pages_

	dis = pos - pageIdx
	if self.bCirc then
		local disL,disR
		if dis > 0 then
			disR = dis
			disL = disR - count
		else
			disL = dis
			disR = disL + count
		end

		if nil == bLeftToRight then
			dis = ((math.abs(disL) > math.abs(disR)) and disR) or disL
		elseif bLeftToRight then
			dis = disR
		else
			dis = disL
		end
	end

	local disABS = math.abs(dis)
	local x = self.viewRect_.x
	local movedis = dis*pageWidth

	for i=1, disABS do
		if dis > 0 then
			pageIdx = pageIdx + 1
		else
			pageIdx = pageIdx + count
			pageIdx = pageIdx - 1
		end
		pageIdx = pageIdx % count
		if 0 == pageIdx then
			pageIdx = count
		end
		page = self.pages_[pageIdx]
		if page then
			page:setVisible(true)
			transition.moveBy(page,
					{x = -movedis, y = 0, time = 0.3})
		end
	end
	transition.moveBy(self.pages_[self.curPageIdx_],
					{x = -movedis, y = 0, time = 0.3,
					onComplete = function()
						local pageIdx = (self.curPageIdx_ + dis + count)%count
						if 0 == pageIdx then
							pageIdx = count
						end
						self.curPageIdx_ = pageIdx
						self:disablePage()
						self:notifyListener_{name = "pageChange"}
					end})
end

function UIPageViewVertical:stopAllTransition()
	for i,v in ipairs(self.pages_) do
		transition.stopTarget(v)
	end
end

function UIPageViewVertical:disablePage()
	local pageIdx = self.curPageIdx_
	local page

	for i,v in ipairs(self.pages_) do
		if i ~= self.curPageIdx_ then
			v:setVisible(false)
		end
	end
end

function UIPageViewVertical:scroll(dis)
	local threePages = {}
	local count
	if self.pages_ then
		count = #self.pages_
	else
		count = 0
	end
	-- conut=self.curPageIdx_
	local page

	for i=1,#self.pages_ do
		local posY = self.pages_[i]:getPositionY()
		self.pages_[i]:setPositionY(posY+dis)
		-- self.page_hight
	end
	-- if 0 == count then
	-- 	return
	-- elseif 1 == count then
	-- 	table.insert(threePages, false)
	-- 	table.insert(threePages, self.pages_[self.curPageIdx_])
	-- elseif 2 == count then
	-- 	local posX, posY = self.pages_[self.curPageIdx_]:getPosition()
	-- 	if posY > self.viewRect_.y then
	-- 		page = self:getNextPage(false)
	-- 		if not page then
	-- 			page = false
	-- 		end
	-- 		table.insert(threePages, page)
	-- 		table.insert(threePages, self.pages_[self.curPageIdx_])
	-- 	else
	-- 		table.insert(threePages, false)
	-- 		table.insert(threePages, self.pages_[self.curPageIdx_])
	-- 		table.insert(threePages, self:getNextPage(true))
	-- 	end
	-- else
	-- 	page = self:getNextPage(false)
	-- 	if not page then
	-- 		page = false
	-- 	end
	-- 	table.insert(threePages, page)
	-- 	table.insert(threePages, self.pages_[self.curPageIdx_])
	-- 	table.insert(threePages, self:getNextPage(true))
	-- end

	-- self:scrollLCRPages(threePages, dis)
end

function UIPageViewVertical:scrollLCRPages(threePages, dis)
	local posX, posY
	local pageL = threePages[1]
	local page = threePages[2]
	local pageR = threePages[3]

	-- current
	posX, posY = page:getPosition()
	posY = posY + dis
	page:setPosition(posX, posY)

	-- left
	posY = posY - self.viewRect_.height
	if pageL and "boolean" ~= type(pageL) then
		pageL:setPosition(posX, posY)
		if not pageL:isVisible() then
			pageL:setVisible(true)
		end
	end

	posY = posY + self.viewRect_.height * 2
	if pageR then
		pageR:setPosition(posX, posY)
		if not pageR:isVisible() then
			pageR:setVisible(true)
		end
	end
end

function UIPageViewVertical:scrollAuto()
	local page = self.pages_[1]

	local bChange = false
	local posX, posY = page:getPosition()
	local dis = posY-self.star_curPageIdx_point 
	
	local page_dis=dis%self.page_hight
	
	local page_move=page_dis

	local symbol_=-1
	if dis>0 then symbol_=1 end
		
	

	if  dis>5 then
			page_move=(self.page_hight-page_dis)*symbol_
	elseif dis<-5 then
		--todo
			page_move=(page_dis)*symbol_
	end

	if posY<self.border_pos then
		page_move=self.border_pos-posY
	end

	if self.pages_[#self.pages_]:getPositionY()>self.border_pos-self.page_hight*(self.page_rect_num-1) then
		page_move=(self.border_pos-self.page_hight*(self.page_rect_num-1))-self.pages_[#self.pages_]:getPositionY()
	end
	-- print("222---",self.pages_[#self.pages_]:getPositionY(),(self.border_pos-self.page_hight*6),page_move)	
	for i=1,#self.pages_ do
			local page=self.pages_[i]
			transition.moveTo(page,
				{x = posX, y = page:getPositionY()+page_move, time = 0.2,
				onComplete = function()
					self.star_curPageIdx_point=self.pages_[1]:getPositionY()

				end})
	end


end

function UIPageViewVertical:onClick_(event)
	local itemW, itemH

	itemW = (self.viewRect_.width - self.padding_.left - self.padding_.right
				- self.columnSpace_*(self.column_ - 1)) / self.column_
	itemH = (self.viewRect_.height - self.padding_.top - self.padding_.bottom
				- self.rowSpace_*(self.row_ - 1)) / self.row_

	local itemRect = {width = itemW, height = itemH}

	local clickIdx
	for row = 1, self.row_ do
		itemRect.y = self.viewRect_.y + self.viewRect_.height - self.padding_.top - row*itemH - (row - 1)*self.rowSpace_
		for column = 1, self.column_ do
			itemRect.x = self.viewRect_.x + self.padding_.left + (column - 1)*(itemW + self.columnSpace_)

			if self:isTouchInViewRect_(event, itemRect) then
				clickIdx = (row - 1)*self.column_ + column
				break
			end
		end
		if clickIdx then
			break
		end
	end

	if not clickIdx then
		-- not found, maybe touch in space
		return
	end

	clickIdx = clickIdx + (self.column_ * self.row_) * (self.curPageIdx_ - 1)

	self:notifyListener_{name = "clicked",
		item = self.items_[clickIdx],
		itemIdx = clickIdx}
end

function UIPageViewVertical:notifyListener_(event)
	if not self.touchListener then
		return
	end

	event.pageView = self
	event.pageIdx = self.curPageIdx_
	self.touchListener(event)
end

function UIPageViewVertical:getNextPage(bRight)
	if not self.pages_ then
		return
	end

	if self.pages_ and #self.pages_ < 2 then
		return
	end

	local pos = self:getNextPageIndex(bRight)

	return self.pages_[pos]
end

function UIPageViewVertical:getNextPageIndex(bRight)
	local count = #self.pages_
	local pos
	if bRight then
		pos = self.curPageIdx_ - 1
	else
		pos = self.curPageIdx_ + 1
	end

	if self.bCirc then
		pos = pos + count
		pos = pos%count
		if 0 == pos then
			pos = count
		end
	end

	return pos
end



return UIPageViewVertical
