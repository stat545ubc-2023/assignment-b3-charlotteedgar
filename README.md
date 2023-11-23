A link to a running instance of your Shiny app.
A description of your app.
Whatever dataset you will use, acknowledge its source clearly. Remember that we value open, reproducible science: this means that the user of your app should have direct access to the data, or know where to go to access it.

Link: https://charlotte-edgar.shinyapps.io/quakes/

This app allows one to visualize the quakes dataset. This dataset has 5 columns, longitude, latitude, magnitude, depth and number of stations reporting, that describe 1000 earthquakes that occured near Fiji since 1964. 

This app begins by allowing one to select a range of the number of stations reporting. We'd expect larger earthquakes to be reported by more stations so this allows one to explore the relationship between number of stations reporting and magnitude in the histogram. The binwidths can also be changed for the histogram. This is an important feature as we are changing the number of observations included in the histogram by changing the range of the number of stations. A histogram will few features might be visually unpleasing if it has the same binwidths as a histogram with many observations. 

Then there is a scatterplot showing the longitude and latitude of the different earthquakes. This allows the user to look for patterns and clusters of the locations of the earthquakes. The colour of the points are based on the number of stations, and the general palette can be chosen based on the users preferences.

Finally, there is a table showing the column means. The columns shown in the table can be chosen by the user.
