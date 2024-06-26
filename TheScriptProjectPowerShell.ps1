###########################################
#            M. Dhauyre Jerome            #
#           M. Dominici Thomas            #
#         M. Del Ciotto Vincent           #
#          Projet "MyFirstScript"         #
#     Le but du projet est de pouvoir     #
#        interagir depuis un serveur      # 
#    vers different client avec des OS    # 
#              different                  #
# Le Projet a commencé le lundi 9 octobre#
#                Version 1.0              #
###########################################

#------------------Variable------------------#

$cli = Read-host "Quelle est le nom de la machine sur laquelle vous voulez intervenir ?"
$cred = Read-Host "Sur quel utilisateur voulez vous vous connecter ?"
#------------------Fonction------------------#

#Ajout d'un Utilisateur

function newUser 
{
    Invoke-command -computername $cli -Credential $cred -scriptblock {
        $newUser = Read-Host "Merci de renseigner un nom d'utilisateur a ajouter"
        If ($newUser)
        {
            If (-not(Get-LocalUser | Where-Object {$_.name -like $($newUser)}))
            {
                $newPassword = Read-Host "Merci de renseigner le mot de passe de cet utilisateur "
                If ($newPassword)
                {
                    New-LocalUser -Name $newUser -Password (Convertto-securestring -asplaintext $($newPassword) -Force )
                    Write-Host "L'utilisateur $newUser a bien ete cree "
                }
                Else
                {
                    Write-Host "Merci de renseigner un mot de passe"

                }
            }
            Else
            {
                Write-Host "Cet utilisateur existe deja"
            }
        }
        Else
        {
            Write-Host "Merci de renseigner un nom d'utilisateur a ajouter"
        } 
    }

    #Format de la date pour Journalisation
    $LogDate = Get-Date -Format yyyyMMdd-hhmmss 
    #Journalisation
    "Utilisateur ajoute le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-AjoutUtilisateur.log
}

#Modification d'un utilisateur

function renameUser { Invoke-command -computername $cli -Credential $cred -scriptblock { $UserToRename = Read-Host "Merci de renseigner un nom d'utilisateur à renommer"
If ($UserToRename)
{
    If (Get-LocalUser | Where-Object {$_.name -like $($UserToRename)})
    {
        $newNameUser = Read-Host "Merci de renseigner un nouveau nom d'utilisateur "
        If ($newNameUser)
        {
            If (Get-LocalUser | Where-Object {$_.name -like $($newNameUser)})
            {
                Write-Host "Ce nom d'utilisateur existe deja"
            }
            Else
            {
                Rename-LocalUser -Name $UserToRename -NewName $newNameUser
                Write-Host "L'utilisateur $UserToRename a bien ete renomme en $newNameUser "
            }
        }
        Else
        {
            Write-Host "Merci de renseigner un nouveau nom d'utilisateur"

        }
    }
    Else
    {
        Write-Host "Cet utilisateur n'existe pas"
    }
}
Else
{
Write-Host "Merci de renseigner un nom d'utilisateur a renommer"

} 
}

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Utilisateur rennome le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-RenommageUtilisateur.log
}

#Suppression d'un utilisateur

function delUser { Invoke-command -computername $cli -Credential $cred -scriptblock { $delUser = Read-Host "Merci de renseigner un nom d'utilisateur a supprimer"
If ($delUser)
{
    If (Get-LocalUser | Where-Object {$_.name -like $($delUser)})
    {

        Remove-LocalUser -Name $delUser 
        Write-Host "L'utilisateur $delUser a bien ete supprime "
    }
    Else
    {
        Write-Host "Cet utilisateur n'existe pas"
    }
}
Else
{
    Write-Host "Merci de renseigner un nom d'utilisateur a supprimer"

} 
}
#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Utilisateur supprime le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-SuppressionUtilisateur.log
}

#Suspension d'un Utilisateur

function disableUser { Invoke-command -computername $cli -Credential $cred -scriptblock { $disableUser = Read-Host "Merci de renseigner un nom d'utilisateur a suspendre"
If ($disableUser)
{
    If (Get-LocalUser | Where-Object {$_.name -like $($disableUser)})
    {

        Disable-LocalUser -Name $disableUser 
        Write-Host "L'utilisateur $disableUser a bien ete suspendu "
    }
    Else
    {
        Write-Host "Cet utilisateur n'existe pas"
    }
}
Else
{
    Write-Host "Merci de renseigner un nom d'utilisateur a suspendre"

} 
}
#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Utilisateur suspendu le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-SuspensionUtilisateur.log
}


