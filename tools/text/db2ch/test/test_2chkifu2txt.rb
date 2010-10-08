require 'test/unit'
require '../2chkifu2txt.rb'

class TestHenkan < Test::Unit::TestCase
  def setup
    @hdr_file = '/home/norika/public_html/shogi/2chkifu.hdr'

    # test data for board_2ch_to_db
    @db_init_board = 'bcdehedcb,f,,,,,g,aaaaaaaaa,,,,,,,,,,,,,,,,,,,,,,,,,,,AAAAAAAAA,G,,,,,F,BCDEHEDCB'
    @init_board_2ch = ' b,a,,,A,Bcfa,,,AGCd,a,,,A,De,a,,,A,Eh,a,,,A,He,a,,,A,Ed,a,,,A,Dcga,,,AFCb,a,,,A,B'.split(//)
    @init_black = { "A" => 0, "B" => 0, "C" => 0, "D" => 0, "E" => 0, "F" => 0, "G" => 0 }
    @init_white = { "a" => 0, "b" => 0, "c" => 0, "d" => 0, "e" => 0, "f" => 0, "g" => 0 }
    @init_b_info = [@init_board_2ch, @init_black, @init_white]

    @db_second_board = 'bcdehedcb,f,,,,,g,aaaaaaaaa,,,,,,,,,,,,,,,,,,,A,,,,,,,A,AAAAAAA,G,,,,,F,BCDEHEDCB'
    @second_board_2ch = ' b,a,,,A,Bcfa,,A,GCd,a,,,A,De,a,,,A,Eh,a,,,A,He,a,,,A,Ed,a,,,A,Dcga,,,AFCb,a,,,A,B'.split(//)
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

  def test_get_bin_pos
    assert_equal(8, get_bin_pos(@hdr_file,1))
    assert_equal(264, get_bin_pos(@hdr_file,2))
    assert_equal(488, get_bin_pos(@hdr_file,3))
  end

  def test_board_2ch_to_db
    assert_equal(@db_init_board, board_2ch_to_db(@init_board_2ch))
    assert_equal(@db_second_board, board_2ch_to_db(@second_board_2ch))
  end

  def test_move
    assert_equal(['A',false], move(16,15,true,@init_b_info))
  end
end
  
