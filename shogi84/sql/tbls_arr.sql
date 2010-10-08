--
-- Name: arr; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--  cachetest.html でしか使わない
--    一時的データ保存のためのテーブル
--

CREATE TABLE arr (
    bid integer,
    ll  integer,
    nxts integer[],
    nn  smallint,
    pres integer[],
    pn  integer
);

ALTER TABLE public.arr OWNER TO skkmania;