#Modification d'un mot de passe utilisateur

function changePassword
{
    Invoke-command -computername $cli -Credential $cred -scriptblock {
        $UserPassword = Read-Host "Merci de renseigner un nom d'utilisateur pour changer son mot de passe"
        If ($UserPassword)
        {
            If (Get-LocalUser | Where-Object {$_.name -like $($UserPassword)})
            {
                #$Password = Read-Host -AsSecureString 
                $NewPassword = Read-Host -AsSecureString 
                $Password = $NewPassword | ConvertTo-SecureString -AsPlainText -Force 
                Get-LocalUser -Name $UserPassword | Set-LocalUser -Password $NewPassword -UserMayChangePassword $true -PasswordNeverExpires $true
                Write-Host "Mot de passe changé avec succès !"
            }
            else
            {
                write-host " L'utilisateur n'existe pas"
            }
        }
        else
        {
            Write-host "Merci de renseigner un nom d'utilisateur"
        }
    }
    #Format de la date pour Journalisation
    $LogDate = Get-Date -Format yyyyMMdd-hhmmss 
    #Journalisation
    "Mot de passe modifié le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-ModifMotDePasseUtilisateur.log
}

#L'ajout d'un utilisateur a un groupe

function addToGroup { Invoke-command -computername $cli -Credential $cred -scriptblock { $Group = Read-Host "Veuillez entrer le nom du groupe"
If ($Group)
{
    If (Get-LocalGroup | Where-Object {$_.name -like $($Group)})
    {
        $User = Read-Host "Veuillez entrer le nom d'utilisateur"
        If ($User)
        {
            If (Get-LocalUser | Where-Object {$_.name -like $($User)})
            {
                If (Get-LocalGroupMember $Group | Where-Object {$_.name -like $($User)})
                {
                    Write-Host "L'utilisateur appartient deja au groupe"
                }
                Else
                {
                    Add-LocalGroupMember -Group $Group -Member $User
                    Write-Host "L'utilisateur $User a bien ete ajoute au groupe $Groupe ! "
                }
            }
            Else
            {
                Write-Host "L'utilisateur n'existe pas"

            }
        }
        Else
        {
            Write-Host "Merci de renseigner un nom d'utilisateur"

        }
    }
    Else
    {
    Write-Host " Le groupe n'existe pas "
    }
}
Else
{
    "Merci de renseigner le nom du groupe "

}
}
#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Utilisateur ajoute au groupe le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-AjoutGroupeUtilisateur.log
}

#Suppression d'un utilisateur dans un groupe
function removeFromGroup { Invoke-command -computername $cli -Credential $cred -scriptblock { $GroupRemove = Read-Host "Veuillez entrer le nom du groupe"
If ($GroupRemove)
{
    If (Get-LocalGroup | Where-Object {$_.name -like $($GroupRemove)})
    {
        $UserToRemove = Read-Host "Veuillez entrer le nom d'utilisateur"
        If ($UserToRemove)
        {
             If (Get-LocalUser | Where-Object {$_.name -like $($UserToRemove)})
            {
                If (Get-LocalGroupMember $GroupRemove | Select-Object $($UserToRemove))
                {
                    Remove-LocalGroupMember -Group $GroupRemove -Member $UserToRemove
                    Write-Host "L'utilisateur $UserToRemove a bien ete ajouter du groupe $GroupeRemove ! "
                }
                Else
                {
                    Write-Host "L'utilisateur n'appartient pas au groupe"   
                }
            }
            Else
            {
                Write-Host "L'utilisateur n'existe pas"

            }
        }
        Else
        {
            Write-Host "Merci de renseigner un nom d'utilisateur"

        }
    }
    Else
    {
    Write-Host " Le groupe n'existe pas "
    }
}
Else
{
    "Merci de renseigner le nom du groupe "

}
}
#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Utilisateur supprime du groupe le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-SuppressionGroupeUtilisateur.log
}

#---------------------Fonction Action Machine

#Verouillage d'un PC client

function lockedComputer { Invoke-command -computername $cli -Credential $cred -scriptblock { logoff 1
}

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Ordinateur client verrouille le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-VerroullageClient.log
}


#Création d'un répertoire

