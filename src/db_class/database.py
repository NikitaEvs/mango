import sqlite3
import os
from datetime import datetime

from src.data_class.task import Task

class Database:
    """
    Base class for working with SQLite database
    """

    def __init__(self, relative_path="../../resources/database/mango.db"):
        """
        Constructor for initialize database, invoke sqlite3 connection
        :param relative_path: relative path to database file
        """
        file_dir = os.path.dirname(os.path.abspath(__file__))
        self.path = os.path.join(file_dir, relative_path)

        self.__connect = sqlite3.connect(self.path)
        self.__cursor = self.__connect.cursor()
        self.create_database()

    def __enter__(self):
        return self

    def __exit__(self, ext_type, exc_value, traceback):
        """
        Invoke closing of database with exception
        :param ext_type: default __exit__ param
        :param exc_value: default __exit__ param
        :param traceback: default __exit__ param
        :return:
        """
        self.__cursor.close()

        if isinstance(exc_value, Exception):
            self.__connect.rollback()
        else:
            self.__connect.commit()

        self.__connect.close()

    def __del__(self):
        """
        Invoke closing of database with deletion
        :return:
        """
        self.__connect.close()

    def __drop(self):
        """
        Drop table in database
        :return:
        """
        self.__cursor.execute("""
                            DROP TABLE tasks
                            """)

        self.__connect.commit()

    def create_database(self):
        self.__cursor.execute("""
                            CREATE TABLE IF NOT EXISTS tasks (
                                task_id integer primary key, 
                                name text, 
                                start datetime, 
                                finish datetime
                            )
                            """)

    def clear_database(self):
        """
        Reload table in database
        :return:
        """
        self.__drop()
        self.create_database()

    def add_task(self, task):
        """
        Add task to database
        :param task: task to add
        :return: none
        """
        self.__cursor.execute("""
                            INSERT INTO tasks
                            VALUES (?,?,?,?) 
                            """, task.get_list())

        self.__connect.commit()

    def get_task(self, *args, **kwargs):
        """
        Provide access to the database with specific requests
        For now, works only day request
        :param args: none
        :param kwargs: day=request day
        :return: list of Task
        """
        if "day" in kwargs.keys():
            return self.__get_task_via_day(kwargs["day"])


    def __get_task_via_day(self, day):
        """
        Provide access to the database with day request
        :param day: request day
        :return: list of Task
        """
        self.__cursor.execute("""
                            SELECT * FROM tasks WHERE start 
                            BETWEEN DATETIME(?, 'start of day') 
                            AND DATETIME(?, '+1 day', 'start of day')
                            """, [day, day])

        tasks_row = self.__cursor.fetchall()
        tasks = []
        format_str = "%Y-%m-%dT%H:%M:%S"

        for task_row in tasks_row:
            tasks.append(Task(task_row[1],
                              datetime.strptime(task_row[2], format_str),
                              datetime.strptime(task_row[3], format_str),
                              task_row[0]))

        return tasks
