import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import psycopg2
from io import StringIO

from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split


def data_generator(size: int, rng = None) -> pd.DataFrame:
    """
    Create synthetic data for housing price problem using probability distributions for
    features, noise, and weights.

    Computes the data using the formula: price = X*w + b + noise.

    Args:
        size (int): Number of rows or number of data points.
        rng (numpy object): Random number generator.

    Returns:
        pd.DataFrame: DataFrame of the housing prices with features and the prices.

    """
    if rng is None:
        rng = np.random.default_rng()

    # Generate features and noise
    size_sqm = rng.normal(loc = 70, scale = 20, size = size)
    rooms_num = rng.poisson(lam = 3, size = size)
    bathrooms_num = rng.poisson(lam = 1, size = size)
    age_year = rng.normal(loc = 20, scale = 10, size = size).astype(int)
    city_center_distance_km = rng.lognormal(mean = 0.5, sigma = 0.5, size = size)
    elevator_bool = rng.binomial(n = 1, p = 0.5, size = size)
    floor = rng.integers(0, 10, size = size)
    noise = rng.normal(loc = 0, scale = 25000, size = size)
    bias = rng.normal(loc = 120000, scale = 1000)

    # Generate weights
    w1_size_sqm = rng.normal(loc = 4000, scale = 400)
    w2_rooms_num = rng.normal(loc = 15000, scale = 3000)
    w3_bathrooms_num = rng.normal(loc = 7000, scale = 1000)
    w4_age_year = rng.normal(loc = -1200, scale = 200)
    w5_city_center_distance_km = rng.normal(loc = -1500, scale = 200)
    w6_elevator_bool = rng.normal(loc = 7000, scale = 1000)
    w7_floor = rng.normal(loc = 1100, scale = 200)

    # Calculate the price
    price = (
        w1_size_sqm * size_sqm
        + w2_rooms_num * rooms_num
        + w3_bathrooms_num * bathrooms_num
        + w4_age_year * age_year
        + w5_city_center_distance_km * city_center_distance_km
        + w6_elevator_bool * elevator_bool
        + w7_floor * floor
        + noise
        + bias
    ).astype(int)

    # Create a dictionary of the features and the price and convert it to pandas dataframe later
    housing_price_dict = {
        "size_sqm": size_sqm,
        "rooms_num": rooms_num,
        "bathrooms_num": bathrooms_num,
        "age_year": age_year,
        "city_center_distance_km": city_center_distance_km,
        "elevator_bool": elevator_bool,
        "floor": floor,
        "price": price
    }
    # Convert the dictionary to Pandas Dataframe
    housing_price = pd.DataFrame(housing_price_dict)

    return housing_price


def insert_into_database(df: pd.DataFrame, conn_str: str):
    """
    Loads pandas DataFrame into a table in the database

    Args:
        df (pd.DataFrame): Generated data converted into pandas DataFrame.
        conn_str (str): Information string for psycopg2.connect()
    """
    # Create a connection and a cursor to the database
    conn = psycopg2.connect(conn_str)
    cur = conn.cursor()
    # Create a buffer and write the DataFrame in it
    buffer = StringIO()
    df.to_csv(buffer, index = False, header = False)
    buffer.seek(0)
    # The SQL command to copy the DataFrame to the table
    sql_command = "COPY raw_data_housing FROM STDIN WITH CSV"
    cur.copy_expert(sql_command, buffer)
    # Save the changes and close the cursor and the connection
    conn.commit()
    cur.close()
    conn.close()
    








if __name__ == "__main__":
    print("Generating Synthetic Data...")
    df = data_generator(size = 100000, rng = np.random.default_rng(10))
    print("Data Generation Complete.")

    connection_string = "host=172.20.160.1 port=5432 dbname=Housing_Price user=postgres password=1234512345"

    print("Inserting Data into PostgreSQL")
    insert_into_database(df, connection_string)
    print("Data Successfully inserted.")


