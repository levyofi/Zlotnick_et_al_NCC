library(dplyr)
library(ggplot2)
library(rasterVis)
library(tidyverse)
library(ncdf4)
library(reshape2)

path <- "..//input//deep_data//day_sum_np.csv"
dir.create("..//results", showWarnings = F)
dir.create("..//results//figure_1", showWarnings = F)

figure_1 <- function(){
  
  df <- read.csv(path, header = TRUE)
  
  df$ess_shaded_tree <- -1 * df$ess_shaded_tree
  
  rel_df <- df[,c(1:4,10:11)] 
  
  rel_df <- melt(rel_df, id.vars = c("id", "time", "julian_day", "mean_ta"), variable.name = "where") 
  rel_df$time <- ifelse(rel_df$time == 0, "past", "future")
  
  curr_time <- "past"
  
  rel_df <- rel_df %>%
    filter(time == curr_time)
  
  
  
  jet.colors <- #taken from http://senin-seblog.blogspot.com/2008/09/some-r-color-palettes.html
    colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                                "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
                                
  colord=jet.colors(100)
  
  days_per_month <- c(0,31,59,90,120,151,181,212,243,273,304,334, 365)
  months <- c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", "")
  
  quantile_df <- quantile(unique(rel_df$mean_ta), c(0,0.33,0.67,1))
  
  names <- c("low", "med", "high")
  col_i <- c(0,33,67,100)
  
  for(i in 1:3){
    name <- names[[i]]
    
    min <- quantile_df[[i]]
    max <- quantile_df[[i+1]]
    
    spec_df <- rel_df %>%
      filter((mean_ta >= min) & (mean_ta < max))
    
    
    spec_col <- colord[col_i[[i]]:col_i[[i+1]]]
    
    
    
    tiff(file=paste("..\\results\\figure_1\\figure_1_", name, ".tiff", sep = ""), width=6000, height=4000, res=300, compression="lzw")
    
    p <- ggplot(spec_df, aes(x = julian_day, y = value, z = mean_ta)) + 
      theme_bw() +
      #geom_hline(yintercept = 0, color = "black", size = 1) +
      stat_summary_hex(bins = 100) +
      ylab(expression(paste("Time of essential climbing [", frac("minute","hour"),"]", sep = ""))) +
      #annotate(geom = "text", x = -50, y = 0, size = 5, label = "on shaded tree                  on open tree", angle = 90) +
      #xlab("Julian day                                                                                         Julian day") +
      theme(axis.title.y = element_text(size = 26, face = "bold", vjust = 6),
            axis.title.x = element_text(size = 26, face = "bold", vjust = -2),
            legend.text = element_text(size = 20),
            legend.title = element_text(size = 24),
            legend.title.align = 0.5,
            axis.text.x = element_text(size = 20, hjust = -3.5, vjust = -1),
            axis.text.y = element_text(size = 32, hjust = 2),
            strip.text = element_text(size = 34, face = "italic", vjust = 2),
            plot.margin = margin(2,2,2,2, "cm"),
            strip.background = element_blank(),
            panel.grid = element_blank()) +
      scale_fill_gradientn(colors = spec_col, guide = guide_colorbar(barheight = 20, barwidth = 2, vjust = 10)) + 
      labs(fill = "Mean annual\nair temperature\nin the past\n[Celsius]") +
      #facet_grid(. ~ factor(time, levels = c("past", "future"))) +
      scale_y_continuous(limits = c(-30,30),breaks = c(-30,-15,0,15,30), labels = c("30","15","  0","15","30")) +
      scale_x_continuous(limits = c(-1,366), breaks = days_per_month , labels = months)
    
    print(p)
    
    dev.off()
    
  }
  
}









