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
1	add1	2016-08-08 00:00:00	6.79	\N	\N
2	add2	2014-10-03 00:00:00	10.94	\N	\N
3	add3	2018-12-06 00:00:00	9.06	\N	\N
4	add4	2015-04-15 00:00:00	10.89	\N	\N
5	add5	2018-02-14 00:00:00	12.27	\N	\N
6	add6	2012-11-22 00:00:00	13.49	\N	\N
8	add8	2017-04-12 00:00:00	6.56	\N	\N
9	add9	2015-01-12 00:00:00	13.03	\N	\N
10	add10	2018-07-06 00:00:00	11.3	\N	\N
11	add11	2016-05-06 00:00:00	6.08	\N	\N
12	add12	2018-10-18 00:00:00	11.47	\N	\N
13	add13	2018-10-16 00:00:00	7.42	\N	\N
14	add14	2018-10-16 00:00:00	6.63	\N	\N
15	add15	2018-10-15 00:00:00	5.05	\N	\N
16	add16	2018-02-22 00:00:00	7.8	\N	\N
17	add17	2016-05-06 00:00:00	5.15	\N	\N
18	add18	2019-02-23 00:00:00	6.62	\N	\N
19	add19	2019-02-24 00:00:00	7.6	\N	\N
20	add20	2011-03-03 00:00:00	5.18	\N	\N
21	add21	2018-02-22 00:00:00	12.96	\N	\N
22	add22	2018-02-22 00:00:00	11.81	\N	\N
23	add23	2018-12-02 00:00:00	7.19	\N	\N
24	add24	2018-12-17 00:00:00	10.21	\N	\N
25	add25	2018-12-24 00:00:00	9.12	\N	\N
26	add26	2012-03-21 00:00:00	6.58	\N	\N
27	add27	2017-03-12 00:00:00	14.24	\N	\N
7	add7	2018-10-26 00:00:00	5.39	\N	None
\.


--
-- Data for Name: base; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base (id, code, vi_40, vi_100, qqsp_gr, price) FROM stdin;
1	MOH SN-90	39.97	371.29	0.434	8.19
2	MOH SN-150	28.72	264.42	0.088	13.64
3	MOH SN-500	32.87	283.92	0.417	9.57
4	BRIGHT STOCK	5.28	366.52	0.866	13.37
\.


--
-- Data for Name: classify; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classify (substance_id, ghs_id, scl) FROM stdin;
1	71	\N
17	118	\N
28	66	\N
36	119	\N
18	71	12.5
11	117	\N
33	113	10
15	118	\N
23	113	10
39	112	\N
40	70	\N
2	72	\N
17	71	\N
6	117	\N
29	117	\N
8	70	\N
33	112	\N
24	65	\N
31	113	10
31	95	\N
11	71	3
35	75	\N
38	71	50
3	113	10
4	104	\N
42	119	\N
12	66	2
35	116	\N
35	65	\N
38	53	\N
1	113	10
22	66	6.25
17	65	\N
23	65	\N
41	70	\N
32	65	\N
10	113	\N
30	66	\N
32	113	10
1	112	\N
2	66	\N
33	53	\N
39	70	\N
3	65	\N
25	70	\N
7	71	50
5	118	\N
23	95	\N
10	70	14.2
18	66	6.25
33	55	\N
19	66	2
3	53	\N
13	119	\N
41	66	\N
21	118	\N
33	116	10
34	117	\N
3	55	\N
11	66	15
1	53	\N
16	70	\N
2	77	\N
31	116	10
28	72	\N
23	71	\N
3	116	10
25	66	\N
27	118	\N
35	53	\N
22	117	\N
1	116	1
30	118	\N
15	70	46
25	118	\N
10	116	\N
32	116	1
24	60	\N
35	59	\N
35	70	\N
30	71	\N
24	113	\N
5	66	\N
2	82	\N
23	116	10
36	93	\N
38	70	\N
37	117	\N
32	71	\N
27	70	\N
14	119	\N
33	82	\N
5	72	\N
31	65	\N
35	113	\N
9	119	\N
20	118	\N
32	53	\N
6	71	10
41	113	10
42	104	\N
7	117	\N
41	117	1
31	71	\N
26	70	\N
6	66	\N
3	82	\N
3	71	\N
24	116	10
29	66	\N
1	65	\N
42	66	\N
38	117	\N
22	71	12.5
28	117	\N
30	113	1
18	117	\N
33	65	\N
3	112	\N
28	53	\N
29	72	\N
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
19	6	19.19
21	25	17.21
31	23	11.03
31	15	28.16
29	25	27.47
32	16	11.77
35	5	28.39
21	24	14.53
23	15	20.85
5	22	20.58
25	16	29.63
36	25	23.69
39	14	26.2
29	19	29.89
33	19	27.92
12	14	28.69
21	2	29.27
18	25	10.66
29	24	14.6
18	18	10.87
39	8	23.34
28	26	13.37
22	24	16.22
26	3	27.44
21	21	15.62
16	14	11.87
8	9	28.55
26	6	5.14
28	12	20.45
39	20	26.28
16	1	5.07
17	24	21.82
19	4	22.73
10	10	14.58
40	12	27.94
40	19	5.45
7	7	19.27
30	2	11.5
37	25	23.87
9	7	10.62
4	15	7.58
13	4	25.35
14	15	27.56
16	20	29.83
32	10	19.81
12	16	23.63
22	21	5.87
38	15	7.3
19	15	16.47
16	27	5.58
8	13	18.19
1	6	21.72
13	5	24.93
18	2	29.97
27	23	9.51
32	23	11.39
17	20	15.76
6	7	27.13
29	16	27.99
39	1	7.64
12	23	9.68
24	9	11.05
12	26	7.85
2	1	16.36
8	7	9.07
29	14	7.48
31	4	25.84
33	2	29.33
11	19	18.29
1	3	25.16
24	21	17.93
20	17	28.31
16	13	6.78
1	17	12.19
23	26	12.08
15	14	28.78
5	2	26.82
29	3	15.26
14	21	29.99
32	21	17.39
26	16	24.79
36	26	15.48
36	2	10.45
2	23	29.3
5	25	15.65
17	14	16.92
25	26	6.36
11	12	10.93
18	4	20.38
2	12	23.26
38	14	23.67
11	14	22.02
34	15	5.45
40	25	22.3
9	22	15.08
28	23	11.73
\.


--
-- Data for Name: contains_base; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contains_base (product_id, base_id, quantity) FROM stdin;
18	2	27.91
7	4	36.37
17	2	16.46
35	1	34.09
6	1	19.14
39	2	13.2
26	1	32.03
11	1	25.21
21	3	25.81
13	3	31.29
33	4	34.28
29	4	29.14
19	4	17.79
28	1	21.38
2	1	10.29
19	2	39.61
31	1	14.73
4	3	25.7
34	2	5.01
13	1	28.17
20	3	30.81
40	4	26.19
29	3	37.88
11	3	39.66
6	4	23.07
16	3	12.95
25	4	17.35
27	3	23.14
15	4	6.48
38	2	7.94
5	2	14.27
27	2	23.82
39	1	24.01
32	3	17.78
25	1	24.51
38	3	17.95
7	1	5.1
14	1	8.55
34	3	6.52
12	2	27.99
2	4	19.45
12	3	24.12
9	3	8.38
31	2	5.47
26	2	33.39
10	1	10.64
22	4	20.31
33	3	39.52
9	2	18.8
9	4	23.39
28	4	27.31
31	3	21.41
20	2	18.46
18	3	7.21
27	1	38.18
18	1	20.79
12	4	28.39
36	1	7.85
30	4	15.9
16	4	22.65
24	4	6.79
25	3	38.59
35	4	5.61
20	4	18.97
1	4	24.04
15	3	12.79
32	2	6.28
19	3	30.6
36	4	29.53
32	4	21.19
13	2	36.97
37	1	14.69
15	2	36.91
28	3	32.22
7	2	38.21
30	1	17.44
21	2	17.84
39	4	11.71
40	1	28.47
26	4	21.61
6	2	25.92
12	1	17.8
2	2	11.07
1	1	10.6
5	4	29.52
6	3	15.14
3	2	35.68
24	1	37.73
34	4	30.89
21	4	36.16
30	2	24.85
28	2	17.54
8	2	12.84
37	3	24.82
21	1	38.5
19	1	33.4
23	2	35.51
\.


