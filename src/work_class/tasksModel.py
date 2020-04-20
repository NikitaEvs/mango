from PySide2 import QtCore, QtGui, QtQml

from src.data_class.task import Task
from datetime import datetime

"""
Model for visualize tasks into ListView
"""


class TasksModel(QtCore.QAbstractListModel):
    nameRole = QtCore.Qt.UserRole + 1       # Role for task name
    timeRole = QtCore.Qt.UserRole + 2       # Role for start time
    durationRole = QtCore.Qt.UserRole + 3   # Role for duration time

    def __init__(self, parent=None):
        """
        Constructor with initialization of QAbstractListModel
        :param database: database instance
        :param parent: parent component
        """
        super().__init__(parent)
        self.__database = None
        self.tasks = []
        self.__index = 0

    def set_database(self, database):
        self.__database = database
        self.update()

    def data(self, index, role=QtCore.Qt.DisplayRole):
        """
        Util function for connection to ListView
        :param index: current row in parent component
        :param role: current role (component param name)
        :return: data for role
        """
        self.__index = index
        row = index.row()
        if index.isValid() and 0 <= row < self.rowCount():
            if role == TasksModel.nameRole:
                return self.tasks[row].name
            elif role == TasksModel.timeRole:
                return self.simplify(self.tasks[row].start) + " - " + \
                        self.simplify(self.tasks[row].finish)
            elif role == TasksModel.durationRole:
                return self.get_duration(self.tasks[row])


    def add_items(self, items):
        """
        Add new items into ListView
        :param items: list with Task items
        """
        sorted(items)
        row = 0
        while row < len(self.tasks) and len(items) > 0:
            if items[0] < self.tasks[row]:
                self.beginInsertRows(QtCore.QModelIndex(), row, row)
                self.tasks.insert(row, items.pop(0))
                self.endInsertRows()
                row += 1
            row += 1
        if len(items) > 0:
            self.beginInsertRows(QtCore.QModelIndex(), len(self.tasks), len(self.tasks) + len(items) - 1)
            self.tasks.extend(items)
            self.endInsertRows()

    def rowCount(self, parent=QtCore.QModelIndex()):
        """
        Return tasks size for ListView
        :param parent: parent component
        :return:
        """
        return len(self.tasks)

    def roleNames(self):
        """
        Util function for LisView representation
        :return: dict with current model roles
        """
        return {TasksModel.nameRole: b"name",
                TasksModel.timeRole: b"time",
                TasksModel.durationRole: b"duration"}

    @QtCore.Slot(int)
    def get(self, row):
        """
        Get data in the row
        :param row: row index
        :return: dict with Task params
        """
        if 0 <= row < self.rowCount():
            return self.tasks[row].get_dict()

    @QtCore.Slot()
    def update(self):
        """
        Update tasks values from database
        :return:
        """
        self.tasks = \
            self.__database.get_task(day=datetime.now().strftime("%Y-%m-%d"))
        self.tasks = sorted(self.tasks)


    def simplify(self, time):
        """
        Function for simplify timestamp format to HH:MM
        :param time: time to simplify
        :return: time string after simplify
        """
        return time.strftime("%H:%M")

    def get_duration(self, task):
        """
        Calculate duration for simple task and parse into human-readable
        format
        """
        difference = task.finish - task.start
        total = difference.total_seconds()
        hours, remainder = divmod(total, 60 * 60)
        minutes, seconds = divmod(remainder, 60)

        result = ""
        non_zero_hours = False
        if hours > 0:
            result = "{0}h".format(int(hours))
            non_zero_hours = True

        if minutes > 0:
            if non_zero_hours:
                result += " "
            result += "{0}m".format(int(minutes))

        return result

    @QtCore.Slot(str, str, str)
    def add(self, name, start, finish):
        """
        Add new Task to database
        :param name: name __engine.__tasks_modelof Task
        :param start: start time
        :param finish: finish time
        :return:
        """
        format_string = "%Y-%m-%d %H:%M"
        time_start = datetime.strptime(start, format_string)
        time_finish = datetime.strptime(finish, format_string)
        task = Task(name, time_start, time_finish)
        self.__database.add_task(task)
        self.add_items([task])

