--
-- Example2_1.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify
-- it under the terms of the MIT license. See LICENSE for details.
--

require "dbg/DklBaseGraphics"

local bg
local x
local y
local col

function setup()
	size(500,350)
	local f = loadFont("data/Karla.ttf",12)
	textFont(f)
	bg = DklBaseGraphics:new(width(),height())
	x = {10,20,30,40,50}
	y = {20,30,50,20,30}
	col = {"#00FF00","#FF0000"}
end

function draw()
	background(255)
	
	bg:plot(x,y,{type="s", col=col})
	--bg:points(x,y)
	--bg:lines(x,y)

end

function windowResized(w,h)
	bg:resize_window(w,h)
end
