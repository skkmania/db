--
--  index を作成したときのメモ
--    網羅していない
--

-- move_point_user
create index "move_point_user_bid_uid_key" on move_point_user (bid,userid);
  -- getMovePointだけ妙に時間をくうので調べてみたらindexをつくっていなかった #104
