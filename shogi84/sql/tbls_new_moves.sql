--
-- Name: new_moves; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE new_moves (
    bid integer,
    mid integer,
    m_from smallint not null,
    m_to smallint not null,
    piece character(1) not null,
    promote boolean not null,
    nxt_bid integer not null
);

ALTER TABLE public.new_moves OWNER TO skkmania;