--
-- Data for Name: contains_substance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contains_substance (additive_id, substance_id, quantity) FROM stdin;
12	15	6.8796
21	9	21.2122
17	38	21.5727
15	41	5.1448
11	27	23.1754
6	32	6.9861
12	21	14.8995
22	23	22.4764
26	34	15.8145
8	36	31.17
6	12	7.5814
17	29	7.7688
6	19	5.0653
27	35	30.5223
4	13	10.166
19	4	14.9398
12	35	33.2221
17	8	14.8049
17	27	23.9508
5	17	19.1982
9	34	7.3594
11	12	11.1246
20	20	17.9375
21	31	32.0054
9	3	7.8186
1	8	30.2436
2	39	16.1501
7	38	32.3098
13	10	32.9747
12	31	5.5533
10	6	6.2504
13	23	24.081
19	7	32.7998
14	39	9.5212
18	1	28.6464
13	3	28.7767
6	25	31.3892
1	30	11.2672
5	36	27.7658
27	26	33.7691
13	39	21.9443
8	8	6.4498
7	37	14.6621
23	34	28.2839
14	38	30.0129
1	2	11.2357
7	21	16.8307
19	24	34.5103
17	32	6.5178
22	29	22.8148
8	14	9.3257
21	27	12.329
25	11	21.9327
5	33	29.1205
3	30	17.2725
10	25	18.2675
11	5	13.0827
24	31	24.2515
12	19	8.7996
4	41	27.1616
7	31	32.9571
10	26	23.8171
14	31	21.2821
26	3	7.5655
26	4	30.5562
8	33	9.0224
26	35	17.8523
2	38	29.0147
15	30	21.5919
11	17	5.6224
27	30	23.5599
19	40	15.9434
16	35	16.5334
14	37	29.0898
4	5	28.0571
7	12	5.5025
1	32	19.5779
11	30	20.2117
19	3	8.0304
9	24	23.4591
20	30	31.0002
27	41	17.834
17	2	32.016
7	16	17.0345
27	40	5.7842
21	8	11.5745
14	7	10.1505
19	8	9.1849
27	22	12.2046
17	15	33.7261
1	22	17.715
12	1	6.2338
2	31	31.6996
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
1	P380
10	P230
100	P405
112	P501
123	P501
2	P401
63	P280
122	P260
75	P310
137	P321
98	P281
37	P335+P334
58	P270
74	P271
105	P201
64	P305+P351+P338
20	P240
62	P405
135	P304+P312
29	P403+P235
35	P235+P410
66	P264
45	P403
16	P243
17	P303+P361+P353
122	P301+P310
21	P370+P378
89	P201
33	P234
78	P312
131	P302+P352
18	P241
35	P407
132	P280
50	P321
70	P272
82	P261
2	P230
23	P211
92	P405
75	P260
29	P420
10	P371+P380+P375
6	P280
20	P210
31	P210
93	P308+P313
124	P363
84	P501
90	P281
95	P501
101	P281
50	P270
6	P372
122	P405
128	P304+P340
126	P264
124	P320
136	P312
65	P260
134	P271
57	P501
68	P501
137	P337+P313
100	P202
81	P285
10	P233
31	P220
124	P322
57	P361
59	P312
36	P280
78	P304+P312
125	P501
131	P261
34	P302+P334
42	P221
32	P370+P378
43	P370+P378
8	P501
9	P370+P380+P375
19	P501
30	P501
113	P391
125	P361
3	P250
122	P284
110	P309+P311
124	P271
135	P271
12	P210
23	P210
127	P363
85	P308+P313
121	P262
51	P330
6	P373
60	P312
87	P501
103	P405
126	P501
5	P401
4	P240
66	P280
128	P312
77	P271
40	P244
38	P501
136	P304+P312
82	P304+P340
92	P202
127	P322
65	P405
76	P405
28	P411
32	P403+P235
58	P264
17	P280
28	P280
42	P210
104	P308+P313
75	P284
137	P264
29	P370+P380+P375
124	P280
56	P331
63	P301+P330+P331
64	P321
66	P302+P352
125	P301+P310
79	P304+P341
15	P211
42	P220
84	P405
32	P420
95	P405
96	P501
106	P405
107	P501
118	P501
13	P381
121	P321
93	P281
53	P270
100	P201
72	P337+P313
63	P304+P340
57	P405
38	P223
80	P501
50	P264
9	P280
40	P403
121	P270
132	P270
103	P202
122	P403+P233
16	P370+P378
122	P321
28	P234
125	P405
39	P280
130	P330
127	P280
116	P391
128	P361
22	P410+P412
122	P270
87	P405
130	P312
35	P420
15	P210
124	P262
76	P311
7	P212
79	P501
85	P281
90	P501
109	P307+P311
1	P372
123	P304+P340
134	P261
92	P201
36	P413
37	P402+P404
110	P264
18	P240
17	P242
58	P280
69	P280
122	P330
16	P403+P235
131	P312
21	P241
41	P501
52	P501
74	P304+P340
84	P202
95	P202
106	P202
31	P411
54	P312
72	P264
20	P280
31	P280
34	P210
96	P308+P313
107	P308+P313
109	P501
104	P281
126	P261
67	P332+P313
3	P501
76	P403+P233
14	P410+P412
24	P251
129	P264
130	P304+P312
7	P210
18	P210
1	P373
69	P302+P352
77	P261
82	P501
128	P301+P310
63	P264
98	P405
110	P501
46	P376
38	P231+P232
62	P310
64	P303+P361+P353
137	P302+P352
48	P410+P403
46	P370+P378
103	P201
33	P501
131	P304+P312
87	P202
123	P302+P350
79	P342+P311
40	P370+P376
53	P264
64	P264
88	P308+P313
99	P308+P313
109	P260
134	P304+P340
19	P370+P378
30	P370+P378
31	P234
128	P405
52	P301+P310
129	P501
8	P401
121	P264
132	P264
46	P381
63	P501
69	P261
80	P261
16	P233
90	P405
101	P405
91	P501
102	P501
42	P280
127	P321
66	P362
38	P370+P378
84	P201
95	P201
106	P201
52	P405
19	P403+P235
30	P403+P235
122	P320
4	P280
13	P403
132	P271
18	P303+P361+P353
77	P304+P340
98	P202
9	P210
8	P230
4	P372
109	P405
121	P501
132	P501
48	P210
125	P330
96	P281
57	P302+P350
107	P281
83	P271
6	P501
1	P281
7	P370+P380+P375
123	P361
123	P310
62	P305+P351+P338
73	P305+P351+P338
125	P312
82	P405
122	P271
30	P420
4	P370+P380
10	P210
11	P381
74	P501
85	P501
87	P201
68	P333+P313
75	P320
2	P240
64	P280
65	P310
128	P311
129	P302+P352
65	P363
16	P241
70	P321
5	P370+P380
111	P314
90	P202
101	P202
121	P280
29	P210
91	P308+P313
102	P308+P313
112	P260
123	P260
77	P312
104	P501
88	P281
99	P281
115	P501
75	P271
55	P301+P310
124	P264
21	P240
34	P422
63	P405
69	P272
2	P210
12	P377
51	P321
74	P260
8	P233
29	P220
40	P220
93	P405
120	P502
128	P403+P233
34	P280
57	P310
132	P302+P352
68	P363
51	P270
41	P370+P378
98	P201
17	P501
28	P501
55	P405
7	P280
18	P280
21	P210
94	P308+P313
125	P363
137	P362
123	P405
124	P501
57	P322
3	P401
8	P370+P380+P375
128	P330
38	P335+P334
43	P221
70	P333+P313
65	P305+P351+P338
80	P304+P341
125	P322
74	P405
85	P405
86	P501
97	P501
36	P235+P410
37	P280
17	P243
132	P261
33	P370+P378
90	P201
9	P501
101	P201
82	P403+P233
4	P250
5	P240
123	P284
36	P407
111	P270
62	P321
39	P501
52	P330
127	P271
83	P261
93	P202
3	P230
4	P210
24	P211
104	P405
116	P501
127	P501
32	P210
43	P210
74	P284
5	P250
91	P281
102	P281
78	P271
1	P501
22	P251
59	P363
55	P331
70	P363
5	P210
33	P403+P235
64	P301+P330+P331
130	P270
58	P501
69	P501
126	P301+P310
32	P220
43	P220
58	P361
82	P312
41	P371+P380+P375
18	P242
60	P363
11	P403
59	P322
31	P501
64	P304+P340
85	P202
136	P271
33	P420
51	P264
10	P280
13	P210
24	P210
86	P308+P313
97	P308+P313
128	P363
88	P501
94	P281
99	P501
132	P304+P340
126	P405
73	P337+P313
60	P322
6	P401
14	P251
16	P240
129	P312
50	P501
83	P304+P340
104	P202
123	P403+P233
128	P322
29	P411
122	P304+P340
47	P376
29	P280
105	P308+P313
127	P302+P352
135	P261
57	P262
47	P370+P378
93	P201
74	P403+P233
23	P410+P412
45	P282
51	P501
80	P342+P311
2	P280
16	P210
89	P308+P313
65	P321
76	P321
129	P301+P312
6	P230
2	P372
96	P405
107	P405
119	P501
111	P264
59	P280
70	P280
47	P381
71	P310
62	P303+P361+P353
132	P312
46	P410+P403
42	P501
75	P304+P340
62	P363
121	P302+P350
58	P405
81	P501
2	P370+P380
62	P264
73	P264
21	P280
108	P308+P313
127	P261
17	P370+P378
28	P370+P378
4	P501
29	P234
46	P211
50	P301+P310
53	P301+P312
85	P201
39	P231+P232
130	P264
126	P311
128	P280
68	P321
59	P302+P352
70	P302+P352
78	P261
117	P391
132	P301+P312
88	P405
99	P405
36	P420
111	P501
131	P363
110	P260
63	P310
125	P321
8	P212
86	P281
97	P281
124	P304+P340
57	P270
135	P304+P340
5	P374
104	P201
38	P402+P404
34	P222
122	P264
50	P405
17	P403+P235
28	P403+P235
125	P270
130	P271
53	P501
16	P303+P361+P353
64	P501
96	P202
107	P202
126	P403+P233
131	P322
32	P411
126	P321
1	P202
9	P401
32	P280
43	P280
46	P210
105	P281
39	P370+P378
70	P261
121	P361
71	P305+P351+P338
15	P410+P412
126	P270
131	P271
134	P312
63	P260
28	P420
5	P280
8	P210
19	P210
30	P210
123	P363
83	P501
89	P281
94	P501
127	P304+P340
5	P372
110	P405
122	P501
1	P401
62	P280
74	P310
126	P330
65	P303+P361+P353
123	P320
135	P312
64	P260
3	P370+P380
56	P501
78	P304+P340
88	P202
80	P285
99	P202
30	P220
9	P230
123	P322
124	P302+P350
4	P373
65	P264
35	P280
100	P308+P313
74	P320
113	P501
20	P370+P378
31	P370+P378
7	P501
18	P501
32	P234
63	P305+P351+P338
2	P250
134	P304+P312
11	P210
131	P280
5	P373
75	P501
81	P261
121	P301+P310
17	P233
22	P211
91	P405
102	P405
103	P501
114	P501
136	P304+P340
79	P285
128	P321
127	P312
76	P271
96	P201
107	P201
37	P501
57	P363
1	P201
64	P405
65	P501
76	P501
31	P403+P235
57	P264
16	P280
18	P243
92	P308+P313
128	P270
121	P405
56	P301+P310
125	P264
28	P370+P380+P375
77	P304+P312
58	P302+P350
41	P221
123	P280
52	P321
124	P310
124	P361
9	P233
14	P211
83	P405
94	P405
31	P420
106	P501
123	P271
22	P210
12	P381
109	P321
130	P261
52	P270
44	P410+P403
42	P370+P378
88	P201
99	P201
69	P333+P313
113	P273
3	P240
56	P405
65	P280
37	P223
17	P241
109	P270
112	P314
6	P370+P380
50	P330
91	P202
102	P202
61	P312
4	P401
41	P210
103	P308+P313
124	P260
25	P202
100	P281
105	P501
10	P501
127	P361
49	P390
110	P270
75	P405
126	P271
3	P210
13	P377
14	P210
62	P301+P330+P331
123	P262
89	P501
124	P301+P310
41	P220
26	P202
35	P413
16	P242
57	P280
58	P310
68	P280
58	P363
69	P363
63	P321
29	P501
62	P304+P340
94	P202
4	P230
30	P411
129	P270
125	P280
8	P280
19	P280
30	P280
33	P210
84	P308+P313
95	P308+P313
106	P308+P313
92	P281
130	P304+P340
66	P332+P313
124	P405
2	P501
58	P322
23	P251
128	P264
129	P330
68	P302+P352
59	P501
70	P501
76	P261
81	P304+P341
33	P220
86	P405
97	P405
59	P361
98	P501
131	P304+P340
38	P280
37	P231+P232
41	P306+P360
125	P302+P352
47	P410+P403
34	P370+P378
91	P201
102	P201
116	P273
83	P403+P233
6	P240
124	P284
60	P501
52	P264
20	P241
123	P270
87	P308+P313
128	P271
53	P330
18	P370+P378
47	P211
30	P234
105	P405
127	P405
117	P501
128	P501
45	P315
7	P401
109	P264
121	P330
6	P250
103	P281
132	P330
68	P261
89	P405
101	P501
6	P210
65	P301+P330+P331
137	P305+P351+P338
37	P370+P378
94	P201
49	P234
83	P312
75	P403+P233
60	P280
18	P403+P235
12	P403
137	P280
66	P321
32	P501
43	P501
65	P304+P340
76	P304+P340
49	P404
86	P202
97	P202
7	P230
130	P301+P312
2	P373
47	P210
129	P363
98	P308+P313
100	P501
63	P303+P361+P353
84	P281
95	P281
106	P281
82	P271
5	P501
51	P301+P310
15	P251
63	P363
17	P240
59	P405
132	P304+P312
60	P302+P352
137	P332+P313
62	P501
105	P202
124	P403+P233
129	P322
124	P321
48	P376
41	P280
64	P310
127	P311
128	P302+P352
64	P363
130	P501
136	P261
58	P262
39	P402+P404
89	P202
51	P405
24	P410+P412
124	P270
81	P342+P311
121	P310
3	P280
17	P210
28	P210
90	P308+P313
101	P308+P313
111	P260
121	P363
132	P363
9	P212
87	P281
92	P501
3	P372
41	P283
131	P501
10	P401
123	P264
68	P272
71	P280
124	P330
11	P377
133	P312
62	P260
122	P310
72	P305+P351+P338
7	P233
18	P233
28	P220
33	P411
121	P322
10	P212
93	P501
126	P304+P340
127	P403+P233
132	P322
33	P280
128	P261
72	P280
29	P370+P378
86	P201
16	P501
97	P201
27	P222
55	P501
45	P336
129	P280
69	P321
3	P373
79	P261
\.


