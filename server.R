# encoding: utf-8
###############################################################################.
#
# Titre : server.R
# 
# Theme : Data Science - projet VelibR
#
# Creation : 27 février 2016
# MAJ : 22/04/2016
#
# Auteur : CEPE gpe 1
###############################################################################.

require(shiny)
require(leaflet)

shinyServer(function(input, output) {
  
  carteL<-reactive({

    m <- faireCarteVierge()
    
    print(input$modeTransport)
    if ("vel" %in% input$modeTransport){
      m <- ajouterPoints(m, lng = velibs2$longitude, lat = velibs2$latitude, 
                         radius = velibs2$bike_stands,
                         color = ifelse(velibs2$available_bikes>=2, "green", "red"),
                         titre = velibs2$name,
                         attributs = velibs2[,c("bike_stands","available_bike_stands", "available_bikes")])
    }

    if ("auto" %in% input$modeTransport){
      m <- ajouterPoints(m, lng = autolibs2$longitude, lat = autolibs2$latitude,
                         radius = autolibs2$Autolib.,
                         color = "blue",
                         titre = autolibs2$Identifiant.Autolib.,
                         attributs = autolibs2[,c("Autolib.", "Emplacement","Tiers", "Abri")])
    }
    
    coord_dep <- geocode(input$addresse1) 
    m <- addMarkers(m, lng = coord_dep$lon, lat = coord_dep$lat, popup = paste("Depart : ", input$addresse1))
 
    m
    
  })
  
  carteL2<-reactive({
    m<-carteL()
    rvelo<-route(from=as.character(input$addresse1), to=as.character(input$addresse2),
                 mode="bicycling", structure="route", alternatives=FALSE)
    m<-m %>% addPolylines(data = rvelo, lng = ~lon , lat = ~lat) 
    coord_arr <- geocode(input$addresse2) 
    m <- addMarkers(m, lng = coord_arr$lon, lat = coord_arr$lat, popup = paste("Arrivée : ", input$addresse2))
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




