--
--  updateMovePoints
--   move_point_user テーブルをの値を更新する
--   入力値: bid, mid, point, userid
--   返り値：0 = 正常終了,  その他の値 = エラーコード
--
create or replace function updateMovePoints(a_bid integer, a_mid smallint, a_point smallint, a_userid integer)
  returns integer as $$
  declare
    dummy  samallint;
  begin
    select mid into dummy from move_point_user where bid = a_bid and mid = a_mid and userid = a_userid;
    if dummy is null then
      -- 既存のポイントが無い場合（0点とみなしていた。大部分がこのパターン)
      insert into move_point_user values(a_bid, a_mid, a_userid, a_point);
    else
      -- 既存のポイントがある場合
      update move_point_user set point = a_point where bid = a_bid and mid = a_mid and userid = a_userid;
    end if;
    -- move_points の対応するデータを再計算する
    update move_points set point = (select avg(point) from move_point_user where bid = a_bid and mid = a_mid) where bid = a_bid and mid = a_mid;
    return 0;
  end;$$
language 'plpgsql';
