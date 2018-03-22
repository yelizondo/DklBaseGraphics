--
-- DklPlot.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify
-- it under the terms of the MIT license. See LICENSE for details.
--

DklBaseGraphics = DklBaseGraphics or {}

require "dbg/DklAxis"

function DklBaseGraphics:plot(x,y,args)
	args = args or {}
	local xlim = xlim or range(x)
	local ylim = ylim or range(y)
	self:plot_new()
	self:plot_window(xlim,ylim,args)
	
	local axes = args.axes or true
	local ann = args.axes or self.plt.ann
	local bty = args.bty or "o"
	local type = args.type or "p"

	if (type=="p" or type=="o" or type=="b") then
		self:points(x,y,args)
	elseif (type=="l" or type=="o" or type=="b") then
		self:lines(x,y,args)
	end
	if (axes) then
		self:axis(1,args)
		self:axis(2,args)
		self:box({which="plot",bty=bty})
	end
	if (ann) then
		self:title(args)
	end
end

function DklBaseGraphics:points(x,y,args)
	args = args or {}
	
	local pch = args.pch or self.plt.pch
	local tpch = type(pch) == "table"
	local _pch = pch

	local cex = args.cex or self.plt.cex
	local tcex = type(cex) == "table"
	local _cex = cex
	
	local col = args.col or self.plt.col
	local tcol = type(col) == "table"
	
	local bg = args.bg or self.plt.bg
	local tbg = type(bg) == "table"

	local lwd = args.lwd or self.plt.lwd
	local tlwd = type(lwd) == "table"
	local _tmp
		
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	noFill()
	_tmp = not tcol and stroke(col)
	_tmp = not tbg and pch > 14 and fill(bg)
	_tmp = not tlwd and strokeWeight(lwd)
	
	for i=1,#x do
		_cex = tcex and cex[(i-1)%#cex+1] or _cex
		_pch = tpch and pch[(i-1)%#pch+1] or _pch
		_tmp = tcol and stroke(col[(i-1)%#col+1])
		_tmp = tbg and _pch > 14 and fill(bg[(i-1)%#bg+1])
		_tmp = tlwd and strokeWeight(lwd[(i-1)%#tlwd+1])
		shape(_pch,x[i]*self.plt.xscl,-y[i]*self.plt.yscl,
				_cex*self.dev.cra[1],_cex*self.dev.cra[1])
	end
	popMatrix()
end

function DklBaseGraphics:lines(x,y,args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local _col = type(col) == "table" and col[1] or col
	stroke(_col)

	local lwd = args.lwd or self.plt.lwd
	local _lwd = type(lwd) == "table" and lwd[1] or lwd
	strokeWeight(_lwd)
	
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	beginShape()
	for i=1,#x do
		vertex(x[i]*self.plt.xscl,-y[i]*self.plt.yscl)
	end
	endShape()
	
	popMatrix()
end

function DklBaseGraphics:text(x,y,labels,args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local tcol = type(col) == "table"
	
	local cex = args.cex or self.plt.cex
	local tcex = type(cex) == "table"
	local _tmp
	
	local pos = args.pos or 1
	local offset = args.offset or 1
	local offX=0
	local offY=0
	if (pos==1) then
		offY = offset*self.dev.cra[1]
	elseif (pos==2) then
		offX = -offset*self.dev.cra[1]
	elseif (pos==3) then
		offY = -offset*self.dev.cra[1]
	elseif (pos==4) then
		offX = offset*self.dev.cra[1]
	end

	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	_tmp = not tcol and stroke(col)
--	_tmp = not tcex and textSize(cex)
	
	for i=1,#x do
		_tmp = tcol and stroke(col[(i-1)%#col+1])
--		_tmp = tcex and textSize(cex[(i-1)%#cex+1])
		text(labels[i],x[i]*self.plt.xscl+offX,-y[i]*self.plt.yscl-offY)
	end
	
	popMatrix()
end

function DklBaseGraphics:identify(x,y,args)
	args = args or {}
	
	local tlrnc = args.tolerance or 0.1
	local offset = args.offset or 1
	local labels = args.labels or nil
	offset = offset * self.dev.cra[1]
	
	event(PRESSED)
	rectMode(CENTER)
	stroke(0,0)
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	local evt = nil
	for i=1,#x do
		evt = rect(x[i]*self.plt.xscl,-y[i]*self.plt.yscl,
				tlrnc*self.dev.res,tlrnc*self.dev.res)
		if (evt) then
			table.insert(self.fig.selection,i)
		end
	end
	if (labels) then
		for j,i in pairs(self.fig.selection) do
			text(labels[i],x[i]*self.plt.xscl+offset,-y[i]*self.plt.yscl-offset)
		end
	end
	popMatrix()
	noEvent()
	return self.fig.selection
end
