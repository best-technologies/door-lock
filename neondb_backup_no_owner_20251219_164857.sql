--
-- PostgreSQL database dump
--

\restrict 2bdVg7MaWhjbcj8r24HhVTNSiENIMefvu7yRJdgHOOegR2cjZNZSYLjdtUgyrOr

-- Dumped from database version 17.7 (bdc8956)
-- Dumped by pg_dump version 17.7 (Homebrew)

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

--
-- Name: AccessMethod; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AccessMethod" AS ENUM (
    'rfid',
    'fingerprint',
    'keypad'
);


--
-- Name: AccessStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AccessStatus" AS ENUM (
    'success',
    'failed'
);


--
-- Name: AttendanceStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AttendanceStatus" AS ENUM (
    'present',
    'absent',
    'late',
    'early_departure',
    'half_day',
    'holiday',
    'weekend'
);


--
-- Name: AttendanceType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AttendanceType" AS ENUM (
    'check_in',
    'check_out'
);


--
-- Name: Department; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Department" AS ENUM (
    'Engineering',
    'HR',
    'Finance',
    'Operations',
    'IT',
    'Sales',
    'Marketing',
    'Administration',
    'Security',
    'Maintenance'
);


--
-- Name: DeviceStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."DeviceStatus" AS ENUM (
    'online',
    'offline'
);


--
-- Name: Gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Gender" AS ENUM (
    'M',
    'F'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'staff',
    'intern',
    'nysc',
    'trainee',
    'admin',
    'contractor',
    'visitor'
);


