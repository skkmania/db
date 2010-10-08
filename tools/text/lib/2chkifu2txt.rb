#
#  2chkifu2txt.rb
#   2chkifuのデータを柿木形式に似た形式のファイルにして書き出す
#   手数： 終点 駒 成り・不成り (始点)
#   という形式。
#   このスクリプト自体は、2chkifutools.rbのテスト目的で書かれたもの
#   2008/12/1
#   Usage :   ruby 2chkifu2txt.rb  id
#               id  は2chkifuのid
#

require './2chkifutools.rb'

  board_2ch =" lxpxxxPxLnbpxxxPRNsxpxxxPxSgxpxxxPxGkxpxxxPxKgxpxxxPxGsxpxxxPxSnrpxxxPBNlxpxxxPxL".split(//)

  black_stand = { "P" => 0, "L" => 0, "N" => 0, "S" => 0, "G" => 0, "B" => 0, "R" => 0 } 
  white_stand = { "p" => 0, "l" => 0, "n" => 0, "s" => 0, "g" => 0, "b" => 0, "r" => 0 } 

# 盤と駒台
board_info = [board_2ch, black_stand, white_stand]

#
# 主処理
#
  kifu_data, tesu_of_this = prepare_data(ARGV[0].to_i)

#  手を１行ずつ記述していく
1.upto(tesu_of_this) do |i|

  from_pos_2ch = kifu_data[(i-1)*2].to_i
  to_pos_2ch = kifu_data[(i-1)*2+1].to_i
  turn = (i%2 == 1)
  piece, promote = move(from_pos_2ch, to_pos_2ch, turn, board_info)

  from_pos_db = henkan(from_pos_2ch)
  to_pos_db = henkan(to_pos_2ch)

  print i,': '
  print to_pos_db,' ',piece,' ',promote,' (',from_pos_db,')',"\n"

end

