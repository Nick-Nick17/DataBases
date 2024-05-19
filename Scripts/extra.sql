-------------------8) Представления-------------------

create or replace view available_defenders as
select
	Teams.TeamName as Team,
	Players.PlayerName as Name,
	Players.PositionsPlayed as Position,
	Contracts.DateOfSigning as date_of_signing
from football.Teams
join football.Contracts on Teams.TeamID = Contracts.TeamID
join football.Players on Contracts.PlayerID = Players.PlayerID
where 
	Contracts.IsActual and
	(players.PositionsPlayed like '%CB%' or
	players.PositionsPlayed like '%RB%' or
	players.PositionsPlayed like '%LB%');

select * from available_defenders

create or replace view strikers_notes as
select
	Scouts.ScoutName as Scout,
	Scouts.CompanyPosition as scout_job,
	Players.PlayerName as player_name,
	Players.PositionsPlayed as player_positions,
	GameNotes.Node as Note
from football.gamenotes
join football.players on GameNotes.PlayerID = Players.PlayerID
join football.scouts on GameNotes.ScoutID = Scouts.ScoutID
where
	(players.PositionsPlayed like '%LW%' or
	players.PositionsPlayed like '%RW%' or
	players.PositionsPlayed like '%ST%');

select * from strikers_notes



-------------------9) Индексы-------------------

-- 1) Индексы для быстрого доступа к работам скаутов по ScoutID и PlayerID
create index idx_notes_ScoutID on football.GameNotes (ScoutID);
create index idx_notes_PlayerID on football.GameNotes (PlayerID);

-- 2) Индексы для быстрого доступа к домашним и гостевым играм команды по TeamID
create index idx_home_games_TeamID on football.GameResults (HomeTeamID);
create index idx_guest_notes_TeamID on football.GameResults (GuestTeamID);

-- 3) Индексы для быстрого доступа к играм конкретного турнира по TournamentID
create index idx_games_res_TournamentID on football.GameResults (TournamentID);



-------------------10) Функции и процедуры-------------------

--1) Добавление команды в Базу Данных
create or replace procedure AddTeam(
    team_name VARCHAR(50),
    stadium VARCHAR(50)
)
as $$
begin
    insert into football.Teams(TeamName, Stadium) values ($1, $2);
end;
$$ language plpgsql;

call AddTeam('Krilya Sovetod', 'Samara-Arena');


--2) Добавление заметки по имени скаута
create or replace procedure AddGameNote(
    scout_name VARCHAR(50),
    game_id INT,
    player_id INT,
    note_text TEXT
)
as $$
declare
	scout_id INT;
begin
    select ScoutID
    into scout_id
    from football.Scouts
    where scout_name = Scouts.scoutname;
    insert into football.GameNotes (noteid, GameID, PlayerID, ScoutID, Node) values (default, game_id, player_id, scout_id, note_text);
end;
$$ language plpgsql;

insert into football.GameNotes (noteid, GameID, PlayerID, ScoutID, Node) values (default, 1, 1, 1, 'Created a lot space for his partners');

call AddGameNote('Bob', 1, 1, 'Created a lot space for his partners');
call AddGameNote('Mostovoy', 2, 2, 'Рigh level of understanding of the game');


--3) Функция, которая возвращает команду по названию
create or replace function GetTeam(
	TeamName varchar(50)	
)
returns table(Players varchar(50)) as $$
begin
	return query select
		p.playername
	from football.Players p
	join football.Contracts c on p.PlayerID = c.PlayerID
	join football.Teams t on c.TeamID = t.TeamID
	where c.isactual and t.teamname = $1;
end;
$$ language plpgsql;

select GetTeam('Manchester United');
select GetTeam('Sevilla');


-------------------11) Триггеры-------------------


-- 1) Изменение актуальности предыдущего контракта при появлении нового
create or replace function update_contract_status()
returns trigger as $$
begin
    update football.Contracts
    set IsActual = false
    where PlayerID = new.PlayerID and IsActual = true;
    return new;
end;
$$ language plpgsql;

create trigger update_contract_status_trigger
before insert on football.Contracts
for each row
execute function update_contract_status();

insert into football.contracts (playerid, TeamID, isactual, dateofsigning)
values (5, 1, true, '2023-01-15');



-- 2) Проверить, что результат матча является существующим
create or replace function check_match_results()
returns trigger as $$
begin
    if (new.HomeTeamID = new.GuestTeamID) then
        raise exception 'Одинаковые команды играют матч';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger check_match_results_trigger
before insert on football.gameresults
for each row
execute function check_match_results();


--Упадёт с ошибкой "Домашняя и гостевая команды совпадают"
insert into football.GameResults 
(GameID, TournamentID, HomeTeamID, HomeTeamScored, GuestTeamID, GuestTeamScored) 
values (default, 1, 1, 1, 1, 1);



-- 3) Обновляем скаута
create or replace function update_scouts()
returns trigger as $$
begin
    update football.scouts
    set IsInCompany = false
    where ScoutID = new.ScoutID and IsInCompany = true;
    return new;
end;
$$ language plpgsql;

create or replace trigger update_scout_trigger
before insert on football.scouts
for each row
execute function update_scouts();


insert into football.scouts (scoutID, ScoutName, CompanyPosition, LocationNow, IsInCompany)
values (default, 'Simpson', 'Middle Scout', 'England', true);
