#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(readr)
library(dplyr)

# Define server logic required to draw a histogram
# jdd : Jeux de donnée
# BS : Base de sondage
#
#

shinyServer(function(input, output,session) {
  ###############################################################################
  ## initialisation des jdd echantillon. avec reavtiveValues pour les modifié aprè
  ###############################################################################
  ech <- reactiveValues(
    jdd_s = NULL,
    jdd_g = NULL

  )
  
  ###############################################################################
  ## fct d'importation du jeux de donnée avec evenReactive
  ###############################################################################
  
  jdd2 <-  eventReactive (input$donne, {
  
    file1 <- input$donne
    
    ech$jdd_s <- NULL #
                      # Intilisation des jdd echantillon aprés le chargement d'une nouvelle BS
    ech$jdd_g <- NULL #
  
   read.csv(file1$datapath, encoding="UTF-8", quote="", na.strings="", stringsAsFactors=TRUE)
    #vroom(file =  file1$datapath )
  
  
    })

  
  #--- Detaille du jdd qui va s'actualiser une fois charger
output$tab_donne <- renderPrint(
      str(jdd2())
    )

#--- Affichage du jdd au complet 
output$tableauD <- DT::renderDataTable(
  {
   jdd2()
  },options = list(scrollX=400, scrollY=400, scroller = T)
  
)


###############################################################################
## Echantillonge Aleatoir Simple
###############################################################################

output$texte <- renderText(input$n_val)

########

nb_echantillon <- reactive({input$n_val})

#--- Obtention du jdd echantillonnage simple apres clique sur le bouton 
observeEvent(input$sple, 
             {
               if(input$n_val < 0 | input$n_val > nrow(jdd2())) # Si la valeur entrée depasse le nrow() ou ne vaut pas 0 
               {
                 ech$jdd_s <- NULL
               }else
               {
                 ech$jdd_s <-  jdd2()[sample(1:nrow(jdd2()),input$n_val), ] # Fct d'échantillonage
               }
               
              
             },ignoreNULL = T,ignoreInit = T)

#--- Affichage du jdd echantillonnage Simple

output$tableauD_Ech <- DT::renderDataTable(
  {
    ech$jdd_s
  },extensions="Buttons",options=list(pageLength=nrow(jdd2()),scrollX=400, scrollY=300, scroller = T,dom="Bfrtip", buttons = list("csv","excel"))
  
)

###############################################################################
## Echantillonge Aleatoir Simple
###############################################################################

## Actualisation du input avec les noms des variable du jdd
observe(
  updateSelectInput(session,"var_g",label = "Variable grape",choices = names(jdd2()))
)


#--- Obtention du jdd echantillonnage grappe apres clique sur le bouton
observeEvent(input$sple_g, 
             {
               if(input$n_val_g < 0 | input$n_val_g > min(table(jdd2()[ , input$var_g])) )
               {
                 ech$jdd_g <- NULL
               }else
               {
                 ech$jdd_g <- group_by(jdd2(), "variable_grappe" = get(input$var_g))%>%sample_n(input$n_val_g)
                 #ech$jdd_g <- rename(ech$jdd_g, get(input$var_g)=V)
               }
               
               
             },ignoreNULL = T,ignoreInit = T)
 

output$tableauD_Ech_g <- DT::renderDataTable(
  {
    ech$jdd_g
  },extensions="Buttons",options=list(pageLength=nrow(jdd2()),scrollX=400, scrollY=300, scroller = T,dom="Bfrtip", buttons = list("csv","excel"))
  
)


})
