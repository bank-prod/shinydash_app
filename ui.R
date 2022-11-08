#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        dashboardHeader(title = "Projet R Shiny"),
        #Peux cacher le titre avec disable = TRUE | , titleWidth = 500
        dashboardSidebar(
            sidebarMenu(
                menuItem(text = "Acceuil",tabName = "app_home", icon = icon("home")),
                menuItem(text = "Lissage",tabName = "lissage", icon = icon("line-chart")),
                menuItem(text = "Echantillonnage", icon = icon("line-chart"),
                         menuSubItem("Base de sondage", tabName = "e_data",icon=icon("line-chart")),
                         menuSubItem("Simple", tabName = "e_simple",icon=icon("line-chart")),
                         menuSubItem("Grappe", tabName = "e_grappe",icon=icon("line-chart"))
                         )
               
                # https://fontawesome.com/icons?d=gallery
                
            )
        ),
        #Peux cacher le sidebar avec collapse = TRUE
    dashboardBody(
            tabItems(
                
                
                tabItem(tabName = "app_home"
                        
                        ),
                
                ###############################################################################
                ## Importation de la base de sondage
                ###############################################################################
                
                tabItem(tabName = "e_data", 
                        tabBox(id = "age_filier",width = NULL,
                               tabPanel("Choisir un jeu de donnée",
                                        fluidRow(
                                            box(title="Jeu de données", 
                                                fileInput("donne",label = "Sectionner un jeu de donnée (fichier csv)")),
                                            
                                            box(title="Description",
                                                verbatimTextOutput("tab_donne")
                                        )
                                        )
                               
                        ),tabPanel("Vu du jeu de donnée", DT::dataTableOutput("tableauD"))
                        
                      
                        
                            
                        )),
                
                ###############################################################################
                ## Lissage Exponentielle
                ###############################################################################
                
                tabItem(tabName = "lissage"
                      
                    ),
                
                ###############################################################################
                ## Echantillonage Simple
                ###############################################################################
                
                tabItem(tabName = "e_simple",
                        numericInput(inputId = "n_val",label = "Taille de l'echantillon",value = 0),
                        actionButton(inputId = "sple",label = "Tirez l'echantillon"),
                        textOutput("texte"),
                        br(),
                        br(),
                        DT::dataTableOutput("tableauD_Ech")
                        ),
                
                ###############################################################################
                ## Echantillonage par grappe
                ###############################################################################
                
                tabItem(tabName = "e_grappe",
                        
                        numericInput(inputId = "n_val_g",label = "Taille de l'echantillon dans chaque grappe",value = 0),
                        selectInput(inputId = "var_g",label = "Choisire la variable", choices = ""),
                        actionButton(inputId = "sple_g",label = "Tirez l'echantillon"),
                       
                        br(),
                        br(),
                        
                        DT::dataTableOutput("tableauD_Ech_g")
                        
                        )
                
            )
        )
    
    )
)
    

