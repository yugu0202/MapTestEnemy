# -*- coding: utf-8 -*-
require './CHaserConnect.rb' #呼び出すおまじない
require './CHaserTools.rb'

include Action
include Direction
include MapInfo

# 書き換えない
target = CHaserConnect.new("everyLook") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

direction = Direction::UP

def get_slash_item values, move_direction
  move = []

  1.step(10, 2) { |i|
    next if values[i] != MapInfo::ITEM

    case i
    when 1
      move << ([2, 4] & move_direction)
    when 3
      move << ([2, 6] & move_direction)
    when 7
      move << ([8, 4] & move_direction)
    when 9
      move << ([8, 6] & move_direction)
    end
  }

  move.flatten!

  if !move.size.zero?
    return move.uniq
  else
    return move_direction
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

def attack_enemy values, action, direction
  return action, direction if values.index(MapInfo::ENEMY, 1).nil?

  enemy = values.index(MapInfo::ENEMY, 1)

  if enemy.even?
    return Action::PUT, enemy
  else
    #斜めの敵は無視(暫定対応)
    return action, direction
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

action = Action::WALK

#四方向のブロックがないリスト
move_direction = [2, 4, 6, 8].select { |i| values[i] != MapInfo::BLOCK }

#アイテムがある場合は行きたい方向のリストにする
move_direction = get_item(values, move_direction)

direction = move_direction.sample

action, direction = attack_enemy(values, action, direction)

act_values = target.order(action, direction)

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
