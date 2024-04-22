import pyodbc
from datetime import datetime
import os
import csv
from natsort import natsorted

#List csv files directories
def get_file_lists(dirName):
  # Create a list of file and sub directories 
  file_lists = os.listdir(dirName)
  file_lists = natsorted(file_lists)
  all_files = []
  # Iterate over all the entries
  for entry in file_lists:
    # Create full path
    full_path = os.path.join(dirName, entry)

    # If entry is a directory then get the list of files in this directory 
    if os.path.isdir(full_path):
      all_files = all_files + get_file_lists(full_path)
    else:
      all_files.append(full_path)

  return all_files

fileList = get_file_lists("csv")
for filename in fileList:
  all_value = []
  csv_array = []
  with open(filename, encoding='utf8') as csv_file:
    csvfile = csv.reader(csv_file)
    for r in csvfile:
      csv_array.append(r)
    csv_array.pop(0)

    for row in csv_array:
      row[14] = datetime.now()
      row[15] = datetime.now()
      
      value = (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], row[13], row[14], row[15])
      all_value.append(value)

      insert_query = """INSERT INTO chatbot_data
                        (conversation_at, user_id, conversation_id, message, button, question_category_one, question_category_two, question_category_three, reply, language, area, country, residential_area, user_interface, created_at, updated_at)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"""
        
    server = "localhost,1433"
    database = "miyoshi_development"
    username = "sa"
    password = "P@ssw0rd2022"

    conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
    cursor = conn.cursor()
    cursor.executemany(insert_query, all_value)
    conn.commit()
    cursor.close()
