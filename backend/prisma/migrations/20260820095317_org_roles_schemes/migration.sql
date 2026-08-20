-- AlterTable
ALTER TABLE `borrower` ADD COLUMN `areaId` VARCHAR(16) NULL;

-- CreateTable
CREATE TABLE `Area` (
    `id` VARCHAR(16) NOT NULL,
    `code` VARCHAR(16) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT true,

    UNIQUE INDEX `Area_code_key`(`code`),
    INDEX `Area_active_idx`(`active`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Employee` (
    `id` VARCHAR(16) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `mobile` VARCHAR(16) NOT NULL,
    `areaId` VARCHAR(16) NULL,
    `status` ENUM('active', 'onField', 'office') NOT NULL DEFAULT 'active',
    `joinDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `Employee_areaId_idx`(`areaId`),
    INDEX `Employee_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Role` (
    `id` VARCHAR(16) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `isSystem` BOOLEAN NOT NULL DEFAULT false,

    UNIQUE INDEX `Role_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Permission` (
    `id` VARCHAR(16) NOT NULL,
    `key` VARCHAR(64) NOT NULL,
    `label` VARCHAR(191) NOT NULL,
    `group` VARCHAR(64) NOT NULL,

    UNIQUE INDEX `Permission_key_key`(`key`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RolePermission` (
    `roleId` VARCHAR(16) NOT NULL,
    `permissionId` VARCHAR(16) NOT NULL,
    `granted` BOOLEAN NOT NULL DEFAULT false,

    PRIMARY KEY (`roleId`, `permissionId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LoanScheme` (
    `id` VARCHAR(16) NOT NULL,
    `code` VARCHAR(16) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT true,
    `principalMin` DECIMAL(12, 2) NOT NULL,
    `principalMax` DECIMAL(12, 2) NOT NULL,
    `tenureMin` INTEGER NOT NULL,
    `tenureMax` INTEGER NOT NULL,
    `tenureUnit` VARCHAR(16) NOT NULL,
    `frequency` VARCHAR(16) NOT NULL,

    UNIQUE INDEX `LoanScheme_code_key`(`code`),
    INDEX `LoanScheme_active_idx`(`active`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `Borrower_areaId_idx` ON `Borrower`(`areaId`);

-- AddForeignKey
ALTER TABLE `Borrower` ADD CONSTRAINT `Borrower_areaId_fkey` FOREIGN KEY (`areaId`) REFERENCES `Area`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Employee` ADD CONSTRAINT `Employee_areaId_fkey` FOREIGN KEY (`areaId`) REFERENCES `Area`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RolePermission` ADD CONSTRAINT `RolePermission_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `Role`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RolePermission` ADD CONSTRAINT `RolePermission_permissionId_fkey` FOREIGN KEY (`permissionId`) REFERENCES `Permission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
