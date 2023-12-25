

COPY public.player_stats(player_id, team_id, league_id, first_name, last_name, full_name, jersey_number, position_simple, status)
FROM '/Users/bennettsummy/pacers_interview/q3/staging/player_stats.csv'
DELIMITER ','
CSV HEADER;

COPY public.players(player_id, team_id, league_id, first_name, last_name, full_name, jersey_number, position_simple, status)
FROM '/Users/bennettsummy/pacers_interview/q3/staging/players.csv'
DELIMITER ','
CSV HEADER;

COPY public.games(game_id, league_id, season, game_type, game_date, game_time, game_status, home_team_id, away_team_id, home_score, away_score, point_difference)
FROM '/Users/bennettsummy/pacers_interview/q3/staging/games.csv'
DELIMITER ','
CSV HEADER;

COPY public.team(team_id, league_id, team_full_name, division, conference, status)
FROM '/Users/bennettsummy/pacers_interview/q3/staging/teams.csv'
DELIMITER ','
CSV HEADER;
