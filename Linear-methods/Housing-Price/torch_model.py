import torch.nn as nn


class LinearReg(nn.Module):
    def __init__(self, features_num):
        super().__init__()
        self.linear = nn.Linear(features_num, 1)

    def forward(self, x):
        x = self.linear(x)
        return x