--
-- Data for Name: msds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msds (msds_no, product_id, doc, last_check_date) FROM stdin;
1	27	msds_docs\\msds1.docx	2021-08-04
2	6	msds_docs\\msds2.docx	2018-06-24
3	40	msds_docs\\msds3.docx	2018-09-14
4	26	msds_docs\\msds4.docx	2016-11-20
5	1	msds_docs\\msds5.docx	2017-01-12
6	31	msds_docs\\msds6.docx	2017-07-07
7	31	msds_docs\\msds7.docx	2015-06-26
8	16	msds_docs\\msds8.docx	2019-06-06
9	2	msds_docs\\msds9.docx	2014-06-27
10	7	msds_docs\\msds10.docx	2019-05-19
11	2	msds_docs\\msds11.docx	2017-03-05
12	15	msds_docs\\msds12.docx	2017-01-07
13	23	msds_docs\\msds13.docx	2013-04-25
14	17	msds_docs\\msds14.docx	2015-11-21
15	18	msds_docs\\msds15.docx	2017-07-07
16	37	msds_docs\\msds16.docx	2015-05-12
17	22	msds_docs\\msds17.docx	2017-07-05
18	10	msds_docs\\msds18.docx	2017-03-07
19	39	msds_docs\\msds19.docx	2017-04-02
20	21	msds_docs\\msds20.docx	2015-04-16
21	40	msds_docs\\msds21.docx	2021-05-03
22	16	msds_docs\\msds22.docx	2020-02-11
23	32	msds_docs\\msds23.docx	2014-02-27
24	29	msds_docs\\msds24.docx	2018-06-02
25	27	msds_docs\\msds25.docx	2019-07-15
26	11	msds_docs\\msds26.docx	2021-06-27
27	18	msds_docs\\msds27.docx	2014-11-23
28	20	msds_docs\\msds28.docx	2018-06-23
29	37	msds_docs\\msds29.docx	2017-01-19
30	16	msds_docs\\msds30.docx	2019-05-23
31	35	msds_docs\\msds31.docx	2015-10-04
32	8	msds_docs\\msds32.docx	2014-06-21
33	25	msds_docs\\msds33.docx	2017-08-21
34	22	msds_docs\\msds34.docx	2013-02-19
35	9	msds_docs\\msds35.docx	2021-09-05
36	28	msds_docs\\msds36.docx	2013-05-03
37	25	msds_docs\\msds37.docx	2020-05-09
38	3	msds_docs\\msds38.docx	2017-07-23
39	19	msds_docs\\msds39.docx	2015-10-18
40	15	msds_docs\\msds40.docx	2018-07-25
41	3	msds_docs\\msds41.docx	2013-06-18
42	1	msds_docs\\msds42.docx	2017-08-07
43	39	msds_docs\\msds43.docx	2014-07-08
44	3	msds_docs\\msds44.docx	2014-02-02
45	24	msds_docs\\msds45.docx	2016-07-16
46	20	msds_docs\\msds46.docx	2019-08-16
47	17	msds_docs\\msds47.docx	2017-11-17
48	27	msds_docs\\msds48.docx	2021-02-07
49	35	msds_docs\\msds49.docx	2018-01-13
50	9	msds_docs\\msds50.docx	2013-08-20
51	24	msds_docs\\msds51.docx	2020-04-04
52	14	msds_docs\\msds52.docx	2014-10-23
53	37	msds_docs\\msds53.docx	2014-05-14
54	40	msds_docs\\msds54.docx	2018-07-25
55	13	msds_docs\\msds55.docx	2013-01-24
56	36	msds_docs\\msds56.docx	2019-04-20
57	39	msds_docs\\msds57.docx	2016-11-27
58	1	msds_docs\\msds58.docx	2013-09-07
59	17	msds_docs\\msds59.docx	2019-03-18
60	13	msds_docs\\msds60.docx	2014-04-25
61	22	msds_docs\\msds61.docx	2019-03-11
62	33	msds_docs\\msds62.docx	2021-03-17
63	21	msds_docs\\msds63.docx	2015-03-09
64	6	msds_docs\\msds64.docx	2016-06-09
65	3	msds_docs\\msds65.docx	2021-05-04
66	39	msds_docs\\msds66.docx	2015-07-26
67	9	msds_docs\\msds67.docx	2014-05-21
68	14	msds_docs\\msds68.docx	2019-02-02
69	16	msds_docs\\msds69.docx	2013-01-08
70	2	msds_docs\\msds70.docx	2020-11-17
71	20	msds_docs\\msds71.docx	2015-07-13
72	37	msds_docs\\msds72.docx	2014-02-21
73	36	msds_docs\\msds73.docx	2014-07-14
74	31	msds_docs\\msds74.docx	2015-07-23
75	15	msds_docs\\msds75.docx	2021-01-01
76	4	msds_docs\\msds76.docx	2020-06-04
77	30	msds_docs\\msds77.docx	2021-11-12
78	5	msds_docs\\msds78.docx	2017-03-16
79	29	msds_docs\\msds79.docx	2021-05-02
80	3	msds_docs\\msds80.docx	2018-01-04
81	13	msds_docs\\msds81.docx	2019-04-26
82	30	msds_docs\\msds82.docx	2017-02-14
83	10	msds_docs\\msds83.docx	2013-04-25
84	13	msds_docs\\msds84.docx	2020-10-23
85	33	msds_docs\\msds85.docx	2021-05-23
86	25	msds_docs\\msds86.docx	2017-07-12
87	17	msds_docs\\msds87.docx	2015-08-21
88	23	msds_docs\\msds88.docx	2020-11-14
89	30	msds_docs\\msds89.docx	2017-02-14
90	35	msds_docs\\msds90.docx	2019-01-08
91	28	msds_docs\\msds91.docx	2018-11-25
92	14	msds_docs\\msds92.docx	2018-10-13
93	13	msds_docs\\msds93.docx	2013-02-22
94	33	msds_docs\\msds94.docx	2016-02-09
95	19	msds_docs\\msds95.docx	2015-07-23
96	21	msds_docs\\msds96.docx	2021-09-15
97	22	msds_docs\\msds97.docx	2016-08-17
98	32	msds_docs\\msds98.docx	2013-08-06
99	12	msds_docs\\msds99.docx	2021-09-23
100	5	msds_docs\\msds100.docx	2021-02-08
\.


