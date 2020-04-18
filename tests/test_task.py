from src.data_class.task import Task
from src.db_class.database import Database
from datetime import datetime

"""
    Module with simple unit test for task
"""


def test_create():
    start = datetime(2020, 4, 7, 12, 30)
    finish = datetime(2020, 4, 7, 13, 50)
    task = Task("Test", start, finish)
    assert task.finish.hour == 13
    assert task.name == "Test"


def test_database():
    db = Database("/home/hutu/mango/resources/database/mango.db")
    start = datetime(2020, 4, 7, 12, 30)
    finish = datetime(2020, 4, 7, 13, 50)
    task = Task("Test", start, finish)
    db.add_task(task)
    tasks = db.get_task(day="2020-04-07")
    print(tasks[0])
