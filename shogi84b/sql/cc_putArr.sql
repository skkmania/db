--
-- cc_putArr.sql 
--    入力値:bid, level
--    返り値: 正常時 0 ,  異常時 -1
--      テーブルarrにbid, level, nxt_bidの配列、その要素数、pre_bidの配列、その要素数を
--      登録する。
--
create or replace function cc_putArr(integer, integer)
  returns integer as $$
    declare
      arg_bid     alias for $1;
      arg_level   alias for $2;
    begin
      -- raise notice 'cc_putArr : arg_bid is %  arg_level is %', arg_bid, arg_level;
      insert into arr values(arg_bid, arg_level,              
	 (select array(select nxt_bid from moves where bid = arg_bid)), 
	 (select count(*) from moves where bid = arg_bid),
	 (select array(select bid from moves where nxt_bid = arg_bid)),
	 (select count(*) from moves where nxt_bid = arg_bid)
      ); 
      if found then
	return 0;
      else
	raise notice 'cc_putArr : error in putArr';
        return -1;
      end if;
    end;$$
language 'plpgsql';
