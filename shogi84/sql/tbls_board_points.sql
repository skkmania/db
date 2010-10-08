--
-- Name: board_points; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE board_points (
    bid integer unique references boards(bid),
    bpoint real not null check (-10.0 < bpoint and bpoint < 10.0)
);

ALTER TABLE public.board_points OWNER TO skkmania;
