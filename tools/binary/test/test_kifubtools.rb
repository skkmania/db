require 'test/unit'
require '../kifubtools.rb'

class TestBoard < Test::Unit::TestCase
  def setup
    @hdr_file = '/home/norika/public_html/shogi/2chkifu.hdr'

    @init_b_info = [@init_board_2ch, @init_black, @init_white]

    @b = Board.new
    @initial_bytea_string = "E'\\\\055\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\075\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
    @b00 = "E'\\\\255\\\\245\\\\007\\\\017\\\\031\\\\042\\\\053\\\\064\\\\075\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"  #  初手▲２六歩と指した局面。後手番。
    @b01 = "E'\\\\055\\\\245\\\\007\\\\017\\\\031\\\\042\\\\053\\\\064\\\\075\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\224\\\\256\\\\107\\\\213\\\\021\\\\301'"  #  2手目△３二金と指した局面。先手番。
    @b02 = "E'\\\\255\\\\245\\\\007\\\\015\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\076\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
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

  def test_to_pg
    assert_equal(@initial_bytea_string, @b.to_pg)
  end

  def test_read
    b = Board.new
    b.move(16, 15)
    b.move(28, 20)
    b.read(
      [45,165,   # 先手玉、後手玉  @p[0], @p[1]
	7,16,25,34,43,52,61,70,79,131,140,149,158,167,176,185,194,203,  # 歩 @p[2] .. @p[19]
	9,81,129,201,  #  香    @p[20] .. @p[23]
       18,72,138,192,  #  桂馬  @p[24] .. @p[27]
       27,63,147,183,  #  銀    @p[28] .. @p[31]
       36,54,156,174,  #  金    @p[32] .. @p[35]
       71,139,         #  角    @p[36], @p[37]
       17,193])         #  飛車  @p[38], @p[39]
    assert_equal(@initial_bytea_string, b.to_pg)
  end

  def test_read_bytea
    b = Board.new
    b.read_bytea(@b00)
    assert_equal(@b00, b.to_pg)
  end

  def test_move
    # 初期盤面から先手駒をうごかす
    @b.move(16, 15)
    assert_equal(@b00, @b.to_pg)
    # 後手駒を動かす
    @b.move(28,20)
    assert_equal(@b01, @b.to_pg)

    b1 = Board.new
    b1.move(61,60)
    res_b1 = "E'\\\\255\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
    assert_equal(res_b1, b1.to_pg)

    b1.move(66,67)
    res_b2 = "E'\\\\055\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
    assert_equal(res_b2, b1.to_pg)

    # 駒をとる
    b1.move(71,21)
    res_b3 = "E'\\\\255\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\025\\\\213\\\\021\\\\301'"
    assert_equal(res_b3, b1.to_pg)

    b1.move(11,21)
    res_b4 = "E'\\\\055\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\200\\\\225\\\\021\\\\301'"
    assert_equal(res_b4, b1.to_pg)

    b1.move(16,15)
    res_b5 = "E'\\\\255\\\\245\\\\007\\\\017\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\200\\\\225\\\\021\\\\301'"
    assert_equal(res_b5, b1.to_pg)

    # 持ち駒を打つ
    b1.move(87,41)
    res_b6 = "E'\\\\055\\\\245\\\\007\\\\017\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\251\\\\225\\\\021\\\\301'"
    assert_equal(res_b6, b1.to_pg)

    c1 = Board.new
    c1.move(61,60)
    c1.move(66,67)
    # 駒を成る
    c1.move(71,149)  #  ▲３三角成
    res_c = "E'\\\\255\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\132\\\\213\\\\021\\\\301\\\\025'"
    assert_equal(res_c, c1.to_pg)
    # 成り駒をとる
    c1.move(10, 21)  #  △３三桂馬
    res_c = "E'\\\\055\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\074\\\\106\\\\117\\\\203\\\\214\\\\000\\\\236\\\\247\\\\260\\\\271\\\\303\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\225\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\200\\\\213\\\\021\\\\301'"
    assert_equal(res_c, c1.to_pg)

    # read_bytea との組み合わせ
    d = Board.new
    d.read_bytea("E'\\055\\245\\007\\200\\031\\042\\053\\064\\074\\200\\117\\203\\000\\000\\236\\247\\260\\271\\000\\313\\011\\121\\201\\311\\022\\110\\212\\300\\033\\077\\223\\267\\044\\076\\224\\256\\107\\225\\026\\305'")
    d.move(22, 24)
    res_d = "E'\\\\255\\\\245\\\\007\\\\200\\\\031\\\\042\\\\053\\\\064\\\\074\\\\200\\\\117\\\\203\\\\000\\\\000\\\\236\\\\247\\\\260\\\\271\\\\000\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\076\\\\224\\\\256\\\\107\\\\225\\\\030\\\\305'"
    assert_equal(res_d, d.to_pg)

    # 先手玉が動く
    e = Board.new
    e.move(45, 44)
    res_e = "E'\\\\254\\\\245\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\075\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
    assert_equal(res_e, e.to_pg)
    # 後手玉が動く
    e.move(37,29)
    res_e = "E'\\\\054\\\\235\\\\007\\\\020\\\\031\\\\042\\\\053\\\\064\\\\075\\\\106\\\\117\\\\203\\\\214\\\\225\\\\236\\\\247\\\\260\\\\271\\\\302\\\\313\\\\011\\\\121\\\\201\\\\311\\\\022\\\\110\\\\212\\\\300\\\\033\\\\077\\\\223\\\\267\\\\044\\\\066\\\\234\\\\256\\\\107\\\\213\\\\021\\\\301'"
    assert_equal(res_e, e.to_pg)
  end

end
  