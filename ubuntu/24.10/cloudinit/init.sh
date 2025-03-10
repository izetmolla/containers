#!/bin/bash


echo 'Starting Init services'





function settingRootUser(){
    #enable Public Key Authentication
    sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/g' /etc/ssh/sshd_config
    sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config


    sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

    sed -i 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

    sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config



    if [ -n "$ROOT_PWD" ]; then
        # echo "root:$ROOT_PWD"
        echo "root:$ROOT_PWD" | chpasswd
        # echo '======================================================'
        # echo 'Username: root'
        # echo 'Password: '$ROOT_PWD
        # echo '======================================================'
    fi


    # PubkeyAuthentication yes
    if [ -n "$ROOT_SSH_PUBLIC_KEY" ]; then
        echo "\$app is not an empty string."
        mkdir -p /root/.ssh
        IFS=',' read -r -a public_keys_array <<< "$ROOT_SSH_PUBLIC_KEY"
            for pk in "${public_keys_array[@]}"; do
                if ! grep -qF "$pk" /root/.ssh/authorized_keys 2>/dev/null; then
                    echo "$pk" >> /root/.ssh/authorized_keys
                    echo 'Authorized key added successfully for user root'
                else
                    echo 'Authorized key already exists for user root'
                fi
            done
        chmod 600 /root/.ssh/authorized_keys
        chmod 700 /root/.ssh
    fi
}


function installPackages(){
    cloudInitDir="/cloudinit"
    apt update &&  apt upgrade -y
    if [ -n "$SOFTWARES" ]; then
        echo "Installing software's $SOFTWARES"
        apt update && apt install $SOFTWARES -y
    fi

    if [ -n "$CUSTOM_SOFTWARES" ]; then
        echo "Installing custom software's $CUSTOM_SOFTWARES"
        customSoftwareDir="$cloudInitDir/apps"
        if [ -d "$customSoftwareDir" ]; then
            files=$(ls "$customSoftwareDir")
            for file in $files; do
                echo "Processing custom software file: $file"
                IFS=',' read -r -a software_array <<< "$CUSTOM_SOFTWARES"
                for software in "${software_array[@]}"; do
                    name=$(echo "$software" | cut -d'@' -f1)
                    version=$(echo "$software" | cut -d'@' -f2)
                    if [[ "$file" == "install_$name.sh" ]]; then
                        echo "File $file matches the software name $name AND version $version"
                        if [[ "$name" == "$version" ]]; then
                            version=""
                        fi
                        chmod +x $customSoftwareDir/$file
                        bash  $customSoftwareDir/$file $version
                    else
                        echo "File $file does not match the software name $name"
                    fi
                    echo "Installing $name with version $version"
                done
                
            done
        else
            echo "The directory $customSoftwareDir does not exist."
        fi
    fi
}

settingRootUser
installPackages

if [ -n "$ROOT_PWD" ]; then
    echo '======================================================'
    echo 'IP: '$(hostname -I)
    echo 'Username: root'
    echo 'Password: '$ROOT_PWD
    echo '======================================================'
fi

