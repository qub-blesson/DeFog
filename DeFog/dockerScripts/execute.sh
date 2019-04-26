#!/bin/bash
source /mnt/configs/config.sh

#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: execute.sh
#
# Purpose: This script is passed into the Dockerfile during the build process initialised by the build.sh script.
#			This component is supplied the application and pipeline ID to determine the functions invoked. The config
#			file is sourced to allow for communication with the Cloud during the Cloud-Edge pipeline. This script
#			executes a computational task for the specified fog application, calculates several metrics and then
#			uploads the results to an S3 bucket and back to the user device.
#
#########################################################################################################################
	
cloudaddress1="${cloudaddress/$'\r'/}"
clouduser1="${clouduser/$'\r'/}"
edgeawskey1="${edgeawskey/$'\r'/}"

cloudaddress2="${cloudaddress1/$'\n'/}"
clouduser2="${clouduser1/$'\n'/}"
edgeawskey2="${edgeawskey1/$'\n'/}"

new_address1="${foglampaddress/$'\r'/}"
new_address2="${new_address1/$'\n'/}"

chmod 400 /mnt/configs/csc4006awskey.pem

# This is the execute script that is similar between all applications, this allows unique scripts to be run for each specific 
# application to gain the respective benchmark metrics.

# Above references the source location - i.e the config file's location and sets the relevant values, parsing out escape characters.

# Remove the results files, handle the warning message that appears if the files don't exist
function remove_files_before_start {
	# remove result files
	rm /mnt/results/cloudresult.txt 2>/dev/null
	rm /mnt/results/arrresult.txt 2>/dev/null
}

# utility function to navigate to the application and grant access to the necessary files in this path
function navigate_to_application {
	cd $pathToApplication

	chmod 777 $access1
	chmod 777 $access2
}

# create the metric value array with default values to be populated as benchmarks are computed
function initiate_metric_array {
	# instantiate metricsValues
	metricsValues=('NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA' 'NA')
}

# Stop the FogLamp root application
function stop_foglamp {
	scripts/foglamp stop
}

# Execute the foglamp command to interact with FogLamps API, and save the output to the predictions file
function execute_foglamp {
	. foglampcurlcommand.sh $new_address2 >> $predictions
}

# Start the FogLamp root application
function start_foglamp {
	scripts/foglamp start
}

# Determine what application is to be run and handle any necessary set up on the cloud for the Cloud/Edge pipeline
function which_program_cloud_split_pipeline {

	if [ "$application" == 0 ] # YOLO
	then
	
		rm /mnt/assets/yolov3-tiny.weights 2>/dev/null
		cd ~/YOLO/bothcloudyolo
		mv ./yolov3-tiny.weights /mnt/assets/

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		rm -rf /mnt/assets/en-us 2>/dev/null
		cd ~/PocketSphinx/bothcloudpsphinx
		mv ./en-us /mnt/assets/

	elif [ "$application" == 2 ] # Aeneas
	then
		rm -rf /mnt/assets/aeneas-assets/ 2>/dev/null
		cd ~/Aeneas/bothcloudaeneas
		mv ./aeneas-assets/ /mnt/assets/
	fi
}

# Determine what application is to be run and handle any necessary set up on the edge for the Cloud/Edge pipeline
function which_program_edge_split_pipeline {
	access1="" # if a file needs access add it here
	access2=""
	
	if [ "$application" == 0 ] # YOLO
	then
		access1=darknet
		access2=s3Upload.py
		
		predictions=predictions.png
		returned_predictions=./returnedasset.png
		
		pathToApplication=~/YOLO/yolo
		
		executeApplication="./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg"

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=result.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/PocketSphinx/sphinxbase/
		export LD_LIBRARY_PATH=/usr/local/lib
		
		pathToApplication=~/PocketSphinx/sphinxbase/pocketsphinx/
		
		executeApplication="pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null"
		
	elif [ "$application" == 2 ] # Aeneas
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=map.smil
		returned_predictions=./returnedasset.smil
		
		cd ~/Aeneas/aeneas
		export PYTHONIOENCODING=UTF-8 # necessary to ensure the correct encoding standard is used
		
		pathToApplication=~/Aeneas/aeneas
		
		file=$( cat /mnt/assets/aeneas.txt )
		new_file="${file%%.*}"
		
		local conf="task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"
		executeApplication="python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     $new_file.xhtml     ${conf}     map.smil"
	fi
}

