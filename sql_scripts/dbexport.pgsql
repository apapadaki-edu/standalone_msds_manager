--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: additive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.additive (
    id bigint NOT NULL,
    name text,
    last_update_date timestamp without time zone,
    price double precision,
    msds bytea,
    comment text
);


ALTER TABLE public.additive OWNER TO postgres;

--
-- Name: additive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.additive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.additive_id_seq OWNER TO postgres;

--
-- Name: additive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.additive_id_seq OWNED BY public.additive.id;


--
-- Name: base; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base (
    id bigint NOT NULL,
    code text,
    vi_40 double precision,
    vi_100 double precision,
    qqsp_gr double precision,
    price double precision
);


ALTER TABLE public.base OWNER TO postgres;

--
-- Name: base_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.base_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_id_seq OWNER TO postgres;

--
-- Name: base_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.base_id_seq OWNED BY public.base.id;


--
-- Name: classify; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classify (
    substance_id bigint NOT NULL,
    ghs_id bigint NOT NULL,
    scl double precision
);


ALTER TABLE public.classify OWNER TO postgres;

--
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    id bigint NOT NULL,
    name text,
    email text,
    phone text,
    address text,
    zip integer,
    city text,
    country text
);


ALTER TABLE public.company OWNER TO postgres;

--
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_id_seq OWNER TO postgres;

--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;


--
-- Name: contains_additive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contains_additive (
    product_id bigint NOT NULL,
    additive_id bigint NOT NULL,
    quantity double precision
);


ALTER TABLE public.contains_additive OWNER TO postgres;

--
-- Name: contains_base; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contains_base (
    product_id bigint NOT NULL,
    base_id bigint NOT NULL,
    quantity double precision
);


ALTER TABLE public.contains_base OWNER TO postgres;

--
-- Name: contains_substance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contains_substance (
    additive_id bigint NOT NULL,
    substance_id bigint NOT NULL,
    quantity double precision
);


ALTER TABLE public.contains_substance OWNER TO postgres;

--
-- Name: ghs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ghs (
    id bigint NOT NULL,
    code text,
    hazard_statement text,
    hazard_class text,
    category text,
    pictogram_id text,
    signal_word text
);


ALTER TABLE public.ghs OWNER TO postgres;

--
-- Name: ghs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ghs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ghs_id_seq OWNER TO postgres;

--
-- Name: ghs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ghs_id_seq OWNED BY public.ghs.id;


--
-- Name: ghs_pic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ghs_pic (
    code text NOT NULL,
    pic bytea
);


ALTER TABLE public.ghs_pic OWNER TO postgres;

--
-- Name: has_pcode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.has_pcode (
    ghs_id bigint NOT NULL,
    p_code text NOT NULL
);


ALTER TABLE public.has_pcode OWNER TO postgres;

--
-- Name: msds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msds (
    msds_no bigint NOT NULL,
    product_id bigint NOT NULL,
    doc text,
    last_check_date date
);


ALTER TABLE public.msds OWNER TO postgres;

--
-- Name: msds_msds_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.msds_msds_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.msds_msds_no_seq OWNER TO postgres;

--
-- Name: msds_msds_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.msds_msds_no_seq OWNED BY public.msds.msds_no;


--
-- Name: p_statement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.p_statement (
    code text NOT NULL,
    message text
);


ALTER TABLE public.p_statement OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id bigint NOT NULL,
    name text,
    grade text,
    code text,
    category text,
    viscosity double precision,
    company_id bigint NOT NULL,
    comment text
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: substance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substance (
    id bigint NOT NULL,
    ec text,
    cas text,
    name text,
    reach text,
    un_number text,
    pbt boolean,
    last_mod_date date,
    last_check_date date,
    comment text
);


ALTER TABLE public.substance OWNER TO postgres;

--
-- Name: product_contains_substance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.product_contains_substance AS
 SELECT p.id AS product_id,
    p.name AS product,
    p.code AS product_code,
    a.id AS additive_id,
    a.name AS additive,
    ca.quantity AS additive_in_product,
    s.id AS substance_id,
    s.ec AS substance_ec,
    s.cas AS substance_cas,
    cs.quantity AS substance_in_additive,
    ((ca.quantity + cs.quantity) / (100)::double precision) AS substance_in_product
   FROM public.product p,
    public.additive a,
    public.substance s,
    public.contains_additive ca,
    public.contains_substance cs
  WHERE ((p.id = ca.product_id) AND (a.id = ca.additive_id) AND (a.id = cs.additive_id) AND (s.id = cs.substance_id))
  ORDER BY p.id;


