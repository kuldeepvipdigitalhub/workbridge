--
-- PostgreSQL database dump
--

\restrict pXLm0tdlHnTku9QeKZVEUk23EFp9s0TcYHSQEhoieIZO5lqvwiwxqbnkmAolSMA

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-18 14:45:19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 241 (class 1259 OID 16608)
-- Name: admin_withdraw; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.admin_withdraw (
    id integer NOT NULL,
    amount integer,
    method character varying(50),
    details character varying(200),
    status character varying(20),
    created_at timestamp without time zone
);


ALTER TABLE public.admin_withdraw OWNER TO wbuser;

--
-- TOC entry 240 (class 1259 OID 16607)
-- Name: admin_withdraw_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.admin_withdraw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_withdraw_id_seq OWNER TO wbuser;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 240
-- Name: admin_withdraw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.admin_withdraw_id_seq OWNED BY public.admin_withdraw.id;


--
-- TOC entry 219 (class 1259 OID 16392)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO wbuser;

--
-- TOC entry 225 (class 1259 OID 16426)
-- Name: bid; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.bid (
    id integer NOT NULL,
    bid_amount integer NOT NULL,
    proposal text NOT NULL,
    status character varying(20),
    project_id integer NOT NULL,
    developer_id integer NOT NULL
);


ALTER TABLE public.bid OWNER TO wbuser;

--
-- TOC entry 224 (class 1259 OID 16425)
-- Name: bid_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bid_id_seq OWNER TO wbuser;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 224
-- Name: bid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.bid_id_seq OWNED BY public.bid.id;


--
-- TOC entry 237 (class 1259 OID 16574)
-- Name: deliverable; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.deliverable (
    id integer NOT NULL,
    project_id integer,
    developer_id integer,
    file character varying(200),
    github_link character varying(300),
    live_link character varying(300),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.deliverable OWNER TO wbuser;

--
-- TOC entry 236 (class 1259 OID 16573)
-- Name: deliverable_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.deliverable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliverable_id_seq OWNER TO wbuser;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 236
-- Name: deliverable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.deliverable_id_seq OWNED BY public.deliverable.id;


--
-- TOC entry 231 (class 1259 OID 16517)
-- Name: message; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.message (
    id integer NOT NULL,
    sender_id integer NOT NULL,
    receiver_id integer NOT NULL,
    project_id integer NOT NULL,
    message text NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.message OWNER TO wbuser;

--
-- TOC entry 230 (class 1259 OID 16516)
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.message_id_seq OWNER TO wbuser;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 230
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- TOC entry 229 (class 1259 OID 16488)
-- Name: payment; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    project_id integer,
    client_id integer,
    developer_id integer,
    developer_amount integer,
    created_at timestamp without time zone,
    method character varying(50),
    status character varying(20),
    amount integer,
    platform_fee integer
);


ALTER TABLE public.payment OWNER TO wbuser;

--
-- TOC entry 228 (class 1259 OID 16487)
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_seq OWNER TO wbuser;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 228
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- TOC entry 233 (class 1259 OID 16546)
-- Name: portfolio; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.portfolio (
    id integer NOT NULL,
    developer_id integer,
    title character varying(200),
    description text,
    link character varying(300)
);


ALTER TABLE public.portfolio OWNER TO wbuser;

--
-- TOC entry 232 (class 1259 OID 16545)
-- Name: portfolio_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.portfolio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.portfolio_id_seq OWNER TO wbuser;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 232
-- Name: portfolio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.portfolio_id_seq OWNED BY public.portfolio.id;


--
-- TOC entry 223 (class 1259 OID 16411)
-- Name: project; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.project (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    budget integer NOT NULL,
    deadline date NOT NULL,
    status character varying(20),
    client_id integer NOT NULL,
    category character varying(100)
);


ALTER TABLE public.project OWNER TO wbuser;

--
-- TOC entry 235 (class 1259 OID 16561)
-- Name: project_file; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.project_file (
    id integer NOT NULL,
    project_id integer,
    filename character varying(200)
);


ALTER TABLE public.project_file OWNER TO wbuser;

--
-- TOC entry 234 (class 1259 OID 16560)
-- Name: project_file_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.project_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_file_id_seq OWNER TO wbuser;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 234
-- Name: project_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.project_file_id_seq OWNED BY public.project_file.id;


--
-- TOC entry 222 (class 1259 OID 16410)
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_id_seq OWNER TO wbuser;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 222
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.project_id_seq OWNED BY public.project.id;


--
-- TOC entry 227 (class 1259 OID 16446)
-- Name: review; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.review (
    id integer NOT NULL,
    rating integer NOT NULL,
    comment text,
    project_id integer NOT NULL,
    client_id integer NOT NULL,
    developer_id integer NOT NULL
);


ALTER TABLE public.review OWNER TO wbuser;

--
-- TOC entry 226 (class 1259 OID 16445)
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_id_seq OWNER TO wbuser;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 226
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;


--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: user; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(120) NOT NULL,
    password bytea NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp without time zone,
    skills character varying(300),
    bio text,
    github character varying(200),
    resume character varying(200),
    is_active boolean DEFAULT true
);


