CREATE TABLE public.team (
    team_id Int,
    league_id VARCHAR(3),
    team_full_name VARCHAR(50),
    division VARCHAR(10),
    conference VARCHAR(25),
    status VARCHAR(10),
	last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.player (
    player_id INT,
    team_id VARCHAR(20),
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
    home_team_id INT
    away_team_id INT
    home_score INT
    away_score INT
    point_difference INT,
	last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.player_stats (
    player_id INT,
    league_id VARCHAR(3),
    season INT,
    game_type VARCHAR(10),
    games_played,
    games_started INT,
    minutes INT,
    total_seconds INT,
    fgm INT,
    fga INT,
    fg_pct INT,
    2fgm INT,
    2fga INT,
    2fg_pct INT,
    3fgm INT,
    3fga INT,
    3fg_pct INT,
    ftm INT,
    fta INT,
    ft_pct INT,
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
)
