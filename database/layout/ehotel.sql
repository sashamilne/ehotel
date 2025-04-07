--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Homebrew)
-- Dumped by pg_dump version 14.17 (Homebrew)

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

--
-- Name: ehotelschema; Type: SCHEMA; Schema: -; Owner: sashamilne
--

CREATE SCHEMA ehotelschema;


ALTER SCHEMA ehotelschema OWNER TO sashamilne;

--
-- Name: check_reservation_dates(); Type: FUNCTION; Schema: public; Owner: sashamilne
--

CREATE FUNCTION public.check_reservation_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.date_de_fin <= NEW.date_de_debut THEN
        RAISE EXCEPTION 'La date de fin doit être postérieure à la date de début.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_reservation_dates() OWNER TO sashamilne;

--
-- Name: update_registration_date(); Type: FUNCTION; Schema: public; Owner: sashamilne
--

CREATE FUNCTION public.update_registration_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.date_enregistrement = CURRENT_DATE;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_registration_date() OWNER TO sashamilne;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hotel; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.hotel (
    hotel_id integer NOT NULL,
    chain_id integer NOT NULL,
    hotel_address character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL,
    rating numeric(2,1) NOT NULL,
    manager_id integer
);


ALTER TABLE ehotelschema.hotel OWNER TO sashamilne;

--
-- Name: reservation; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.reservation (
    room_number integer NOT NULL,
    sin integer NOT NULL,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    reservation_date date NOT NULL,
    isrental boolean DEFAULT false,
    balancedue integer,
    hotel_id integer,
    reservation_id integer NOT NULL
);


ALTER TABLE ehotelschema.reservation OWNER TO sashamilne;

--
-- Name: room; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.room (
    room_number integer NOT NULL,
    hotel_id integer NOT NULL,
    room_type character varying(50) NOT NULL,
    price numeric(6,2) NOT NULL,
    capacity integer
);


ALTER TABLE ehotelschema.room OWNER TO sashamilne;

--
-- Name: available_rooms_by_area; Type: VIEW; Schema: ehotelschema; Owner: sashamilne
--

CREATE VIEW ehotelschema.available_rooms_by_area AS
 SELECT h.hotel_address,
    count(*) AS available_rooms
   FROM (ehotelschema.room r
     JOIN ehotelschema.hotel h ON ((r.hotel_id = h.hotel_id)))
  WHERE (NOT (EXISTS ( SELECT 1
           FROM ehotelschema.reservation res
          WHERE ((res.hotel_id = r.hotel_id) AND (res.room_number = r.room_number) AND (CURRENT_DATE < res.check_out_date) AND (CURRENT_DATE >= res.check_in_date)))))
  GROUP BY h.hotel_address;


ALTER TABLE ehotelschema.available_rooms_by_area OWNER TO sashamilne;

--
-- Name: client; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.client (
    sin integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    registration_date date NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL
);


ALTER TABLE ehotelschema.client OWNER TO sashamilne;

--
-- Name: employee; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.employee (
    sin integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    employee_role character varying(50),
    works_at integer,
    email character varying(50),
    phone_number character varying(20)
);


ALTER TABLE ehotelschema.employee OWNER TO sashamilne;

--
-- Name: hotel_chain; Type: TABLE; Schema: ehotelschema; Owner: sashamilne
--

CREATE TABLE ehotelschema.hotel_chain (
    chain_id integer NOT NULL,
    office_address character varying(100) NOT NULL,
    chain_name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL
);


ALTER TABLE ehotelschema.hotel_chain OWNER TO sashamilne;

--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE; Schema: ehotelschema; Owner: sashamilne
--

CREATE SEQUENCE ehotelschema.reservation_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ehotelschema.reservation_reservation_id_seq OWNER TO sashamilne;

--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: ehotelschema; Owner: sashamilne
--

ALTER SEQUENCE ehotelschema.reservation_reservation_id_seq OWNED BY ehotelschema.reservation.reservation_id;


--
-- Name: total_capacity_per_hotel; Type: VIEW; Schema: ehotelschema; Owner: sashamilne
--

CREATE VIEW ehotelschema.total_capacity_per_hotel AS
 SELECT h.hotel_id,
    h.hotel_address,
    sum(r.capacity) AS total_capacity
   FROM (ehotelschema.room r
     JOIN ehotelschema.hotel h ON ((r.hotel_id = h.hotel_id)))
  GROUP BY h.hotel_id, h.hotel_address;


ALTER TABLE ehotelschema.total_capacity_per_hotel OWNER TO sashamilne;

