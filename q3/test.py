import argparse

import utils as utils

PARSER = argparse.ArgumentParser("Q3 Setup")

PARSER.add_argument("--test", dest="test", action="store_true", help="Run tests")
ARGS = PARSER.parse_args()

def main():
    """
    Main function
    """

    if ARGS.test:
        print(utils.run_file("q3/staging/public.sql"))

# an extra row of data, with a bad value for the id
        #N/A,NBA,2022,playoffs,6,,32.34166667,1940.5,5,11,0.455,5,11,0.4545454545,0,0,0,1,5,0.2,4,6,10,2,1,0,0,0,1,,8,11,5
if __name__ == "__main__":
    main()
