#
# Plot a week's worth of browsing data by age group
#


pdf(file="testing-lines-2.pdf", width=11, height=4.5, family="Helvetica")

# read in table and remove rows with NAs
# agedata <- na.omit(read.table("startups_by_age.txt", sep="|", header=T))
# agedata <- na.omit(read.table("starts_by_age.txt", sep="|", header=T))
# agedata <- na.omit(read.table("browsing_by_age.txt", sep="|", header=T))
# agedata <- na.omit(read.table("avgtabs_by_age.txt", sep="|", header=T))
# agedata <- na.omit(read.table("sessions_by_age.txt", sep="|", header=T))
agedata <- na.omit(read.table("sessions_by_age_10min.txt", sep="|", header=T))

# color <- c("#EDF8E9", "#C7E9C0", "#A1D99B", "#74C476", "#31A354", "#006D2C")
# color <- c("red", "blue", "#A1D99B", "#74C476", "#31A354", "#006D2C")
# color <- c("0xE6AB02", "0xD95F02", "0x7570B3", "0xE7298A", "0x66A61E", "0x1B9E77")

# illustrator:
# blue, red, green, orange , , pink
color <- c("#0000FF", "#FF1D25", "#009103", "#F7941E", "#00A8E2", "#FFA4D6")

# (probably an easier way to do this)
agedata$color[agedata$q6==0] <- color[1]
agedata$color[agedata$q6==1] <- color[2]
agedata$color[agedata$q6==2] <- color[3]
agedata$color[agedata$q6==3] <- color[4]
agedata$color[agedata$q6==4] <- color[5]
agedata$color[agedata$q6==5] <- color[6]

ages <- c("<18", "18-25", "26-35", "36-45", "46-55", "55+")

survey = read.table("survey.csv", sep=",", header=T)

# par(bg="#eeeeee")
plot(agedata$stimestamp, agedata$total, type="n", ylim=c(0, .4), ylab="", xaxt="n") # for scales

# add a series for each age group
for(i in unique(agedata$q6)) {
  t = agedata[agedata$q6==i,]
  x = length(which(survey$q6==i))
  print(x)
  t$freq <- t$total/x
  # t$freq <- t$total
  # points(t$stimestamp, t$freq, col=t$color, type="p", pch=19, cex=.12)
  lines(lowess(t$stimestamp, t$freq, f=.04), lwd=2, col=t$color)
}
axis(1, at=c(1288756800, 1289361600)) # x axis
legend("topleft", legend=ages, lwd=1.5, col=color, cex=.7)

dev.off()
