/*
09 / 02 / 2024
Macro created by Nicolas GOUDIN - nicolas.goudin@inserm.fr
(Fiji is Just) ImageJ 2.14.0/1.54f; Java 1.8.0_172 [64 bits];
*/

/*
using this macro for publciation, DO NOT FORGET TO CITE :

ilastik: interactive machine learning for (bio)image analysis
Stuart Berg, Dominik Kutra, Thorben Kroeger, Christoph N. Straehle, Bernhard X. Kausler, Carsten Haubold, Martin Schiegg, Janez Ales, Thorsten Beier, Markus Rudy, Kemal Eren, Jaime I Cervantes, Buote Xu, Fynn Beuttenmueller, Adrian Wolny, Chong Zhang, Ullrich Koethe, Fred A. Hamprecht & Anna Kreshuk
in: Nature Methods, (2019)

Used of PT-BIOP plugin (EPFL BioImaging & Optics Core Facility) from FIJI
FIJI : Schindelin, J., Arganda-Carreras, I., Frise, E., Kaynig, V., Longair, M., Pietzsch, T., … Cardona, A. (2012). Fiji: an open-source platform for biological-image analysis.
Nature Methods, 9(7), 676–682. doi:10.1038/nmeth.2019
*/

/*
NEEDED Materials :

Before using this Macro you need to have done :
	- QuPath Annotations validated and exported
	- Ilastik Simple Segmentations exported
	- at least one annotation have been maid in each raw image list if not the image have to be excluded from the raw image list

Before using this Macro you need to have installed these plugins :
 
- to have installed the BIOP plugin 
		Help > Update > Manage update site > PT-BIOP

- to install ilastik plugin :
	- Help > Update > check the ilastik box and close
	- Restart FIJI
	- The Ilastik plugin is not in the alphabetic order it's and the end of the plugin list
	- You have then to select 
		Ilastik > configure ilsatik executable location 
		Select the ilastik.exe into it's folder installation
*/

///////////////////////////////////////////////////////////////////////
////////	Variables	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// From https://www.biodip.de/w/images/0/00/ImageJ_macro_cheatsheet.pdf
// Input files
#@ String(value="Folders location", visibility="MESSAGE") hints_1
#@ File (label = "Raw image", style = "directory") raw_folder
#@ File (style = "ilastik project to use for pixel classification") ilastik_project
#@ File (label = "ROI folder from QuPath project directory", style = "directory") QuPath_roi_folder
#@ File (label = "Save directory", style = "directory") save_folder
// macro parameters
#@ String(value="Macro parameters", visibility="MESSAGE") hints_2
#@ Integer(label="Enter the channel you wan to analyse", value=1) chan_to_analyzed
#@ String(label="Add the 2 QuPath class name you've put (seperate them with , without space)", description="example : glom,tubul") roi_suffix
#@ Integer(label="glomerul border size (pixels)", value=7) border_width

file_list=getFileList(raw_folder);

// path
QuPath_roi_folder_path = QuPath_roi_folder + File.separator;
save_path = save_folder + File.separator;

// array creation by using the split FIJI function (see FIJI autocompletion for more info)
class_array = split(roi_suffix, ",");
Array.show(class_array);

// determine size of an array
number_of_elements = lengthOf(class_array);

// creating a step folder into the results folder
File.makeDirectory(save_folder + File.separator + "Macros_steps");
// step folder path is : 
steps_directory = save_folder + File.separator + "Macros_steps" + File.separator;

// renaming
rename_raw = "raw";
rename_chan_of_interest = "chan_of_interest";
rename_ilastik = "ilastik";
rename_label_maps = "Label_maps";

// other variables
label_of_interest = 1; // ilastik label used for the signal of interest (label1 = 1 Label2 = 2, etc)
run("Set Measurements...", "area mean redirect=None decimal=3");

///////////////////////////////////////////////////////////////////////
////////	code	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// clearing the space and the log windows
print("\\Clear"); // clear the log windows before starting the macro
clearing_the_space(); // f1
delete_existing_roi(); // f2

// log info of macro parameters and save it
Log_info(); // f3
saveAs("Text", save_folder + File.separator + "Macro_settings.txt");

