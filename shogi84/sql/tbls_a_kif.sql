--
-- Name: moves; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE a_kif (
    cnt		bigint,
    kmid	numeric,
    bid		integer,
    mid		integer,
    m_from	smallint not null,
    m_to	smallint not null,
    piece	character(1) not null,
    promote	boolean not null,
    nxt_bid	integer not null
);

ALTER TABLE public.a_kif OWNER TO skkmania;
