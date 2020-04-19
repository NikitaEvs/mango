import sys
import os
import pathlib

from src.work_class.render import Render


def main():
    """
    Global enter point
    :return:
    """
    path = pathlib.Path(__file__).resolve().parent.parent.absolute()
    os.chdir(path)

    engine = Render(sys.argv, path)
    engine.run()


if __name__ == "__main__":
    main()
