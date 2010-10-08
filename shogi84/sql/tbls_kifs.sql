--
-- Name: kifs; Type: TABLE; Schema: public; Owner: skkmania; Tablespace:
--

CREATE TABLE kifs (
   kid   serial primary key,
   id2ch integer unique,
   tesu  integer not null,
   gdate date,
   black varchar(30),
   white varchar(30),
   result char not null check (result ~ '[bwjsu]'),
   kif   varchar not null
);

ALTER TABLE public.kifs OWNER TO skkmania;
