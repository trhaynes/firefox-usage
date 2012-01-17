"""
Break the all_sessions_sorted.txt file into 10 minute chunks
"""


import csv, sys
from datetime import datetime, timedelta

reader = csv.reader(open("all_sessions_sorted.txt", 'rb'), delimiter="|")

timestamp = None
user = 0

sessions = []

current_session = None

for row in reader:  
  if reader.line_num == 1: continue # skip the header row
  if row[2] == "": continue # skip rows without q6 (age) values
  # if reader.line_num > 10000: break # for testing
  event_code = int(row[3])
  timestamp = int(row[4])
  if int(row[0]) == user:
    if event_code == 1 or event_code == 4: # start/active
      
      if current_session == None:
        current_session = {}
        current_session['start'] = timestamp
        current_session['user'] = user
        current_session['q6'] = int(row[2])      
      
    elif event_code == 2 or event_code == 5: # end/inactive
     
      if current_session != None:        
        if current_session['start'] < timestamp: # might have missed the start event
          current_session['end'] = timestamp
          sessions.append(current_session)
        current_session = None
        
  else:
    # new user
    user = int(row[0])
    current_session = None

start = 1288756800 # Nov 3, 00:00    
# interval = [start+i*60*60 for i in range(7*24+1)] # every hour
interval = [start+i*60 for i in range(7*24*60+1)] # every ten minutes

print "q6|stimestamp|total"
for age in range(5,6):
  for i in interval:
    total = 0
    for session in sessions:
      if session['q6'] == age and session['start']/1000.0 < i and i <= session['end']/1000.0:
        total += 1
    print "%d|%d|%d" % (age, i, total)
    