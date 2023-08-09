
library(tidyverse)
library(sf) # Package used for dealing with shapefiles and simple features
library(ggplot2)
library(gh)



############### Load files ###############

RiskRegion_sf <- st_read("Input/SFB_RiskRegions_20210304_SP Shapefiles/SFB_RiskRegions_20210304_SP.shp") # read in Risk Region shapefile from Input folder

Particles_sf <- st_read("Input/SFEI.ID.particles Shapefiles/SFEI.ID.particles.shp") %>% # Read in Particle Data from Input folder
  st_transform(st_crs(RiskRegion_sf)) # ask to transform to the same crs as the risk region shapefile

st_crs(RiskRegion_sf) #Check that the files are in the same crs: NAD83
st_crs(Particles_sf)




############### Cut Particle Data by Risk Region ##############

# Plot data with the risk region outlines before cutting 
ggplot() +
  geom_sf(data = RiskRegion_sf)  +
  geom_sf(data = Particles_sf)


Particle_Joined <- st_join(Particles_sf, RiskRegion_sf[3], left = T) %>% # left join of risk region numbers to SFEI data
  filter(!is.na(name))


# Plot data with the risk region outlines after cutting
ggplot() +
  geom_sf(data = RiskRegion_sf)  +
  geom_sf(data = Particle_Joined)



# Save new joined datafile as shapefile in output folder
write_sf(Particle_Joined, "Output/SFEI.ID.particles.byRiskRegion Shapefiles/SFEI.ID.particles.byRiskRegion.shp")

