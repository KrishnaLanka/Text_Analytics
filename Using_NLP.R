# Clear space

rm(list=ls())

# Install required packages

require(rvest) || install.packages('rvest')
require(NLP) || install.packages('NLP')
require(openNLP) || install.packages('openNLP')
install.packages("openNLPmodels.en", repos = "http://datacube.wu.ac.at/", type = "source")
require(ggmap) || install.packages('ggmap')
require(rworldmap) || install.packages("rworldmap")
require(rworldxtra) || install.packages("rworldxtra")

library(rvest)
library(NLP)
library(openNLP)
library(openNLPmodels.en)
library(ggmap)
library(rworldmap)
library(rworldxtra)

# Select any well known firm or a person, I have selected Elon Musk

page = read_html("https://en.wikipedia.org/wiki/Elon_Musk")

# Scraping OpenAI Wikipedia Page.

text = html_text(html_nodes(page,'p'))
text = text[text != ""]
text = gsub("\\[[0-9]]|\\[[0-9][0-9]]|\\[[0-9][0-9][0-9]]","",text) # removing references [101] type

## Make one complete document
text = paste(text,collapse = " ") 

text = as.String(text)

#Using OpenNLP, finding all locations and Persons mentioned in Elon Musk Wikipedia Page. Setting timers.

t1 = Sys.time()

sent_annot = Maxent_Sent_Token_Annotator()
word_annot = Maxent_Word_Token_Annotator()
loc_annot = Maxent_Entity_Annotator(kind = "location")
person_annot = Maxent_Entity_Annotator(kind = "person")

annot.l1 = NLP::annotate(text, list(sent_annot,word_annot,loc_annot,person_annot))

Sys.time() - t1

k <- sapply(annot.l1$features, `[[`, "kind")
EM_locations = text[annot.l1[k == "location"]]
EM_persons = text[annot.l1[k == "person"]]

locations = unique(EM_locations) # view contents of this obj
persons = unique(EM_persons)

print(locations)

print(persons)
