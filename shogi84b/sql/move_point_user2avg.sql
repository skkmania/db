--
--  move_point_user2avg
--   move_point_user テーブルを読み、それぞれの指し手のポイントの平均値を求め
--   move_points テーブルとする
--
create or replace function move_point_user2avg()
  returns void as $$
  begin
    -- 既存のテーブルを削除
    drop table move_points;
    -- move_point_userから集計した結果を新しくテーブルとする
    create table move_points as select bid,mid,avg(point) as point from move_point_user group by bid,mid order by bid;
    -- ポイントの検索の高速化のためにインデックスをつくっておく
    create index mv_po_idx on move_points(bid);
  end;$$
language 'plpgsql';
