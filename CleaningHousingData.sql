Select * 
From PortfolioProject..NashvilleHousing$

-- Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..NashvilleHousing$

Alter Table NashvilleHousing$
Add SaleDateConverted Date;

Update NashvilleHousing$
SET SaleDateConverted = Convert (date, SaleDate)

-- Populate Property Address data

Select PropertyAddress 
From PortfolioProject..NashvilleHousing$
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing$ a
JOIN PortfolioProject..NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing$ a
JOIN PortfolioProject..NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing$
--where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))  as Address
From PortfolioProject..NashvilleHousing$

Alter Table NashvilleHousing$
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing$
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

Select *
FROM PortfolioProject..NashvilleHousing$




Select OwnerAddress
FROM PortfolioProject..NashvilleHousing$

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject..NashvilleHousing$


Alter Table NashvilleHousing$
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table NashvilleHousing$
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table NashvilleHousing$
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Select *
FROM PortfolioProject..NashvilleHousing$


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing$
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, Case WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant ='N' then 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProject..NashvilleHousing$

Update NashvilleHousing$
SET SoldAsVacant =  Case WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant ='N' then 'No'
		ELSE SoldAsVacant
		END


-- Remove Duplicates

WITH RowNumCTE as(
SELECT *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) row_num

FROM PortfolioProject..NashvilleHousing$
--order by ParcelID
)
Select *
-- DELETE to remove duplicates
FROM RowNumCTE
Where row_num > 1
--Order by PropertyAddress

Select *
FROM PortfolioProject..NashvilleHousing$


-- Delete Unused Columns

Select *
FROM PortfolioProject..NashvilleHousing$

Alter TABLE PortfolioProject..NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


Alter TABLE PortfolioProject..NashvilleHousing$
DROP COLUMN SaleDate