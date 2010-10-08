--
-- Name: moves; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE moves (
    bid integer,
    mid integer,
    m_from smallint not null,
    m_to smallint not null,
    piece character(1) not null check((upper(piece)=piece and bid%2=1) or (lower(piece)=piece and bid%2=0)),
    promote boolean not null,
    nxt_bid integer not null references boards(bid) check(bid%2<>nxt_bid%2),
    primary key (bid, mid),
    unique (bid, m_from, m_to, piece, promote)
);

ALTER TABLE public.moves OWNER TO skkmania;
