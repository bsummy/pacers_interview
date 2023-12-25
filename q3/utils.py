from configparser import ConfigParser
import psycopg2
import json
import csv

def get_config(filename='database.ini', section="postgresql"):
    parser = ConfigParser()
    parser.read(filename)
    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception(f'Section {section} not found in the {filename} file')
    return db

def connect(query="SELECT version()"):
    """ Connect to the PostgreSQL database server
    might need to streamline with execute()

    """
    conn = None
    try:
        # read connection parameters
        params = get_config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)
        with conn:
            with conn.cursor() as cur:
                cur.execute(query)
                print(cur.statusmessage)
                if cur.pgresult_ptr is not None: # selects
                    result = cur.fetchall()
                    return result
                # context manager does implicit commit/rollback for db transactions
    except (Exception, psycopg2.DatabaseError) as error:
        print("ERROR", error)
        conn.rollback() # idk if this will work
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')

def bulk_execute(queries):
    """ Using a list of queries, execute them all in the same transaction
    """
    conn = None
    try:
        # read connection parameters
        params = get_config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        results = []
        with psycopg2.connect(**params) as conn:
            with conn.cursor() as cur:
                for q in queries:
                    cleaned_query = q.strip("\n\n")
                    if cleaned_query: # if the query is not empty, execute it
                        cur.execute(cleaned_query)
                        print(cur.statusmessage)
                    else:
                        continue
                    if cur.pgresult_ptr is not None: # selects
                        result = cur.fetchall()
                        results.append(result)
                # context manager does implicit commit/rollback for db transactions
    except (Exception, psycopg2.DatabaseError) as error:
        print("ERROR", error)
        conn.rollback() # idk if this will work
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
        return results

def execute(query="SELECT version()"):
    """ Execute a query on the postgres database """
    print("executing: " + query)
    result = connect(query)
    return result

def test_copy():
    query = """
        COPY sandbox.persons(first_name, last_name, dob, email)
        FROM '/Users/bennettsummy/VSC_Projects/nhl-draft-pick-value/persons.csv'
        DELIMITER ','
        CSV HEADER;
        """
    execute(query)

def test():
    query = "SELECT * FROM sandbox.persons;"
    print("executing: " + query)
    execute(query)
    print("done")

def run_file(filepath):
    """ Run a file of queries - might need some checking here
        Usually won't need the results from this, but I'll provide them anyway
    """
    results = []
    with open(filepath, "r") as f:
        file = f.read()
    queries = file.split(";")
    results = bulk_execute(queries)
    return results

def build_hash(dict_of_values):
    """
    Build a hash from a dictionary of values
    """
    str_of_values = json.dumps(dict_of_values, sort_keys=True)
    return hash(str_of_values)

def write_to_csv(file, data, fieldnames=None):
    # does converting to tempfiles still meet the requirements for a downloaded file?
    # now we will open a file for writing
    with open(file, 'w') as csvfile:
        # creating a csv dict writer object
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        # writing headers (field names)
        writer.writeheader()

        # writing data rows
        writer.writerows(data)

    return csvfile # this will be the name


execute()
