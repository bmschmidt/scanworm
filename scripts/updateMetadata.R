pageNumbers = function(dir = "/home/bschmidt/Printers/texts") {
  #must specify an absolute dir here, not a relative (tilde) one.
  files = list.files(dir,recursive=T,full.names=T)
  length(files)  
  require(plyr)
  firstlines = ldply(files,function(file) {
    words = scan(file,nlines=1,what='raw',quiet=T)
    words = words[grep("^\\d+$",words)]
    words = as.numeric(words)
    if(length(words)>0) {
    data.frame(file=as.character(file),word=words)}
  },.progress="text")
  
  output = data.frame(filename=gsub(paste0(dir,"/"),"",files))
  output$volume = as.numeric(gsub("^([0-9\\.]+)/.*","\\1",output$filename))
  output$page = as.numeric(gsub(".*/(\\d+).txt","\\1",output$filename))
  
  firstlines$volume = as.numeric(gsub(".*/([0-9\\.]+)/.*","\\1",firstlines$file))
  firstlines$page = as.numeric(gsub(".*/(\\d+).txt","\\1",firstlines$file))

  firstlines$impliedStart = firstlines$page-firstlines$word
  firstlines = firstlines[firstlines$impliedStart > 0 & firstlines$word < 300,]
summary(output$volume)
  output=output[!is.na(output$volume),]
  ggplot(firstlines[firstlines$volume==sample(firstlines$volume,1),]) + geom_point(aes(y=page,x=impliedStart))
  firstlines$
  volumePages = ddply(firstlines,.(volume),function(volume) {
    pagesInVolume=max(
      output$page[output$volume==volume$volume[1]],na.rm=T
    )
    require(MASS)
    starts = table(volume$impliedStart)
    starts = starts[starts > 5]
    volume = volume[volume$impliedStart %in% names(starts),]
    volume$start = factor(volume$impliedStart)
    predictions = predict(rpart(start~page,volume),
                          newdata=data.frame(
                            page=1:pagesInVolume))
    data.frame(
      page=1:pagesInVolume,issuepage = 1:pagesInVolume-as.numeric(apply(predictions,1,function(row) {colnames(predictions)[which(row==max(row))[1]]})))
    })
  
  output=merge(volumePages,output)
  output$filename = as.character(output$filename)
  require(rjson)
  cat("",file="/tmp/jsoncatalog.txt")
  d_ply(output,.(volume,page), function(row) {
    row$searchstring=paste0("Volume ",row$volume,", page ",row$page,
                            " <a href=images/",gsub("txt","tif",row$filename),">View page</a>")
    cat(file="/tmp/jsoncatalog.txt",toJSON(row),append=T)
    cat(file="/tmp/jsoncatalog.txt","\n",append=T)
  })
  
}


pageNumbers()