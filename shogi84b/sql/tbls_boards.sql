--
-- Name: boards; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE boards (
      bid integer primary key,
      board bytea NOT NULL unique check (length(board) <= 37)
);
ALTER TABLE public.boards OWNER TO norika;
