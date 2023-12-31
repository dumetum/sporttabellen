CREATE TABLE "TTT_MANNSCHAFTEN" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"VEREIN" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"KATEGORIE" VARCHAR2(10 CHAR), 
	"NR" VARCHAR2(3 CHAR), 
	 CONSTRAINT "TTT_MANNSCHAFTEN_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;
   
   
   
 CREATE TABLE "TTT_TABELLEN" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"BEZEICHNUNG" VARCHAR2(100 CHAR) NOT NULL ENABLE, 
	 CONSTRAINT "TTT_TABELLEN_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

   COMMENT ON TABLE "TTT_TABELLEN"  IS 'Basistabelle für die Tabellen';
   
   
CREATE TABLE "TTT_SPIELE" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"TAB_ID" NUMBER NOT NULL ENABLE, 
	"MANN_ID_1" NUMBER NOT NULL ENABLE, 
	"MANN_ID_2" NUMBER NOT NULL ENABLE, 
	"PUNKTE_MANN_1" NUMBER NOT NULL ENABLE, 
	"PUNKTE_MANN_2" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "TTT_SPIELE_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "TTT_SPIELE" ADD CONSTRAINT "TTT_SPIELE_FK_MANN_ID_1" FOREIGN KEY ("MANN_ID_1")
	  REFERENCES "TTT_MANNSCHAFTEN" ("ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "TTT_SPIELE" ADD CONSTRAINT "TTT_SPIELE_FK_MANN_ID_2" FOREIGN KEY ("MANN_ID_2")
	  REFERENCES "TTT_MANNSCHAFTEN" ("ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "TTT_SPIELE" ADD CONSTRAINT "TTT_SPIELE_FK_TAB_ID" FOREIGN KEY ("TAB_ID")
	  REFERENCES "TTT_TABELLEN" ("ID") ON DELETE CASCADE ENABLE;
      
      
CREATE TABLE "TTT_TABELLENZEILEN" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"TAB_ID" NUMBER NOT NULL ENABLE, 
	"MANN_ID" NUMBER NOT NULL ENABLE, 
	"RANG" NUMBER NOT NULL ENABLE, 
	"ANZ_SPIELE" NUMBER NOT NULL ENABLE, 
	"ANZ_SIEGE" NUMBER NOT NULL ENABLE, 
	"ANZ_UNENTSCHIEDEN" NUMBER NOT NULL ENABLE, 
	"ANZ_NIEDERLAGEN" NUMBER NOT NULL ENABLE, 
	"EINZELPUNKTE_PLUS" NUMBER NOT NULL ENABLE, 
	"EINZELPUNKTE_MINUS" NUMBER NOT NULL ENABLE, 
	"GESAMTPUNKTE_PLUS" NUMBER NOT NULL ENABLE, 
	"GESAMTPUNKTE_MINUS" NUMBER, 
	 CONSTRAINT "TTT_TABELLENZEILEN_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "TTT_TABELLENZEILEN" ADD CONSTRAINT "TTT_TABELLENZEILEN_FK_MANN_ID" FOREIGN KEY ("MANN_ID")
	  REFERENCES "TTT_MANNSCHAFTEN" ("ID") ENABLE;
  ALTER TABLE "TTT_TABELLENZEILEN" ADD CONSTRAINT "TTT_TABELLENZEILEN_FK_TAB_ID" FOREIGN KEY ("TAB_ID")
	  REFERENCES "TTT_TABELLEN" ("ID") ON DELETE CASCADE ENABLE;

   COMMENT ON COLUMN "TTT_TABELLENZEILEN"."RANG" IS 'Tabellenplatz';
   COMMENT ON COLUMN "TTT_TABELLENZEILEN"."EINZELPUNKTE_PLUS" IS 'Gewonnene einzelne Spiele oder geschossene Tore';
   COMMENT ON COLUMN "TTT_TABELLENZEILEN"."EINZELPUNKTE_MINUS" IS 'Verlorene Einzelne Spiele oder Gegentore';
   COMMENT ON COLUMN "TTT_TABELLENZEILEN"."GESAMTPUNKTE_PLUS" IS 'Punkte, die letztenendes den Platz ausmachen';
   COMMENT ON COLUMN "TTT_TABELLENZEILEN"."GESAMTPUNKTE_MINUS" IS 'Optional: Bei Systemen, bei denen auch Minuspunkte berechnet werden, z.B. 2-0, 1-1, 0:2';
   
   
 CREATE TABLE "TTT_TAB_MANN" 
   (	"ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"TAB_ID" NUMBER, 
	"MANN_ID" NUMBER, 
	 CONSTRAINT "TTT_TAB_MANN_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "TTT_TAB_MANN" ADD CONSTRAINT "TTT_TAB_MANN_FK_MANN_ID" FOREIGN KEY ("MANN_ID")
	  REFERENCES "TTT_MANNSCHAFTEN" ("ID") ENABLE;
  ALTER TABLE "TTT_TAB_MANN" ADD CONSTRAINT "TTT_TAB_MANN_FK_TAB_ID" FOREIGN KEY ("TAB_ID")
	  REFERENCES "TTT_TABELLEN" ("ID") ON DELETE CASCADE ENABLE;
      
