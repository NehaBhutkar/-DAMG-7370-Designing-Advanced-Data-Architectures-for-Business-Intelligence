-- Trend Analysis:

-- 1. Average movie runtime change over the years:

SELECT AVG(fm.RunTimeMin), y.Year
FROM fct_movie fm
JOIN dim_imdb_year y
ON fm.ReleaseYearSK = y.YearSK
GROUP BY y.Year
ORDER BY y.Year;

-- 2. Is there a correlation between the average movie rating and the year of release?

SELECT AVG(fm.AvgRating), y.Year
FROM fct_movie fm
JOIN dim_imdb_year y
ON fm.ReleaseYearSK = y.YearSK
GROUP BY y.Year
ORDER BY y.Year;


-- 3. Visualization of the distribution of movie releases per year

SELECT count(fm.MoviesSK), y.Year
FROM fct_movie fm
JOIN dim_imdb_year y
ON fm.ReleaseYearSK = y.YearSK
GROUP BY y.Year
ORDER BY y.Year;

-- Genre Analysis

-- 1. Which genres have seen the most significant ratings in popularity over the past decade?

SELECT
dy.decade,
dg.genres,
AVG(f.AvgRating) AS AverageRating
FROM dim_imdb_genres dg
JOIN dim_moviegenre dmg ON dg.genreSK = dmg.GenreSK
JOIN fct_movie f ON dmg.MovieSK = f.MoviesSK
JOIN dim_imdb_year dy ON f.ReleaseYearSK = dy.YearSK
GROUP BY dy.decade,dg.genres
ORDER BY dy.decade;


-- 2. Show the top 5 genres as compared to gross earnings for the 9 box office movies.
 
-- Performance Metrics:
-- 1. Correlation between the movie's runtime and its average rating

SELECT
f.RuntimeMin,
f.AvgRating
FROM
fct_movie f
WHERE
f.RuntimeMin IS NOT NULL
AND f.AvgRating IS NOT NULL
ORDER BY RuntimeMin desc;

-- 2. Correlation between the movie's runtime and its average gross 

SELECT
f.RuntimeMin,
AVG(g.DailyGross) AS AvgGross
FROM
dim_imdb_gross g
JOIN fct_movie f
ON g.MovieSK = f.MoviesSK
WHERE
f.RuntimeMin IS NOT NULL
AND g.DailyGross IS NOT NULL
AND  f.RuntimeMin != -1
GROUP BY f.RuntimeMin
order by AvgGross desc;

-- Relationship between the number of votes and the average rating of movies

SELECT
f.NoofVotes,
f.AvgRating
FROM
fct_movie f
WHERE
f.NoofVotes IS NOT NULL
AND f.AvgRating IS NOT NULL
ORDER BY f.NoofVotes desc;

-- Director Success Metrics:
-- 1. Identify directors with the most films rated above 7. Sort them in the descending order

SELECT
    p.Name AS DirectorName,
    COUNT(d.MoviesSK) AS Above7FilmCount
FROM
    dim_director d
JOIN
    fct_movie m ON d.MoviesSK = m.MoviesSK
JOIN 
	dim_person p ON p.PersonSK = d.PersonSK
WHERE
    m.AvgRating > 7 and m.AvgRating <= 10 
GROUP BY
    p.Name
ORDER BY
    Above7FilmCount DESC;

    

-- director success part 2


WITH DirectorStats AS (
    SELECT
        dp.Name AS DirectorName,
        COUNT(fm.MoviesSK) AS TotalMovies,
        SUM(fm.TotalGross) AS TotalGross
    FROM
        dim_director dd
    JOIN dim_person dp ON dd.PersonSK = dp.PersonSK
    JOIN fct_movie fm ON dd.MoviesSK = fm.MoviesSK
    WHERE dp.Name IS NOT NULL
    GROUP BY
        DirectorName
)
SELECT
    DirectorName,
    MAX(TotalMovies) AS MaxTotalMovies,
    SUM(TotalGross) AS TotalGrossEarnings
FROM
    DirectorStats
GROUP BY
    DirectorName
ORDER BY
    TotalGrossEarnings DESC
