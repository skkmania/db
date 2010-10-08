--
--  kidを指定されるとkifsからデータを読み、その棋譜のデータをkifu_dataテーブルへ登録する
--
create or replace function kifs2data(id integer)
  returns void as $$
  declare
    kif_str varchar default '';
    count  smallint;
    mid_chr varchar default '';
    tesu_cnt smallint default 1;
    this_bid integer default 1;
    this_mid smallint;
  begin
    -- kifu_dataには指定されたidのデータがまだ無いことを確認
    select into count kid from kifu_data where kid = id;
    if found then
      raise exception 'kifs2data: requested id % already exists in kifu_data.',id;
    end if;
    
    -- kifsから棋譜の文字列と手数を取得
    select into kif_str kif from kifs where kid = id;
    select into count  tesu from kifs where kid = id;
    -- kif_strを１文字ずつ追いかけてkifu_dataにデータを登録

      -- まず、kif_strのぶんを処理
    while length(kif_str) > 0 loop
      mid_chr := substr(kif_str, 1, 1);
        -- kif_str に'd'が現れたらその次の二文字がmidである
      if mid_chr = 'd' then
        kif_str := substr(kif_str, 2);
        mid_chr := substr(kif_str, 1, 2);
        this_mid := to_number(mid_chr, '99');
        -- dの後に1つだけしか数字がない場合、0が削除されているということので、補う
        if this_mid < 10 then this_mid := 10*this_mid; end if;
        kif_str := substr(kif_str, 3);
      else
        this_mid := to_number(mid_chr, '9');
        kif_str := substr(kif_str, 2);
      end if;
      insert into kifu_data values(id, tesu_cnt, this_bid, this_mid);
      select into this_bid nxt_bid from moves where bid = this_bid and mid = this_mid;
      tesu_cnt := tesu_cnt + 1;
    end loop;

      -- kif_strを読み尽くしたあとはこの棋譜の手数までmidは0が続く
    while tesu_cnt <= count loop
      insert into kifu_data values(id, tesu_cnt, this_bid, 0);
      select into this_bid nxt_bid from moves where bid = this_bid and mid = 0;
      tesu_cnt := tesu_cnt + 1;
    end loop;
      
  end;$$
language 'plpgsql';
