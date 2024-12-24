/*
 * source : https://forum.image.sc/t/export-qupath-annotations-for-stardist-training/37391/3
 * source : https://qupath.readthedocs.io/en/stable/docs/advanced/exporting_annotations.html#imagej-rois
 * source : https://groups.google.com/g/qupath-users/c/EOdNLyP7ixc
 * source : https://petebankhead.github.io/qupath/2019/08/21/scripting-in-v020.html
 */


/*
 * This is to import annotations as ROI directly into the project :
 *     - without any image name
 *     - all annotations
 */
 
import ij.plugin.frame.RoiManager

// get the name of the current image
def image_name = getProjectEntry().getImageName()
print(image_name + " treatment start") // adding some log info in order to know what's done during the process

// get specific classified annotations
def class_name_1 = getPathClass('glom')
def annotations = getAnnotationObjects()
def class_1_annotations = annotations.findAll {it.getPathClass() == class_name_1}

// define a specific folder to save the ROIs with the class name
def pathInput = buildFilePath(PROJECT_BASE_DIR) // for getting the QuPath project folder
def pathModel = pathInput + "/ROIs/" + image_name + "_" + class_name_1 + ".zip" // create the rest of the path : folder_name / image_name.zip


// roi manager creation for exporting annotations into
def roiMan = new RoiManager(false)
double x = 0
double y = 0
double downsample = 1 // Increase if you want to export to work at a lower resolution

// exporting annotations
// I need to put an if condition in case there's no annotations in the image
if (class_1_annotations.size() >0) {
    class_1_annotations.each {
        def roi = IJTools.convertToIJRoi(it.getROI(), x, y, downsample)
        roiMan.addRoi(roi)
    }
    roiMan.runCommand("Save", pathModel)
    print(class_1_annotations.size() + " " + class_name_1 + " annotations saved") // adding some log info in order to know what's done during the process
}
else {
    print("No " + class_name_1 + " annotations")
}