LIMIT 10;





/**************************************************************/
-- Actor and Actress Film Records:

-- 1. List the top 10 actors/actresses with the most films rated between 4 and 7.

SELECT
    dp.Name,
    COUNT(fm.MoviesSK) AS FilmCount
FROM
    fct_movie fm 
JOIN dim_actors da ON da.MoviesSK = fm.MoviesSK
JOIN dim_person dp on da.PersonSK = dp.PersonSK
WHERE
    fm.AvgRating between 4 and 7 and dp.name is not null
GROUP BY
dp.Name
ORDER BY FilmCount desc
LIMIT 10;

-- 2. Compare the top 5 actors and actresses based on movie ratings


-- Approach 1  - top 5 actors
with data1 as (
SELECT
    da.PersonSK AS PersonSK,
    AVG(fm.AvgRating) AS AverageRating
FROM
    fct_movie fm
JOIN dim_actors da ON da.MoviesSK = fm.MoviesSK
GROUP BY personsk
ORDER BY
AverageRating DESC
LIMIT 5
)
SELECT
    dp.Name AS ActorActressName,
	AverageRating
FROM
    data1 d
JOIN dim_person dp ON d.PersonSK = dp.PersonSK
WHERE dp.scd_active = 1;

-- top 5 actress

with data1 as (
SELECT
    da.PersonSK AS PersonSK,
    AVG(fm.AvgRating) AS AverageRating
FROM
    fct_movie fm
JOIN dim_actors da ON da.MoviesSK = fm.MoviesSK
WHERE da.ProfessionType = "actress"
GROUP BY personsk
ORDER BY
AverageRating DESC
LIMIT 5
)
SELECT
    dp.Name AS ActorActressName,
	AverageRating
FROM
    data1 d
JOIN dim_person dp ON d.PersonSK = dp.PersonSK
WHERE dp.scd_active = 1;




-- Approach 2

with data1 as (
SELECT
    da.PersonSK AS PersonSK,
    AVG(fm.AvgRating) AS AverageRating
FROM
    fct_movie fm
JOIN dim_actors da ON da.MoviesSK = fm.MoviesSK
GROUP BY personsk
HAVING count(fm.MoviesSK) > 5
ORDER BY
    AverageRating DESC
LIMIT 5
)
SELECT
    dp.Name AS ActorActressName,
   AverageRating
FROM
    data1 d
JOIN dim_person dp ON d.PersonSK = dp.PersonSK
WHERE dp.scd_active = 1;


select * from dim_person where Name is null;



  
 
-- seasonal analysis:

-- 1. How does movie performance vary across different seasons of the year? (based on gross earnings)
 select distinct d.Season, sum(g.DailyGross) from dim_imdb_date d
 join dim_imdb_gross g
 on d.DateSK = g.DateSK
 group by d.Season
 limit 10;
 
 -- Top 3 movies based on the season (spring, summer, fall)

 select distinct d.Season, sum(g.DailyGross) , t.originalTitle 
 from dim_imdb_date d
 join dim_imdb_gross g
 on d.DateSK = g.DateSK
 join fct_movie fm
 on fm.MoviesSK = g.MovieSK
 join dim_imdb_title t
 on t.tconst = fm.tconst
 where d.Season in ("Fall","Summer","Spring")
 group by d.Season, t.originalTitle
 order by d.Season
 limit 9;
 
 
-- regional analysis
SELECT
    m.tconst AS MovieID,
    t.primaryTitle AS MovieTitle,
    COUNT(DISTINCT rm.RegionSK) AS RegionCount
FROM
    fct_movie m
JOIN
    dim_regionmovie rm ON m.MoviesSK = rm.MovieSK
JOIN 
	dim_imdb_title t on t.tconst = m.tconst
GROUP BY
    m.tconst, t.primaryTitle
ORDER BY
    RegionCount DESC;

 -- KPI dashboard
 
 select 
 sum(f.NoofActors)
 from fct_movie f;
 
select 
count(ActorSK)
from dim_actors da
 join fct_movie f
 on f.MoviesSK = da/MoviesSK;

