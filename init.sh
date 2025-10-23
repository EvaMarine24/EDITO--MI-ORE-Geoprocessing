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
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/GeoProcessing_EL.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/Image_to_Shapefile.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/Shapefile_Buffer.ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/Feature_to%20Shapefile%20(1).ipynb
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/download_model.py
wget -N https://raw.githubusercontent.com/EvaMarine24/EDITO--MI-ORE-Geoprocessing/refs/heads/main/upload_model.py
