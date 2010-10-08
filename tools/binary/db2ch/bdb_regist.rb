#!/usr/bin/ruby
#  bdb_regist.rb
#   2chの棋譜データをもとに局面情報を生成し、
#   binaryデータベースに登録する
#   2009/06/01
#
#   Usage:
#      ruby bdb_regist.rb from to
#      from, toは2chkifuのidを表す数字。必ずfrom < toとなるように指定すること

$hdr = '/home/skkmania/workspace/db/2chkifu.hdr'
require 'kifubtools.rb'
require 'db_connect.rb'
$logger2ch = Logger.new('log/bdb_regist.log')

def exec_regist(id)
  # 2chkifuと同じ配列の将棋盤
  # １一から縦に1,2,3とふっていく
  # その初期盤面が下記のとおり
  # 駒を表すアルファベットはDB(shogi2)と同じ


  # idで指定した棋譜情報の配列[bin_pos, 先手氏名、後手氏名、手数、結果、日付]を取得
  info = get_kifu_info($hdr, id)

  query = 'delete from kifread;'
  query += 'delete from new_boards;'
  query += 'delete from new_moves;'
  query += kifu2ch_to_query(id)
  query += "select kif_insert(#{id}, '#{info[5]}', '#{info[1]}', '#{info[2]}', '#{info[4]}');"
  # 2chのid, 日付、先手氏名、後手氏名、結果
  # query += 'delete from kifread;'
  $logger2ch.debug { query }

  db = connect_db
  $logger2ch.debug { db.inspect  }

  begin
    kekka = db.run(query)
    $logger2ch.debug { "bdb_regist.rb: kekka is #{kekka}" }
  rescue
    db.disconnect
  else
    print kekka
    db.disconnect
  end
end

#
#  main
#
from_id = ARGV[0].to_i
to_id = ARGV[1].to_i

if from_id > to_id then
  puts "Usage: bdb_regist.rb from to  (to must be larger than from)"
else
  (from_id..to_id).each{|i| exec_regist(i) }
end
