# MUBI-Shiny-App

1. Full Web URL
https://xintu.shinyapps.io/MUBI_App_v2_2/
*Due to the large dataset, this web app may run slowly on Shinyapps server. Thanks for your patience for waiting!

2. Full Github URL
https://github.com/Ashin200/MUBI-Shiny-App

3. Technical description

3.1 Tools
Shiny provides a powerful web framework and an open-source R package to build web apps. It helps turn your analyses into an interactive web application. It doesn’t require any knowledge like HTML, CSS, or JavaScript. Shiny combines the analytical abilities of R with the display abilities of the web and ships with a very powerful and flexible layout engine. Shiny app has three components. They are the front end: a user-interface object (UI) that controls the layout and appearance of the app, the back end: a server function (server) that contains the computer needs the instructions to build the app, and a call to the Shiny App function that creates Shiny app objects from an explicit UI/server pair. In this MUBI web app, the backend is the RSQLite database, and the frontend is the Shiny web app. The web is connected to the backend RSQLite database through the Shiny server. Users can access the frontend web and input values. Shiny app will process input values to produce the output results by querying from the backend database. 

3.2 Data
The MUBI dataset was acquired from the Kaggle website (https://www.kaggle.com/clementmsika/mubi-sqlite-database-for-movie-lovers). Data was collected by Clément Msika with MUBI API in 2020 and then transformed into the SQLite database to facilitate the analysis. User IDs were anonymized. Data from MUBI users who set their profile in private mode are not in this database. We created the MUBI relational database model with optimized tables and relationships in MySQL workbench using Structured Query Language (SQL). To import the MUBI relational database, we connected to the MySQL database server using the dbConnect function in RStudio. Next, we created a RSQLite database and wrote the MUBI tables into the RSQLite database in RStudio. All data was stored, managed, and updated in the RSQLite database. Then we created a connection using the dbConnect function to access the RSQLite database. 

3.3	Users’ functionalities
  
  There are five panel pages for this web app: Home, Search, Movie, List, and About. Users’ functionalities in these panels are shown below. 
      
      1.	Home panel: 
      Link function: users can use the link to go the MUBI official website.

      2.	Search panel:
      Search function: users can search the movie information (released year, director, popularity, and URL link) by entering the interested movie name. 

      3.	Ratings panel:
      3.1	Rating scores plot function: users can find the distribution of rating scores.
      3.2	Top rated movie function: users can select a number, and it will display top number of rated movies.
      3.3	Top rated movie filter function: users can select an interested movie released year, and it will display top-rated movie in this year. 

      4.	Lists panel
      4.1	Lists stats plot function: users can plot the distributions of list length and the number of list followers.
      4.2	Top followed lists function: users can enter a number, and get the top followed list information.

      5.	About panel
      Tag function: Users can find the version of this app and the contact information about developers.
