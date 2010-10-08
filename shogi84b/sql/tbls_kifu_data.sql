--
-- Name: kifu_data; Type: TABLE; Schema: public; Owner: norika; Tablespace:
--

CREATE TABLE kifu_data (
	    kid  integer not null references kifs(kid),
	    tesu smallint NOT NULL,
	    bid  integer not null references boards(bid),
	    mid  smallint NOT NULL,
	    unique (kid, tesu)
);

ALTER TABLE public.kifu_data OWNER TO norika;

create index sasite_idx on kifu_data (bid,mid);
