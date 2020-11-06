# Fonctions analyse stat COR Project

# Db usage du sol



# Graphe par Env

graphe<- function(csvpath="./data/fitness.csv") {

  data<-read.table(csvpath, header=TRUE, sep=",", na.strings="NA")

moy_pop_env<-plyr::ddply(data, c("pop", "env"), summarise,
                 Moy=mean(col))
moy_pop_env

g_pop_env<-ggplot2::ggplot(data=moy_pop_env, aes(x=pop, y=Moy, fill=env))+
  geom_bar(stat="identity", color="black")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  facet_wrap(vars(Env))
g_pop_env

}


# Analyse

analyse_stat<- function(data){
glmer_mouches<-lme4::glmer(Col~Env+Pop+(1|Block),data=data,family="poisson")
glmer_mouches
simulationOutput <- DHARMa::simulateResiduals(fittedModel = glmer_mouches, n = 250) # QQplot
plot<-DHARMa::plotSimulatedResiduals(simulationOutput = simulationOutput, quantreg = TRUE)
anova_mouches<-car::Anova(glmer_mouches, test="Chisq")
anova_mouches
sump<-summary(multcomp::glht(glmer_mouches, mcp("Pop"="Tukey")))
sump
sume<-summary(glht(glmer_mouches, mcp("Env"="Tukey")))
sume
return(plot, anova_mouches, sump,sume)
}


