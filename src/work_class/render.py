from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication

from src.work_class.tasksModel import TasksModel
from src.db_class.database import Database


class Render:
    """
    Class for GUI rendering
    """

    def __init__(self, argv):
        """
        Initialize application and GUI engine
        :param argv: command line options
        """
        self.argv = argv + ['--style', 'material']
        self.__app = QApplication(self.argv)
        self.__app.setStyle("Material")

        self.__database = Database()
        self.__tasks_mode = TasksModel(self.__database)

        self.__engine = QQmlApplicationEngine()
        self.__engine.rootContext().setContextProperty("tasksmodel", self.__tasks_mode)
        self.__engine.load("../../resources/layout/main.qml")
        self.__engine.quit.connect(self.__app.quit)

    def run(self):
        """
        Run GUI rendering
        :return:
        """
        self.__app.exec_()