# Determine what application is to be run and handle any necessary set up on the Cloud or Edge only pipelines
function which_program_only_pipelines {
	access1=""
	access2=""
	
	if [ "$application" == 0 ] # YOLO
	then
		access1=darknet
		access2=s3Upload.py
		
		predictions=predictions.png
		returned_predictions=./returnedasset.png
		
		pathToApplication=~/YOLO/yolo
		
		executeApplication="./darknet detect cfg/yolov3-tiny.cfg yolov3-tiny.weights /mnt/assets/yoloimage.jpg"

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=result.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/PocketSphinx/sphinxbase/
		export LD_LIBRARY_PATH=/usr/local/lib
		
		pathToApplication=~/PocketSphinx/sphinxbase/pocketsphinx/
		
		executeApplication="pocketsphinx_continuous -infile /mnt/assets/psphinx.wav -logfn /dev/null"
		
	elif [ "$application" == 2 ] # Aeneas
	then
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=map.smil
		returned_predictions=./returnedasset.smil
		
		cd ~/Aeneas/aeneas
		export PYTHONIOENCODING=UTF-8 # ensure correct encoding standards are used
		
		pathToApplication=~/Aeneas/aeneas
		
		local conf="task_language=eng|os_task_file_format=smil|os_task_file_smil_audio_ref=audio.mp3|os_task_file_smil_page_ref=page.xhtml|is_text_type=unparsed|is_text_unparsed_id_regex=f[0-9]+|is_text_unparsed_id_sort=numeric"
		executeApplication="python -m aeneas.tools.execute_task     /mnt/assets/aeneasaudio.mp3     /mnt/assets/aeneastext.xhtml     ${conf}     map.smil"
	
	elif [ "$application" == 3 ] # FogLamp
	then
	
		access1=s3Download.py
		access2=s3Upload.py
	
		predictions=foglampoutput.txt
		returned_predictions=./returnedasset.txt
		
		cd ~/FogLAMP
		export FOGLAMP_ROOT=/root/FogLAMP
		cp /mnt/assets/foglampcurlcommand.sh .

		pathToApplication=~/FogLAMP
						
	fi
}