--
-- Name: reservation reservation_id; Type: DEFAULT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.reservation ALTER COLUMN reservation_id SET DEFAULT nextval('ehotelschema.reservation_reservation_id_seq'::regclass);


--
-- Data for Name: client; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.client (sin, first_name, last_name, registration_date, phone_number, email) FROM stdin;
0	sasha	milne	2025-03-30	1234567890	a.sasha.milne@gmail.com
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.employee (sin, first_name, last_name, employee_role, works_at, email, phone_number) FROM stdin;
0	admin	admin	admin	\N	admin@ehotel.ca	1234567890
\.


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.hotel (hotel_id, chain_id, hotel_address, phone_number, email, rating, manager_id) FROM stdin;
0	1	835 Garcia Plaza Suite 842\nSouth Nicoletown, HI 20744	5963608079	lmontoya@example.net	5.0	\N
1	1	51434 Torres Street Apt. 656\nNorth Kristaview, WY 62864	5119969840	olopez@example.net	1.0	\N
2	1	Unit 9121 Box 6533\nDPO AA 87732	2349894563	lorihunter@example.net	1.0	\N
3	1	37393 Anderson Village Apt. 097\nLake Crystalport, TX 08362	4563212665	lcastillo@example.org	3.0	\N
4	1	6659 Stevenson Village\nJenniferfort, GA 72280	2486846195	crice@example.net	4.0	\N
5	1	Unit 5482 Box 0841\nDPO AA 74776	9282007158	davidbradley@example.net	5.0	\N
6	1	8530 Nicole Underpass Suite 331\nEast Josephville, WV 47685	1390618192	davidfisher@example.com	4.0	\N
7	1	84479 Victoria Mountains Apt. 359\nPort Lauraside, NE 05080	3198770287	saundersmelissa@example.org	4.0	\N
8	2	9540 Simmons Haven Apt. 559\nWest Patricia, WY 50395	7560201718	craneluis@example.net	1.0	\N
9	2	5750 Lindsay Prairie Apt. 389\nSouth Michael, MT 06711	8230625048	ericgarrett@example.org	2.0	\N
10	2	61691 Mary Glen\nNorth Taylorstad, VA 30500	5542158462	zsanchez@example.com	5.0	\N
11	2	6050 Jennifer Burg Apt. 450\nRobertland, NH 30481	3546056104	pmontgomery@example.net	1.0	\N
12	2	241 Brian Way Apt. 158\nHarrisbury, MT 60751	3770408072	wwilson@example.org	1.0	\N
13	2	090 Nancy Stream Apt. 126\nNew Lauren, GU 29073	5983033552	codyrodriguez@example.net	4.0	\N
14	2	2328 Wilson Plain\nAmyfort, NY 87499	2975121564	cynthia83@example.net	1.0	\N
15	2	3650 Nelson Route\nNorth Sabrina, IN 77739	7558965046	alexandra94@example.net	2.0	\N
16	3	13297 Jenkins Terrace Apt. 079\nThompsonmouth, DC 69060	1472678369	buckleytrevor@example.org	5.0	\N
17	3	44408 Dennis Manors Apt. 963\nNorth Mauricetown, NV 23825	7657613005	angela98@example.net	2.0	\N
18	3	90960 Baker Crossing Suite 584\nNorth Michael, IA 63430	9832624699	laurencamacho@example.org	2.0	\N
19	3	268 Sarah Island Apt. 882\nEast Kristen, WV 35333	1685708777	lisaprice@example.org	1.0	\N
20	3	27132 Allison Club\nEast Helen, MP 46680	4743679134	changsarah@example.net	3.0	\N
21	3	180 Christopher Keys Suite 162\nWest Veronica, WA 15385	2192973010	brivas@example.net	4.0	\N
22	3	92547 Dickson Course\nNorth Alicia, MS 19353	3615494870	carrillojason@example.com	1.0	\N
23	3	17447 Rogers Viaduct Suite 145\nFrankfurt, MI 42353	7905308363	veronicalopez@example.net	2.0	\N
24	4	3236 Gregory Junctions Apt. 003\nWilliamston, UT 89673	8080821404	adammolina@example.com	3.0	\N
25	4	519 Stephen Skyway Apt. 661\nSouth Matthewton, TN 39057	5009288750	kimberly31@example.net	1.0	\N
26	4	9192 Daniel Ports Suite 619\nSouth Christine, MI 51334	6179698882	hernandezjustin@example.com	1.0	\N
27	4	39938 Barbara Tunnel Suite 468\nWest Stephenville, PR 45393	2974366763	hancockzachary@example.org	1.0	\N
28	4	5638 Mary Field Suite 387\nDavidport, NE 35015	9342986799	msmith@example.org	4.0	\N
29	4	376 Kristin Pine Apt. 042\nMitchellland, PW 69817	9132138624	xle@example.org	3.0	\N
30	4	0987 Williams Ridges Apt. 880\nWest Paul, CT 04458	4227639483	carrollbrooke@example.org	4.0	\N
31	4	017 Victor Park\nGarzaville, GU 72769	3626947390	mwilliams@example.net	3.0	\N
32	5	67511 Gabriel Circles\nLake Fredborough, IL 81511	8169859711	wsheppard@example.com	1.0	\N
33	5	5488 Cardenas Avenue Suite 599\nAmandamouth, AL 85469	4815291337	stephanie81@example.org	2.0	\N
34	5	0302 Anne Crescent\nTranberg, NV 80525	8295190906	sarah61@example.org	4.0	\N
35	5	3575 Aaron Inlet Apt. 475\nSouth Brianshire, MN 91691	6061768099	flopez@example.org	3.0	\N
36	5	027 Garner Lodge Suite 788\nEast Christine, MI 44846	6786661236	patrick93@example.net	2.0	\N
37	5	807 Thomas Road\nNorth Katelynmouth, WY 54019	9649456991	vwatson@example.org	4.0	\N
38	5	932 Livingston Ranch Apt. 404\nEast Bobby, PA 39452	7932278610	msellers@example.org	4.0	\N
39	5	54821 King Roads\nMitchellmouth, NE 38065	6285454302	abigailsmith@example.net	2.0	\N
\.


