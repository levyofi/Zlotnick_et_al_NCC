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
dir.create("..//results//figure_S13", showWarnings = F)


figure_S13_facet_a <- function(file_name, activity_hours_mat, min, max, by){
  
  # load data from netcdf files
  
  case <- "past_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  past_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  case <- "future_climbing"
  file_name <- paste("..\\netcdf_files\\", case, ".nc", sep = "")
  nfile <- nc_open((file_name))
  future_climbing_mat <- ncvar_get(nfile, varid = "annual_activity_hours")
  status <- nc_close((nfile))
  
  
  # climbing - effect of climate change
  
  climbing_change_in_time_mat <- future_climbing_mat - past_climbing_mat
  
  min <- -1000
  max <- 1500
  by <- 500
  
  activity_hours_l <- raster(climbing_change_in_time_mat)
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("#00007F", "#007FFF", "grey79",
                       "yellow", "red", "#7F0000"))
  
  tiff(file=paste("..\\results\\figure_S13\\facet_a.tiff", sep = ""), width=6000, height=2500, res=300, compression="lzw")
  
  colord=jet.colors(100)
  breaks <- seq(min,max,length.out = 100)
  plot(activity_hours_l, pch = 18, col = colord, asp = 0.5, ylim=c(0,1), xlim=c(0,1), xlab="", ylab="", xaxt="n", yaxt="n", breaks = breaks, legend = FALSE)
  plot(activity_hours_l, pch = 18, breaks = breaks, asp = 0.45, legend.width = 3, col = colord, axis.args=list(cex.axis=1.5, tcl = -0.2, mgp=c(0,0.5,0), lwd=0.5, at=seq(min,max,by)), axes=FALSE, box=FALSE)
  
  dev.off()
}


figure_S13_facet_b <- function(mat){
  
  rel_df <- as.data.frame(mat)
  rel_df$mean_ta_year <- rel_df$mean_ta_year - 273.15
  
  time_df <- rel_df %>%
    group_by(id) %>%
    summarise(first_ah = first(annual_activity_hours), last_ah = last(annual_activity_hours), first_gr = first(growth_rate_per_year), last_gr = last(growth_rate_per_year), first_mty = first(mean_ta_year)) %>%
    mutate(diff_ah = last_ah - first_ah, diff_gr = last_gr - first_gr)
  
  
  big_rel_df <- merge(rel_df, time_df, by = c("id"))
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                                "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
                                
  colord=jet.colors(100)
  
  tiff(file=paste("..\\results\\figure_S13\\facet_b.tiff", sep = ""), width=5000, height=2500, res=300, compression="lzw")
  
  p <- ggplot(big_rel_df, aes(x = diff_ah, y = diff_gr, z = first_mty)) +
    theme_bw() +
    stat_summary_hex(bins = 100) +
    xlab("Change in mean annual activity hours") +
    ylab("Change in growth rate [lizards/year]") +
    theme(axis.title.y = element_text(size = 22, face = "bold", vjust = 3),
          axis.title.x = element_text(size = 22, face = "bold", vjust = 0),
          legend.text = element_text(size = 18),
          legend.title = element_text(size = 18),
          legend.key.height = unit(2,"cm"),
          legend.title.align = 0.5,
          axis.text.x = element_text(size = 28),
          axis.text.y = element_text(size = 28),
          plot.margin = margin(1,1,1,1, "cm"),
          panel.grid = element_blank()) +
    labs(fill = "Mean annual air\ntemperature [\u00B0C]\n") +
    scale_fill_gradientn(colors = colord) +
    xlim(-750,1250) +
    ylim(-7.5,7.5)
  
  print(p)
  
  dev.off()
}