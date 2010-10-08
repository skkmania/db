--
-- Name: move_points; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE move_points (
    bid integer,
    mid smallint,
    point real,
    foreign key (bid, mid) references moves (bid, mid)
);

ALTER TABLE public.move_points OWNER TO skkmania;
