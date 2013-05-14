\W
DROP TABLE IF EXISTS MRCOC;
CREATE TABLE MRCOC (
    CUI1	char(8) NOT NULL,
    AUI1	varchar(9) NOT NULL,
    CUI2	char(8),
    AUI2	varchar(9),
    SAB	varchar(20) NOT NULL,
    COT	varchar(3) NOT NULL,
    COF	int unsigned,
    COA	text,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRCOC.RRF' into table MRCOC fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui1,@aui1,@cui2,@aui2,@sab,@cot,@cof,@coa,@cvf)
SET CUI1 = @cui1,
AUI1 = @aui1,
CUI2 = NULLIF(@cui2,''),
AUI2 = NULLIF(@aui2,''),
SAB = @sab,
COT = @cot,
COF = NULLIF(@cof,''),
COA = NULLIF(@coa,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRCOLS;
CREATE TABLE MRCOLS (
    COL	varchar(20),
    DES	varchar(200),
    REF	varchar(20),
    MIN	int unsigned,
    AV	numeric(5,2),
    MAX	int unsigned,
    FIL	varchar(50),
    DTY	varchar(20)
) CHARACTER SET utf8;

load data local infile 'MRCOLS.RRF' into table MRCOLS fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@col,@des,@ref,@min,@av,@max,@fil,@dty)
SET COL = NULLIF(@col,''),
DES = NULLIF(@des,''),
REF = NULLIF(@ref,''),
MIN = NULLIF(@min,''),
AV = NULLIF(@av,''),
MAX = NULLIF(@max,''),
FIL = NULLIF(@fil,''),
DTY = NULLIF(@dty,'');

DROP TABLE IF EXISTS MRCONSO;
CREATE TABLE MRCONSO (
    CUI	char(8) NOT NULL,
    LAT	char(3) NOT NULL,
    TS	char(1) NOT NULL,
    LUI	varchar(10) NOT NULL,
    STT	varchar(3) NOT NULL,
    SUI	varchar(10) NOT NULL,
    ISPREF	char(1) NOT NULL,
    AUI	varchar(9) NOT NULL,
    SAUI	varchar(50),
    SCUI	varchar(50),
    SDUI	varchar(50),
    SAB	varchar(20) NOT NULL,
    TTY	varchar(20) NOT NULL,
    CODE	varchar(50) NOT NULL,
    STR	text NOT NULL,
    SRL	int unsigned NOT NULL,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRCONSO.RRF' into table MRCONSO fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@lat,@ts,@lui,@stt,@sui,@ispref,@aui,@saui,@scui,@sdui,@sab,@tty,@code,@str,@srl,@suppress,@cvf)
SET CUI = @cui,
LAT = @lat,
TS = @ts,
LUI = @lui,
STT = @stt,
SUI = @sui,
ISPREF = @ispref,
AUI = @aui,
SAUI = NULLIF(@saui,''),
SCUI = NULLIF(@scui,''),
SDUI = NULLIF(@sdui,''),
SAB = @sab,
TTY = @tty,
CODE = @code,
STR = @str,
SRL = @srl,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRCUI;
CREATE TABLE MRCUI (
    CUI1	char(8) NOT NULL,
    VER	varchar(10) NOT NULL,
    REL	varchar(4) NOT NULL,
    RELA	varchar(100),
    MAPREASON	text,
    CUI2	char(8),
    MAPIN	char(1)
) CHARACTER SET utf8;

load data local infile 'MRCUI.RRF' into table MRCUI fields terminated by '|' lines terminated by '\n'
(@cui1,@ver,@rel,@rela,@mapreason,@cui2,@mapin)
SET CUI1 = @cui1,
VER = @ver,
REL = @rel,
RELA = NULLIF(@rela,''),
MAPREASON = NULLIF(@mapreason,''),
CUI2 = NULLIF(@cui2,''),
MAPIN = NULLIF(@mapin,'');

DROP TABLE IF EXISTS MRCXT;
CREATE TABLE MRCXT (
    CUI	char(8),
    SUI	varchar(10),
    AUI	varchar(9),
    SAB	varchar(20),
    CODE	varchar(50),
    CXN	int unsigned,
    CXL	char(3),
    RANK	int unsigned,
    CXS	text,
    CUI2	char(8),
    AUI2	varchar(9),
    HCD	varchar(50),
    RELA	varchar(100),
    XC	varchar(1),
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRCXT.RRF' into table MRCXT fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@sui,@aui,@sab,@code,@cxn,@cxl,@rank,@cxs,@cui2,@aui2,@hcd,@rela,@xc,@cvf)
SET CUI = NULLIF(@cui,''),
SUI = NULLIF(@sui,''),
AUI = NULLIF(@aui,''),
SAB = NULLIF(@sab,''),
CODE = NULLIF(@code,''),
CXN = NULLIF(@cxn,''),
CXL = NULLIF(@cxl,''),
RANK = NULLIF(@rank,''),
CXS = NULLIF(@cxs,''),
CUI2 = NULLIF(@cui2,''),
AUI2 = NULLIF(@aui2,''),
HCD = NULLIF(@hcd,''),
RELA = NULLIF(@rela,''),
XC = NULLIF(@xc,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRDEF;
CREATE TABLE MRDEF (
    CUI	char(8) NOT NULL,
    AUI	varchar(9) NOT NULL,
    ATUI	varchar(11) NOT NULL,
    SATUI	varchar(50),
    SAB	varchar(20) NOT NULL,
    DEF	text NOT NULL,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRDEF.RRF' into table MRDEF fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@aui,@atui,@satui,@sab,@def,@suppress,@cvf)
SET CUI = @cui,
AUI = @aui,
ATUI = @atui,
SATUI = NULLIF(@satui,''),
SAB = @sab,
DEF = @def,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRDOC;
CREATE TABLE MRDOC (
    DOCKEY	varchar(50) NOT NULL,
    VALUE	varchar(200),
    TYPE	varchar(50) NOT NULL,
    EXPL	text
) CHARACTER SET utf8;

load data local infile 'MRDOC.RRF' into table MRDOC fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@dockey,@value,@type,@expl)
SET DOCKEY = @dockey,
VALUE = NULLIF(@value,''),
TYPE = @type,
EXPL = NULLIF(@expl,'');

DROP TABLE IF EXISTS MRFILES;
CREATE TABLE MRFILES (
    FIL	varchar(50),
    DES	varchar(200),
    FMT	text,
    CLS	int unsigned,
    RWS	int unsigned,
    BTS	bigint
) CHARACTER SET utf8;

load data local infile 'MRFILES.RRF' into table MRFILES fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@fil,@des,@fmt,@cls,@rws,@bts)
SET FIL = NULLIF(@fil,''),
DES = NULLIF(@des,''),
FMT = NULLIF(@fmt,''),
CLS = NULLIF(@cls,''),
RWS = NULLIF(@rws,''),
BTS = NULLIF(@bts,'');

DROP TABLE IF EXISTS MRHIER;
CREATE TABLE MRHIER (
    CUI	char(8) NOT NULL,
    AUI	varchar(9) NOT NULL,
    CXN	int unsigned NOT NULL,
    PAUI	varchar(10),
    SAB	varchar(20) NOT NULL,
    RELA	varchar(100),
    PTR	text,
    HCD	varchar(50),
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRHIER.RRF' into table MRHIER fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@aui,@cxn,@paui,@sab,@rela,@ptr,@hcd,@cvf)
SET CUI = @cui,
AUI = @aui,
CXN = @cxn,
PAUI = NULLIF(@paui,''),
SAB = @sab,
RELA = NULLIF(@rela,''),
PTR = NULLIF(@ptr,''),
HCD = NULLIF(@hcd,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRHIST;
CREATE TABLE MRHIST (
    CUI	char(8),
    SOURCEUI	varchar(50),
    SAB	varchar(20),
    SVER	varchar(20),
    CHANGETYPE	text,
    CHANGEKEY	text,
    CHANGEVAL	text,
    REASON	text,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRHIST.RRF' into table MRHIST fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@sourceui,@sab,@sver,@changetype,@changekey,@changeval,@reason,@cvf)
SET CUI = NULLIF(@cui,''),
SOURCEUI = NULLIF(@sourceui,''),
SAB = NULLIF(@sab,''),
SVER = NULLIF(@sver,''),
CHANGETYPE = NULLIF(@changetype,''),
CHANGEKEY = NULLIF(@changekey,''),
CHANGEVAL = NULLIF(@changeval,''),
REASON = NULLIF(@reason,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRMAP;
CREATE TABLE MRMAP (
    MAPSETCUI	char(8) NOT NULL,
    MAPSETSAB	varchar(20) NOT NULL,
    MAPSUBSETID	varchar(10),
    MAPRANK	int unsigned,
    MAPID	varchar(50) NOT NULL,
    MAPSID	varchar(50),
    FROMID	varchar(50) NOT NULL,
    FROMSID	varchar(50),
    FROMEXPR	text NOT NULL,
    FROMTYPE	varchar(50) NOT NULL,
    FROMRULE	text,
    FROMRES	text,
    REL	varchar(4) NOT NULL,
    RELA	varchar(100),
    TOID	varchar(50),
    TOSID	varchar(50),
    TOEXPR	text,
    TOTYPE	varchar(50),
    TORULE	text,
    TORES	text,
    MAPRULE	text,
    MAPRES	text,
    MAPTYPE	varchar(50),
    MAPATN	varchar(100),
    MAPATV	text,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRMAP.RRF' into table MRMAP fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@mapsetcui,@mapsetsab,@mapsubsetid,@maprank,@mapid,@mapsid,@fromid,@fromsid,@fromexpr,@fromtype,@fromrule,@fromres,@rel,@rela,@toid,@tosid,@toexpr,@totype,@torule,@tores,@maprule,@mapres,@maptype,@mapatn,@mapatv,@cvf)
SET MAPSETCUI = @mapsetcui,
MAPSETSAB = @mapsetsab,
MAPSUBSETID = NULLIF(@mapsubsetid,''),
MAPRANK = NULLIF(@maprank,''),
MAPID = @mapid,
MAPSID = NULLIF(@mapsid,''),
FROMID = @fromid,
FROMSID = NULLIF(@fromsid,''),
FROMEXPR = @fromexpr,
FROMTYPE = @fromtype,
FROMRULE = NULLIF(@fromrule,''),
FROMRES = NULLIF(@fromres,''),
REL = @rel,
RELA = NULLIF(@rela,''),
TOID = @toid,
TOSID = NULLIF(@tosid,''),
TOEXPR = @toexpr,
TOTYPE = @totype,
TORULE = NULLIF(@torule,''),
TORES = NULLIF(@tores,''),
MAPRULE = NULLIF(@maprule,''),
MAPRES = NULLIF(@mapres,''),
MAPTYPE = @maptype,
MAPATN = NULLIF(@mapatn,''),
MAPATV = NULLIF(@mapatv,''),
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRRANK;
CREATE TABLE MRRANK (
    RANK	int unsigned NOT NULL,
    SAB	varchar(20) NOT NULL,
    TTY	varchar(20) NOT NULL,
    SUPPRESS	char(1) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRRANK.RRF' into table MRRANK fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@rank,@sab,@tty,@suppress)
SET RANK = @rank,
SAB = @sab,
TTY = @tty,
SUPPRESS = @suppress;

DROP TABLE IF EXISTS MRREL;
CREATE TABLE MRREL (
    CUI1	char(8) NOT NULL,
    AUI1	varchar(9),
    STYPE1	varchar(50) NOT NULL,
    REL	varchar(4) NOT NULL,
    CUI2	char(8) NOT NULL,
    AUI2	varchar(9),
    STYPE2	varchar(50) NOT NULL,
    RELA	varchar(100),
    RUI	varchar(10) NOT NULL,
    SRUI	varchar(50),
    SAB	varchar(20) NOT NULL,
    SL	varchar(20) NOT NULL,
    RG	varchar(10),
    DIR	varchar(1),
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRREL.RRF' into table MRREL fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui1,@aui1,@stype1,@rel,@cui2,@aui2,@stype2,@rela,@rui,@srui,@sab,@sl,@rg,@dir,@suppress,@cvf)
SET CUI1 = @cui1,
AUI1 = NULLIF(@aui1,''),
STYPE1 = @stype1,
REL = @rel,
CUI2 = @cui2,
AUI2 = NULLIF(@aui2,''),
STYPE2 = @stype2,
RELA = NULLIF(@rela,''),
RUI = @rui,
SRUI = NULLIF(@srui,''),
SAB = @sab,
SL = @sl,
RG = NULLIF(@rg,''),
DIR = NULLIF(@dir,''),
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRSAB;
CREATE TABLE MRSAB (
    VCUI	char(8),
    RCUI	char(8),
    VSAB	varchar(20) NOT NULL,
    RSAB	varchar(20) NOT NULL,
    SON	text NOT NULL,
    SF	varchar(20) NOT NULL,
    SVER	varchar(20),
    VSTART	char(8),
    VEND	char(8),
    IMETA	varchar(10) NOT NULL,
    RMETA	varchar(10),
    SLC	text,
    SCC	text,
    SRL	int unsigned NOT NULL,
    TFR	int unsigned,
    CFR	int unsigned,
    CXTY	varchar(50),
    TTYL	varchar(400),
    ATNL	text,
    LAT	char(3),
    CENC	varchar(20) NOT NULL,
    CURVER	char(1) NOT NULL,
    SABIN	char(1) NOT NULL,
    SSN	text NOT NULL,
    SCIT	text NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRSAB.RRF' into table MRSAB fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@vcui,@rcui,@vsab,@rsab,@son,@sf,@sver,@vstart,@vend,@imeta,@rmeta,@slc,@scc,@srl,@tfr,@cfr,@cxty,@ttyl,@atnl,@lat,@cenc,@curver,@sabin,@ssn,@scit)
SET VCUI = NULLIF(@vcui,''),
RCUI = @rcui,
VSAB = @vsab,
RSAB = @rsab,
SON = @son,
SF = @sf,
SVER = NULLIF(@sver,''),
VSTART = NULLIF(@vstart,''),
VEND = NULLIF(@vend,''),
IMETA = @imeta,
RMETA = NULLIF(@rmeta,''),
SLC = NULLIF(@slc,''),
SCC = NULLIF(@scc,''),
SRL = @srl,
TFR = NULLIF(@tfr,''),
CFR = NULLIF(@cfr,''),
CXTY = NULLIF(@cxty,''),
TTYL = NULLIF(@ttyl,''),
ATNL = NULLIF(@atnl,''),
LAT = NULLIF(@lat,''),
CENC = @cenc,
CURVER = @curver,
SABIN = @sabin,
SSN = @ssn,
SCIT = @scit;

DROP TABLE IF EXISTS MRSAT;
CREATE TABLE MRSAT (
    CUI	char(8) NOT NULL,
    LUI	varchar(10),
    SUI	varchar(10),
    METAUI	varchar(50),
    STYPE	varchar(50) NOT NULL,
    CODE	varchar(50),
    ATUI	varchar(11) NOT NULL,
    SATUI	varchar(50),
    ATN	varchar(100) NOT NULL,
    SAB	varchar(20) NOT NULL,
    ATV	text,
    SUPPRESS	char(1) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRSAT.RRF' into table MRSAT fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@lui,@sui,@metaui,@stype,@code,@atui,@satui,@atn,@sab,@atv,@suppress,@cvf)
SET CUI = @cui,
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,''),
METAUI = NULLIF(@metaui,''),
STYPE = @stype,
CODE = NULLIF(@code,''),
ATUI = @atui,
SATUI = NULLIF(@satui,''),
ATN = @atn,
SAB = @sab,
ATV = @atv,
SUPPRESS = @suppress,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRSMAP;
CREATE TABLE MRSMAP (
    MAPSETCUI	char(8) NOT NULL,
    MAPSETSAB	varchar(20) NOT NULL,
    MAPID	varchar(50) NOT NULL,
    MAPSID	varchar(50),
    FROMEXPR	text NOT NULL,
    FROMTYPE	varchar(50) NOT NULL,
    REL	varchar(4) NOT NULL,
    RELA	varchar(100),
    TOEXPR	text,
    TOTYPE	varchar(50),
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRSMAP.RRF' into table MRSMAP fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@mapsetcui,@mapsetsab,@mapid,@mapsid,@fromexpr,@fromtype,@rel,@rela,@toexpr,@totype,@cvf)
SET MAPSETCUI = @mapsetcui,
MAPSETSAB = @mapsetsab,
MAPID = @mapid,
MAPSID = NULLIF(@mapsid,''),
FROMEXPR = @fromexpr,
FROMTYPE = @fromtype,
REL = @rel,
RELA = NULLIF(@rela,''),
TOEXPR = @toexpr,
TOTYPE = @totype,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRSTY;
CREATE TABLE MRSTY (
    CUI	char(8) NOT NULL,
    TUI	char(4) NOT NULL,
    STN	varchar(100) NOT NULL,
    STY	varchar(50) NOT NULL,
    ATUI	varchar(11) NOT NULL,
    CVF	int unsigned
) CHARACTER SET utf8;

load data local infile 'MRSTY.RRF' into table MRSTY fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@cui,@tui,@stn,@sty,@atui,@cvf)
SET CUI = @cui,
TUI = @tui,
STN = @stn,
STY = @sty,
ATUI = @atui,
CVF = NULLIF(@cvf,'');

DROP TABLE IF EXISTS MRXNS_ENG;
CREATE TABLE MRXNS_ENG (
    LAT	char(3) NOT NULL,
    NSTR	text NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXNS_ENG.RRF' into table MRXNS_ENG fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@nstr,@cui,@lui,@sui)
SET LAT = @lat,
NSTR = @nstr,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXNW_ENG;
CREATE TABLE MRXNW_ENG (
    LAT	char(3) NOT NULL,
    NWD	varchar(100) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXNW_ENG.RRF' into table MRXNW_ENG fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@nwd,@cui,@lui,@sui)
SET LAT = @lat,
NWD = @nwd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRAUI;
CREATE TABLE MRAUI (
    AUI1	varchar(9) NOT NULL,
    CUI1	char(8) NOT NULL,
    VER	varchar(10) NOT NULL,
    REL	varchar(4),
    RELA	varchar(100),
    MAPREASON	text NOT NULL,
    AUI2	varchar(9) NOT NULL,
    CUI2	char(8) NOT NULL,
    MAPIN	char(1) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRAUI.RRF' into table MRAUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@aui1,@cui1,@ver,@rel,@rela,@mapreason,@aui2,@cui2,@mapin)
SET AUI1 = @aui1,
CUI1 = @cui1,
VER = @ver,
REL = NULLIF(@rel,''),
RELA = NULLIF(@rela,''),
MAPREASON = @mapreason,
AUI2 = @aui2,
CUI2 = @cui2,
MAPIN = @mapin;

DROP TABLE IF EXISTS MRXW_BAQ;
CREATE TABLE MRXW_BAQ (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_BAQ.RRF' into table MRXW_BAQ fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_CZE;
CREATE TABLE MRXW_CZE (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_CZE.RRF' into table MRXW_CZE fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_DAN;
CREATE TABLE MRXW_DAN (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_DAN.RRF' into table MRXW_DAN fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_DUT;
CREATE TABLE MRXW_DUT (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_DUT.RRF' into table MRXW_DUT fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_ENG;
CREATE TABLE MRXW_ENG (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_ENG.RRF' into table MRXW_ENG fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_FIN;
CREATE TABLE MRXW_FIN (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_FIN.RRF' into table MRXW_FIN fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_FRE;
CREATE TABLE MRXW_FRE (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_FRE.RRF' into table MRXW_FRE fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_GER;
CREATE TABLE MRXW_GER (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_GER.RRF' into table MRXW_GER fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_HEB;
CREATE TABLE MRXW_HEB (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_HEB.RRF' into table MRXW_HEB fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_HUN;
CREATE TABLE MRXW_HUN (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_HUN.RRF' into table MRXW_HUN fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_ITA;
CREATE TABLE MRXW_ITA (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_ITA.RRF' into table MRXW_ITA fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_JPN;
CREATE TABLE MRXW_JPN (
    LAT char(3) NOT NULL,
    WD  varchar(500) NOT NULL,
    CUI char(8) NOT NULL,
    LUI varchar(10) NOT NULL,
    SUI varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_JPN.RRF' into table MRXW_JPN fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_KOR;
CREATE TABLE MRXW_KOR (
    LAT char(3) NOT NULL,
    WD  varchar(500) NOT NULL,
    CUI char(8) NOT NULL,
    LUI varchar(10) NOT NULL,
    SUI varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_KOR.RRF' into table MRXW_KOR fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_LAV;
CREATE TABLE MRXW_LAV (
    LAT char(3) NOT NULL,
    WD  varchar(200) NOT NULL,
    CUI char(8) NOT NULL,
    LUI varchar(10) NOT NULL,
    SUI varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_LAV.RRF' into table MRXW_LAV fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_NOR;
CREATE TABLE MRXW_NOR (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_NOR.RRF' into table MRXW_NOR fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_POL;
CREATE TABLE MRXW_POL (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_POL.RRF' into table MRXW_POL fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_POR;
CREATE TABLE MRXW_POR (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_POR.RRF' into table MRXW_POR fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_RUS;
CREATE TABLE MRXW_RUS (
    LAT char(3) NOT NULL,
    WD  varchar(200) NOT NULL,
    CUI char(8) NOT NULL,
    LUI varchar(10) NOT NULL,
    SUI varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_RUS.RRF' into table MRXW_RUS fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_SCR;
CREATE TABLE MRXW_SCR (
    LAT char(3) NOT NULL,
    WD  varchar(200) NOT NULL,
    CUI char(8) NOT NULL,
    LUI varchar(10) NOT NULL,
    SUI varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_SCR.RRF' into table MRXW_SCR fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = NULLIF(@lat,''),
WD = NULLIF(@wd,''),
CUI = NULLIF(@cui,''),
LUI = NULLIF(@lui,''),
SUI = NULLIF(@sui,'');

DROP TABLE IF EXISTS MRXW_SPA;
CREATE TABLE MRXW_SPA (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_SPA.RRF' into table MRXW_SPA fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS MRXW_SWE;
CREATE TABLE MRXW_SWE (
    LAT	char(3) NOT NULL,
    WD	varchar(200) NOT NULL,
    CUI	char(8) NOT NULL,
    LUI	varchar(10) NOT NULL,
    SUI	varchar(10) NOT NULL
) CHARACTER SET utf8;

load data local infile 'MRXW_SWE.RRF' into table MRXW_SWE fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lat,@wd,@cui,@lui,@sui)
SET LAT = @lat,
WD = @wd,
CUI = @cui,
LUI = @lui,
SUI = @sui;

DROP TABLE IF EXISTS AMBIGSUI;
CREATE TABLE AMBIGSUI (
    SUI	varchar(10) NOT NULL,
    CUI	char(8) NOT NULL
) CHARACTER SET utf8;

load data local infile 'AMBIGSUI.RRF' into table AMBIGSUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@sui,@cui)
SET SUI = @sui,
CUI = @cui;

DROP TABLE IF EXISTS AMBIGLUI;
CREATE TABLE AMBIGLUI (
    LUI	varchar(10) NOT NULL,
    CUI	char(8) NOT NULL
) CHARACTER SET utf8;

load data local infile 'AMBIGLUI.RRF' into table AMBIGLUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@lui,@cui)
SET LUI = @lui,
CUI = @cui;

DROP TABLE IF EXISTS DELETEDCUI;
CREATE TABLE DELETEDCUI (
    PCUI	char(8) NOT NULL,
    PSTR	text NOT NULL
) CHARACTER SET utf8;

load data local infile 'CHANGE/DELETEDCUI.RRF' into table DELETEDCUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@pcui,@pstr)
SET PCUI = @pcui,
PSTR = @pstr;

DROP TABLE IF EXISTS DELETEDLUI;
CREATE TABLE DELETEDLUI (
    PLUI	varchar(10) NOT NULL,
    PSTR	text NOT NULL
) CHARACTER SET utf8;

load data local infile 'CHANGE/DELETEDLUI.RRF' into table DELETEDLUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@plui,@pstr)
SET PLUI = @plui,
PSTR = @pstr;

DROP TABLE IF EXISTS DELETEDSUI;
CREATE TABLE DELETEDSUI (
    PSUI	varchar(10) NOT NULL,
    LAT	char(3) NOT NULL,
    PSTR	text NOT NULL
) CHARACTER SET utf8;

load data local infile 'CHANGE/DELETEDSUI.RRF' into table DELETEDSUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@psui,@lat,@pstr)
SET PSUI = @psui,
LAT = @lat,
PSTR = @pstr;

DROP TABLE IF EXISTS MERGEDCUI;
CREATE TABLE MERGEDCUI (
    PCUI	char(8) NOT NULL,
    CUI	char(8) NOT NULL
) CHARACTER SET utf8;

load data local infile 'CHANGE/MERGEDCUI.RRF' into table MERGEDCUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@pcui,@cui)
SET PCUI = @pcui,
CUI = @cui;

DROP TABLE IF EXISTS MERGEDLUI;
CREATE TABLE MERGEDLUI (
    PLUI	varchar(10),
    LUI	varchar(10)
) CHARACTER SET utf8;

load data local infile 'CHANGE/MERGEDLUI.RRF' into table MERGEDLUI fields terminated by '|' ESCAPED BY '' lines terminated by '\n'
(@plui,@lui)
SET PLUI = NULLIF(@plui,''),
LUI = NULLIF(@lui,'');

