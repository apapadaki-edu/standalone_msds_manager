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

