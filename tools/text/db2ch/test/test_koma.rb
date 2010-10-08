require 'test/unit'
require '../koma.rb'

class TC_Koma < Test::Unit::TestCase
  def setup
      @obj = Koma.new(0,0,0)
      @bFu = Koma.new(0,0,0)
  end

  def teardown
  end
  
  def test_chr2koma
    assert_equal(@bFu, @obj.chr2koma('a'))
  end

end
  
