-- CreateEnum
CREATE TYPE "AssignmentStatus" AS ENUM ('CANCELED', 'COMPLETE', 'EXPIRED', 'OUTSTANDING');

-- CreateEnum
CREATE TYPE "GroupType" AS ENUM ('CLINICAL', 'RESEARCH');

-- CreateEnum
CREATE TYPE "SubjectIdentificationMethod" AS ENUM ('CUSTOM_ID', 'PERSONAL_INFO');

-- CreateEnum
CREATE TYPE "InstrumentKind" AS ENUM ('FORM', 'INTERACTIVE', 'SERIES');

-- CreateEnum
CREATE TYPE "Sex" AS ENUM ('MALE', 'FEMALE');

-- CreateEnum
CREATE TYPE "BasePermissionLevel" AS ENUM ('ADMIN', 'GROUP_MANAGER', 'STANDARD');

-- CreateEnum
CREATE TYPE "AppSubject" AS ENUM ('all', 'Assignment', 'Group', 'Instrument', 'InstrumentRecord', 'Session', 'Subject', 'User');

-- CreateEnum
CREATE TYPE "AppAction" AS ENUM ('create', 'delete', 'manage', 'read', 'update');

-- CreateEnum
CREATE TYPE "SessionType" AS ENUM ('RETROSPECTIVE', 'IN_PERSON', 'REMOTE');

