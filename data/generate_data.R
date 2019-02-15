library(dplyr)
library(magrittr)
library(lubridate)

scenario_1 <- data.frame(id=sprintf("%03d", c(1:400)),
                           source=c(rep("GP", 400), rep("INPATIENT", 400)),
                           potassium=c(rnorm(200, mean=4.25, sd=0.375), rep(NA, 200),
                                       rnorm(200, mean=4.25, sd=0.5), rep(NA, 200)),
                           sodium=c(rep(NA, 200), rnorm(200, mean=140, sd=2.5),
                                    rep(NA, 200), rnorm(200, mean=140, sd=4)),
                           stringsAsFactors = FALSE)
write.csv(scenario_1,
          file="data/scenario_1.csv",
          quote=c(1, 2),
          row.names=FALSE)

scenario_2 <- data.frame(data_analisi=rep(c("4/2/2019", "5/2/2019", "6/2/2019", "7/2/2019", "8/2/2019"), 80),
                         id=sprintf("%03d", c(1:400)),
                         sialo_4 = c(rnorm(250, mean=80, sd=3),
                                     rnorm(150, mean=70, sd=3)),
                         sialo_2 = c(rnorm(250, mean=0.4, sd=0.2),
                                     rnorm(100, mean=3, sd=1),
                                     rnorm(50, mean=8, sd=2)),
                         sialo_0 = c(rep(0, 350),
                                     rnorm(50, mean=1, sd=0.25)),
                         stringsAsFactors = FALSE)
scenario_2 %<>% mutate(sialo_5 = runif(length(sialo_4),
                                       max=100-(sialo_4+sialo_2+sialo_0),
                                       min=0),
                       sialo_3 = 100-(sialo_5+sialo_4+sialo_2+sialo_0),
                       cdt = sialo_2 + sialo_0) %>%
  select(data_analisi, id, sialo_5, sialo_4, sialo_3, sialo_2, sialo_0,
         cdt)
write.csv(scenario_2,
          file="data/scenario_2.csv",
          quote=c(1, 2),
          row.names=FALSE)

internal_standard_concentration = 120
scenario_3 <- data.frame(date=rep(dmy("7/11/2018") + seq(0, 112, by=7),
                                  each=20),
                         worklist_num=rep(1:20, times=17),
                         type=rep(c(rep("CAL", 8), rep("Sample", 12)),
                                  times=17),
                         level=rep(c(sprintf("CAL%d", 1:8), rep(NA, 12)),
                                   times=17),
                         expected_concentration=rep(c(20, 50, 120, 240, 500, 1000, 2000, 8000, rep(NA, 12)),
                                                    times=17),
                         result_concentration=
                           as.vector(replicate(17,
                                               c(c(20, 50, 120, 240, 500, 1000, 2000, 8000) *
                                                   rnorm(8, mean=1.0, sd=0.05),
                                                 rnorm(7, mean=70, sd=25),
                                                 rnorm(5, 1000, 300)))),
                         internal_standard_area=rnorm(340, mean=100, sd=5) * rep(rnorm(17, mean=1, sd=0.25), each=20),
                         stringsAsFactors = FALSE)
scenario_3 %<>% mutate(result_area = result_concentration / internal_standard_concentration * internal_standard_area) %>%
  select(date, worklist_num, type, level, expected_concentration, result_concentration,
         result_area, internal_standard_area)

write.csv(scenario_3,
          file="data/scenario_3.csv",
          quote=c(1, 2, 3),
          row.names=FALSE)