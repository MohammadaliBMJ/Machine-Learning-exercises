from torch_model import LinearReg
import torch.nn as nn
import torch
import torch.optim as optim
from typing import Tuple
import pandas as pd
import psycopg2
from sklearn.model_selection import train_test_split
import numpy as np
from sklearn.preprocessing import StandardScaler


def import_data() -> Tuple:
    """
    Import data from Housing_Price database into a pandas DataFrame.

    Returns:
        Tuple:
            - X_train
            - X_test
            - y_train
            - y_test
    """
    
    conn = psycopg2.connect(dsn = "host='host name' port='port' " \
    "dbname=Housing_Price " \
    "user=postgres " \
    "password='password'")
    df = pd.read_sql(sql = "SELECT * FROM clean_data_housing", con = conn)
    conn.close()

    df = np.array(df).astype(float)
    X = df[:, :-1]
    y = df[:, -1]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.25, random_state = 10)

    return X_train, X_test, y_train, y_test


X_train, X_test, y_train, y_test = import_data()

# Standardization
scaler_X = StandardScaler()
scaler_y = StandardScaler()

X_train = scaler_X.fit_transform(X_train)
X_test = scaler_X.transform(X_test)

y_train = scaler_y.fit_transform(y_train.reshape(-1, 1))
y_test = scaler_y.transform(y_test.reshape(-1, 1))

# Convert to tensor
X_train = torch.tensor(X_train, dtype = torch.float32)
X_test = torch.tensor(X_test, dtype = torch.float32)

y_train = torch.tensor(y_train, dtype = torch.float32).view(-1, 1)
y_test = torch.tensor(y_test, dtype = torch.float32).view(-1, 1)

model = LinearReg(features_num = X_train.shape[1])
criterion = nn.MSELoss()
optimizer = optim.SGD(model.parameters(), lr = 0.001)

losses = []

model.train()
for i in range(10000):
    optimizer.zero_grad()
    predictions = model(X_train)
    loss = criterion(predictions, y_train)
    losses.append(loss)
    loss.backward()
    optimizer.step()

    if i % 1000 == 0:
        print(f"Epoch = {i}       Loss = {loss}")


model.eval()
with torch.no_grad():
    predictions_test = model(X_test)
    loss_test = criterion(predictions_test, y_test)
    print(loss_test)