// loop for all files treatment
for(i = 0; i < file_list.length; i = i+1){ 
	// opening raw
	raw_path = raw_folder + File.separator + file_list[i];
	opening_image (raw_path); // f3
	//image info
	raw_name = File.getName(raw_path);
	raw_name_without_extention = File.getNameWithoutExtension(raw_path);
	getVoxelSize(width, height, depth, unit);
	pix_width = width;
	getDimensions(width, height, channels, slices, frames);
	// rename to facilitate analysis
	rename(rename_raw);
	/* Note :
	 * I need to pass my image in pixel to be equal to the pixxel value of the ilastik mask 
	 * if I don't do this appriximate results will make the part starting  L 207 false due to imprecision
	 */
	run("Properties...", "channels="+ channels +" slices="+ slices +" frames="+ frames +" pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	
	
	// opening ilastik chan and creating ilastik mask
	duplicate_image(rename_raw, rename_chan_of_interest, chan_to_analyzed); // f5
	ilastik_segmentation (ilastik_project, rename_chan_of_interest); // f6
	rename(rename_ilastik);
	
	// creatig array for results
	array_class_name = newArray(0);
	array_intensity_mean_border = newArray(0);
	array_intensity_mean_inside = newArray(0);
	array_chan_area_border = newArray(0);
	array_full_area_border = newArray(0);
	array_chan_area_inside = newArray(0);	
	array_full_area_inside = newArray(0);
	// array temp for concatenation
	class_temp = newArray(1);
	area_temp = newArray(1);
	intentisty_temp = newArray(1);
	
	// opening ROIs if they exist >> I'll try to do all the analysis if they exist and at the end check which ave been done
	for (j = 0; j < number_of_elements; j++) {
		ROI_name = QuPath_roi_folder_path + raw_name + "_" + class_array[j] + ".zip";
		rename_ilastik_mask_border = "border_" + class_array[j];
		rename_ilastik_mask_inside = "inside_" + class_array[j];
		
		// if ROI exist then do the analysis
		if (File.exists(ROI_name) == true) {
			// create new image for border and for inside chan measurment
			newImage(rename_ilastik_mask_border, unit + " black", width, height, depth);
			newImage(rename_ilastik_mask_inside, unit + " black", width, height, depth);
			// opening and counting ROIs
			roiManager("Open", ROI_name);
			number_of_roi = roiManager("count");
			
			// make measurments			
			for (k = 0; k < number_of_roi; k++) {
				class_temp[0] = class_array[j];
				array_class_name = Array.concat(array_class_name, class_temp);
				
				// inside measurments
				duplicate_image(rename_ilastik, "temp", 1);
				//// inside creation and measurment
				roiManager("Select", k);
				run("Enlarge...", "enlarge=-" + border_width + " pixel");
				roiManager("Update"); // need this update part : if not It does not apply the roi transformation
				roiManager("measure");
				area_temp[0] = getResult("Area", 0);
				array_full_area_inside = Array.concat(array_full_area_inside, area_temp);
				run("Clear Results");
				//// creating the inside roi of ilastik mask
				clear_ourside(); // f7
				create_selection_and_measure(); // f8
				//// drowing inside mask measured as labelmap
				create_label (rename_ilastik_mask_inside, k+1); // f9
				//// adding result to the final result array using concatenation
				area_temp[0] = getResult("Area", 0);
				array_chan_area_inside = Array.concat(array_chan_area_inside, area_temp);
				intentisty_temp[0] = getResult("Mean", 0);
				array_intensity_mean_inside = Array.concat(array_intensity_mean_inside, intentisty_temp);
				run("Clear Results");
				close("temp");
				
				// border measurment
				duplicate_image(rename_ilastik, "temp", 1);
				//// border creation and measurment
				roiManager("Select", k);
				run("Make Band...", "band=" + border_width); // as I have update the ROI I work now on a reduced ROI I can directly make the band
				roiManager("Update"); // need this update part : if not It does not apply the roi transformation
				roiManager("measure");
				area_temp[0] = getResult("Area", 0);
				array_full_area_border = Array.concat(array_full_area_border, area_temp);
				run("Clear Results");
				//// creating the inside roi of ilastik mask
				clear_ourside(); // f7
				create_selection_and_measure(); // f8
				//// drowing border mask measured as labelmap
				create_label (rename_ilastik_mask_border, k+1); // f9
				//// adding result to the final result array using concatenation
				area_temp[0] = getResult("Area", 0);
				array_chan_area_border = Array.concat(array_chan_area_border, area_temp);
				intentisty_temp[0] = getResult("Mean", 0);
				array_intensity_mean_border = Array.concat(array_intensity_mean_border, intentisty_temp);
				run("Clear Results");
				close("temp");
			}
		}	
		// deleting existing roi for next loop
		delete_existing_roi();
	}
	/* Notes :
	 * If there's no area to detect with the mask this script take the full area 
	 * 	so when full area = mask area there's no area
	 * 	but intensity of no mask area can't be = to 0 as it can be a value : so when there's no area I keep the mean of the full as it give me the background value
	 * 	Last I need to convert every pixels area corrected if necessary into µm²
	 */
	pixel_area = pix_width*pix_width; // need for measurments
	for (L = 0; L < array_class_name.length; L++) {
		// border check
		if (array_full_area_border[L] == array_chan_area_border[L]) {
			array_chan_area_border[L] = 0;
		}
		// inside check
		if(array_full_area_inside[L] == array_chan_area_inside[L]) {
			array_chan_area_inside[L] = 0;
		}
		// converting all area in pixel into µm²
		array_full_area_border[L] = array_full_area_border[L]*pixel_area;
		array_chan_area_border[L] = array_chan_area_border[L]*pixel_area;
		array_full_area_inside[L] = array_full_area_inside[L]*pixel_area;
		array_chan_area_inside[L] = array_chan_area_inside[L]*pixel_area;
	}
	// show array and save it
	Array.show("class_results", array_class_name, array_full_area_border, array_chan_area_border, array_intensity_mean_border, array_full_area_inside , array_chan_area_inside, array_intensity_mean_inside);
	saveAs("Results", save_path + raw_name_without_extention + ".csv");
	
	// saving all masks
	close(rename_raw);
	close(rename_chan_of_interest);
	// ilastik mask
	save_image (rename_ilastik, "Tiff", steps_directory + raw_name_without_extention + "_ilastik.tif" ) ; // f10
	// gloms and / or tubul label maps
	run("Concatenate...", "all_open title=" + rename_label_maps + " open"); 
	save_image (rename_label_maps, "Tiff", steps_directory + raw_name_without_extention + "_label_map.tif" ) ; // f10
}

///////////////////////////////////////////////////////////////////////
////////	functions	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// f1
function delete_existing_roi() {
	//print("hey I'm function 0-C");
	existing_roi = roiManager("count");
	if (existing_roi>0) {
		roiManager("deselect");
		roiManager("delete");
	}
}

// f2
function clearing_the_space () {
	run("Close All");
	run("Clear Results");
}

// f3
function Log_info() { 
	print("---- Paths ----");
	print("Raw folder path : " + raw_folder);
	print("QuPath ROIs folder path : " + QuPath_roi_folder);
	print("\n---- Macro parameters ----");
	for (i = 0; i < number_of_elements; i++) {
		print("QuPath ROI class n°" + i+1 + " = " + class_array[i]);
	}
	print("Glomeruly inner border width  = " + border_width);
	print("Channel of interest = " + chan_to_analyzed );
	selectWindow("Log");
}

// f4
function opening_image (input) {
	run("Bio-Formats Importer", "open=[" + input + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
}

// f5
function duplicate_image(input, title, channel_to_extract) {
	selectImage(input);
	run("Select None");
	run("Duplicate...", "title="+ title +" duplicate channels="+ channel_to_extract);
}

// f6
function ilastik_segmentation (input_project, input_image) {
	run("Run Pixel Classification Prediction", "projectfilename=[" + input_project + "] inputimage=" + input_image + " pixelclassificationtype=Segmentation");
}

// f7
function clear_ourside() {
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
}

// f8
function create_selection_and_measure() {
	setThreshold(label_of_interest, label_of_interest, "raw");
	run("Create Selection");
	selectImage(rename_chan_of_interest);
	run("Restore Selection");
	run("Measure");
}

// f9
function create_label (input_image, label_value) {
	selectWindow(input_image);
	run("Restore Selection");
	run("Set...", "value=" + label_value);
}

// f10
function save_image (input_image, format, path) {
	selectWindow(input_image);
	saveAs(format, path);
	close();
}
