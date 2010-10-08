require 'test/unit'
require 'db_connect.rb'

class TestHenkan < Test::Unit::TestCase
  def setup
    @db = connect_db
  end

  def teardown
    @db.disconnect
  end
  
  def test_connect_db
#    DB = Sequel.connect("postgres://skkmania@localhost:5432/shogi84",
#      :max_connections => 10, :logger => Logger.new('log/db_shogi84.log'))
    dataset = @db['select bid from boards']
    assert_equal(0, dataset.count)
  end

  def test_run
#    DB = Sequel.connect("postgres://skkmania@localhost:5432/shogi84",
#      :max_connections => 10, :logger => Logger.new('log/db_shogi84.log'))
    result = @db.run('delete from kifread')
    assert_equal(nil, result)
  end
end
  
