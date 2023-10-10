library(data.table)
library(ggplot2)
load("C:/Users/minunno/Documents/research/assessCarbon/results/dataRes2019_ErrCal.rdata")

dataRes2019[,resperPda2019 := (PINE*G)/100 - (perPda2019*Bda2019)/100]
dataRes2019[,resperSPda2019 := (SPRUCE*G)/100 - (perSPda2019*Bda2019)/100]
dataRes2019[,resperBda2019 := (BL*G)/100 - (perBda2019*Bda2019)/100]

dataRes2019[,resDda2019 := D - Dda2019]
dataRes2019[,resDs2019 := D - Ds2019]
dataRes2019[,resDm2019 := D -Dm2019]
dataRes2019[,plot(D,resDda2019,ylim=c(-40,20))]
dataRes2019[,points(D,resDs2019,col=2,pch=20)]
dataRes2019[,points(D,resDm2019,col=3,pch=20)]

dataRes2019[,resBda2019:= G-Bda2019]
dataRes2019[,resBs2019:= G-Bs2019]
dataRes2019[,resBm2019:= G-Bm2019]
dataRes2019[,plot(G,resBda2019,ylim=c(-40,20))]
dataRes2019[,points(G,resBs2019,col=2,pch=20)]
dataRes2019[,points(G,resBm2019,col=3,pch=20)]

dataRes2019[,resHda2019:= H-Hda2019]
dataRes2019[,resHs2019:= H-Hs2019]
dataRes2019[,resHm2019:= H-Hm2019]
dataRes2019[,plot(H,resHda2019,ylim=c(-40,20))]
dataRes2019[,points(H,resHs2019,col=2,pch=20)]
dataRes2019[,points(H,resHm2019,col=3,pch=20)]

dataRes2019[H<5,Hclass:=1]
dataRes2019[H>=5 & H<10, Hclass:=2]
dataRes2019[H>=10 & H<15, Hclass:=3]
dataRes2019[H>=15 & H<20, Hclass:=4]
dataRes2019[H>=20 & H<25, Hclass:=5]
# dataRes2019[H>=25 & H<30, Hclass:=6]
dataRes2019[H>=25, Hclass:=6]

dataRes2019[D<5,Dclass:=1]
dataRes2019[D>=5 & D<10, Dclass:=2]
dataRes2019[D>=10 & D<15, Dclass:=3]
dataRes2019[D>=15 & D<20, Dclass:=4]
dataRes2019[D>=20 & D<25, Dclass:=5]
dataRes2019[D>=25 & D<30, Dclass:=6]
dataRes2019[D>=30, Dclass:=7]

dataRes2019[G<7,Gclass:=1]
dataRes2019[G>=7 & G<14, Gclass:=2]
dataRes2019[G>=14 & G<21, Gclass:=3]
dataRes2019[G>=21 & G<28, Gclass:=4]
dataRes2019[G>=28 & G<35, Gclass:=5]
# dataRes2019[G>=35 & G<42, Gclass:=6]
dataRes2019[G>=35, Gclass:=6]

dataRes_ErrCal <- dataRes2019

load("C:/Users/minunno/Documents/research/assessCarbon/results/dataRes2019_noErrCal.rdata")

dataRes2019[,resperPda2019 := (PINE*G)/100 - (perPda2019*Bda2019)/100]
dataRes2019[,resperSPda2019 := (SPRUCE*G)/100 - (perSPda2019*Bda2019)/100]
dataRes2019[,resperBda2019 := (BL*G)/100 - (perBda2019*Bda2019)/100]

dataRes2019[,resDda2019 := D - Dda2019]
dataRes2019[,resDs2019 := D - Ds2019]
dataRes2019[,resDm2019 := D -Dm2019]
dataRes2019[,plot(D,resDda2019,ylim=c(-40,20))]
dataRes2019[,points(D,resDs2019,col=2,pch=20)]
dataRes2019[,points(D,resDm2019,col=3,pch=20)]

dataRes2019[,resBda2019:= G-Bda2019]
dataRes2019[,resBs2019:= G-Bs2019]
dataRes2019[,resBm2019:= G-Bm2019]
dataRes2019[,plot(G,resBda2019,ylim=c(-40,20))]
dataRes2019[,points(G,resBs2019,col=2,pch=20)]
dataRes2019[,points(G,resBm2019,col=3,pch=20)]

dataRes2019[,resHda2019:= H-Hda2019]
dataRes2019[,resHs2019:= H-Hs2019]
dataRes2019[,resHm2019:= H-Hm2019]
dataRes2019[,plot(H,resHda2019,ylim=c(-40,20))]
dataRes2019[,points(H,resHs2019,col=2,pch=20)]
dataRes2019[,points(H,resHm2019,col=3,pch=20)]


dataRes2019[H<5,Hclass:=1]
dataRes2019[H>=5 & H<10, Hclass:=2]
dataRes2019[H>=10 & H<15, Hclass:=3]
dataRes2019[H>=15 & H<20, Hclass:=4]
dataRes2019[H>=20 & H<25, Hclass:=5]
# dataRes2019[H>=25 & H<30, Hclass:=6]
dataRes2019[H>=25, Hclass:=6]

dataRes2019[D<5,Dclass:=1]
dataRes2019[D>=5 & D<10, Dclass:=2]
dataRes2019[D>=10 & D<15, Dclass:=3]
dataRes2019[D>=15 & D<20, Dclass:=4]
dataRes2019[D>=20 & D<25, Dclass:=5]
dataRes2019[D>=25 & D<30, Dclass:=6]
dataRes2019[D>=30, Dclass:=7]

