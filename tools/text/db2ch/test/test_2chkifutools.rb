require 'test/unit'
require '2chkifutools.rb'

class TestHenkan < Test::Unit::TestCase
  def setup
    @hdr_file = '2chkifu.hdr'

    # test data for board_2ch_to_db
    @db_init_board = "lnsgkgsnlxbxxxxxrxpppppppppxxxxxxxxxxxxxxxxxxxxxxxxxxxPPPPPPPPPxRxxxxxBxLNSGKGSNL"
    @init_board_2ch = " lxpxxxPxLnbpxxxPRNsxpxxxPxSgxpxxxPxGkxpxxxPxKgxpxxxPxGsxpxxxPxSnrpxxxPBNlxpxxxPxL".split(//)
    @init_black = { "P" => 0, "L" => 0, "N" => 0, "S" => 0, "G" => 0, "B" => 0, "R" => 0 }
    @init_white = { "p" => 0, "l" => 0, "n" => 0, "s" => 0, "g" => 0, "b" => 0, "r" => 0 }
    @init_b_info = [@init_board_2ch, @init_black, @init_white]

    @db_second_board = 'lnsgkgsnlxbxxxxxrxpppppppppxxxxxxxxxxxxxxxxxxxPxxxxxxxPxPPPPPPPxRxxxxxBxLNSGKGSNL'
    @second_board_2ch = " lxpxxxPxLnbpxxPxRNsxpxxxPxSgxpxxxPxGkxpxxxPxKgxpxxxPxGsxpxxxPxSnrpxxxPBNlxpxxxPxL".split(//)
  end

  def teardown
  end
  
  def test_henkan
    assert_equal(11, henkan(1))
    assert_equal(91, henkan(73))
    assert_equal(19, henkan(9))
    assert_equal(99, henkan(81))
    assert_equal(0, henkan(82))
    assert_equal(0, henkan(88))
    assert_equal(11, henkan(129))
    assert_equal(55, henkan(169))
  end

  def test_get_kifu_info
    assert_equal([8,'羽生善治','谷川浩司',126,'w','2003-09-08'], get_kifu_info(@hdr_file,1))
    assert_equal([264,'島　　朗','三浦弘行',110,'w','2003-09-05'], get_kifu_info(@hdr_file,2))
    assert_equal([488,'畠山成幸','郷田真隆',138,'w','2003-08-25'], get_kifu_info(@hdr_file,3))
  end

  def test_board_2ch_to_db
    assert_equal(@db_init_board, board_2ch_to_db(@init_board_2ch))
    assert_equal(@db_second_board, board_2ch_to_db(@second_board_2ch))
  end

  def test_move
    # 駒が進むテスト
    original_b_info = @init_b_info.map{|e| e.clone }
    result = move(16,15,true,@init_b_info) # 2六歩
    assert_equal(['P',false], result)
    assert_equal('x', @init_board_2ch[16]) 
    assert_equal('P', @init_board_2ch[15]) 
    assert(check_other_cells(16,15, original_b_info, @init_b_info))
    assert(check_stands(true,nil, original_b_info, @init_b_info))

    original_b_info = @init_b_info.map{|e| e.clone }
    result = move(21,22,false,@init_b_info) # 3四歩
    assert_equal(['p',false], result)
    assert_equal('x', @init_board_2ch[21]) 
    assert_equal('p', @init_board_2ch[22]) 
    assert(check_other_cells(21,22, original_b_info, @init_b_info))
    assert(check_stands(true,nil, original_b_info, @init_b_info))

    assert_equal(['P',false], move( 7, 6,true,@init_b_info)) # 1六歩
    assert_equal(['P',false], move(25,24,true,@init_b_info)) # 3六歩

    # 駒をとるテスト
    original_b_info = @init_b_info.map{|e| e.clone }
    result = move(71,11+128,true,@init_b_info) # ２二角成
    assert_equal('x', @init_board_2ch[71]) 
    assert_equal('H', @init_board_2ch[11]) 
    assert_equal(1, @init_b_info[1]['B']) 
    assert(check_other_cells(71,11, original_b_info, @init_b_info))
    assert(check_stands(true,'B', original_b_info, @init_b_info))
    
    original_b_info = @init_b_info.map{|e| e.clone }
    result = move(19,11,false,@init_b_info) # ２二同銀
    assert_equal('x', @init_board_2ch[19]) 
    assert_equal('s', @init_board_2ch[11]) 
    assert_equal(1, @init_b_info[2]['b']) 
    assert(check_other_cells(19,11, original_b_info, @init_b_info))
    assert(check_stands(false,'b', original_b_info, @init_b_info))

    # 駒を打つテスト
    original_b_info = @init_b_info.map{|e| e.clone }
    result = move(87,5,true,@init_b_info) # 1五角打つ
    assert_equal('B', @init_board_2ch[5]) 
    assert_equal(0, @init_b_info[1]['B']) 
    assert(check_other_cells(87,5, original_b_info, @init_b_info))
    assert(check_stands(true,'B', original_b_info, @init_b_info))

    
  end

  def test_stand_to_str
    tdata = {}
    assert_equal('', stand_to_str(tdata))
    tdata = { "P" => 0 }
    assert_equal('', stand_to_str(tdata))
    tdata = { "P" => 1 }
    assert_equal('P', stand_to_str(tdata))
    tdata = { "P" => 1,"L" => 2, "S" => 1 }
    assert_equal('SLLP', stand_to_str(tdata))
    tdata = { "p" => 1,"l" => 2, "s" => 1 }
    assert_equal('sllp', stand_to_str(tdata))
    tdata = { "G" => 2, "P" => 1,"L" => 2, "S" => 1 }
    assert_equal('GGSLLP', stand_to_str(tdata))
    tdata = { "g" => 2, "p" => 1,"l" => 2, "s" => 1 }
    assert_equal('ggsllp', stand_to_str(tdata))
  end

  def check_other_cells(from, to, orig, alter)
    # board上のfrom, to以外のすべての升目に同じ駒があることをチェックする
    min, max = [from, to].min, [from, to].max
    if (min > 0 and max < 82)
      return (
        orig[0].values_at(0...min, min+1...max, max+1..81) == alter[0].values_at(0...min, min+1...max, max+1..81)
      )
    end
    # 持ち駒を打ったときは、打たれた升目以外をチェック
    if (max > 81)
      return (
        orig[0].values_at(0...min, min+1..81) == alter[0].values_at(0...min, min+1..81)
      )
    end
  end   

  def check_stands(turn, except_piece, orig, alter)
    # except_pieceがnilのときは、２つのstandが等しいかどうかチェックする
    return ((orig[1] == alter[1]) and (orig[2] == alter[2])) unless except_piece
    # standがexcept_piece以外は変わっていないことをチェックする
    ret = true
    if turn
      return false unless (orig[2] == alter[2])
      orig[1].each{|k,v| ret = false if (alter[1][k] != v and k != except_piece) }
    else
      return false unless (orig[1] == alter[1])
      orig[2].each{|k,v| ret = false if (alter[2][k] != v and k != except_piece) }
    end
    ret
  end
end
  
