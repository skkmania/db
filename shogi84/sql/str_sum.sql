-- 文字列の和の集約関数をつくる

CREATE OR REPLACE FUNCTION sum(text,text) 
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
            RETURN state || ':' || input_data;
        END IF;
    END
$BODY$
LANGUAGE 'plpgsql' VOLATILE;


-- 集約関数
CREATE AGGREGATE sum(basetype = text, sfunc = sum, stype = text);