ALTER TABLE public.product_contains_substance OWNER TO postgres;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO postgres;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: standard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standard (
    product_id bigint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.standard OWNER TO postgres;

--
-- Name: substance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.substance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.substance_id_seq OWNER TO postgres;

--
-- Name: substance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.substance_id_seq OWNED BY public.substance.id;


--
-- Name: additive id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additive ALTER COLUMN id SET DEFAULT nextval('public.additive_id_seq'::regclass);


--
-- Name: base id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base ALTER COLUMN id SET DEFAULT nextval('public.base_id_seq'::regclass);


--
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- Name: ghs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ghs ALTER COLUMN id SET DEFAULT nextval('public.ghs_id_seq'::regclass);


--
-- Name: msds msds_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msds ALTER COLUMN msds_no SET DEFAULT nextval('public.msds_msds_no_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: substance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substance ALTER COLUMN id SET DEFAULT nextval('public.substance_id_seq'::regclass);


--
-- Data for Name: additive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.additive (id, name, last_update_date, price, msds, comment) FROM stdin;
1	add1	2016-08-08 00:00:00	5.2	\N	\N
2	add2	2014-10-03 00:00:00	5.02	\N	\N
3	add3	2018-12-06 00:00:00	8.56	\N	\N
4	add4	2015-04-15 00:00:00	7.39	\N	\N
5	add5	2018-02-14 00:00:00	10.58	\N	\N
6	add6	2012-11-22 00:00:00	13.57	\N	\N
7	add7	2018-10-26 00:00:00	5.04	\N	\N
8	add8	2017-04-12 00:00:00	12.08	\N	\N
9	add9	2015-01-12 00:00:00	7.07	\N	\N
10	add10	2018-07-06 00:00:00	11.41	\N	\N
11	add11	2016-05-06 00:00:00	12.7	\N	\N
12	add12	2018-10-18 00:00:00	14.11	\N	\N
13	add13	2018-10-16 00:00:00	6.4	\N	\N
14	add14	2018-10-16 00:00:00	12.52	\N	\N
15	add15	2018-10-15 00:00:00	11.31	\N	\N
16	add16	2018-02-22 00:00:00	14.99	\N	\N
17	add17	2016-05-06 00:00:00	7.55	\N	\N
18	add18	2019-02-23 00:00:00	7.16	\N	\N
19	add19	2019-02-24 00:00:00	7.32	\N	\N
20	add20	2011-03-03 00:00:00	12.24	\N	\N
21	add21	2018-02-22 00:00:00	14.13	\N	\N
22	add22	2018-02-22 00:00:00	7.26	\N	\N
23	add23	2018-12-02 00:00:00	8.04	\N	\N
24	add24	2018-12-17 00:00:00	6.64	\N	\N
25	add25	2018-12-24 00:00:00	10.92	\N	\N
26	add26	2012-03-21 00:00:00	11.1	\N	\N
27	add27	2017-03-12 00:00:00	14.78	\N	\N
28	gjklii	2022-02-02 00:00:00	200	\N	\N
\.


--
-- Data for Name: base; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base (id, code, vi_40, vi_100, qqsp_gr, price) FROM stdin;
1	MOH SN-90	20.46	425.48	0.965	11.35
2	MOH SN-150	34.51	181.36	0.367	8.65
3	MOH SN-500	31.61	522.43	0.577	11.75
4	BRIGHT STOCK	29.01	446.86	0.484	5.27
\.


--
-- Data for Name: classify; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classify (substance_id, ghs_id, scl) FROM stdin;
26	70	\N
6	66	\N
3	71	\N
3	82	\N
29	66	\N
1	65	\N
42	66	\N
28	117	\N
18	117	\N
33	65	\N
3	112	\N
18	71	12.5
20	118	\N
28	53	\N
38	53	\N
29	72	\N
33	113	10
1	71	\N
23	113	10
17	118	\N
28	66	\N
36	119	\N
31	113	10
11	117	\N
38	71	50
11	71	3
15	118	\N
39	112	\N
40	70	\N
3	113	10
2	72	\N
17	71	\N
6	117	\N
29	117	\N
12	66	2
8	70	\N
24	65	\N
31	95	\N
35	75	\N
1	113	10
3	53	\N
22	66	6.25
4	104	\N
42	119	\N
32	113	10
35	116	\N
35	65	\N
17	65	\N
23	65	\N
41	70	\N
32	65	\N
7	71	50
10	113	\N
10	70	14.2
18	66	6.25
30	66	\N
19	66	2
1	112	\N
2	66	\N
33	53	\N
39	70	\N
3	65	\N
25	70	\N
5	118	\N
23	95	\N
33	116	10
33	55	\N
11	66	15
13	119	\N
41	66	\N
31	116	10
21	118	\N
3	116	10
3	55	\N
34	117	\N
1	53	\N
16	70	\N
2	77	\N
1	116	1
28	72	\N
15	70	46
23	71	\N
25	66	\N
32	116	1
27	118	\N
35	53	\N
22	117	\N
30	118	\N
25	118	\N
23	116	10
38	117	\N
10	116	\N
24	60	\N
35	59	\N
35	70	\N
30	71	\N
24	113	\N
5	66	\N
2	82	\N
36	93	\N
38	70	\N
6	71	10
37	117	\N
41	113	10
32	71	\N
41	117	1
27	70	\N
14	119	\N
33	82	\N
5	72	\N
24	116	10
31	65	\N
35	113	\N
9	119	\N
22	71	12.5
32	53	\N
42	104	\N
7	117	\N
30	113	1
33	112	\N
31	71	\N
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company (id, name, email, phone, address, zip, city, country) FROM stdin;
1	comp1	comp1@support.gr	1234567890	fjkdi	15124	Athens	Greece
2	comp2	comp2@info.gr	2345678901	finfd	14561	Athens	Greece
3	comp3	comp3@support.gr	3456789012	hfdu	45500	Ioannina	Greece
4	comp4	comp4@info.gr	4567890123	dfhks	57200	Thessaloniki	Greece
5	comp5	comp5@info.gr	5678901234	2sssx	56533	Thessaloniki	Greece
6	comp6	comp6@support.gr	6789012345	Street6, Apolonos	18541	Piraeus	Greece
\.


--
-- Data for Name: contains_additive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contains_additive (product_id, additive_id, quantity) FROM stdin;
29	13	28.76
2	2	8.83
16	23	22.22
36	4	12.44
18	7	21.85
7	24	21.96
29	25	10.42
29	26	25.28
14	26	13.13
35	25	11.31
23	20	6.17
26	3	6.71
6	18	7.66
2	23	5.32
31	4	14.63
26	13	20.38
40	8	16.22
11	7	11.42
26	19	27.49
38	15	11.61
2	3	12.67
38	11	17.92
27	19	18.72
12	13	22.55
17	20	24.31
3	27	12.11
39	5	26.89
13	22	10.98
25	8	22.68
12	20	15.87
26	9	14.81
37	13	19.66
3	6	14.89
4	7	12.23
30	6	10.91
28	23	25.4
21	8	13.12
16	18	15.39
34	2	6.55
15	24	9.6
14	1	7.72
30	2	14.45
16	3	5.95
24	8	27.51
38	1	20.75
19	17	21.04
27	20	14.85
39	3	26.14
7	6	11.18
32	2	27.16
33	15	12.32
39	17	27.88
27	26	22.65
31	24	25.52
1	8	14.71
34	25	19.53
9	17	13.04
22	24	11.21
10	18	16.76
24	25	5.56
4	9	7.87
29	4	20.3
24	2	19.31
5	13	21.65
3	9	21.98
13	10	5.64
17	25	25.88
40	12	27.3
30	25	26.37
40	15	20.46
40	3	21.7
22	1	19.6
16	25	13.98
3	21	24.12
8	19	12
25	18	13.91
32	23	28.3
12	27	16.42
3	7	9.74
1	24	28.6
34	24	7.64
31	23	21.38
8	2	10.22
1	5	11.29
15	6	24.39
27	5	11.88
20	25	18.65
3	22	20.15
40	6	5.01
1	20	24.56
\.


--
-- Data for Name: contains_base; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contains_base (product_id, base_id, quantity) FROM stdin;
20	3	24.28
24	4	13.23
2	2	36.92
25	4	12.15
27	2	14.35
40	2	11.94
37	4	22.09
35	4	25.97
36	1	27.82
13	4	38.59
16	2	17.89
29	4	38.75
2	1	15.01
21	3	28.28
10	1	33.92
37	2	7.15
17	4	29.86
27	3	37.01
14	2	5.17
2	4	31.32
27	1	16.67
30	3	37.56
18	2	7.09
9	1	10.71
11	1	19.65
36	3	16.37
22	4	26.38
40	4	30.69
17	3	30.09
6	2	16.33
28	1	28.7
38	2	11.59
26	2	24.64
10	4	10.55
8	3	34.78
11	3	13.43
23	3	39.31
31	4	19.94
14	1	26.17
34	2	37.22
15	3	23.48
22	2	19.36
30	2	32.35
14	4	39.5
3	3	10.98
1	2	17.6
20	4	8.14
5	3	35.79
2	3	14.26
18	1	13.68
24	1	19.13
26	3	10.32
29	1	13.66
35	1	8.18
13	1	9.67
17	2	37.34
25	2	21.19
9	3	13.48
28	4	34.05
19	2	11.95
33	3	23.14
31	3	39.14
7	1	7.96
22	1	30.01
8	4	24.94
35	2	24.43
10	3	20.4
31	1	22.12
7	3	17.49
39	1	12.72
25	1	31.95
9	4	5.09
32	4	11.73
28	2	25.64
4	1	20.04
15	4	14.38
32	3	23.12
5	4	36.17
39	2	35.3
36	4	23.85
23	2	7.71
19	1	16.6
13	3	14.88
16	4	39.18
37	3	6.83
1	3	24.71
38	4	24.54
11	2	17.46
24	2	10.16
18	4	13.41
10	2	9.68
33	1	32.89
40	3	16.95
34	4	6.08
29	3	23.19
25	3	25.74
12	2	8.47
24	3	22.8
5	1	26.28
\.


--
-- Data for Name: contains_substance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contains_substance (additive_id, substance_id, quantity) FROM stdin;
10	40	19.6842
27	11	11.2377
12	24	28.2048
3	6	29.2463
12	13	24.3582
23	33	27.7186
26	41	10.2385
17	35	32.3371
12	35	28.0535
9	17	8.7488
4	19	10.7
11	24	11.7
10	34	34.2311
21	10	20.4373
16	27	14.1565
22	42	8.0937
15	18	16.2371
21	21	23.2478
19	22	14.7388
5	32	19.9512
17	31	26.919
9	25	7.5564
14	14	22.5635
22	38	25.2886
12	14	29.3945
12	1	21.6517
6	6	33.043
20	24	24.2874
17	2	5.5545
7	34	25.8711
16	37	34.3318
26	28	8.7669
21	25	31.1958
9	39	16.342
27	17	10.2838
9	13	20.1889
8	22	11.2239
10	29	19.2654
13	7	15.5767
14	19	33.569
2	9	6.6079
16	38	12.4583
24	11	8.3943
18	39	14.9323
14	34	29.2034
24	30	15.4899
25	17	7.2592
8	39	8.1584
10	39	9.2025
5	41	9.858
19	11	20.344
8	3	6.1337
12	6	14.3201
23	18	19.5082
24	32	32.354
25	3	33.0096
7	29	31.6339
18	28	16.9711
11	29	13.825
16	1	6.6069
19	10	34.2767
14	8	30.0982
7	27	10.0587
24	19	12.149
23	12	34.4842
20	17	21.1967
2	34	6.1682
23	26	12.0816
27	5	24.7572
24	40	18.5031
24	33	12.1763
18	37	9.1932
17	8	26.6752
20	11	11.1411
15	36	22.5139
15	27	21.0782
18	25	13.2373
4	41	24.7129
11	22	9.9176
15	22	22.3301
17	29	31.0528
3	12	24.6264
8	1	21.9792
4	42	11.0997
25	8	32.2606
2	8	9.9087
19	23	31.2424
10	23	15.3435
17	34	16.0092
4	21	28.9723
1	12	26.7137
2	42	15.4582
16	40	17.737
28	11	45
\.


--
-- Data for Name: ghs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ghs (id, code, hazard_statement, hazard_class, category, pictogram_id, signal_word) FROM stdin;
1	H200	Unstable Explosive	Explosives	Unstable Explosive	GHS1	Danger
2	H201	Explosive; mass explosion hazard	Explosives	Div 1.1	GHS1	Danger
3	H202	Explosive; severe projection hazard	Explosives	Div 1.2	GHS1	Danger
4	H203	Explosive; fire, blast or projection hazard	Explosives	Div 1.3	GHS1	Danger
5	H204	Fire or projection hazard	Explosives	Div 1.4	GHS1	Warning
6	H205	May mass explode in fire	Explosives	Div 1.5	None	Danger
7	H206	Fire, blast or projection hazard; increased risk of explosion if desensitizing agent is reduced	Desensitized explosives	Category 1	GHS2	Danger
8	H207	Fire or projection hazard; increased risk of explosion if desensitizing agent is reduced	Desensitized explosives	Category 2	GHS2	Danger
9	H207	Fire or projection hazard; increased risk of explosion if desensitizing agent is reduced	Desensitized explosives	Category 3	GHS2	Warning
10	H208	Fire hazard; increased risk of explosion if desensitizing agent is reduced	Desensitized explosives	Category 4	GHS2	Warning
11	H220	Extremely flammable gas	Flammable gases	1A: Flammable gas, Pyrophoric gas, Chemically unstable gas A,B	GHS2	Danger
12	H221	Flammable gas	Flammable gases	1B	GHS2	Danger
13	H221	Flammable gas	Flammable gases	Category 2	None	Warning
14	H222	Extremely flammable aerosol	Aerosols	Category 1	GHS2	Danger
15	H223	Flammable aerosol	Aerosols	Category 2	GHS2	Warning
16	H224	Extremely flammable liquid and vapor	Flammable liquids	Category 1	GHS2	Danger
17	H225	Highly Flammable liquid and vapor	Flammable liquids	Category 2	GHS2	Danger
18	H226	Flammable liquid and vapor	Flammable liquids	Category 3	GHS2	Warning
19	H227	Combustible liquid	Flammable liquids	Category 4	None	Warning
20	H228	Flammable solid	Flammable solids	Category 1	GHS2	Danger
21	H228	Flammable solid	Flammable solids	Category 2	GHS2	Warning
22	H229	Pressurized container: may burst if heated	Aerosols	Category 1	GHS2	Danger
23	H229	Pressurized container: may burst if heated	Aerosols	Category 2	GHS2	Warning
24	H229	Pressurized container: may burst if heated	Aerosols	Category 3	None	Warning
25	H230	May react explosively even in the absence of air	Flammable gases	1A, Chemically unstable gas A	GHS2	None
26	H231	May react explosively even in the absence of air at elevated pressure and/or temperature	Flammable gases	1A, Chemically unstable gas B	GHS2	None
27	H232	May ignite spontaneously if exposed to air	Flammable gases	1A, Pyrophoric gas	GHS2	Danger
28	H240	Heating may cause an explosion	Self-reactive substances and mixtures; Organic peroxides	Type A	GHS1	Danger
29	H241	Heating may cause a fire or explosion	Self-reactive substances and mixtures; Organic peroxides	Type B	GHS1	Danger
30	H242	Heating may cause a fire	Self-reactive substances and mixtures; Organic peroxides	Type C	GHS2	Danger
31	H242	Heating may cause a fire	Self-reactive substances and mixtures; Organic peroxides	Type D	GHS2	Danger
32	H242	Heating may cause a fire	Self-reactive substances and mixtures; Organic peroxides	Type E	GHS2	Warning
33	H242	Heating may cause a fire	Self-reactive substances and mixtures; Organic peroxides	Type F	GHS2	Warning
34	H250	Catches fire spontaneously if exposed to air	Pyrophoric liquids; Pyrophoric solids	Category 1	GHS2	Danger
35	H251	Self-heating; may catch fire	Self-heating substances and mixtures	Category 1	GHS2	Danger
36	H252	Self-heating in large quantities; may catch fire	Self-heating substances and mixtures	Category 2	GHS2	Warning
37	H260	In contact with water releases flammable gases which may ignite spontaneously	Substances and mixtures which in contact with water, emit flammable gases	Category 1	GHS2	Danger
38	H261	In contact with water releases flammable gas	Substances and mixtures which in contact with water, emit flammable gases	Category 2	GHS2	Danger
39	H261	In contact with water releases flammable gas	Substances and mixtures which in contact with water, emit flammable gases	Category 3	GHS2	Warning
40	H270	May cause or intensify fire; oxidizer	Oxidizing gases	Category 1	GHS3	Danger
41	H271	May cause fire or explosion; strong Oxidizer	Oxidizing liquids; Oxidizing solids	Category 1	GHS3	Danger
42	H272	May intensify fire; oxidizer	Oxidizing liquids; Oxidizing solids	Category 2	GHS3	Danger
43	H272	May intensify fire; oxidizer	Oxidizing liquids; Oxidizing solids	Category 3	GHS3	Warning
44	H280	Contains gas under pressure; may explode if heated	Gases under pressure	Compressed gas, Liquefied gas, Dissolved gas	GHS4	Warning
45	H281	Contains refrigerated gas; may cause cryogenic burns or injury	Gases under pressure	Refrigerated liquefied gas	GHS4	Warning
46	H282	Extremely flammable chemical under pressure: may explode if heated	Chemicals under pressure	Category 1	GHS2,4	Danger
47	H283	Flammable chemical under pressure: may explode if heated	Chemicals under pressure	Category 2	GHS2,4	Warning
48	H284	Chemical under pressure: may explode if heated	Chemicals under pressure	Category 3	GHS4	Warning
49	H290	May be corrosive to metals	Corrosive to Metals	Category 1	GHS5	Warning
50	H300	Fatal if swallowed	Acute toxicity, oral	Category 1	GHS6	Danger
51	H300	Fatal if swallowed	Acute toxicity, oral	Category 2	GHS6	Danger
52	H301	Toxic if swallowed	Acute toxicity, oral	Category 3	GHS6	Danger
53	H302	Harmful if swallowed	Acute toxicity, oral	Category 4	GHS7	Warning
54	H303	May be harmful if swallowed	Acute toxicity, oral	Category 5	None	Warning
55	H304	May be fatal if swallowed and enters airways	Aspiration hazard	Category 1	GHS8	Danger
56	H305	May be fatal if swallowed and enters airways	Aspiration hazard	Category 2	GHS8	Warning
57	H310	Fatal in contact with skin	Acute toxicity, dermal	Category 1	GHS6	Danger
58	H310	Fatal in contact with skin	Acute toxicity, dermal	Category 2	GHS6	Danger
59	H311	Toxic in contact with skin	Acute toxicity, dermal	Category 3	GHS6	Danger
60	H312	Harmful in contact with skin	Acute toxicity, dermal	Category 4	GHS7	Warning
61	H313	May be harmful in contact with skin	Acute toxicity, dermal	Category 5	None	None
62	H314	Causes severe skin burns and eye damage	Skin corrosion/irritation	Category 1	GHS5	Danger
63	H314	Causes severe skin burns and eye damage	Skin corrosion/irritation	Category 1A	GHS7	Danger
64	H314	Causes severe skin burns and eye damage	Skin corrosion/irritation	Category 1B	GHS7	Danger
65	H314	Causes severe skin burns and eye damage	Skin corrosion/irritation	Category 1C	GHS7	Danger
66	H315	Causes skin irritation	Skin corrosion/irritation	Category 2	GHS7	Warning
67	H316	Causes mild skin irritation	Skin corrosion/irritation	Category 3	None	Warning
68	H317	May cause an allergic skin reaction	Sensitization, Skin	Category 1	GHS7	Warning
69	H317	May cause an allergic skin reaction	Sensitization, Skin	Category 1A	GHS5	Warning
70	H317	May cause an allergic skin reaction	Sensitization, Skin	Category 1B	GHS5	Warning
71	H318	Causes serious eye damage	Serious eye damage/eye irritation	Category 1	GHS5	Danger
72	H319	Causes serious eye irritation	Serious eye damage/eye irritation	Category 2A	GHS7	Warning
73	H320	Causes eye irritation	Serious eye damage/eye irritation	Category 2B	None	Warning
74	H330	Fatal if inhaled	Acute toxicity, inhalation	Category 1	GHS6	Danger
75	H330	Fatal if inhaled	Acute toxicity, inhalation	Category 2	GHS6	Danger
76	H331	Toxic if inhaled	Acute toxicity, inhalation	Category 3	GHS6	Danger
77	H332	Harmful if inhaled	Acute toxicity, inhalation	Category 4	GHS7	Warning
78	H333	May be harmful if inhaled	Acute toxicity, inhalation	Category 5	None	Warning
79	H334	May cause allergy or asthma symptoms or breathing difficulties if inhaled	Sensitization, respiratory	Category 1	GHS8	Danger
80	H334	May cause allergy or asthma symptoms or breathing difficulties if inhaled	Sensitization, respiratory	Category 1A	GHS7	Danger
81	H334	May cause allergy or asthma symptoms or breathing difficulties if inhaled	Sensitization, respiratory	Category 1B	GHS7	Danger
82	H335	May cause respiratory irritation	Specific target organ toxicity, single exposure; Respiratory tract irritation	Category 3	GHS7	Warning
83	H336	May cause drowsiness or dizziness	Specific target organ toxicity, single exposure; Narcotic effects	Category 3	GHS7	Warning
84	H340	May cause genetic defects	Germ cell mutagenicity	Category 1A	GHS8	Danger
85	H340	May cause genetic defects	Germ cell mutagenicity	Category 1B	GHS8	Danger
86	H341	Suspected of causing genetic defects	Germ cell mutagenicity	Category 2	GHS8	Warning
87	H350	May cause cancer	Carcinogenicity	Category 1A	GHS8	Danger
88	H350	May cause cancer	Carcinogenicity	Category 1B	GHS8	Danger
89	H350i	May cause cancer by inhalation	Carcinogenicity	Category 1A	GHS8	Danger
90	H350i	May cause cancer by inhalation	Carcinogenicity	Category 1B	GHS8	Danger
91	H351	Suspected of causing cancer	Carcinogenicity	Category 2	GHS8	Warning
92	H360	May damage fertility or the unborn child	Reproductive toxicity	Category 1A	GHS8	Danger
93	H360	May damage fertility or the unborn child	Reproductive toxicity	Category 1B	GHS8	Danger
94	H360F	May damage fertility	Reproductive toxicity	Category 1A	GHS8	Danger
95	H360F	May damage fertility	Reproductive toxicity	Category 1B	GHS8	Danger
96	H360D	May damage the unborn child	Reproductive toxicity	Category 1A	GHS8	Danger
97	H360D	May damage the unborn child	Reproductive toxicity	Category 1B	GHS8	Danger
98	H360FD	May damage fertility; May damage the unborn child	Reproductive toxicity	Category 1A	GHS8	Danger
99	H360FD	May damage fertility; May damage the unborn child	Reproductive toxicity	Category 1B	GHS8	Danger
100	H360Fd	May damage fertility; Suspected of damaging the unborn child	Reproductive toxicity	Category 1A	GHS8	Danger
101	H360Fd	May damage fertility; Suspected of damaging the unborn child	Reproductive toxicity	Category 1B	GHS	Danger
102	H360Df	May damage the unborn child; Suspected of damaging fertility	Reproductive toxicity	Category 1A	GHS8	Danger
103	H360Df	May damage the unborn child; Suspected of damaging fertility	Reproductive toxicity	Category 1B	GHS8	Danger
104	H361	Suspected of damaging fertility or the unborn child	Reproductive toxicity	Category 2	GHS8	Warning
105	H361f	Suspected of damaging fertility	Reproductive toxicity	Category 2	GHS8	Warning
106	H361d	Suspected of damaging the unborn child	Reproductive toxicity	Category 2	GHS8	Warning
107	H361fd	Suspected of damaging fertility; Suspected of damaging the unborn child	Reproductive toxicity	Category 2	GHS8	Warning
108	H362	May cause harm to breast-fed children	Reproductive toxicity, effects on or via lactation	Additional category	None	P201, P260, P263, P264, P270
109	H370	Causes damage to organs	Specific target organ toxicity, single exposure	Category 1	GHS8	Danger
110	H371	May cause damage to organs	Specific target organ toxicity, single exposure	Category 2	GHS8	Warning
111	H372	Causes damage to organs through prolonged or repeated exposure	Specific target organ toxicity, repeated exposure	Category 1	GHS8	Danger
112	H373	Causes damage to organs through prolonged or repeated exposure	Specific target organ toxicity, repeated exposure	Category 2	GHS8	Warning
113	H400	Very toxic to aquatic life	Hazardous to the aquatic environment, acute hazard	Category 1	GHS9	Warning
114	H401	Toxic to aquatic life	Hazardous to the aquatic environment, acute hazard	Category 2	None	P273
115	H402	Harmful to aquatic life	Hazardous to the aquatic environment, acute hazard	Category 3	None	P273
116	H410	Very toxic to aquatic life with long lasting effects	Hazardous to the aquatic environment, long-term hazard	Category 1	GHS9	Warning
117	H411	Toxic to aquatic life with long lasting effects	Hazardous to the aquatic environment, long-term hazard	Category 2	GHS9	P273
118	H412	Harmful to aquatic life with long lasting effects	Hazardous to the aquatic environment, long-term hazard	Category 3	None	P273
119	H413	May cause long lasting harmful effects to aquatic life	Hazardous to the aquatic environment, long-term hazard	Category 4	None	P273
120	H420	Harms public health and the environment by destroying ozone in the upper atmosphere	Hazardous to the ozone layer	Category 1	GHS7	Warning
121	H300+H310	Fatal if swallowed or in contact with skin	Acute toxicity, oral; acute toxicity, dermal	Category 1, 2	GHS6	Danger
122	H300+H330	Fatal if swallowed or if inhaled	Acute toxicity, oral; acute toxicity, inhalation	Category 1, 2	GHS6	Danger
123	H310+H330	Fatal in contact with skin or if inhaled	Acute toxicity, dermal; acute toxicity, inhalation	Category 1, 2	GHS6	Danger
124	H300+H310+H330	Fatal if swallowed, in contact with skin or if inhaled	Acute toxicity, oral; acute toxicity, dermal; acute toxicity, inhalation	Category 1, 2	GHS6	Danger
125	H301+H311	Toxic if swallowed or in contact with skin	Acute toxicity, oral; acute toxicity, dermal	Category 3	GHS6	Danger
126	H301+H331	Toxic if swallowed or if inhaled	Acute toxicity, oral; acute toxicity, inhalation	Category 3	GHS6	Danger
127	H311+H331	Toxic in contact with skin or if inhaled.	Acute toxicity, dermal; acute toxicity, inhalation	Category 3	GHS6	Danger
128	H301+H311+H331	Toxic if swallowed, in contact with skin or if inhaled	Acute toxicity, oral; acute toxicity, dermal; acute toxicity, inhalation	Category 3	GHS6	Danger
129	H302+H312	Harmful if swallowed or in contact with skin	Acute toxicity, oral; acute toxicity, dermal	Category 4	GHS7	Warning
130	H302+H332	Harmful if swallowed or if inhaled	Acute toxicity, oral; acute toxicity, inhalation	Category 4	GHS7	Warning
131	H312+H332	Harmful in contact with skin or if inhaled	Acute toxicity, dermal; acute toxicity, inhalation	Category 4	GHS7	Warning
132	H302+H312+H332	Harmful if swallowed, in contact with skin or if inhaled	Acute toxicity, oral; acute toxicity, dermal; acute toxicity, inhalation	Category 4	GHS7	Warning
133	H303+H313	May be harmful if swallowed or in contact with skin	Acute toxicity, oral; acute toxicity, dermal	Category 5	None	Warning
134	H303+H333	May be harmful if swallowed or if inhaled	Acute toxicity, oral; acute toxicity, inhalation	Category 5	None	Warning
135	H313+H333	May be harmful in contact with skin or if inhaled	Acute toxicity, dermal; acute toxicity, inhalation	Category 5	None	Warning
136	H303+H313+H333	May be harmful if swallowed, in contact with skin or if inhaled	Acute toxicity, oral; acute toxicity, dermal; acute toxicity, inhalation	Category 5	None	Warning
137	H315+H320	Cause skin and eye irritation	Skin corrosion/irritation and serious eye damage/eye irritation	Category 2, 2B	GHS7	Warning
\.


--
-- Data for Name: ghs_pic; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ghs_pic (code, pic) FROM stdin;
\.


--
-- Data for Name: has_pcode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.has_pcode (ghs_id, p_code) FROM stdin;
62	P301+P330+P331
65	P405
76	P405
126	P330
127	P321
128	P261
42	P221
57	P302+P350
5	P210
127	P322
129	P270
9	P280
15	P211
128	P403+P233
65	P304+P340
7	P401
69	P302+P352
39	P231+P232
76	P304+P340
83	P501
94	P501
3	P250
122	P501
93	P281
79	P261
39	P280
75	P271
46	P410+P403
60	P312
69	P321
137	P302+P352
43	P221
1	P372
45	P403
127	P363
30	P220
56	P501
36	P413
51	P301+P310
84	P405
75	P260
95	P405
106	P405
122	P310
1	P373
13	P210
24	P210
128	P312
130	P304+P312
17	P240
53	P270
113	P501
4	P370+P380
71	P305+P351+P338
7	P501
18	P501
49	P404
30	P234
85	P202
129	P301+P312
56	P331
80	P304+P341
58	P280
69	P280
65	P260
121	P270
132	P270
81	P285
75	P501
125	P405
124	P271
135	P271
137	P280
85	P281
82	P261
20	P280
31	P280
17	P370+P378
28	P370+P378
50	P321
82	P403+P233
104	P202
37	P501
93	P308+P313
31	P403+P235
49	P234
53	P301+P312
16	P210
81	P342+P311
59	P363
70	P363
51	P321
91	P201
102	P201
9	P401
132	P301+P312
104	P281
65	P310
15	P251
30	P420
82	P312
124	P501
65	P301+P330+P331
131	P261
127	P271
121	P501
36	P407
86	P501
10	P401
97	P501
6	P250
16	P303+P361+P353
85	P308+P313
51	P264
78	P271
27	P222
59	P405
129	P302+P352
136	P304+P340
98	P405
58	P361
94	P201
131	P312
47	P381
20	P240
57	P310
42	P280
31	P234
105	P501
116	P501
122	P301+P310
127	P501
9	P230
10	P501
104	P308+P313
72	P280
4	P373
124	P270
30	P411
4	P280
123	P403+P233
41	P220
37	P335+P334
2	P401
89	P501
128	P405
16	P233
76	P311
129	P280
10	P230
46	P210
20	P241
20	P370+P378
64	P321
128	P304+P340
132	P302+P352
40	P403
74	P403+P233
96	P202
29	P501
12	P377
90	P405
101	P405
107	P202
129	P330
1	P202
111	P264
8	P210
19	P210
30	P210
48	P376
17	P242
62	P363
113	P273
2	P501
96	P281
107	P281
62	P264
73	P264
64	P280
1	P281
33	P220
59	P501
70	P501
109	P405
122	P321
53	P330
130	P264
121	P280
132	P280
44	P410+P403
88	P202
99	P202
121	P330
33	P234
132	P330
134	P261
10	P371+P380+P375
11	P210
62	P405
23	P410+P412
51	P501
82	P304+P340
74	P284
86	P201
97	P201
4	P401
136	P304+P312
88	P281
99	P281
34	P280
119	P501
42	P370+P378
96	P308+P313
107	P308+P313
126	P261
92	P405
134	P312
18	P280
7	P280
126	P403+P233
81	P501
5	P401
8	P233
125	P301+P310
75	P320
32	P370+P378
43	P370+P378
18	P403+P235
65	P321
50	P270
76	P321
69	P272
77	P261
105	P201
123	P302+P350
33	P420
57	P262
131	P304+P340
32	P501
43	P501
93	P405
63	P304+P340
62	P260
70	P333+P313
37	P231+P232
8	P370+P380+P375
130	P271
22	P210
89	P201
37	P280
51	P270
100	P501
111	P501
2	P370+P380
4	P230
65	P363
5	P501
116	P273
55	P405
121	P361
88	P308+P313
99	P308+P313
65	P264
8	P212
117	P391
77	P312
124	P320
137	P305+P351+P338
62	P501
123	P405
122	P271
124	P280
41	P210
69	P261
80	P261
137	P337+P313
16	P243
71	P310
124	P284
47	P410+P403
57	P322
66	P362
123	P304+P340
13	P403
127	P302+P352
130	P501
91	P202
102	P202
74	P405
85	P405
124	P330
128	P311
3	P210
14	P210
125	P322
12	P381
18	P240
25	P202
15	P410+P412
24	P211
33	P411
74	P304+P340
92	P501
57	P363
68	P363
22	P251
91	P281
102	P281
57	P264
34	P370+P378
111	P270
41	P221
125	P363
28	P220
104	P405
26	P202
125	P264
127	P280
33	P210
112	P260
123	P260
10	P280
63	P310
18	P370+P378
49	P390
128	P301+P310
94	P202
16	P501
63	P301+P330+P331
28	P234
76	P271
57	P405
36	P420
130	P270
126	P264
79	P285
59	P302+P352
70	P302+P352
4	P250
131	P304+P312
94	P281
29	P280
38	P402+P404
37	P370+P378
40	P244
61	P312
5	P370+P380
7	P230
70	P321
72	P305+P351+P338
103	P501
114	P501
17	P241
91	P308+P313
52	P301+P310
29	P403+P235
59	P322
102	P308+P313
124	P361
123	P310
72	P337+P313
2	P373
79	P342+P311
87	P405
122	P270
2	P280
65	P501
76	P501
126	P405
39	P402+P404
100	P201
130	P301+P312
74	P310
63	P305+P351+P338
59	P280
60	P322
70	P280
24	P251
28	P420
126	P304+P340
134	P304+P340
63	P303+P361+P353
128	P321
58	P302+P350
6	P210
128	P322
137	P362
21	P280
50	P330
77	P304+P340
8	P401
84	P501
95	P501
60	P363
106	P501
64	P305+P351+P338
127	P361
46	P370+P378
94	P308+P313
64	P303+P361+P353
66	P332+P313
128	P363
31	P220
57	P501
68	P501
96	P405
107	P405
51	P330
128	P264
47	P210
92	P201
129	P312
46	P211
125	P501
86	P202
8	P501
19	P501
30	P501
58	P405
97	P202
81	P304+P341
132	P261
4	P372
2	P240
28	P411
18	P242
87	P501
136	P271
86	P281
83	P261
52	P264
97	P281
32	P280
43	P280
29	P370+P378
62	P321
35	P235+P410
5	P372
83	P403+P233
45	P336
38	P501
105	P202
55	P301+P310
32	P403+P235
99	P405
59	P361
109	P264
5	P373
17	P210
28	P210
46	P376
132	P312
5	P280
21	P240
18	P303+P361+P353
134	P304+P312
57	P270
11	P403
89	P202
131	P302+P352
103	P201
105	P281
62	P280
52	P405
31	P420
83	P312
125	P270
42	P220
68	P333+P313
128	P271
131	P322
89	P281
123	P262
35	P280
98	P501
21	P370+P378
111	P314
2	P230
17	P303+P361+P353
86	P308+P313
97	P308+P313
130	P330
77	P304+P312
9	P210
82	P405
122	P320
131	P363
60	P501
110	P405
63	P363
4	P240
37	P223
84	P201
95	P201
106	P201
137	P332+P313
58	P310
63	P264
122	P284
32	P234
117	P501
128	P501
122	P330
126	P311
105	P308+P313
135	P261
123	P322
5	P240
31	P411
16	P280
22	P211
124	P403+P233
38	P335+P334
3	P401
79	P501
90	P501
17	P233
101	P501
109	P260
41	P370+P378
89	P308+P313
16	P403+P235
121	P302+P350
82	P271
63	P405
123	P363
41	P501
13	P377
52	P501
91	P405
102	P405
123	P264
28	P370+P380+P375
75	P284
20	P210
5	P374
31	P210
87	P201
110	P260
135	P312
109	P501
126	P301+P310
3	P501
40	P370+P376
64	P405
108	P308+P313
127	P261
65	P280
45	P315
128	P270
14	P211
120	P502
127	P403+P233
64	P304+P340
68	P302+P352
82	P501
121	P405
9	P233
131	P271
2	P250
78	P261
68	P321
125	P302+P352
132	P304+P340
100	P202
33	P501
35	P413
83	P405
94	P405
63	P260
9	P370+P380+P375
12	P210
23	P210
127	P312
125	P321
16	P240
24	P410+P412
52	P270
83	P304+P340
122	P304+P340
98	P201
100	P281
66	P264
9	P212
57	P280
68	P280
131	P501
78	P312
109	P270
80	P285
63	P501
126	P321
123	P271
125	P280
41	P371+P380+P375
42	P210
70	P261
8	P280
19	P280
30	P280
93	P501
6	P401
16	P370+P378
92	P202
18	P241
125	P330
19	P403+P235
30	P403+P235
124	P302+P350
74	P271
80	P342+P311
4	P210
58	P262
29	P370+P380+P375
55	P501
75	P304+P340
74	P260
38	P231+P232
90	P201
101	P201
92	P281
64	P310
38	P280
14	P251
59	P312
112	P501
123	P501
3	P370+P380
6	P501
64	P301+P330+P331
100	P308+P313
50	P301+P310
55	P331
2	P372
121	P310
35	P407
60	P302+P352
74	P501
85	P501
124	P405
5	P250
47	P370+P378
6	P230
81	P261
17	P243
48	P410+P403
58	P322
124	P304+P340
128	P302+P352
135	P304+P340
103	P202
86	P405
97	P405
137	P321
57	P361
134	P271
15	P210
132	P304+P312
13	P381
47	P211
104	P501
115	P501
58	P363
69	P363
62	P305+P351+P338
73	P305+P351+P338
125	P361
92	P308+P313
103	P281
58	P264
60	P280
34	P222
62	P303+P361+P353
73	P337+P313
123	P270
29	P220
40	P220
105	P405
127	P405
126	P271
137	P264
128	P280
34	P210
124	P260
75	P310
19	P370+P378
30	P370+P378
52	P321
127	P304+P340
84	P202
17	P501
11	P377
28	P501
29	P234
89	P405
95	P202
106	P202
128	P330
79	P304+P341
77	P271
130	P261
7	P210
18	P210
47	P376
109	P321
16	P242
78	P304+P340
93	P201
84	P281
95	P281
50	P264
106	P281
41	P280
113	P391
126	P501
38	P370+P378
6	P370+P380
8	P230
3	P372
41	P306+P360
103	P308+P313
52	P330
124	P310
3	P373
88	P405
130	P312
3	P280
122	P403+P233
1	P401
121	P301+P310
87	P202
9	P501
39	P370+P378
71	P280
50	P405
29	P420
39	P501
110	P264
85	P201
129	P322
135	P304+P312
87	P281
121	P262
33	P280
96	P501
54	P312
63	P321
107	P501
118	P501
65	P305+P351+P338
1	P501
51	P405
21	P241
84	P308+P313
56	P301+P310
33	P403+P235
95	P308+P313
106	P308+P313
34	P302+P334
72	P264
128	P361
75	P403+P233
65	P303+P361+P353
67	P332+P313
126	P270
129	P363
32	P220
43	P220
58	P501
69	P501
80	P501
7	P233
18	P233
129	P264
31	P370+P378
131	P280
48	P210
104	P201
76	P261
68	P272
46	P381
63	P280
76	P403+P233
98	P202
31	P501
121	P321
7	P370+P380+P375
10	P210
121	P322
132	P322
3	P240
29	P411
22	P410+P412
88	P501
99	P501
34	P422
64	P363
87	P308+P313
98	P281
53	P264
7	P212
64	P264
116	P391
78	P304+P312
109	P307+P311
36	P235+P410
6	P372
121	P363
123	P320
132	P363
50	P501
100	P405
132	P501
121	P264
132	P264
123	P280
6	P373
29	P210
68	P261
133	P312
6	P280
123	P284
58	P270
12	P403
124	P301+P310
45	P282
74	P320
90	P202
101	P202
127	P311
1	P380
2	P210
32	P420
11	P381
122	P264
14	P410+P412
23	P211
62	P304+P340
66	P302+P352
69	P333+P313
90	P281
101	P281
124	P262
36	P280
110	P501
33	P370+P378
66	P321
110	P309+P311
3	P230
112	P314
130	P304+P340
70	P272
42	P501
98	P308+P313
21	P210
111	P260
125	P312
122	P405
10	P233
4	P501
38	P223
96	P201
107	P201
1	P201
66	P280
56	P405
35	P420
129	P501
64	P260
124	P321
136	P261
132	P271
124	P322
6	P240
32	P411
17	P280
28	P280
37	P402+P404
91	P501
102	P501
123	P361
16	P241
90	P308+P313
101	P308+P313
17	P403+P235
28	P403+P235
10	P212
83	P271
75	P405
110	P270
124	P363
53	P501
64	P501
103	P405
41	P283
124	P264
32	P210
43	P210
88	P201
99	P201
122	P260
18	P243
62	P310
136	P312
23	P251
93	P202
\.


--
-- Data for Name: msds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msds (msds_no, product_id, doc, last_check_date) FROM stdin;
1	2	msds_docs\\msds1.docx	2013-03-14
2	26	msds_docs\\msds2.docx	2015-11-13
3	2	msds_docs\\msds3.docx	2015-07-22
4	15	msds_docs\\msds4.docx	2014-09-04
5	1	msds_docs\\msds5.docx	2016-10-08
6	6	msds_docs\\msds6.docx	2013-07-06
7	38	msds_docs\\msds7.docx	2019-04-26
8	31	msds_docs\\msds8.docx	2020-10-23
9	9	msds_docs\\msds9.docx	2018-04-16
10	16	msds_docs\\msds10.docx	2017-05-10
11	18	msds_docs\\msds11.docx	2016-02-19
12	13	msds_docs\\msds12.docx	2017-10-05
13	15	msds_docs\\msds13.docx	2013-05-14
14	25	msds_docs\\msds14.docx	2018-05-06
15	40	msds_docs\\msds15.docx	2016-02-05
16	11	msds_docs\\msds16.docx	2021-05-10
17	9	msds_docs\\msds17.docx	2013-09-06
18	36	msds_docs\\msds18.docx	2020-05-06
19	30	msds_docs\\msds19.docx	2017-04-16
20	21	msds_docs\\msds20.docx	2015-04-09
21	2	msds_docs\\msds21.docx	2019-08-02
22	32	msds_docs\\msds22.docx	2014-10-09
23	4	msds_docs\\msds23.docx	2019-04-13
24	10	msds_docs\\msds24.docx	2021-06-23
25	15	msds_docs\\msds25.docx	2020-05-15
26	28	msds_docs\\msds26.docx	2016-04-03
27	3	msds_docs\\msds27.docx	2019-09-14
28	26	msds_docs\\msds28.docx	2017-05-27
29	27	msds_docs\\msds29.docx	2013-11-19
30	13	msds_docs\\msds30.docx	2016-01-15
31	3	msds_docs\\msds31.docx	2013-02-03
32	12	msds_docs\\msds32.docx	2013-07-09
33	35	msds_docs\\msds33.docx	2017-08-01
34	2	msds_docs\\msds34.docx	2016-07-19
35	12	msds_docs\\msds35.docx	2015-07-11
36	24	msds_docs\\msds36.docx	2018-03-01
37	33	msds_docs\\msds37.docx	2018-01-18
38	36	msds_docs\\msds38.docx	2014-07-23
39	38	msds_docs\\msds39.docx	2015-07-02
40	16	msds_docs\\msds40.docx	2021-03-22
41	20	msds_docs\\msds41.docx	2015-10-23
42	20	msds_docs\\msds42.docx	2016-09-23
43	4	msds_docs\\msds43.docx	2020-01-09
44	4	msds_docs\\msds44.docx	2014-03-08
45	31	msds_docs\\msds45.docx	2013-11-11
46	29	msds_docs\\msds46.docx	2014-06-08
47	19	msds_docs\\msds47.docx	2014-02-18
48	6	msds_docs\\msds48.docx	2018-09-16
49	24	msds_docs\\msds49.docx	2021-03-02
50	40	msds_docs\\msds50.docx	2015-08-26
51	3	msds_docs\\msds51.docx	2021-02-08
52	12	msds_docs\\msds52.docx	2018-10-24
53	33	msds_docs\\msds53.docx	2014-04-15
54	35	msds_docs\\msds54.docx	2015-07-03
55	15	msds_docs\\msds55.docx	2017-07-25
56	28	msds_docs\\msds56.docx	2014-10-27
57	14	msds_docs\\msds57.docx	2015-01-06
58	15	msds_docs\\msds58.docx	2018-09-19
59	20	msds_docs\\msds59.docx	2020-03-11
60	24	msds_docs\\msds60.docx	2017-03-14
61	35	msds_docs\\msds61.docx	2016-10-15
62	12	msds_docs\\msds62.docx	2019-05-15
63	24	msds_docs\\msds63.docx	2018-11-04
64	26	msds_docs\\msds64.docx	2014-06-17
65	13	msds_docs\\msds65.docx	2021-07-18
66	1	msds_docs\\msds66.docx	2017-03-26
67	2	msds_docs\\msds67.docx	2014-04-19
68	29	msds_docs\\msds68.docx	2014-11-13
69	20	msds_docs\\msds69.docx	2021-04-16
70	23	msds_docs\\msds70.docx	2019-11-11
71	34	msds_docs\\msds71.docx	2015-02-25
72	10	msds_docs\\msds72.docx	2021-05-02
73	30	msds_docs\\msds73.docx	2020-03-07
74	26	msds_docs\\msds74.docx	2015-07-17
75	8	msds_docs\\msds75.docx	2017-06-03
76	17	msds_docs\\msds76.docx	2015-08-23
77	25	msds_docs\\msds77.docx	2014-11-11
78	22	msds_docs\\msds78.docx	2019-01-18
79	30	msds_docs\\msds79.docx	2015-11-03
80	4	msds_docs\\msds80.docx	2017-02-15
81	7	msds_docs\\msds81.docx	2015-06-23
82	15	msds_docs\\msds82.docx	2015-05-09
83	33	msds_docs\\msds83.docx	2017-02-17
84	40	msds_docs\\msds84.docx	2017-11-16
85	29	msds_docs\\msds85.docx	2015-08-22
86	23	msds_docs\\msds86.docx	2017-07-15
87	7	msds_docs\\msds87.docx	2021-08-04
88	26	msds_docs\\msds88.docx	2021-06-11
89	29	msds_docs\\msds89.docx	2014-01-27
90	38	msds_docs\\msds90.docx	2019-01-06
91	13	msds_docs\\msds91.docx	2018-03-06
92	24	msds_docs\\msds92.docx	2021-01-05
93	15	msds_docs\\msds93.docx	2013-06-15
94	20	msds_docs\\msds94.docx	2014-07-16
95	22	msds_docs\\msds95.docx	2021-07-20
96	1	msds_docs\\msds96.docx	2014-07-14
97	39	msds_docs\\msds97.docx	2014-04-11
98	5	msds_docs\\msds98.docx	2017-06-16
99	30	msds_docs\\msds99.docx	2017-01-17
100	21	msds_docs\\msds100.docx	2014-01-06
101	41	\N	2023-02-03
102	42	\N	2023-02-03
103	43	\N	2023-02-03
104	44	C:/Users/Aspa/Dropbox/python/msds_manager/app/msds_docs/msd3.docx	2023-02-03
\.


--
-- Data for Name: p_statement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.p_statement (code, message) FROM stdin;
P381	In case of leakage, eliminate all ignition sources.
P309+P311	IF exposed or if you feel unwell: call a POISON CENTER or doctor/physician.
P337+P313	IF eye irritation persists: Get medical advice/attention.
P361	Take off immediately all contaminated clothing.
P412	Do not expose to temperatures exceeding 50 Β°C/ 122 Β°F.
P334	Immerse in cool water [or wrap in wet bandages].
P305	IF IN EYES:
P281	Use personal protective equipment as required.
P311	Call a POISON CENTER or doctor/...
P372	Explosion risk.
P235	Keep cool.
P422	Store contents under ...
P302+P352	IF ON SKIN: wash with plenty of water.
P308+P313	IF exposed or concerned: Get medical advice/attention.
P390	Absorb spillage to prevent material damage.
P272	Contaminated work clothing should not be allowed out of the workplace.
P230	Keep wetted with ...
P301+P312	IF SWALLOWED: call a POISON CENTER/doctor/... IF you feel unwell.
P308+P311	IF exposed or concerned: Call a POISON CENTER/doctor/...
P271	Use only outdoors or in a well-ventilated area.
P335	Brush off loose particles from skin.
P222	Do not allow contact with air.
P221	Take any precaution to avoid mixing with combustibles/...
P284	[In case of inadequate ventilation] Wear respiratory protection.
P377	Leaking gas fire: Do not extinguish, unless leak can be stopped safely.
P406	Store in corrosive resistant/... container with a resistant inner liner.
P280	Wear protective gloves/protective clothing/eye protection/face protection.
P502	Refer to manufacturer or supplier for information on recovery or recycling
P410+P403	Protect from sunlight. Store in a well-ventilated place.
P336	Thaw frosted parts with lukewarm water. Do not rub affected area.
P321	Specific treatment (see ... on this label).
P220	Keep away from clothing and other combustible materials.
P420	Store separately.
P402	Store in a dry place.
P332+P313	IF SKIN irritation occurs: Get medical advice/attention.
P361+P364	Take off immediately all contaminated clothing and wash it before reuse.
P283	Wear fire resistant or flame retardant clothing.
P313	Get medical advice/attention.
P380	Evacuate area.
P260	Do not breathe dust/fume/gas/mist/vapors/spray.
P410	Protect from sunlight.
P330	Rinse mouth.
P242	Use only non-sparking tools.
P342+P311	IF experiencing respiratory symptoms: Call a POISON CENTER/doctor/...
P250	Do not subject to grinding/shock/friction/...
P282	Wear cold insulating gloves/face shield/eye protection.
P333	If skin irritation or rash occurs:
P232	Protect from moisture.
P331	Do NOT induce vomiting.
P364	And wash it before reuse.[Added in 2015 version]
P322	Specific measures (see ...on this label).
P304+P312	IF INHALED: Call a POISON CENTER/doctor/... if you feel unwell.
P371	In case of major fire and large quantities:
P410+P412	Protect from sunlight. Do not expose to temperatures exceeding 50 Β°C/122Β°F.
P403+P235	Store in a well-ventilated place. Keep cool.
P401	Store in accordance with ...
P251	Do not pierce or burn, even after use.
P303	IF ON SKIN (or hair):
P240	Ground/bond container and receiving equipment.
P306+P360	IF ON CLOTHING: Rinse Immediately contaminated CLOTHING and SKIN with plenty of water before removing clothes.
P304+P341	IF INHALED: If breathing is difficult, remove victim to fresh air and keep at rest in a position comfortable for breathing.
P101	If medical advice is needed, have product container or label at hand.
P370	In case of fire:
P262	Do not get in eyes, on skin, or on clothing.
P302+P334	IF ON SKIN: Immerse in cool water [or wrap in wet bandages].
P223	Do not allow contact with water.
P362+P364	Take off contaminated clothing and wash it before reuse.
P202	Do not handle until all safety precautions have been read and understood.
P233	Keep container tightly closed.
P312	Call a POISON CENTER or doctor/... if you feel unwell.
P301+P330+P331	IF SWALLOWED: Rinse mouth. Do NOT induce vomiting.
P360	Rinse immediately contaminated clothing and skin with plenty of water before removing clothes.
P404	Store in a closed container.
P244	Keep valves and fittings free from oil and grease.
P315	Get immediate medical advice/attention.
P231	Handle under inert gas.
P306	IF ON CLOTHING:
P303+P361+P353	IF ON SKIN (or hair): Take off Immediately all contaminated clothing. Rinse SKIN with water [or shower].
P307	IF exposed:
P376	Stop leak if safe to do so.
P362	Take off contaminated clothing.
P391	Collect spillage.
P210	Keep away from heat, hot surface, sparks, open flames and other ignition sources. - No smoking.
P353	Rinse skin with water [or shower].
P302+P335+P334	Brush off loose particles from skin. Immerse in cool water [or wrap in wet bandages].
P335+P334	Brush off loose particles from skin. Immerse in cool water/wrap in wet bandages.
P363	Wash contaminated clothing before reuse.
P370+P380	In case of fire: Evacuate area.
P403+P233	Store in a well-ventilated place. Keep container tightly closed.
P341	If breathing is difficult, remove victim to fresh air and keep at rest in a position comfortable for breathing.
P235+P410	Keep cool. Protect from sunlight.
P273	Avoid release to the environment.
P310	Immediately call a POISON CENTER or doctor/physician.
P307+P311	IF exposed: call a POISON CENTER or doctor/physician.
P201	Obtain special instructions before use.
P411+P235	Store at temperatures not exceeding ... Β°C/...Β°F. Keep cool.
P337	If eye irritation persists:
P234	Keep only in original container.
P373	DO NOT fight fire when fire reaches explosives.
P308	IF exposed or concerned:
P403	Store in a well-ventilated place.
P302	IF ON SKIN:
P243	Take precautionary measures against static discharge.
P304	IF INHALED:
P305+P351+P338	IF IN EYES: Rinse cautiously with water for several minutes. Remove contact lenses if present and easy to do - continue rinsing.
P351	Rinse cautiously with water for several minutes.
P102	Keep out of reach of children.
P352	Wash with plenty of water/...
P270	Do not eat, drink or smoke when using this product.
P304+P340	IF INHALED: Remove person to fresh air and keep comfortable for breathing.
P263	Avoid contact during pregnancy/while nursing.
P340	Remove victim to fresh air and keep at rest in a position comfortable for breathing.
P231+P232	Handle under inert gas/... Protect from moisture.
P309	IF exposed or if you feel unwell
P320	Specific treatment is urgent (see ... on this label).
P103	Read label before use
P285	In case of inadequate ventilation wear respiratory protection.
P314	Get medical advice/attention if you feel unwell.
P407	Maintain air gap between stacks or pallets.
P211	Do not spray on an open flame or other ignition source.
P413	Store bulk masses greater than ... kg/...lbs at temperatures not exceeding ... Β°C/...Β°F.
P411	Store at temperatures not exceeding ... Β°C/...Β°F.
P264	Wash ... thoroughly after handling.
P301+P310	IF SWALLOWED: Immediately call a POISON CENTER/doctor/...
P212	Avoid heating under confinement or reduction of the desensitized agent.
P501	Dispose of contents/container to ...
P370+P378	In case of fire: Use ... to extinguish.
P301	IF SWALLOWED:
P338	Remove contact lenses, if present and easy to do. Continue rinsing.
P371+P380+P375	In case of major fire and large quantities: Evacuate area. Fight fire remotely due to the risk of explosion.
P342	If experiencing respiratory symptoms:
P374	Fight fire with normal precautions from a reasonable distance.
P405	Store locked up.
P350	Gently wash with plenty of soap and water.
P261	Avoid breathing dust/fume/gas/mist/vapors/spray.
P333+P313	IF SKIN irritation or rash occurs: Get medical advice/attention.
P370+P376	in case of fire: Stop leak if safe to do so.
P241	Use explosion-proof [electrical/ventilating/lighting/.../] equipment.
P370+P380+P375	In case of fire: Evacuate area. Fight fire remotely due to the risk of explosion.
P302+P350	IF ON SKIN: Gently wash with plenty of soap and water.
P378	Use ... to extinguish.
P402+P404	Store in a dry place. Store in a closed container.
P332	IF SKIN irritation occurs:
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, name, grade, code, category, viscosity, company_id, comment) FROM stdin;
1	pr1	A-B-CC-32	ZINC	4.66	4	3	\N
2	pr2	ISO 46	AA-B-DC-14	OIL	5.06	5	\N
3	pr3	20W	AB-BB-C-33	OIL ISO 220	6.12	6	\N
4	pr4	75W/80	AB-BD-C-55	SPESIAL	0.38	4	\N
5	pr5	85W/140	AA-CC-D-56	HIGH VI  ISO 46	3.46	1	\N
6	pr6	90	AB-CD-C-57	OIL ISO 220	0.53	3	\N
7	pr7	75W/140	AB-CD-C-66	OIL ISO 220	8.85	1	\N
8	pr8	85W/90	AA-C-D-67	OIL ISO 220	9.93	5	\N
9	pr9	85W/90	AB-CC-C-75	OIL	7.48	3	\N
10	pr10	15W/40	AA-D-BB-77	OIL ISO 220	2.31	3	\N
11	pr11	5W/30	AA-CD-FG-43	ZINC	9.28	2	\N
12	pr12	75W/80	BE-B-BB-43	GEAR OIL	4.2	3	\N
13	pr13	10W/60	BB-AA-BE-432	ULTRA	4.75	3	\N
14	pr14	30	BB-AC-GG-532	SUPER	3.7	3	\N
15	pr15	5W/30	BC-GE-533	OIL	8.82	2	\N
16	pr16	ISO 22	BB-FE-EE-522	OIL	5.9	1	\N
17	pr17	5W/30	BE-AS-AS-623	HIGH VI	4.2	4	\N
18	pr18	85W/140	BB-GE-KK-970	MULTI	1.55	2	\N
19	pr19	ISO 320	BE-GG-HE-724	HIGH VI	4.14	1	\N
20	pr20	SAE 20W	BD-GE-HE-513	SPECIAL	5.85	5	\N
21	pr21	10W/60	FB-GE-HE-5362	MULTI	5.12	6	\N
22	pr22	20W	GG-GE-TEWA-523	ULTRA	1.52	3	\N
23	pr23	75W/80	AB-GEE-GE-1612	ULTRA	5.75	4	\N
24	pr24	20W	BD-GG-TEWW-1563	MULTI	6.93	1	\N
25	pr25	30	FD-GE-GGG-326	MULTI	7.19	2	\N
26	pr26	5W/30	FFE-322-DFD-A	SUPER	4.97	2	\N
27	pr27	140	FEW-32-GDE	HIGH VI ZINC	7.54	6	\N
28	pr28	10W/30	FF-TE-ZZ-763	MULTI	3.91	2	\N
29	pr29	20W/30	HE-EWA-AA-146	DIESEL	9.8	6	\N
30	pr30	ISO 680	AA-GE-GH-14466	SUPER	0.71	6	\N
31	pr31	85W/90	GE-HEHE-FE-723	SUPER	8.82	3	\N
32	pr32	20W	FDIB-GE-GEE-3602	ZINC	0.67	4	\N
33	pr33	ISO 46	  	EXTRA	4.82	2	\N
34	pr34	10W30	DFE-BAX-ND-9127	GEAR OIL	2.32	5	\N
35	pr35	85W/140	DD-BD-HH-1363	HIGH VI	8.05	6	\N
36	pr36	ISO 68	BE-GG-VA-1262	GEAR OIL	4.91	4	\N
37	pr37	ISO 680	GG-BB-HEA-0923	HIGH VI	1.44	3	\N
38	pr38	ISO 32	FDE-BED-EHGE-543	GEAR OIL 	2.49	5	\N
39	pr39	10W/30	BEDD-GE-BA-328T	EXTRA	1.56	1	\N
40	pr40	75W/80	FD-GEE-3VS-L322	ZF	1.18	6	\N
41	pr43	5W/50	AA-TRB-Y34	MULTI	4.5	2	\N
42	pr43	4W/50	AW-FE-3G3	SPECIAL	4.5	3	\N
43			GE-2343-GE3		0	3	\N
44			FEE-GER-2F3		0	2	\N
\.


--
-- Data for Name: standard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standard (product_id, name) FROM stdin;
23	API GL-4
23	API CF-4/CF/SG
26	MAN 3275
35	VW 505.01
25	Deutz DQC I-02
29	THYSSEN TH N-256132
15	CAT ECF-1
28	ACEA C2 08
12	API CF
11	VW 501.01
15	ZF TE-ML 05A
26	ZF TE-ML 05A
18	CAT ECF-1-a
37	MAN 3477
15	API CI-4/CH-4/CG-4/CF-4
38	US Steel 126/127/136
3	EATON VICKERS EH-1027C
24	MAN 339 TYPE F
5	ZF TE-ML 19C
34	JASO FB
3	MB 228.1
7	MB-Approval 235.0
8	MB 229.51
11	AFNOR NF E 48 603 HM
5	ACEA C2
35	ZF TE-ML 10
13	ZF TE-ML 10
35	DAG
16	FORD M2G 159B/C
30	part 2 and 3 HLP
36	ACEA A3/B3-04
15	ACEA A2
26	BMW LL-04
38	DRESSER
9	VW 502.00
25	ZF TE-ML 17B
2	JASO MB T903:2006
34	MAN 3275
37	PSA B712290
20	API SN/SM/CF
19	SAE-J-1966 MIL-L-6082E
32	ACEA E6
5	MB 235.8
33	RVI RLD-2
39	VCL
22	HV
12	NMMA
17	SIS SS 155434
34	ZF TE-ML 05A
27	KOMATSU KES 07.868.1
39	VW 502.00
3	ZF TE-ML 16F
39	DAF
13	SAE J2360
12	ACEA B3
33	EATON VICKERS EH-1027C
37	TEMEC/TTC
12	MAN 341 Type Z2
27	MAN 342M-2
1	MB 228.51
15	ZF TE-ML 07A
27	MWM
24	Mack EO-K/2
40	ZF TE-ML 02B
12	API TC
21	JASO MA T903:2006
4	ISO-L-EGB
19	SPERRY VICKERS M-2950-S/I-286-S
37	Volvo 97310/97316
16	MAN 339 TYPE F
13	ACEA E3
35	ACEA E3
15	VW 505.00
27	POCLAIN
5	ACEA E9-08
18	ZF TE-ML 16C
25	VOLVO 97335
23	JASO FD
6	CAT TO-4
5	API CF-4/CF/SG
34	SCANIA STO 1:0
35	WAUKESHA
38	JASO MA
21	ZF TE-ML 08A
2	ISO 6521DAA
11	API SL/CF
25	RVI RLD-2
33	ISO /DP 6521 DAA
29	ACEA A3/B4
36	ZF TE-ML 17B
31	DAF
30	ZF TE-ML 04G
30	KOMATSU KES 07.868.1
31	VW 502.00
15	API SF/CD
38	FORD ESP-M2C166-H
2	AFNOR NF E 48-603HM
28	Denison Filterability TP 02100
17	Denison Filterability TP 02100
19	ZF TE-ML 12E
13	ACEA E9-08
21	DEXTRON IID
8	MWM
19	MWM
26	ISO-L-EGD
21	GUASCOR
15	API SJ
22	DRESSER
37	BMW LL-04
15	API GL-4
27	VW 505.01
36	ACEA B2
40	VW502.00
21	ISO 6521DAA
7	VW 505.00
14	VOITH 55.6335
15	API CF
34	JASO FC
31	FORD ESP-M2C138-CJ
15	ISO-L-EGB
28	FORD MERCON
16	WAUKESHA
29	GM Dexos 2
20	ACEA A1/B1
5	API TC
32	JASO FD
6	Mack EO-K/2
30	DIN 51517 PART 3
23	MB 228.51
31	ZF TE ML 05C/12C/16E
17	ACEA A3/B4-04
27	ZF TE-ML 10
29	N.HOLLAND 82009201/2/3
18	JASO FC
23	VCL
3	MTU TYPE 2
15	API SC/CC
14	AGMA 250.04
21	ACEA A3/B4
23	VW 502.00
34	API GL-4
37	ACEA C2/C3
8	MAN 342 Type M2
1	MB 235.0
17	NIGATA
14	SCANIA STO 1.0
28	DAB
11	ZF TE-ML 12E
18	Volvo 97310
14	HOESCH HWN 233
39	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
2	N.HOLLAND 82009201/2/3
27	SAE J2360
15	ACEA B3
40	MB-Approval 235.0
15	MAN 341 Type Z2
26	MAN 341 Type Z2
7	API CF-4/CF/SG
18	ACEA E3/E5/E7/A3/B3
7	ACEA E3/E5/E7/A3/B3
31	FORD ESP-M2C166-H
1	MB 229.52
10	ZF TE-ML 05A
28	GM dexos 2
5	DAVID BROWN S1.53.101
23	FORD ESP-M2C138-CJ
7	SEB 181 226
21	MAN 3477
17	DENISON
33	SCANIA STO 1.0
38	US Steel 224
40	Volvo 97310/97316
34	ZF TE ML 05L
15	JASO FD
8	MB 229.5
36	MIL-L-2105D
26	API SG
18	API SC/CC
10	JOHN DEERE J27
7	MB 236.2
22	DIN 51524
34	MAN 341 Type Z2
4	VW 502.00
1	Deutz DQC I-02
31	VOLVO VDS-3
13	ZF TE-ML 08A
38	VW 505.01
39	ACEA A3/B4-04
25	MTU TYPE 1
34	API TC
29	BMW Longlife 04
25	VOITH 55.6335
9	ACEA E2-96 Issue 5 2007
40	Denison Filterability TP 02100
36	ISO /DP 6521 DAA
35	DAVID BROWN S1.53.101
21	POCLAIN
24	Sperry Vickers M-2950-S/ I-286-S
7	ACEA B3
11	CAT TO-4
36	ZF TE-ML 12L
1	ACEA A3/B4-04
25	AFNOR NF E 48 603 HM
7	Voith 3.325-339
30	ACEA C2/C3
2	BMW Longlife 04
38	DAG
14	MAN 342 Type M-1
35	ZF TE-ML 24A
13	GUASCOR
17	API GL-4/GL-5/MT-1
20	MTU
29	DIN 51506 VBL
10	ACEA E2-96 Issue 5 2007
10	VW 505.00
10	ZF TE-ML 16B/C/D
30	MB 235.8
19	MB 235.8
4	MAN 3477
39	MAN 339 TYPE F
3	MB 235.0
6	VW 501.01
27	ZF TE-ML 16B
38	ZF TE-ML 06A/B/C &07B
38	SAE J2360
28	ZF TE-ML 16D
17	ALLISON C-4
22	DIN 51517 PART 3
21	MAN 3275
12	VOLVO VDS-3
30	ZF TE ML 09
20	CUMMINS
3	SUFFIX A
21	BMW Longlife 04
24	ACEA A3/B4
8	API GL-1
40	ACEA E2-96 Issue 5 2007
30	API GL-1
30	CUMMINS CES 20 072/1/6/7/8
9	EATON VICKERS EH-1027C
20	MAN DIESEL & TURBO 4T
29	VW 505.00
40	ZF TE-ML 16B/C/D
9	MB 228.1
14	VW 501.01/505.00
14	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
28	JASO MB T903:2011
17	ZF TE-ML 12L
31	CAT TO-2
25	MB 229.51
5	N.HOLLAND 82009201/2/3
2	ZF TE-ML 19C
35	ZF TE-ML 08
22	MB 2283/229.1
21	ACEA A2
10	API SJ
32	MB-Approval 235.0
39	Mack EO-K/2
5	API SN/CF
14	TC-W3
21	ZF TE-ML 10
27	THYSSEN TH N-256132
25	SAE-J-1966 MIL-L-6082E
39	ACEA A5/B5
16	ISO 6521DAA
14	POCLAIN
38	ACEA E6
12	ZF TE-ML 12M
4	JASO FB
36	AGMA 250.04
5	CAT ECF-1-a
30	DANA POWERSHIFT
10	ISO-L-EGB
10	SEB 181 226
1	SF TE-ML 07C
23	ZF TE-ML 19B
26	ACEA A1/B1
34	US STEEL 224
21	ZF TE-ML 07A
3	Porsche
23	ACEA A3/B4-04
34	ML-2105D
18	VOLVO VDS
15	ZF TE ML 05C/12C/16E
40	API SL
3	FORD M2G 159B/C
7	VCL
24	API SN/CF
5	Volvo 97310/97316
25	FORD ESP-M2C166-H
21	VW 505.00
32	CAT ECF-1
36	ZF TE-ML 21A
34	ACEA C2 08
26	SIS SS 155434
2	CUMMINS CES 20 072/1/6/7/8
15	SIS SS 155434
17	VOITH 55.6335
32	ZF TE-ML 05A
37	Volvo 97316
16	ZF TE-ML 08
23	CAT TO-4
14	ACEA C3
34	FORD ESP-M2C138-CJ
10	JASO MA 2 T903:2011
20	SF TE-ML 07C
40	API CI-4/CH-4/CG-4/CF-4/CF/SL
35	TEMEC/TTC
22	ZF TE-ML 19C
36	GUASCOR
27	ZF TE-ML 02B
6	MAN 342 Type M-1
32	BMW LL-04
30	API GL-5
19	API GL-5
3	ACEA E7
8	JASO MB T903:2006
28	US Steel 126/127/136
27	ISO 6521DAA
36	API SL/CF
1	ZF TE-ML 12L
29	NMMA
10	DIN 51524 IIHLP
29	ZF TE ML 05L
26	ACEA A3/B3-04
29	ACEA B3
20	ALLISON C-4
21	API CF-4/CF/SG
32	ZF TE-ML 07A
24	MAN 3275
26	VOLVO VDS-3
9	MTU TYPE 1
22	ACEA E6
24	BMW Longlife 04
4	ACEA E2-96 Issue 5 2007
2	ZF TE ML 05L
35	Denison Filterability TP 02100
5	SCANIA STO 1:0
22	Volvo 97310
21	ISO-L-EGB
14	SAE J2360
36	SPERRY VICKERS M-2950-S/I-286-S
6	MAN 342M-2
31	RENAULT TRUCKS RXD/RGD
1	SEB 181 222
11	THYSSEN TH N-256132
40	JASO FD
17	ACEA A1/B1
25	MB 229.1
3	Mack EO-K/2
27	ZF TE-ML 08
30	ZF TE-ML 24A
35	ACEA A2
21	API SC/CC
8	GUASCOR
35	JOHN DEERE J27
13	JOHN DEERE J27
24	JOHN DEERE J27
17	ZF TE ML 05C/12C/16E
37	VDMA 24318
35	ZF TE-ML 12M
19	ACEA A2/B2
14	ACEA E3
40	CATERPILLAR
33	MCK GO-J
39	AGMA 250.04
9	US STEEL 224
10	MAN 271
12	ZF TE-ML 16F
14	WAUKESHA
32	API SF/CD
9	ML-2105D
19	AFNOR NF E 48-603HM
36	VW 501.01/505.00
38	DEXTRON IID
27	N.HOLLAND 82009201/2/3
30	NMMA FC.W
33	ACEA C2
26	CUMMINS
5	JASO FC
8	NMMA FC.W
1	MTU TYPE 2
12	DEXTRON IIIH
10	VCL
36	TC-W3
12	ISO /DP 6521 DAA
30	ACEA A3/B4
27	API SN/CF
34	MTU
17	SPERRY VICKERS M-2950-S/I-286-S
5	ALLISON C4
16	API CI-4/CH-4/CG-4/CF-4
26	MAN DIESEL & TURBO 4T
26	DAB
32	API CF
9	ACEA A1/B1
32	SEB 181 226
32	ISO-L-EGB
16	ACEA A2
9	ZF TE ML 05C/12C/16E
34	ZF TE-ML 19B
16	MB 229.5
6	VW 505.01
29	MB 228.51
20	AFNOR NF E 48 603 HM
11	ACEA A2/B2
33	ZF TE ML 09
10	ACEA C2 08
36	ISO 6743/4 HM
5	API CF
34	CUMMINS
3	ZF TE-ML 16B
17	HVLP
32	API SC/CC
37	MB 229.52
31	MTU TYPE 2
16	SCANIA STO 1:0
5	SEB 181 226
2	MAN 271
22	API GL-5
20	US Steel 126/127/136
28	ZF TE-ML 04G
17	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
12	MIL-PRF-2105E
4	ALLISON C-4
28	ZF TE-ML 12E
17	VW 501.01/505.00
24	Volvo 97310
8	JASO MA 2
30	JASO MA 2
4	JASO MA 2 T903:2011
32	ZF TE ML 05L
6	ZF TE-ML 10
19	N.HOLLAND 82009201/2/3
5	API SC/CC
25	ACEA A5/B5
32	ACEA B3
13	API SJ
4	ISO /DP 6521 DAA
5	MB 236.2
30	API SN/CF
35	API GL-4
24	API GL-4
22	ZF TE-ML 08A
1	API SL/CF
35	ACEA E3/E5/E7/A3/B3
7	DAB
37	JOHN DEERE J27
17	MTU
26	RVI RLD-2
15	RVI RLD-2
13	API CF
21	Volvo 97316
7	CAT TO-2
24	MB 228.1
11	ZF TE-ML 08
8	CAT ECF-1-a
36	ACEA E7
30	TEMEC/TTC
36	ACEA C3 08
6	US STEEL 126/127/136
31	MB 229.51
31	GUASCOR
12	AFNOR NF E 48 603 HM
9	ACEA A3/B3-04
11	VW502.00
40	ZF TE ML 05C/12C/16E
6	ACEA C2
29	ZF TE ML 05C/12C/16E
17	ISO 6743/4 HM
37	CUMMINS
16	JASO FC
9	SUFFIX A
21	VCL
9	HVLP
20	part 2 and 3 HLP
3	JENBACHER
9	ZF TE-ML 04G
25	API GL-1
23	SCANIA STO 1.0
22	ISO 6521DAA
30	JASO FB
12	SCANIA STO 1.0
34	RVI RLD-2
39	SUFFIX A
7	VOLVO 97335
36	MCK GO-J
27	SCANIA STO 1:0
31	DEUTZ DQC III-05
15	ZF TE-ML 14A
24	JASO MA 2 T903:2011
34	EATON VICKERS EH-1027C
38	MB-Approval 235.0
27	CUMMINS
33	THYSSEN TH N-256132
3	ZF TE-ML 08A
6	ACEA E6
22	NMMA FC.W
30	BMW Longlife 04
11	CAT ECF-1-a
17	ACEA E7
22	MACK EO-M PLUS
20	FORD ESP-M2C166-H
17	MAN 339 TYPE F
38	JASO FB
17	ACEA C3 08
26	JASO MB T903:2011
8	ZF TE-ML 16C
37	VOLVO 97335
7	API CI-4/CH-4/CG-4/CF-4/CF/SL
13	JASO FD
9	FORD M2G 159B/C
11	DIN 51517 PART 3
24	API SG
8	ACEA A2
13	API SG
4	MB 228.51
11	Volvo 97310/97316
10	Deutz DQC I-02
14	ACEA A2/B2
36	ZF TE ML 09
25	ACEA A3/B3
20	HVLP
35	MIL-PRF-2105E
40	MB 229.52
30	SCANIA STO 1:0
23	DEUTZ DQC III-05
10	FORD MERCON
37	SF TE-ML 07C
27	ALLISON C4
20	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
10	ZF TE-ML 19B
7	ZF TE-ML 16D
31	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
20	VW 501.01/505.00
15	SEB 181 222
14	NMMA FC.W
17	ACEA C2
5	SCANIA STO 1.0
7	DEXTRON IIIH
7	ISO /DP 6521 DAA
5	DAF
8	ACEA C2/C3
22	PSA B712290
39	VW 505.01
25	ZF TE ML 01/03C/07F
6	ACEA A3/B3
19	VW 505.00
8	VW 505.00
2	ZF TE-ML 05A
24	Volvo 97316
20	WARTSILA 4T
14	ZF TE-ML 08
9	DAH
9	DAG
40	FORD MERCON
24	MAN 271
28	WAUKESHA
11	ACEA A2
15	ZF TE-ML 06A/B/C &07B
33	API CF/CF-2
21	VOLVO VDS-3
28	ZF TE-ML 14A
37	JASO MA 2 T903:2011
4	API SL/CF
2	JOHN DEERE J27
13	VOLVO VDS
17	ZF TE ML 09
3	DIN 51524
26	JASO MB T903:2006
9	MCK GO-J
7	CATERPILLAR
6	JASO MA T903:2006
29	ZF TE-ML 17B
40	NIGATA
36	ACEA A3/B3
21	ZF TE-ML 05A
24	US STEEL 224
18	SEB 181 222
15	HOESCH HWN 233
12	MWM
30	API SL
1	DAG
20	ACEA C3
9	ACEA A5/B5
26	DRESSER
2	ZF TE-ML 17B
3	API SN/CF
14	API SN/CF
8	API GL-4
7	MTU TYPE 1
11	VW 505.00
39	ACEA C2
22	BMW Longlife 04
33	DIN 51524
37	HV
34	AGMA 250.04
28	DANA POWERSHIFT
1	SAE J2360
38	ALLISON C4
30	DRESSER RAND
24	ACEA A1/B1
23	DIN 51517 PART 3
22	ZF TE-ML 16C
29	VOLVO 97335
38	CUMMINS CES 20 072/1/6/7/8
23	Porsche
16	VOLVO VDS
31	DAH
31	ZF TE-ML 10
36	ZF TE-ML 17H
1	ACEA C2/C3
21	CUMMINS
2	GM dexos 2
19	MB 236.2
22	AFNOR NF E 48-603 HM
7	AGMA 250.04
38	API SJ
34	DRESSER
5	MB 235.0
18	SCANIA STO 1.0
7	SCANIA STO 1.0
24	VDMA 24318
4	MB 229.52
4	MAN 342M-2
19	NMMA
21	ACEA E2-96 Issue 5 2007
4	MWM
32	MB 229.52
26	AFNOR NF E 48-603HM
33	CAT ECF-1-a
19	JASO MA 2 T903:2011
30	JASO MA 2 T903:2011
5	US STEEL 126/127/136
20	ZF TE-ML 19C
34	MB 229.51
14	BMW Longlife 04
28	ZF TE ML 05L
34	part 2 and 3 HLP
10	ISO /DP 6521 DAA
37	AGMA 250.04
11	SEB 181 226
26	SPERRY VICKERS M-2950-S/I-286-S
17	JASO MB T903:2006
32	Deutz DQC I-02
20	ACEA E3
22	VW 505.00
39	ZF TE-ML 16B
4	Porsche
19	DIN 51524 IIHLP
2	DRESSER RAND
12	DAH
30	JASO FD
7	part 2 and 3 HLP
31	WAUKESHA
29	ZF TE-ML 16D
14	DIN 51506 VBL
40	DIN 51517 part III CLP
19	API SN/SM/CF
38	Voith 3.325-339
32	ACEA A3/B4-04
36	NMMA FC.W
15	SUFFIX A
23	MCK GO-J
26	HVLP
15	HVLP
32	ZF TE-ML 17B
34	SPERRY VICKERS M-2950-S/I-286-S
31	CUMMINS CES 20 072/1/6/7/8
4	MB 2283/229.1
32	MAN DIESEL & TURBO 4T
21	EATON VICKERS EH-1027C
5	MB 229.1
5	M.FERGUSON CMS M 1139/1144 & 1145
26	MAN 342M-2
15	MAN 342M-2
29	RENAULT TRUCKS RXD/RGD
31	ACEA E9-08
11	Voith 3.325-339
21	DRESSER RAND
17	ZF TE-ML 02B
12	ACEA A5/B5
38	API SG
39	API TC
15	API CG-4/SF
6	PSA B712290
7	SPERRY VICKERS M-2950-S/I-286-S
14	ZF TE-ML 16B/C/D
34	SUFFIX A
20	ZF TE-ML 16B
31	ZF TE-ML 16B
26	WARTSILA 4T
39	JENBACHER
11	API SG
28	API CF/CF-2
21	ZF TE-ML 16D
17	AFNOR NF E 48-603HM
13	M.FERGUSON CMS M 1139/1144 & 1145
34	ZF TE-ML 12E
32	VOLVO 97335
36	JASO MA 2
35	CUMMINS
7	HVLP
18	KOMATSU KES 07.868.1
19	DAF
7	ZF TE-ML 04G
15	MAN 342 Type M2
3	ALLISON C4
25	API CI-4/CH-4/CG-4/CF-4
6	JASO FB
16	Denison Filterability TP 02100
28	MACK EO-M PLUS
24	DAB
34	POCLAIN
27	SIS SS 155434
8	ML-2105D
34	WARTSILA 4T
36	CAT ECF-1-a
26	VDL
4	ACEA A5/B5
32	Mack EO-K/2
14	API GL-4
3	API GL-4
24	ACEA B2
17	VW502.00
9	ACEA A2/B2
34	Porsche
4	MB 235.8
10	ZF TE-ML 21A
19	ACEA C2 08
29	JASO MB T903:2006
21	HV
27	FORD ESP-M2C166-H
29	MTU TYPE 2
40	MTU TYPE 2
18	WARTSILA 4T
1	DAVID BROWN S1.53.101
14	SEB 181 226
34	US Steel 224
40	US Steel 126/127/136
6	API CI-4/CH-4/CG-4/CF-4
26	MAN 339 TYPE F
15	ACEA C3 08
16	M.FERGUSON CMS M 1139/1144 & 1145
39	MAN 271
37	VW 501.01/505.00
10	MB 229.51
4	ZF TE-ML 14A
4	ACEA E6
15	ZF TE-ML 10
18	MB 229.1
32	MIL-L-2105D
18	US Steel 224
9	ACEA A3/B4
7	US Steel 224
11	VW 502.00
33	API CF-4/CF/SG
27	VOLVO VDS-3
12	ACEA A3/B3
13	RVI RLD-2
40	ZF TE-ML 21A
38	ACEA C2 08
18	MAN DIESEL & TURBO 4T
5	MIL-L-2105D
38	FORD ESP-M2C138-CJ
24	SF TE-ML 07C
15	SAE J2360
20	Sperry Vickers M-2950-S/ I-286-S
21	ZF TE-ML 06A/B/C &07B
17	MB-Approval 235.0
32	RENAULT TRUCKS RXD/RGD
6	ZF TE-ML 07A
31	DEXTRON IID
20	DEXTRON IID
3	API TC
35	API GL-4/GL-5/MT-1
33	API SC/CC
16	GM dexos 2
36	BMW LL-04
6	ACEA E2-96 Issue 5 2007
28	Volvo 97310/97316
12	ZF TE ML 01/03C/07F
31	ACEA A2/B2
29	API SL/CF
38	SIS SS 155434
16	ALLISON C4
3	JASO FD
18	DAH
2	part 2 and 3 HLP
39	MAN 3477
37	VDL
35	ZF TE-ML 14A
30	ACEA A3/B3-04
12	HOESCH HWN 233
39	GM Dexos 2
25	ISO-L-EGD
24	ZF TE-ML 16D
35	ALLISON C-4
29	JASO MA
27	M.FERGUSON CMS M 1139/1144 & 1145
24	DIN 51517 part III CLP
25	API GL-4
36	ZF TE-ML 07A
17	MAN 3275
21	ML-2105D
1	VW502.00
15	ZF TE ML 09
28	CAT ECF-1
25	API CF
9	API CG-4/SF
34	ACEA A5/B5
31	MACK EO-M PLUS
13	JASO MB T903:2011
27	CAT TO-2
32	VW 501.01
16	API CI-4/CH-4/CG-4/CF-4/CF/SL
12	ZF TE-ML 02B
1	VDMA 24318
21	part 2 and 3 HLP
2	MAN 342 Type M-1
32	ZF TE-ML 06A/B/C &07B
25	MB 236.2
8	Deutz DQC I-02
19	Deutz DQC I-02
19	MIL-L-2105D
23	ISO 6521DAA
5	MTU TYPE 1
34	ZF TE-ML 14A
25	NMMA
4	US Steel 126/127/136
37	MCK GO-J
29	HVLP
15	ZF TE-ML 16B
4	ZF TE-ML 17H
3	MAN 271
30	FORD MERCON
34	CUMMINS CES 20 072/1/6/7/8
36	ALLISON C4
40	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
22	ACEA A1/B1
40	MAN 342M-2
17	ZF TE-ML 07A
9	ACEA C3
2	ACEA A3/B3-04
34	ACEA E9-08
10	Porsche
6	MB 236.2
5	AGMA 250.04
3	VW 502.00
19	ZF TE-ML 17B
14	DAF
21	SPERRY VICKERS M-2950-S/I-286-S
28	ACEA E2-96 Issue 5 2007
4	Sperry Vickers M-2950-S/ I-286-S
5	US Steel 126/127/136
21	FORD ESP-M2C166-H
33	ZF TE-ML 24A
37	ACEA E3
11	ZF TE-ML 05A
35	VOITH 55.6335
22	SIS SS 155434
19	CAT TO-2
13	VW 501.01
30	CAT TO-4
10	VDL
36	DRESSER RAND
20	MB-Approval 235.0
26	THYSSEN TH N-256132
1	MAN 3275
8	ACEA B2
23	VW502.00
21	ACEA A3/B3-04
2	MTU
35	JASO MB T903:2006
21	SUFFIX A
23	MAN 3477
30	DENISON
37	API GL-1
8	DENISON
23	GM Dexos 2
38	NIGATA
34	ACEA A3/B3
5	MB 229.51
37	ACEA E9-08
33	ML-2105D
26	ZF TE-ML 17H
10	DAG
22	ACEA A3/B3-04
35	DRESSER
1	ZF TE-ML 12M
6	API SN/SM/CF
4	MACK EO-M PLUS
7	ACEA A3/B3
17	ACEA E3/E5/E7/A3/B3
11	DAB
16	VOITH 55.6335
23	API CG-4/SF
6	MIL-PRF-2105E
31	Denison Filterability TP 02100
31	ZF TE-ML 05A
20	Denison Filterability TP 02100
2	ACEA C3
17	ISO-L-EGB
19	EATON VICKERS EH-1027C
40	MAN 339 TYPE F
30	Mack EO-K/2
21	Porsche
10	ACEA C2
29	MB 229.5
34	ZF TE-ML 17H
4	DIN 51524
16	MB 228.51
11	GM dexos 2
31	AFNOR NF E 48-603 HM
31	DIN 51506 VBL
9	API SF/CD
1	ZF TE-ML 16B/C/D
35	API SL/CF
15	ISO 6521DAA
38	RVI RLD-2
6	Volvo 97316
12	MAN 342 Type M2
17	ZF TE ML 05L
31	SCANIA STO 1:0
2	MB 229.5
8	MIL-L-2105D
32	KOMATSU KES 07.868.1
6	MAN 271
8	ZF TE-ML 16F
13	DEUTZ DQC III-05
35	DEUTZ DQC III-05
7	HOESCH HWN 233
18	HOESCH HWN 233
9	ISO-L-EGD
38	EATON VICKERS EH-1027C
15	AFNOR NF E 48-603HM
8	ALLISON C-4
35	JASO MA
14	US STEEL 126/127/136
19	DIN 51517 part III CLP
32	VW 501.01/505.00
34	DEXTRON IID
23	CAT ECF-1
38	DRESSER RAND
19	DEXTRON IIIH
40	ACEA A5/B5
5	KOMATSU KES 07.868.1
11	SF TE-ML 07C
7	Sperry Vickers M-2950-S/ I-286-S
15	MACK EO-M PLUS
35	FORD ESP-M2C166-H
22	MAN DIESEL & TURBO 4T
20	VW 505.00
37	ZF TE ML 01/03C/07F
5	MAN 342M-2
32	POCLAIN
5	MWM
1	API SL
15	ZF TE-ML 08
10	API CF-4/CF/SG
37	ZF TE-ML 17H
7	GUASCOR
1	API SJ
4	Volvo 97310/97316
16	SAE-J-1966 MIL-L-6082E
1	ACEA E3/E5/E7/A3/B3
18	ACEA A2/B2
40	ACEA E6
2	MB 235.8
32	FORD M2G 159B/C
31	JASO FC
30	HV
24	SUFFIX A
10	DANA POWERSHIFT
8	CATERPILLAR
16	DEUTZ DQC III-05
15	MAN 3477
11	ALLISON C-4
13	ZF TE-ML 12E
5	DIN 51517 PART 3
19	SEB 181 222
40	ACEA E9-08
11	JASO MA 2 T903:2011
9	API TC
35	TC-W3
27	DRESSER
13	TC-W3
5	US Steel 224
14	ZF TE-ML 17B
26	API SN/CF
12	ACEA C2/C3
32	VW 505.01
19	MTU TYPE 1
39	ISO /DP 6521 DAA
34	VW502.00
13	MTU
17	Volvo 97316
11	ZF TE-ML 12L
1	ZF TE ML 05L
9	DIN 51524 IIHLP
18	ZF TE-ML 08
5	VDL
34	MAN 3477
32	ACEA E7
22	Mack EO-K/2
4	AFNOR NF E 48-603 HM
4	BMW LL-04
16	ACEA A3/B3-04
33	ACEA A3/B4-04
35	ISO 6743/4 HM
37	NMMA FC.W
22	API GL-4/GL-5/MT-1
11	CATERPILLAR
10	JASO MA T903:2006
10	API GL-5
10	JENBACHER
38	MTU TYPE 1
11	SEB 181 222
38	VOITH 55.6335
27	API CF/CF-2
23	CUMMINS CES 20 072/1/6/7/8
22	MIL-L-2105D
18	N.HOLLAND 82009201/2/3
12	API SL
13	MB 2283/229.1
\.


--
-- Data for Name: substance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substance (id, ec, cas, name, reach, un_number, pbt, last_mod_date, last_check_date, comment) FROM stdin;
1	775-461-5	423224-60-4	"sub1	01-7262288169-22	\N	\N	2013-10-01	2019-10-25	\N
2	598-870-2	907534-60-6	"sub2	01-1018954628-25	UN9003	\N	2015-11-27	2020-02-21	\N
3	169-833-4	477137-37-0	sub3	01-8414025376-33	\N	\N	2020-01-19	2014-01-25	\N
4	481-879-8	660924-33-1	sub4	01-4223819163-76	\N	\N	2019-06-05	2014-01-13	\N
5	411-809-4	325209-61-0	"sub5	01-4529955924-87	\N	\N	2020-02-11	2014-06-11	\N
6	523-240-5	611495-61-7	"sub6	01-1435317837-40	UN3082	\N	2020-01-16	2014-06-19	\N
7	576-681-6	362369-34-7	sub7	01-2897534758-88	UN3082	\N	2014-01-21	2017-01-04	\N
8	208-989-6	286132-94-5	sub8	01-6052444891-78	\N	\N	2015-01-05	2018-08-01	\N
9	485-883-0	911367-94-5	"sub9	01-4409879152-43	\N	\N	2015-07-25	2021-01-11	\N
10	147-377-3	440633-71-2	sub10	01-8248098959-56	\N	\N	2014-11-19	2013-06-17	\N
11	985-367-3	865870-66-3	sub11	01-2637744216-15	UN3082	\N	2013-04-06	2014-05-19	\N
12	122-269-2	26294-35-2	sub12	01-4819199547-79	\N	\N	2013-08-09	2020-08-24	\N
13	802-204-1	622269-46-7	"sub13	01-5007788547-58	\N	\N	2013-09-17	2020-04-22	\N
14	727-694-3	688229-70-5	"sub14	01-2485289225-42	\N	\N	2013-02-14	2020-05-23	\N
15	524-951-4	253166-51-0	"sub15	01-3259365667-27	UN3082	\N	2018-02-08	2014-01-26	\N
16	695-306-2	450128-53-0	sub16	01-1737435619-89	\N	\N	2021-03-09	2019-08-20	\N
17	239-389-6	223964-60-2	sub17	01-7343947730-17	UN2819	\N	2016-05-27	2016-07-15	\N
18	188-880-3	888782-28-0	"sub18	01-6726836717-15	\N	\N	2018-04-14	2013-06-11	\N
19	758-368-6	232707-23-4	sub19	01-8625319560-55	\N	\N	2014-04-03	2017-05-18	\N
20	434-354-4	552357-83-0	sub20	01-7906734344-70	\N	\N	2015-10-11	2016-01-22	\N
21	997-480-8	470465-92-8	sub21	01-6211709968-77	\N	\N	2020-01-19	2013-01-27	\N
22	455-366-2	498297-25-6	"sub22	01-2216042927-59	\N	\N	2016-07-05	2014-04-06	\N
23	284-142-0	142286-81-8	"sub23	01-1841274264-69	UN3082	\N	2016-06-14	2019-09-03	\N
24	239-328-2	295844-43-1	sub24	01-5869017855-76	UN1760	\N	2021-06-21	2016-04-03	\N
25	465-471-0	678817-13-3	sub25	01-4094639860-47	\N	\N	2013-02-06	2020-11-22	\N
26	537-135-6	125868-13-0	sub26	01-1171962692-38	\N	\N	2016-07-26	2015-05-16	\N
27	581-549-0	35235-31-1	"sub27	01-8329336153-51	\N	\N	2020-10-21	2016-05-25	\N
28	898-790-5	143271-24-3	sub28	01-7729699308-14	UN3082	t	2014-05-24	2013-05-12	\N
29	805-348-0	325706-79-4	sub29	01-2363032894-87	\N	\N	2015-04-04	2018-01-20	\N
30	268-156-0	456606-18-7	"sub30	01-7667094748-73	\N	\N	2019-10-01	2016-09-05	\N
31	860-890-2	952471-18-0	sub31	01-6577253534-36	\N	\N	2016-09-20	2015-11-16	\N
32	728-606-4	488859-63-5	sub32	01-1298927224-26	UN2735	\N	2019-04-04	2016-08-10	\N
33	533-125-1	468277-15-1	sub34	01-4827050975-48	UN2735	\N	2019-05-26	2019-03-01	\N
34	564-206-6	389700-24-8	"sub35	01-4818135503-96	\N	\N	2018-06-26	2013-07-27	\N
35	707-828-0	492774-48-5	sub36	01-8789688807-89	UN2922	\N	2018-11-15	2020-06-07	\N
36	531-360-2	597123-85-6	"sub37	01-6043618064-63	\N	\N	2017-01-13	2020-10-20	\N
37	351-976-4	399462-85-1	sub38	01-1783800571-84	\N	\N	2015-05-14	2017-05-24	\N
38	963-805-0	409546-66-3	"sub39	01-2146559231-31	UN1993	\N	2014-10-16	2021-07-19	\N
39	796-784-8	685937-72-4	sub40	01-5854960807-68	UN3145	\N	2014-06-10	2021-10-21	\N
40	140-528-4	299975-19-6	sub41	01-5892544511-76	\N	\N	2013-09-16	2015-09-06	\N
41	452-423-7	637306-64-8	"sub42	01-1062306376-75	UN3082	\N	2016-05-24	2020-07-03	\N
42	899-874-8	232340-54-7	"sub43	01-8175877439-19	\N	\N	2018-10-24	2013-02-23	\N
\.


--
-- Name: additive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.additive_id_seq', 28, true);


--
-- Name: base_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_id_seq', 4, true);


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 6, true);


