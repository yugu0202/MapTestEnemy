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

looked = false

direction = Direction::UP
prev_move = 0

#斜めの座標からそこに向かえる移動方向の配列を返す
def get_adjacent_direction point
  case point
  when 1
    return [2, 4]
  when 3
    return [2, 6]
  when 7
    return [8, 4]
  when 9
    return [8, 6]
  end

  return nil
end

#斜め方向にアイテムがあった際に取りに行ける方向の配列を返す
def get_slash_item values, move_direction
  move = []

  for i in [1, 3, 7, 9]
    next if values[i] != MapInfo::ITEM

    move << get_adjacent_direction(i)
  end

  move = move.flatten.uniq & move_direction

  if move.empty?
    return move_direction
  else
    return move
  end

end

#周囲にあればアイテムがある方向のみの配列を返す
def get_item values, move_direction
  return move_direction if !values.include?(MapInfo::ITEM)

  item = [2, 4, 6, 8].select { |i| values[i] == MapInfo::ITEM }

  if item.empty?
    return get_slash_item(values, move_direction)
  else
    return item
  end

end

#四方に敵がいた場合にputを行う
def attack_enemy values, action, direction
  return action, direction if values.rindex(MapInfo::ENEMY) == 0

  #敵がいるマスを特定する
  enemy = values.rindex(MapInfo::ENEMY)

  #敵がいるマスが四方のどれかだったらputを行う
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

if !looked
  #四方向のブロックがない方向の配列を生成する
  move_direction = [2, 4, 6, 8].select { |i| values[i] != MapInfo::BLOCK }

  #前いた位置に戻らない
  move_direction.delete(Direction.Reverse(prev_move)) if move_direction.size > 1

  #アイテムがある場合は行きたい方向の配列にする
  move_direction = get_item(values, move_direction)

  #向きを決定する
  direction = move_direction.sample

  action = Action::LOOK
  looked = true
else
  looked = false
end

#周囲に敵がいた場合に対処する
action, direction = attack_enemy(values, action, direction)

prev_move = direction

#行動を行いその結果を受け取る
act_values = target.order(action, direction)

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
