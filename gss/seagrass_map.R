# Working document for Bay of Ranobe Seagrass Restoration Feasibility Study
# June 8, 2022 O. Won

#Load libraries 
library(here)
source(here("seagrass_load_libraries.R"))

#Simple map
world_map <- tm_shape(spData::world) +
  tm_fill()
st_crs(spData::world)

#Match coordinates to base world map
st_geometry(spData::world)
head(spData::world)

madagascar <- filter(spData::world, name_long == "Madagascar") %>%
  st_transform(crs = 4326)

#Read in all BoR shapefiles
bayofranobe <- read_sf(here("data", "recouvrement","drv_classif_recouvrement.dbf")) %>% 
  st_transform(crs = 4326)

#Read in seagrass shapefiles, save as spatial object
seagrass <- read_sf(here("data", "Seagrass_Bay_of_Ranobe","herbiers_bdr.dbf")) %>% 
  st_transform(crs = 4326)
st_geometry(seagrass)
seagrass_sp <- as(seagrass, Class = "Spatial")

#Take bounding box for seagrass with crs 4326, convert to match stamen map), use st_bbox

bbox <- c(4837047, -2657547, 4855526,-2626976,)
class(bbox)


#Background map 
mad_map <- get_stamenmap(bbox, maptype = "toner-lite", crop = FALSE, zoom = 4)
plot(mad_map) #not working due to poor tile data?

m <- leaflet() %>% 
  setView(lng = 43.555, lat = -23.1404, zoom = 10) %>% 
  addProviderTiles(providers$Esri.WorldImagery)
class(m)
#addProviderTiles "CartoDB.Positron" good for simpler map


#Plot seagrass with ggplot

ggplot() +
  geom_sf(data=seagrass, mapping = aes(color = Class_name)) +
  ggtitle("Seagrass Beds in Bay of Ranobe") +
  labs(x = "Longitude (deg)", y = "Latitude (deg)")


# Plot seagrass beds map, use tmap_mode("view") for interactive with base ESRI map 
currentseagrassmapBoR <- tmap_mode("view")
  tm_shape(seagrass_sp) +
  tm_fill(col = "Class_name") +
    tm_basemap(leaflet::providers$Esri.WorldImagery)+
  tmap_options(check.and.fix = TRUE)+
  tm_scale_bar(position = c("left", "bottom"))+
  tm_layout(main.title = "Seagrass beds Bay of Ranobe")
  # save interactive plot
  
class(seagrass_sp)

