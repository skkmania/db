#
#  2chkifu2query.rb
#   2chkifuの1局分のデータをDB kifreadテーブルに登録するための一連のsql queryにして書き出す
#   このスクリプトは2chkifutools.rbのテスト目的で書かれたもの
#   2008/12/1
#   Usage :   ruby 2chkifu2query.rb  id
#               id  は2chkifuのid
#

require './2chkifutools.rb'

board_2ch =" lxpxxxPxLnbpxxxPRNsxpxxxPxSgxpxxxPxGkxpxxxPxKgxpxxxPxGsxpxxxPxSnrpxxxPBNlxpxxxPxL".split(//)

  # 持ち駒
  black_stand = { "P" => 0, "L" => 0, "N" => 0, "S" => 0, "G" => 0, "B" => 0, "R" => 0 } 
  white_stand = { "p" => 0, "l" => 0, "n" => 0, "s" => 0, "g" => 0, "b" => 0, "r" => 0 } 

# 盤と駒台
board_info = [board_2ch, black_stand, white_stand]

#
# 主処理
#
  kifu_data, tesu_of_this = prepare_data(ARGV[0].to_i)
    # kifu_data : 棋譜のバイト列(2*手数バイト)

#  １行ずつ記述していく
#  注意：あるレコードRに指し手Mと盤面情報Bがあるとすると、
#        BにMを指すと次のレコードR+1の盤面になる
old_board = board_2ch_to_db(board_2ch)
old_black = ''
old_white = ''
1.upto(tesu_of_this) do |i|

  from_pos_2ch = kifu_data[(i-1)*2].to_i
  to_pos_2ch = kifu_data[(i-1)*2+1].to_i
    #  2バイトの指し手を1バイトずつ分割してfrom, toに読み直している。2ch盤面座標である。
  turn = (i%2 == 1)
  piece, promote = move(from_pos_2ch, to_pos_2ch, turn, board_info)

  from_pos_db = henkan(from_pos_2ch)
  to_pos_db = henkan(to_pos_2ch)

  print "insert into kifread values("
  print "%3d,%2d,%2d,'%s',%5s,%5s,'%s','%s','%s');\n" % [i, from_pos_db, to_pos_db, piece, promote, turn,old_black, old_board, old_white]
  
  old_black = stand_to_str(black_stand)
  old_white = stand_to_str(white_stand)
  old_board = board_2ch_to_db(board_2ch)

end

black_hand = stand_to_str(black_stand)
white_hand = stand_to_str(white_stand)
board = board_2ch_to_db(board_2ch)

# 最後に1行追加
print "insert into kifread values(\
  #{tesu_of_this+1}, null, null, null, null, #{(tesu_of_this + 1) % 2 == 1},\
  '#{black_hand}', '#{board}', '#{white_hand}');","\n"