function newDir { Invoke-command -computername $cli -Credential $cred -scriptblock { $Localisation = Read-Host "Renseigner la localisation pour la creation de dossier  "
If ($Localisation)
{
    If (Test-Path $Localisation)
    {
        $NewDir = Read-Host "Renseigner le nom de dossier a creer  "
        If ($NewDir)
        {
            If (Test-Path $NewDir)
            {
               Write-Host " Ce dossier existe deja"
            }
            Else
            {
                New-Item -Path $Localisation -ItemType Directory -Name $NewDir
                Write-Host "Dossier $NewDir créé avec succes"
            }
        }
        Else
        {
            Write-Host " Merci de renseigner un nom de dossier "
        }
    }
    Else
    {
        Write-Host " Cet emplacement n'existe pas "
    }
}
Else
{
    Write-Host " Merci de renseigner une localisation "
}
}

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Dossier crée le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-CreationDossier.log
}


#Modification d'un répertoire

function renameDir { Invoke-command -computername $cli -Credential $cred -scriptblock { $Localisation2 = Read-Host "Renseigner la localisation complete du dossier a renommer  "
If ($Localisation2)
{

    If (Test-Path $Localisation2)
    {
         $NewNameDir = Read-Host " Renseignez le nouveau nom du dossier "
      Rename-Item -Path $Localisation2 $NewNameDir
         Write-Host "Dossier $NewDir renomme avec succes"
    }
    Else
    {
     Write-Host " Ce dossier n'existe pas "
    }
}
Else
{
Write-Host " Vous devez renseigner un nom de dossier complet "
}
}

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Dossier Renomme le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-DossierRenomme.log

}


#Suppression d'un repertoire

function delDir { Invoke-command -computername $cli -Credential $cred -scriptblock { $Localisation3 = Read-Host "Renseigner la localisation complete du dossier a supprimer  "
If ($Localisation3)
{

    If (Test-Path $Localisation3)
    {

      Remove-Item -Path $Localisation3
         Write-Host "Dossier $NewDir supprime avec succes"
    }
    Else
    {
     Write-Host " Ce dossier n'existe pas "
    }
}
Else
{
Write-Host " Vous devez renseigner un nom de dossier complet "
}
}

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Dossier supprimé le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-SuppressionDossier.log

}


#Prise en main a distance
function remoteControl {
$clientRemote = Read-Host " Merci de renseigner le nom du client pour la prise en main a distance "
$userRemote = Read-Host " Merci de renseigner le nom d'utilisateur "
Enter-PSSession -Computername $clientRemote -credential "$userRemote"

#Format de la date pour Journalisation
$LogDate = Get-Date -Format yyyyMMdd-hhmmss 
#Journalisation
"Prise de controle fait le $($LogDate)" |  Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-PriseControleCLI.log
}

#------------------------------fonction 01 Date de derniere connection d’un utilisateur
function LastConnectionUser {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    $Lastconnection = Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock {
        $utilisateur = Read-Host "Entrez le nom de l'utilisateur"
    
        # Rechercher la date de la derniere connexion de l'utilisateur
        $evenement = Get-WinEvent -LogName "Security" | Where-Object { $_.Id -eq 4624 -and $_.Properties[5].Value -eq $utilisateur } | Select-Object -First 1
    
        if ($evenement) {
            $dateDerniereConnexion = $evenement.TimeCreated
            return "La date de la derniere connexion de $utilisateur est : $dateDerniereConnexion"
        } else {
            Write-Host "L'utilisateur $utilisateur n'a pas de connexion enregistrée."
        }
    } > C:\Users\administrateur\Desktop\export\DerniereConnectionUtilisateur_$($cli)_$($logDate).txt
    $Lastconnection
}

#-----------------------------fonction 02 Date de dernière modification du mot de passe
function LastPasswordChangeDate {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss  
    Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock {
        $utilisateur = Read-Host "Entrez le nom de l'utilisateur"
        $evenement = Get-WinEvent -LogName "Security" | Where-Object { $_.Id -eq 4624 -and $_.Properties[5].Value -eq $utilisateur } | Select-Object -First 1
        if ($utilisateur) 
        {
            if (Get-LocalUser | Where-Object {$_.name -eq $utilisateur}) 
            {
                if ($evenement) 
                {
                    $lastPasswdChangeDate = $evenement.TimeCreated
                    return "La date de derniere modification du mot de passe de $utilisateur est : $lastPasswdChangeDate" 
                } 
                else 
                {
                    Write-Host "L'utilisateur $utilisateur n'a pas de connexion enregistree."
                }
            } 
            else 
            {
                Write-Host "Cet utilisateur n'existe pas"
            }
        }
        else 
        {
            Write-Host "Merci de renseigner un nom d'utilisateur"
        }
    } > C:\Users\administrateur\Desktop\export\DerniereModificationMotDePasse_$($cli)_$($logDate).txt
    
} 

