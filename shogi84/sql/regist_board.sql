--
--  regist_board
--    与えられた盤面情報を検索し、そのbidを返す。
--    同時に指し手をmovesに登録する。
--    その盤面がなければ、bidを生成し、盤面をboardsに、指し手をmovesに登録する。
--    返り値: record変数 この変数にはboardが既存のものならbidのみを格納し、boardが新規のものならbidとmidを格納する
--
create or replace function regist_board(boolean, char(81), varchar(40), varchar(40), integer, smallint, smallint, char, boolean)
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
       ret_rec   moves%rowtype;
       tmp_str   varchar;
     begin
       raise notice 'regist_board 0 : arg_turn is %  arg_board is %  arg_oldbid is %', arg_turn, arg_board, arg_oldbid;
       -- 作業用のテーブルをクリア
       delete from forBoardRegist;

       -- まず新手のmidを決定
       select coalesce(max(mid)+1,0) into new_mid from moves where bid = arg_oldbid;
         raise notice 'regist_board 1 : new_mid is % ', new_mid;

       -- 与えられた情報のboardを検索し
       select into new_bid bid from boards
         where turn = arg_turn and
	       black = arg_black and
	       board = arg_board and
	       white = arg_white;
       raise notice 'regist_board 3 : new_bid is %  arg_board is % ', new_bid, arg_board;
       if new_bid is null then
         -- boardが新規のものの場合(見つからなかった場合）
         if arg_turn then
           new_bid := nextval('black_bid');
	 else
	   new_bid := nextval('white_bid');
	 end if;
         raise notice 'regist_board 4 : new_bid is % ', new_bid;
	 insert into boards values(new_bid, arg_turn, arg_black, arg_board, arg_white);
         -- select new_bid, new_mid into ret_rec;
         insert into forBoardRegist values(new_bid, new_mid);
       else
         -- boardが既存のものの場合 返り値にはbidしか含めない
         -- select new_bid into ret_rec;
         insert into forBoardRegist values(new_bid, null);
       end if;
       -- ここまでくればnew_bidが決まっているので、新手を登録できる
       raise notice 'regist_board 5 : insert into moves values(%, %, %, %, %, %, %)', arg_oldbid, new_mid, arg_from, arg_to, arg_piece, arg_promote, new_bid;
       insert into moves values(arg_oldbid, new_mid, arg_from, arg_to, arg_piece, arg_promote, new_bid); 
       -- ret_str := to_char(new_bid,'999999999') || ',' || to_char(new_mid,'99');
       -- raise notice 'ret_str : %', ret_str;
       select to_char(new_bid,'999999999') || ',' || to_char(new_mid,'99') into tmp_str from forBoardRegist;
       raise notice 'regist_board 5 : return value in string : %', tmp_str;
       select into ret_rec new_bid, new_mid from forBoardRegist;
       return ret_rec;
     end;$$
language 'plpgsql';
