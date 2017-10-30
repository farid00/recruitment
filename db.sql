--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


SET search_path = public, pg_catalog;

--
-- Name: Comments_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE "Comments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Comments_id_seq" OWNER TO dev;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Comments; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE "Comments" (
    user_id integer,
    organization_id integer,
    text text,
    id integer DEFAULT nextval('"Comments_id_seq"'::regclass) NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    recruit_id integer,
    parent_id integer
);


ALTER TABLE "Comments" OWNER TO dev;

--
-- Name: Organizations; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE "Organizations" (
    id integer NOT NULL,
    primary_name character varying(255),
    secondary_name character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    token_code character varying(255),
    user_id integer
);


ALTER TABLE "Organizations" OWNER TO dev;

--
-- Name: Organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE "Organizations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Organizations_id_seq" OWNER TO dev;

--
-- Name: Organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE "Organizations_id_seq" OWNED BY "Organizations".id;


--
-- Name: Recruits; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE "Recruits" (
    id integer NOT NULL,
    first_name character varying(255),
    middle_name character varying(255),
    last_name character varying(255),
    organization_id integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE "Recruits" OWNER TO dev;

--
-- Name: Users; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE "Users" (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    password character varying(255),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    username character varying(255),
    organization_id integer
);


ALTER TABLE "Users" OWNER TO dev;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE "Users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Users_id_seq" OWNER TO dev;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE "Users_id_seq" OWNED BY "Users".id;


--
-- Name: Votes; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE "Votes" (
    user_id integer,
    comment_id integer,
    id integer NOT NULL,
    value integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE "Votes" OWNER TO dev;

--
-- Name: Votes_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE "Votes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Votes_id_seq" OWNER TO dev;

--
-- Name: Votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE "Votes_id_seq" OWNED BY "Votes".id;


--
-- Name: recruit_comments; Type: VIEW; Schema: public; Owner: dev
--

CREATE VIEW recruit_comments AS
 WITH RECURSIVE recruit_comments(id, parent_id, comment, level) AS (
         SELECT "Comments".id,
            "Comments".id AS parent_id,
            "Comments".text,
            0 AS level
           FROM "Comments"
          WHERE ("Comments".parent_id IS NULL)
        UNION ALL
         SELECT c.id,
            c.parent_id,
            c.text,
            (ct.level + 1)
           FROM ("Comments" c
             JOIN recruit_comments ct ON ((ct.id = c.parent_id)))
        )
 SELECT recruit_comments.id,
    recruit_comments.parent_id,
    recruit_comments.comment,
    recruit_comments.level
   FROM recruit_comments;


ALTER TABLE recruit_comments OWNER TO dev;

--
-- Name: recruits_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE recruits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recruits_id_seq OWNER TO dev;

--
-- Name: recruits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE recruits_id_seq OWNED BY "Recruits".id;


--
-- Name: user_organizations; Type: TABLE; Schema: public; Owner: dev; Tablespace: 
--

CREATE TABLE user_organizations (
    user_id integer NOT NULL,
    organization_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE user_organizations OWNER TO dev;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Organizations" ALTER COLUMN id SET DEFAULT nextval('"Organizations_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Recruits" ALTER COLUMN id SET DEFAULT nextval('recruits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Users" ALTER COLUMN id SET DEFAULT nextval('"Users_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Votes" ALTER COLUMN id SET DEFAULT nextval('"Votes_id_seq"'::regclass);


--
-- Data for Name: Comments; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY "Comments" (user_id, organization_id, text, id, updated_at, created_at, recruit_id, parent_id) FROM stdin;
12	87	asdfs	1	2017-08-30 23:41:05.074-04	2017-08-30 23:41:05.074-04	\N	\N
12	87	asdfs	2	2017-08-30 23:43:01.09-04	2017-08-30 23:43:01.09-04	\N	\N
12	87	asdfs	3	2017-08-30 23:44:22.58-04	2017-08-30 23:44:22.58-04	\N	\N
12	87	 afghrff	8	2017-08-31 00:03:38.609-04	2017-08-31 00:03:38.609-04	14	\N
12	87	asdf	9	2017-08-31 00:09:13.637-04	2017-08-31 00:09:13.637-04	14	\N
12	87	fdsafdsaf	10	2017-08-31 00:09:56.173-04	2017-08-31 00:09:56.173-04	14	\N
12	87	fdsafdsaf	11	2017-08-31 00:12:51.887-04	2017-08-31 00:12:51.887-04	14	\N
12	87	asdf	12	2017-08-31 00:16:37.059-04	2017-08-31 00:16:37.059-04	14	\N
12	87	asdf	13	2017-08-31 00:18:19.601-04	2017-08-31 00:18:19.601-04	14	\N
12	87	asdfsd	14	2017-08-31 00:20:03.486-04	2017-08-31 00:20:03.486-04	15	\N
12	87	asdfsd	15	2017-08-31 00:22:07.934-04	2017-08-31 00:22:07.934-04	15	\N
12	87	asdf	17	2017-08-31 00:26:19.922-04	2017-08-31 00:26:19.922-04	14	16
12	87	asdfdsafdsafd	18	2017-08-31 00:27:57.631-04	2017-08-31 00:27:57.631-04	14	16
12	87	adfg	16	2017-08-31 00:24:41.472-04	2017-08-31 00:24:41.472-04	14	\N
12	87	asdfsda	19	2017-08-31 00:30:08.993-04	2017-08-31 00:30:08.993-04	14	11
12	87	asdfdsa	20	2017-09-07 17:27:42.493-04	2017-09-07 17:27:42.493-04	\N	\N
12	87	asdfsa	21	2017-09-07 17:28:50.989-04	2017-09-07 17:28:50.989-04	\N	\N
12	87	asdfsda	22	2017-09-07 17:46:14.988-04	2017-09-07 17:46:14.988-04	\N	\N
12	87	asdf	23	2017-09-07 17:47:59.731-04	2017-09-07 17:47:59.731-04	\N	\N
12	87	kjkj	24	2017-09-07 18:01:03.946-04	2017-09-07 18:01:03.946-04	14	\N
12	87	test	25	2017-09-07 18:18:48.989-04	2017-09-07 18:18:48.989-04	14	\N
12	87	test	26	2017-09-07 18:19:47.552-04	2017-09-07 18:19:47.552-04	14	8
12	87	fxgdf	27	2017-09-07 18:37:41.15-04	2017-09-07 18:37:41.15-04	14	8
12	87	hj	28	2017-09-07 18:40:31.643-04	2017-09-07 18:40:31.643-04	14	8
12	87	hi	29	2017-09-07 18:49:17.122-04	2017-09-07 18:49:17.122-04	14	8
12	87	hiii	30	2017-09-07 18:49:22.368-04	2017-09-07 18:49:22.368-04	14	8
12	87	hu	31	2017-09-07 18:49:32.47-04	2017-09-07 18:49:32.47-04	14	8
12	87	hi	32	2017-09-07 18:50:00.877-04	2017-09-07 18:50:00.877-04	14	26
12	87	hiii	33	2017-09-07 18:50:04.012-04	2017-09-07 18:50:04.012-04	14	26
12	87	l	34	2017-09-07 18:50:43.98-04	2017-09-07 18:50:43.98-04	14	26
12	87	jj	35	2017-09-07 18:52:05.256-04	2017-09-07 18:52:05.256-04	14	8
12	87	xx	36	2017-09-07 18:53:00.485-04	2017-09-07 18:53:00.485-04	14	8
12	87	l	37	2017-09-07 18:55:00.974-04	2017-09-07 18:55:00.974-04	14	26
12	87	hihi	38	2017-09-07 19:00:37.718-04	2017-09-07 19:00:37.718-04	14	31
12	87	hihihihihi	39	2017-09-07 19:00:40.447-04	2017-09-07 19:00:40.447-04	14	31
\.


--
-- Name: Comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('"Comments_id_seq"', 39, true);


--
-- Data for Name: Organizations; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY "Organizations" (id, primary_name, secondary_name, created_at, updated_at, token_code, user_id) FROM stdin;
89	AEPI	a	2017-08-29 01:08:14.512-04	2017-08-29 01:08:14.512-04	\N	\N
90	AEPI	z	2017-08-29 01:14:28.139-04	2017-08-29 01:14:28.139-04	\N	\N
91	tokenChapter	fs	2017-08-29 02:46:45.974-04	2017-08-29 02:46:45.974-04	\\x801e252143a1410f1932b6cf57206e2b02de6f4f5f189d0457915f15d07d2c1576a39b70eb53ef0a2e3bcefb758197a1	\N
92	tokenChapter2	fs	2017-08-29 02:54:27.463-04	2017-08-29 02:54:27.463-04	08aIJ8Hv1fLR3GWduLGl/7K+Pr5CjsT6Pro+LhQdvBB6XkynEfgfkOV/sSPv0hiq	\N
93	as	as	2017-08-29 03:12:21.07-04	2017-08-29 03:12:21.07-04	\N	\N
87	AEPI	SKP	2017-08-29 01:01:21.964-04	2017-08-29 01:01:21.964-04	Uq76R8GFqFg5/xGKDORe5WPEId1mXhVOdd9aU7w/10xPXDo8gYDuzjWMYLtRIK0B	\N
\.


--
-- Name: Organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('"Organizations_id_seq"', 93, true);


--
-- Data for Name: Recruits; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY "Recruits" (id, first_name, middle_name, last_name, organization_id, created_at, updated_at, user_id) FROM stdin;
14	bob the builder	\N	bob the builder	87	2017-08-29 01:46:23.834-04	2017-08-29 01:46:23.834-04	12
15	times new roman	\N	sfsf	87	2017-08-29 02:20:00.298-04	2017-08-29 02:20:00.298-04	12
16	asdf	\N	asdf	87	2017-08-29 02:21:21.437-04	2017-08-29 02:21:21.437-04	12
17	as	\N	as	87	2017-08-29 02:22:30.507-04	2017-08-29 02:22:30.507-04	12
18	as	\N	as	87	2017-08-29 02:25:31.072-04	2017-08-29 02:25:31.072-04	12
19	death man	\N	blob pants	87	2017-08-29 14:36:14.932-04	2017-08-29 14:36:14.932-04	15
20	bob	\N	mueller	87	2017-09-03 12:44:09.294-04	2017-09-03 12:44:09.294-04	12
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY "Users" (id, first_name, last_name, password, created_at, updated_at, username, organization_id) FROM stdin;
15	member	member	$2a$12$JNtFcbS3Pc0SrlyfFHNgwO19WFtEokA8SoTvIsGdfMGVzRTUTvr92	2017-08-29 14:34:20.649-04	2017-08-29 14:35:33.187-04	member	87
12	matt	brandman	$2a$05$2T7Y9XBqtJ9bBI4ZLLC.gOWeA1Jwha9y4uLtym4xFIC2GHjiUYrqu	2017-08-03 16:19:07.952-04	2017-08-30 18:59:19.42-04	admin	87
\.


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('"Users_id_seq"', 15, true);


--
-- Data for Name: Votes; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY "Votes" (user_id, comment_id, id, value, created_at, updated_at) FROM stdin;
14	16	2	1	2017-08-30 18:59:19.42-04	2017-08-30 18:59:19.42-04
12	16	3	1	2017-08-30 18:59:19.42-04	2017-08-30 18:59:19.42-04
\.


--
-- Name: Votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('"Votes_id_seq"', 3, true);


--
-- Name: recruits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('recruits_id_seq', 20, true);


--
-- Data for Name: user_organizations; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY user_organizations (user_id, organization_id, created_at, updated_at) FROM stdin;
12	87	2017-08-29 01:01:21.982-04	2017-08-29 01:01:21.982-04
12	89	2017-08-29 01:08:14.531-04	2017-08-29 01:08:14.531-04
12	90	2017-08-29 01:14:28.154-04	2017-08-29 01:14:28.154-04
12	91	2017-08-29 02:46:45.99-04	2017-08-29 02:46:45.99-04
12	92	2017-08-29 02:54:27.479-04	2017-08-29 02:54:27.479-04
12	93	2017-08-29 03:12:21.082-04	2017-08-29 03:12:21.082-04
15	87	2017-08-29 14:35:31.375-04	2017-08-29 14:35:31.375-04
\.


--
-- Name: Comments_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Comments"
    ADD CONSTRAINT "Comments_pkey" PRIMARY KEY (id);


--
-- Name: Organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Organizations"
    ADD CONSTRAINT "Organizations_pkey" PRIMARY KEY (id);


--
-- Name: UQ_username; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "UQ_username" UNIQUE (username);


--
-- Name: Users_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: recruits_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Recruits"
    ADD CONSTRAINT recruits_pkey PRIMARY KEY (id);


--
-- Name: user_id_organization_id_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY user_organizations
    ADD CONSTRAINT user_id_organization_id_pkey PRIMARY KEY (user_id, organization_id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: dev; Tablespace: 
--

ALTER TABLE ONLY "Votes"
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: FKI_organizations_comments; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_organizations_comments" ON "Comments" USING btree (organization_id);


--
-- Name: FKI_organizations_user_organizations; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_organizations_user_organizations" ON user_organizations USING btree (organization_id);


--
-- Name: FKI_organizations_users; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_organizations_users" ON "Recruits" USING btree (organization_id);


--
-- Name: FKI_recruits_comments; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_recruits_comments" ON "Comments" USING btree (recruit_id);


--
-- Name: FKI_users_comments; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_users_comments" ON "Comments" USING btree (user_id);


--
-- Name: FKI_users_organizations; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "FKI_users_organizations" ON "Organizations" USING btree (user_id);


--
-- Name: fki_user_organizations_fk_constraint_UserId_and_OrganizationId; Type: INDEX; Schema: public; Owner: dev; Tablespace: 
--

CREATE INDEX "fki_user_organizations_fk_constraint_UserId_and_OrganizationId" ON "Recruits" USING btree (user_id, organization_id);


--
-- Name: FK_organizations_comments; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Comments"
    ADD CONSTRAINT "FK_organizations_comments" FOREIGN KEY (organization_id) REFERENCES "Organizations"(id);


--
-- Name: FK_organizations_user_organizations; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY user_organizations
    ADD CONSTRAINT "FK_organizations_user_organizations" FOREIGN KEY (organization_id) REFERENCES "Organizations"(id);


--
-- Name: FK_organizations_users; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Recruits"
    ADD CONSTRAINT "FK_organizations_users" FOREIGN KEY (organization_id) REFERENCES "Organizations"(id);


--
-- Name: FK_recruits_comments; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Comments"
    ADD CONSTRAINT "FK_recruits_comments" FOREIGN KEY (recruit_id) REFERENCES "Recruits"(id);


--
-- Name: FK_user_organizations_users; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Users"
    ADD CONSTRAINT "FK_user_organizations_users" FOREIGN KEY (id, organization_id) REFERENCES user_organizations(user_id, organization_id);


--
-- Name: FK_users_comments; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Comments"
    ADD CONSTRAINT "FK_users_comments" FOREIGN KEY (user_id) REFERENCES "Users"(id);


--
-- Name: FK_users_organizations; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Organizations"
    ADD CONSTRAINT "FK_users_organizations" FOREIGN KEY (user_id) REFERENCES "Users"(id);


--
-- Name: FK_users_recruits; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY "Recruits"
    ADD CONSTRAINT "FK_users_recruits" FOREIGN KEY (user_id) REFERENCES "Users"(id);


--
-- Name: FK_users_user_organizations; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY user_organizations
    ADD CONSTRAINT "FK_users_user_organizations" FOREIGN KEY (user_id) REFERENCES "Users"(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: dev
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM dev;
GRANT ALL ON SCHEMA public TO dev;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

