args=commandArgs(trailingOnly = TRUE)

base<-args[1]

s<-as.double(args[2])

xmaxx<-as.double(args[3])

inds<-as.character(read.table(paste(s,"tmp.indv",sep="."))$V1)

pdf(paste(base,"hetIndStats.pdf",sep="."),width=10,height=5)

rcbpal<-c("#ffeda0","#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#bd0026","#800026")

par(mfrow=c(1,2))
rf<-colorRampPalette((rcbpal))
r<-rf(12)

for(i in inds){
if(file.exists(paste(s,"hets",i,sep="."))){if(file.info(paste(s,"hets",i,sep="."))$size>0){
d<-read.table(paste(s,"hets",i,sep="."),sep=",")
d<-cbind(d,max=apply(d,1,max),min=apply(d,1,min))
d<-cbind(d,minreadprop=d$min/(d$min+d$max),depth=d$min+d$max)
x.bin<-seq(floor(min(d$depth,na.rm=T)),ceiling(max(d$depth,na.rm=T)),length=ceiling(max(d$depth,na.rm=T))-floor(min(d$depth,na.rm=T))+1)
y.bin<-seq(floor(min(d$min,na.rm=T)),ceiling(max(d$min,na.rm=T)),length=ceiling(max(d$min,na.rm=T))-floor(min(d$min,na.rm=T))+1)
freq<-as.data.frame(table(findInterval(d$depth,x.bin),findInterval(d$min,y.bin)))
freq[,1] <- as.numeric(as.character(freq[,1]))
freq[,2] <- as.numeric(as.character(freq[,2]))
freq2D<-matrix(0,nrow=length(x.bin),ncol=length(y.bin))
freq2D[cbind(freq[,1], freq[,2])] <- freq[,3]
if(xmaxx==0) xmaxx=max(x.bin,na.rm=T)
image(x.bin,y.bin,log10(freq2D),col=r,breaks = seq(0,max(log10(freq2D),na.rm=T),length.out=length(r)+1),
main=paste(i,sep=""),xlab="DP",ylab="Reads minor alleles",xlim=c(0,xmaxx),ylim=c(0,max(x.bin,na.rm=T)/2))
barval<-round(10^(seq(0,max(log10(freq2D),na.rm=T),length.out = length(r)+1)))
legend("topleft",legend=rev(barval[round(seq(2,length(barval),length.out = length(r)))]),
fill=rev(r[round(seq(1,length(barval[-1]),length.out = length(r)))]),bty="n",ncol=3,title="heterozygous genotypes count")
abline(0,1/2)
abline(0,1/5,col="#00FF0088",lty=1)
abline(0,3/10,col="#0000FF88",lty=1)
legend("left",c("50:50 both alleles","70:30 common:rare","80:20"),
lwd=1,lty=c(1,1,1),col=c(1,"#0000FF88","#00FF0088"),bty="n",cex=0.8)
hist(d$minreadprop,breaks=seq(0,0.5,by=0.02),col=1,xlim=c(0,0.5),
xlab="Proportion minor allele reads",main=paste(i,sep=""))
abline(v=0.2,col="#00FF0088",lty=1)
abline(v=0.3,col="#0000FF88",lty=1)
}}
}

dev.off()
