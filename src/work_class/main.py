import sys

from src.work_class.render import Render


def main():
    """
    Global enter point
    :return:
    """
    engine = Render(sys.argv)
    engine.run()


if __name__ == "__main__":
    main()
