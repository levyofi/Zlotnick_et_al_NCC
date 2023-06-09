library(ncdf4)
library(raster)
library(maptools)
library(plotrix)
library(gplots)
library(rasterVis)
library(maps)
library(RColorBrewer)
library(ggplot2)

dir.create("..//results", showWarnings = F)
dir.create("..//results//figure_S2", showWarnings = F)

figure_S2_facet_a <- function(){
  
  # loading data from netcdf
  
  case <- "past_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  min <- 0
  max <- 4000
  by <- 1000
  
  activity_hours_l <- raster(past_climbing_mat)
  #print(min(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  #print(max(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                       "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
  
  tiff(file=paste("..\\results\\figure_S2\\facet_a.tiff", sep = ""), width=6000, height=2500, res=300, compression="lzw")
  
  colord=jet.colors(100)
  breaks <- seq(min,max,length.out = 100)
  plot(activity_hours_l, pch = 18, col = colord, asp = 0.5, ylim=c(0,1), xlim=c(0,1), xlab="", ylab="", xaxt="n", yaxt="n", breaks = breaks, legend = FALSE)
  plot(activity_hours_l, pch = 18, breaks = breaks, asp = 0.45, legend.width = 3, col = colord, axis.args=list(cex.axis=1.5, tcl = -0.2, mgp=c(0,0.5,0), lwd=0.5, at=seq(min,max,by)), axes=FALSE, box=FALSE)
  
  dev.off()
}


figure_S2_facet_b <- function(){
  
  # load data from netcdf files
  
  case <- "past_not_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_not_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  case <- "past_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  
  # past - change if climbing
  
  past_change_if_climbing_per_mat <- ((past_climbing_mat - past_not_climbing_mat) / past_climbing_mat) * 100
  
  min <- 0
  max <- 80
  by <- 20
  
  activity_hours_l <- raster(past_change_if_climbing_per_mat)
  #print(min(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  #print(max(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("grey79", "yellow", "#FF7F00", "red", "#7F0000"))
  
  tiff(file=paste("..\\results\\figure_S2\\facet_b.tiff", sep = ""), width=6000, height=2500, res=300, compression="lzw")
  
  colord=jet.colors(100)
  breaks <- seq(min,max,length.out = 100)
  plot(activity_hours_l, pch = 18, col = colord, asp = 0.5, ylim=c(0,1), xlim=c(0,1), xlab="", ylab="", xaxt="n", yaxt="n", breaks = breaks, legend = FALSE)
  plot(activity_hours_l, pch = 18, breaks = breaks, asp = 0.45, legend.width = 3, col = colord, axis.args=list(cex.axis=1.5, tcl = -0.2, mgp=c(0,0.5,0), lwd=0.5, at=seq(min,max,by)), axes=FALSE, box=FALSE)
  
  dev.off()
}


figure_S2_facet_c <- function(){
  
  # load data from netcdf files
  
  case <- "past_not_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_not_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))

  case <- "past_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  
  # past - change if climbing
  
  past_change_if_climbing_mat <- past_climbing_mat - past_not_climbing_mat
  
  min <- 0
  max <- 2000
  by <- 500
  
  activity_hours_l <- raster(past_change_if_climbing_mat)
  #print(min(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  #print(max(activity_hours_mat[activity_hours_mat != -10000], na.rm = TRUE))
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("grey79", "yellow", "#FF7F00", "red", "#7F0000"))
  
  tiff(file=paste("..\\results\\figure_S2\\facet_c.tiff", sep = ""), width=6000, height=2500, res=300, compression="lzw")
  
  colord=jet.colors(100)
  breaks <- seq(min,max,length.out = 100)
  plot(activity_hours_l, pch = 18, col = colord, asp = 0.5, ylim=c(0,1), xlim=c(0,1), xlab="", ylab="", xaxt="n", yaxt="n", breaks = breaks, legend = FALSE)
  plot(activity_hours_l, pch = 18, breaks = breaks, asp = 0.45, legend.width = 3, col = colord, axis.args=list(cex.axis=1.5, tcl = -0.2, mgp=c(0,0.5,0), lwd=0.5, at=seq(min,max,by)), axes=FALSE, box=FALSE)
  
  dev.off()
}






