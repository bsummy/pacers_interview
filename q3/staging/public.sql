CREATE TABLE public.team (
    team_id INT,
    league_id VARCHAR(3),
    team_full_name VARCHAR(50),
    division VARCHAR(10),
    conference VARCHAR(25),
    status VARCHAR(10),
	last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.players (
    player_id INT,
    team_id INT,
    league_id VARCHAR(3),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(50),
    jersey_number INT,
    position_simple VARCHAR(10),
    status VARCHAR(10),
	last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.games (
    game_id INT,
    league_id VARCHAR(3),
    season INT,
    game_type VARCHAR(20),
    game_date VARCHAR(50),
    game_time VARCHAR(50),
    game_status VARCHAR(15),
    home_team_id INT,
    away_team_id INT,
    home_score INT,
    away_score INT,
    point_difference INT,
	last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.player_stats (
    player_id INT,
    league_id VARCHAR(3),
    season INT,
    game_type VARCHAR(10),
    games_played INT,
    games_started INT,
    minutes FLOAT,
    total_seconds FLOAT,
    fgm INT,
    fga INT,
    fg_pct FLOAT,
    "2fgm" INT,
    "2fga" INT,
    "2fg_pct" FLOAT,
    "3fgm" INT,
    "3fga" INT,
    "3fg_pct" FLOAT,
    ftm INT,
    fta INT,
    ft_pct FLOAT,
    oreb INT,
    dreb INT,
    reb INT,
    ast INT,
    tov INT,
    stl INT,
    blk INT,
    blka INT,
    pf INT,
    techs INT,
    plusminus INT,
    pts INT,
    pfd INT,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

COPY public.player_stats(player_id,league_id,season,game_type,games_played,games_started,minutes,total_seconds,fgm,fga,fg_pct,"2fgm","2fga","2fg_pct","3fgm","3fga","3fg_pct",ftm,fta,ft_pct,oreb,dreb,reb,ast,tov,stl,blk,blka,pf,techs,plusminus,pts,pfd)
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