ALTER TABLE public."user" OWNER TO wbuser;

--
-- TOC entry 220 (class 1259 OID 16398)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO wbuser;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 239 (class 1259 OID 16595)
-- Name: withdraw_request; Type: TABLE; Schema: public; Owner: wbuser
--

CREATE TABLE public.withdraw_request (
    id integer NOT NULL,
    user_id integer,
    amount integer,
    method character varying(50),
    details character varying(200),
    status character varying(20),
    created_at timestamp without time zone
);


ALTER TABLE public.withdraw_request OWNER TO wbuser;

--
-- TOC entry 238 (class 1259 OID 16594)
-- Name: withdraw_request_id_seq; Type: SEQUENCE; Schema: public; Owner: wbuser
--

CREATE SEQUENCE public.withdraw_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.withdraw_request_id_seq OWNER TO wbuser;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 238
-- Name: withdraw_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wbuser
--

ALTER SEQUENCE public.withdraw_request_id_seq OWNED BY public.withdraw_request.id;


--
-- TOC entry 4922 (class 2604 OID 16611)
-- Name: admin_withdraw id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.admin_withdraw ALTER COLUMN id SET DEFAULT nextval('public.admin_withdraw_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 16429)
-- Name: bid id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.bid ALTER COLUMN id SET DEFAULT nextval('public.bid_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16577)
-- Name: deliverable id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.deliverable ALTER COLUMN id SET DEFAULT nextval('public.deliverable_id_seq'::regclass);


--
-- TOC entry 4916 (class 2604 OID 16520)
-- Name: message id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 16491)
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- TOC entry 4917 (class 2604 OID 16549)
-- Name: portfolio id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.portfolio ALTER COLUMN id SET DEFAULT nextval('public.portfolio_id_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 16414)
-- Name: project id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project ALTER COLUMN id SET DEFAULT nextval('public.project_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 16564)
-- Name: project_file id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project_file ALTER COLUMN id SET DEFAULT nextval('public.project_file_id_seq'::regclass);


--
-- TOC entry 4914 (class 2604 OID 16449)
-- Name: review id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 16402)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 16598)
-- Name: withdraw_request id; Type: DEFAULT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.withdraw_request ALTER COLUMN id SET DEFAULT nextval('public.withdraw_request_id_seq'::regclass);


--
-- TOC entry 5135 (class 0 OID 16608)
-- Dependencies: 241
-- Data for Name: admin_withdraw; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.admin_withdraw (id, amount, method, details, status, created_at) FROM stdin;
1	1000	UPI	7804984824@ybl	completed	2026-03-17 12:21:25.475276
\.


--
-- TOC entry 5113 (class 0 OID 16392)
-- Dependencies: 219
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.alembic_version (version_num) FROM stdin;
54378cb7bf6e
\.


--
-- TOC entry 5119 (class 0 OID 16426)
-- Dependencies: 225
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.bid (id, bid_amount, proposal, status, project_id, developer_id) FROM stdin;
1	1212	jnmm	accepted	1	1
2	250000	bnbjbjknk	accepted	2	4
4	12500	 mnknkjn	accepted	3	1
3	12000	125631415	rejected	3	4
6	1	1235456	accepted	4	1
5	1500	, MB NMJNJBGH	rejected	4	4
7	1	mkjnkjnhjmbghjvbgh	accepted	6	4
8	1	434	accepted	7	4
9	1	  mnmm	accepted	8	4
\.


--
-- TOC entry 5131 (class 0 OID 16574)
-- Dependencies: 237
-- Data for Name: deliverable; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.deliverable (id, project_id, developer_id, file, github_link, live_link, notes, created_at) FROM stdin;
1	7	4	\N	\N	\N	\N	2026-03-16 19:30:05.663391
2	8	4	13.jpg	nvhgvhvhv	bvgvhg	hvghghgfvhg	2026-03-16 19:54:09.67867
\.


--
-- TOC entry 5125 (class 0 OID 16517)
-- Dependencies: 231
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.message (id, sender_id, receiver_id, project_id, message, "timestamp") FROM stdin;
1	3	1	1	DCJVJVHBDJVBJD MMVBDJVB	2026-03-06 17:05:35.748619
2	3	1	1		2026-03-06 17:05:37.20394
3	3	1	1	HJJVBJV	2026-03-06 17:05:47.711471
\.


--
-- TOC entry 5123 (class 0 OID 16488)
-- Dependencies: 229
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.payment (id, project_id, client_id, developer_id, developer_amount, created_at, method, status, amount, platform_fee) FROM stdin;
1	1	2	1	1800	2026-03-07 07:55:59.830738	\N	\N	\N	\N
2	3	5	1	13500	2026-03-13 15:57:18.578868	cash	completed	\N	\N
3	2	5	4	450000	2026-03-13 16:42:51.423271	cash	completed	\N	\N
4	3	5	1	13500	2026-03-13 16:47:57.204789	cash	completed	15000	1500
5	4	5	1	1982	2026-03-16 18:31:14.47786	cash	completed	2202	220
6	4	5	1	1982	2026-03-16 18:36:50.782595	cash	completed	2202	220
7	8	5	4	1	2026-03-17 04:53:05.142767	cash	completed	1	0
\.


--
-- TOC entry 5127 (class 0 OID 16546)
-- Dependencies: 233
-- Data for Name: portfolio; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.portfolio (id, developer_id, title, description, link) FROM stdin;
1	1	hbjbnhj	jbjbj	nkjnj
2	1	 mx nc	c nm n	dn 
3	1	nvjdbgjgdb	rfvjngj	djkfvnjdf
5	4	kbjbjbhkjjknbjkh	hbjhugh	bhug
\.


--
-- TOC entry 5117 (class 0 OID 16411)
-- Dependencies: 223
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.project (id, title, description, budget, deadline, status, client_id, category) FROM stdin;
1	medical website	nvkjnkbnfkvbk	2000	2026-02-01	completed	2	Web Development
3	college managment website	this is the college managment project	15000	2026-03-15	completed	5	Web Development
2	hotel managment system	This Is The Hotel Managment Website Project  , it is a 3s Star hotel 	500000	2026-03-01	completed	5	Web Development
5	M BNVN	VM GNB	2120	2026-04-01	open	5	Web Development
4	kdvhdfhvjv	dcbnjfvbj	2202	2026-05-01	completed	5	Web Development
6	college website	a pharmecy clg website	1	2026-05-07	submitted	5	Web Development
7	phone paye	jnnkjnjvbjbkj bgd	1	2026-05-03	submitted	5	Web Development
8	goooglr pr	fb fg 	1	2026-05-05	completed	5	Web Development
9	lost and found app	this is appliction for find you lost item	1500000	2026-05-05	open	2	Mobile App
10	data entry in the db mall	work for the some hour	10000	2026-05-01	open	2	data entry
\.


--
-- TOC entry 5129 (class 0 OID 16561)
-- Dependencies: 235
-- Data for Name: project_file; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.project_file (id, project_id, filename) FROM stdin;
\.


--
-- TOC entry 5121 (class 0 OID 16446)
-- Dependencies: 227
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.review (id, rating, comment, project_id, client_id, developer_id) FROM stdin;
1	5	,m ,nm	3	5	1
2	5	nm m	2	5	4
\.


--
-- TOC entry 5115 (class 0 OID 16399)
-- Dependencies: 221
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public."user" (id, name, email, password, role, created_at, skills, bio, github, resume, is_active) FROM stdin;
2	atul	atul13072003@gmail.com	\\x243262243132246b3573446e3746744d374f44657553675831442f6875516c594d4c593633555868374d387862704c73364266784c393859595a7475	client	2026-03-03 19:15:00.064653	\N	\N	\N	\N	t
3	Kuldeep Harinkhede	kuldeepharinkhede512@gmail.com	\\x24326224313224514a487951514631784961424b556847495152376575767053354d334c68316b41796f4e5450337469727869326b47476b6f437332	admin	2026-03-05 17:46:12.029943	\N	\N	\N	\N	t
1	Laxit Choudhary	laxit1610@gmail.com	\\x2432622431322479685252716a486d4b7662393250436168477430362e5933792f7878364f6e4f6951504f5678584f7749336647414258596148652e	developer	2026-03-03 19:08:30.519634	pythiob,rb 	bcgcfgfg\r\nNone\r\n\r\n	Nonegvhvhv	\N	t
4	khushi bisen	khushi@gmail.com	\\x24326224313224446644664b6f51344e794f6e5059436e546f5666432e55794f7731494f394c43494b4a52545847686651464e742f5163752e2f6857	developer	2026-03-07 13:32:48.918375	None	\r\nNone\r\nvnkjgkb \r\n	Nonevkrgnkejbjk 	\N	t
5	bharti patle	bharti@gmail.com	\\x24326224313224397445356441765a744563423769433945426639454f67446572693133326c5561756852464f6877486f30454a4531497066717332	client	2026-03-07 13:39:37.70363	\N	\N	\N	\N	t
\.


--
-- TOC entry 5133 (class 0 OID 16595)
-- Dependencies: 239
-- Data for Name: withdraw_request; Type: TABLE DATA; Schema: public; Owner: wbuser
--

COPY public.withdraw_request (id, user_id, amount, method, details, status, created_at) FROM stdin;
1	4	40000	UPI	7804984824@ybl	pending	2026-03-17 08:53:49.759156
2	1	32000	UPI	7804984824@ybl	completed	2026-03-17 10:00:56.81652
\.


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 240
-- Name: admin_withdraw_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.admin_withdraw_id_seq', 1, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 224
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.bid_id_seq', 9, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 236
-- Name: deliverable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.deliverable_id_seq', 2, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 230
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.message_id_seq', 3, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 228
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.payment_id_seq', 7, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 232
-- Name: portfolio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.portfolio_id_seq', 5, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 234
-- Name: project_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.project_file_id_seq', 1, false);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 222
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.project_id_seq', 10, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 226
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.review_id_seq', 2, true);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.user_id_seq', 5, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 238
-- Name: withdraw_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wbuser
--

SELECT pg_catalog.setval('public.withdraw_request_id_seq', 2, true);


--
-- TOC entry 4948 (class 2606 OID 16614)
-- Name: admin_withdraw admin_withdraw_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.admin_withdraw
    ADD CONSTRAINT admin_withdraw_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 16397)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 4932 (class 2606 OID 16434)
