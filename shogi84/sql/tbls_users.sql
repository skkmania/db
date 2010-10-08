--
-- Name: users; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE users (
    userid integer primary key,
    uname varchar(15) NOT NULL unique, 
    upw varchar(30) not null
);

ALTER TABLE public.users OWNER TO skkmania;
