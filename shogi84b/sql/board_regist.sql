--
-- 盤面情報を登録する
--    持ち駒が空のときは持ち駒フィールドに空文字列を挿入する
--    bidはsequenceから取得し、与えられた盤面情報をboards,movesに登録する
--

create or replace function board_regist(boolean, varchar(38), char(81), varchar(38))
  returns integer as $$
    declare
       turn  alias for $1;
       black alias for $2;
       board alias for $3;
       white alias for $4;
       new_bid integer;

    begin

    raise notice 'board_regist : % ', board;

    raise notice 'board_regist : new_bid is % ', new_bid;
    raise notice 'board_regist : turn is % ', turn;
    raise notice 'board_regist : black is % ', black;
    raise notice 'board_regist : white is % ', white;
    if turn then
      new_bid := nextval('black_bid');
    else
      new_bid := nextval('white_bid');
    end if;
    insert into boards values (new_bid, turn, black, board, white);
    return new_bid;

   end;$$
language 'plpgsql';
