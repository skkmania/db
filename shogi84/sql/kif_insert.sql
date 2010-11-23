--
--  kifreadからそれぞれのテーブルへデータをコピーする
--
-- 入力 5つ（下記参照）登録する棋譜のメタデータ
-- 出力 record kifsへ登録したこの棋譜のrecord
create or replace function kif_insert(
    id_on_2ch integer,
    game_date date,
    black_name varchar(30),
    white_name varchar(30),
    result_char char)
  returns kifs as $$
  declare
    old_bid   integer default 1;
    new_bid   integer default 0;
    line      kifread%rowtype;
    old_line  kifread%rowtype;
    new_mid   smallint default 0;
    new_mid_str varchar;
    new_kid   integer;
    kif_data  varchar default '';
    new_move_str varchar default '';
    kif_tesu  integer;
    result    kifs%rowtype;
  begin
    raise notice 'new game start : id is %, ',id_on_2ch;
    -- kifreadから１行読み、old_lineとする
    select into old_line * from kifread where tesu = 1;
    raise notice 'line 1 : %, ', old_line;
    -- 初期盤面なのでold_bidは1となる。
    old_bid := 1;
    for line in select * from kifread where tesu > 1 order by tesu loop
      -- lineに次行を読み、以降、lineとold_lineを入れ替えながらループする
      -- old_lineの指し手を実行するとlineの局面になることに注意
      raise notice '----------------into next loop-----------------';
      raise notice 'line: %', line;
      -- lineのboardが既存かどうか探す
      select into new_bid bid from boards where
        turn = line.turn and black = line.black_hand and
	board = line.board and white = line.white_hand;
      if not found then
        -- lineのboardが既存の局面ではない場合
        raise notice 'this board is not found in boards';
        -- 新しいbidを生成して
        if line.turn then
          new_bid := nextval('black_bid');
        else
          new_bid := nextval('white_bid');
        end if;
	raise notice 'so, new_bid is generated: %', new_bid;
          -- boards と new_boards に新しいboard情報を登録
        insert into boards values (new_bid, line.turn, line.black_hand, line.board, line.white_hand);
        insert into new_boards values (new_bid, line.turn, line.black_hand, line.board, line.white_hand);

	-- bidが新しいということはこの手は新手なのでmovesに登録
	  -- まず新しいmidを生成して
        select coalesce(max(mid)+1,0) into new_mid from moves where bid = old_bid;
        -- new_mid := generate_new_mid(old_bid);
        -- execute generate_new_mid(old_bid) into new_mid;

	raise notice 'and, new mid is generated: %', new_mid;
        raise notice '1: insert into moves %, %, %, %, %, %, %', old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid;
	  -- moves に登録
        insert into moves values(old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid);
	  -- new_movesにも登録
        insert into new_moves values(old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid);
          -- この手が新手なので、new_move_strに'0'を追加
        new_move_str := new_move_str || '0';
      else
        -- lineのboard が既存の局面の場合
          -- new_bidにはlineのboardのbidがはいっているはず
        raise notice 'this board is found in boards %', new_bid;
	  -- old_lineの指し手がmovesにあるかどうか探す
        select into new_mid mid from moves where bid = old_bid and nxt_bid = new_bid;
	if not found then
	   -- 指し手がmovesに無い場合だけ
	  raise notice 'but, this move is not found in moves: old_bid is %, new_bid is %, board is %',old_bid, new_bid, line.board;
	  select coalesce(max(mid)+1,0) into new_mid from moves where bid = old_bid;
          -- new_mid := generate_new_mid(old_bid);
          raise notice '2: insert into moves %, %, %, %, %, %, %', old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid;
	   -- 指し手をmovesに登録
          insert into moves values(old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid);
	   -- 指し手をnew_movesにも登録
          insert into new_moves values(old_bid, new_mid, old_line.m_from, old_line.m_to, old_line.piece, old_line.promote, new_bid);
           -- この手が新手なので、new_move_strに'0'を追加
          new_move_str := new_move_str || '0';
        else
	  raise notice 'and, this move is also found in moves: bid %, mid %, ',old_bid, new_mid;
           -- この手が新手ではないので、new_move_strに'1'を追加
          new_move_str := new_move_str || '1';
	end if;
      end if;
      -- ループの最後には局面だけが存在し、指し手が存在しないので脱出する
      if line.m_from is null and line.m_to is null then exit; end if;
      -- 次の処理のためにline情報を入れ替える
      old_line := line; old_bid  := new_bid;
      raise notice 'old_line became % ', old_line;
      raise notice 'old_bid became % ', old_bid;
      -- 棋譜データを更新
        -- 前処理としてmidが１桁ならそのまま文字に。2桁ならd12のようにdをつける
      if new_mid < 10 then
        new_mid_str = trim(to_char(new_mid, '9'));
      else
        new_mid_str = 'd' || trim(to_char(new_mid, '99'));
      end if;
      -- kif_dataの末尾に追加していく
      kif_data := kif_data || new_mid_str;
      raise notice 'new_mid is % , kif_data is % , new_move_str is % ', new_mid, kif_data, new_move_str;
    end loop;
    raise notice 'loop ended. kif_data became % ', kif_data;
    raise notice 'loop ended. new_move_str became % ', new_move_str;
    -- kif_data, new_move_str から末尾の0の連続を削除する
    kif_data := rtrim_zeros(kif_data);
    new_move_str := rtrim_zeros(new_move_str);
    -- kifreadからこの棋譜の手数を読み取る。最後に空白行があるので１を引く。
    select max(tesu)-1 into kif_tesu from kifread;
    raise notice 'going to regist metadata into kifs';
    begin
      -- max kid の値が競合しないようにロックをかける。
      lock kifs in exclusive mode;
      select into new_kid max(kid) + 1 from kifs;
      insert into kifs values(new_kid, id_on_2ch, kif_tesu, game_date, black_name, white_name, result_char, kif_data, new_move_str);
    end;
    select * into result from kifs where kid = new_kid;
    return result;
  end;$$
language 'plpgsql';

