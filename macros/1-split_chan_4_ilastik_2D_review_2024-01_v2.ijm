/*
16 / 01 / 2024
Macro created by Nicolas GOUDIN - nicolas.goudin@inserm.fr
(Fiji is Just) ImageJ 2.14.0/1.54f; Java 1.8.0_172 [64 bits];
*/

///////////////////////////////////////////////////////////////////////
////////	Variables	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// creation of a windows dialog for image source folder and treated image save folder
// From https://www.biodip.de/w/images/0/00/ImageJ_macro_cheatsheet.pdf
#@ File (label = "Raw datas directory", style = "directory") raw_folder 
#@ File (label = "Save directory", style = "directory") save_folder
#@ String(label="Image format (.czi, .lif, .lsm, .nd2 ,...",description="put the format ith the point before as .czi for exemple") image_format
#@ String(label="if needed : Z Projection type",choices={"Average Intensity","Max Intensity","Min Intensity","Sum Slices","Standard Deviation","Median"},style="list") projection_type

// path and file liste creation
fileList=getFileList(raw_folder);
raw_path = raw_folder+File.separator;

// List of selected image type Creation and getting the max channels value (put here as it's a vairiable)
setBatchMode (true);

// creating the specified image format list using Table fonction of FIJI
table_good_image_list = "Good image list";
Table.create(table_good_image_list);
k = 0;
for(i = 0; i < fileList.length; i = i+1){ 
	path = raw_path + fileList[i];
	good_image_format = endsWith(path, image_format);
	if (good_image_format==1) {
		Table.set("image name", k, File.getName(path));	
	k = k + 1;
	}
}
// getting the max channels number of the selected image list
good_image_number = Table.size;
array_chan_number = newArray(good_image_number);
for(i = 0; i < good_image_number ; i = i+1){ 
	path = raw_path + Table.getString("image name", i);
	opening_virtual_image(path); //f2
	getDimensions(width, height, channels, slices, frames);
	array_chan_number[i] = channels;
}	
// creation of the results array of chan value of all images of the list and getting the max value
Array.show("Results", array_chan_number);
run("Summarize");
max_chan_number = getResult("Value", good_image_number + 3);
run("Clear Results");

// renaming
rename_projection  = "proj_img";
rename_raw = "img";


///////////////////////////////////////////////////////////////////////
////////	code	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// log windows indication for following what the macro do
print("\\Clear"); // clearing the log windows
clearing_the_space(); //f0
Log_info("The macro start working"); //f1

// folder creation using the mac channels number measured
folder_creation(max_chan_number); //f4

// loop creation for opening image getting its umber of chan split them and save each in its own folder
for(i = 0; i < good_image_number ; i = i+1) { 
	
	// opening image
	path = raw_path + Table.getString("image name", i);
	opening_image(path); //f3
	name = File.getNameWithoutExtension(path);
	getDimensions(width, height, channels, slices, frames);
	
	// if it's a z stack or not
	if (slices >1) {
		run("Z Project...", "projection=["+ projection_type +"]");
		rename(rename_projection);
		// spliting the source image and saving each chan in its specific folder
		image_split_and_save(raw_proj_rename); //f5
		run("Close All");	
	}
	else {
		rename(rename_raw);
		image_split_and_save(rename_raw); //f5
		run("Close All");	
	}

	// log windows indication for following what the macro do
	Log_info("Image "+i+1+" / "+fileList.length+" treated"); //f1
}

// log windows indication for following what the macro do
Log_info("Macro finished"); //f1
	
///////////////////////////////////////////////////////////////////////
////////	functions	////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// f0
function clearing_the_space () {
	//print("hey I'm function 0");
	run("Close All");
	run("Clear Results");
}

// f1
function Log_info(input_text) { 
	print(input_text);
	print("------------");
}


// f2
function opening_virtual_image(input_path) {
	//print("hey I'm function 1-A");
	run("Bio-Formats Importer", "open=["+input_path+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT use_virtual_stack");
}

// f3
function opening_image(input_path) {
	// print("hey I'm function 1-B");
	good_image_format = endsWith(input_path, image_format);
	if (good_image_format==1) {
		run("Bio-Formats Importer", "open=["+input_path+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	}
}

// f4
function folder_creation(number_of_channels) {
	//print("hey I'm function 3");
	for(n = 1; n < number_of_channels+1; n = n+1)	{ 
		NewFold=File.makeDirectory(save_folder+File.separator+"C"+n);
	}
}

// f5
function image_split_and_save(input_image) {
	//print("hey I'm function 4");
	selectWindow(input_image);
	run("Split Channels");
	for(i = 1; i < channels+1; i = i+1) { 
		selectWindow("C" + i + "-" + input_image);
		NewPathsave=save_folder+File.separator+"C"+i+File.separator;
		saveAs("Tiff", NewPathsave + "C" + i + "_" + name);
	}
}