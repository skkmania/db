--
-- Name: user_logins; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE user_logins (
    userid integer not null references users(userid),
    uname varchar(15) NOT NULL references users(uname), 
    login_key varchar not null
);

ALTER TABLE public.user_logins OWNER TO skkmania;
