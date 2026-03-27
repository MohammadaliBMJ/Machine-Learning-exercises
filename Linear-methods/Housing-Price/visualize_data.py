import pandas as pd
import psycopg2
import seaborn as sns
import matplotlib.pyplot as plt


def import_data() -> pd.DataFrame:
    """
    Import data the from table raw_data_housing and store it as a pandas DataFrame.

    Returns:
        df (pd.DataFrame): Data stored in table called raw_data_housing.
    """
    conn = psycopg2.connect(dsn = "host=172.20.160.1 port=5432 dbname=Housing_Price user=postgres password=1234512345")
    df = pd.read_sql(sql = "SELECT * FROM raw_data_housing", con = conn)
    conn.close()
    return df


def hist_plot(df: pd.DataFrame) -> None:
    """
    Plot a histogram of each table of the DataFrame.

    Args:
        df (pd.DataFrame): Data imported from the database.
    """
    sns.set(style = "whitegrid")
    plt.figure(figsize = (14, 8))
    for i, column in enumerate(df.columns, start = 1):
        # Look for discrete values to avoid drawing the Kernel Density Estimator line.
        kde_flag = df[column].nunique() < 20

        plt.subplot(3, 3, i)
        sns.histplot(df[column], bins = 100, kde = not kde_flag, color = "steelblue")
    
    plt.tight_layout()
    plt.show()


def scatter_plot(df: pd.DataFrame) -> None:
    """
    Scatter plot of the size_sqm column and price.

    Args:
        df (pd.DataFrame): Data imported from the database.
    """
    sns.set(style = "whitegrid")
    plt.figure(figsize = (14, 8))
    sns.scatterplot(data = df, x = df.columns[0], y = "price", alpha = 0.5)
    plt.title("Size vs Price")
    plt.show()


def lmplot(df: pd.DataFrame) -> None:
    """
    sns.lmplot of the size_sqm column and price.

    Args:
        df (pd.DataFrame): Data imported from the database.
    """
    sns.set(style = "whitegrid")
    sns.lmplot(data = df, x = df.columns[0], y = df.columns[-1], aspect = 1.4, line_kws = {"color": "red"})
    plt.title("Size vs Price with Linear Regression")
    plt.show()


def heatmap(df: pd.DataFrame) -> None:
    """
    Heatmap of correlations between Dataframe columns.

    Args:
        df (pd.DataFrame): Data imported from the database.
    """
    sns.heatmap(
        data = df.corr(),
        annot = True,
        fmt = ".2f",
        cmap = "coolwarm",
        linecolor = "black",
        linewidths = 0.5,
        square = True
    )
    plt.title("Correlation Heatmap")
    plt.show()





if __name__ == "__main__":
    df = import_data()
    hist_plot(df)
    scatter_plot(df)
    lmplot(df)
    heatmap(df)