# execute data transfer between the cloud and the edege
function execute_cloud_to_edge_transfer {

	start=$(date +%s.%N) # start the time
	
	# execute the task
	if [ "$application" == 0 ] # YOLO
	then
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/defog/assets/yolov3-tiny.weights ./ 2>&1 | grep "Transferred") 		

	elif [ "$application" == 1 ] # Pocket Sphinx
	then
		
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/defog/assets/en-us/* ./model/en-us/ 2>&1 | grep "Transferred") 		

	elif [ "$application" == 2 ] # Aeneas
	then
	
		transfer_cloud=$(scp -v -o StrictHostKeyChecking=no -i $edgeawskey2 $clouduser2@$cloudaddress2:/home/ubuntu/defog/assets/aeneas-assets/text/$new_file.xhtml ./ 2>&1 | grep "Transferred")
		
	fi
	
	# handle the escape characters and character returns from the returned verbose data
	nocarriagereturns=${transfer_cloud//[!0-9\\ \\.]/}
	newarr1=(`echo ${nocarriagereturns}`);
	
	end=$(date +%s.%N) # stop the timer
	runtime=$( echo "$end - $start" | bc -l ) # calculate the time difference
	
	echo -e "Cloud to Edge Transfer: completed in $runtime secs" | tee -a results.txt
	metricsValues[9]=${newarr1[1]}
	metricsValues[13]=$runtime
	
}

# execute the compute task, gather the relevant time metrics
function execute_program_only {
	# capture the time taken for computation
	start=$(date +%s.%N)

	if [ "$application" == 3 ]; then execute_foglamp # if foglamp then execute and save to file
	else $executeApplication # else execute the application as normal
	fi
	
	end=$(date +%s.%N)
	
	runtime=$( echo "$end - $start" | bc -l )
	echo -e
	echo -e "Computation: completed in $runtime secs" | tee -a results.txt
	
	# set execution time metric
	metricsValues[1]=$runtime
}

# upload the relevant data to the S3 bucket and capture the necessary metrics
function upload_to_s3 {
	echo -e
	echo -e "Starting Upload to S3 Bucket..."
	# capture time it takes to transfer to the S3 bucket
	start=$(date +%s.%N)
	python s3Upload.py $predictions $predictions
	end=$(date +%s.%N)
	
	runtime=$( echo "$end - $start" | bc -l )
	echo "Upload to S3 bucket: completed in $runtime secs" | tee -a results.txt

	# set upload time metric
	metricsValues[2]=$runtime
}

# calculate the real time factor for audio applications using the ffprobe package
function calc_rtf {
	length=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 /mnt/assets/psphinx.wav)
	metricsValues[5]=$length
}

# save the metrics array and prediction data to the necessary results files
function save_to_files {
	# save data to the results file(s) and move results/data to relevant folder
	cat results.txt >> /mnt/results/cloudresult.txt
	echo ${metricsValues[@]} >> /mnt/results/arrresult.txt

	cp $predictions $returned_predictions
	mv $returned_predictions /mnt/results/
}

# set the input application
function set_application {
	application=$1
}

# set the input pipeline
function set_pipeline {
	pipeline=$1
}

# execute the pipeline for Cloud/Edge - Cloud portion
function execute_cloud_split_pipeline {	
	
	which_program_cloud_split_pipeline
	
}

# execute the pipeline for Cloud/Edge - Edge portion
function execute_edge_split_pipeline {	
	
	remove_files_before_start # remove files
	
	which_program_edge_split_pipeline # determine what setup is needed
	navigate_to_application 
	initiate_metric_array
	
	execute_cloud_to_edge_transfer
	
	execute_program_only
	
	if [ "$application" == 1 ]; # Pocket Sphinx
	then
		calc_rtf
	fi
	
	upload_to_s3
	save_to_files
}

# execute the pipeline for Cloud or Edge only

function execute_only_pipelines {	
	remove_files_before_start # remove files
	
	which_program_only_pipelines # determine setup
	navigate_to_application
	initiate_metric_array
	
	if [ "$application" == 3 ]; # FogLamp
	then
		start_foglamp
		echo -e Starting FogLamp
	fi
	
	execute_program_only
	
	if [ "$application" == 3 ]; # FogLamp
	then
		stop_foglamp
		echo -e Stopping FogLamp

	fi
	
	if [ "$application" == 1 ]; # Pocket Sphinx
	then
		calc_rtf
	fi
	
	upload_to_s3
	save_to_files
}

# invoke input methods
set_application $1 # 0 = Yolo, 1 = PocketSphinx, 2 = Aeneas, 3 = FogLamp
set_pipeline $2 # 0 = Cloud or Edge Only, 1 = Cloud/Edge - Cloud, 2 = Cloud/Edge - Edge

# invoke the necessary pipeline
if [ "$pipeline" == 0 ]; # Cloud or Edge Only
then
	execute_only_pipelines
elif [ "$pipeline" == 1 ]; # Cloud Split
then
	execute_cloud_split_pipeline	
elif [ "$pipeline" == 2 ]; # Edge Split
then
	execute_edge_split_pipeline
fi

while getopts :yljp:bcez: opt; do
    case "$opt" in
        y)
            application=0
            ;;	
		l)
            application=3
            ;;
		j)
			application=2
            ;;
        p)
			application=1          
            ;;
		b)
            pipeline=2
            ;;	
		c)
            pipeline=0
            ;;
		z)
			pipeline=1
            ;;
        e)
			pipeline=0          
            ;;	
    esac
done

exit
