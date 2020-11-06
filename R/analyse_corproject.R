# Fonctions analyse stat COR Project

# Graphe par Env

#' Title
#'
#' @param csvpath
#'
#' @return
#' @export
#' @import ggplot2
#' @importFrom plyr ddply
#' @importFrom dplyr summarise
#'
#' @examples
graphe<- function(csvpath="./data/fitness.csv") {

  data<-read.table(csvpath, header=TRUE, sep=",", na.strings="NA")

moy_pop_env<-plyr::ddply(data, c("pop", "env"), dplyr::summarise,
                 Moy=mean(col))
moy_pop_env

g_pop_env<-ggplot2::ggplot(data=moy_pop_env, aes(x=pop, y=Moy, fill=env))+
  geom_bar(stat="identity", color="black")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  facet_wrap(vars(env))
g_pop_env

}


# Analyse

#' Analyse
#'
#' @param csvpath
#'
#' @return
#' @export
#' @importFrom lme4 glmer
#' @importFrom DHARMa plotSimulatedResiduals
#' @importFrom car Anova
#' @import multcomp
#' @examples
#
analyse_stat<- function(csvpath="./data/fitness.csv"){
  data<-read.table(csvpath, header=TRUE, sep=",", na.strings="NA")
  glmer_mouches<-lme4::glmer(nbadrep1~env+pop+(1|block),data=data,family="poisson")
  print(glmer_mouches)
  simulationOutput <- DHARMa::simulateResiduals(fittedModel = glmer_mouches, n = 250) # QQplot
  plot<-DHARMa::plotSimulatedResiduals(simulationOutput = simulationOutput, quantreg = TRUE)
  anova_mouches<-car::Anova(glmer_mouches, test="Chisq")
  print(anova_mouches)
  sump<-summary(multcomp::glht(glmer_mouches, linfct = mcp(pop="Tukey")))
  sump
  sume<-summary(multcomp::glht(glmer_mouches, linfct = mcp("env"="Tukey")))
  sume
  return(plot, anova_mouches, sump, sume)
}


