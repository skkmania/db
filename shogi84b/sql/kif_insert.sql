--
--  kifreadからそれぞれのテーブルへデータをコピーする
--    shogib2 版
--    2009/5/31
--
create or replace function kif_insert(
    id_on_2ch integer,
    game_date date,
    black_name varchar(30),
    white_name varchar(30),
    result_char char)
  returns void as $$
  declare
    old_bid   integer default 1;
    new_bid   integer default 0;
    line      kifread%rowtype;
    old_line  kifread%rowtype;
    new_mid   smallint default 0;
    new_mid_str varchar;
    new_kid   integer;
    kif_data  varchar default '';
    kif_tesu  integer;
  begin
    select into old_line * from kifread where tesu = 1;
    for line in select * from kifread where tesu > 1 order by tesu loop
      select into new_bid bid from boards where board = line.board;
      if not found then
        -- new_bid が既存の局面ではない場合
        raise notice 'bid was not found in boards: tesu is %', line.tesu;
        -- 新しいbidを生成して
        if get_byte(line.board, 0) < 128 then  -- 先手番か
          new_bid := nextval('black_bid');
        else                                   -- 後手番か
          new_bid := nextval('white_bid');
        end if;
	raise notice 'so, new_bid is generated: %', new_bid;
          -- boards と new_boards に新しいboard情報を登録
        insert into boards values (new_bid, line.board);
        insert into new_boards values (new_bid, line.board);

	-- bidが新しいということはこの手は新手なのでmovesに登録
	  -- まず新しいmidを生成して
        select coalesce(max(mid)+1,0) into new_mid from moves where bid = old_bid;
        raise notice '1: insert into moves %, %, %, %', old_bid, new_mid, old_line.move, new_bid;
	  -- moves に登録
        insert into moves values(old_bid, new_mid, old_line.move, new_bid);
	  -- new_movesにも登録
        insert into new_moves values(old_bid, new_mid, old_line.move, new_bid);
      else
        -- new_bid が既存の局面の場合
        select into new_mid mid from moves where bid = old_bid and nxt_bid = new_bid;
	  -- 指し手がmovesにあるかどうか探す
	if not found then
	   -- 指し手がmovesに無い場合だけ
	  raise notice 'this move not found in moves: bid is %, nxt_bid is %, board is %',old_bid, new_bid, line.board;
	  select coalesce(max(mid)+1,0) into new_mid from moves where bid = old_bid;
          raise notice '2: insert into moves %, %, %, %', old_bid, new_mid, old_line.move, new_bid;
	   -- 指し手をmovesに登録
          insert into moves values(old_bid, new_mid, old_line.move, new_bid);
	   -- 指し手をnew_movesにも登録
          insert into new_moves values(old_bid, new_mid, old_line.move, new_bid);
	end if;
      end if;
      -- ループの最後には局面だけが存在し、指し手が存在しないので脱出する
      if line.move is null then exit; end if;
      -- 次の処理のためにline情報を入れ替える
      old_line := line; old_bid  := new_bid;
      -- 棋譜データを更新
        -- 前処理としてmidが１桁ならそのまま文字に。2桁ならd12のようにdをつける
      if new_mid < 10 then
        new_mid_str = trim(to_char(new_mid, '9'));
      else
        new_mid_str = 'd' || trim(to_char(new_mid, '99'));
      end if;
      -- kif_dataの末尾に追加していく
      kif_data := kif_data || new_mid_str;
      raise notice 'new_mid is % kif_data is % ', new_mid, kif_data;
    end loop;
    raise notice 'kif_data is % ', kif_data;
    -- kif_data から末尾の0の連続を削除する
    kif_data := rtrim_zeros(kif_data);
    -- kifreadからこの棋譜の手数を読み取る。最後に空白行があるので１を引く。
    select max(tesu)-1 into kif_tesu from kifread;
    insert into kifs (id2ch, tesu, gdate, black, white, result, kif) values(id_on_2ch, kif_tesu, game_date, black_name, white_name, result_char, kif_data);
  end;$$
language 'plpgsql';

