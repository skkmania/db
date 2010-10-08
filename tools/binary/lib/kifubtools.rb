#
#  kifubtools.rb
#   2chkifuのデータを扱う道具(バイナリ版)
#   2009/06/01
#

def henkan(x)
  # 2chkifuでは盤面の各マスを１バイトの数字で表している
  # 1一から1九までが1,2,3...9と縦に順に数字をふっていく
  # 2一から2九までが10,11,...18
  #  .....
  # 9一から9九までが73,74,...81
  # それを、人間の読みやすい表現の数字(DBで使用している）に変換する関数
  # また、成り駒、持ち駒のことも考慮する
  # 成り駒の場合、盤面座標に128を足してあるのでこれを引く
  # 持ち駒は、82 - 88 の値をとる。DBでは持ち駒のfrom座標を0とする
  # x : 1byte unsigned int
  # 返り値： 6七 -> 67 のように符号をそのまま数字にかえたもの
  # 
  return 0 if (82..88).include?(x)
  x -= 128 if x > 128
  x%9 == 0 ?  (((x-1)/9)+1)*10 + 9 : (((x-1)/9)+1)*10 + x%9
end

def get_kifu_info(hdr_file, id)
  # 入力値 ヘッダファイル名 棋譜の2chid
  # 返り値 idで指定した棋譜のbin_pos, 先手、後手の氏名、手数、結果、日付
  # bin_pos とは、
  # binファイルにおいて、id の棋譜の始まる位置（バイトカウント）である。
  # id を与えられると、2chkifu.hdrファイルを先頭からサーチして
  # 順々に各棋譜の手数からバイト数の累積を求め返す。
  # 各棋譜はその棋譜の手数情報4バイトから始まる
  # ここで返すのは、その手数情報の直前までに読むべきバイト数である
  accum = 0; kif_num = 0; black = ''; white = ''; tesu = 0; result = ''; gdate = ''
  open(hdr_file,"r") do |src|
    while line = src.gets
      if /^\d/ =~ line then
        num_ary = line.scan(/\d+/)
        break if num_ary[0].to_i == id
        kif_num += 1
        accum += num_ary[3].to_i
      end
    end
    tesu = num_ary[3].to_i
    case
      when line =~ /先手の勝ち/
        result = 'b'
      when line =~ /後手の勝ち/
        result = 'w'
      when line =~ /千日手/
        result = 's'
      when line =~ /持将棋/
        result = 'j'
      else
        result = 'u'
    end
    line = src.gets; black = line.split('：')[1].chomp
    line = src.gets; white = line.split('：')[1].chomp
    line = src.gets; gdate = line.split('：')[1].chomp.gsub(/\//,'-')
  end
  # kif_num は最初の１行のせいで１増えてしまっているので修正
  kif_num -= 1
  # 先頭の8バイト + 4バイト（各棋譜の手数）*kif_num + 2バイト（各手）*accum
  bin_pos = 8 + 4*kif_num + 2*accum
  [bin_pos, black, white, tesu, result, gdate]
end

# 駒を数字で表す(5bit)
#  歩、香、桂、銀、金、角、飛、王 の順に0,1,2,3,4,5,6,7が基本
#  裏返っていたら+8(4bit目に1), 後手は+16(5bit目に1)
#  先手 歩、   香   、桂、   銀、   金、   角、   飛、   王、   と、   成香、 成桂、 成銀、 馬、   龍
#      00000, 00001, 00010, 00011, 00100, 00101, 00110, 00111, 01000, 01001, 01010, 01011, 01101, 01110
#  後手 歩、   香   、桂、   銀、   金、   角、   飛、   王、   と、   成香、 成桂、 成銀、 馬、   龍
#      10000, 10001, 10010, 10011, 10100, 10101, 10110, 10111, 11000, 11001, 11010, 11011, 11101, 11110
P_MASK   = 0b10111  # 駒と成り駒の違いは下から4ビットめが立っているかどうか。成り駒にP_MASKをかけると元の駒になる
W2B_MASK = 0b01111  # 先手と後手の駒の違いは下から5ビットめが立っているかどうか。後手の駒にこれを&すると先手の駒になる
B2W_MASK = 0b10000  # W2B_MASKの反転したもの。先手の駒にこれを|すると後手の駒になる
#  定数指定
PROMOTED      = 90    #  駒の配列には値として各駒の盤面座標を置くのだが、成り駒の場合はまず90という値をいれておいて、配列の末尾の対応する位置に盤面座標の数字をいれることにする。
PROMOTE_DIV   = 128   #  指し手の記述で、成るときは128を足すことにしている。
WHITE_DIV     = 128   #  盤面座標で、後手なら128を足すことにしている。
NUM_OF_PIECES = 40    #  駒の数。平手なので４０個。
BLACK_HAND = 0        #  先手持ち駒の盤面座標
WHITE_HAND = 128      #  後手持ち駒の盤面座標
class Board
  def initialize
    # boardは盤面座標 => 駒のハッシュ。
    # 盤面座標は1から81までの整数。１０進数。先手持ち駒は0, 後手持ち駒は128
    # 先手玉0b00111の座標は局面の手番をも表す。先手番 -> 座標,  後手番 -> 座標 + 128
    @board = {  1 => 0b10001,                 3 => 0b10000,  7 => 0b00000,                 9 => 0b00001,
               10 => 0b10010, 11 => 0b10101, 12 => 0b10000, 16 => 0b00000, 17 => 0b00110, 18 => 0b00010,
	       19 => 0b10011,                21 => 0b10000, 25 => 0b00000,                27 => 0b00011,
	       28 => 0b10100,                30 => 0b10000, 34 => 0b00000,                36 => 0b00100,
	       37 => 0b10111,                39 => 0b10000, 43 => 0b00000,                45 => 0b00111,
	       46 => 0b10100,                48 => 0b10000, 52 => 0b00000,                54 => 0b00100,
	       55 => 0b10011,                57 => 0b10000, 61 => 0b00000,                63 => 0b00011,
	       64 => 0b10010, 65 => 0b10110, 66 => 0b10000, 70 => 0b00000, 71 => 0b00101, 72 => 0b00010,
	       73 => 0b10001,                75 => 0b10000, 79 => 0b00000,                81 => 0b00001 }
    # 持ち駒の個数の配列。添字が駒の種類に対応する。
    @black_stand = [ 0, 0, 0, 0, 0, 0, 0 ]
    @white_stand = [ 0, 0, 0, 0, 0, 0, 0 ]
    @turn = (@board.index(0b00111) < WHITE_DIV) 
    #  先手玉の盤面座標に、盤面の手番情報を付加する。
    #  先手番なら盤面座標そのまま。後手番なら先頭ビットを立てるというイメージ。
    @ary = []
  end

  def turn
    # 手番をbooleanで返す
    # 先手番 true,   後手番 false
    (@board.index(0b00111) < WHITE_DIV)
    #  先手玉の盤面座標に、盤面の手番情報が付加されている。
    #  先手番なら盤面座標そのまま。後手番なら先頭ビットを立てるというイメージ。
    #  先手番なら座標の値が128より小さく、後手番なら大きい
  end

  def move(from, to)
    # 入力: 指し手 from, to はそれぞれ1バイトの数字
    #    移動元 unsigned char 1バイト 盤面座標1-81 持ち駒=82-88(歩-飛)
    #    移動先 unsigned char 1バイト 盤面座標1-81 成るときは +128
    # これにしたがって、自身の状態を変更する
    # print "turn: #{turn} : from : #{from}, to : #{to}\n"
    # print "turn_from : #{@board[from]}, turn_to : #{@board[to]}\n"
    begin
      # 持ち駒をうつときの処理
      if from > 81 and from < 89
	unless (turn ? @black_stand[from - 82] : @white_stand[from - 82]) > 0
	  #  持ち駒の存在確認
	  raise '持ち駒を動かすように指定されましたが、その持ち駒が見つかりませんでした。' 
	else
	  # 存在すれば、それを持ち駒スタンドからひとつ削除
	  turn ? @black_stand[from - 82] -= 1 : @white_stand[from - 82] -= 1
	end
	# 打った地点の処理
        @board[to] = ((from - 82) + (turn ? 0 : 16))
      # 盤上の駒を動かす処理
      else
	#  駒が成るときの処理
	if to > PROMOTE_DIV
	  # 駒をとるときの処理
	  if @board[to^PROMOTE_DIV]
	    # 進む位置に駒が存在するならば、その駒をとり持ち駒スタンドに追加
	    # 成り -> 表にしてから、先手のときはとる駒が後手の駒なので、先手の駒に変換している
	    turn ? @black_stand[((@board[to^PROMOTE_DIV])&P_MASK)&W2B_MASK] += 1 : @white_stand[(@board[to^PROMOTE_DIV])&P_MASK] += 1
	  end
	  # 動き先の地点の処理 
	  @board[to^PROMOTE_DIV] = @board[from] + 8
	# 駒が成らないときの処理
	else
	  # 駒をとるときの処理
	  if @board[to]
	    # 進む位置に駒が存在するならば、その駒をとり持ち駒スタンドに追加
	    # 成り -> 表にしてから、先手のときはとる駒が後手の駒なので、先手の駒に変換している
	    turn ? @black_stand[((@board[to])&P_MASK)&W2B_MASK] += 1 : @white_stand[(@board[to])&P_MASK] += 1
	  end
	  # 動き先の地点の処理 
	  @board[to] = @board[from]
	end
	# 動き元の地点の処理
	@board.delete from
      end
    rescue => ex
      puts "exception occure! #{ex.message}"
      exit
    end
    change_turn
  end

  def change_turn
    # 手番の変更
    tmp = @board.index(0b00111)^WHITE_DIV
    @board.delete @board.index(0b00111)
    @board[tmp] = 0b00111
  end

  def ary2byte
    # 0 or 1 の要素からなる配列@aryを8個ずつ読み、バイト文字列として返す
    # 末尾の余りにはrubyが0を埋めてくれる。unpackすると0がついてくる。
    # 読み取るべきデータの個数は持ち駒の個数が先頭のほうに明記されているので問題ない
    [@ary.join].pack("B*")
  end

  def to_ary
    # board情報を0 or 1 の要素からなる配列に変換
    @ary[0]     = (turn ? 0 : 1)
    @ary[1..6]  = sprintf("%06b", @black_stand.inject(0){|m,e| m += e }).split('').map{|i| i.to_i }
    @ary[7..12] = sprintf("%06b", @black_stand.inject(0){|m,e| m += e }).split('').map{|i| i.to_i }
    @black_stand.each_with_index{|e,i| e.times do @ary += sprintf("%03b", i).split('').map{|i| i.to_i } end }
    @white_stand.each_with_index{|e,i| e.times do @ary += sprintf("%03b", i).split('').map{|i| i.to_i } end }
    (1..81).each{|i| @ary.push(@board[i] ? 1 : 0) }
    @board.sort.each{|a| @ary += sprintf("%05b", a[1]).split('').map{|i| i.to_i } }
  end

  def to_pg
    # board情報をPostgresqlのbytea型にinsertするときの表現の文字列にしてかえす
    to_ary
    ret = ary2byte.unpack("C*").inject("E'"){|m,e| m += '\\\\' + sprintf("%03o", e) } + "'"
    #print ret + "\n"
    #print_board_map
    @ary = []
    ret
  end

  def print_board
    print "--- board --- "
    @board.keys.sort.each{|e| print "#{e} #{@board[e]}, " }
    print " --- \n"
  end

  def print_board_map
    # for human being 
    flag = turn
    change_turn unless flag
    print_stand @white_stand
    print "------------------\n"
    1.upto(9) do |i|
      8.downto 0 do |j|
	p = @board[9*j + i]
	print "#{p ? (p > 15 ? (p+81).chr : (p+65).chr) : '.'} "
      end
      print "\n"
    end
    print "------------------\n"
    print_stand @black_stand
    change_turn unless flag
  end

  def print_stand(stand)
    stand.each_with_index{|e,i| print "#{(i+97).chr} : #{e}, " if e > 0 }
    print "\n"
  end
end

#
# ファイルから指定された棋譜のデータを読み込み、返す
#  入力: 棋譜のid
#  出力: [棋譜のバイト列(2*手数バイト), 手数]
#
def prepare_data(id_2ch)
  bin_file = '../2chkifu.bin'
  hdr_file = '../2chkifu.hdr'

  binHandle = open(bin_file)

  # idで指定された棋譜の最初の位置まで移動する
  binHandle.pos = get_kifu_info(hdr_file, id_2ch)[0]

  # まず、この棋譜の手数の情報が4バイトで記述されている
  tesu_of_this = binHandle.read(4).unpack("I*")[0].to_i

  # 1手が２バイトなので、ここで棋譜全体を変数に保存
  kifu_data = binHandle.read(2 * tesu_of_this)

  # binファイルはもう閉じてよい
  binHandle.close

  [kifu_data, tesu_of_this]
end

#
# id で指定された棋譜をDB kifread に登録するためのqueryに加工して返す
#
def kifu2ch_to_query(id)
  ret = ''
  kifu_data, tesu_of_this = prepare_data(id)
  bytes_to_query(kifu_data)
end


#
# DB kifread に登録するためのqueryに加工して返す
#   入力: 1局ぶんの棋譜のバイト列(2*手数バイト). 2ch流
#   出力: 1局ぶんのquery文字列
#     (insert into のvaluesに手数ぶんplus最後にひとつ追加されたもの。)　
#
def bytes_to_query(kifu_data)
  ret = "insert into kifread values "
  tesu_of_this = kifu_data.size / 2
  board = Board.new

  #  注意：同じレコードにおける指し手と盤面情報の関係
  #        その盤面にそのレコードの指し手を指すと次のレコードの盤面になるのである
  old_board = board.to_pg
  1.upto(tesu_of_this) do |i|

    from = kifu_data[(i-1)*2]
    to = kifu_data[(i-1)*2+1]
    #  2バイトの指し手を1バイトずつ分割してfrom, toに読み直している。2ch盤面座標である。
    board.move(from, to)

    ret += "(%3d,%s,%s)," % [i, sprintf("E'\\\\%03o\\\\%03o'", from, to), old_board]
    
    old_board = board.to_pg

  end

  # 最後に1行追加
  ret += "(%3d,%s,%s);" % [tesu_of_this + 1, 'NULL', board.to_pg]
  ret
end


#
# text型DBの kifread に登録するためのqueryに加工して返す
#   入力: 1局ぶんの棋譜のバイト列(2*手数バイト). 2ch流
#   出力: 1局ぶんのquery文字列
#     binaryタイプに比べてkifreadのカラムが多く、insert into ひとつだけで
#     すませると引数の文字列が長くなりすぎるので
#     insert into 文をが手数ぶんplus 1 個つくり、それをつなげた文字列を返す　
#
def bytes_to_query_text_type(kifu_data)
  ret = "insert into kifread values "
  tesu_of_this = kifu_data.size / 2
  board = Board.new

  #  注意：同じレコードにおける指し手と盤面情報の関係
  #        その盤面にそのレコードの指し手を指すと次のレコードの盤面になるのである
  old_board = board.to_pg
  1.upto(tesu_of_this) do |i|

    from = kifu_data[(i-1)*2]
    to = kifu_data[(i-1)*2+1]
    #  2バイトの指し手を1バイトずつ分割してfrom, toに読み直している。2ch盤面座標である。
    board.move(from, to)

    ret += "(%3d,%s,%s)," % [i, sprintf("E'\\\\%03o\\\\%03o'", from, to), old_board]
    
    old_board = board.to_pg

  end

  # 最後に1行追加
  ret += "(%3d,%s,%s);" % [tesu_of_this + 1, 'NULL', board.to_pg]
  ret
end

