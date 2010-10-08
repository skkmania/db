--
-- Name: new_boards; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE new_boards (
    bid integer,
    board bytea NOT NULL unique check (length(board) <= 37)
);

ALTER TABLE public.new_boards OWNER TO norika;