--
-- Name: UserStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserStatus" AS ENUM (
    'active',
    'suspended',
    'terminated'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: access_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access_logs (
    id text NOT NULL,
    "logId" text NOT NULL,
    "userId" text NOT NULL,
    "deviceId" text NOT NULL,
    method public."AccessMethod" NOT NULL,
    "rfidUid" text,
    "fingerprintId" integer,
    "keypadPin" text,
    status public."AccessStatus" NOT NULL,
    message text,
    "timestamp" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance (
    id text NOT NULL,
    "attendanceId" text NOT NULL,
    "userId" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    "checkIn" timestamp(3) without time zone,
    "checkOut" timestamp(3) without time zone,
    status public."AttendanceStatus" NOT NULL,
    "isWorkingDay" boolean DEFAULT true NOT NULL,
    "isHoliday" boolean DEFAULT false NOT NULL,
    "holidayName" text,
    "minutesLate" integer,
    "minutesEarly" integer,
    "totalHours" double precision,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devices (
    id text NOT NULL,
    "deviceId" text NOT NULL,
    name text NOT NULL,
    location text NOT NULL,
    status public."DeviceStatus" DEFAULT 'offline'::public."DeviceStatus" NOT NULL,
    "firmwareVersion" text,
    "lastSeen" timestamp(3) without time zone,
    settings jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: fingerprint_ids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fingerprint_ids (
    id text NOT NULL,
    "fingerprintId" integer NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.holidays (
    id text NOT NULL,
    name text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    "isRecurring" boolean DEFAULT false NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: password_reset_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_codes (
    id text NOT NULL,
    code text NOT NULL,
    email text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    used boolean DEFAULT false NOT NULL,
    "usedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: profile_pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profile_pictures (
    id text NOT NULL,
    "userId" text NOT NULL,
    "secureUrl" text NOT NULL,
    "publicId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: rfid_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rfid_tags (
    id text NOT NULL,
    tag text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: temporary_access_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temporary_access_codes (
    id text NOT NULL,
    code text NOT NULL,
    "userId" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    used boolean DEFAULT false NOT NULL,
    "usedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    "userId" text NOT NULL,
    "firstName" text NOT NULL,
    "lastName" text NOT NULL,
    email text NOT NULL,
    "phoneNumber" text,
    gender public."Gender",
    "employeeId" text,
    status public."UserStatus" DEFAULT 'active'::public."UserStatus" NOT NULL,
    role public."UserRole" DEFAULT 'staff'::public."UserRole" NOT NULL,
    department text DEFAULT 'Engineering'::text,
    "accessLevel" integer DEFAULT 1 NOT NULL,
    "allowedAccessMethods" public."AccessMethod"[],
    "keypadPin" text,
    password text,
    "lastAccessAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
eedb78ef-17e3-41b8-8a8d-53b893ac1958	adb6369ea55386e6cd02723087e030ef5afd2234718460cf2bfbd096d50ae91e	2025-12-13 15:53:05.161985+00	20251213155302_init	\N	\N	2025-12-13 15:53:03.814835+00	1
\.


--
-- Data for Name: access_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.access_logs (id, "logId", "userId", "deviceId", method, "rfidUid", "fingerprintId", "keypadPin", status, message, "timestamp") FROM stdin;
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.attendance (id, "attendanceId", "userId", date, "checkIn", "checkOut", status, "isWorkingDay", "isHoliday", "holidayName", "minutesLate", "minutesEarly", "totalHours", notes, "createdAt", "updatedAt") FROM stdin;
cmjcoj7e5000bm32fbsbym3ze	ATT-2025-12-19-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-19 00:00:00	2025-12-19 09:41:14.628	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-19 09:41:15.438	2025-12-19 09:41:15.438
cmj8bh1bq0007nk2fd0269sx1	ATT-2025-12-16-cmj6x925s0002vldvclxu8goj	cmj6x925s0002vldvclxu8goj	2025-12-16 00:00:00	2025-12-16 08:24:33.759	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 08:24:34.551	2025-12-16 15:06:50.353
cmj89d3rh0001nk2f5nxvtipe	ATT-2025-12-16-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-16 00:00:00	2025-12-16 07:25:30.989	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 07:25:31.848	2025-12-16 15:20:06.724
cmj4lcnz50003b61q6nn1g7ol	ATT-2025-12-13-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-13 00:00:00	2025-12-13 17:50:01.613	\N	weekend	f	f	\N	\N	\N	\N	\N	2025-12-13 17:50:02.081	2025-12-13 17:50:02.081
cmj4iz8vb0004dc286m3sdmxx	ATT-2025-12-13-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-13 00:00:00	2025-12-13 16:43:35.947	2025-12-13 17:05:41.179	weekend	f	f	\N	\N	\N	\N	\N	2025-12-13 16:43:36.744	2025-12-13 17:55:10.106
cmj6wzj5t0001ck1qmq3outmg	ATT-2025-12-15-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-15 00:00:00	2025-12-15 08:51:16.599	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-15 08:51:17.057	2025-12-15 11:21:25.646
cmj6x5ezn0005ck1q4qvsi9xi	ATT-2025-12-15-cmj6x2vta0001vldvd7tx3dum	cmj6x2vta0001vldvd7tx3dum	2025-12-15 00:00:00	2025-12-15 08:55:50.774	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-15 08:55:51.588	2025-12-15 11:24:15.245
cmj72ixqq0005dx1qqzawje0i	ATT-2025-12-15-cmj72gidd0003vldv1bdrult0	cmj72gidd0003vldv1bdrult0	2025-12-15 00:00:00	2025-12-15 11:26:19.696	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-15 11:26:20.499	2025-12-15 11:26:20.499
cmj6xbk5a0009ck1qle8uf5fn	ATT-2025-12-15-cmj6x925s0002vldvclxu8goj	cmj6x925s0002vldvclxu8goj	2025-12-15 00:00:00	2025-12-15 09:00:37.933	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-15 09:00:38.206	2025-12-15 11:38:27.649
cmja0whg7000unk2fq9opyydr	ATT-2025-12-17-cmj8of5s0000gnk2fbe6ckda1	cmj8of5s0000gnk2fbe6ckda1	2025-12-17 00:00:00	2025-12-17 13:04:11.017	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 13:04:11.864	2025-12-17 13:04:11.864
cmj72bt0u0001dx1qhdmesq9a	ATT-2025-12-15-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-15 00:00:00	2025-12-15 11:20:44.979	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-15 11:20:47.79	2025-12-15 18:18:32.235
cmj9s9vpx000snk2fg7y1fsyy	ATT-2025-12-17-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-17 00:00:00	2025-12-17 09:02:39.496	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 09:02:40.342	2025-12-17 14:33:45.698
cmj8dkveo0009nk2f8sf9e8ly	ATT-2025-12-16-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-16 00:00:00	2025-12-16 09:23:31.91	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 09:23:32.737	2025-12-16 09:23:32.737
cmj8dof5e000enk2feu3ujmxx	ATT-2025-12-16-cmj8dmjd0000ank2fwxqwvgmi	cmj8dmjd0000ank2fwxqwvgmi	2025-12-16 00:00:00	2025-12-16 09:26:18.024	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 09:26:18.291	2025-12-16 09:26:18.291
cmj9ppc3f000mnk2fmmjgaamv	ATT-2025-12-17-cmj6x2vta0001vldvd7tx3dum	cmj6x2vta0001vldvd7tx3dum	2025-12-17 00:00:00	2025-12-17 07:50:41.724	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 07:50:42.555	2025-12-17 14:35:07.712
cmj8amxze0003nk2fub52f3mt	ATT-2025-12-16-cmj6x2vta0001vldvd7tx3dum	cmj6x2vta0001vldvd7tx3dum	2025-12-16 00:00:00	2025-12-16 08:01:09.683	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 08:01:10.538	2025-12-16 10:47:18.642
cmj9pqu3x000onk2fptbhaeza	ATT-2025-12-17-cmj72gidd0003vldv1bdrult0	cmj72gidd0003vldv1bdrult0	2025-12-17 00:00:00	2025-12-17 07:51:52.29	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 07:51:52.558	2025-12-17 14:46:54.4
cmj9q78rd000qnk2ffw913vg0	ATT-2025-12-17-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-17 00:00:00	2025-12-17 08:04:37.227	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 08:04:38.041	2025-12-17 16:34:45.126
cmj8b1bc10005nk2fys37c9fm	ATT-2025-12-16-cmj72gidd0003vldv1bdrult0	cmj72gidd0003vldv1bdrult0	2025-12-16 00:00:00	2025-12-16 08:12:20.236	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 08:12:21.025	2025-12-16 12:01:57.445
cmj8okp7l000knk2ftsu75o0x	ATT-2025-12-16-cmj8of5s0000gnk2fbe6ckda1	cmj8of5s0000gnk2fbe6ckda1	2025-12-16 00:00:00	2025-12-16 14:31:19.668	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-16 14:31:20.481	2025-12-16 14:31:20.481
cmjb5fr8e0001m32f89vtbs7r	ATT-2025-12-18-cmj6x925s0002vldvclxu8goj	cmj6x925s0002vldvclxu8goj	2025-12-18 00:00:00	2025-12-18 07:58:54.815	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-18 07:58:55.646	2025-12-18 13:39:53.489
cmjbcmjz70007m32fmxgqspjv	ATT-2025-12-18-cmj8of5s0000gnk2fbe6ckda1	cmj8of5s0000gnk2fbe6ckda1	2025-12-18 00:00:00	2025-12-18 11:20:09.284	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-18 11:20:10.147	2025-12-18 15:17:50.763
cmjb79iom0005m32fjyzcwi59	ATT-2025-12-18-cmj4iwzdx0000vl0c0gq3elnt	cmj4iwzdx0000vl0c0gq3elnt	2025-12-18 00:00:00	2025-12-18 08:50:03.074	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-18 08:50:03.862	2025-12-18 16:15:13.332
cmjbgegn50009m32fdh4yo3tk	ATT-2025-12-18-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-18 00:00:00	2025-12-18 13:05:50.202	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-18 13:05:51.041	2025-12-18 16:21:21.613
cmjb5rtuq0003m32fg9j8m3p7	ATT-2025-12-18-cmj72gidd0003vldv1bdrult0	cmj72gidd0003vldv1bdrult0	2025-12-18 00:00:00	2025-12-18 08:08:18.086	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-18 08:08:18.914	2025-12-18 16:41:39.144
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devices (id, "deviceId", name, location, status, "firmwareVersion", "lastSeen", settings, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: fingerprint_ids; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fingerprint_ids (id, "fingerprintId", "userId", "createdAt") FROM stdin;
cmj4iywkj0002dc2838k6vzce	2	cmj4iwzdx0000vl0c0gq3elnt	2025-12-13 16:43:20.804
cmj4lc1bi0001b61q107u2fnb	3	cmj4jcwip0001vl0c9nrnnfkj	2025-12-13 17:49:32.718
cmj6x543c0003ck1qvmokufqg	4	cmj6x2vta0001vldvd7tx3dum	2025-12-15 08:55:37.464
cmj6xbaeq0007ck1qsa7zbfc1	5	cmj6x925s0002vldvclxu8goj	2025-12-15 09:00:25.586
cmj72iixq0003dx1qeb4mk69k	6	cmj72gidd0003vldv1bdrult0	2025-12-15 11:26:01.31
cmj8do1vg000cnk2fum7jud5t	7	cmj8dmjd0000ank2fwxqwvgmi	2025-12-16 09:26:01.085
cmj8ojykd000ink2fjrlzfc29	8	cmj8of5s0000gnk2fbe6ckda1	2025-12-16 14:30:45.95
\.


--
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.holidays (id, name, date, "isRecurring", description, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: password_reset_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_codes (id, code, email, "expiresAt", used, "usedAt", "createdAt") FROM stdin;
cmj6wxkqr0000vldvfwptdrmu	580705	maximusz.dev@gmail.com	2025-12-15 09:04:45.793	t	2025-12-15 08:50:21.344	2025-12-15 08:49:45.794
cmj8e3jq2000fnk2f88lipd9w	197351	demruthesther99@gmail.com	2025-12-16 09:53:04.058	t	2025-12-16 09:38:55.887	2025-12-16 09:38:04.059
\.


--
-- Data for Name: profile_pictures; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profile_pictures (id, "userId", "secureUrl", "publicId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: rfid_tags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rfid_tags (id, tag, "userId", "createdAt") FROM stdin;
cmjcpmuya0001vlusd31q35op	73A079F6	cmj4iwzdx0000vl0c0gq3elnt	2025-12-19 10:12:05.554
\.


--
-- Data for Name: temporary_access_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.temporary_access_codes (id, code, "userId", "expiresAt", used, "usedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, "userId", "firstName", "lastName", email, "phoneNumber", gender, "employeeId", status, role, department, "accessLevel", "allowedAccessMethods", "keypadPin", password, "lastAccessAt", "createdAt", "updatedAt") FROM stdin;
cmj4jcwip0001vl0c9nrnnfkj	BTL-25-12-02	Oluwajuwon	Kayode	kayodeoluwajuwon9@gmail.com	08140379737	M	EMP-002	active	intern	IT	1	{rfid,fingerprint}	\N	$2b$10$mmk8pQNVcybsiHrKFbsrV.hh9NTR8IM3myX8SdR10iqm1KFAdS3pm	\N	2025-12-13 16:54:13.921	2025-12-13 16:54:13.921
cmj4iwzdx0000vl0c0gq3elnt	BTL-25-12-01	Maximus	Developer	maximusz.dev@gmail.com	+2348146694787	M	EMP-001	active	admin	Engineering	1	{rfid,fingerprint,keypad}	$2b$10$MmzzuRzETvvNhuCqOn0aJ./Vkyj5p15tgfIV.CFKDoXLniIkeo8Km	$2b$10$QoSnq4.86KwFmvqlphpV2O9AvwLWfw4GG1IMsG30Swi1LRRVV8JNW	\N	2025-12-13 16:41:51.142	2025-12-15 08:50:20.893
cmj6x2vta0001vldvd7tx3dum	BTL-25-12-03	Oluwapelumi	Akindele	akinlumi17@gmail.com	+2348161262061	F	EMP-003	active	nysc	IT	5	{rfid,fingerprint,keypad}	$2b$10$gXKgsphoZEYFvEI9vWXMSO5YJw3Oe4XY2OJd47xZVELeGW3cmomDi	$2b$10$asSllj8Tu14FopyV2dv/wuh1nVQ0ewkhIIS1Xi6.wKu8lVnaVkYyi	\N	2025-12-15 08:53:53.422	2025-12-15 08:53:53.422
cmj6x925s0002vldvclxu8goj	BTL-25-12-04	TGM	Ola	delights40@gmail.com	08133188308	M	EMP-004	active	admin	Marketing	10	{rfid,fingerprint,keypad}	$2b$10$FX88HolQTfytZV1S65vmkupCDjseMCZ2UOz7oPT5huw3.i4PlWELa	$2b$10$6igLncRZgHwetaJghTEmlu3/oP6bq0TWKvLapJC0gwJyTy.jhJ16e	\N	2025-12-15 08:58:41.584	2025-12-15 08:58:41.584
cmj72waeb0004vldv5x0jws63	BTL-25-12-06	Moses	Adetola	nebestpal@gmail.com	08124839200	M	EMP-006	active	admin	Operations	10	{rfid,fingerprint,keypad}	$2b$10$QU0jKP2yexMJKUUbuxzYludpiUl9/hzDDn4VF0cw1ct.uIj9tc8LW	$2b$10$hm5RYq.2O3PG8DZ4B0ns5u/1Fo9YmAgyMOWSruowI9N3c.Ij6rqHu	\N	2025-12-15 11:36:43.427	2025-12-15 11:36:43.427
cmj72gidd0003vldv1bdrult0	BTL-25-12-05	Esther O'funmi	Bangboje	demruthesther99@gmail.com	+2349024031799	F	EMP-005	active	admin	Administration	10	{rfid,fingerprint,keypad}	$2b$10$wmSwrEfv4gNZaMTVOmX2AOuJzGMEwyWmL057w7eDMY1HktjhhF9wu	$2b$10$jPLBj0NKeZUi5LuZMWwzIejjelEBmmlkS2Yoc4tCpY3ps3z/qMy3m	\N	2025-12-15 11:24:27.265	2025-12-16 09:38:55.717
cmj8dmjd0000ank2fwxqwvgmi	BTL-25-12-07	Olayemi	Awofe	awofe16@gmail.com	07053971464	M	EMP-007	active	nysc	IT	10	{rfid,fingerprint,keypad}	$2b$10$oqfBdsKHBBQtg/dmrJKqae2TmdfvA1liJZE1Q5UtEcNMS5151HUlm	$2b$10$iLnFYaae0Dmlv953sw9Cp.CYa/8fmFLzKt8D/W8HJl1.VIuqT/rUK	\N	2025-12-16 09:24:50.437	2025-12-16 09:46:33.016
cmj8of5s0000gnk2fbe6ckda1	BTL-25-12-08	Adedapo	Gbadega	md@accessible.com	+2348146694787	M	EMP-008	active	admin	Administration	1	{rfid,fingerprint}	\N	$2b$10$4Yuh9oeWS3x2EXPwTgmfUOR985dkTm5F0XQYToGwIu5VJkH4KLz2i	\N	2025-12-16 14:27:02.017	2025-12-16 14:27:02.017
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: access_logs access_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT access_logs_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: fingerprint_ids fingerprint_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fingerprint_ids
    ADD CONSTRAINT fingerprint_ids_pkey PRIMARY KEY (id);


--
-- Name: holidays holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: password_reset_codes password_reset_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_codes
    ADD CONSTRAINT password_reset_codes_pkey PRIMARY KEY (id);


--
-- Name: profile_pictures profile_pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_pictures
    ADD CONSTRAINT profile_pictures_pkey PRIMARY KEY (id);


--
-- Name: rfid_tags rfid_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rfid_tags
    ADD CONSTRAINT rfid_tags_pkey PRIMARY KEY (id);


--
-- Name: temporary_access_codes temporary_access_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_access_codes
    ADD CONSTRAINT temporary_access_codes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: access_logs_deviceId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "access_logs_deviceId_idx" ON public.access_logs USING btree ("deviceId");


--
-- Name: access_logs_logId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "access_logs_logId_key" ON public.access_logs USING btree ("logId");


--
-- Name: access_logs_method_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_logs_method_idx ON public.access_logs USING btree (method);


--
-- Name: access_logs_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_logs_status_idx ON public.access_logs USING btree (status);


--
-- Name: access_logs_timestamp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_logs_timestamp_idx ON public.access_logs USING btree ("timestamp");


--
-- Name: access_logs_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "access_logs_userId_idx" ON public.access_logs USING btree ("userId");


--
-- Name: attendance_attendanceId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "attendance_attendanceId_key" ON public.attendance USING btree ("attendanceId");


--
-- Name: attendance_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_date_idx ON public.attendance USING btree (date);


--
-- Name: attendance_isHoliday_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "attendance_isHoliday_idx" ON public.attendance USING btree ("isHoliday");


--
-- Name: attendance_isWorkingDay_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "attendance_isWorkingDay_idx" ON public.attendance USING btree ("isWorkingDay");


--
-- Name: attendance_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_status_idx ON public.attendance USING btree (status);


--
-- Name: attendance_userId_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "attendance_userId_date_idx" ON public.attendance USING btree ("userId", date);


--
-- Name: attendance_userId_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "attendance_userId_date_key" ON public.attendance USING btree ("userId", date);


--
-- Name: attendance_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "attendance_userId_idx" ON public.attendance USING btree ("userId");


--
-- Name: devices_deviceId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "devices_deviceId_idx" ON public.devices USING btree ("deviceId");


--
-- Name: devices_deviceId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "devices_deviceId_key" ON public.devices USING btree ("deviceId");


--
-- Name: devices_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX devices_status_idx ON public.devices USING btree (status);


--
-- Name: fingerprint_ids_fingerprintId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fingerprint_ids_fingerprintId_idx" ON public.fingerprint_ids USING btree ("fingerprintId");


--
-- Name: fingerprint_ids_fingerprintId_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "fingerprint_ids_fingerprintId_userId_key" ON public.fingerprint_ids USING btree ("fingerprintId", "userId");


--
-- Name: fingerprint_ids_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fingerprint_ids_userId_idx" ON public.fingerprint_ids USING btree ("userId");


--
-- Name: holidays_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX holidays_date_idx ON public.holidays USING btree (date);


--
-- Name: holidays_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX holidays_date_key ON public.holidays USING btree (date);


--
-- Name: holidays_isRecurring_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "holidays_isRecurring_idx" ON public.holidays USING btree ("isRecurring");


--
-- Name: password_reset_codes_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX password_reset_codes_code_idx ON public.password_reset_codes USING btree (code);


--
-- Name: password_reset_codes_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX password_reset_codes_code_key ON public.password_reset_codes USING btree (code);


--
-- Name: password_reset_codes_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX password_reset_codes_email_idx ON public.password_reset_codes USING btree (email);


--
-- Name: password_reset_codes_expiresAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "password_reset_codes_expiresAt_idx" ON public.password_reset_codes USING btree ("expiresAt");


--
-- Name: password_reset_codes_used_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX password_reset_codes_used_idx ON public.password_reset_codes USING btree (used);


--
-- Name: profile_pictures_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "profile_pictures_userId_key" ON public.profile_pictures USING btree ("userId");


--
-- Name: rfid_tags_tag_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rfid_tags_tag_idx ON public.rfid_tags USING btree (tag);


--
-- Name: rfid_tags_tag_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "rfid_tags_tag_userId_key" ON public.rfid_tags USING btree (tag, "userId");


--
-- Name: rfid_tags_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "rfid_tags_userId_idx" ON public.rfid_tags USING btree ("userId");


--
-- Name: temporary_access_codes_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX temporary_access_codes_code_idx ON public.temporary_access_codes USING btree (code);


--
-- Name: temporary_access_codes_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX temporary_access_codes_code_key ON public.temporary_access_codes USING btree (code);


--
-- Name: temporary_access_codes_expiresAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "temporary_access_codes_expiresAt_idx" ON public.temporary_access_codes USING btree ("expiresAt");


--
-- Name: temporary_access_codes_used_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX temporary_access_codes_used_idx ON public.temporary_access_codes USING btree (used);


--
-- Name: temporary_access_codes_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "temporary_access_codes_userId_idx" ON public.temporary_access_codes USING btree ("userId");


--
-- Name: users_accessLevel_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_accessLevel_idx" ON public.users USING btree ("accessLevel");


--
-- Name: users_department_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_department_idx ON public.users USING btree (department);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_email_idx ON public.users USING btree (email);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_employeeId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "users_employeeId_key" ON public.users USING btree ("employeeId");


--
-- Name: users_role_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_role_createdAt_idx" ON public.users USING btree (role, "createdAt");


--
-- Name: users_role_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_role_idx ON public.users USING btree (role);


--
-- Name: users_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_status_idx ON public.users USING btree (status);


--
-- Name: users_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_userId_idx" ON public.users USING btree ("userId");


--
-- Name: users_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "users_userId_key" ON public.users USING btree ("userId");


--
-- Name: access_logs access_logs_deviceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT "access_logs_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES public.devices(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: access_logs access_logs_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT "access_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance attendance_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "attendance_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fingerprint_ids fingerprint_ids_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fingerprint_ids
    ADD CONSTRAINT "fingerprint_ids_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_pictures profile_pictures_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_pictures
    ADD CONSTRAINT "profile_pictures_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rfid_tags rfid_tags_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rfid_tags
    ADD CONSTRAINT "rfid_tags_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: temporary_access_codes temporary_access_codes_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_access_codes
    ADD CONSTRAINT "temporary_access_codes_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 2bdVg7MaWhjbcj8r24HhVTNSiENIMefvu7yRJdgHOOegR2cjZNZSYLjdtUgyrOr

