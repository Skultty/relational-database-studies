-- Since we are goind to run this file each time after adding a new sql command, we need to drop the db if it already exists 
DROP DATABASE IF EXISTS  worldcup;

-- Create the database
CREATE DATABASE worldcup;

-- Use the database
\c worldcup;

-- Create teams table
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Create games table
CREATE TABLE games (
    game_id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    round VARCHAR(50) NOT NULL,
    winner_id INT REFERENCES teams(team_id) NOT NULL,
    opponent_id INT REFERENCES teams(team_id) NOT NULL,
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
);