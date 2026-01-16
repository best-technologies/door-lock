--
-- PostgreSQL database dump
--

\restrict f1ujf0zlemkgeYvoCsX5vdP4c06FT1lwtgpajk1Bx2678C1NqQo95xEAJKCkK0i

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
cmj9q78rd000qnk2ffw913vg0	ATT-2025-12-17-cmj4jcwip0001vl0c9nrnnfkj	cmj4jcwip0001vl0c9nrnnfkj	2025-12-17 00:00:00	2025-12-17 08:04:37.227	\N	half_day	t	f	\N	\N	\N	\N	\N	2025-12-17 08:04:38.041	2025-12-