--
-- Name: ghs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ghs_id_seq', 137, true);


--
-- Name: msds_msds_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.msds_msds_no_seq', 104, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 44, true);


--
-- Name: substance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.substance_id_seq', 42, true);


--
-- Name: additive additive_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additive
    ADD CONSTRAINT additive_name_key UNIQUE (name);


--
-- Name: additive additive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additive
    ADD CONSTRAINT additive_pkey PRIMARY KEY (id);


--
-- Name: base base_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base
    ADD CONSTRAINT base_pkey PRIMARY KEY (id);


--
-- Name: classify classify_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classify
    ADD CONSTRAINT classify_pkey PRIMARY KEY (substance_id, ghs_id);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: contains_additive contains_additive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_additive
    ADD CONSTRAINT contains_additive_pkey PRIMARY KEY (product_id, additive_id);


--
-- Name: contains_base contains_base_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_base
    ADD CONSTRAINT contains_base_pkey PRIMARY KEY (product_id, base_id);


--
-- Name: contains_substance contains_substance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_substance
    ADD CONSTRAINT contains_substance_pkey PRIMARY KEY (additive_id, substance_id);


--
-- Name: ghs_pic ghs_pic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ghs_pic
    ADD CONSTRAINT ghs_pic_pkey PRIMARY KEY (code);


