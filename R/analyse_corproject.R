# Fonctions analyse stat COR Project

setwd("C:/Users/Camille/Documents/Essai/CORproject/data")

# Db usage du sol
data_temp<-read.table("FitnessExperimentalDesign_G60Final.csv", header=TRUE, sep=";", na.strings="NA")


# Graphe par Env

graphe<- function(data) {

moy_pop_env<-plyr::ddply(data, c("Pop", "Env"), summarise,
                 Moy=mean(Col))
moy_pop_env

g_pop_env<-ggplot2::ggplot(data=moy_pop_env, aes(x=Pop, y=Moy, fill=Env))+
  geom_bar(stat="identity", color="black")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  facet_wrap(vars(Env))
g_pop_env

}

graphe(data_temp)

# Analyse

analyse_stat<- function(data_temp){
glmer_mouches<-lme4::glmer(Col~Env+Pop+(1|Block),data=data_temp,family="poisson")
glmer_mouches
simulationOutput <- DHARMa::simulateResiduals(fittedModel = glmer_mouches, n = 250) # QQplot
DHARMa::plotSimulatedResiduals(simulationOutput = simulationOutput, quantreg = TRUE)
anova_mouches<-car::Anova(glmer_mouches, test="Chisq")
anova_mouches
sump<-summary(multcomp::glht(glmer_mouches, mcp("Pop"="Tukey")))
sump
sume<-summary(glht(glmer_mouches, mcp("Env"="Tukey")))
sume
}