--
-- Data for Name: p_statement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.p_statement (code, message) FROM stdin;
P230	Keep wetted with ...
P281	Use personal protective equipment as required.
P251	Do not pierce or burn, even after use.
P315	Get immediate medical advice/attention.
P302+P350	IF ON SKIN: Gently wash with plenty of soap and water.
P103	Read label before use
P364	And wash it before reuse.[Added in 2015 version]
P301	IF SWALLOWED:
P361	Take off immediately all contaminated clothing.
P405	Store locked up.
P285	In case of inadequate ventilation wear respiratory protection.
P302+P352	IF ON SKIN: wash with plenty of water.
P232	Protect from moisture.
P360	Rinse immediately contaminated clothing and skin with plenty of water before removing clothes.
P402+P404	Store in a dry place. Store in a closed container.
P308+P313	IF exposed or concerned: Get medical advice/attention.
P102	Keep out of reach of children.
P235+P410	Keep cool. Protect from sunlight.
P301+P312	IF SWALLOWED: call a POISON CENTER/doctor/... IF you feel unwell.
P302+P334	IF ON SKIN: Immerse in cool water [or wrap in wet bandages].
P322	Specific measures (see ...on this label).
P361+P364	Take off immediately all contaminated clothing and wash it before reuse.
P403+P233	Store in a well-ventilated place. Keep container tightly closed.
P309	IF exposed or if you feel unwell
P309+P311	IF exposed or if you feel unwell: call a POISON CENTER or doctor/physician.
P370+P378	In case of fire: Use ... to extinguish.
P402	Store in a dry place.
P222	Do not allow contact with air.
P302	IF ON SKIN:
P234	Keep only in original container.
P304	IF INHALED:
P337+P313	IF eye irritation persists: Get medical advice/attention.
P307	IF exposed:
P235	Keep cool.
P337	If eye irritation persists:
P374	Fight fire with normal precautions from a reasonable distance.
P407	Maintain air gap between stacks or pallets.
P304+P341	IF INHALED: If breathing is difficult, remove victim to fresh air and keep at rest in a position comfortable for breathing.
P422	Store contents under ...
P304+P312	IF INHALED: Call a POISON CENTER/doctor/... if you feel unwell.
P272	Contaminated work clothing should not be allowed out of the workplace.
P372	Explosion risk.
P313	Get medical advice/attention.
P410+P403	Protect from sunlight. Store in a well-ventilated place.
P333	If skin irritation or rash occurs:
P332	IF SKIN irritation occurs:
P231+P232	Handle under inert gas/... Protect from moisture.
P305	IF IN EYES:
P243	Take precautionary measures against static discharge.
P342	If experiencing respiratory symptoms:
P401	Store in accordance with ...
P240	Ground/bond container and receiving equipment.
P335	Brush off loose particles from skin.
P260	Do not breathe dust/fume/gas/mist/vapors/spray.
P280	Wear protective gloves/protective clothing/eye protection/face protection.
P310	Immediately call a POISON CENTER or doctor/physician.
P340	Remove victim to fresh air and keep at rest in a position comfortable for breathing.
P331	Do NOT induce vomiting.
P308+P311	IF exposed or concerned: Call a POISON CENTER/doctor/...
P411	Store at temperatures not exceeding ... Β°C/...Β°F.
P301+P330+P331	IF SWALLOWED: Rinse mouth. Do NOT induce vomiting.
P303	IF ON SKIN (or hair):
P373	DO NOT fight fire when fire reaches explosives.
P304+P340	IF INHALED: Remove person to fresh air and keep comfortable for breathing.
P332+P313	IF SKIN irritation occurs: Get medical advice/attention.
P502	Refer to manufacturer or supplier for information on recovery or recycling
P352	Wash with plenty of water/...
P306+P360	IF ON CLOTHING: Rinse Immediately contaminated CLOTHING and SKIN with plenty of water before removing clothes.
P301+P310	IF SWALLOWED: Immediately call a POISON CENTER/doctor/...
P202	Do not handle until all safety precautions have been read and understood.
P308	IF exposed or concerned:
P223	Do not allow contact with water.
P284	[In case of inadequate ventilation] Wear respiratory protection.
P501	Dispose of contents/container to ...
P410+P412	Protect from sunlight. Do not expose to temperatures exceeding 50 Β°C/122Β°F.
P242	Use only non-sparking tools.
P263	Avoid contact during pregnancy/while nursing.
P410	Protect from sunlight.
P264	Wash ... thoroughly after handling.
P262	Do not get in eyes, on skin, or on clothing.
P210	Keep away from heat, hot surface, sparks, open flames and other ignition sources. - No smoking.
P390	Absorb spillage to prevent material damage.
P362	Take off contaminated clothing.
P380	Evacuate area.
P271	Use only outdoors or in a well-ventilated area.
P363	Wash contaminated clothing before reuse.
P403	Store in a well-ventilated place.
P306	IF ON CLOTHING:
P273	Avoid release to the environment.
P341	If breathing is difficult, remove victim to fresh air and keep at rest in a position comfortable for breathing.
P351	Rinse cautiously with water for several minutes.
P302+P335+P334	Brush off loose particles from skin. Immerse in cool water [or wrap in wet bandages].
P404	Store in a closed container.
P212	Avoid heating under confinement or reduction of the desensitized agent.
P406	Store in corrosive resistant/... container with a resistant inner liner.
P353	Rinse skin with water [or shower].
P370+P380	In case of fire: Evacuate area.
P333+P313	IF SKIN irritation or rash occurs: Get medical advice/attention.
P282	Wear cold insulating gloves/face shield/eye protection.
P283	Wear fire resistant or flame retardant clothing.
P312	Call a POISON CENTER or doctor/... if you feel unwell.
P244	Keep valves and fittings free from oil and grease.
P371+P380+P375	In case of major fire and large quantities: Evacuate area. Fight fire remotely due to the risk of explosion.
P220	Keep away from clothing and other combustible materials.
P233	Keep container tightly closed.
P307+P311	IF exposed: call a POISON CENTER or doctor/physician.
P334	Immerse in cool water [or wrap in wet bandages].
P314	Get medical advice/attention if you feel unwell.
P303+P361+P353	IF ON SKIN (or hair): Take off Immediately all contaminated clothing. Rinse SKIN with water [or shower].
P377	Leaking gas fire: Do not extinguish, unless leak can be stopped safely.
P403+P235	Store in a well-ventilated place. Keep cool.
P350	Gently wash with plenty of soap and water.
P261	Avoid breathing dust/fume/gas/mist/vapors/spray.
P330	Rinse mouth.
P381	In case of leakage, eliminate all ignition sources.
P342+P311	IF experiencing respiratory symptoms: Call a POISON CENTER/doctor/...
P412	Do not expose to temperatures exceeding 50 Β°C/ 122 Β°F.
P413	Store bulk masses greater than ... kg/...lbs at temperatures not exceeding ... Β°C/...Β°F.
P241	Use explosion-proof [electrical/ventilating/lighting/.../] equipment.
P376	Stop leak if safe to do so.
P101	If medical advice is needed, have product container or label at hand.
P335+P334	Brush off loose particles from skin. Immerse in cool water/wrap in wet bandages.
P370+P380+P375	In case of fire: Evacuate area. Fight fire remotely due to the risk of explosion.
P371	In case of major fire and large quantities:
P411+P235	Store at temperatures not exceeding ... Β°C/...Β°F. Keep cool.
P270	Do not eat, drink or smoke when using this product.
P201	Obtain special instructions before use.
P336	Thaw frosted parts with lukewarm water. Do not rub affected area.
P391	Collect spillage.
P231	Handle under inert gas.
P420	Store separately.
P362+P364	Take off contaminated clothing and wash it before reuse.
P321	Specific treatment (see ... on this label).
P370	In case of fire:
P370+P376	in case of fire: Stop leak if safe to do so.
P211	Do not spray on an open flame or other ignition source.
P311	Call a POISON CENTER or doctor/...
P250	Do not subject to grinding/shock/friction/...
P338	Remove contact lenses, if present and easy to do. Continue rinsing.
P305+P351+P338	IF IN EYES: Rinse cautiously with water for several minutes. Remove contact lenses if present and easy to do - continue rinsing.
P378	Use ... to extinguish.
P320	Specific treatment is urgent (see ... on this label).
P221	Take any precaution to avoid mixing with combustibles/...
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, name, grade, code, category, viscosity, company_id, comment) FROM stdin;
1	pr1	A-B-CC-32	ZINC	4.66	4	6	\N
2	pr2	ISO 46	AA-B-DC-14	OIL	5.06	6	\N
3	pr3	20W	AB-BB-C-33	OIL ISO 220	6.12	3	\N
4	pr4	75W/80	AB-BD-C-55	SPESIAL	0.38	1	\N
5	pr5	85W/140	AA-CC-D-56	HIGH VI  ISO 46	3.46	2	\N
6	pr6	90	AB-CD-C-57	OIL ISO 220	0.53	2	\N
7	pr7	75W/140	AB-CD-C-66	OIL ISO 220	8.85	4	\N
8	pr8	85W/90	AA-C-D-67	OIL ISO 220	9.93	2	\N
9	pr9	85W/90	AB-CC-C-75	OIL	7.48	2	\N
10	pr10	15W/40	AA-D-BB-77	OIL ISO 220	2.31	4	\N
11	pr11	5W/30	AA-CD-FG-43	ZINC	9.28	3	\N
12	pr12	75W/80	BE-B-BB-43	GEAR OIL	4.2	1	\N
13	pr13	10W/60	BB-AA-BE-432	ULTRA	4.75	3	\N
14	pr14	30	BB-AC-GG-532	SUPER	3.7	1	\N
15	pr15	5W/30	BC-GE-533	OIL	8.82	4	\N
16	pr16	ISO 22	BB-FE-EE-522	OIL	5.9	6	\N
17	pr17	5W/30	BE-AS-AS-623	HIGH VI	4.2	3	\N
18	pr18	85W/140	BB-GE-KK-970	MULTI	1.55	5	\N
19	pr19	ISO 320	BE-GG-HE-724	HIGH VI	4.14	6	\N
20	pr20	SAE 20W	BD-GE-HE-513	SPECIAL	5.85	4	\N
21	pr21	10W/60	FB-GE-HE-5362	MULTI	5.12	2	\N
22	pr22	20W	GG-GE-TEWA-523	ULTRA	1.52	4	\N
23	pr23	75W/80	AB-GEE-GE-1612	ULTRA	5.75	2	\N
24	pr24	20W	BD-GG-TEWW-1563	MULTI	6.93	3	\N
25	pr25	30	FD-GE-GGG-326	MULTI	7.19	1	\N
26	pr26	5W/30	FFE-322-DFD-A	SUPER	4.97	6	\N
27	pr27	140	FEW-32-GDE	HIGH VI ZINC	7.54	6	\N
28	pr28	10W/30	FF-TE-ZZ-763	MULTI	3.91	1	\N
29	pr29	20W/30	HE-EWA-AA-146	DIESEL	9.8	3	\N
30	pr30	ISO 680	AA-GE-GH-14466	SUPER	0.71	2	\N
31	pr31	85W/90	GE-HEHE-FE-723	SUPER	8.82	1	\N
32	pr32	20W	FDIB-GE-GEE-3602	ZINC	0.67	3	\N
33	pr33	ISO 46	  	EXTRA	4.82	6	\N
34	pr34	10W30	DFE-BAX-ND-9127	GEAR OIL	2.32	5	\N
35	pr35	85W/140	DD-BD-HH-1363	HIGH VI	8.05	6	\N
36	pr36	ISO 68	BE-GG-VA-1262	GEAR OIL	4.91	1	\N
37	pr37	ISO 680	GG-BB-HEA-0923	HIGH VI	1.44	4	\N
38	pr38	ISO 32	FDE-BED-EHGE-543	GEAR OIL 	2.49	3	\N
39	pr39	10W/30	BEDD-GE-BA-328T	EXTRA	1.56	5	\N
40	pr40	75W/80	FD-GEE-3VS-L322	ZF	1.18	2	\N
\.


