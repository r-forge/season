# Calculates the periodogram
'peri'<-function(data,adjmean=TRUE,plot=TRUE){
  op <- par(no.readonly = TRUE) # the whole list of settable par's.
  if(adjmean==TRUE) adjust<-mean(data) else adjust<-0
  n<-length(data)
  nfft<-(n/2)+1
  if (n%%2!=0) {data<-c(data,mean(data))} # taper odd length series with mean of data
  first<-fft(data-adjust)/(n/2) # Fast Fourier Transform
  realpart<-Re(first[1:nfft])
  imagpart<- -Im(first[1:nfft])
  peri<-(n/2)*(realpart^2+imagpart^2) # Periodogram
  f<-(0:(n/2))*pi*2/n # Frequencies in radians
  c<-pi*2/f # Frequencies in cycles
  c[1]<-NA
  amp<-sqrt(realpart^2+imagpart^2)
  phase<-vector(mode="numeric",length=nfft) # phase in scale [0,2pi]
# phase in [0,2pi]
  for (j in 2:(nfft-1)){
     ph<-atan(imagpart[j]/realpart[j])
     if (realpart[j]>=0) {phase[j]<-ph}
     if (realpart[j]<0&imagpart[j]>=0) {phase[j]<-ph+pi}
     if (realpart[j]<0&imagpart[j]<0) {phase[j]<-ph-pi}
# put in 0 to 2pi range
     if (phase[j]<0) { phase[j]<-phase[j]+(2*pi)} 
     if (phase[j]>(2*pi)) { phase[j]<-phase[j]-(2*pi)}
  }
## Plot
  if(plot==TRUE){
    par(mfrow=c(2,1))
    plot(f,peri,ylab='Periodogram',xlab='Frequency (radians)',type='h',xaxp=c(0,pi,4))
    plot(c[3:nfft],peri[3:nfft],ylab='Periodogram',xlab='Cycles',type='h')
  }
  return(list(peri=peri,f=f,c=c,amp=amp,phase=phase))
  par(op) # restore graphic settings
}
