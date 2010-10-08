--
-- 盤面を検索する
--   与えられた盤面を検索し、存在するならばそのbidを返す。存在しなければ0を返す。
--
create or replace function search_board(boolean, varchar(38), char(81), varchar(38))
  returns integer as $$
     declare
       arg_turn  alias for $1;
       arg_black alias for $2;
       arg_board alias for $3;
       arg_white alias for $4;
       new_bid   integer default 0;
     begin
	select bid into new_bid from boards where turn = arg_turn
	   and board = arg_board and black = arg_black and white = arg_white;
        raise notice 'search_board returning new_bid : % ', new_bid;
	if not found then
	  return 0;
	else
	  return new_bid;
	end if;
        return new_bid;
     end;$$
language 'plpgsql';
