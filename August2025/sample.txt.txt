@echo off
REM Batch script to create Data Science Project folder structure

:: Root folder
set PROJECT=data_science_project

:: Create main project folder
mkdir %PROJECT%

:: Create subfolders
mkdir %PROJECT%\data
mkdir %PROJECT%\data\raw
mkdir %PROJECT%\data\interim
mkdir %PROJECT%\data\processed

mkdir %PROJECT%\notebooks

mkdir %PROJECT%\src

mkdir %PROJECT%\models

mkdir %PROJECT%\reports
mkdir %PROJECT%\reports\figures

mkdir %PROJECT%\tests

:: Create placeholder files
echo # Project overview > %PROJECT%\README.md
echo requirements > %PROJECT%\requirements.txt
echo config: > %PROJECT%\config.yaml
echo from setuptools import setup, find_packages > %PROJECT%\setup.py

:: Create Python source files
type nul > %PROJECT%\src\__init__.py
type nul > %PROJECT%\src\data_preprocessing.py
type nul > %PROJECT%\src\feature_engineering.py
type nul > %PROJECT%\src\model_training.py
type nul > %PROJECT%\src\evaluation.py
type nul > %PROJECT%\src\utils.py

:: Create test files
type nul > %PROJECT%\tests\test_data_preprocessing.py
type nul > %PROJECT%\tests\test_model_training.py

:: Create notebook placeholders
type nul > %PROJECT%\notebooks\EDA.ipynb
type nul > %PROJECT%\notebooks\FeatureEngineering.ipynb
type nul > %PROJECT%\notebooks\ModelTraining.ipynb

:: Create report placeholder
type nul > %PROJECT%\reports\model_report.pdf

echo Folder structure created successfully!
pause