--
-- Data for Name: hotel_chain; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.hotel_chain (chain_id, office_address, chain_name, phone_number, email) FROM stdin;
1	7750 Wisconsin Ave	Mariott	1234567890	mariott@ehotel.ca
2	1247 Maplewood Drive	Sofitel	2345678901	sofitel@ehotel.ca
3	892 Ocean Breeze Avenue	Nouveautel	3456789012	nouveautel@ehotel.ca
4	3569 Pinecrest Lane	Hilton	4567890123	hilton@ehotel.ca
5	105 Riverbend Road	Westview	5678901234	westview@ehotel.ca
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.reservation (room_number, sin, check_in_date, check_out_date, reservation_date, isrental, balancedue, hotel_id, reservation_id) FROM stdin;
101	0	2025-04-06	2025-04-16	2025-04-06	f	\N	8	2
\.


--
-- Data for Name: room; Type: TABLE DATA; Schema: ehotelschema; Owner: sashamilne
--

COPY ehotelschema.room (room_number, hotel_id, room_type, price, capacity) FROM stdin;
101	8	Deluxe	150.00	\N
1	1	Deluxe Room	156.00	3
2	1	Standard Room	224.00	3
3	1	Standard Room	251.00	2
4	1	Standard Room	274.00	3
5	1	Standard Room	250.00	5
6	2	Suite	159.00	3
7	2	Suite	176.00	3
8	2	Deluxe Room	203.00	4
9	2	Deluxe Room	199.00	3
10	2	Standard Room	193.00	2
11	3	Standard Room	177.00	2
12	3	Deluxe Room	285.00	5
13	3	Deluxe Room	274.00	3
14	3	Standard Room	238.00	2
15	3	Deluxe Room	278.00	4
16	4	Suite	237.00	3
17	4	Deluxe Room	229.00	3
18	4	Deluxe Room	260.00	4
19	4	Deluxe Room	221.00	4
20	4	Standard Room	187.00	4
21	5	Standard Room	242.00	2
22	5	Deluxe Room	171.00	4
23	5	Standard Room	299.00	5
24	5	Deluxe Room	161.00	3
25	5	Suite	194.00	2
26	6	Suite	229.00	5
27	6	Suite	261.00	2
28	6	Suite	251.00	2
29	6	Suite	196.00	5
30	6	Standard Room	165.00	3
31	7	Suite	287.00	5
32	7	Standard Room	208.00	2
33	7	Standard Room	252.00	3
34	7	Deluxe Room	295.00	5
35	7	Standard Room	251.00	2
36	8	Suite	230.00	5
37	8	Standard Room	203.00	3
38	8	Suite	245.00	4
39	8	Deluxe Room	208.00	5
40	8	Standard Room	279.00	4
41	9	Deluxe Room	229.00	3
42	9	Suite	299.00	3
43	9	Standard Room	260.00	2
44	9	Suite	187.00	2
45	9	Deluxe Room	299.00	3
46	10	Suite	182.00	3
47	10	Suite	269.00	2
48	10	Standard Room	270.00	2
49	10	Deluxe Room	227.00	2
50	10	Standard Room	203.00	3
51	11	Suite	158.00	2
52	11	Deluxe Room	257.00	4
53	11	Deluxe Room	219.00	5
54	11	Standard Room	278.00	4
55	11	Deluxe Room	159.00	5
56	12	Suite	188.00	4
57	12	Standard Room	250.00	2
58	12	Deluxe Room	216.00	5
59	12	Suite	293.00	5
60	12	Standard Room	210.00	5
61	13	Deluxe Room	202.00	3
62	13	Suite	173.00	2
63	13	Suite	171.00	3
64	13	Deluxe Room	158.00	5
65	13	Standard Room	208.00	3
66	14	Deluxe Room	199.00	2
67	14	Deluxe Room	174.00	3
68	14	Standard Room	222.00	2
69	14	Deluxe Room	210.00	5
70	14	Standard Room	274.00	5
71	15	Suite	231.00	4
72	15	Deluxe Room	168.00	4
73	15	Standard Room	265.00	5
74	15	Standard Room	199.00	2
75	15	Deluxe Room	172.00	2
76	16	Standard Room	266.00	5
77	16	Suite	162.00	2
78	16	Deluxe Room	281.00	4
79	16	Suite	216.00	2
80	16	Suite	274.00	2
81	17	Suite	265.00	3
82	17	Standard Room	266.00	3
83	17	Suite	212.00	2
84	17	Standard Room	205.00	4
85	17	Deluxe Room	247.00	5
86	18	Standard Room	270.00	2
87	18	Suite	247.00	3
88	18	Deluxe Room	285.00	3
89	18	Standard Room	222.00	4
90	18	Deluxe Room	297.00	2
91	19	Standard Room	283.00	5
92	19	Suite	270.00	4
93	19	Standard Room	170.00	3
94	19	Deluxe Room	291.00	4
95	19	Standard Room	168.00	4
96	20	Deluxe Room	273.00	2
97	20	Standard Room	282.00	2
98	20	Suite	285.00	5
99	20	Suite	163.00	2
100	20	Standard Room	160.00	2
101	21	Suite	151.00	3
102	21	Deluxe Room	155.00	4
103	21	Deluxe Room	196.00	3
104	21	Suite	224.00	2
105	21	Deluxe Room	292.00	4
106	22	Deluxe Room	187.00	3
107	22	Standard Room	179.00	2
108	22	Standard Room	269.00	4
109	22	Deluxe Room	186.00	4
110	22	Suite	282.00	4
111	23	Suite	263.00	5
112	23	Standard Room	219.00	2
113	23	Standard Room	202.00	4
114	23	Deluxe Room	271.00	3
115	23	Suite	272.00	4
116	24	Deluxe Room	269.00	2
117	24	Suite	239.00	3
118	24	Standard Room	153.00	5
119	24	Suite	197.00	4
120	24	Standard Room	286.00	2
121	25	Deluxe Room	288.00	3
122	25	Suite	222.00	4
123	25	Suite	233.00	5
124	25	Standard Room	234.00	2
125	25	Standard Room	227.00	2
126	26	Standard Room	287.00	3
127	26	Standard Room	248.00	4
128	26	Standard Room	228.00	4
129	26	Deluxe Room	229.00	5
130	26	Deluxe Room	281.00	5
131	27	Suite	261.00	2
132	27	Standard Room	204.00	2
133	27	Deluxe Room	247.00	3
134	27	Deluxe Room	263.00	2
135	27	Deluxe Room	277.00	4
136	28	Standard Room	264.00	4
137	28	Deluxe Room	214.00	4
138	28	Suite	299.00	5
139	28	Standard Room	285.00	5
140	28	Standard Room	235.00	2
141	29	Deluxe Room	244.00	3
142	29	Suite	264.00	2
143	29	Suite	265.00	4
144	29	Deluxe Room	244.00	4
145	29	Deluxe Room	263.00	5
146	30	Suite	268.00	4
147	30	Suite	184.00	4
148	30	Deluxe Room	154.00	2
149	30	Suite	198.00	3
150	30	Deluxe Room	267.00	5
151	31	Deluxe Room	208.00	3
152	31	Deluxe Room	259.00	2
153	31	Suite	213.00	4
154	31	Suite	245.00	4
155	31	Suite	173.00	5
156	32	Deluxe Room	205.00	5
157	32	Standard Room	178.00	5
158	32	Deluxe Room	294.00	2
159	32	Suite	173.00	5
160	32	Suite	165.00	2
161	33	Suite	211.00	5
162	33	Suite	286.00	3
163	33	Standard Room	294.00	3
164	33	Suite	176.00	3
165	33	Suite	183.00	2
166	34	Deluxe Room	287.00	3
167	34	Deluxe Room	204.00	5
168	34	Deluxe Room	204.00	4
169	34	Standard Room	213.00	4
170	34	Deluxe Room	293.00	3
171	35	Deluxe Room	256.00	5
172	35	Standard Room	231.00	5
173	35	Standard Room	150.00	3
174	35	Deluxe Room	214.00	2
175	35	Deluxe Room	290.00	5
176	36	Standard Room	174.00	4
177	36	Standard Room	176.00	5
178	36	Deluxe Room	174.00	5
179	36	Suite	244.00	4
180	36	Suite	281.00	2
181	37	Suite	214.00	5
182	37	Deluxe Room	169.00	5
183	37	Deluxe Room	224.00	5
184	37	Deluxe Room	271.00	3
185	37	Deluxe Room	174.00	2
186	38	Deluxe Room	240.00	2
187	38	Deluxe Room	300.00	2
188	38	Standard Room	269.00	2
189	38	Standard Room	174.00	4
190	38	Deluxe Room	155.00	3
191	39	Standard Room	241.00	2
192	39	Suite	163.00	2
193	39	Deluxe Room	206.00	3
194	39	Deluxe Room	219.00	3
195	39	Deluxe Room	154.00	4
196	0	Deluxe Room	231.00	2
197	0	Suite	210.00	5
198	0	Standard Room	231.00	3
199	0	Suite	205.00	4
200	0	Suite	261.00	4
\.