-- Name: bid bid_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.bid
    ADD CONSTRAINT bid_pkey PRIMARY KEY (id);


--
-- TOC entry 4944 (class 2606 OID 16583)
-- Name: deliverable deliverable_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.deliverable
    ADD CONSTRAINT deliverable_pkey PRIMARY KEY (id);


--
-- TOC entry 4938 (class 2606 OID 16529)
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- TOC entry 4936 (class 2606 OID 16500)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- TOC entry 4940 (class 2606 OID 16554)
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id);


--
-- TOC entry 4942 (class 2606 OID 16567)
-- Name: project_file project_file_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project_file
    ADD CONSTRAINT project_file_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 2606 OID 16419)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- TOC entry 4934 (class 2606 OID 16458)
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- TOC entry 4926 (class 2606 OID 16409)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 4928 (class 2606 OID 16407)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 16601)
-- Name: withdraw_request withdraw_request_pkey; Type: CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.withdraw_request
    ADD CONSTRAINT withdraw_request_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 16435)
-- Name: bid bid_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.bid
    ADD CONSTRAINT bid_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public."user"(id);


--
-- TOC entry 4951 (class 2606 OID 16440)
-- Name: bid bid_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.bid
    ADD CONSTRAINT bid_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4963 (class 2606 OID 16589)
