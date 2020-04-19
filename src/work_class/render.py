from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtWidgets import QApplication

from src.work_class.tasksModel import TasksModel
from src.work_class.auth import Auth
from src.work_class.time import Time


class Render:
    """
    Class for GUI rendering
    """

    def __init__(self, argv, path):
        """
        Initialize application and GUI engine
        :param argv: command line options
        :param path: project directory path
        """
        self.argv = argv + ['--style', 'material']
        self.__app = QApplication(self.argv)
        self.__app.setStyle("Material")

        self.__tasks_model = TasksModel()
        self.__engine = QQmlApplicationEngine()
        self.__auth = Auth(self.__engine, self.__tasks_model)
        self.__time = Time()

        self.__engine.rootContext().setContextProperty("auth", self.__auth)
        self.__engine.rootContext().setContextProperty("tasksmodel",
                                                       self.__tasks_model)
        self.__engine.rootContext().setContextProperty("time", self.__time)

        self.__engine.load(str(path) + "/resources/layout/main.qml")
        self.__engine.quit.connect(self.__app.quit)

    def run(self):
        """
        Run GUI rendering
        :return:
        """
        self.__app.exec_()
