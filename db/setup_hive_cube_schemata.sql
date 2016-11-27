
create database country_cube;
use country_cube;

create table NAICS_conversion (
NAICS2012 nvarchar(6),
ISIC4 nvarchar(2),

primary key(NAICS2012)
);

load data local infile '~/Documents/Project/data/Final/NAICS_ISIC_CONVERT_2.csv'
into table NAICS_conversion
fields terminated by ';'
ignore 1 lines;

create table AUS (
rep_year datetime,
A int(15),
`01` int(15),
`02` int(15),
`03` int(15),
B int(15),
`05` int(15),
`06` int(15),
`07` int(15),
`08` int(15),
`09` int(15),
C int(15),
`10` int(15),
`11` int(15),
`12` int(15),
`13` int(15),
`14` int(15),
`15` int(15),
`16` int(15),
`17` int(15),
`18` int(15),
`19` int(15),
`20` int(15),
`21` int(15),
`22` int(15),
`23` int(15),
`24` int(15),
`25` int(15),
`26` int(15),
`27` int(15),
`28` int(15),
`29` int(15),
`30` int(15),
`31` int(15),
`32` int(15),
`33` int(15),
D int(15),
`35` int(15),
E int(15),
`36` int(15),
`37` int(15),
`38` int(15),
`39` int(15),
F int(15),
`41` int(15),
`42` int(15),
`43` int(15),
G int(15),
`45` int(15),
`46` int(15),
`47` int(15),
H int(15),
`49` int(15),
`50` int(15),
`51` int(15),
`52` int(15),
`53` int(15),
I int(15),
`55` int(15),
`56` int(15),
J int(15),
`58` int(15),
`59` int(15),
`60` int(15),
`61` int(15),
`62` int(15),
`63` int(15),
K int(15),
`64` int(15),
`65` int(15),
`66` int(15),
L int(15),
`68` int(15),
M int(15),
`69` int(15),
`70` int(15),
`71` int(15),
`72` int(15),
`73` int(15),
`74` int(15),
`75` int(15),
N int(15),
`77` int(15),
`78` int(15),
`79` int(15),
`80` int(15),
`81` int(15),
`82` int(15),
O int(15),
`84` int(15),
P int(15),
`85` int(15),
Q int(15),
`86` int(15),
`87` int(15),
`88` int(15),
R int(15),
`90` int(15),
`91` int(15),
`92` int(15),
`93` int(15),
S int(15),
`94` int(15),
`95` int(15),
`96` int(15),
T int(15),
`97` int(15),
`98` int(15),
U int(15),
`99` int(15),

primary key(rep_year)
);

create table KOR like AUS;
create table MEX like AUS;
create table CHL like AUS;
create table AUT like AUS;
create table BEL like AUS;
create table CZE like AUS;
create table USA like AUS;
create table FRA like AUS;
create table DEU like AUS;
create table ITA like AUS;
create table NLD like AUS;
create table SVN like AUS;
create table HUN like AUS;
create table LUX like AUS;
create table DNK like AUS;
create table EST like AUS;
create table GRC like AUS;
create table SWE like AUS;
create table SVK like AUS;
create table POL like AUS;
create table LVA like AUS;
create table FIN like AUS;
create table NOR like AUS;
create table GBR like AUS;
create table PRT like AUS;
create table CHE like AUS;
create table ESP like AUS;
create table LTU like AUS;

load data local infile '~/Documents/Project/data/Final/AUS.csv'
into table AUS
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/KOR.csv'
into table KOR
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/MEX.csv'
into table MEX
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/AUT.csv'
into table AUT
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/BEL.csv'
into table BEL
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/CZE.csv'
into table CZE
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/USA.csv'
into table USA
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/FRA.csv'
into table FRA
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/DEU.csv'
into table DEU
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/ITA.csv'
into table ITA
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/NLD.csv'
into table NLD
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/SVN.csv'
into table SVN
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/HUN.csv'
into table HUN
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/LUX.csv'
into table LUX
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/DNK.csv'
into table DNK
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/EST.csv'
into table EST
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/GRC.csv'
into table GRC
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/SWE.csv'
into table SWE
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/SVK.csv'
into table SVK
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/POL.csv'
into table POL
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/LVA.csv'
into table LVA
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/FIN.csv'
into table FIN
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/NOR.csv'
into table NOR
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/GBR.csv'
into table GBR
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/PRT.csv'
into table PRT
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/CHE.csv'
into table CHE
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/ESP.csv'
into table ESP
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/LTU.csv'
into table LTU
fields terminated by ';'
ignore 1 lines;

create database sector_cube;
use sector_cube;

create table NAICS_conversion (
NAICS2012 nvarchar(6),
ISIC4 nvarchar(2),

primary key(NAICS2012)
);

create table `01` (
rep_year datetime,
AUS int(15),
KOR int(15),
MEX int(15),
CHL int(15),
AUT int(15),
BEL int(15),
CZE int(15),
USA int(15),
FRA int(15),
DEU int(15),
ITA int(15),
NLD int(15),
SVN int(15),
HUN int(15),
LUX int(15),
DNK int(15),
EST int(15),
GRC int(15),
SWE int(15),
SVK int(15),
POL int(15),
LVA int(15),
FIN int(15),
NOR int(15),
GBR int(15),
PRT int(15),
CHE int(15),
ESP int(15),
LTU int(15),

primary key(rep_year)
);