-- CreateTable
CREATE TABLE "EncryptionKeyPair" (
    "id" UUID NOT NULL,
    "publicKey" BYTEA NOT NULL,
    "privateKey" BYTEA NOT NULL,

    CONSTRAINT "EncryptionKeyPair_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssignmentModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" TEXT NOT NULL,
    "completedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "groupId" UUID NOT NULL,
    "instrumentId" UUID NOT NULL,
    "status" "AssignmentStatus" NOT NULL,
    "subjectId" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "encryptionKeyPairId" UUID,

    CONSTRAINT "AssignmentModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ErrorMessage" (
    "id" UUID NOT NULL,
    "en" TEXT,
    "fr" TEXT,

    CONSTRAINT "ErrorMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GroupSettings" (
    "id" UUID NOT NULL,
    "defaultIdentificationMethod" "SubjectIdentificationMethod" NOT NULL,
    "idValidationRegex" TEXT,
    "idValidationRegexErrorMessageId" UUID,

    CONSTRAINT "GroupSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GroupModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" UUID NOT NULL,
    "accessibleInstrumentIds" TEXT[],
    "name" TEXT NOT NULL,
    "settingsId" UUID NOT NULL,
    "subjectIds" TEXT[],
    "type" "GroupType" NOT NULL,
    "userIds" UUID[],

    CONSTRAINT "GroupModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InstrumentRecordModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" UUID NOT NULL,
    "computedMeasures" JSONB,
    "data" JSONB,
    "date" TIMESTAMP(3) NOT NULL,
    "groupId" UUID,
    "subjectId" UUID NOT NULL,
    "instrumentId" UUID NOT NULL,
    "assignmentId" TEXT,
    "sessionId" UUID NOT NULL,

    CONSTRAINT "InstrumentRecordModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InstrumentInternal" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "edition" DOUBLE PRECISION NOT NULL,
    "instrumentId" UUID NOT NULL,

    CONSTRAINT "InstrumentInternal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InstrumentModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" UUID NOT NULL,
    "bundle" TEXT NOT NULL,
    "groupIds" UUID[],

    CONSTRAINT "InstrumentModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubjectModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" UUID NOT NULL,
    "dateOfBirth" TIMESTAMP(3),
    "firstName" TEXT,
    "groupIds" UUID[],
    "lastName" TEXT,
    "sex" "Sex",

    CONSTRAINT "SubjectModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthRule" (
    "id" TEXT NOT NULL,
    "action" "AppAction" NOT NULL,
    "subject" "AppSubject" NOT NULL,

    CONSTRAINT "AuthRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" TEXT NOT NULL,
    "basePermissionLevel" "BasePermissionLevel",
    "firstName" TEXT NOT NULL,
    "groupIds" UUID[],
    "lastName" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "sex" "Sex",
    "dateOfBirth" TIMESTAMP(3),

    CONSTRAINT "UserModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SessionModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" UUID NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "groupId" UUID,
    "subjectId" UUID NOT NULL,
    "type" "SessionType" NOT NULL,

    CONSTRAINT "SessionModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SetupStateModel" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "id" TEXT NOT NULL,
    "isDemo" BOOLEAN NOT NULL,
    "isExperimentalFeaturesEnabled" BOOLEAN,
    "isSetup" BOOLEAN NOT NULL,

    CONSTRAINT "SetupStateModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_AccessibleInstruments" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_GroupModelToSubjectModel" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateTable
CREATE TABLE "_Users" (
    "A" UUID NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_GroupModelToUserModel" (
    "A" UUID NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_AuthRuleToUserModel" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "GroupModel_name_key" ON "GroupModel"("name");

-- CreateIndex
CREATE UNIQUE INDEX "InstrumentRecordModel_assignmentId_key" ON "InstrumentRecordModel"("assignmentId");

-- CreateIndex
CREATE UNIQUE INDEX "_AccessibleInstruments_AB_unique" ON "_AccessibleInstruments"("A", "B");

-- CreateIndex
CREATE INDEX "_AccessibleInstruments_B_index" ON "_AccessibleInstruments"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_GroupModelToSubjectModel_AB_unique" ON "_GroupModelToSubjectModel"("A", "B");

-- CreateIndex
CREATE INDEX "_GroupModelToSubjectModel_B_index" ON "_GroupModelToSubjectModel"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_Users_AB_unique" ON "_Users"("A", "B");

-- CreateIndex
CREATE INDEX "_Users_B_index" ON "_Users"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_GroupModelToUserModel_AB_unique" ON "_GroupModelToUserModel"("A", "B");

-- CreateIndex
CREATE INDEX "_GroupModelToUserModel_B_index" ON "_GroupModelToUserModel"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_AuthRuleToUserModel_AB_unique" ON "_AuthRuleToUserModel"("A", "B");

-- CreateIndex
CREATE INDEX "_AuthRuleToUserModel_B_index" ON "_AuthRuleToUserModel"("B");

-- AddForeignKey
ALTER TABLE "AssignmentModel" ADD CONSTRAINT "AssignmentModel_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "GroupModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentModel" ADD CONSTRAINT "AssignmentModel_instrumentId_fkey" FOREIGN KEY ("instrumentId") REFERENCES "InstrumentModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentModel" ADD CONSTRAINT "AssignmentModel_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "SubjectModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentModel" ADD CONSTRAINT "AssignmentModel_encryptionKeyPairId_fkey" FOREIGN KEY ("encryptionKeyPairId") REFERENCES "EncryptionKeyPair"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GroupSettings" ADD CONSTRAINT "GroupSettings_idValidationRegexErrorMessageId_fkey" FOREIGN KEY ("idValidationRegexErrorMessageId") REFERENCES "ErrorMessage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GroupModel" ADD CONSTRAINT "GroupModel_settingsId_fkey" FOREIGN KEY ("settingsId") REFERENCES "GroupSettings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentRecordModel" ADD CONSTRAINT "InstrumentRecordModel_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "GroupModel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentRecordModel" ADD CONSTRAINT "InstrumentRecordModel_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "SubjectModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentRecordModel" ADD CONSTRAINT "InstrumentRecordModel_instrumentId_fkey" FOREIGN KEY ("instrumentId") REFERENCES "InstrumentModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentRecordModel" ADD CONSTRAINT "InstrumentRecordModel_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "AssignmentModel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentRecordModel" ADD CONSTRAINT "InstrumentRecordModel_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "SessionModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstrumentInternal" ADD CONSTRAINT "InstrumentInternal_instrumentId_fkey" FOREIGN KEY ("instrumentId") REFERENCES "InstrumentModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SessionModel" ADD CONSTRAINT "SessionModel_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "GroupModel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SessionModel" ADD CONSTRAINT "SessionModel_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "SubjectModel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AccessibleInstruments" ADD CONSTRAINT "_AccessibleInstruments_A_fkey" FOREIGN KEY ("A") REFERENCES "GroupModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AccessibleInstruments" ADD CONSTRAINT "_AccessibleInstruments_B_fkey" FOREIGN KEY ("B") REFERENCES "InstrumentModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GroupModelToSubjectModel" ADD CONSTRAINT "_GroupModelToSubjectModel_A_fkey" FOREIGN KEY ("A") REFERENCES "GroupModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GroupModelToSubjectModel" ADD CONSTRAINT "_GroupModelToSubjectModel_B_fkey" FOREIGN KEY ("B") REFERENCES "SubjectModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Users" ADD CONSTRAINT "_Users_A_fkey" FOREIGN KEY ("A") REFERENCES "GroupModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_Users" ADD CONSTRAINT "_Users_B_fkey" FOREIGN KEY ("B") REFERENCES "UserModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GroupModelToUserModel" ADD CONSTRAINT "_GroupModelToUserModel_A_fkey" FOREIGN KEY ("A") REFERENCES "GroupModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GroupModelToUserModel" ADD CONSTRAINT "_GroupModelToUserModel_B_fkey" FOREIGN KEY ("B") REFERENCES "UserModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AuthRuleToUserModel" ADD CONSTRAINT "_AuthRuleToUserModel_A_fkey" FOREIGN KEY ("A") REFERENCES "AuthRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AuthRuleToUserModel" ADD CONSTRAINT "_AuthRuleToUserModel_B_fkey" FOREIGN KEY ("B") REFERENCES "UserModel"("id") ON DELETE CASCADE ON UPDATE CASCADE;
