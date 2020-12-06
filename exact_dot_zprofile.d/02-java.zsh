# enable JAVA font antialiasing
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

# Work around X2Go Session being extremely wonky when Java programs are run
# source: http://bugs.x2go.org/cgi-bin/bugreport.cgi?bug=645
if [ -n "${X2GO_SESSION}" ]; then
    export _JAVA_OPTIONS+=" -Dsun.java2d.xrender=false"
fi

# if there is a java directory in home assume that is the Java home and
# take precedence
[ -d "${HOME}/java" ] && export JAVA_HOME="${HOME}/java"