create table `02` like `01`;
create table `03` like `01`;
create table `04` like `01`;
create table `05` like `01`;
create table `06` like `01`;
create table `07` like `01`;
create table `08` like `01`;
create table `09` like `01`;
create table `10` like `01`;
create table `11` like `01`;
create table `12` like `01`;
create table `13` like `01`;
create table `14` like `01`;
create table `15` like `01`;
create table `16` like `01`;
create table `17` like `01`;
create table `18` like `01`;
create table `19` like `01`;
create table `20` like `01`;
create table `21` like `01`;
create table `22` like `01`;
create table `23` like `01`;
create table `24` like `01`;
create table `25` like `01`;
create table `26` like `01`;
create table `27` like `01`;
create table `28` like `01`;
create table `29` like `01`;
create table `30` like `01`;
create table `31` like `01`;
create table `32` like `01`;
create table `33` like `01`;
create table `34` like `01`;
create table `35` like `01`;
create table `36` like `01`;
create table `37` like `01`;
create table `38` like `01`;
create table `39` like `01`;
create table `40` like `01`;
create table `41` like `01`;
create table `42` like `01`;
create table `43` like `01`;
create table `44` like `01`;
create table `45` like `01`;
create table `46` like `01`;
create table `47` like `01`;
create table `48` like `01`;
create table `49` like `01`;
create table `50` like `01`;
create table `51` like `01`;
create table `52` like `01`;
create table `53` like `01`;
create table `54` like `01`;
create table `55` like `01`;
create table `56` like `01`;
create table `57` like `01`;
create table `58` like `01`;
create table `59` like `01`;
create table `60` like `01`;
create table `61` like `01`;
create table `62` like `01`;
create table `63` like `01`;
create table `64` like `01`;
create table `65` like `01`;
create table `66` like `01`;
create table `67` like `01`;
create table `68` like `01`;
create table `69` like `01`;
create table `70` like `01`;
create table `71` like `01`;
create table `72` like `01`;
create table `73` like `01`;
create table `74` like `01`;
create table `75` like `01`;
create table `76` like `01`;
create table `77` like `01`;
create table `78` like `01`;
create table `79` like `01`;
create table `80` like `01`;
create table `81` like `01`;
create table `82` like `01`;
create table `83` like `01`;
create table `84` like `01`;
create table `85` like `01`;
create table `86` like `01`;
create table `87` like `01`;
create table `88` like `01`;
create table `89` like `01`;
create table `90` like `01`;
create table `91` like `01`;
create table `92` like `01`;
create table `93` like `01`;
create table `94` like `01`;
create table `95` like `01`;
create table `96` like `01`;
create table `97` like `01`;
create table `98` like `01`;
create table `99` like `01`;

load data local infile '~/Documents/Project/data/Final/01.csv'
into table `01`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/02.csv'
into table `02`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/03.csv'
into table `03`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/04.csv'
into table `04`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/05.csv'
into table `05`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/06.csv'
into table `06`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/07.csv'
into table `07`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/08.csv'
into table `08`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/09.csv'
into table `09`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/10.csv'
into table `10`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/11.csv'
into table `11`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/12.csv'
into table `12`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/13.csv'
into table `13`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/14.csv'
into table `14`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/15.csv'
into table `15`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/16.csv'
into table `16`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/17.csv'
into table `17`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/18.csv'
into table `18`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/19.csv'
into table `19`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/20.csv'
into table `20`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/21.csv'
into table `21`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/22.csv'
into table `22`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/23.csv'
into table `23`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/24.csv'
into table `24`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/25.csv'
into table `25`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/26.csv'
into table `26`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/27.csv'
into table `27`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/28.csv'
into table `28`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/29.csv'
into table `29`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/30.csv'
into table `30`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/31.csv'
into table `31`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/32.csv'
into table `32`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/33.csv'
into table `33`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/34.csv'
into table `34`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/35.csv'
into table `35`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/36.csv'
into table `36`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/37.csv'
into table `37`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/38.csv'
into table `38`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/39.csv'
into table `39`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/40.csv'
into table `40`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/41.csv'
into table `41`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/42.csv'
into table `42`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/43.csv'
into table `43`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/44.csv'
into table `44`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/45.csv'
into table `45`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/46.csv'
into table `46`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/47.csv'
into table `47`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/48.csv'
into table `48`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/49.csv'
into table `49`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/50.csv'
into table `50`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/51.csv'
into table `51`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/52.csv'
into table `52`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/53.csv'
into table `53`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/54.csv'
into table `54`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/55.csv'
into table `55`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/56.csv'
into table `56`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/57.csv'
into table `57`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/58.csv'
into table `58`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/59.csv'
into table `59`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/60.csv'
into table `60`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/61.csv'
into table `61`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/62.csv'
into table `62`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/63.csv'
into table `63`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/64.csv'
into table `64`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/65.csv'
into table `65`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/66.csv'
into table `66`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/67.csv'
into table `67`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/68.csv'
into table `68`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/69.csv'
into table `69`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/70.csv'
into table `70`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/71.csv'
into table `71`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/72.csv'
into table `72`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/73.csv'
into table `73`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/74.csv'
into table `74`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/75.csv'
into table `75`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/76.csv'
into table `76`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/77.csv'
into table `77`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/78.csv'
into table `78`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/79.csv'
into table `79`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/80.csv'
into table `80`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/81.csv'
into table `81`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/82.csv'
into table `82`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/83.csv'
into table `83`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/84.csv'
into table `84`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/85.csv'
into table `85`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/86.csv'
into table `86`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/87.csv'
into table `87`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/88.csv'
into table `88`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/89.csv'
into table `89`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/90.csv'
into table `90`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/91.csv'
into table `91`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/92.csv'
into table `92`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/93.csv'
into table `93`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/94.csv'
into table `94`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/95.csv'
into table `95`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/96.csv'
into table `96`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/97.csv'
into table `97`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/98.csv'
into table `98`
fields terminated by ';'
ignore 1 lines;

load data local infile '~/Documents/Project/data/Final/99.csv'
into table `99`
fields terminated by ';'
ignore 1 lines;
