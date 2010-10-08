--
-- Name: new_moves; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE new_moves (
    bid integer,
    mid integer,
    move bytea not null,
    nxt_bid integer not null
);

ALTER TABLE public.new_moves OWNER TO norika;
