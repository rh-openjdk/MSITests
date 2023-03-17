# Windows TPS

## TPS
Run folder `tps` directory as tests

1. Clone repo into WindowsTPS
2. Add installer into input folder
3. Run ./WindowsTPS/wrapper/run-tps-win-vagrant.sh
4. The results will be stored in jtr format aside the WindowsTPS in results folder

## Configuration 

### RESULTS_FOLDER
Use RESULTS_FOLDER for the name of the folder where the results will be stored.  
Default: results

### OTOOL_JDK_VERSION
Use OTOOL_JDK_VERSION for defition of java version. The corresponding subset of tests will be used.

### MSI_VENDOR
Use MSI_VENDOR for defining vender specific settings used for test run. (Adoptium or RH)  
Default: RH

### INPUT_FOLDER
Use INPUT_FOLDER used for testing (including MSI)  
Default: input

### CURRENT_USER_NAME
Use CURRENT_USER_NAME for definiton of user under which the tests will run.  
This is used as the root directory for installation, saving logs etc.  
Prerequisities: user has to have Windows admin rights. Test suite uses default user account place in Users folder.
Default: tester

# Credits
This project would never be created without extensive help of
* [@sparkoo](https://github.com/sparkoo)
