# load pacakges
library(ggtree)
library(tidyverse)
library(tidytree)
library(ape)
library(treeio)
library("readxl")
library(viridis)
library("ggsci")

tree<-read.newick('nextstrain_groups_ngs-sa_COVID19-ZA-2021.02.17_timetree_v2.nwk')
metadata_df <- read_excel("sequenceIDs6.xlsx")

p<-ggtree(tree, mrsd="2021-02-13",as.Date=TRUE, aes(color=grepl('SouthAfrica',label,fixed=TRUE)),size=0.35) + theme_tree2()+
  scale_colour_manual(values=c("gray80", "gray30"), name="Sampling", labels=c('Global', 'South Africa'))+
  geom_tippoint(aes(
    subset=(grepl('SouthAfrica',label,fixed=TRUE)==TRUE)),size=1, align=F, fill='gray50', color='gray30',shape=21)+
  scale_x_date(date_labels = "%b-%y",date_breaks = "1 month")+
  #theme(axis.text=element_text(size=10))+
  expand_limits(y = 3800)+
  theme(axis.text.x = element_text(size=10,angle=90))
#theme(legend.position = 'none') ##### to label nodes if necessart
#geom_text(aes(label=node), hjust=-.3, size=2)

p


p1 <- p %<+% metadata_df + 
  geom_tippoint(aes(
    subset=(virus=='ncov'), fill=pangolin_lineage2),size=6, align=F, color='black', shape=21)+ #normal size 3
  #scale_fill_simpsons(name='Genomes in this study')
  scale_fill_manual(values=custom3,name='Genomes in this study')

####To label points, add below
  geom_tiplab(aes(
    subset=(grepl('K005325',label,fixed=TRUE)==TRUE)),label='K005325',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K002868',label,fixed=TRUE)==TRUE)),label='K002868',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004285',label,fixed=TRUE)==TRUE)),label='K004285',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004289',label,fixed=TRUE)==TRUE)),label='K004289',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004291',label,fixed=TRUE)==TRUE)),label='K004291',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004295',label,fixed=TRUE)==TRUE)),label='K004295',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004302',label,fixed=TRUE)==TRUE)),label='K004302',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K003667',label,fixed=TRUE)==TRUE)),label='K003667',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K003668',label,fixed=TRUE)==TRUE)),label='K003668',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K003673',label,fixed=TRUE)==TRUE)),label='K003673',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K003675',label,fixed=TRUE)==TRUE)),label='K003675',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004292',label,fixed=TRUE)==TRUE)),label='K004292',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004293',label,fixed=TRUE)==TRUE)),label='K004293',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004300',label,fixed=TRUE)==TRUE)),label='K004300',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K004306',label,fixed=TRUE)==TRUE)),label='K004306',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K008628',label,fixed=TRUE)==TRUE)),label='K008628',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K008633',label,fixed=TRUE)==TRUE)),label='K008633',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)+
  geom_tiplab(aes(
    subset=(grepl('K008637',label,fixed=TRUE)==TRUE)),label='K008637',linesize=0.6,color='royalblue3',geom='label',angle=45,size=3, parse=TRUE)
  
p1


