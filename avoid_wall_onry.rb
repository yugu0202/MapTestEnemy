# -*- coding: utf-8 -*-
require './CHaserConnect.rb' #呼び出すおまじない
require './CHaserTools.rb'

include Action
include Direction
include MapInfo

# 書き換えない
target = CHaserConnect.new("avoid wall onry") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

direction = Direction::UP

def create_can_move values
  can_move = []

  2.step(9, 2) { |i|
    if values[i] != MapInfo::BLOCK
      can_move.push(i)
    end
  }

  return can_move
end

#--------ここから--------
loop do # ここからループ

#---------ここから---------
  values = target.getReady

  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

can_move = create_can_move(values)

if can_move.include?(direction)
  act_values = target.order(Action::WALK, direction)
else
  # 同じ方向が含まれていない場合、ランダムに選択
  direction = can_move.sample
  act_values = target.order(Action::WALK, direction)
end

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
