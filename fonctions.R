# encoding: utf-8
###############################################################################.
#
# Titre : Fonctions
# 
# Theme : Data Science - projet VelibR
#
# Creation : 6 mars 2016
# MAJ : 6 mars 2016
#
# Auteur : CEPE gpe 1
###############################################################################.



# Descriptif :Fonctions appelées dans global.R et server.R
###############################################################################.

# voir global.R pour les packages nécessaires

# 1- Fonctions de chargements et mise en forme ---------------------------------

# TODO : à mettre sous forme de fonction de chargements dynamiques via les API
#############--------------------
# 
# #les donnes d origine 
# velibs<-read.csv("data/stations-velib-disponibilites-en-temps-reel.csv", sep=";")
# autolibs<-read.csv("data/stations_et_espaces_autolib_de_la_metropole_parisienne.csv", sep=";")
# 
# ###--------------Mise en forme de la table autolib 
# coordAuto<-str_split_fixed(autolibs$Coordonnées.geo, pattern=",", n=2)%>%as.matrix%>%apply(as.numeric, MARGIN=2)
# autolibs2<-data.frame(autolibs, latitude=coordAuto[,1], longitude=coordAuto[,2] )
# 
# 
# 
# ##-------------------Pretraitement sur les velibs 
# #separation de latitude et longitude 
# coord<-str_split_fixed(velibs$position, pattern=",", n=2)%>%as.matrix%>%apply(as.numeric, MARGIN=2)
# velibs2<-data.frame(velibs, latitude=coord[,1], longitude=coord[,2] )
# 
# 
# ##mise en forme des dates et heures
# velibs2<-velibs2%>%mutate(datetime0=substr(as.character(last_update),1,16),
#                           datetime=as.POSIXct(datetime0, "%Y-%m-%dT%H:%M", tz=Sys.timezone())
# )%>%select(-datetime0)%>%mutate(date=floor_date(datetime, "day"),
#                                 hour=hour(datetime),
#                                 minute=minute(datetime))

#save(velibs2, file="velibsFormate.RData") 
##############----------------


elevationAnne<-function(i, cleElev){
  # recuperation de l'elevation à partir des coordonnees longitude latitude : long!
  # nécessite une clé (API key google)
  print(i)
  Sys.sleep(1) ##on est oblige de ralentir pour etre servis par google
  x<-elevation(latitude=velibs2$latitude[i], longitude=velibs2$longitude[i], key=cleElev)$elevation
  return(as.numeric(x))
}


##tres long: recherche des altitudes
#elevs<-sapply(1:nrow(velibs2), FUN=elevationAnne) ##recuperation des altitudes de stations velibs
#velibs2<-data.frame(velibs2, elevation=elevs)


# 2- Fonctions de calcul -------------------------------------------------------


rechercheVelib<-function(adresse,
                         table, ##table des stations, velib ou autolib
                         nb=5){
  # recherche des n stations Velib (ou Autolib) les plus proches d'une adresse
  
  coord<-geocode(adresse )
  table.out<-table%>%
    mutate(distance=sqrt((latitude-coord$lat)^2 + (longitude-coord$lon)^2))%>%
    arrange(distance)
  table.out<-table.out[1:nb,]
  return(table.out)
}



# 3- Fonctions graphiques ------------------------------------------------------

faireCarteVierge <- function(lat=48.86, lng=2.344, zoom = 12){
  # Fond de carte Leaflet centrée sur [lat, lng]
  m <- leaflet()
  m <- addTiles(m)
  m <- setView(m, lat = lat, lng = lng, zoom = zoom)
  m
}


ajouterPoints <- function(m, lng, lat, titre="test", attributs=NULL, 
                          radius = 10, color="blue", ...){
  # m objet leaflet
  # lng, lat
  # titre
  # attributs data.frame d'info
  
  mm <- addCircleMarkers(m, lng = lng, lat = lat, radius = radius, color = color,
                         popup = genererTexte(titre, attributs),
                         clusterOptions = markerClusterOptions())
  mm
}


genererTexte <- function(titre, attributs=NULL){
  # Sous-fonction pour générer le texte d'une popup pour leaflet
  # @input titre [character]: texte du titre
  # @input attributs [data.frame]: data.frame contenant les infos à lister,
  #                                une colonne par info
  # @output texte html pour le contenu de la popup
  nb <- ncol(attributs)
  res <- paste0("<strong>",titre,"</strong><br>")
  if (!is.null(attributs)){
    for (i in 1:nb){
      res <- paste0(res, colnames(attributs)[i]," : ", attributs[,i], "<br>") 
    }
  }
  res
}
