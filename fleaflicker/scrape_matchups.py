from sqlalchemy import create_engine
import pandas as pd
from pandas import DataFrame
import requests
from bs4 import BeautifulSoup as Soup
import os
from datetime import datetime
from functools import partial
import re
import numpy as np

engine = create_engine(os.environ['BBDB_POSTGRES'])

raw_url = 'http://www.fleaflicker.com/nfl/leagues/34958/scores'

proc_url = requests.get(raw_url)
btn btn-default btn-xs
soup = Soup(proc_url.text, "lxml")

score_urls = [tag.get('href') for tag in soup.find_all('a') 
        if tag.get('class') == ['btn', 'btn-default', 'btn-xs'] and 
        tag.string == 'Live!']

for tag in soup.find_all('a'):
    print(tag.get('href'))
