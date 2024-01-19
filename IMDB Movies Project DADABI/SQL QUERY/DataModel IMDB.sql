use imdb_movies_datamart;


CREATE TABLE dim_imdb_date (
  DateSK int NOT NULL AUTO_INCREMENT,
  Date date DEFAULT NULL,
  Year varchar(4) DEFAULT NULL,
  Month varchar(20) DEFAULT NULL,
  Decade varchar(5) DEFAULT NULL,
  Season varchar(6) DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime DEFAULT NULL,
  PRIMARY KEY (DateSK)
);

CREATE TABLE dim_imdb_year (
  YearSK int NOT NULL AUTO_INCREMENT,
  Year int DEFAULT NULL,
  Decade varchar(5) DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Created_DT datetime DEFAULT NULL,
  PRIMARY KEY (YearSK)
) ;

CREATE TABLE dim_region (
  RegionSK int NOT NULL AUTO_INCREMENT,
  name varchar(100) DEFAULT NULL,
  code varchar(4) DEFAULT NULL,
  region varchar(10) DEFAULT NULL,
  sub_region varchar(50) DEFAULT NULL,
  ProcessID varchar(20) NOT NULL,
  DI_Create_DT datetime NOT NULL,
  PRIMARY KEY (RegionSK)
) ;

CREATE TABLE dim_imdb_genres (
  genreSK int NOT NULL AUTO_INCREMENT,
  genres varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  Process_ID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (genreSK)
) ;



CREATE TABLE dim_imdb_title (
TitleSK int NOT NULL AUTO_INCREMENT,
  tconst varchar(10) NOT NULL,
  primaryTitle varchar(1024) DEFAULT NULL,
  originalTitle varchar(1024) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Process_id varchar(20) DEFAULT NULL,
  scd_start datetime NOT NULL,
  scd_end datetime DEFAULT NULL,
  scd_version int NOT NULL,
  scd_active int NOT NULL,
  PRIMARY KEY (TitleSK)
);

create index  idx_tconst on dim_imdb_title(tconst);

CREATE TABLE fct_movie (
  MoviesSK int NOT NULL AUTO_INCREMENT,
  tconst varchar(10) not NULL Unique key,
  ReleaseYearSK int DEFAULT NULL,
  isAdult int DEFAULT -1,
  RuntimeMin int DEFAULT -1,
  NoofDirectors int DEFAULT -1,
  NoofActors int DEFAULT -1,
  NoofWriters int DEFAULT -1,
  TotalGross int DEFAULT -1,
  AvgRating double DEFAULT -1,
  NoofRegions int DEFAULT -1,
  NoofGenres int DEFAULT -1,
  NoofVotes int DEFAULT -1,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime DEFAULT NULL,
  PRIMARY KEY (MoviesSK)
) ;


CREATE TABLE dim_person (
  PersonSK int NOT NULL AUTO_INCREMENT,
  nconst varchar(10) NOT NULL,
  Name varchar(255) DEFAULT NULL,
  BirthYear int DEFAULT NULL,
  DeathYear int DEFAULT NULL,
  Process_id varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  scd_start datetime NOT NULL,
  scd_end datetime DEFAULT NULL,
  scd_version int NOT NULL,
  scd_active int NOT NULL,
  PRIMARY KEY (PersonSK),
  KEY idx_nconst1 (nconst)
);

create index idx_PersonSK on dim_person(PersonSK);


CREATE TABLE dim_moviegenre (
  MovieGenreSK int NOT NULL AUTO_INCREMENT,
  MovieSK int DEFAULT NULL,
  GenreSK int DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (MovieGenreSK)
) ;

CREATE TABLE dim_imdb_gross (
  GrossSK int NOT NULL AUTO_INCREMENT,
  DateSK int DEFAULT NULL,
  MovieSK int DEFAULT NULL,
  tconst varchar(10) DEFAULT NULL,
  CummulativeTotalGross bigint DEFAULT NULL,
  DailyGross bigint DEFAULT NULL,
  DayNum int DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime DEFAULT NULL,
  PRIMARY KEY (GrossSK)
) ;

