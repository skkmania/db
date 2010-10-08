--
-- Name: move_point_user; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE move_point_user (
    bid integer,
    mid smallint,
    userid integer references users (userid),
    point smallint check( point >= -10 and point <=10),
    foreign key (bid, mid) references moves (bid, mid)
);

ALTER TABLE public.move_point_user OWNER TO skkmania;
