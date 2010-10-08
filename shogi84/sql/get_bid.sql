-- lenny-pg の shogi2 データベースに作成した関数の覚書
--
--  get_bid のメイン関数
--    与えられた盤面情報を検索し、そのbidを返す。
--    同時に指し手をmovesに登録する。
--    その盤面がなければ、bidを生成し、盤面をboardsに、指し手をmovesに登録する。
--    返り値:登録したbid とmidの配列
--
create or replace function get_bid(boolean, char(81), varchar(40), varchar(40), integer, smallint, smallint, char, boolean)
  returns text as $$
     declare
       arg_turn    alias for $1;
       arg_board   alias for $2;
       arg_black   alias for $3;
       arg_white   alias for $4;
       arg_oldbid  alias for $5;
       arg_from    alias for $6;
       arg_to      alias for $7;
       arg_piece   alias for $8;
       arg_promote alias for $9;
       new_bid   integer;
       new_mid   integer;
       tmp_turn  boolean;
       ret_str   text;
     begin
       raise notice 'get_bid : arg_turn is %  arg_board is %  arg_oldbid is %', arg_turn, arg_board, arg_oldbid;
       select into new_bid bid from boards
         where turn = arg_turn and
	       black = arg_black and
	       board = arg_board and
	       white = arg_white;
       raise notice 'get_bid : new_bid is %  arg_board is % ', new_bid, arg_board;
       if new_bid is null then
         if arg_turn then
           new_bid := nextval('black_bid');
	 else
	   new_bid := nextval('white_bid');
	 end if;
         raise notice 'get_bid 2 : new_bid is % ', new_bid;
	 insert into boards values(new_bid, arg_turn, arg_black, arg_board, arg_white);
       end if;
       select coalesce(max(mid)+1,0) into new_mid from moves where bid = arg_oldbid;
         raise notice 'get_bid 3 : new_mid is % ', new_mid;
       insert into moves values(arg_oldbid, new_mid, arg_from, arg_to, arg_piece, arg_promote, new_bid); 
       ret_str := to_char(new_bid,'999999999') || ',' || to_char(new_mid,'99');
       raise notice 'ret_str : %', ret_str;
       return ret_str;
     end;$$
language 'plpgsql';
