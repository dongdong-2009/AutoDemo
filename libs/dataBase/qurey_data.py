from __future__ import print_function
from datetime import date, datetime, timedelta
import mysql.connector

cnx = mysql.connector.connect(user='root', password='banrieen', host='192.168.56.202',database='employees')
cursor = cnx.cursor()

tomorrow = datetime.now().date() + timedelta(days=1)


add_employee = ("INSERT INTO employees "
               "(first_name, last_name, hire_date, gender, birth_date) "
               "VALUES (%s, %s, %s, %s, %s)")

add_salary = ("INSERT INTO salaries "
              "(emp_no, salary, from_date, to_date) "
              "VALUES (%(emp_no)s, %(salary)s, %(from_date)s, %(to_date)s)")

select_employee = ("SELECT emp_no, first_name, last_name, hire_date FROM employees  "
                   "WHERE last_name = 'Vanderkelen' ")

select_salary = ("SELECT emp_no, salary FROM salaries  "
                   "WHERE emp_no = '500002' ")

data_employee = ('Geert', 'Vanderkelen', tomorrow, 'M', date(1977, 6, 14))
cursor.execute(add_employee, data_employee)
emp_no = cursor.lastrowid
# Insert salary information
data_salary = {
  'emp_no': emp_no,
  'salary': 5000000,
  'from_date': tomorrow,
  'to_date': date(9999, 1, 1),
}
cursor.execute(add_salary, data_salary)

cursor.execute(select_employee)
for (emp_no, first_namne, last_name, hire_date ) in cursor:
    print (emp_no,first_namne, last_name, hire_date )


cursor.execute(select_salary)
for (emp_no ) in cursor:
    print (emp_no)
# Make sure data is committed to the database
cnx.commit()

cursor.close()
cnx.close()