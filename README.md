# BMQuant - A FIJI Macro to Quantify Basement Membrane Protein

BMQuant is a FIJI macro and a framework for basement membrane protein quantification in organoid samples.

## Steps to Use This Macro

1. **Object Segmentation**: Use QuPath to annotate and segment the objects for quantification (e.g., Gloms and tubules).
2. **Export Annotations**: Export the region of interest (ROI) using the provided script.
3. **Pixel Classification**: Use Ilastik software to perform pixel classification on the channel of interest with a machine learning model.
4. **Measurement**: Use the Fiji macro to measure the mean fluorescent intensity in the basement membrane and inside the objects by calculating the area.

We developed this macro to quantify collagen a5(IV) mean intensity in the basement membranes of our X-linked Alport syndrome (XLAS) kidney organoid model from male iPSCs after antisense oligonucleotide treatment.

## Usage

### Getting Started

1. **Install QuPath Software**: [Download QuPath](https://qupath.github.io/) for object annotation and ROI extraction (available for macOS, Windows, and Linux OS).
2. **Install FIJI**: [Download FIJI](https://imagej.net/software/fiji/downloads), a powerful and free image analysis tool.
3. **Install Ilastik Software**: [Download Ilastik](https://www.ilastik.org/download) for pixel classification.
4. **Create Conda Environment**:

    ```bash
    conda env create -f samapi_env.yml
    conda activate samapi
    ```

### Using SAM API for Automated Border Detection

1. **Create Conda Environment**:
    ```bash
    conda create -n samapi -y python=3.10
    conda activate samapi
    ```

2. **Install CUDA Toolkit (if using a CUDA-compatible GPU)**:
    ```bash
    conda install -c conda-forge -y cudatoolkit=11.8
    ```

3. **Install Torch with GPU Support (if using a CUDA-compatible GPU on Windows)**:
    ```bash
    python -m pip install "torch>=2.3.1,<2.4" torchvision --index-url https://download.pytorch.org/whl/cu118
    ```

4. **Install SAM API and Dependencies**:
    ```bash
    python -m pip install git+https://github.com/ksugar/samapi.git
    ```

5. **Update `LD_LIBRARY_PATH` (if using WSL2)**:
    ```bash
    export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH
    ```

6. **Start the SAM API Server**:
    ```bash
    export PYTORCH_ENABLE_MPS_FALLBACK=1 # Required for running on Apple silicon
    uvicorn samapi.main:app --workers 2
    ```

    The command will launch a server at [http://localhost:8000](http://localhost:8000).
    ```bash
    INFO:     Started server process [21258]
    INFO:     Waiting for application startup.
    INFO:     Application startup complete.
    INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
    ```

## License

This pipeline is distributed under the MIT license. You can review the full license agreement in the license tab.

For non-commercial use, this product is available for free.

## Contacts

This macro is designed in collaboration with Nicolas Gaudin. For more information and help, you can write to:

- Nicolas Gaudin: nicolas.gaudin@inserm.fr
- Hassan Saei: hassan.saeiahan@gmail.com

## Citations

(Soon to be updated...)