-- Name: deliverable deliverable_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.deliverable
    ADD CONSTRAINT deliverable_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public."user"(id);


--
-- TOC entry 4964 (class 2606 OID 16584)
-- Name: deliverable deliverable_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.deliverable
    ADD CONSTRAINT deliverable_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4958 (class 2606 OID 16530)
-- Name: message message_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4959 (class 2606 OID 16535)
-- Name: message message_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public."user"(id);


--
-- TOC entry 4960 (class 2606 OID 16540)
-- Name: message message_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public."user"(id);


--
-- TOC entry 4955 (class 2606 OID 16501)
-- Name: payment payment_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_client_id_fkey FOREIGN KEY (client_id) REFERENCES public."user"(id);


--
-- TOC entry 4956 (class 2606 OID 16506)
-- Name: payment payment_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public."user"(id);


--
-- TOC entry 4957 (class 2606 OID 16511)
-- Name: payment payment_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4961 (class 2606 OID 16555)
-- Name: portfolio portfolio_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT portfolio_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public."user"(id);


--
-- TOC entry 4949 (class 2606 OID 16420)
-- Name: project project_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_client_id_fkey FOREIGN KEY (client_id) REFERENCES public."user"(id);


--
-- TOC entry 4962 (class 2606 OID 16568)
-- Name: project_file project_file_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.project_file
    ADD CONSTRAINT project_file_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4952 (class 2606 OID 16459)
