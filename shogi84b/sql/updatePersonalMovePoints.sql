--
--  updatePersonalMovePoints
--   move_point_user テーブルの値を更新する
--   入力値: bid, mid, diff, userid
--   返り値：0 = 正常終了,  その他の値 = エラーコード
--
create or replace function updatePersonalMovePoints(a_bid integer, a_mid smallint, a_diff smallint, a_userid integer)
  returns integer as $$
  declare
    dummy  smallint;
    d_rec  move_points;
  begin
    select mid into dummy from move_point_user where bid = a_bid and mid = a_mid and userid = a_userid;
    if dummy is null then
      -- 既存のポイントが無い場合（0点とみなしていた。大部分がこのパターン)
      insert into move_point_user values(a_bid, a_mid::smallint, a_userid, a_diff::smallint);
    else
      -- 既存のポイントがある場合
      update move_point_user set point = point + a_diff where bid = a_bid and mid = a_mid and userid = a_userid;
    end if;
    -- move_points の対応するデータを再計算する
    select * into d_rec from move_points where bid = a_bid and mid = a_mid;
    if d_rec is null then
      insert into move_points values(a_bid, a_mid, (select avg(point) from move_point_user where bid = a_bid and mid = a_mid));
    else
      update move_points set point = (select avg(point) from move_point_user where bid = a_bid and mid = a_mid) where bid = a_bid and mid = a_mid;
    end if;
    return 0;
  end;$$
language 'plpgsql';