--
-- Name: reservation_reservation_id_seq; Type: SEQUENCE SET; Schema: ehotelschema; Owner: sashamilne
--

SELECT pg_catalog.setval('ehotelschema.reservation_reservation_id_seq', 2, true);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (sin);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (sin);


--
-- Name: hotel_chain hotel_chain_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.hotel_chain
    ADD CONSTRAINT hotel_chain_pkey PRIMARY KEY (chain_id);


--
-- Name: hotel hotel_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (hotel_id);


--
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- Name: room room_pkey; Type: CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (room_number, hotel_id);


--
-- Name: idx_check_in_date; Type: INDEX; Schema: ehotelschema; Owner: sashamilne
--

CREATE INDEX idx_check_in_date ON ehotelschema.reservation USING btree (check_in_date);


--
-- Name: idx_client_email; Type: INDEX; Schema: ehotelschema; Owner: sashamilne
--

CREATE UNIQUE INDEX idx_client_email ON ehotelschema.client USING btree (email);


--
-- Name: idx_room_hotel_id; Type: INDEX; Schema: ehotelschema; Owner: sashamilne
--

CREATE INDEX idx_room_hotel_id ON ehotelschema.room USING btree (hotel_id);


--
-- Name: client update_client_registration; Type: TRIGGER; Schema: ehotelschema; Owner: sashamilne
--

