create if not exists database company_db;
use company_db;

create table if not exists companies  (  
  ticker varchar(4),
  name varchar(40),
  execcomp decimal(13,4),
  sic varchar(40),
  primary_exchange varchar(1),	
  exchang_ecode int,
  cusip varchar(8),
  naics varchar(6),
) row format delimited fields 
  terminated by '\t' 
  stored as orcfile;

create table if not exists company_annuals (
  year int, 
  cusip varchar(8),
  gvkey int,
  tic varchar(5),	
  companyname varchar(40),
  aco	decimal(5,3),
  act	decimal (6,3),
  at	decimal (7,3),
  ceq	decimal (6,3),
  ci	decimal (5,3),
  citotal	decimal (5,3),
  dlc	decimal(6,3),
  dltt decimal(6,3),
  dt decimal(6,3),
  dvt decimal(5,3),
  icapt decimal(6,3),	
  idit decimal(4,3),
  intan decimal(6,3),
  invt decimal(6,3),
  ivst decimal(6,3),
  lco decimal(5,3),
  lct decimal(6,3),
  lo decimal(7,3),
  lse decimal(7,3),
  lt	decimal(7,3),
  mibt decimal(5,3),
  mrct decimal(5,3),
  ppegt decimal(6,3),
  ppent decimal(6,3),
  rect decimal(7,3),
  revt decimal(6,3),
  seq decimal(6,3),
  teq decimal(6,3),
  tfva decimal(7,3),
  tfvl decimal(7,3),
  tstk decimal(6,3),
  txndb decimal(5,3),
  txt decimal(5,3),
  xint decimal(5,3),
  xopr decimal(6,3),
  exchg int,
  mkvalt decimal(6,3),
  country	varchar(3),
  siccode int
) row format delimited fields 
  terminated by '\t' 
  stored as orcfile;
