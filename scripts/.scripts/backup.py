#!/usr/bin/python

from datetime import timedelta
from dotenv import load_dotenv
from os.path import join, dirname
import datetime
import json
import logging
import os
import requests
import shutil
import subprocess
import sys

# Create .env file path
dotenv_path = join(dirname(__file__), '.env')

# Load file from the path
load_dotenv(dotenv_path)

c = [
    'Photos/',
    'Wallpapers/',
]
music = 'Music/'

rawday = datetime.datetime.today()
today = rawday.strftime('%Y-%m-%d')
oldest = rawday - timedelta(days=7)
user = '/mnt/c/Users/Juan/'
drop = user + 'Dropbox/'
media = '/mnt/d/'
bud = '/mnt/d/Backup/'
backup = bud + today
b2 = 'b2:helms-deep/guzman-backup/' + today
rsync = [
    'rsync',
    '--times',
    '--recursive',
    '--delete',
    '--exclude=.dropbox',
    '--exclude=desktop.ini',
    '--exclude=.tmp.drivedownload',
    '--exclude=.git',
    '--exclude=.gitignore',
    '--exclude=README.md',
    '--exclude=LICENSE'
]
rclone = ['rclone', 'sync']
remove = bud + oldest.strftime('%Y-%m-%d')
hook = os.getenv('SLACK_HOOK')

# Add progress flag if running on visual terminal
if sys.stdout.isatty():
    rsync.append('--progress')
    rclone.append('--progress')

# Logging config
LOG_FILENAME = user + 'Dropbox/Logs/sync.log'
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s',
                    datefmt='%y-%b-%d %H:%M:%S',
                    filename=LOG_FILENAME)

# Post errors to Slack
def slack_erros(message):
    try:
        data = {'text': message}

        response = requests.post(
            hook, data=json.dumps(data),
            headers={'Content-Type': 'application/json'}
        )
        if response.status_code != 200:
            raise ValueError(
                'Request to slack returned an error %s, the response is:\n%s'
                % (response.status_code, response.text)
            )
    except Exception as e:
        logging.exception(e)

# Create today's Backup Directory
try:
    os.makedirs(backup)
    os.makedirs(os.path.join(backup, music))
    for copy in c:
        os.makedirs(os.path.join(backup, copy))
    logging.info('Backup directory created')
except Exception as e:
    logging.exception(e)
    slack_erros(today + '-' + e)

# Sync files to newly create Backup Directory
try:
    subprocess.call(rsync + [os.path.join(media, music), os.path.join(backup, music)])
    for folder in c:
        subprocess.call(rsync + [os.path.join(drop, folder), os.path.join(backup, folder)])
    logging.info('Files synced')
except Exception as e:
    logging.exception(e)
    slack_erros(today + '-' + e)

# Upload Back to b2 bucket
try:
    subprocess.call(rclone + [backup, b2])
    logging.info('Backup sent to b2')
except Exception as e:
    logging.exception(e)
    slack_erros(today + '-' + e)

# Deconste local backup older than 30 days
try:
    shutil.rmtree(remove)
    logging.info('Old backup deleted')
except Exception as e:
    logging.exception(e)
    slack_erros(today + '-' + e)
