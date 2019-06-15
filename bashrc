alias ls='ls -G'
alias vim='nvim'
alias vi='nvim'
alias sn='vi ~/SN/README'
alias nexus='/Users/ali.shah/Library/Android/sdk/tools/emulator -avd Nexus_5X_API_26 &'
alias pixel='/Users/ali.shah/Library/Android/sdk/emulator/emulator64 -avd Pixel_XL_API_27'
set -o vi

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.bin" 
export EDITOR="nvim"
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h:\[$(tput sgr0)\]\[\033[38;5;34m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \\$ \[$(tput sgr0)\]"

alias vimdiff="nvim -d"

#### Android Setup guide
#export CLIENT_TOOLS_ROOT=$HOME/Library/Android/sdk
#export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
#export ANDROID_SDK_HOME=$HOME/Library/Android/sdk
#export ANDROID_HOME=$HOME/Library/Android/sdk
# Export ANDROID_NDK_ROOT to tell the makefiles where it can
# find the cross-compilation tools.
#export ANDROID_NDK_ROOT=$HOME/Library/Android/sdk/ndk-bundle/android-ndk-r11c
#export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk-bundle/android-ndk-r11c
# Update your path so you can call adb, android and other 
# binaries in the SDK.
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_NDK_ROOT
# This this export of FLX_TARGET tells the Makefiles to build 
# Android - it's the only target we use these days.
export FLX_TARGET=Android

#Android requires JDK8
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home

# This export of SECURITY_CORE_PATH tells the makefiles where it
# can find the security project in order to build the last version
# of the library.
export SECURITY_CORE_PATH=$HOME/Projects/security
#### END Android Setup guide

alias ..='cd ..'
alias client='cd ~/ws/sn_client/Android'
alias partners='cd ~/ws/android/apps/personal/partners/'
alias features='cd ~/ws/android/apps/personal/features/'
alias uninstallSN='adb uninstall com.att.mobilesecurity'
#alias phase2='amoc_reset 0000000003; echo -n "Uninstalling... "; adb uninstall com.att.mobilesecurity; echo -n "Instaling Phase2... "; adb install ~/Downloads/apk/SmartNetwork-AmocPhase2-debug-2.0.10-9686717.apk; echo -e "\n\n"'
alias phase2='amoc_reset 0000000003; echo -n "Uninstalling... "; adb uninstall com.att.mobilesecurity; echo -n "Instaling Phase2... "; adb install ~/Downloads/APKs/SmartNetwork-AmocPhase2-debug-2.0.11-1fbc6dc.apk; echo -e "\n\n"'

alias phase3='echo -n "Installing Phase3... "; date; echo "";  adb install -r ~/ws/sn_client/Android/SmartNetwork/build/apk/SmartNetwork-AmocPhase3-debug.apk;'
alias phase3_offical='echo -n "Installing Official Phase3... "; date; echo "";  adb install -r ~/Downloads/APKs/SmartNetwork-AmocPhase3-debug-3.0-8ef01e0.apk;'
alias attsnui='vi ~/ws/sn_client/Android/partners/attsn_ui/src/main/java/com/lookout/plugin/ui/attsn/AttSnUiPluginModule.java'
alias pbc='pbcopy'
alias pbp='pbpaste'

alias debug="cd ~/ws/android/apps/personal/SmartNetwork/src/debug/java/com/att/mobilesecurity/application/"
alias main="cd ~/ws/android/apps/personal/SmartNetwork/src/main/java/com/att/mobilesecurity/application/"
alias release="cd ~/ws/android/apps/personal/SmartNetwork/src/release/java/com/att/mobilesecurity/application/"

export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
export FZF_DEFAULT_OPTS="--height 75% --reverse --border --no-mouse"

fz () {
  FILE=$(fzf)

  if [[ "$?" == 0 ]]; then
    eval vi $FILE
  fi
}

fzd () {
  if [[ $1 != "" ]];
  then
      eval cd $(dirname "$1")
  else
      FILE=$(fzf --no-mouse)

      if [[ "$?" == 0 ]]; then
          eval cd $(dirname "$FILE")
      fi
    fi
}

diffz () {
  FILE=$(fzf)

  if [[ "$?" == 0 ]]; then
    eval git difftool HEAD^ HEAD $FILE
  fi

}

vicommit() {
    COMMIT=$1
    FILE=$(git show --pretty="" --name-only $COMMIT | fzf)
    if [[ "$?" == 0 ]]; then
        eval vi $FILE
    fi
}

find_apk () { 
    REL=$1
    TC=$2
    file=$TC/$REL/$(basename $TC | cut -c15- | sed "s/Market/market-$REL/").apk;
    echo $file 
}

install_release_apk () { 
    file=$(find_apk release $1)
    echo "Attempt to install $file..."
    adb install $file
}

git_status_vi() {
    COMMIT=$1
    echo "COMMIT IS: $1"
    if [[ -z $COMMIT ]]
    then
#       FILE=$(git status -u | egrep 'modified|new\ file' | fzf)
#       FILE=$(git status -u | grep 'modified|new\ file' | fzf)
        FILE=$(git status -u --porcelain | fzf)
        if [[ $? == 0 ]];
        then
            # FILE=$(echo $FILE |  sed 's/.*: //')
            FILE=$(echo $FILE |  sed 's/^.* //')
            eval vi "$FILE"
        fi
    else
        git_show_vi $COMMIT
    fi
}

alias gsv='git_status_vi'

git_show_vi () {
    COMMIT=$1
    if [[ $COMMIT == "" ]]; then
        $COMMIT="HEAD"
    fi
    echo "Looking up : $COMMIT"
    FILE=$(git show --name-only $COMMIT |fzf);
    if [[ $? == 0 ]];
    then
        eval vi "$FILE"
    fi
}

function fuzz () {
    FILE=$(fzf)
    export FZ_FILE=$FILE
    echo $FZ_FILE
}
alias git_latest_head='git rev-parse HEAD | cut -c-7'

alias android_log='adb logcat | grep "Lookout : \[" | egrep -v BooleanGate\|BatterySensor\|InvestigationMetricTracker\|dalvik-cache\|FirmwareInvestigator\|PaperDelivery\|NewsroomService\|AppScanListener\|SecurityDB\|ZipAnomalyDetected\|HasAssessment\|ScanMetricsListener\|ZipFileInputStream\|FilesystemScanManagerScanner\|ResourceDataTable\|ScannableManifest\|ContainsPattern\|INotify.startMonitoring\|LocalScanner\|BaseApkScanner\|Id3TagValidationHeuristic'

function checkout() {
    name=$1
    location=$2

    git clone git@source.corp.lookout.com:lookout/$name.git $location
    cd $location
    scp -P 29418 gerrit:hooks/commit-msg .git/hooks
    git remote set-url --push origin no_push
    git remote add -f gerrit ssh://ali.shah@gerrit.corp.lookout.com:29418/$name
}

apk_fz () {
  FILE=$(fzf)
  echo "GOT: $FILE"

  if [[ "$?" == 0 ]]; then
    adb install "$FILE"
  fi
}

files_changed () {
    COMMIT=$1
    if [[ $COMMIT == "" ]];
    then 
        echo "checking HEAD"
        COMMIT="HEAD^"
    fi
    echo git diff --name-only $COMMIT
}

ls_apk () {
    find ./apps/personal/SmartNetwork/build -name *.apk 2>/dev/null
    find ./apps/personal/SmartBusiness/build -name *.apk 2>/dev/null | while read line; do ls -l $line; done;
    find ./apps/personal/Phoenix/build -name *.apk 2>/dev/null
}
clean_apk() {
    ls_apk | while read line; do rm "$line"; done
}

apks () { 
    HASH=$(git log | head -1  | cut -c 8-14)
    echo "Looking for $HASH"
    find ./apps/personal/SmartNetwork/build  -name *$HASH*.apk -exec ls -latr {} \; 2>/dev/null
    find ./apps/personal/SmartBusiness/build -name *$HASH*.apk -exec ls -latr {} \; 2>/dev/null
    find ./apps/personal/Phoenix/build       -name *$HASH*.apk -exec ls -latr {} \; 2>/dev/null
    find ./apps/personal/LookoutPersonal/build       -name *$HASH*.apk -exec ls -latr {} \; 2>/dev/null
}

select_apk () {
    SELECTED=$(apks | grep -v unsigned | fzf | awk '{print $NF}')
    echo "$SELECTED"
}

adb_connect() {
    adb connect 192.168.1.19:5555
}

install_apk() {
    APK=$(select_apk)
    echo "Installing: $APK"
    adb install -r "$APK"
}

sha256sum() {
    echo -n $1 | shasum -a 256
}

pick_command() {
    cmd=$(echo -e \
"./gradlew :apps:personal:features:attsn:testDebugUnitTest
./gradlew :apps:personal:features:attsn:checkstyle
./gradlew :apps:personal:partners:attsn_ui:testDebugUnitTest
./gradlew :apps:personal:partners:attsn_ui:checkstyle
./gradlew :apps:personal:partners:att_common_ui:testDebugUnitTest
./gradlew :apps:personal:partners:att_common_ui:checkstyle
./gradlew :apps:personal:features:attsn:checkstyle" | fzf)
    echo "$cmd"
    $cmd
}