CREATE TRIGGER update_client_registration BEFORE UPDATE ON ehotelschema.client FOR EACH ROW EXECUTE FUNCTION public.update_registration_date();


--
-- Name: reservation validate_reservation_dates; Type: TRIGGER; Schema: ehotelschema; Owner: sashamilne
--

CREATE TRIGGER validate_reservation_dates BEFORE INSERT OR UPDATE ON ehotelschema.reservation FOR EACH ROW EXECUTE FUNCTION public.check_reservation_dates();


--
-- Name: employee employee_works_at_fkey; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.employee
    ADD CONSTRAINT employee_works_at_fkey FOREIGN KEY (works_at) REFERENCES ehotelschema.hotel(hotel_id);


--
-- Name: hotel fk_manager; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES ehotelschema.employee(sin);


--
-- Name: hotel hotel_chain_id_fkey; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.hotel
    ADD CONSTRAINT hotel_chain_id_fkey FOREIGN KEY (chain_id) REFERENCES ehotelschema.hotel_chain(chain_id);


--
-- Name: reservation reservation_room_number_fkey; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_room_number_fkey FOREIGN KEY (room_number, hotel_id) REFERENCES ehotelschema.room(room_number, hotel_id);


--
-- Name: reservation reservation_sin_fkey; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.reservation
    ADD CONSTRAINT reservation_sin_fkey FOREIGN KEY (sin) REFERENCES ehotelschema.client(sin);


--
-- Name: room room_hotel_id_fkey; Type: FK CONSTRAINT; Schema: ehotelschema; Owner: sashamilne
--

ALTER TABLE ONLY ehotelschema.room
    ADD CONSTRAINT room_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES ehotelschema.hotel(hotel_id);


--
-- PostgreSQL database dump complete
--