#-----------------------fonction 03 Groupe d’appartenance d’un utilisateur
function UserGroup {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    $UserGroup = Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock { whoami /groups } > C:\Users\administrateur\Desktop\export\GroupeUtilisateur_$($cli)_$($logDate).txt
    $UserGroup
}

#----------------------fonction 04 Droits/permissions de l’utilisateur
function UserPermissions {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    $UserPermissions = Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock { whoami /priv }  > C:\Users\administrateur\Desktop\export\PermissionUtilisateur_$($cli)_$($logDate).txt
    $UserPermissions
}
#---------------------------------fonction menu informations ordinateur
#---------------------------------01 fonction OS---------------------------------------------
function OsVersion {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock { $osInfo = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version 
    return $osInfo 
    } > C:\Users\administrateur\Desktop\export\VersionOS_$($cli)_$($logDate).txt
}

#--------------------------------02 fonction espace disque------------------------------
function diskSpace {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock {
        $FreeDiskSpaceCommand = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }
        $FreeSpaceBytes = $FreeDiskSpaceCommand.FreeSpace
        $FreeSpaceGB = [math]::Round($FreeSpaceBytes / 1GB, 2)
        return "Espace disque restant sur le lecteur C: : $FreeSpaceGB Go"
    } > C:\Users\administrateur\Desktop\export\EspaceDisque_$($cli)_$($logDate).txt
}

#-----------------------------03 fonction taille de repertoire--------------------------
function sizeOfDirectory {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    $DirectorySize = Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock {
        #Demander le chemin du repertoire à l'utilisateur
        $cheminDuRepertoire = Read-Host "Veuillez entrer le chemin du repertoire"

        if ($cheminDuRepertoire)
        {
            if (Test-Path $cheminDuRepertoire)
            {
                #Obtenir la taille du repertoire en octets
                $tailleEnOctets = (Get-ChildItem -Recurse -File -Path $cheminDuRepertoire | Measure-Object -Property Length -Sum).Sum

                #Fonction pour convertir la taille en une unite lisible par un humain
                function ConvertirEnLisible 
                {
                    param(
                        [long]$tailleEnOctets
                    )

                    if ($tailleEnOctets -ge 1GB) 
                    {
                        "{0:N2} Go" -f ($tailleEnOctets / 1GB)
                    }
                    elseif ($tailleEnOctets -ge 1MB)
                    {
                        "{0:N2} Mo" -f ($tailleEnOctets / 1MB)
                    }
                    elseif ($tailleEnOctets -ge 1KB) 
                    {
                        "{0:N2} Ko" -f ($tailleEnOctets / 1KB)
                    }
                    else
                    {
                        "{0:N0} octets" -f $tailleEnOctets
                    }
                }

                #Convertir la taille en une forme lisible par un humain
                $tailleLisible = ConvertirEnLisible -tailleEnOctets $tailleEnOctets

                #Afficher la taille du répertoire de manière lisible
                return "La taille du répertoire $cheminDuRepertoire est de $tailleLisible."
            }
            else
            {
                Write-Host "Ce chemin de repertoire n'est pas valide"
            }
        }
        else
        {
            Write-Host "Merci de renseigner un chemin de repertoire"
        }
    } > C:\Users\administrateur\Desktop\export\TailleRepertoire_$($cli)_$($logDate).txt
    
}

#-------------------------------------04 fonction liste des lecteurs-----------------------------------------------
Function hardDriveList {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
   Invoke-Command -ScriptBlock { $lecteurs = Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, VolumeName
        return $lecteurs
    } -ComputerName $cli -Credential $cred > C:\Users\administrateur\Desktop\export\ListeLecteur_$($cli)_$($logDate).txt
    
}

