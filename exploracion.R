
library(tidyverse)

dom.cruda <- read.csv("domestico.csv",header = T)

dom <- dom.cruda %>% 
  select("Deal.ID","X","Y","Current.size.under.contract..ha.","year","Operating.company..Classification") %>% 
  rename(ID = "Deal.ID",
         ha = "Current.size.under.contract..ha.",
         yr = "year",
         quien = "Operating.company..Classification") %>% 
  filter(!is.na(X)|!is.na(Y))

ggplot(dom,aes(x=ha))+
  geom_boxplot()

extr.cruda <- read.csv("extranjero.csv", header = T)
extr <- extr.cruda %>% 
  select("Deal.ID","X","Y","Current.size.under.contract","year","Operating.company..Classification") %>% 
  rename(ID = "Deal.ID",
         ha = "Current.size.under.contract",
         yr = "year",
         quien = "Operating.company..Classification")

ggplot(extr,aes(x="",y=ha))+
  geom_boxplot()+
  geom_jitter(aes(colour = factor(yr)))
