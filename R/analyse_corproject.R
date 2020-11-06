# Fonctions analyse stat COR Project

setwd("C:/Users/Camille/Documents/Essai/CORproject/data")

# Db usage du sol
data_temp<-read.table("FitnessExperimentalDesign_G60Final.csv", header=TRUE, sep=";", na.strings="NA")


# Graphe par Env


graphe<- function() {

moy_pop_env<-plyr::ddply(data_temp, c("Pop", "Env"), summarise,
                 Moy=mean(Col))
moy_pop_env

g_pop_env<-ggplot2::ggplot(data=moy_pop_env, aes(x=Pop, y=Moy))+
  geom_bar(stat="identity", color="black", fill="grey")+
  theme_minimal()+
  facet_wrap(vars(Env))
g_pop_env

}

# Analyse

analyse_stat<- function(){
glmer_mouches<-lme4::glmer(Col~Env+Pop+(1|Block),data=data_temp,family="poisson")
glmer_mouches
simulationOutput <- DHARMa::simulateResiduals(fittedModel = glmer_mouches, n = 250) # QQplot
DHARMa::plotSimulatedResiduals(simulationOutput = simulationOutput, quantreg = TRUE)
anova_mouches<-lme4::Anova(glmer_mouches, test="Chisq")
anova_mouches
sump<-summary(multcomp::glht(glmer_mouches, mcp("Pop"="Tukey")))
sump
sume<-summary(glht(glmer_mouches, mcp("Env"="Tukey")))
sume
}
