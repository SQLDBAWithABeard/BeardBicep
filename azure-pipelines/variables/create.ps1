Set-Location 'G:\OneDrive\Documents\GitHub\BeardBicep'
$films = 'Iron-Man', 'The-Incredible-Hulk', 'Iron-Man-2', 'Thor', 'Captain-America-The-First-Avenger', 'Marvels-The-Avengers', 'Iron-Man-3', 'Thor-The-Dark-World', 'Captain-America-The-Winter-Soldier', 'Guardians-of-the-Galaxy',	'Avengers-Age-of-Ultron', 'Ant-Man',	'Captain-America-Civil-War', 'Doctor-Strange',	'Guardians-of-the-Galaxy-2', 'Spider-Man-Homecoming', 'Thor-Ragnarok',	'Black-Panther',	'Avengers-Infinity-War', 'Ant-Man-and-the-Wasp', 'Captain-Marvel',	'Avengers-Endgame', 'Spider-Man-Far-From-Home', 'Black-Widow'

foreach ($film in $films) {
    foreach ($env in 'dev', 'uat', 'prod') {
        $filepath = 'azure-pipelines\variables\{0}-{1}.yaml' -f $film, $env
        if (-not (Test-Path $filepath)) {
            New-Item $filepath -ItemType File
        }
        $storageAccountName = '{0}{1}' -f (($film.ToLower()[0..21] -join '') -replace '-', ''), $env
        switch ($env) {
            'dev' { 
                $rgVirtualNetworksSubnets = '{0}/{1}/{2},{0}/{1}/{3},{0}/{1}/{4}' -f 'beardynetwork-dev-rg', 'beardvnet-dev', 'Public', 'onprem', 'internal'
                $peRGVnetSubnet = '{0}/{1}/{2}' -f 'beardynetwork-dev-rg', 'beardvnet-dev', 'internal'
            }
            'uat' { 
                $rgVirtualNetworksSubnets = '{0}/{1}/{2},{0}/{1}/{3},{0}/{1}/{4}' -f 'beardynetwork-uat-rg', 'beardvnet-uat', 'Public', 'onprem', 'internal'
                $peRGVnetSubnet = '{0}/{1}/{2}' -f 'beardynetwork-uat-rg', 'beardvnet-uat', 'internal'
            }
            'prod' { 
                $rgVirtualNetworksSubnets = '{0}/{1}/{2},{0}/{1}/{3},{0}/{1}/{4}' -f 'beardednetwork-rg', 'beardvnet', 'Public', 'onprem', 'iamgroot'
                $peRGVnetSubnet = '{0}/{1}/{2}' -f 'beardednetwork-rg', 'beardvnet', 'iamgroot'
            }
            
        }
        switch ($film) {
            'Iron-Man' { 
                $storageAccountContainers = 'tonystark,rhodey,pepperpots,jarvis'
            }
            'The-Incredible-Hulk' { 
                $storageAccountContainers = 'brucebanner,bettyross,abonimation'
            }
            'Iron-Man-2' { 
                $storageAccountContainers = 'tonystark,pepperpots,rhodey,ivanvanko,natalierushman,nickfury'
            }
            'Thor' { 
                $storageAccountContainers = 'thor,odin,janefoster,loki,heimdall,coulson'
            }
            'Captain-America-The-First-Avenger' { 
                $storageAccountContainers = 'steverogers,nickfury,peggycarter,bucky'
            }
            'Marvels-The-Avengers' { 
                $storageAccountContainers = 'tonystark,steverogers,natasharomanoff,thor,hulk,loki,pepperpots'
            }
            'Iron-Man-3' { 
                $storageAccountContainers = 'tonystark,rhodey,pepperpots,jarvis,aldrichkilian'
            }
            'Thor-The-Dark-World' { 
                $storageAccountContainers = 'thor,odin,janefoster,loki,heimdall,malekith,sif,erikselvig'
            }
            'Captain-America-The-Winter-Soldier' { 
                $storageAccountContainers = 'steverogers,nickfury,natasharomanoff,peggycarter,bucky'
            }
            'Guardians-of-the-Galaxy' { 
                $storageAccountContainers = 'starlord,groot,rocket,gamora,drax,ronan,nebula,yondu,collector'
            }
            'Avengers-Age-of-Ultron' { 
                $storageAccountContainers = 'tonystark,steverogers,thor,brucebanner,natasharomanoff,ultron'
            }
            'Ant-Man' { 
                $storageAccountContainers = 'scottlang,hankpym,darrencross,hopevandyne,samwilson,paxton'
            }
            'Captain-America-Civil-War' { 
                $storageAccountContainers = 'tonystark,brucebanner,natasharomanoff,samwilson,steverogers,nickfury,peggycarter,bucky'
            }
            'Doctor-Strange' { 
                $storageAccountContainers = 'drstephenstrange,mordo,drchristinepalmer,wong,theancientone'
            }
            'Guardians-of-the-Galaxy-2' { 
                $storageAccountContainers = 'starlord,babygroot,rocket,gamora,drax,nebula,yondu,ego,mantis,taserface'
            }
            'Spider-Man-Homecoming' { 
                $storageAccountContainers = 'peterparker,tonystark,pepperpots,happy'
            }
            'Thor-Ragnarok' { 
                $storageAccountContainers = 'thor,odin,loki,heimdall,brucebanner,hela,grandmaster,drstrange'
            }
            'Black-Panther' { 
                $storageAccountContainers = 'tchalla,nakia,okoye,shuri,mbaku'
            }	
            'Avengers-Infinity-War' { 
                $storageAccountContainers = 'tonystark,steverogers,thor,brucebanner,natasharomanoff,peterparker,drstrange,tchalla,gamora,nebula,loki'
            }
            'Ant-Man-and-the-Wasp' { 
                $storageAccountContainers = 'scottlang,hankpym,janetvandyne,sonny,paxton'
            }
            'Captain-Marvel' { 
                $storageAccountContainers = 'caroldanvers,nickfury,talos,ynrogg,korath'
            }
            'Avengers-Endgame' { 
                $storageAccountContainers = 'tonystark,steverogers,thor,brucebanner,natasharomanoff,clint,rhodey'
            }
            'Spider-Man-Far-From-Home' { 
                $storageAccountContainers = 'peterparker,tonystark,pepperpots,happy'
            }
            'Black-Widow' { 
                $storageAccountContainers = 'natasharomanoff,yelenabelova,alexei,melina,dreykov'
            }
            Default {}
        }
        $content = @"
variables:
 rgName: '$film-$env-rg'
 location: 'uksouth'
 storageAccountName: '$storageAccountName'
 storageAccountContainers: '$storageAccountContainers' # IMPORTANT - MUST BE 'containername1,containername2' for containers to be created
 rgVirtualNetworksSubnets: '$rgVirtualNetworksSubnets' # IMPORTANT - MUST BE 'RGName/vNetName/subnetName,RGName/vNetName/subnetName' The vNet/Subnet that will have the Private Endpoints
 peRGVnetSubnet: '$peRGVnetSubnet' # IMPORTANT - MUST BE 'RGName/vNetName/subnetName'
"@
        $content | Set-Content  $filepath
    }
}