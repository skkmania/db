require 'test/unit'
require 'kif2tbl.rb'

class TestKif2Query < Test::Unit::TestCase
  def setup
    @sample_kifu_file = File.dirname(__FILE__) + '/../sample/s01.kif' 
    @kifu_text = File.read(@sample_kifu_file)
  end

  def teardown
  end

  def test_zen2i
    assert_equal(76, zen2i('７六'))
    assert_equal(34, zen2i('３四'))
  end

  def test_kif_text_to_sasite_array
    result = kif_text_to_sasite_array(@kifu_text)
    assert_equal(2, result.size)
  end

end
