
  CREATE TABLE "TTT_MANNSCHAFTEN" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"VEREIN" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"KATEGORIE" VARCHAR2(10 CHAR), 
	"NR" VARCHAR2(3 CHAR), 
	 CONSTRAINT "TTT_MANNSCHAFTEN_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;