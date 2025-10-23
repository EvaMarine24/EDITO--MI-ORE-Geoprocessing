#!/bin/bash
set -e  # Exit on any error

# Enable conda commands in this shell
source $INSTALL_DIR/etc/profile.d/conda.sh

### === Create and activate environment ===
echo "🧪 Creating conda environment 'geoprocessing'..."
conda create -y -n geoprocessing python=3.10.13
conda activate geoprocessing

# Install mamba
conda install -y -c conda-forge mamba

### === Install exact packages ===
echo "📦 Installing required packages..."
mamba install -y -c conda-forge \
  rasterio=1.3.7 \
  geopandas=0.14.1 \
  pandas=2.1.3 \
  xarray=2023.11.0 \
  proj=9.2.0 \
  pyproj=3.6.0 \
  numpy=1.26.0 \
  gdal=3.6.4 \
  s3fs \
  arcgis \
  ipykernel jupyter nbformat nbconvert s3fs cartopy

### === Register kernel for Jupyter ===
echo "🔗 Registering Jupyter kernel..."
python -m ipykernel install --user --name geoprocessing --display-name "Python (geoprocessing)"

### === Download notebook and helper script ===
echo "📥 Downloading notebook and script..."
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/GeoProcessing_EL.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/Image_to_Shapefile.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/Shapefile_Buffer.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/Feature_to%20Shapefile%20(1).ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/download_model.py
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/upload_model.py


### === Embed kernel metadata ===
echo "⚙️ Embedding kernel metadata into notebook..."
python - <<EOF
import nbformat

nb_path = "main.ipynb"
nb = nbformat.read(open(nb_path), as_version=nbformat.NO_CONVERT)

nb["metadata"]["kernelspec"] = {
    "name": "sfincs_vegetation",
    "display_name": "Python (sfincs_vegetation)",
    "language": "python"
}

nbformat.write(nb, open(nb_path, "w"))
EOF

### === Clear notebook output ===
echo "🧼 Clearing cell outputs..."
jupyter nbconvert --clear-output --inplace main.ipynb

echo "✅ Setup complete. You can now open main.ipynb and it will use the 'sfincs_vegetation' kernel by default."

### === Download input ===
# Make folder
mkdir -p input_dir
cd input_dir

# Base path to raw files on GitHub
BASE_URL="https://github.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/blob/main/data"

# List of files to download
FILES=(
  Cargo_Vessel_Density.shp
  Danger and Restricted areas that coincide with Marine or Coastal Areas only.shp
  Ferry_Routes_Buffer.shp
  Fishing_Vessel_Density.shp
  INFOMAR-150.shp
  Passenger_Vessel_Density.shp
  Shipwrecks_Buffer.shp
  Shipwrecks_Buffer.shp
  Special_Protected_Area.shp
)

# Download each file
for file in "${FILES[@]}"; do
  echo "Downloading $file..."
  wget -nc "$BASE_URL/$file"
done

cd ..