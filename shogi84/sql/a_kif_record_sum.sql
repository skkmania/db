-- 指し手を文字列にし、その和の集約関数をつくる

CREATE OR REPLACE FUNCTION sum(a_kif_record, a_kif_record) 
RETURNS text as 
$BODY$
    -- 現在の状態値と現在の入力データ項目を受け取り、次の状態値を返す
    DECLARE
        state alias for $1;         -- 状態値
        input_data alias for $2;    -- 入力値
    BEGIN
        IF state IS NULL THEN
            RETURN input_data;
        ELSIF input_data IS NULL THEN
            RETURN state;
        ELSE
            RETURN state.piece || ':' || input_data.piece;
        END IF;
    END
$BODY$
LANGUAGE 'plpgsql' VOLATILE;


-- 集約関数
CREATE AGGREGATE sum(basetype = a_kif_record, sfunc = sum, stype = text);
