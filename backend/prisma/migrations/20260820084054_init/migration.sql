-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `passwordHash` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `role` ENUM('ADMIN', 'MANAGER', 'FIELD_OFFICER', 'CASHIER') NOT NULL DEFAULT 'FIELD_OFFICER',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Borrower` (
    `id` VARCHAR(16) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `mobile` VARCHAR(16) NOT NULL,
    `aadhaar` VARCHAR(16) NOT NULL,
    `village` VARCHAR(191) NOT NULL,
    `address` TEXT NOT NULL,
    `pinCode` VARCHAR(8) NOT NULL,
    `joinDate` DATETIME(3) NOT NULL,
    `activeLoans` INTEGER NOT NULL DEFAULT 0,
    `totalOutstanding` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `status` ENUM('active', 'overdue', 'closed') NOT NULL DEFAULT 'active',

    INDEX `Borrower_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Loan` (
    `id` VARCHAR(16) NOT NULL,
    `borrowerId` VARCHAR(16) NOT NULL,
    `borrowerName` VARCHAR(191) NOT NULL,
    `principal` DECIMAL(12, 2) NOT NULL,
    `annualRate` DECIMAL(5, 2) NOT NULL,
    `tenureMonths` INTEGER NOT NULL,
    `frequency` VARCHAR(16) NOT NULL,
    `totalRepayable` DECIMAL(12, 2) NOT NULL,
    `totalPaid` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `paidInstallments` INTEGER NOT NULL DEFAULT 0,
    `totalInstallments` INTEGER NOT NULL,
    `disbursementDate` DATETIME(3) NOT NULL,
    `closedDate` DATETIME(3) NULL,
    `status` ENUM('active', 'closed', 'overdue', 'disbursed') NOT NULL DEFAULT 'disbursed',

    INDEX `Loan_borrowerId_idx`(`borrowerId`),
    INDEX `Loan_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Installment` (
    `id` VARCHAR(16) NOT NULL,
    `loanId` VARCHAR(16) NOT NULL,
    `number` INTEGER NOT NULL,
    `dueDate` DATETIME(3) NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `paidAmount` DECIMAL(12, 2) NULL,
    `paidDate` DATETIME(3) NULL,
    `status` ENUM('paid', 'pending', 'overdue', 'partial', 'advance') NOT NULL DEFAULT 'pending',

    INDEX `Installment_loanId_idx`(`loanId`),
    INDEX `Installment_dueDate_idx`(`dueDate`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CollectionEntry` (
    `id` VARCHAR(16) NOT NULL,
    `borrowerId` VARCHAR(16) NOT NULL,
    `borrowerName` VARCHAR(191) NOT NULL,
    `loanId` VARCHAR(16) NOT NULL,
    `previousDue` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `amountDue` DECIMAL(12, 2) NOT NULL,
    `amountPaid` DECIMAL(12, 2) NULL,
    `dueDate` DATETIME(3) NOT NULL,
    `paidDate` DATETIME(3) NULL,
    `paymentMode` ENUM('cash', 'upi', 'bank') NULL,
    `notes` TEXT NULL,
    `status` ENUM('pending', 'collected', 'overdue', 'partial') NOT NULL DEFAULT 'pending',

    INDEX `CollectionEntry_borrowerId_idx`(`borrowerId`),
    INDEX `CollectionEntry_loanId_idx`(`loanId`),
    INDEX `CollectionEntry_dueDate_idx`(`dueDate`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Payment` (
    `id` VARCHAR(16) NOT NULL,
    `receiptNo` VARCHAR(32) NOT NULL,
    `borrowerId` VARCHAR(16) NOT NULL,
    `borrowerName` VARCHAR(191) NOT NULL,
    `loanId` VARCHAR(16) NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `mode` ENUM('cash', 'upi', 'bank') NOT NULL,
    `notes` TEXT NULL,
    `paidAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Payment_receiptNo_key`(`receiptNo`),
    INDEX `Payment_loanId_idx`(`loanId`),
    INDEX `Payment_borrowerId_idx`(`borrowerId`),
    INDEX `Payment_paidAt_idx`(`paidAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PaymentInstallment` (
    `paymentId` VARCHAR(16) NOT NULL,
    `installmentId` VARCHAR(16) NOT NULL,

    PRIMARY KEY (`paymentId`, `installmentId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Loan` ADD CONSTRAINT `Loan_borrowerId_fkey` FOREIGN KEY (`borrowerId`) REFERENCES `Borrower`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Installment` ADD CONSTRAINT `Installment_loanId_fkey` FOREIGN KEY (`loanId`) REFERENCES `Loan`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CollectionEntry` ADD CONSTRAINT `CollectionEntry_borrowerId_fkey` FOREIGN KEY (`borrowerId`) REFERENCES `Borrower`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CollectionEntry` ADD CONSTRAINT `CollectionEntry_loanId_fkey` FOREIGN KEY (`loanId`) REFERENCES `Loan`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_borrowerId_fkey` FOREIGN KEY (`borrowerId`) REFERENCES `Borrower`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_loanId_fkey` FOREIGN KEY (`loanId`) REFERENCES `Loan`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PaymentInstallment` ADD CONSTRAINT `PaymentInstallment_paymentId_fkey` FOREIGN KEY (`paymentId`) REFERENCES `Payment`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PaymentInstallment` ADD CONSTRAINT `PaymentInstallment_installmentId_fkey` FOREIGN KEY (`installmentId`) REFERENCES `Installment`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
