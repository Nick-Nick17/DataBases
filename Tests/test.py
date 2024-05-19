import pytest
import psycopg2
import psycopg2.extras 

conn = psycopg2.connect(host='localhost', dbname='pg_db', user='pos', password='12345')

class Testing:
    """
    Поиск центральных защитников
    """
    def test_finding_cb(self):
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(
        '''
            select PlayerName
            from football.Players
            where positionsplayed like '%CB%';
        ''')
        res = cursor.fetchall()
        expected = ['Sergio Ramos', 'Virgil van Dijk']
        for player in expected:
            assert([player] in res)
        cursor.close()

    """
    Самые голевые матчи
    """
    def test_most_goals_matches(self):
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(
        '''
            select 
	            (HomeTeamScored + GuestTeamScored) as goals_scored,
	            t1.TeamName as home_team,
            	t2.teamname as guest_team
                from football.GameResults g
                join football.teams t1 on g.hometeamid = t1.teamid
                join football.teams t2 on g.guestteamid = t2.teamid
                order by (HomeTeamScored + GuestTeamScored) DESC;
        ''')
        res = cursor.fetchall()
        order = [int(res['goals_scored']) for res in cursor.fetchall()]
        assert(all(order[i] >= order[i+1] for i in range(len(order) - 1)))
        cursor.close()

    """
    Поиск центральных защитников
    """
    def test_player_in_teams(self):
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute(
        '''
            select PlayerName
            from football.contracts c
            join football.players p on c.playerid = p.playerid 
            join football.teams t on c.teamid = t.teamid
            where TeamName = 'Sevilla';
        ''')
        res = cursor.fetchall()
        expected = ['Kevin De Bruyne', 'Antoine Griezmann']
        for player in expected:
            assert([player] in res)
        cursor.close()

