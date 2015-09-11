import sys
from sqlalchemy import create_engine
sys.path.append('/Users/nathan/bb-bowl/fleaflicker')
import ffutil as ff
import os
from random import randint
from pandas import DataFrame
 
class TestUtilities:

    def setup(self):
        print('TestUtilities:setup() before each test method')
        self.engine = create_engine(os.environ['BBDB_POSTGRES'])
        self.positions = ['QB', 'RB1', 'RB2', 'WR1', 'WR2', 'TE', 'K', 'D']


    def teardown(self):
        print('TestUtilities:teardown() after each test method')

    
    def test_matchup_scraper(self):
        matchup_urls = ff._matchup_urls() 
        assert len(matchup_urls) == 6


    def test_single_matchup(self):
        matchup_urls = ff._matchup_urls() 
        url = matchup_urls[randint(0,5)]
        mu = DataFrame(ff._single_matchup(url))
        assert set(mu.index) == set(self.positions)

