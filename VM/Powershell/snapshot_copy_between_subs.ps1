#Provide the subscription Id of the subscription where snapshot exists
$sourceSubscriptionId="6cae2ff4-f328-4114-be78-1126535486c7"

#Provide the name of your resource group where snapshot exists
$sourceResourceGroupName="rg-tfg-dwh-prod-vm-01"

#Provide the name of the snapshot
$snapshotName="tfg-dwh-prod-vm-pyramid-01_OsDisk_1_snapshot_20230407"

#Set the context to the subscription Id where snapshot exists
az account set --subscription $sourceSubscriptionId

#Get the snapshot Id 
$snapshotId=$(az snapshot show --name $snapshotName --resource-group $sourceResourceGroupName --query [id] -o tsv)

#If snapshotId is blank then it means that snapshot does not exist.
echo 'source snapshot Id is: ' $snapshotId

#Provide the subscription Id of the subscription where snapshot will be copied to
#If snapshot is copied to the same subscription then you can skip this step
$targetSubscriptionId="7c7f7454-2e52-4509-88a3-533cf6c27cf9"

#Name of the resource group where snapshot will be copied to
$targetResourceGroupName="rg-tfg-dwh-dev-vm-01"

#Set the context to the subscription Id where snapshot will be copied to
#If snapshot is copied to the same subscription then you can skip this step
az account set --subscription $targetSubscriptionId

#Copy snapshot to different subscription using the snapshot Id
#We recommend you to store your snapshots in Standard storage to reduce cost. Please use Standard_ZRS in regions where zone redundant storage (ZRS) is available, otherwise use Standard_LRS
#Please check out the availability of ZRS here: https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy-zrs#support-coverage-and-regional-availability
az snapshot create --resource-group $targetResourceGroupName --hyper-v-generation V2 --name $snapshotName --source $snapshotId --sku Standard_LRS