dataRes2019[G<7,Gclass:=1]
dataRes2019[G>=7 & G<14, Gclass:=2]
dataRes2019[G>=14 & G<21, Gclass:=3]
dataRes2019[G>=21 & G<28, Gclass:=4]
dataRes2019[G>=28 & G<35, Gclass:=5]
# dataRes2019[G>=35 & G<42, Gclass:=6]
dataRes2019[G>=35, Gclass:=6]

dataRes_noErrCal <- dataRes2019


dataRes_noErrCal[,error:="Non-calib"]
dataRes_ErrCal[,error:="Calib"]


library(reshape2)
library(ggpubr)
df1 <- rbind(dataRes_ErrCal, dataRes_noErrCal)

df2 <- data.table(melt(df1[,.(Hclass,Tile,resHda2019,error)],id.var=c("Hclass","Tile","error")))
df2$Hclass <- as.factor(df2$Hclass)
p <- ggplot(df2, aes(x=Hclass, y=value,fill=error))
pAll_H <- p + geom_boxplot() + labs(title = "H") + ylab("m")
p <- ggplot(df2[Tile=="34VEQ"], aes(x=Hclass, y=value,fill=error))
p1_H <- p + geom_boxplot() + labs(title = "H")
p <- ggplot(df2[Tile=="35VLJ"], aes(x=Hclass, y=value,fill=error))
p2_H <- p + geom_boxplot() + labs(title = "H")
p <- ggplot(df2[Tile=="35WMN"], aes(x=Hclass, y=value,fill=error))
p3_H <- p + geom_boxplot() + labs(title = "H")
# ggarrange(p1,p2,p3,pAll)


df2 <- data.table(melt(df1[,.(Dclass,Tile,resDda2019,error)],id.var=c("Dclass","Tile","error")))
df2$Dclass <- as.factor(df2$Dclass)
p <- ggplot(df2, aes(x=Dclass, y=value,fill=error))
pAll_D <- p + geom_boxplot() + labs(title = "D") + ylab("cm")
p <- ggplot(df2[Tile=="34VEQ"], aes(x=Dclass, y=value,fill=error))
p1_D <- p + geom_boxplot() + labs(title = "D")
p <- ggplot(df2[Tile=="35VLJ"], aes(x=Dclass, y=value,fill=error))
p2_D <- p + geom_boxplot() + labs(title = "D")
p <- ggplot(df2[Tile=="35WMN"], aes(x=Dclass, y=value,fill=error))
p3_D <- p + geom_boxplot() + labs(title = "D")
# ggarrange(p1,p2,p3,pAll)

df2 <- data.table(melt(df1[,.(Gclass,Tile,resBda2019,error)],id.var=c("Gclass","Tile","error")))
df2$Bclass <- as.factor(df2$Gclass)
p <- ggplot(df2, aes(x=Bclass, y=value,fill=error))
pAll_B <- p + geom_boxplot() + labs(title = "G") + xlab("Gclass") + ylab(bquote(m^2~ha^-1))
p <- ggplot(df2[Tile=="34VEQ"], aes(x=Bclass, y=value,fill=error))
p1_B <- p + geom_boxplot() + labs(title = "G")
p <- ggplot(df2[Tile=="35VLJ"], aes(x=Bclass, y=value,fill=error))
p2_B <- p + geom_boxplot() + labs(title = "G")
p <- ggplot(df2[Tile=="35WMN"], aes(x=Bclass, y=value,fill=error))
p3_B <- p + geom_boxplot() + labs(title = "G")

fig1_A1 <- ggarrange(pAll_B,pAll_D,pAll_H,nrow = 3,common.legend = T)
ggsave(fig1_A1,filename = "C:/Users/minunno/Documents/research/assessCarbon/results/figures/fig1_A1.png",device = "png",height=8,width=7)


# Tab 1.A1
tabA1 <- matrix(NA,2,6)
tabA1[1,1] <- sqrt(mean(dataRes_noErrCal$resBda2019^2,na.rm=T))
tabA1[2,1] <- sqrt(mean(dataRes_ErrCal$resBda2019^2,na.rm=T))
tabA1[1,2] <- sqrt(mean(dataRes_noErrCal$resDda2019^2,na.rm=T))
tabA1[2,2] <- sqrt(mean(dataRes_ErrCal$resDda2019^2,na.rm=T))
tabA1[1,3] <- sqrt(mean(dataRes_noErrCal$resHda2019^2,na.rm=T))
tabA1[2,3] <- sqrt(mean(dataRes_ErrCal$resHda2019^2,na.rm=T))
tabA1[1,4] <- sqrt(mean(dataRes_noErrCal$resperPda2019^2,na.rm=T))
tabA1[2,4] <- sqrt(mean(dataRes_ErrCal$resperPda2019^2,na.rm=T))
tabA1[1,5] <- sqrt(mean(dataRes_noErrCal$resperSPda2019^2,na.rm=T))
tabA1[2,5] <- sqrt(mean(dataRes_ErrCal$resperSPda2019^2,na.rm=T))
tabA1[1,6] <- sqrt(mean(dataRes_noErrCal$resperBda2019^2,na.rm=T))
tabA1[2,6] <- sqrt(mean(dataRes_ErrCal$resperBda2019^2,na.rm=T))

colnames(tabA1) <- c("G","D","H","GP","GS","GB")
write.csv(tab1)