Link: https://charlotte-edgar.shinyapps.io/quakes/ (assignment B3)

Link: https://charlotte-edgar.shinyapps.io/quakes2/ (assignment B4)

This app allows one to visualize the quakes dataset. This dataset has 5 columns, longitude, latitude, magnitude, depth and number of stations reporting, that describe 1000 earthquakes that occured near Fiji since 1964. 

This app shows a summary statistics table for each variable in the tables tab. 

In the plots tab, this app shows the relationship between depth and magnitude and station and magnitude. Magnitude is treated as categorical and a boxplot is used. The user can choose if they want to view depth or stations on the y-axis. Then, there is a scatterplot showing the longitude and latitude of the different earthquakes. This allows the user to look for patterns and clusters of the locations of the earthquakes. The colour of the points are based on the magnitude, and the general colour palette can be chosen based on the users preferences. The user can specify the range of magnitudes that they would like to view on both graphs.

There is a regression model that can be explored in the regression model tab. This section allows the user to choose the proportion of the dataset that will be used as the training set. A multiple linear regression model is fit to predict magnitude with the other four variables as explanatory variables. The testing set is used to find the model's predictive accuracy (mean squared prediction error). 

The dataset is from the datasets package in R and in the documentation it says that "this is one of the Harvard PRIM-H project data sets. They in turn obtained it from Dr. John Woodhouse, Dept. of Geophysics, Harvard University.". 
