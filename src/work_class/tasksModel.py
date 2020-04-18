from PySide2 import QtCore, QtGui, QtQml

from src.data_class.task import Task
from datetime import datetime

"""
Model for visualize tasks into ListView
"""


class TasksModel(QtCore.QAbstractListModel):
    nameRole = QtCore.Qt.UserRole + 1  # Role for task name
    startRole = QtCore.Qt.UserRole + 2  # Role for start time
    finishRole = QtCore.Qt.UserRole + 3  # Role for finish time

    def __init__(self, database, parent=None):
        """
        Constructor with initialization of QAbstractListModel
        :param database: database instance
        :param parent: parent component
        """
        super().__init__(parent)
        self.__database = database
        self.tasks = []
        self.__index = 0
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
            if role == TasksModel.startRole:
                return self.simplify(self.tasks[row].start)
            if role == TasksModel.finishRole:
                return self.simplify(self.tasks[row].finish)

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
        return {TasksModel.nameRole: b"name", TasksModel.startRole: b"start",
                TasksModel.finishRole: b"finish"}

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
        self.dataChanged.emit(self.__index, self.__index)

    def simplify(self, time):
        """
        Function for simplify timestamp format to HH:MM
        :param time: time to simplify
        :return: time string after simplify
        """
        return time.strftime("%H:%M")

    @QtCore.Slot(str, str, str)
    def add(self, name, start, finish):
        """
        Add new Task to database
        :param name: name of Task
        :param start: start time
        :param finish: finish time
        :return:
        """
        format_string = "%Y-%m-%d %H:%M"
        time_start = datetime.strptime(start, format_string)
        time_finish = datetime.strptime(finish, format_string)
        task = Task(name, time_start, time_finish)
        self.__database.add_task(task)
        self.update()

