# Regularization
This project implements and demonstrates **Overfitting**, **Underfitting**, and **bias-variance decomposition** for polynomial regression using stochastic gradient descent. It visualizes how they evolve over time and over training steps. This project also implements two regularization techniques **L1** and **L2**

## Files
The repository contains two notebooks called `L1_L2.ipynb` and `overfit_underfit.ipynb`. The first file run different polynomial regression models with no regularization, L1, and L2 regularization. The second file `overfit_underfit.ipynb` demonstrates overfitting and underfitting based on the degree of the polynomial model.

## How to Run
Simply open the notebooks and run all the cells in each one.

## Results
The `L1_L2` notebook produces:
- Root Mean Squared Error for each 3 model.
- plot for Model prediction vs True data. 
- plot for bias and variance over training steps for each model.

The `overfit_underfit` notebook produces:
- Plot of Root Mean Squared Error over different polynomial degrees for both training and evaluation data