-- Name: review review_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_client_id_fkey FOREIGN KEY (client_id) REFERENCES public."user"(id);


--
-- TOC entry 4953 (class 2606 OID 16464)
-- Name: review review_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public."user"(id);


--
-- TOC entry 4954 (class 2606 OID 16469)
-- Name: review review_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- TOC entry 4965 (class 2606 OID 16602)
-- Name: withdraw_request withdraw_request_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wbuser
--

ALTER TABLE ONLY public.withdraw_request
    ADD CONSTRAINT withdraw_request_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE alembic_version; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.alembic_version TO postgres;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE bid; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.bid TO postgres;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE bid_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.bid_id_seq TO postgres;


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE message; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.message TO postgres;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE message_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.message_id_seq TO postgres;


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE payment; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.payment TO postgres;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE payment_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.payment_id_seq TO postgres;


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE portfolio; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.portfolio TO postgres;


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE portfolio_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.portfolio_id_seq TO postgres;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE project; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.project TO postgres;


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE project_file; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.project_file TO postgres;


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE project_file_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.project_file_id_seq TO postgres;


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE project_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.project_id_seq TO postgres;


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE review; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public.review TO postgres;


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE review_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.review_id_seq TO postgres;


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON TABLE public."user" TO postgres;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: public; Owner: wbuser
--

GRANT ALL ON SEQUENCE public.user_id_seq TO postgres;


-- Completed on 2026-03-18 14:45:20

--
-- PostgreSQL database dump complete
--

\unrestrict pXLm0tdlHnTku9QeKZVEUk23EFp9s0TcYHSQEhoieIZO5lqvwiwxqbnkmAolSMA

