--
-- Name: board_comments; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE board_comments (
    bid integer references boards(bid),
    bcomment text not null check(char_length(bcomment) < 300),
    userid integer references users(userid),
    unique (bid, userid)
);

ALTER TABLE public.board_comments OWNER TO skkmania;
