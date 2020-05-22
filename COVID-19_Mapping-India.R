#Author information ---------
#Author name: G Vamsi Krishna
#Created on: May 22, 2020
#Version: 3.6.1 (R.Studio)

# Libraries --------------------
library(ggplot2)
library(readxl)
library(ggmap)
library(gganimate)
library(sf)
library("rnaturalearth")
library("rnaturalearthdata")
library(rgeos)
library(gifski)

# Shape file of the World -------------
world <- ne_countries(scale = "medium", returnclass = "sf")

g<-ggplot(data=world)+
  geom_sf()

# Data and Borders --------------

# World Borders
borders <- borders("world")$data[, 1:5]

#Dataset EUopen portal
data <- read_excel("Desktop/Covid/COVID-19-geographic-disbtribution-worldwide.xlsx")

# Merge shapefile with Gapminder data 
df <- merge(data, borders, by.x = "countriesAndTerritories", by.y = "region", all.x = F,all.y=F)

# Order data
df<- df[with(df, order(group, order,dateRep)), ]


#Time series --------------
i<-g+geom_polygon(data=subset(df,countriesAndTerritories==c("India")),
                  aes(x=long,y=lat,group=group,fill=cases),
                  alpha=0.5,color="black")+
  scale_fill_gradientn(colours = c("green", "yellow", "red")) +
  labs(title = "COVID-19 cases in INDIA on {frame_time}")+
  transition_time(dateRep)



# Animation -------------------
animate(i,renderer=gifski_renderer(),
        start_pause=2,end_pause=3,
        fps=4,nframes=360,
        width=1920 ,height=1080)

anim_save("Output.gif")

