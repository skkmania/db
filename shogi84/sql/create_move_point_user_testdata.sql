--
--  move_point_user テーブルにテストデータを挿入
--
create or replace function create_move_point_user_testdata()
  returns void as $$
  declare
    kifdata  record;
    i        integer;
    userid   integer;
    pnt      smallint;
  begin
    -- kifu_data テーブルから tesuが３０以下のbid,midの組み合わせを選択し
    for kifdata in  select distinct bid,mid from kifu_data where tesu < 31 order by bid loop

      for i in 1..30 loop
	-- それぞれについてユーザを30人ずつランダムに選び
	userid := ceil(19999 * random());
	-- ユーザごとに、-10から10までのランダムに選んだポイントをその手に付与する
	pnt := ceil(20 * random()) - 10;
	insert into move_point_user values(kifdata.bid, kifdata.mid, userid, pnt);
      end loop;
    end loop;
  end;$$
language 'plpgsql';
