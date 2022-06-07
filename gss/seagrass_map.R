# Load libraries
library(tidyverse)
library(tmap)
library(sf)
library(spData)
library(here)
library(ggmap)

world_map <- tm_shape(spData::world) +
  tm_fill()
st_crs(spData::world)
#Match coordinates to base world map

st_geometry(spData::world)
head(spData::world)

madagascar <- filter(spData::world, name_long == "Madagascar") %>%
  st_transform(crs = 4326)

tm_shape(seagrass)+
  tm_fill() 

#Read in all BoR shapefiles
bayofranobe <- read_sf(here("data", "recouvrement","drv_classif_recouvrement.dbf")) %>% 
  st_transform(crs = 4326)

#Read in seagrass shapefiles
seagrass <- read_sf(here("data", "Seagrass_Bay_of_Ranobe","herbiers_bdr.dbf")) %>% 
  st_transform(crs = 4326)
st_geometry(seagrass)
seagrass_sp <- as(seagrass, Class = "Spatial")
#Take bounding box for seagrass with crs 4326, convert to match stamen map) 
bbox <- c(4837047, -2657547, 4855526,-2626976)


#Crop background map
mad_map <- get_stamenmap(bbox, maptype = "terrain", crop = FALSE, zoom = 2)
plot(mad_map)

#Plot seagrass on background

ggplot() +
  geom_sf(data=seagrass, mapping = aes(color = Class_name)) +
  ggtitle("Seagrass Beds in Bay of Ranobe") +
  labs(x = "Longitude (deg)", y = "Latitude (deg)")

seagrass_simple <- 

tmap_mode("plot")
tm_shape(seagrass_sp) +
  tm_polygons(col = "Class_name") +
  tmap_options(check.and.fix = TRUE)
class(seagrass_sp)

