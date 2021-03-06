<<<<<<< HEAD
library(randomForest)
library(ROCR)
require(Hmisc)

#Set working directory and filenames for Input/output
#setwd("/Users/ogriffit/git/biostar-tutorials/MachineLearning")
setwd("/Users/nspies/biostar-tutorials/MachineLearning")
RF_model_file="RF_model"
datafile="testset_gcrma.txt" #combined (standardCDF + customCDF)
clindatafile="testset_clindetails.txt"

outfile="testset_RFoutput.txt"
case_pred_outfile="testset_CasePredictions.txt"
ROC_pdffile="testset_ROC.pdf"
vote_dist_pdffile="testset_vote_dist.pdf"

#Read in data (expecting a tab-delimited file with header line and rownames)
data_import=read.table(datafile, header = TRUE, na.strings = "NA", sep="\t")
clin_data_import=read.table(clindatafile, header = TRUE, na.strings = "NA", sep="\t")

#NEED TO GET CLINICAL DATA IN SAME ORDER AS GCRMA DATA
clin_data_order=order(clin_data_import[,"geo_accn"])
clindata=clin_data_import[clin_data_order,]
data_order=order(colnames(data_import)[4:length(colnames(data_import))])+3 #Order data without first three columns, then add 3 to get correct index in original file
rawdata=data_import[,c(1:3,data_order)] #grab first three columns, and then remaining columns in order determined above
header=colnames(rawdata)

#Get predictor variables
predictor_data=t(rawdata[,4:length(header)])
predictor_names=as.vector((rawdata[,3])) #gene symbol + probe ids
colnames(predictor_data)=predictor_names

#Load RandomForests classifier from file (object "rf_output" which was saved previously)
load(file=RF_model_file)

#Run test data through forest
RF_predictions_responses=predict(rf_output, predictor_data, type="response")
#RF_predictions_probs=predict(rf_output, predictor_data, type="prob")
RF_predictions_votes=predict(rf_output, predictor_data, type="vote")

#Join predictions with clinical data
clindata_plusRF=cbind(clindata,RF_predictions_responses,RF_predictions_votes)

#Exclude rows with missing clinical data needed for subsequent steps
clindata_plusRF=clindata_plusRF[which(!is.na(clindata_plusRF[,"event.rfs"])),]

#write results to file
write.table(clindata_plusRF,file=case_pred_outfile, sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE)

#Determine performance statistics
confusion=table(clindata_plusRF[,c("event.rfs","RF_predictions_responses")])
rownames(confusion)=c("NoRelapse","Relapse")
sensitivity=(confusion[2,2]/(confusion[2,2]+confusion[2,1]))*100
specificity=(confusion[1,1]/(confusion[1,1]+confusion[1,2]))*100
overall_error=((confusion[1,2]+confusion[2,1])/sum(confusion))*100
overall_accuracy=((confusion[1,1]+confusion[2,2])/sum(confusion))*100
class1_error=confusion[1,2]/(confusion[1,1]+confusion[1,2])
class2_error=confusion[2,1]/(confusion[2,2]+confusion[2,1])

#Prepare stats for output to file
sens_out=paste("sensitivity=",sensitivity, sep="")
spec_out=paste("specificity=",specificity, sep="")
err_out=paste("overall error rate=",overall_error,sep="")
acc_out=paste("overall accuracy=",overall_accuracy,sep="")
misclass_1=paste(confusion[1,2], colnames(confusion)[1],"misclassified as", colnames(confusion)[2], sep=" ")
misclass_2=paste(confusion[2,1], colnames(confusion)[2],"misclassified as", colnames(confusion)[1], sep=" ")

#Prepare confusion table for writing to file
confusion_out=confusion[1:2,1:2]
confusion_out=cbind(rownames(confusion_out), confusion_out)

#Create ROC curve plot and calculate AUC
#Can use Relapse vote fractions fractions as predictive variable
=======
#Load necessary libraries
library(randomForest)
library(ROCR)
require(Hmisc)

#Set working directory and filenames for Input/output
setwd("/Users/ogriffit/git/biostar-tutorials/MachineLearning")
RF_model_file="RF_model"
datafile="testset_gcrma.txt"
clindatafile="testset_clindetails.txt"

outfile="testset_RFoutput.txt"
case_pred_outfile="testset_CasePredictions.txt"
ROC_pdffile="testset_ROC.pdf"
vote_dist_pdffile="testset_vote_dist.pdf"

#Read in data (expecting a tab-delimited file with header line and rownames)
data_import=read.table(datafile, header = TRUE, na.strings = "NA", sep="\t")
clin_data_import=read.table(clindatafile, header = TRUE, na.strings = "NA", sep="\t")

