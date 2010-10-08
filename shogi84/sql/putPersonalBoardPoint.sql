--
-- putPersonalBoardPoint
--    個人の盤面への採点をテーブルに登録する
--    入力値: bid, userid, point
--    返り値：0 = 正常終了,  その他の値 = エラーコード
--
create or replace function putPersonalBoardPoint(a_bid integer,
  						 a_userid integer,
						 a_point smallint)
  returns integer as $$
  begin
    begin
      insert into boardp_users values(a_bid, a_userid, a_point);
    exception when unique_violation then
      update boardp_users set pbpoint = a_point where bid = a_bid and userid = a_userid;
    end;
    begin
      insert into board_points values(a_bid, (select avg(pbpoint) from boardp_users where bid = a_bid));
    exception when unique_violation then
      update board_points set bpoint = (select avg(pbpoint) from boardp_users where bid = a_bid) where bid = a_bid;
    end;
    return 0;
  end;
  $$ language plpgsql;
