export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppModalDialogDemo1
keytool -genkey -v -keystore AppModalDialogDemo1-release.keystore -alias appmodaldialogdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppModalDialogDemo1/appmodaldialogdemo1keytool_input.txt
