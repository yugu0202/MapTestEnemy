# -*- coding: utf-8 -*-
require './CHaserConnect.rb' #呼び出すおまじない
require './CHaserTools.rb'

include Action
include Direction
include MapInfo

# 書き換えない
target = CHaserConnect.new("avoid wall") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

direction = Direction::UP

def create_can_move values, direction
  can_move = []

  can_move = [2, 4, 6, 8].select { |i|
    values[i] != MapInfo::BLOCK
  }

  return can_move
end

def select_move_to_wall can_move, direction
  return direction if can_move.size.zero?

  if can_move.include?(direction)
    return direction
  else
    return can_move.sample(random)
  end
end

def get_item values, move_direction
  return move_direction if !values.include?(MapInfo::ITEM)

  item = [2, 4, 6, 8].select { |i| values[i] == MapInfo::ITEM }

  if !item.size.zero?
    return item
  else
    return get_slash_item(values, move_direction)
  end

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

move_to_wall = select_move_to_wall(can_move, direction)

move_direction = get_item(values, move_direction)

direction = move_direction.sample

act_values = target.order(Action::WALK, direction)

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