--
-- Name: ghs ghs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ghs
    ADD CONSTRAINT ghs_pkey PRIMARY KEY (id);


--
-- Name: has_pcode has_pcode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.has_pcode
    ADD CONSTRAINT has_pcode_pkey PRIMARY KEY (ghs_id, p_code);


--
-- Name: msds msds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msds
    ADD CONSTRAINT msds_pkey PRIMARY KEY (msds_no, product_id);


--
-- Name: p_statement p_statement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.p_statement
    ADD CONSTRAINT p_statement_pkey PRIMARY KEY (code);


--
-- Name: product product_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: standard standard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standard
    ADD CONSTRAINT standard_pkey PRIMARY KEY (product_id, name);


--
-- Name: substance substance_cas_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substance
    ADD CONSTRAINT substance_cas_key UNIQUE (cas);


--
-- Name: substance substance_ec_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substance
    ADD CONSTRAINT substance_ec_key UNIQUE (ec);


--
-- Name: substance substance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substance
    ADD CONSTRAINT substance_pkey PRIMARY KEY (id);


--
-- Name: idx_additive_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_additive_name ON public.additive USING btree (name);


--
-- Name: idx_product_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_name ON public.product USING btree (name);


--
-- Name: idx_substance_cas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_substance_cas ON public.substance USING btree (cas);


