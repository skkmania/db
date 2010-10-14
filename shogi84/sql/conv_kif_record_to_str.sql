-- 指し手を文字列に変換する

CREATE OR REPLACE FUNCTION conv_kif_record_to_str(bid integer, 
                                                  mid integer,
                                                  m_from smallint,
                                                  m_to   smallint,
                                                  piece  char,
                                                  promote boolean,
                                                  nxt_bid integer)
RETURNS text as 
$BODY$
    BEGIN
      if promote then
        RETURN bid::text || ',' || mid::text || ',' ||
               m_from::text || ',' || m_to::text || ',' ||
               piece || ',t,' || nxt_bid::text;
      else
        RETURN bid::text || ',' || mid::text || ',' ||
               m_from::text || ',' || m_to::text || ',' ||
               piece || ',f,' || nxt_bid::text;
      end if;
    END
$BODY$
LANGUAGE 'plpgsql' VOLATILE;
