# -*- coding: utf-8 -*-
require 'CHaserConnect.rb' #呼び出すおまじない
require 'CHaserTools.rb'

include Action
include Direction
include MapInfo

# 書き換えない
target = CHaserConnect.new("everyLook") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

direction = Direction::UP

def get_item values, can_move
  2.step(9, 2) { |i| item.push(i) if values[i] == MapInfo::ITEM }

#--------ここから--------
loop do # ここからループ

#---------ここから---------
  values = target.getReady

  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

  can_move = 2.step(9, 2) { |i| can_move.push(i) if values[i] != MapInfo::BLOCK }.to_a


direction = can_move.sample

act_values = target.order(Action::WALK, direction)

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
