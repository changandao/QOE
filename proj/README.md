This code is for data analysis part.

preprocessing part:

    generatenew.m : combine different features from separate mat file to make a new feature mat file
    preprocessing.py: process the crowdsourced MOS
    genlable.py: get the MOS of Netflix_dataset

main predicting part:

    prediction.m: run this file to do the prediction work
    getMetrics.m: main part in prediction.mat, here at first I do the leave one out crossValidation for PCR, PLSR, and Netflix, and then draw the pictures of different methods.
    prevalidation.m:  see the percent variant of PCR and PSLR over whole dataset

in data folder, all the data will be saved here
