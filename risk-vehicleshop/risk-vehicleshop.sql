-- risk-vehicleshop SQL migration
-- Purpose: ensure ESX owned_vehicles has `spawnname` column used by this resource.

ALTER TABLE `owned_vehicles`
ADD COLUMN IF NOT EXISTS `spawnname` VARCHAR(64) NULL DEFAULT NULL AFTER `job`;

