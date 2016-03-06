# encoding: utf-8
###############################################################################.
#
# Titre : server.R
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

shinyServer(function(input, output) {
  
  carteL<-reactive({
    mon.data<-velibs2

                 
    m <- faireCarteVierge()
    m <- ajouterPoints(m, lng = mon.data$longitude, lat = mon.data$latitude, 
                       radius = mon.data$bike_stands,
                       color = ifelse(mon.data$available_bikes>=2, "green", "red"),
                       titre = mon.data$name,
                       attributs = mon.data[,c("bike_stands","available_bike_stands", "available_bikes")])
    
    
 
    m
    
  })
  
  carteL2<-reactive({
    m<-carteL()
    rvelo<-route(from=as.character(input$addresse1), to=as.character(input$addresse2),
                 mode="bicycling", structure="route", alternatives=FALSE)
    m<-m %>% addPolylines(data = rvelo, lng = ~lon , lat = ~lat) 
    m
  })
  
  tableDep<-reactive({
    t<- rechercheVelib(adresse=input$addresse1,
                             table=velibs2, ##table des stations, velib ou autolib
                             nb=50)
    #names(t)<-c('Adresse de la station','Nombre de vélos','Emplacement disponible','Nombre de vélos disponibles')
    t<-t[t$available_bikes>=input$sliderDepart,]
    t
  })
  tableArrivee<-reactive({
    t<- rechercheVelib(adresse=input$addresse2,
                       table=velibs2, ##table des stations, velib ou autolib
                       nb=50)
    t<-t[t$available_bike_stands>=input$sliderArrivee,]
    t
  })
  
  
  output$table_depart = renderDataTable({
    tableDep()[,c("name","bike_stands","available_bike_stands", "available_bikes")]
  })
  output$table_arrive = renderDataTable({
    tableArrivee()[,c("name","bike_stands","available_bike_stands", "available_bikes")]
  })
  
  output$carte <- renderLeaflet({
    if (input$objet=="Itineraire"){
      carteL2()
    }else{
      carteL()
    }

  })
})




