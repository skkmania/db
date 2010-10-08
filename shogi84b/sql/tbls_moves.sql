--
-- Name: moves; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE moves (
    bid integer references boards(bid),
    mid integer,
    move bytea not null check (length(move) = 2),
    nxt_bid integer not null references boards(bid) check(bid%2<>nxt_bid%2),
    primary key (bid, mid),
    unique (bid, move)
);

ALTER TABLE public.moves OWNER TO norika;
