test_results <- data.frame(id=sprintf("%03d", c(1:400)),
                           source=c(rep("GP", 400), rep("INPATIENT", 400)),
                           potassium=c(rnorm(200, mean=4.25, sd=0.375), rep(NA, 200),
                                       rnorm(200, mean=4.25, sd=0.5), rep(NA, 200)),
                           sodium=c(rep(NA, 200), rnorm(200, mean=140, sd=2.5),
                                    rep(NA, 200), rnorm(200, mean=140, sd=4)),
                           stringsAsFactors = FALSE)
write.csv(test_results,
          file="data/scenario_1.csv",
          quote=c(1, 2),
          row.names=FALSE)