CREATE TABLE dim_regionmovie (
  RegionMovieSK int NOT NULL AUTO_INCREMENT,
  RegionSK int DEFAULT NULL,
  MovieSK int DEFAULT NULL,
  Process_id varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (RegionMovieSK)
) ;

CREATE TABLE dim_actors (
  ActorSK int NOT NULL AUTO_INCREMENT,
  MoviesSK int DEFAULT NULL,
  PersonSK int DEFAULT NULL,
  nconst varchar(10) DEFAULT NULL,
  ProfessionType varchar(10) DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ActorSK)
);
create index idx_MovieSK on dim_actors(MoviesSK);
create index idx_PersonSK_1 on dim_actors(PersonSK);

CREATE TABLE dim_writers (
  WriterSK int NOT NULL AUTO_INCREMENT,
  MoviesSK int DEFAULT NULL,
  PersonSK int DEFAULT NULL,
  nconst varchar(10) DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (WriterSK)
);
create index idx_MovieSK_1 on dim_writers(MoviesSK);
create index idx_PersonSK_2 on dim_writers(PersonSK);



CREATE TABLE dim_director (
  DirectorSK int NOT NULL AUTO_INCREMENT,
  MoviesSK int DEFAULT NULL,
  PersonSK int DEFAULT NULL,
  nconst varchar(10) DEFAULT NULL,
  ProcessID varchar(20) DEFAULT NULL,
  DI_Create_DT datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (DirectorSK)
) ;
create index idx_MovieSK_2 on dim_director(MoviesSK);
create index idx_PersonSK_2 on dim_director(PersonSK);



ALTER TABLE fct_movie ADD CONSTRAINT fk_fct_movie_tconst FOREIGN KEY (tconst) REFERENCES dim_imdb_title (tconst);
ALTER TABLE fct_movie ADD CONSTRAINT fk_fct_movie_yearsk FOREIGN KEY (ReleaseYearSK) REFERENCES dim_imdb_year (YearSK);


ALTER TABLE dim_moviegenre ADD CONSTRAINT fk_dim_moviegenre_movie FOREIGN KEY (MovieSK) REFERENCES fct_movie (MoviesSK);
ALTER TABLE dim_moviegenre ADD CONSTRAINT fk_dim_moviegenre_genre FOREIGN KEY (GENRESK) REFERENCES dim_imdb_genres (GENRESK);

ALTER TABLE dim_imdb_gross ADD CONSTRAINT fk_dim_imdb_gross_movie FOREIGN KEY (MovieSK) REFERENCES fct_movie (MoviesSK);
ALTER TABLE dim_imdb_gross ADD CONSTRAINT fk_dim_imdb_gross_date FOREIGN KEY (DATESK) REFERENCES dim_imdb_date (DATESK);

ALTER TABLE dim_regionmovie ADD CONSTRAINT fk_dim_regionmovie_region FOREIGN KEY (RegionSK) REFERENCES dim_region (RegionSK);
ALTER TABLE dim_regionmovie ADD CONSTRAINT fk_dim_regionmovie_movie FOREIGN KEY (MovieSK) REFERENCES fct_movie (MoviesSK);

ALTER TABLE dim_actors ADD CONSTRAINT fk_dim_actors_movie FOREIGN KEY (MoviesSK) REFERENCES fct_movie (MoviesSK);
ALTER TABLE dim_actors ADD CONSTRAINT fk_dim_actors_person FOREIGN KEY (PersonSK) REFERENCES dim_person (PersonSK);

ALTER TABLE dim_writers ADD CONSTRAINT fk_dim_writers_movie FOREIGN KEY (MoviesSK) REFERENCES fct_movie (MoviesSK);
ALTER TABLE dim_writers ADD CONSTRAINT fk_dim_writers_person FOREIGN KEY (PersonSK) REFERENCES dim_person (PersonSK);