--
-- Data for Name: standard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standard (product_id, name) FROM stdin;
31	VOLVO VDS-3
24	ACEA A3/B3-04
22	GUASCOR
38	MB 235.0
35	AFNOR NF E 48 603 HM
28	MAN 271
15	CAT TO-2
17	MAN 271
28	ZF TE-ML 19B
21	MB 229.5
8	MB 229.1
16	NMMA
9	Volvo 97310/97316
26	ISO-L-EGB
40	API GL-4
5	MB 235.8
32	MAN 3275
5	WARTSILA 4T
37	ACEA A2/B2
30	MB 228.1
16	ZF TE ML 09
1	MWM
11	SIS SS 155434
6	API GL-1
18	Deutz DQC I-02
36	ZF TE-ML 16F
14	MB 236.2
14	JASO FC
3	JASO FC
26	SAE-J-1966 MIL-L-6082E
32	ZF TE-ML 17H
12	US STEEL 224
34	ZF TE-ML 14A
7	ACEA E6
2	API GL-4
6	ZF TE-ML 16B/C/D
28	ZF TE-ML 21A
16	ACEA B2
18	EATON VICKERS EH-1027C
7	EATON VICKERS EH-1027C
35	TC-W3
13	TC-W3
38	ZF TE-ML 16D
18	ZF TE-ML 16B
21	ZF TE-ML 10
20	DANA POWERSHIFT
20	ZF TE-ML 12E
30	MB 229.52
1	M.FERGUSON CMS M 1139/1144 & 1145
14	AGMA 250.04
28	HV
15	WAUKESHA
33	ZF TE ML 01/03C/07F
5	HVLP
27	API SG
38	MB 228.1
40	Volvo 97316
26	SEB 181 226
16	ACEA A3/B3-04
14	GUASCOR
22	KOMATSU KES 07.868.1
1	VOLVO VDS
1	ACEA B3
38	MAN 341 Type Z2
38	MACK EO-M PLUS
13	Denison Filterability TP 02100
29	JASO MB T903:2006
35	JASO MA 2
6	ACEA B2
24	JASO MA 2
23	MB 228.51
31	JASO MA 2 T903:2011
20	VDMA 24318
5	ZF TE-ML 06A/B/C &07B
32	API SL/CF
30	CAT ECF-1
21	TEMEC/TTC
29	ACEA C2
38	PSA B712290
34	VOLVO 97335
22	DEUTZ DQC III-05
37	SF TE-ML 07C
40	ACEA A1/B1
40	ZF TE-ML 19C
27	NMMA FC.W
27	VCL
34	WAUKESHA
23	VDL
27	ZF TE ML 09
29	MB 229.52
31	SPERRY VICKERS M-2950-S/I-286-S
5	MB 229.5
14	API CI-4/CH-4/CG-4/CF-4/CF/SL
34	Porsche
16	FORD MERCON
31	VW 501.01
13	API SJ
19	MTU TYPE 2
10	JASO FB
36	MAN 342M-2
39	ISO 6521DAA
5	ZF TE ML 05C/12C/16E
20	DIN 51506 VBL
8	part 2 and 3 HLP
21	US Steel 126/127/136
21	Volvo 97316
31	GM dexos 2
14	KOMATSU KES 07.868.1
5	Sperry Vickers M-2950-S/ I-286-S
16	API CF/CF-2
16	Denison Filterability TP 02100
22	ZF TE-ML 17B
1	ZF TE-ML 21A
16	JASO MA 2
16	MAN 3275
39	ZF TE-ML 08
21	MACK EO-M PLUS
9	BMW LL-04
37	VW502.00
5	VW 501.01/505.00
12	MTU TYPE 1
10	ZF TE-ML 12L
13	API SN/CF
24	DIN 51517 PART 3
31	ZF TE-ML 19B
7	THYSSEN TH N-256132
22	MB 229.1
12	Volvo 97310/97316
32	ISO 6743/4 HM
40	JASO FB
37	ZF TE ML 05C/12C/16E
32	TEMEC/TTC
8	DAVID BROWN S1.53.101
30	VCL
38	part 2 and 3 HLP
30	ZF TE ML 09
21	MB 229.52
7	API GL-4/GL-5/MT-1
1	ACEA E3
11	DRESSER RAND
14	MB 235.0
6	JASO FC
24	DAH
35	DAH
8	AFNOR NF E 48-603 HM
11	MTU
20	ZF TE-ML 21A
30	CUMMINS CES 20 072/1/6/7/8
19	CUMMINS CES 20 072/1/6/7/8
20	ISO 6521DAA
11	part 2 and 3 HLP
30	ACEA B2
10	GM Dexos 2
38	NMMA
21	API CI-4/CH-4/CG-4/CF-4
6	CAT ECF-1-a
33	DEUTZ DQC III-05
26	ZF TE ML 05C/12C/16E
22	API SL
39	part 2 and 3 HLP
1	ACEA A3/B4
20	HV
31	HV
3	MAN 342 Type M2
23	ZF TE ML 05L
19	ACEA A3/B3-04
2	ZF TE-ML 12L
32	DAB
4	CATERPILLAR
12	ZF TE-ML 19B
17	ACEA E7
30	ZF TE-ML 12M
14	MB 229.1
14	ZF TE-ML 16D
3	DRESSER
13	API GL-4
2	ACEA E9-08
12	FORD ESP-M2C166-H
23	FORD ESP-M2C166-H
24	API GL-4
13	ISO 6743/4 HM
4	US Steel 224
26	ZF TE-ML 08A
2	CUMMINS
29	ACEA C3 08
3	MAN DIESEL & TURBO 4T
28	VOITH 55.6335
20	ZF TE-ML 16F
32	ACEA A1/B1
29	SF TE-ML 07C
4	ACEA B3
27	ZF TE-ML 17H
18	US STEEL 224
37	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
5	JASO MB T903:2006
38	ACEA E3/E5/E7/A3/B3
11	CUMMINS CES 20 072/1/6/7/8
24	DAG
8	ACEA A3/B4-04
32	ZF TE-ML 02B
20	Mack EO-K/2
26	API CG-4/SF
8	TC-W3
33	MB 229.1
2	SF TE-ML 07C
33	ALLISON C4
15	ZF TE-ML 12E
7	MB-Approval 235.0
39	JASO MA
37	Voith 3.325-339
19	WARTSILA 4T
15	ZF TE-ML 07A
13	US Steel 126/127/136
32	API CI-4/CH-4/CG-4/CF-4
29	DEXTRON IID
10	SEB 181 226
5	ZF TE-ML 02B
24	DAB
35	DAB
11	FORD M2G 159B/C
29	RENAULT TRUCKS RXD/RGD
40	RENAULT TRUCKS RXD/RGD
19	MAN 3275
30	MAN 3275
15	VDMA 24318
29	VW502.00
28	NIGATA
27	API SL/CF
26	Volvo 97310/97316
30	ACEA A3/B3
25	ACEA C2 08
27	MB 229.5
24	DEXTRON IIIH
2	DEXTRON IID
22	ZF TE-ML 05A
29	JASO MA T903:2006
34	ZF TE-ML 12E
28	AGMA 250.04
18	VDL
24	MB 229.52
22	API CF
10	API GL-4/GL-5/MT-1
20	ALLISON C-4
14	FORD ESP-M2C138-CJ
36	KOMATSU KES 07.868.1
6	MB 235.0
34	MWM
6	SIS SS 155434
38	API CF/CF-2
22	AFNOR NF E 48-603 HM
18	ACEA C3
7	ACEA C3
19	API SJ
18	ZF TE-ML 12E
24	API SF/CD
5	JASO FB
11	WARTSILA 4T
27	US STEEL 126/127/136
27	VW 501.01/505.00
16	US Steel 126/127/136
40	THYSSEN TH N-256132
36	DEUTZ DQC III-05
21	AFNOR NF E 48-603HM
21	DEXTRON IID
27	ZF TE-ML 10
12	ZF TE-ML 16C
16	DAB
39	ACEA E2-96 Issue 5 2007
32	ACEA E9-08
9	JASO FC
5	VW 505.00
8	N.HOLLAND 82009201/2/3
31	ISO /DP 6521 DAA
9	MAN 339 TYPE F
26	ZF TE ML 05L
37	VDL
28	ISO-L-EGD
4	BMW LL-04
14	ML-2105D
32	BMW Longlife 04
9	NIGATA
27	MB 228.51
16	ACEA C2
1	WARTSILA 4T
3	NMMA
6	ZF TE-ML 16D
6	ALLISON C4
27	API GL-4
4	ZF TE-ML 16F
39	MAN 339 TYPE F
10	Voith 3.325-339
35	JASO FB
16	ZF TE-ML 19C
1	ZF TE ML 01/03C/07F
27	TEMEC/TTC
23	ALLISON C-4
12	ALLISON C-4
1	MB 236.2
32	RVI RLD-2
19	DAH
6	MACK EO-M PLUS
35	VW 505.00
12	SEB 181 226
18	VW 501.01
37	VDMA 24318
4	CAT TO-2
27	MIL-PRF-2105E
26	ISO 6521DAA
27	DAG
6	VW 505.01
27	DANA POWERSHIFT
37	MTU TYPE 1
20	SCANIA STO 1:0
28	DEUTZ DQC III-05
33	ZF TE-ML 05A
32	ISO-L-EGB
31	JENBACHER
40	Voith 3.325-339
2	JASO FD
13	CUMMINS
26	ZF TE-ML 08
14	ACEA A3/B3-04
21	API TC
18	ZF TE-ML 19B
31	JASO FC
35	BMW LL-04
3	JOHN DEERE J27
24	API CF
8	API GL-4
30	ISO 6743/4 HM
4	VOLVO 97335
31	NIGATA
13	ACEA C3 08
32	VW 502.00
31	CAT ECF-1-a
9	KOMATSU KES 07.868.1
24	SF TE-ML 07C
5	SAE-J-1966 MIL-L-6082E
11	Sperry Vickers M-2950-S/ I-286-S
21	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
25	MIL-L-2105D
25	API GL-1
33	ACEA E3/E5/E7/A3/B3
25	ML-2105D
7	VW 505.00
30	DAG
19	DAG
20	GUASCOR
26	Mack EO-K/2
18	VW 505.00
33	MB 229.51
10	ACEA C3
12	DIN 51524
10	SCANIA STO 1.0
11	ZF TE-ML 10
2	MCK GO-J
3	WARTSILA 4T
7	HV
3	VW 502.00
4	ISO /DP 6521 DAA
8	US Steel 126/127/136
17	MB 228.1
19	Volvo 97316
24	DEXTRON IID
9	SIS SS 155434
26	API GL-1
3	API CF/CF-2
10	DAF
21	ZF TE-ML 04G
11	ISO 6743/4 HM
16	ACEA E6
2	MB 228.51
6	ML-2105D
7	BMW LL-04
5	THYSSEN TH N-256132
32	API TC
30	ACEA C2
6	ZF TE-ML 05A
21	US STEEL 126/127/136
40	SCANIA STO 1.0
8	ACEA A1/B1
17	API SL
29	ZF TE-ML 12E
13	WAUKESHA
16	API GL-5
6	DAVID BROWN S1.53.101
31	DIN 51517 part III CLP
11	MIL-PRF-2105E
29	MWM
25	ACEA A3/B3-04
20	KOMATSU KES 07.868.1
22	Sperry Vickers M-2950-S/ I-286-S
6	AFNOR NF E 48-603 HM
9	ALLISON C4
33	MAN 3275
3	ZF TE-ML 06A/B/C &07B
39	JASO MB T903:2011
9	MAN DIESEL & TURBO 4T
4	ZF TE ML 01/03C/07F
35	THYSSEN TH N-256132
8	API CI-4/CH-4/CG-4/CF-4
27	ACEA E9-08
11	DAB
38	ACEA A1/B1
4	SEB 181 222
5	API SN/SM/CF
14	N.HOLLAND 82009201/2/3
31	SUFFIX A
7	ZF TE-ML 16B/C/D
36	DAVID BROWN S1.53.101
2	JASO MA 2 T903:2011
23	ISO-L-EGD
11	MACK EO-M PLUS
6	ACEA A3/B3-04
35	API GL-4/GL-5/MT-1
17	FORD ESP-M2C138-CJ
29	SPERRY VICKERS M-2950-S/I-286-S
39	MAN 341 Type Z2
3	API SN/CF
3	ACEA A2
36	AFNOR NF E 48-603 HM
25	TC-W3
2	US Steel 224
27	ACEA E6
21	ACEA C3
25	FORD MERCON
40	VW 501.01
16	JASO MA T903:2006
19	ACEA A2/B2
30	JASO FB
36	CUMMINS CES 20 072/1/6/7/8
24	CAT TO-4
12	KOMATSU KES 07.868.1
21	MAN 342 Type M-1
27	SF TE-ML 07C
9	ZF TE-ML 08
29	API SC/CC
25	API CF/CF-2
5	ZF TE-ML 04G
14	DIN 51517 part III CLP
22	VDL
30	VW 505.00
19	VW 505.00
31	MAN 342 Type M2
22	DANA POWERSHIFT
36	AFNOR NF E 48 603 HM
8	ZF TE-ML 12L
21	JASO MB T903:2006
36	JOHN DEERE J27
29	MAN 271
17	NMMA
17	ZF TE-ML 05A
28	ZF TE-ML 05A
14	ZF TE-ML 10
1	API SL
15	JENBACHER
38	ACEA A2/B2
11	Volvo 97310
6	VW 502.00
28	DAVID BROWN S1.53.101
27	DEXTRON IID
12	SIS SS 155434
21	SPERRY VICKERS M-2950-S/I-286-S
8	DIN 51524 IIHLP
18	ACEA E7
15	SEB 181 222
35	US STEEL 224
13	ZF TE-ML 04G
17	API CF-4/CF/SG
3	API GL-4
14	ISO 6743/4 HM
5	ZF TE-ML 08A
37	MAN 342M-2
17	CUMMINS CES 20 072/1/6/7/8
11	MAN 3477
20	VW 505.01
36	ACEA A3/B4-04
7	VOITH 55.6335
9	part 2 and 3 HLP
17	ACEA B2
19	EATON VICKERS EH-1027C
1	Volvo 97310
26	CAT ECF-1-a
36	MB 235.8
35	MCK GO-J
38	CUMMINS
13	VOLVO VDS-3
28	ACEA A3/B3-04
38	BMW Longlife 04
29	ACEA E3
11	ZF TE-ML 12L
8	CAT TO-2
28	ZF TE-ML 12M
18	DIN 51524
5	SCANIA STO 1.0
30	ISO-L-EGB
6	API SJ
1	MTU TYPE 2
18	JENBACHER
2	HV
38	ACEA C3 08
2	ZF TE-ML 08
9	VCL
11	BMW Longlife 04
2	ACEA E3
14	DAB
12	MAN 341 Type Z2
12	MACK EO-M PLUS
16	US STEEL 224
9	AFNOR NF E 48-603 HM
11	API CF
19	RENAULT TRUCKS RXD/RGD
15	ACEA A2
13	VDL
31	ACEA A3/B4
21	ISO 6521DAA
18	NIGATA
33	DAG
5	MTU TYPE 1
29	Mack EO-K/2
16	US STEEL 126/127/136
3	ACEA A1/B1
16	MCK GO-J
8	JASO MA T903:2006
22	ACEA A2/B2
5	M.FERGUSON CMS M 1139/1144 & 1145
19	ZF TE ML 05C/12C/16E
3	ZF TE-ML 19C
7	AGMA 250.04
30	WAUKESHA
32	DIN 51506 VBL
1	DAVID BROWN S1.53.101
2	ZF TE-ML 14A
16	VOLVO VDS-3
38	DEXTRON IID
14	ZF TE-ML 02B
9	AFNOR NF E 48 603 HM
32	API SC/CC
29	ZF TE-ML 16C
37	SEB 181 222
27	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
17	Denison Filterability TP 02100
14	API SF/CD
4	ZF TE-ML 19B
35	JASO MA 2 T903:2011
31	ML-2105D
36	MB 229.5
30	THYSSEN TH N-256132
33	ACEA C2
24	CATERPILLAR
39	FORD M2G 159B/C
31	NMMA
33	VW 505.01
38	ZF TE ML 05C/12C/16E
3	ACEA C2/C3
13	DENISON
10	ISO /DP 6521 DAA
23	ACEA A3/B4
33	ZF TE-ML 02B
8	API TC
7	API CI-4/CH-4/CG-4/CF-4/CF/SL
9	TC-W3
12	MTU
17	API SJ
28	API SJ
16	DANA POWERSHIFT
25	JASO MB T903:2011
15	VOLVO VDS
28	ZF TE-ML 06A/B/C &07B
9	VW 502.00
23	API SG
20	API GL-5
11	Porsche
32	HV
6	MIL-PRF-2105E
31	ACEA A3/B3-04
15	JASO MB T903:2011
13	MAN 271
22	CAT TO-2
38	API TC
28	ACEA A2
20	FORD M2G 159B/C
7	DEUTZ DQC III-05
34	VOLVO VDS
16	M.FERGUSON CMS M 1139/1144 & 1145
21	VOLVO 97335
16	DENISON
32	POCLAIN
6	Volvo 97316
18	MB 235.0
4	FORD ESP-M2C138-CJ
21	ALLISON C-4
26	MAN 341 Type Z2
17	DAH
17	DIN 51517 part III CLP
38	API SN/SM/CF
15	MACK EO-M PLUS
14	ACEA E6
6	JASO MB T903:2006
1	JASO MA 2
22	RENAULT TRUCKS RXD/RGD
4	MTU TYPE 2
21	JASO MA
14	ACEA C3 08
36	DAG
1	ACEA A3/B3
7	ACEA C2 08
6	ACEA C2
38	ZF TE-ML 24A
27	API CG-4/SF
16	GM dexos 2
22	VOLVO 97335
34	MB 229.1
40	DIN 51524
3	SF TE-ML 07C
3	ZF TE-ML 16B
22	JASO MA T903:2006
8	MB-Approval 235.0
19	MB-Approval 235.0
18	MAN 342 Type M2
35	ZF TE-ML 08
34	MAN DIESEL & TURBO 4T
30	VOLVO VDS-3
23	ACEA A3/B3-04
13	ACEA E3
2	SCANIA STO 1:0
18	MB 229.1
18	ALLISON C4
33	API CF
28	API GL-4
4	ZF TE-ML 05A
1	ZF TE-ML 06A/B/C &07B
26	SPERRY VICKERS M-2950-S/I-286-S
7	MAN DIESEL & TURBO 4T
2	ZF TE ML 01/03C/07F
4	VCL
26	Volvo 97310
24	ZF TE-ML 16F
35	ZF TE-ML 16F
25	MB 2283/229.1
33	ZF TE-ML 14A
40	AGMA 250.04
2	MAN 339 TYPE F
37	MAN 342 Type M2
3	VW502.00
26	DRESSER RAND
38	VOLVO VDS-3
36	ZF TE-ML 02B
12	ACEA A3/B4-04
1	API SN/CF
21	SCANIA STO 1:0
39	Sperry Vickers M-2950-S/ I-286-S
8	ACEA C3
12	FORD MERCON
37	ALLISON C4
7	API SL
19	DANA POWERSHIFT
37	MAN DIESEL & TURBO 4T
30	MWM
4	ACEA A3/B3-04
14	SEB 181 226
16	ACEA E3
13	API GL-1
33	SAE-J-1966 MIL-L-6082E
15	MIL-L-2105D
33	RENAULT TRUCKS RXD/RGD
13	ZF TE-ML 16B/C/D
12	JASO MA 2
5	JASO MA
33	VW502.00
34	ACEA A3/B4
16	BMW LL-04
1	VW 501.01/505.00
30	MTU TYPE 1
22	ZF TE-ML 24A
28	ACEA C2
19	CATERPILLAR
17	DEXTRON IIIH
32	ACEA E7
25	GM Dexos 2
18	Volvo 97310
39	API GL-4
34	MTU
25	RVI RLD-2
37	API SL
22	Voith 3.325-339
21	AGMA 250.04
36	MAN 3477
39	TEMEC/TTC
26	VCL
18	ACEA A3/B4
28	MB 229.52
9	ZF TE-ML 17B
20	DAH
22	US STEEL 224
1	ISO 6743/4 HM
7	MTU
36	VW 505.00
7	Mack EO-K/2
22	SAE J2360
17	API SF/CD
20	US STEEL 126/127/136
32	MB 235.8
32	SCANIA STO 1:0
6	GM Dexos 2
30	GM dexos 2
6	ZF TE-ML 16B
11	MAN 342 Type M-1
26	API GL-5
36	ACEA E9-08
6	RVI RLD-2
3	API SN/SM/CF
14	ZF TE-ML 05A/07A/16B/16C/16D/17B/19B/21A
14	JASO FD
38	M.FERGUSON CMS M 1139/1144 & 1145
12	N.HOLLAND 82009201/2/3
13	ISO /DP 6521 DAA
27	ZF TE-ML 08
19	ZF TE ML 05L
11	JASO MA 2 T903:2011
12	API SL/CF
38	SPERRY VICKERS M-2950-S/I-286-S
36	Deutz DQC I-02
4	ACEA A3/B3
6	CAT TO-2
12	DIN 51517 PART 3
9	HOESCH HWN 233
15	JOHN DEERE J27
30	MAN 271
12	MB 229.5
31	ISO 6743/4 HM
6	ISO-L-EGB
37	MTU
7	ZF TE-ML 05A
37	MTU TYPE 2
37	Mack EO-K/2
10	ACEA A5/B5
29	VOLVO VDS
15	AFNOR NF E 48-603HM
11	DENISON
40	VOLVO VDS
28	MAN 3477
20	TEMEC/TTC
39	M.FERGUSON CMS M 1139/1144 & 1145
5	JASO FC
25	Porsche
14	ZF TE-ML 04G
3	US STEEL 224
21	MWM
16	SEB 181 226
11	VW 501.01
30	ZF TE-ML 21A
9	API SF/CD
16	MAN 342M-2
18	CUMMINS CES 20 072/1/6/7/8
8	VW 505.00
26	ACEA A3/B4-04
40	JASO MB T903:2011
38	MAN 271
20	ZF TE-ML 17B
28	ZF TE-ML 12L
33	ZF TE-ML 24A
35	SCANIA STO 1:0
34	MB 229.51
23	VW 501.01/505.00
24	DIN 51524
13	DIN 51524
37	ZF TE-ML 05A
29	DRESSER
11	API SC/CC
36	ISO-L-EGB
13	ACEA E2-96 Issue 5 2007
9	ACEA C2/C3
28	BMW Longlife 04
17	DIN 51524 IIHLP
6	Porsche
7	ZF TE-ML 12M
22	VDMA 24318
38	ZF TE-ML 21A
33	SAE J2360
8	BMW LL-04
28	ACEA C3 08
16	VOITH 55.6335
36	VOLVO 97335
20	DENISON
17	GM Dexos 2
24	CAT ECF-1-a
36	WAUKESHA
10	ACEA A3/B4
10	DRESSER RAND
1	FORD ESP-M2C166-H
13	GUASCOR
18	ACEA A3/B4-04
6	API TC
23	ZF TE-ML 17B
37	JOHN DEERE J27
14	ACEA C3
16	DIN 51524
9	ML-2105D
34	Denison Filterability TP 02100
14	ZF TE-ML 12E
1	JASO FB
23	MAN 342 Type M-1
34	ACEA A3/B3
23	Volvo 97316
26	JASO FD
40	Volvo 97310
9	BMW Longlife 04
19	API GL-1
8	API GL-1
18	API CF/CF-2
17	SAE-J-1966 MIL-L-6082E
28	SAE-J-1966 MIL-L-6082E
26	N.HOLLAND 82009201/2/3
27	ISO /DP 6521 DAA
10	MIL-L-2105D
34	HVLP
18	ACEA A3/B3
6	ZF TE-ML 24A
23	ACEA C2
14	CATERPILLAR
23	DEXTRON IIIH
11	POCLAIN
3	US Steel 224
10	ZF TE-ML 05A
29	MTU
6	Voith 3.325-339
16	AGMA 250.04
31	MAN 3477
7	HVLP
18	HVLP
4	MIL-PRF-2105E
36	CAT TO-4
5	MB 235.0
14	SPERRY VICKERS M-2950-S/I-286-S
4	DAG
1	DIN 51524 IIHLP
39	RVI RLD-2
14	ACEA B3
15	Sperry Vickers M-2950-S/ I-286-S
36	API SN/SM/CF
33	DAF
34	N.HOLLAND 82009201/2/3
14	VW 501.01
29	MIL-L-2105D
37	JASO MA 2
37	MAN 3275
23	API SF/CD
30	MAN 342M-2
15	US STEEL 126/127/136
33	MTU TYPE 1
27	SCANIA STO 1:0
2	API SG
17	THYSSEN TH N-256132
4	US Steel 126/127/136
27	WARTSILA 4T
4	ACEA A5/B5
35	DEUTZ DQC III-05
33	US Steel 224
32	ALLISON C4
15	ZF TE-ML 10
19	ACEA E3/E5/E7/A3/B3
1	ZF TE-ML 16B
37	ZF TE-ML 17H
19	ISO /DP 6521 DAA
9	RENAULT TRUCKS RXD/RGD
29	NMMA FC.W
35	SUFFIX A
29	DAVID BROWN S1.53.101
40	VCL
14	ZF TE ML 05L
16	ISO-L-EGD
40	API CF
17	API GL-4/GL-5/MT-1
35	SIS SS 155434
38	ALLISON C-4
27	MB 236.2
36	ZF TE-ML 04G
40	API CF-4/CF/SG
21	MTU
14	FORD ESP-M2C166-H
39	RENAULT TRUCKS RXD/RGD
25	SCANIA STO 1.0
32	DEXTRON IIIH
23	ACEA A2/B2
38	JASO MA
4	ZF TE-ML 19C
37	ZF TE-ML 06A/B/C &07B
12	MAN 3477
25	ZF TE-ML 07A
2	DAVID BROWN S1.53.101
20	GM Dexos 2
20	ZF TE-ML 16B
31	ZF TE-ML 16B
22	ZF TE-ML 16F
36	MB-Approval 235.0
2	API CF-4/CF/SG
11	SEB 181 226
15	MIL-PRF-2105E
7	US STEEL 126/127/136
37	API SL/CF
19	SCANIA STO 1:0
23	ZF TE-ML 12L
28	ZF TE-ML 24A
37	API SN/CF
37	DIN 51517 PART 3
40	JOHN DEERE J27
4	API CI-4/CH-4/CG-4/CF-4
29	JOHN DEERE J27
40	MB 229.51
24	ALLISON C4
34	SUFFIX A
25	US Steel 224
8	ACEA E2-96 Issue 5 2007
19	JENBACHER
36	ZF TE-ML 08A
40	AFNOR NF E 48-603HM
15	MAN 342 Type M-1
14	ZF TE-ML 08
13	MAN DIESEL & TURBO 4T
3	ZF TE-ML 08
7	MAN 342 Type M-1
31	DEXTRON IID
32	Volvo 97310
12	Deutz DQC I-02
22	ZF TE-ML 16C
13	MAN 341 Type Z2
35	MAN 341 Type Z2
20	SAE-J-1966 MIL-L-6082E
28	ZF TE-ML 04G
19	MAN 339 TYPE F
25	ZF TE-ML 02B
33	ZF TE-ML 21A
16	VOLVO VDS
16	MB 229.5
31	VW502.00
5	CAT ECF-1
33	VW 505.00
32	FORD ESP-M2C138-CJ
10	ACEA A3/B3
29	ACEA A3/B4-04
16	ACEA C2 08
35	PSA B712290
36	API CG-4/SF
21	ACEA B2
12	RVI RLD-2
17	MB-Approval 235.0
7	MIL-PRF-2105E
39	CAT TO-4
19	GUASCOR
6	ACEA B3
2	FORD MERCON
32	MIL-L-2105D
29	MAN 3275
26	API SF/CD
24	CAT ECF-1
36	MTU TYPE 1
16	MB 228.1
33	POCLAIN
4	Deutz DQC I-02
4	NMMA FC.W
2	API CF/CF-2
3	ZF TE-ML 16B/C/D
29	HVLP
5	ML-2105D
9	SAE J2360
23	VW502.00
24	FORD ESP-M2C138-CJ
26	FORD ESP-M2C166-H
22	ACEA E7
7	HOESCH HWN 233
4	GM Dexos 2
7	VW 505.01
23	JASO MA T903:2006
28	ZF TE-ML 12E
15	ACEA A2/B2
30	API CG-4/SF
12	ZF TE ML 05C/12C/16E
26	MAN 3477
28	ZF TE-ML 07A
24	API SG
37	ACEA A5/B5
23	Porsche
14	JASO MA
14	MAN 342M-2
27	JASO MB T903:2011
21	ACEA A3/B3
40	API SN/CF
37	HOESCH HWN 233
28	JASO MB T903:2006
32	FORD M2G 159B/C
12	THYSSEN TH N-256132
28	US Steel 224
27	DRESSER
22	JENBACHER
7	ACEA C2/C3
17	DENISON
37	MB 229.52
12	API GL-4/GL-5/MT-1
6	ACEA E3
33	ALLISON C-4
16	FORD ESP-M2C138-CJ
14	ACEA E7
23	API TC
34	MB 2283/229.1
19	SIS SS 155434
11	API CI-4/CH-4/CG-4/CF-4/CF/SL
40	Sperry Vickers M-2950-S/ I-286-S
31	US STEEL 224
15	ACEA E6
4	JASO MA T903:2006
4	ZF TE ML 05C/12C/16E
26	ACEA C3 08
15	ACEA C3 08
18	MAN 3477
28	DIN 51506 VBL
40	US STEEL 126/127/136
39	SCANIA STO 1.0
28	API SC/CC
2	DAH
23	API SN/SM/CF
9	DAF
36	HV
8	MAN 342 Type M2
36	ZF TE-ML 08
\.


