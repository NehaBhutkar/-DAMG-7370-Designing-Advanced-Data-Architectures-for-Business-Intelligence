select * from imdb_name_basics;
/* imdb_name_basics has details about a person. Array Attributes include primaryProfession, knownForTitles
column nconst is key identifer for every person
Staging need 3 staging tables.
-- stg_imdb_name_basics : load as it is
-- stg_imdb_name_basics_profession
-- stg_imdb_name_basics_titles
*/
select * from imdb_title_akas;
/* table has movie title names specifuc to region and language
Columns Description
titleId is key identifier for each titles, table has duplicate title names in different languages
attributes ??
types has details about where the title is used, if original is the orignal name of the movie.
We to add region full name in future
Staging
stg_imdb_title_akas
*/
select distinct types from imdb_title_akas;
select distinct attributes from imdb_title_akas;

select * from imdb_title_basics;
select tconst,count(*) from imdb_title_basics group by tconst having count(*)>2; /*0 rows*/
/*
imdb_title_basics has all distinct movie titles
tconst is title specific key
Staging
stg_imdb_title_basics
stg_imdb_title_basics_genres
*/

select * from imdb_title_crew;
/*
imdb_title_crew has details about directors and writers of the movie

Staging
stg_imdb_title_crew 
stg_imdb_title_crew_directors
stg_imdb_title_crew_writers
*/

select * from imdb_title_principals;
select distinct category from imdb_title_principals;
select distinct job from imdb_title_principals;
/*
imdb_title_principals has title, crew relation and charaters play by actors and actress
column:
Characters check if actor has played 2 characters
Stage:
stg_imdb_title_principals
stg_imdb_title_principals_characters -- if 2 characters placed
*/

select * from imdb_title_ratings;
/*
imdb_title_ratings has ratings and votes
staging:
stg_imdb_title_ratings
*/