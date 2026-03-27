import pandas as pd
import numpy as np

df = pd.DataFrame({
    "a": [2, 1],
    "b": [5, 7],
    "c": [9, 0],
    "d": [1, 1],
    "e": [0, 5],
    "f": [22, 4],
    "g":[10, 9]
})
print(df.head())
df = np.array(df)

x = np.linspace(1, 5, 5)
y = np.linspace(6, 10, 5)

X, Y = np.meshgrid(x, y)

print(df.shape)

