--
-- Name: kifread; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE kifread (
    tesu smallint not null,
    m_from smallint,
    m_to smallint,
    piece character(1) check((upper(piece)=piece and tesu%2=1) or (lower(piece)=piece and tesu%2=0)),
    promote boolean,
    turn boolean not null,
    black_hand varchar,
    board character(81) not null,
    white_hand varchar
);

ALTER TABLE public.kifread OWNER TO skkmania;

