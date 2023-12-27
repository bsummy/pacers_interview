
/*
Quick Notes
- Season 2022 means Season 2022-2023 even though the 20222023 playoffs occur completely in 2023.
- games_started is null for playoff statlines, so I commented out that section of the code
- I chose postgreSQL, so column alias don't work in the same query.
       SELECT ROUND(XYZ, 2) AS ABC                              SELECT ROUND(XYZ, 2) AS ABC
       FROM table         but instead I'm forced to write       FROM table
       ORDER BY ABC;                                            ORDER BY ROUND(XYZ, 2);
- I wrote two answers for Q2, since I think a non-cte route is cleaner, but I wanted to demonstrate I can do both.
*/

-- Question #1
SELECT player_id, full_name, conference, games_played, pts,
	ROUND(CAST(pts AS NUMERIC) / NULLIF(CAST(games_played AS NUMERIC), 0), 2) AS raw_ppg
FROM public.players p
LEFT JOIN public.team USING(team_id)
LEFT JOIN public.player_stats USING(player_id)
WHERE season = 2022 AND p.status = 'active' AND t.conference = 'Western'
;

-- Question #2
-- Without CTE
SELECT t.team_full_name, team_id, season, game_type, COUNT(DISTINCT game_id)
FROM public.team t
LEFT JOIN public.games g ON t.team_id = g.away_team_id or t.team_id = g.home_team_id
WHERE game_type = 'playoffs'
GROUP BY t.team_full_name, team_id, season, game_type;

-- With CTE
WITH away_team_playoffs AS (
	SELECT season, game_type, away_team_id, COUNT(DISTINCT game_id) AS games_played
	FROM public.games
	WHERE game_type = 'playoffs'
	GROUP BY season, game_type, away_team_id
), home_team_playoffs AS (
	SELECT season, game_type, home_team_id, COUNT(DISTINCT game_id) AS games_played
	FROM public.games
	WHERE game_type = 'playoffs'
	GROUP BY season, game_type, home_team_id
) SELECT t.team_full_name, t.team_id, htp.season, htp.game_type, atp.games_played + htp.games_played AS games_played
FROM away_team_playoffs atp
LEFT JOIN home_team_playoffs htp ON htp.home_team_id = atp.away_team_id
LEFT JOIN public.team t ON atp.away_team_id = t.team_id
GROUP BY t.team_full_name, t.team_id, htp.season, htp.game_type, atp.games_played, htp.games_played;

-- Question #3
-- Kevin Durant comes in with the highest avg minutes!
SELECT full_name, player_id, season, game_type, games_played, minutes, ROUND(CAST(minutes AS NUMERIC) / NULLIF(CAST(games_played AS NUMERIC), 0), 2) as avg_mpg
FROM public.player_stats
LEFT JOIN public.players USING (player_id)
WHERE game_type = 'playoffs' -- AND games_started > ROUND(games_played / 2)
ORDER BY ROUND(CAST(minutes AS NUMERIC) / NULLIF(CAST(games_played AS NUMERIC), 0), 2) DESC;

-- Question #4
/*
    1) "Joel Embiid"
    2) "Giannis Antetokounmpo"
    3) "Jayson Tatum"
    4) "Stephen Curry"
    5) "Kevin Durant"
*/
with game_types as (
	SELECT player_id, COUNT(DISTINCT game_type) AS game_types -- distinct game types, not number of statlines is the counter
	FROM public.player_stats
	GROUP BY player_id
)
SELECT full_name, team_full_name, season, games_played, pts, ROUND(CAST(pts AS NUMERIC) / NULLIF(CAST(games_played AS NUMERIC), 0), 2) AS avg_ppg
FROM public.player_stats
LEFT JOIN game_types USING(player_id)
LEFT JOIN public.players USING(player_id)
LEFT JOIN public.team USING (team_id)
WHERE game_types = 2 AND game_type = 'regular' AND season = 2022
ORDER BY ROUND(CAST(pts AS NUMERIC) / NULLIF(CAST(games_played AS NUMERIC), 0), 2) DESC
LIMIT 5; -- remove this to see more results!
