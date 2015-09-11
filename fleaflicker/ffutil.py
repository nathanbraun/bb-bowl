import pandas as pd
from pandas import DataFrame
import requests
from bs4 import BeautifulSoup as Soup
import os

ffcom = 'http://www.fleaflicker.com'

def _matchup_urls(league_id = 34958):
    """ Get urls to every matchup for current week given some league_id
    (defaults to BB Bowl).
    """
    league_url = ffcom + '/nfl/leagues/{0}'
    raw_url = league_url.format(league_id) + '/scores'

    proc_url = requests.get(raw_url)
    soup = Soup(proc_url.text, "lxml")

    score_urls = [tag.get('href') for tag in soup.find_all('a') 
            if tag.get('class') == ['btn', 'btn-default', 'btn-xs'] and 
            tag.string == 'Live!']

    return score_urls


def _single_matchup(matchup_url):
    """ Get starting lineups for both teams given some matchup url. """

    raw_url = ffcom + matchup_url
    proc_url = requests.get(raw_url)
    soup = Soup(proc_url.text, "lxml")

    positions = ['QB', 'RB1', 'RB2', 'WR1', 'WR2', 'TE', 'K', 'D']

    player_str = 'row_{0}_0_{1}'

    teams = {}
    for t in [0, 1]:
        tags = {}
        for i, pos in enumerate(positions):
            for tag in soup.find_all(id=player_str.format(t,i)):
                link = tag.find('a')
                if link:
                    tags.update({pos: link.string})

            teams.update({'team{0}'.format(t): tags})

    return teams


def starting_lineups(league_id = 34958):
    """ Get DataFrame of starting lineups given some league_id (defaults to BB
    Bowl). """
    lineups = DataFrame()

    for i, mu in enumerate(_matchup_urls(league_id)):
        single_matchup = DataFrame(_single_matchup(mu))
        linups = pd.concat([lineups, single_matchup], axis=1)

    lineups.columns = ['team{0}'.format(x) for x in range(12)] 
    return lineups