--
-- Name: idx_substance_ec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_substance_ec ON public.substance USING btree (ec);


--
-- Name: idx_substance_reach; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_substance_reach ON public.substance USING btree (reach);


--
-- Name: classify classify_ghs_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classify
    ADD CONSTRAINT classify_ghs_id_fkey FOREIGN KEY (ghs_id) REFERENCES public.ghs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: classify classify_substance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classify
    ADD CONSTRAINT classify_substance_id_fkey FOREIGN KEY (substance_id) REFERENCES public.substance(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_additive contains_additive_additive_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_additive
    ADD CONSTRAINT contains_additive_additive_id_fkey FOREIGN KEY (additive_id) REFERENCES public.additive(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_additive contains_additive_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_additive
    ADD CONSTRAINT contains_additive_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_base contains_base_base_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_base
    ADD CONSTRAINT contains_base_base_id_fkey FOREIGN KEY (base_id) REFERENCES public.base(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_base contains_base_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_base
    ADD CONSTRAINT contains_base_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_substance contains_substance_additive_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_substance
    ADD CONSTRAINT contains_substance_additive_id_fkey FOREIGN KEY (additive_id) REFERENCES public.additive(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contains_substance contains_substance_substance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contains_substance
    ADD CONSTRAINT contains_substance_substance_id_fkey FOREIGN KEY (substance_id) REFERENCES public.substance(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: has_pcode has_pcode_ghs_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.has_pcode
    ADD CONSTRAINT has_pcode_ghs_id_fkey FOREIGN KEY (ghs_id) REFERENCES public.ghs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: has_pcode has_pcode_p_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.has_pcode
    ADD CONSTRAINT has_pcode_p_code_fkey FOREIGN KEY (p_code) REFERENCES public.p_statement(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: msds msds_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msds
    ADD CONSTRAINT msds_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: product product_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.company(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: standard standard_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standard
    ADD CONSTRAINT standard_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- PostgreSQL database dump complete
--

