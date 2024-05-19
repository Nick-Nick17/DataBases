--1. Вывести все команды и их стадионы:
select TeamName, Stadium
from football.Teams;

--2. Вывести скаутов, которые сейчас находятся на должности в компании.
select ScoutName 
from football.Scouts 
where IsInCompany = true;

--3. Вывести все турниры и страны, в которых они проходят:
select TournamentName, Country
from football.Tournaments;

--4. Вывести результаты игр (ID игры, название турнира, команды-участники и счет):
select GameID, TournamentName, HomeTeamID, HomeTeamScored, GuestTeamID, GuestTeamScored
from football.GameResults
join football.Tournaments on GameResults.TournamentID = Tournaments.TournamentID;

--5. Вывести количество игр в каждом турнире:
select TournamentName, count(GameID) as Number_of_games
from football.GameResults gr
join football.Tournaments t ON gr.TournamentID = t.TournamentID
group by TournamentName
order by Number_of_games desc;

--6. Вывести все контракты, подписанные в определённые даты(в примере - зимнее трансферное окно сезона 22/23):
select DateOfSigning, PlayerName, TeamName
from football.Contracts C
join football.Players P ON C.PlayerID = P.PlayerID
join football.Teams T ON C.TeamID = T.TeamID
where DateOfSigning < '2022-02-01' and DateOfSigning > '2022-01-01';

--7. Вывести количество игроков в каждой команде.
select TeamName, count(PlayerID) as players_count
from football.Contracts c
join football.Teams t on c.TeamID = t.TeamID
where c.isactual = true
group by TeamName;

--8. Найти игры, в которых участвовала команда Manchester United:
select GameID, TournamentName, HomeTeamID, HomeTeamScored, GuestTeamID, GuestTeamScored
from football.GameResults
join football.Teams on GameResults.HomeTeamID = Teams.TeamID or GameResults.GuestTeamID = Teams.TeamID
join football.Tournaments on GameResults.TournamentID = Tournaments.TournamentID
where TeamName = 'Manchester United';


--9. Вывести топ-3 команды с наивысшим количеством выигранных матчей:
select
	TeamName,
	count(case when HomeTeamScored > GuestTeamScored then 1 else 0 end +
          case when GuestTeamScored > HomeTeamScored then 1 else 0 end) as Wins
from football.GameResults
join football.Teams on GameResults.HomeTeamID = Teams.TeamID or GameResults.GuestTeamID = Teams.TeamID
group by TeamName
order by Wins desc
limit 3;

--10. Вывести топ-3 самых продуктивных скаутов по количеству заметок о игроках.
select s.ScoutName, count(n.NoteID) as NotesCount
from football.GameNotes n
join football.Scouts s ON n.ScoutID = s.ScoutID
group by s.ScoutName
order by NotesCount desc
limit 3;
