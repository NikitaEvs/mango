from datetime import datetime


def get_id():
    """Get unique id for task"""
    return hash(datetime.now())


class Task:
    """
    Basic class for task representation
    """

    def __init__(self, name, start, finish, task_id=get_id()):
        """
        Constructor with timestamps
        :param name: name of task
        :param start: start time for task
        :param finish: finish time for task
        :param task_id: unique identification of task, default -
        hash of current time
        """
        self.task_id = task_id
        self.name = name
        self.start = start
        self.finish = finish

    def __str__(self):
        return "{task_id : " + str(self.task_id) + ", name : " + self.name + \
                   ", start : " + self.start.isoformat() + ", finish : " + \
                   self.finish.isoformat() + "}"

    def get_list(self):
        """
        Util function for storing Task class in database
        :return: list with params for insertion in database
        """
        return [str(self.task_id), self.name, self.start.isoformat(),
                self.finish.isoformat()]

    def get_dict(self):
        """
        Util function for visualize Task in ListView
        :return:dict with params for insert in ListView (without id)
        """
        return {"name" : self.name, "start" : self.start,
                "finish" : self.finish}