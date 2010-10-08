--
-- Name: move_comments; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE move_comments (
    bid integer,
    mid smallint,
    mcomment text not null check(char_length(mcomment) < 200),
    userid integer not null references users (userid),
    foreign key (bid, mid) references moves (bid, mid),
    unique (bid, mid, userid)
);

ALTER TABLE public.move_comments OWNER TO skkmania;
