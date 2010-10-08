--
-- Name: new_boards; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE new_boards (
	    bid integer,
	    turn boolean NOT NULL,
	    black varchar(38) not null,
	    board character(81) NOT NULL,
	    white varchar(38) not null
);

ALTER TABLE public.new_boards OWNER TO skkmania;

