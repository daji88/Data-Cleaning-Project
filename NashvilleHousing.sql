--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--

--Skills used : CONVERT, UPDATE, JOINS, CASE STATEMENTS & CTE

-- Cleaning Data in SQL --

SELECT *
FROM [Portfolio Project - 2].dbo.NashvilleHousing
WHERE PropertyAddress is not null

--Standardize Date Format --

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM [Portfolio Project - 2].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

-- Populate Property Address Data, Removes nulls & update property address column --

SELECT *
FROM [Portfolio Project - 2].dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project - 2].dbo.NashvilleHousing a
JOIN [Portfolio Project - 2].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project - 2].dbo.NashvilleHousing a
JOIN [Portfolio Project - 2].dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking out address into Different columns based on Street Address & City --

SELECT PropertyAddress
FROM [Portfolio Project - 2].dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM [Portfolio Project - 2].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD StreetAddress Nvarchar(255)

UPDATE NashvilleHousing
SET StreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD City Nvarchar(255)

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM [Portfolio Project - 2].dbo.NashvilleHousing

-- Splitting Owner Address into Stree, City, State --


SELECT OwnerAddress
FROM [Portfolio Project - 2].dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)
FROM [Portfolio Project - 2].dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD StreetAddress1 Nvarchar(255)

UPDATE NashvilleHousing
SET StreetAddress1 = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
ADD City1 Nvarchar(255)

UPDATE NashvilleHousing
SET City1 = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD StateName Nvarchar(255)

UPDATE NashvilleHousing
SET StateName = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)

Select * 
From [Portfolio Project - 2].dbo.NashvilleHousing


-- Changing Y & N to Yes & No --

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project - 2].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 end
From [Portfolio Project - 2].dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						ELSE SoldAsVacant
						end

-- Remove Duplicates --

WITH ROwNumCTE as (

Select *,
	ROW_NUMBER() OVER(
	Partition by ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueId
					) row_num

From [Portfolio Project - 2].dbo.NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM ROwNumCTE
where row_num > 1
order by PropertyAddress

-- DELETE unused columns --

Select *
From [Portfolio Project - 2].dbo.NashvilleHousing

ALTER TABLE [Portfolio Project - 2].dbo.NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict, OwnerAddress


ALTER TABLE [Portfolio Project - 2].dbo.NashvilleHousing
DROP COLUMN SaleDate


--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--*/*-------*/*--