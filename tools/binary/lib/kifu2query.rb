#
#  kifu2query.rb
#   2chkifuのデータをDB shogi84 のkifreadテーブルに登録するためのqueryにして書き出す
#   kifubtools.rbの機能テストのために作ったようなものなので、testで置き換えられるべきスクリプト
#   2010/05/19
#   Usage :   ruby kifu2query.rb  id
#               id  は2chkifuのid
#

require './kifubtools.rb'

board = Board.new

#
# 主処理
#
  kifu_data, tesu_of_this = prepare_data(ARGV[0].to_i)
    # kifu_data : 棋譜のバイト列(2*手数バイト)

#  １行ずつ記述していく
#  注意：あるレコードRに指し手Mと盤面情報Bがあるとすると、
#        BにMを指すと次のレコードR+1の盤面になる
old_board = board.to_pg
1.upto(tesu_of_this) do |i|

  from = kifu_data[(i-1)*2]
  to = kifu_data[(i-1)*2+1]
    #  2バイトの指し手を1バイトずつ分割してfrom, toに読み直している。2ch盤面座標である。
  board.move(from, to)

  print "insert into kifread values("
  print "%3d,%s,%s);\n" % [i, sprintf("E'\\\\%03o\\\\%03o'", from, to), old_board]
  
  old_board = board.to_pg

end

# 最後に1行追加
print "insert into kifread values("
print "%3d,%s,%s);\n" % [tesu_of_this + 1, 'NULL', board.to_pg]
