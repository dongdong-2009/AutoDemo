#! /usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
from decimal import Decimal
from datetime import datetime,date,timedelta
import mysql.connector
from mysql.connector import errorcode


class resources(object):
    
    def __init__(self):
        self.config = {'user':'root',
                'password':'banrieen',
                'host':'192.168.56.202',
                'database':'learn_example'
                       }
        
    def connect_db(self,configs):
        configs = {'user':'root',
                'password':'banrieen',
                'host':'192.168.56.202',
                 }
        try:
            cnx = mysql.connector.connect(**configs)
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_ACCESS_DENIED_CHANGE_USER_ERROR:
                print ("user name or Passwd for database is wrong !")
            if err.errno == errorcode.ER_BAD_DB_ERROR:
                print ("Database does not exist !")
            else:
                print (err)
        return cnx
    
    def create_db(self,cnx,DB_NAME):
        if not DB_NAME:
            DB_NAME = 'employees'
        cursor = cnx.cursor()
        try:
            cursor.execute(
                "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))  
        except mysql.connector.Error as err:
            print ("Failed creating database: {}".format(err))      
            exit(1)
        try:
            cnx.database = DB_NAME
        except mysql.connector.Error as err:
            if err.errno == errorcode.ER_BAD_DB_ERROR:
                print (err)
                exit(1)
    
    def delete_db(self,DB_NAME,cnx):
        if DB_NAME:
            cursor = cnx.cursor()
            try:
                cursor.execute(
                    "Drop DATABASE {} ".format(DB_NAME))  
            except mysql.connector.Error as err:
                print ("Failed creating database: {}".format(err))      
                exit(1)
    
    def create_tables(self,cnx,DB_NAME):
        TABLES = {}
        TABLES['employees'] = (
            "CREATE TABLE `employees` ("
            " `emp_no` int(11) NOT NULL AUTO_INCREMENT, "
            " `birth_date` date NOT NULL,"
            " `first_name` varchar(14) NOT NULL, "
            " `last_name` varchar(16) NOT NULL, "
            " `gender` enum('M','F') NOT NULL," 
            " `hire_date` date NOT NULL, "
            " PRIMARY KEY (`emp_no`)"
            ") ENGINE=InnoDB")
        
        TABLES['departments'] = (
            "CREATE TABLE `departments` ("
            " `dept_no` char(4) NOT NULL,"
            " `dept_name` varchar(40) NOT NULL,"
            " PRIMARY KEY (`dept_no`), UNIQUE KEY `dept_name` (`dept_name`)"
            ") ENGINE=InnoDB")
        
        TABLES['salaries'] = (
            "CREATE TABLE `salaries` ("
            " `emp_no` int(11) NOT NULL, "
            " `salary` int(11) NOT NULL, "
            " `from_date` date NOT NULL, "
            " `to_date` date NOT NULL, "
            " PRIMARY KEY (`emp_no`,`from_date`), KEY `emp_no` (`emp_no`)"
            ") ENGINE=InnoDB" )       

        
        TABLES['titles'] = (
            "CREATE TABLE `titles` ("
            "  `emp_no` int(11) NOT NULL,"
            "  `title` varchar(50) NOT NULL,"
            "  `from_date` date NOT NULL,"
            "  `to_date` date DEFAULT NULL,"
            "  PRIMARY KEY (`emp_no`,`title`,`from_date`), KEY `emp_no` (`emp_no`),"
            "  CONSTRAINT `titles_ibfk_1` "
            "      FOREIGN KEY (`emp_no`) REFERENCES `employees`(`emp_no`) ON DELETE CASCADE"
            ") ENGINE=InnoDB")
        
        TABLES['dept_emp'] = (
            "CREATE TABLE `dept_emp` ("
            "  `emp_no` int(11) NOT NULL,"
            "  `dept_no` char(4) NOT NULL,"
            "  `from_date` date NOT NULL,"
            "  `to_date` date NOT NULL,"
            "  PRIMARY KEY (`emp_no`,`dept_no`), KEY `emp_no` (`emp_no`),"
            "  KEY `dept_no` (`dept_no`),"
            "  FOREIGN KEY (`emp_no`) REFERENCES `employees`(`emp_no`) ON DELETE CASCADE,"
            "  FOREIGN KEY (`dept_no`) REFERENCES `departments`(`dept_no`) ON DELETE CASCADE"
            ") ENGINE=InnoDB;")

        TABLES['dept_manager'] = (
            "  CREATE TABLE `dept_manager` ("
            "  `emp_no` int(11) NOT NULL,"
            "  `dept_no` char(4) NOT NULL,"
            "  `from_date` date NOT NULL,"
            "  `to_date` date NOT NULL,"
            "  PRIMARY KEY (`emp_no`,`dept_no`),"
            "  CONSTRAINT `dept_manager_ibfk_1` "
            "      FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,"
            "  CONSTRAINT `dept_manager_ibfk_2` "
            "      FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE"
            ") ENGINE=InnoDB;" )
        
        
        for name,ddl in TABLES.items():
            try:
                cursor = cnx.cursor()
                print ("Creating table {}: ".format(name),end=' ')
                cursor.execute(ddl)
            except mysql.connector.Error as err:
                print (err.msg)
        cursor.close()
        cnx.close()
        
    def select_keys(self,cnx):
        try:
            cnx.database = 'learn_example'
            cursor = cnx.cursor() 
                # Read a single record
                #sql = "SELECT `goal`  FROM `student` order by goal desc
            sursor = cursor.execute("SELECT `goal`  FROM `student` " )
            print (sursor)
        finally:
            cnx.close()
            
    def insert_table(self,cnx,database):
        cnx.database = database
        print (cnx.database)
        query = ("SELECT s.emp_no,salary,from_date,to_date FROM employees AS e "
                 "LEFT JOIN salaries AS s USING (emp_no) "
                 "WHERE to_date = DATE('9999-01-01')"
                 "AND e.hire_date BETWEEN DATE('%s') AND DATE(%s)" )    
        update_old_salary = (
            "UPDATE slaries SET to_date = %s"
            "WHERE emp_no = %s AND from_date = %s"
            )    
        insert_new_salary = (
            "INSERT INTO salaries (emp_no,from_date,to_date, salary)"
            "VALUES (%s,%s,%s,%s)")
        curA.execute(query,date(2000,1,1),date(2000,12,31))
        print ("Debug SQL Insert !")
        for (emp_no,salary, from_date, to_date) in curA:
            print ("Debug SQL Insert !")
            new_salary = int(round(salary * Decimal('1.15')))
            print ("Debug SQL Insert !")
            tomorrow = datetime.now().date() + timedelta(days=1)
            print ("tomorrowis : ", tomorrow)
            curB.execute(update_old_salary,(tomorrow,emp_no,from_date))
            curB.execute(insert_new_salary,
                         (emp_no,tomorrow,date(9999,1,1), new_salary))
            cnx.commit()
            
        cnx.close()
        
if __name__ == "__main__":
    db_1 = resources()
    configs = {'user':'root',
        'password':'banrieen',
        'host':'192.168.56.202',
         }
    DB_NAME = 'employees'
    cnx = db_1.connect_db(configs)
    db_1.delete_db(DB_NAME,cnx)
    #db_1.select_keys(cnx)
    db_1.create_db(cnx,DB_NAME)
    db_1.create_tables(cnx,DB_NAME)
    #db_1.insert_table(cnx,DB_NAME)
    