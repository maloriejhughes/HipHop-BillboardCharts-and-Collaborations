library(readr)
library(tidyverse)
library(lubridate)
library(stringr)
library(ggplot2)
library(highcharter)


# Clean -------------------------------------------------------------------


us_billboard <- read_delim("../Python/us_billboard.psv",delim="|", col_names = FALSE)
colnames(us_billboard)<-c("pos" ,"last.week", "peak" ,"weeks.on.chart" , "title","artist", "chart.entry.date", "entry.position", "overall.peak", "overall.weeks.on.chart", "chart.date")
us_billboard$chart.entry.date<-as.Date(us_billboard$chart.entry.date)


us_billboard$chart.date<- paste0(substr(us_billboard$chart.date,1,4),"-",substr(us_billboard$chart.date,5,6),"-",substr(us_billboard$chart.date,7,8))
us_billboard$chart.date<-as.Date(us_billboard$chart.date)

us_billboard$year<-year(us_billboard$chart.date)
us_billboard$artist<-as.character(us_billboard$artist)
patterns<-c("featuring", "&", "with","and", "/",",")

us_billboard$collab <- ifelse(grepl(paste(patterns, collapse = "|"), us_billboard$artist), "Collaboration","Solo")


# Collab ------------------------------------------------------------------



collab <- us_billboard %>%
    filter(collab == "Collaboration")
yearly <- collab %>%
    group_by(year) %>%
    summarize(tot=n())


# Plot Collab over Time ---------------------------------------------------



#plot yearly collaboration occurrences 
ggplot(yearly,aes(x=year,y=tot)) +
    geom_bar(stat = "identity") +
    geom_smooth() +
    xlab("Year") + ylab("Number of Songs") +
    ggtitle("Frequency of Song Collaborations on the Billboard Hot 100 List")


typeof(yearly$tot)
hc<- highchart() %>% hc_xAxis(yearly$year) %>% hc_add_series(data=yearly$tot, name="Number of Collaborations")
hc %>% 
    hc_chart(type = "column")# %>% hc_add_series(type="",data=yearly$tot )


hchart(yearly,type="column", value=list(x=yearly$year,y=yearly$tot)) %>% hc_title(text="Yearly Total Collaborations on Billboard Hot 100")




# Labeling Hiphop ---------------------------------------------------------

hiphop_artists_ids<-read_csv("~/Documents/2018/06_Music/DATA/CLEANED/hiphop_artists_ids.csv")



patterns<-hiphop_artists_ids$artist
    
us_billboard$genre <- ifelse(grepl(paste(patterns, collapse = "|"), us_billboard$artist), "Hiphop","Other")

write_csv(us_billboard, "~/Documents/2018/06_Music/DATA/CLEANED/us_billboard_with_genre.csv")
