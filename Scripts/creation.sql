-----Создание дазы банных-------
create schema if not exists football;


create table if not exists football.Teams (
	TeamName     varchar(50)    not null,
	TeamID       serial         primary key,
	Stadium      varchar(50)    not null
);

create table if not exists football.Players (
	PlayerID          serial         primary key,
	PlayerName        varchar(50)    not null,
	PositionsPlayed   varchar(50)    not null
);

create table if not exists football.Contracts (
	ContractID        serial         primary key,
	IsActual          bool           not null,
	DateOfSigning     date           not null,
	PlayerID          int references football.Players,
	TeamID            int references football.Teams
);

create table if not exists football.Tournaments (
	TournamentID     serial        primary key,
	TournamentName   varchar(50)   not null,
	Country          varchar(50)
);

create table if not exists football.GameResults (
	GameID            serial  primary key,
	TournamentID      int     references football.Tournaments,
	HomeTeamID        int     references football.Teams (TeamID),
	HomeTeamScored    int     check (HomeTeamScored >= 0),
	GuestTeamID       int     references football.Teams (TeamID),
	GuestTeamScored   int     check (GuestTeamScored >= 0)
);

create table if not exists football.Scouts (
	ScoutID           serial        primary key,
	ScoutName              varchar(50)   not null,
	CompanyPosition   VARCHAR(50)   not null,
	LocationNow       VARCHAR(50),
	IsInCompany       bool
);

create table if not exists football.GameNotes (
	NoteID     serial primary key,
        GameID     int    references football.GameResults,
	PlayerID   int    references football.Players,
	ScoutID    int    references football.Scouts,
	Node       text
);

insert into football.Teams (teamname, stadium)
values
('Manchester United','Old Trafford'),
('Manchester City','Etihad'),
('Liverpool','Anfield'),
('Sevilla',''),
('Barcelona', 'Camp Nou'),
('Real Madrid', 'Santiago Bernabeu'),
('Milan', 'San Siro'),
('Inter Milan', 'San Siro'),
('Inter Maiami', 'MLS staium'),
('Chealse', 'Stamford Bridge');


-- Вставка данных в таблицу Players
insert into football.Players (PlayerName, PositionsPlayed)
values
('Cristiano Ronaldo', 'RW'),
('Lionel Messi', 'RW'),
('Mohamed Salah', 'ST'),
('Sergio Ramos', 'CB'),
('Romelu Lukaku', 'ST'),
('Kylian Mbappe', 'ST'),
('Kevin De Bruyne', 'CAM, CM'),
('Robert Lewandowski', 'ST'),
('Neymar Jr.', 'LW'),
('Virgil van Dijk', 'CB'),
('Eden Hazard', 'LW'),
('Harry Kane', 'ST'),
('Luka Modric', 'CM'),
('Sadio Mane', 'LW'),
('Antoine Griezmann', 'ST');

-- Вставка данных в таблицу Players
insert into football.contracts (playerid, TeamID, isactual, dateofsigning)
values
(1, 1, true, '2022-01-15'),
(2, 5, true, '2022-01-15'),
(3, 3, true, '2022-01-15'),
(4, 6, true, '2022-01-15'),
(5, 8, true, '2022-01-15'),
(6, 2, true, '2022-01-15'),
(7, 4, true, '2022-01-15'),
(8, 7, true, '2022-01-15'),
(9, 2, true, '2022-01-15'),
(10, 1, true, '2022-01-15'),
(11, 3, false, '2022-01-15'),
(12, 5, true, '2022-01-15'),
(13, 6, true, '2022-01-15'),
(14, 8, true, '2022-01-15'),
(15, 4, true, '2022-01-15');

-- Вставка данных в таблицу Tournaments
insert into football.Tournaments (TournamentName, Country)
VALUES
('Premier League', 'England'),
('La Liga', 'Spain'),
('Serie A', 'Italy'),
('MLS Cup', 'USA'),
('Bundesliga', 'Germany'),
('Ligue 1', 'France'),
('Primeira Liga', 'Portugal'),
('Eredivisie', 'Netherlands'),
('Russian Premier League', 'Russia'),
('Scottish Premiership', 'Scotland'),
('J1 League', 'Japan'),
('Brasileirao Serie A', 'Brazil'),
('Super Lig', 'Turkey'),
('Chinese Super League', 'China'),
('A-League', 'Australia');

-- Вставка данных в таблицу GameResults
insert into football.GameResults (TournamentID, HomeTeamID, HomeTeamScored, GuestTeamID, GuestTeamScored)
values
(1, 1, 2, 3, 1),
(2, 5, 3, 6, 2),
(3, 7, 1, 8, 0),
(4, 2, 4, 4, 2),
(5, 6, 1, 7, 3),
(6, 8, 2, 1, 2),
(7, 3, 3, 5, 0),
(8, 4, 0, 6, 1),
(9, 7, 2, 9, 2),
(1, 1, 3, 8, 1);

-- Вставка данных в таблицу GameNotes
insert into football.Scouts (ScoutName, CompanyPosition, LocationNow, IsInCompany)
values
('Bob', 'Main Scout', 'England', true),
('Mr. Kek', 'Senior Scout', 'Englad', true),
('Peter Parker', 'Junior Scout', 'USA', true),
('Simpson', 'Junior Scout', 'USA', false),
('Mostovoy', 'Seniour Scout', 'Russia', true);


-- Вставка данных в таблицу GameNotes
insert into football.GameNotes
values
(default, 1, 1, 1, 'Great Game, CR7 is the GOAT'),
(default, 2, 2, 2, 'Great Game, Messi is the GOAT'),
(default, 3, 3, 3, 'Good confident game, created chances for my team, lost ball a lot');
