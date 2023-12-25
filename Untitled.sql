

Select player_id, full_name, conference, games_played, pts, 
	
	ROUND(CAST(pts AS numeric) / NULLIF(CAST(games_played AS Numeric), 0), 2) AS raw_ppg
from public.players p
left join public.team using(team_id)
left join public.player_stats using(player_id)
where season = 2022 and p.status = 'active'
;


select team_id, season, game_type, count(distinct game_id) from public.team t
left join public.games g on t.team_id = g.away_team_id or t.team_id = g.home_team_id
where game_type = 'playoffs'
group by team_id, season, game_type;