ALTER TABLE dim_director ADD CONSTRAINT fk_dim_director_movie FOREIGN KEY (MoviesSK) REFERENCES fct_movie (MoviesSK);
ALTER TABLE dim_director ADD CONSTRAINT fk_dim_director_person FOREIGN KEY (PersonSK) REFERENCES dim_person (PersonSK);



CREATE TABLE etl_job(
    job_id                 INT       AUTO_INCREMENT     NOT NULL,
    job_name           VARCHAR(100),
    table_name           VARCHAR(100),
    schedule         VARCHAR(30),
    created_by           VARCHAR(30),
    created_date           DATETIME,
    PRIMARY KEY (job_id)
)
;

CREATE TABLE etl_job_log(
    job_log_id                 INT       AUTO_INCREMENT     NOT NULL,
    job_id                 INT       NOT NULL,
	process_id  		VARCHAR(20),
    job_status           VARCHAR(20),
    created_by           VARCHAR(30),
    created_date           DATETIME,
    PRIMARY KEY (job_log_id)
);

ALTER TABLE etl_job_log
ADD CONSTRAINT fk_job_id
FOREIGN KEY (job_id)
REFERENCES etl_job(job_id);

select * from etl_job;
select * from etl_job_log;
select * from etl_job where job_id=14;



DIM:

INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_imdb_date',"dim_imdb_date","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_year',"dim_imdb_year","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_actor_part1',"dim_actors","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_actor_part2',"dim_actors","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_director_Part1',"dim_director","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_director_Part2',"dim_director","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_director_Part3',"dim_director","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_genre',"dim_imdb_genres","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_gross',"dim_imdb_gross","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_movie_genre',"Dim_MovieGenre","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_person_Part1',"dim_person","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_person_Part2',"dim_person","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_person_Part3',"dim_person","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_person_Part4_scd',"dim_person","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_region',"dim_region","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dimregionmovie',"dim_regionmovie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_title_part1',"dim_imdb_title","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_title_part2',"dim_imdb_title","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_title_part3_scd',"dim_imdb_title","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_writer_Part1',"dim_writers","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_writer_Part2',"dim_writers","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_dim_writer_Part3',"dim_writers","DAILY",user(),current_timestamp());

FACT:

INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_actor_metrics',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_director_metrics',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_writer_metrics',"fct_movie","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_part2',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_gross_metrics',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_genre_metrics',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_region_metrics',"fct_movie","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_fct_movie_update_details',"fct_movie","DAILY",user(),current_timestamp());



Logging:

INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_post_job_load',"etl_job_log","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_pre_job_load',"etl_job_log","DAILY",user(),current_timestamp());


Stage:

INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_box_office_rev',"stg_box_office_rev","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_newdata_name_basics',"stg_newdata_name_basics","DAILY",user(),current_timestamp());



INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_newdata_title_basics',"stg_newdata_title_basics","DAILY",user(),current_timestamp());




INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_name_basics_prof',"stg_imdb_name_basics_prof","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_name_basics_titles',"stg_imdb_name_basics_titles","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_name_basics',"stg_imdb_name_basics","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_akas',"stg_imdb_title_akas","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_basics_genres',"stg_imdb_title_basics_genres","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_basics',"stg_imdb_title_basics","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_crew_directors',"stg_imdb_title_crew_directors","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_crew_writers',"stg_imdb_title_crew_writers","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_crew',"stg_imdb_title_crew","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_principals',"tg_imdb_title_principals","DAILY",user(),current_timestamp());


INSERT INTO etl_job(job_name,table_name,schedule,created_by,created_date) 

VALUES('wf_load_stg_imdb_title_ratings',"stg_imdb_title_ratings","DAILY",user(),current_timestamp());