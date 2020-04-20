from PySide2 import QtCore

from src.db_class.database import Database

"""
Auth class for sign in/sign up/offline mode
"""

class Auth(QtCore.QObject):
    def __init__(self, engine, task_model, parent=None):
        """
        Init with QQmlApplicationEngine
        :param engine:
        """
        super().__init__(parent)
        self.__engine = engine
        self.__task_model = task_model

    @QtCore.Slot()
    def offline(self):
        """
        Slot function for init the offline mode with local database from
        interface
        """
        self.__database = Database()
        self.__task_model.set_database(self.__database)

    def __exit__(self, exc_type, exc_val, exc_tb):
        try:
            self.__database.__exit__(exc_type, exc_val, exc_tb)
        except AttributeError:
            pass
