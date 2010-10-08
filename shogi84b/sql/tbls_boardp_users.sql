--
-- Name: boardp_users; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE boardp_users (
    bid integer references boards(bid),
    userid integer references users(userid),
    pbpoint smallint not null check (-10 < pbpoint and pbpoint < 10),
    unique (bid, userid)
);

ALTER TABLE public.boardp_users OWNER TO skkmania;
