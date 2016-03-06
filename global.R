# encoding: utf-8
###############################################################################.
#
# Titre : global.R
# 
# Theme : Data Science - projet VelibR
#
# Creation : 27 f�vrier 2016
# MAJ : 6 mars 2016
#
# Auteur : CEPE gpe 1
###############################################################################.



# Descriptif :Initialisation de l'appli Shiny
###############################################################################.


# Chargement des packages et fonctions -----------------------------------------

# TODO{2016-03-06, Matthieu}: identifier les packages r�ellement utilis�s
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

source("fonctions.R") # nos fonctions


# Chargement des donn�es Velib -------------------------------------------------

# Chargement statique des donn�es pr�trait�es
load("data/velibsFormate.RData") # --> charge velibs2

# Rq : Chargement dynamique d�sactiv� pour le github provisoirement
# TODO : � r�activer

## Ajout des altitudes (d�sactiv� pour l'instant car trop long)
#elevs<-sapply(1:nrow(velibs2), FUN=elevationAnne) ##recuperation des altitudes de stations velibs
#velibs2<-data.frame(velibs2, elevation=elevs)


# Chargement des donn�es Autolib -----------------------------------------------

# TODO : Autolib � ajouter