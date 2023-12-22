CREATE TEMP TABLE hockey_reference_temp (LIKE hr.pick_selections INCLUDING DEFAULTS);

COPY pick_selections_temp(draft_year, overall_pick, team, player_id_hockey_reference, player, nationality, position, age, to, amateur_team, skater_games_played, goals, assists, points, plus_minus, penalty_minutes, goalie_games_played, wins, losses, ties, save_percentage, goals_against_average, point_shares, hash)
FROM '/Users/bennettsummy/VSC_Projects/nhl-draft-pick-value/hockey_reference/processed/hr_2023.csv'
DELIMITER ','
CSV HEADER;

COPY pick_selections_temp(draft_year, round, overall_pick, pick_in_round, team, transactions, player, is_pick_lottery, hash)
FROM '/Users/bennettsummy/VSC_Projects/nhl-draft-pick-value/staging/past_picks.csv'
DELIMITER ','
CSV HEADER;

/* Selecting the Target and the Source */
MERGE INTO pst.pick_selections as main
USING pick_selections_temp as temp
ON main.draft_year = temp.draft_year AND main.overall_pick = temp.overall_pick
	WHEN MATCHED AND main.hash <> temp.hash THEN -- could add conditionals here
	/* Update the records in TARGET */
	UPDATE
		SET team = temp.team,
        is_pick_lottery = temp.is_pick_lottery,
		transactions = temp.transactions,
        round = temp.round,
        pick_in_round = temp.pick_in_round,
        player = temp.player,
        hash = temp.hash,
        last_updated = temp.last_updated

	/* When no records are matched with TARGET table
	Then insert the records in the target table */
	WHEN NOT MATCHED THEN INSERT (draft_year, round, is_pick_lottery, overall_pick, pick_in_round, team, transactions, player, hash)
		VALUES (temp.draft_year, temp.round, temp.is_pick_lottery, temp.overall_pick, temp.pick_in_round, temp.team, temp.transactions, temp.player, temp.hash)
;

DROP TABLE pick_selections_temp;
