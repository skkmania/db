--
-- Name: moves_user; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE moves_user (
    bid integer,
    mid smallint,
    userid integer references users (userid),
    foreign key (bid, mid) references moves (bid, mid)
);

ALTER TABLE public.moves_user OWNER TO skkmania;