--
-- Data for Name: substance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substance (id, ec, cas, name, reach, un_number, pbt, last_mod_date, last_check_date, comment) FROM stdin;
1	760-682-8	685237-59-2	"sub1	01-7805728900-37	\N	\N	2016-05-06	2020-10-24	\N
2	833-972-5	116487-84-6	"sub2	01-8817305900-81	UN9003	\N	2021-01-14	2017-07-23	\N
3	462-331-4	43047-64-8	sub3	01-7218897585-29	\N	\N	2016-04-18	2016-07-14	\N
4	203-868-4	730685-47-1	sub4	01-6408809117-11	\N	\N	2016-07-09	2017-06-25	\N
5	327-696-8	286610-20-3	"sub5	01-5558162472-44	\N	\N	2020-06-17	2019-06-20	\N
6	794-389-6	844365-55-3	"sub6	01-6818084331-73	UN3082	\N	2014-08-11	2017-09-01	\N
7	915-223-6	624323-25-5	sub7	01-2818465696-81	UN3082	\N	2015-08-26	2017-02-23	\N
8	524-632-1	857783-29-1	sub8	01-1507368734-37	\N	\N	2014-09-25	2016-11-14	\N
9	338-275-5	80241-92-8	"sub9	01-7096670742-14	\N	\N	2018-01-16	2021-02-03	\N
10	660-477-2	690358-67-7	sub10	01-1905711692-16	\N	\N	2018-04-22	2013-01-13	\N
11	792-923-0	534088-52-8	sub11	01-3766943915-92	UN3082	\N	2013-05-23	2020-07-01	\N
12	363-824-0	809190-40-4	sub12	01-8100333676-67	\N	\N	2014-09-09	2016-11-04	\N
13	294-709-3	320375-21-7	"sub13	01-1076688125-50	\N	\N	2013-01-01	2017-03-17	\N
14	726-367-8	974855-53-8	"sub14	01-6572578401-88	\N	\N	2019-02-19	2018-02-07	\N
15	946-669-1	56572-45-4	"sub15	01-5407951042-13	UN3082	\N	2013-01-22	2015-05-06	\N
16	760-461-6	755028-58-6	sub16	01-4418569662-38	\N	\N	2021-07-12	2021-11-11	\N
17	408-658-8	524562-41-3	sub17	01-7798316597-64	UN2819	\N	2015-08-10	2019-03-26	\N
18	786-614-1	782479-16-6	"sub18	01-8316415398-35	\N	\N	2014-03-20	2021-09-12	\N
19	828-559-4	977263-57-1	sub19	01-6521010309-53	\N	\N	2018-06-25	2016-09-09	\N
20	684-676-3	266487-63-6	sub20	01-2944639599-23	\N	\N	2016-09-01	2014-09-18	\N
21	636-777-6	380683-42-1	sub21	01-6194701207-67	\N	\N	2013-06-27	2021-08-25	\N
22	228-392-1	818913-49-6	"sub22	01-2134945936-60	\N	\N	2014-11-26	2014-09-19	\N
23	335-269-3	69702-46-8	"sub23	01-4061041986-43	UN3082	\N	2019-08-08	2013-08-21	\N
24	914-301-3	503940-36-4	sub24	01-3930345448-92	UN1760	\N	2018-05-15	2020-09-19	\N
25	863-528-6	52044-48-0	sub25	01-7691100125-31	\N	\N	2015-11-20	2018-11-06	\N
26	532-778-0	538512-27-0	sub26	01-2444772690-97	\N	\N	2020-05-15	2020-01-12	\N
27	343-554-8	857196-72-4	"sub27	01-5393170583-70	\N	\N	2015-06-16	2019-11-22	\N
28	488-578-8	858596-46-1	sub28	01-8382442573-78	UN3082	t	2020-10-14	2017-04-26	\N
29	180-158-1	326868-62-1	sub29	01-3290373484-86	\N	\N	2016-10-19	2015-04-16	\N
30	465-517-2	869121-65-8	"sub30	01-7874734361-45	\N	\N	2019-03-17	2018-03-26	\N
31	874-502-2	990906-64-7	sub31	01-8153209739-69	\N	\N	2021-03-11	2016-05-18	\N
32	566-919-2	212306-83-7	sub32	01-1087748521-45	UN2735	\N	2017-10-18	2014-07-15	\N
33	525-728-1	955163-18-6	sub34	01-8818109173-47	UN2735	\N	2018-02-20	2020-07-13	\N
34	138-638-3	108126-41-3	"sub35	01-4186584753-50	\N	\N	2017-05-09	2020-04-19	\N
35	707-322-0	51790-76-2	sub36	01-7869686661-29	UN2922	\N	2020-02-06	2017-09-02	\N
36	710-372-7	920137-24-5	"sub37	01-8859027766-98	\N	\N	2017-03-22	2015-01-07	\N
37	180-469-6	642107-15-5	sub38	01-3380932685-93	\N	\N	2019-03-20	2013-10-17	\N
38	954-544-7	744202-37-6	"sub39	01-6915012152-49	UN1993	\N	2016-09-05	2018-06-03	\N
39	699-757-8	498689-68-6	sub40	01-4936885689-12	UN3145	\N	2019-05-09	2016-03-12	\N
40	432-745-0	81864-42-3	sub41	01-5704661246-19	\N	\N	2015-06-15	2016-06-19	\N
41	534-770-5	496975-20-6	"sub42	01-1253514924-86	UN3082	\N	2013-11-02	2017-01-20	\N
42	944-910-0	650903-11-7	"sub43	01-4437622906-32	\N	\N	2015-05-17	2017-11-08	\N
\.


--
-- Name: additive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.additive_id_seq', 59, true);


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

SELECT pg_catalog.setval('public.msds_msds_no_seq', 105, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 45, true);


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
    ADD CONSTRAINT msds_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

