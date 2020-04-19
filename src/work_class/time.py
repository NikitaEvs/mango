from PySide2 import QtCore

from datetime import datetime
import calendar

"""
    Util class for time manipulation in QML interface
"""
class Time(QtCore.QObject):
    signal = QtCore.Signal(int)

    def __init__(self, parent=None):
        super().__init__(parent)

    @QtCore.Slot(result=int)
    def get_year(self):
        """
        :return : year number
        """
        time = datetime.now()
        return int(time.year)

    @QtCore.Slot(result=int)
    def get_month(self):
        """
        :return : month number
        """
        time = datetime.now()
        return int(time.month)

    @QtCore.Slot(result=int)
    def get_day(self):
        """
        :return : day number
        """
        time = datetime.now()
        return int(time.day)

    @QtCore.Slot(result=int)
    def get_hour(self):
        """
        :return : hour number
        """
        time = datetime.now()
        return int(time.hour)

    @QtCore.Slot(result=int)
    def get_current_days_number(self):
        """
        :return : get day number in current month
        """
        return self.get_days_number(self.get_year(), self.get_month())

    @QtCore.Slot(int, int, result=int)
    def get_days_number(self, year, month):
        """
        :year : input year
        :month : input month
        :return : day number in the month
        """
        return int(calendar.monthrange(year, month)[1])