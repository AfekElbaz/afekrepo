Set-AzCurrentStorageAccount -ResourceGroupName 'afek-elbaz-rg' -Name 'afek1storage'
$ContainerName = 'acontainer'
New-AzStorageContainer -Name $ContainerName -Context $Context -Permission Blob
New-Item -Path . -Name "testfile1.txt" -ItemType "file" -Value "This is a text string."
$val=0
while($val -ne 100)
{
  $val++
  $Blob1HT = @{
  File             = '/home/afek/testfile1.txt'
  Container        = 'acontainer'
  Blob             = "$val.txt"
  Context          = $Context
  StandardBlobTier = 'Hot'

}
Set-AzStorageBlobContent @Blob1HT
}
Set-AzCurrentStorageAccount -ResourceGroupName 'afek-elbaz-rg' -Name 'afek2storage'
$ContainerName = 'bcontainer'
New-AzStorageContainer -Name $ContainerName -Context $Context -Permission Blob

$srcResourceGroupName = 'afek-elbaz-rg'
$srcStorageAccountName = "afek1storage"
$srcContainer = 'acontainer'
$destResourceGroupName = 'afek-elbaz-rg'
$destStorageAccountName = "afek2storage"
$destContainer = "bcontainer"
$srcStorageKey = Get-AzStorageAccountKey -Name $srcStorageAccountName `
                                         -ResourceGroupName $srcResourceGroupName 
$destStorageKey = Get-AzStorageAccountKey -Name $destStorageAccountName `
  -ResourceGroupName $destResourceGroupName
  $srcContext = New-AzStorageContext -StorageAccountName $srcStorageAccountName `
                                   -StorageAccountKey $srcStorageKey.Value[0]
$destContext = New-AzStorageContext -StorageAccountName $destStorageAccountName `
                                    -StorageAccountKey $destStorageKey.Value[0]

$val=0
 while($val -ne 100)
{  
  $val++ 
$blobName = "$val.txt"                                   
$copyOperation = Start-AzStorageBlobCopy -SrcBlob $blobName `
                                         -SrcContainer $srcContainer `
                                         -Context $srcContext `
                                         -DestBlob $blobName `
                                         -DestContainer $destContainer `
                                         -DestContext $destContext
}