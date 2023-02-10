# Windows TPS

## TPS
Run folder `tps` directory as tests

1. Clone repo into WindowsTPS
2. Add installer into input folder
3. Run ./WindowsTPS/wrapper/run-tps-win-vagrant.sh
4. The results will be stored in jtr format aside the WindowsTPS in results folder

## Configuration 
Use RESULTS_FOLDER_NAME for the name of the folder where the results will be stored.
Use OTOOL_JDK_VERSION for defition of java version. The corresponding subset of tests will be used.
Use MSI_VENDOR for defining vender specific settings used for test run.
Use INPUT_FOLDER used for testing (including MSI)
Use CURRENT_USER_NAME for definiton of user under which the tests will run.