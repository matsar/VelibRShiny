# encoding: utf-8
###############################################################################.
#
# Titre : global.R
# 
# Theme : Data Science - projet VelibR
#
# Creation : 27 février 2016
# MAJ : 22/04/2016
#
# Auteur : CEPE gpe 1
###############################################################################.



# Descriptif :Initialisation de l'appli Shiny
###############################################################################.


# Chargement des packages et fonctions -----------------------------------------

# TODO{2016-03-06, Matthieu}: identifier les packages réellement utilisés
library(shiny)
library(dplyr)
require(plyr)
require(stringr)
library(lubridate)
require(rgbif) #il faut passer par le zip!
library(ggmap)
require(dismo)
require(rgdal)
require(leaflet)

library(XML) # shinyapps le réclame

source("fonctions.R") # nos fonctions


# Chargement des données Velib -------------------------------------------------

# Chargement statique des données prétraitées
load("data/velibsFormate.RData") # --> charge velibs2

# Rq : Chargement dynamique désactivé pour le github provisoirement
# TODO : à réactiver

## Ajout des altitudes (désactivé pour l'instant car trop long)
#elevs<-sapply(1:nrow(velibs2), FUN=elevationAnne) ##recuperation des altitudes de stations velibs
#velibs2<-data.frame(velibs2, elevation=elevs)


# Chargement des données Autolib -----------------------------------------------

load("data/autolibsFormate.RData") # --> charge autolibs2
