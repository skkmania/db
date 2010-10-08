--
-- Name: boards; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE boards (
	    bid integer primary key,
	    turn boolean NOT NULL check (turn = (bid%2=1)),
	    black varchar(38) not null check (black = upper(black)),
	    board character(81) NOT NULL check (length(board) = 81),
	    white varchar(38) not null check (white = lower(white)),
	    unique (turn, black, board, white)
);

ALTER TABLE public.boards OWNER TO skkmania;

create index board_only_idx on boards (board);
create index black__idx on boards (black);
create index white__idx on boards (white);
create index all_idx on boards (board, black, white);