#-----------------------------------05 fonction adresses IP------------------------------------
Function ipAdrress {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -scriptblock { $adresseIP =  Get-NetIPAddress -AddressFamily IPV4 | Select-Object "*ipa*"
    return $adresseIP
    } -computername $cli -credential $cred > C:\Users\administrateur\Desktop\export\AdresseIP_$($cli)_$($logDate).txt

    
}

#---------------------------------06 fonction liste des adresses MAC---------------------

function macaddressList {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -scriptblock { $MacList = Get-NetAdapter -Name * | Select-Object "MacAddress"
    return $MacList
    } -computername $cli -credential $cred > C:\Users\administrateur\Desktop\export\AdresseMAC_$($cli)_$($logDate).txt

    $MacList
}

#------------------------------------07 fonction liste des application et paquets------------------------

function programList {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -scriptblock { $PaquetsList = Get-Package
    return $PaquetsList
    } -computername $cli -credential $cred  > C:\Users\administrateur\Desktop\export\ApplicationPaquet_$($cli)_$($logDate).txt
}

#------------------------------------08 fonction CPU------------------------------------
function cpuType {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -scriptblock { $CPUtype = Get-WmiObject -Class Win32_Processor
    return $CPUtype
    } -computername $cli -credential $cred  > C:\Users\administrateur\Desktop\export\InfoCPU_$($cli)_$($logDate).txt
}

#------------------------------------09 fonction RAM-------------------------------------
function RamMemory {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command  -computername $cli -credential $cred -scriptblock { $ram = ([math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2))
    return "$ram Go"
    } > C:\Users\administrateur\Desktop\export\InfoRAM_$($cli)_$($logDate).txt
}

#------------------------------------10 fonction Ports-------------------------------------
function portsList {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    $Ports = Invoke-Command -computername $cli -credential $cred -scriptblock { $Ports = Get-NetTCPConnection | Select-Object LocalPort
    return $Ports | Format-Table
    } > C:\Users\administrateur\Desktop\export\InfoPort_$($cli)_$($logDate).txt 
}

#------------------------------------11 fonction Pare-feu---------------------------------
function FirewallStatus {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -computername $cli -credential $cred -scriptblock { $Firewall = Get-NetFirewallProfile | Select-Object Name, Enabled
    
    return $Firewall} > C:\Users\administrateur\Desktop\export\StatutParefeu_$($cli)_$($logDate).txt     
}

#------------------------------------12 fonction utilisateurs locaux---------------------------------
function localUsersList {
    $logDate = Get-Date -Format yyyyMMdd_hhmmss
    Invoke-Command -ComputerName $cli -Credential $cred -ScriptBlock { $LocalUsers =  Get-WmiObject -Class Win32_UserAccount | Select-Object Name, Fullname, SID
    return $LocalUsers} > C:\Users\administrateur\Desktop\export\UtilisateurLocaux_$($cli)_$($logDate).txt 
}
#-----------------Menu Principale----------------#

