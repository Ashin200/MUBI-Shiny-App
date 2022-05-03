#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# load the packages
library(DBI)
library(RSQLite)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyalert)
library(DT)
library(forecast)
library(ggplot2)
library(plotly)
library(maps)
library(leaflet)
library(openair)
library(dplyr)



# Create RSQLite database called mubi
conn <- dbConnect(RSQLite::SQLite(), "MUBI_DB_2019.db")

# List all the tables available in the database
dbListTables(conn)

tbl(conn, "ratings_data")

dataFrame <- tbl(conn, "ratings_data")
dataFrame

x <- dataFrame$rating_score
x

# Query movie release year
releaseyear <- dbGetQuery(conn, 
                          'SELECT distinct(movie_release_year)
                           FROM movie_data
                           ORDER by movie_release_year DESC')
releaseyear

releaseyear$movie_release_year

# Query movie ratings
allratings <- dbGetQuery(conn, 
                         'SELECT rating_score
                           FROM ratings_data
                          ')
allratings

allratings$rating_score


# Query list length
alllistlength <- dbGetQuery(conn, 
                            'SELECT list_movie_number
                           FROM lists_data
                           WHERE list_movie_number <= 200
                           ORDER By list_movie_number DESC
                          ')
alllistlength

alllistlength$list_movie_number



# Query list followers
listfollowers <- dbGetQuery(conn, 
                            'SELECT list_followers
                           FROM lists_data
                           ORDER By list_followers DESC
                          ')
listfollowers

listfollowers$list_followers



# Define UI layout for application

# Navigation bar

ui <- fluidPage(
    
    navbarPage(
        title = 'MUBI Web App',
        windowTitle = 'Navigation Bar', 
        collapsible = TRUE, 
        theme = shinytheme('spacelab'), 
        
        # tab panel 1: Home
        tabPanel("Home",
                 br(),
                 tags$h3("Welcome to the MUBI Web App!"),
                 br(),
                 tags$h5(" This is a Shiny Web App for you to access, search, and analyze the MUBI movie data."),
                 tags$a(href="https://mubi.com/", "Go to MUBI for more!"),
                 br(),
                 br(),
                 tags$img(src = "https://tvovermind.com/wp-content/uploads/2021/08/m0.jpg", 
                          height = 500, width = 800)
        ),
        
        # Search
        tabPanel('Search',
                 tags$h4("Find the movie information:"),
                 br(),
                 searchInput(
                     inputId = "search",
                     placeholder = "Enter movie name",
                     btnSearch = icon("search"),
                     btnReset = icon("remove"),
                     width = "450px"
                 ),
                 br(),
                 dataTableOutput("search_result")
        ),
        
        # Ratings
        tabPanel('Ratings',
                 tags$h4("Find the movie rating stats:"),
                 br(),
                 
                 navlistPanel(
                     
                     tabPanel(title = "Overall rating stats",
                              
                              br(),
                              plotOutput('overal_rating_hist')
                              
                     ),
                     
                     tabPanel(title = "Top movies of all time",
                              br(),
                              numericInput(
                                  inputId = "top_movie_number", 
                                  label = "Select the number of movies", 
                                  value = 10,
                                  min = 10,
                                  max = 100,
                                  step = 10
                              ),
                              br(),
                              dataTableOutput("top_movies_all")
                              
                     ),
                     
                     tabPanel(title = "Top movies by year",
                              selectInput(
                                  inputId = "movie_release_year", 
                                  label = "Select movie released year:", 
                                  choices = releaseyear$movie_release_year,
                                  selected = "2000"
                              ),
                              br(),
                              dataTableOutput("rating_stats")
                     )
                 )
                 
        ),
        # Lists
        tabPanel('Lists',
                 tags$h4("Find the movie list stats:"),
                 br(),
                 br(),
                 
                 tabsetPanel(
                     tabPanel("Overall list stats",
                              br(),
                              plotOutput("overal_list_length_hist"),
                              br(),
                              plotOutput("overal_list_followers_hist")
                     ),
                     tabPanel("Top followed lists",
                              br(),
                              numericInput(
                                  inputId = "top_list_number", 
                                  label = "Select top number of list follower", 
                                  value = 10,
                                  min = 1,
                                  max = 100,
                                  step = 10
                                  
                              ),
                              br(),
                              dataTableOutput("top_list_followers")
                              
                     )
                 )
        ),
        # Introduction of this App
        tabPanel('About',
                 br(),
                 tags$h3("MUBI Web App"),
                 tags$h4("2020.04.25"),
                 br(),
                 br(),
                 br(),
                 tags$b("Produced by:"),
                 tags$h5("Xin Tu, xintu@iu.edu"),
                 tags$h5("Jie Zhen, jz67@iu.edu"),
                 tags$h5("Xuemei Hu, xh18@iu.edu")
                 
        )
        
    )
)

# Define server logic required to
server <- function(input, output, session){
    
    observeEvent(input$link_to_search_panel, {
        newvalue <- "Search"
        updateTabsetPanel(session, "panels", newvalue)
    })
    
    output$search_result <- renderDataTable(
        data <- dbGetQuery(
            conn, 
            "SELECT movie_title As Movie_title, 
                    movie_release_year AS Release_year,
                    director_name As Director,
                    movie_popularity AS Popularity,
                    movie_url AS URL
             FROM movie_data
             WHERE movie_title LIKE ?
             ORDER BY movie_release_year DESC",
            params = input$search
        )
    )
    
    output$rating_stats <- renderDataTable(
        data <- dbGetQuery(
            conn, 
            "SELECT movie_title as Movie_title, 
                ROUND(AVG(rating_score),2) AS Average_rating,
                COUNT(rating_id) AS Number_of_ratings,
                movie_popularity AS Popularity
             FROM ratings_data r
                 LEFT JOIN movie_data m ON r.movie_id=m.movie_id 
             GROUP BY movie_title
             Having movie_release_year = ?
             ORDER BY COUNT(rating_id) DESC",
            params = input$movie_release_year
        )
    )
    
    #top movies of all time
    output$top_movies_all <- renderDataTable(
        data <- dbGetQuery(
            conn, 
            "SELECT movie_title as Movie_title, 
                    ROUND(AVG(rating_score),2) AS Average_rating,
                    COUNT(rating_id) AS Number_of_ratings,
                    movie_popularity AS Popularity
             FROM ratings_data r
                 LEFT JOIN movie_data m ON r.movie_id=m.movie_id 
             GROUP BY movie_title
             ORDER BY COUNT(rating_id) DESC
             LIMIT ?
            ",
            params = input$top_movie_number
        )
    )
    
    
    #read in the table
    dataFrame <- tbl(conn, 
                     "ratings_data")
    
    #hist plot:
    output$overal_rating_hist <- renderPlot({
        
        x <- allratings$rating_score
        x <- na.omit(x)
        hist(x,
             breaks = seq(0.5, 5.5, length.out = 6),
             col = 'darkgray', border = 'white',
             xlab = "Rating Scores",
             main = "Histogram of Rating Scores")
    })
    
    alllistlength$list_movie_number
    
    #list length hist plot:
    output$overal_list_length_hist <- renderPlot({
        
        x <- alllistlength$list_movie_number
        x <- na.omit(x)
        hist(x,
             breaks = seq(min(x), max(x)),
             xlab = "List length",
             main = "Histogram of List Length")
    })
    
    #list followers hist plot:
    output$overal_list_followers_hist <- renderPlot({
        
        x <- listfollowers$list_followers
        x <- na.omit(x)
        hist(x,
             breaks = seq(min(x), max(x)),
             xlab = "List followers",
             main = "Histogram of List Followers")
    })
    
    #top list followers
    output$top_list_followers <- renderDataTable(
        data <- dbGetQuery(
            conn, 
            "SELECT list_title as List_title, 
                list_movie_number AS Number_of_movies,
                list_followers AS Number_of_followers,
                list_url AS List_URL
         FROM lists_data 
         ORDER BY list_followers DESC
         LIMIT ?
        ",
            params = input$top_list_number
        )
    )
    
    # render the summary metrics shown at the top 
    output$MUBI_intro <- renderText({
        "Most of the services we use on the web are provided by web 
    database applications. A web database application can allow 
    users to manage the data and get analytical results based on 
    the data. Here, we design a web application 
    interface using Shiny in R for MUBI movie lovers. 
    It provided users a web tool to access, search, and analyze the MUBI movie data.
    "
    })
    
    
}  

# Run the application
shinyApp(ui=ui, server=server)
