# encoding: utf-8
###############################################################################.
#
# Titre : ui.R
# 
# Theme : Data Science - projet VelibR
#
# Creation : 27 février 2016
# MAJ : 27 février 2016
#
# Auteur : CEPE gpe 1
###############################################################################.

require(shiny)
require(leaflet)
  
  # Application title
  shinyUI(fluidPage(
    h1(titlePanel("Lib R dans Paris")),
    fluidRow(
      column(4,
             wellPanel(
              radioButtons("objet", "Que voulez vous?", c("Autour de","Itineraire"), selected = "Autour de", inline = TRUE, width = NULL),
              #hr(),
              #img(src='D:/TP20160227/DATA/Geo.png', height = 10, width = 10, align = "right"),
              hr(),
              actionButton("Geo", label = img(src="geo.png", height = 20, width = 20)),
              textInput("addresse1", "Depart", value = "10 Rue de Rivoli, Paris"), 
          
              conditionalPanel(condition = "input.objet == 'Itineraire'", textInput("addresse2", "Arrivee", value = "60 rue Etienne Dolet, Malakoff")),
              hr(),
              dateInput('dateTime',
                         label = "Date",
                         value = as.character(Sys.Date()),
                         min = Sys.Date(), max = Sys.Date() + 30,
                         format = "dd/mm/yyyy",
                         startview = 'year', language = 'fr', weekstart = 1 ),
              textInput("heure", "Heure", value = as.character(strftime(Sys.time(), format="%H:%M"))),
              conditionalPanel(condition = "input.objet == 'Itineraire'", 
                               hr(),
                               div(actionButton("rapide", label = "+ rapide"),actionButton("court", label = "+ court")))
             ),
             wellPanel(
               checkboxGroupInput("modeTransport", label = h3("Mode de transport"), 
                                  choices = list("Velib" = 1, "Autolib" = 2),
                                  selected = character(0), inline=TRUE)
             ),
             wellPanel(
               h3("Depart", align = "center"),
               checkboxInput("procheDepart", label = "Le plus proche", value = FALSE),
               sliderInput("sliderDepart","Nombre de velos disponibles",min=0,max=25,value=1)
             ),
             conditionalPanel(condition = "input.objet == 'Itineraire'", wellPanel(
               h3("Arrivée", align = "center"),
               checkboxInput("procheArrivee", label = "Le plus proche", value = FALSE),
               sliderInput("sliderArrivee","Nombre de places disponibles",min=0,max=25,value=1),
               tags$small(paste0(
                 "Attention: les places peuvent être prises d'assaut pendant que ",
                 "vous flanez sur votre bicyclette."
               ))
              ))
      ),
    
      column(8,
             leafletOutput("carte", height = 700),
               column(6,
                      h3("Départ"),
                      dataTableOutput("table_depart")),
             conditionalPanel(condition = "input.objet == 'Itineraire'",column(6,
                      h3("Arrivée"),
                      dataTableOutput("table_arrive")))
                
             
         
      )
  )
  )
  )