function MenuPrincipal
{
Clear-Host
    $selection = $null
    while ($selection -ne 4)
    { 
    Clear-host 
        Write-Host "Menu Principal"
        Write-Host "--------------------------------"
        Write-Host "1. Voulez-vous recolter une information ?"
        Write-Host "2. Voulez-vous effetuer une action ?"
        Write-Host "3. Quitter"
        $choice = Read-Host "Sélectionnez une option (1-3)"
        switch ($choice)
        {
        1
            {
            MenuInfo
            }
        2
            {
            MenuAction
            }
        3 
            {
            Write-Host "See you!"
            exit
            }        
        default 
            {
            Write-Host "Option invalide. Veuillez sélectionner une option valide (1-3)."
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        }
    }
}

#-----------------Menu Informations ----------------#

function MenuInfo
{
Clear-Host
    $selection = $null
    while ($selection -ne 4)
    { 
    Clear-host 
        Write-Host "Menu Information"
        Write-Host "--------------------------------"
        Write-Host "1. Voulez-vous recolter une information sur l'utilisateur ?"
        Write-Host "2. Voulez-vous recolter une information sur la machine ?"
        Write-Host "3. Retour au menu precedent"
        Write-Host "4. Quitter"
        $choice = Read-Host "Sélectionnez une option (1-4)"
        switch ($choice)
        {
        1
            {
            MenuInfosUser
            }
        2
            {
            MenuInfoComp
            }
        3 
            {
            MenuPrincipal
            }
        4
            {
            Write-Host "See you!"
            exit
            }
        default 
            {
            Write-Host "Option invalide. Veuillez sélectionner une option valide (1-4)."
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        }
    }
}

#-----------------Menu Information Utilisateur----------------#

function MenuInfosUser 
{
Clear-Host
    $selection = $null
    while ($selection -ne 6)
    { 
    Clear-Host
    Write-Host "Menu Informations utilisateurs"
    Write-Host "--------------------------------"
    Write-Host "1. Date de derniere connection utilisateur"
    Write-Host "2. Date de derniere modification du mot de passe"
    Write-Host "3. Groupe d'appartenance d'un utilisateur"
    Write-Host "4. Droits/permissions de l'utilisateur"
    Write-Host "5. Retour au menu précedent"
    Write-Host "6. Quitter"
    $choice = Read-Host "Entrez le numéro de l'option que vous souhaitez exécuter"
        # Menu d'informations sur les utilisateurs                                                        
            switch ($choice) 
            {
                1 
                    {
                    LastConnectionUser                   
                    Read-Host "Appuyez sur Entrée pour revenir au menu..."
                    }
                2 
                    {
                    LastPasswordChangeDate
                    Read-Host "Appuyez sur Entrée pour revenir au menu..."
                    }
                3 
                    {
                    UserGroup
                    Read-Host "Appuyez sur Entrée pour revenir au menu..."
                    }
                4 
                    {
                    UserPermissions
                    Read-Host "Appuyez sur Entrée pour revenir au menu..."
                    }
                5
                    {
                    MenuInfo                    
                    }
                6 
                    {
                    Write-Host "See you!"
                    exit
                    }
                default 
                    {
                    Write-Host "Option invalide. Veuillez sélectionner une option valide (1-6)."
                    Read-Host "Appuyez sur Entrée pour revenir au menu..."
                    }
            }
    }
}

#-----------------Menu Information Machine----------------#

function MenuInfoComp 
{
Clear-Host
    $selection = $null
    while ($selection -ne 14)
    { 
    Clear-Host
    Write-Host "Menu Informations ordinateurs"
    Write-Host "--------------------------------"
    Write-Host "1. Information systeme (OS)"
    Write-Host "2. Espace disque"
    Write-Host "3. Taille d'un repertoire"
    Write-Host "4. Liste des lecteurs"
    Write-Host "5. Adresses IP"
    Write-Host "6. Liste des adresses MAC"
    Write-Host "7. Liste des applications et paquets"
    Write-Host "8. Type de CPU"
    Write-Host "9. Mémoire RAM"
    Write-Host "10. Liste des ports en cours d'utilisation"
    Write-Host "11. État du pare-feu"
    Write-Host "12. Liste des utilisateurs locaux"
    Write-host "13. Retour au menu precedent"
    Write-Host "14. Quitter"
    $choice = Read-Host "Sélectionnez une option (1-14)"
    switch ($choice) 
        {
            1 
                { 
                OsVersion 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            2 
                { 
                diskSpace 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            3
                { 
                sizeOfDirectory 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            4
                { 
                hardDriveList 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            5
                { 
                ipAdrress 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            6
                { 
                macaddressList 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            7  
                { 
                programList 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            8 
                { 
                cpuType 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            9 
                { 
                RamMemory 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            10
                { 
                portsList 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            11 
                { 
                FirewallStatus 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            12 
                { 
                localUsersList 
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            13 
                {
                MenuInfo 
                }
            14 
                {
                Write-Host "See you!"
                exit
                }
            default 
                {
                Write-Host "Option invalide. Veuillez sélectionner une option valide (1-14)."
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
        }
    }
}

#-----------------Menu Action----------------#

function MenuAction
{
Clear-Host
    $selection = $null
    while ($selection -ne 4)
    { 
    Clear-host 
        Write-Host "Menu Action"
        Write-Host "--------------------------------"
        Write-Host "1. Voulez-vous effetuer une action sur l'utilisateur ?"
        Write-Host "2. Voulez-vous effetuer une action sur la machine ?"
        Write-Host "3. Retour au menu precedent"
        Write-Host "4. Quitter"
        $choice = Read-Host "Sélectionnez une option (1-4)"
        switch ($choice)
        {
        1
            {
            MenuActUser
            }
        2
            {
            MenuActCompt
            }
        3 
            {
            MenuPrincipal
            }
        4
            {
            Write-Host "See you!"
            exit
            }
        default 
            {
            Write-Host "Option invalide. Veuillez sélectionner une option valide (1-4)."
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        }
    }
}

#-----------------Menu Action Utilisateur----------------#

function MenuActUser 
{
Clear-Host
    $selection = $null
    while ($selection -ne 9)
    {
        Clear-host 
        Write-Host "Menu Action Utilisateurs"
        Write-Host "--------------------------------"
        Write-Host "1. Voulez-vous ajouter un Utilisateur ?"
        Write-Host "2. Voulez-vous renommer un Utilisateur ?"
        Write-Host "3. Voulez-vous supprimer un Utilisateur ?"
        Write-Host "4. Voulez-vous suspendre un Utilisateur ?"
        Write-Host "5. Voulez-vous changer le mot de passe d'un Utilisateur ?"
        Write-Host "6. Voulez-vous ajouter l'utilisateur a un groupe ?"
        Write-Host "7. Voulez-vous retirer l'utilisateur a un groupe ?"
        Write-Host "8. Retour au menu precedent"
        Write-Host "9. Quitter"
        $choice = Read-Host "Sélectionnez une option (1-9)"
        switch ($choice)
        {
            1
                {
                newUser
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            2
                {
                renameUser
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            3
                {
                delUser
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            4
                {
                disableUser
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            5
                {
                changePassword
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            6
                {
                addToGroup
                Read-Host "Appuyez sur Entrée pour revenir au menu..." 
                }
            7
                {
                removeFromGroup
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
            8
                {
                MenuAction
                }
            9
                {
                Write-Host "See you!"
                exit
                }
            default
                {
                Write-Host "Option invalide. Veuillez sélectionner une option valide (1-9)"
                Read-Host "Appuyez sur Entrée pour revenir au menu..."
                }
        }
    }
}

#-----------------Menu Action Machine----------------#

function MenuActCompt 
{
Clear-Host
    $selection = $null
    while ($selection -ne 12)
    {
        Clear-host 
        Write-Host "Menu Action Machine"
        Write-Host "--------------------------------"
        Write-Host "1. Voulez-vous arreter la machine ?"
        Write-Host "2. Voulez-vous redemarrer la machine ?"
        Write-Host "3. Voulez-vous demarrer la machine grace au wake-on-lan ?"
        Write-Host "4. Voulez-vous mettre a jour le systeme ?"
        Write-Host "5. Voulez-vous verrouiller la session ?"
        Write-Host "6. Voulez-vous creer un repertoire ?"
        Write-Host "7. Voulez-vous modifier un repertoire ?"
        Write-Host "8. Voulez-vous supprimer un repertoire ?"
        Write-Host "9. Voulez-vous prendre en main le client ?"
        Write-Host "10. Voulez-vous definir les regles du pare-feu?"
        Write-Host "11. Retour au menu precedent"
        Write-Host "12. Quitter"
        $choice = Read-Host "Sélectionnez une option (1-12)"
        switch ($choice)
        {
        1
            {
            Stop-Computer -ComputerName $cli -Credential $cred -force

            #Format de la date pour Journalisation
            $LogDate = Get-Date -Format yyyyMMdd_hhmmss 
            "Ordinateur client éteint le $($LogDate)" | Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-ShutdownClient.log
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        2
            {
            Restart-Computer -ComputerName $cli -Credential $cred -force

            #Format de la date pour Journalisation
            $LogDate = Get-Date -Format yyyyMMdd_hhmmss 
            "Ordinateur client redémarré le $($LogDate)" | Out-File -Append -FilePath C:\Windows\System32\LogFiles\$($LogDate)-Administrateur-$cli-RebootClient.log
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        3
            {
            Write-Host "Non executable a ce stade de la formation"
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        4
            {
            Write-Host "Non executable a ce stade de la formation"
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        5
            {
            lockedComputer
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        6
            {
            newDir
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        7
            {
            renameDir
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        8
            {
            delDir
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        9
            {
            remoteControl
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        10
            {
            Write-Host "Non executable a ce stade de la formation"
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
        11
            {
            MenuAction
            }
        12
            {
            Write-Host "See you!"
            exit
            }
        default
            {
            Write-Host "Option invalide. Veuillez sélectionner une option valide (1-12)"
            Read-Host "Appuyez sur Entrée pour revenir au menu..."
            }
            
        }
    }
}
#-------------------------------MAIN---------------------------------#

MenuPrincipal
