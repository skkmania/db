--
-- cc_getBids.sql 
--    入力値:bid, level
--    返り値:登録したbid とmidの配列
--      level の深さまで、bid, nxt_bids, pre_bidsの組を検索してテーブルarrに登録し
--      それをかえす
--
create or replace function cc_getBids(integer, integer)
  returns setof arr as $$
    declare
      arg_bid     alias for $1;
      arg_level   alias for $2;
      dummy	integer;
      i         smallint;
      j         smallint;
      nxt_num   smallint;
      pre_num   smallint;
      nxt       integer[];
      pre       integer[];
      rec       arr%rowtype;
    begin
      -- raise notice 'cc_getBids : arg_bid is %  arg_level is %', arg_bid, arg_level;
        -- まずarrを空にする
      delete from arr;
        -- 渡されたbidについて、arrにデータを登録
      perform cc_putArr(arg_bid, 0);
        -- それをもとにlevelぶん展開する
      for i in 1..arg_level loop
        -- levelの指定ぶん、
        for rec in select * from arr where ll = i-1 loop
	  -- nxt_bidsの配列を順にとりだして
	  for j in 1..rec.nn loop
	    -- 要素rec.nxts[j]がすでにarrにあるかどうかを検査し
	    select bid into dummy from arr where bid = rec.nxts[j];
	    if not found then
	    -- 存在しないならば、その要素について、arrにデータを登録
	      perform cc_putArr(rec.nxts[j], i);
	    end if;
	  end loop;
	  -- 次にpre_bidsの配列を順にとりだして
	  for j in 1..rec.pn loop
	    -- その要素について、arrにデータを登録
	    select bid into dummy from arr where bid = rec.pres[j];
	    if not found then
	      perform cc_putArr(rec.pres[j], i);
	    end if;
	  end loop;
	end loop;
      end loop;
      -- raise notice 'cc_getBids : last ';
      return query (select * from arr);
     end;$$
language 'plpgsql';
