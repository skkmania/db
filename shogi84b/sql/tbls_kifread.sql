--
-- Name: kifread; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE kifread (
    tesu smallint not null,
    move bytea,
    board bytea not null
);

ALTER TABLE public.kifread OWNER TO norika;