#NEED TO GET CLINICAL DATA IN SAME ORDER AS GCRMA DATA
clin_data_order=order(clin_data_import[,"geo_accn"])
clindata=clin_data_import[clin_data_order,]
data_order=order(colnames(data_import)[4:length(colnames(data_import))])+3 #Order data without first three columns, then add 3 to get correct index in original file
rawdata=data_import[,c(1:3,data_order)] #grab first three columns, and then remaining columns in order determined above
header=colnames(rawdata)

#Get predictor variables
predictor_data=t(rawdata[,4:length(header)])
predictor_names=as.vector((rawdata[,3])) #gene symbol
colnames(predictor_data)=predictor_names

#Load RandomForests classifier from file (object "rf_output" which was saved previously)
load(file=RF_model_file)

#Run test data through forest
RF_predictions_responses=predict(rf_output, predictor_data, type="response")
RF_predictions_votes=predict(rf_output, predictor_data, type="vote")

#Join predictions with clinical data
clindata_plusRF=cbind(clindata,RF_predictions_responses,RF_predictions_votes)

#Exclude rows with missing clinical data needed for subsequent steps
clindata_plusRF=clindata_plusRF[which(!is.na(clindata_plusRF[,"event.rfs"])),]

#write results to file
write.table(clindata_plusRF,file=case_pred_outfile, sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE)

#Determine performance statistics
confusion=table(clindata_plusRF[,c("event.rfs","RF_predictions_responses")])
rownames(confusion)=c("NoRelapse","Relapse")
sensitivity=(confusion[2,2]/(confusion[2,2]+confusion[2,1]))*100
specificity=(confusion[1,1]/(confusion[1,1]+confusion[1,2]))*100
overall_error=((confusion[1,2]+confusion[2,1])/sum(confusion))*100
overall_accuracy=((confusion[1,1]+confusion[2,2])/sum(confusion))*100
class1_error=confusion[1,2]/(confusion[1,1]+confusion[1,2])
class2_error=confusion[2,1]/(confusion[2,2]+confusion[2,1])

#Prepare stats for output to file
sens_out=paste("sensitivity=",sensitivity, sep="")
spec_out=paste("specificity=",specificity, sep="")
err_out=paste("overall error rate=",overall_error,sep="")
acc_out=paste("overall accuracy=",overall_accuracy,sep="")
misclass_1=paste(confusion[1,2], colnames(confusion)[1],"misclassified as", colnames(confusion)[2], sep=" ")
misclass_2=paste(confusion[2,1], colnames(confusion)[2],"misclassified as", colnames(confusion)[1], sep=" ")

#Prepare confusion table for writing to file
confusion_out=confusion[1:2,1:2]
confusion_out=cbind(rownames(confusion_out), confusion_out)

#Print results to file
write("confusion table", file=outfile)
write.table(confusion_out,file=outfile, sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE, append=TRUE)
write(c(sens_out,spec_out,acc_out,err_out,misclass_1,misclass_2,AUC_out), file=outfile, append=TRUE)

#Create ROC curve plot and calculate AUC
#Can use Relapse vote fractions fractions as predictive variable
>>>>>>> 5bd7c52fbf394c54d848092ca1abf0d5e4a82730
#The ROC curve will be generated by stepping up through different thresholds for calling Response vs NoResponse
target=clindata_plusRF[,"event.rfs"]
target[target==1]="Relapse"
target[target==0]="NoRelapse"
relapse_scores=clindata_plusRF[,"Relapse"]
<<<<<<< HEAD

pred=prediction(relapse_scores,target)
#First calculate the AUC value
perf_AUC=performance(pred,"auc")
AUC=perf_AUC@y.values[[1]]
AUC_out=paste("AUC=",AUC,sep="")
#Then, plot the actual ROC curve
perf_ROC=performance(pred,"tpr","fpr")
pdf(file=ROC_pdffile)
plot(perf_ROC, main="ROC plot")
text(0.5,0.5,paste("AUC = ",format(AUC, digits=5, scientific=FALSE)))
dev.off()

#Print results to file
write("confusion table", file=outfile)
write.table(confusion_out,file=outfile, sep="\t", quote=FALSE, col.names=TRUE, row.names=FALSE, append=TRUE)
write(c(sens_out,spec_out,acc_out,err_out,misclass_1,misclass_2,AUC_out), file=outfile, append=TRUE)



=======

pred=prediction(relapse_scores,target)
#First calculate the AUC value
perf_AUC=performance(pred,"auc")
AUC=perf_AUC@y.values[[1]]
AUC_out=paste("AUC=",AUC,sep="")
#Then, plot the actual ROC curve
perf_ROC=performance(pred,"tpr","fpr")
pdf(file=ROC_pdffile)
plot(perf_ROC, main="ROC plot")
text(0.5,0.5,paste("AUC = ",format(AUC, digits=5, scientific=FALSE)))
dev.off()




>>>>>>> 5bd7c52fbf394c54d848092ca1abf0d5e4a82730
