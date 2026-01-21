import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/backup_state_provider.dart';
import 'package:chkpnt/models/backup_models.dart';

class ProfileBackupSection extends ConsumerWidget {
  const ProfileBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final backupState = ref.watch(backupStateProvider);

    return Container(
      width: double.infinity,
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: EdgeInsets.all(
          isLandscape ? 12 : ProfileStyles.sectionPadding,
        ),
        child: _buildContent(context, ref, isLandscape, backupState),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
    BackupOperationState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppHeadingStyles.gradientHeading(
          'Backup & Restore',
          fontSize: isLandscape ? 14 : 16,
        ),
        SizedBox(height: isLandscape ? 8 : 16),
        _buildStateContent(context, ref, isLandscape, state),
      ],
    );
  }

  Widget _buildStateContent(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
    BackupOperationState state,
  ) {
    return state.when(
      idle: () => _buildIdleState(context, ref, isLandscape),
      selectingDirectory:
          () => _buildLoadingState(
            isLandscape,
            'Selecting backup location...',
            null,
          ),
      selectingFile:
          () =>
              _buildLoadingState(isLandscape, 'Selecting backup file...', null),
      creatingBackup:
          (progress, currentStep, statusMessage) => _buildProgressState(
            isLandscape,
            'Creating Backup',
            progress,
            currentStep,
            statusMessage,
          ),
      restoringBackup:
          (progress, currentStep, statusMessage) => _buildProgressState(
            isLandscape,
            'Restoring Backup',
            progress,
            currentStep,
            statusMessage,
          ),
      validatingBackup:
          (filePath) => _buildLoadingState(
            isLandscape,
            'Validating backup file...',
            null,
          ),
      confirmingRestore:
          (backupFilePath, metadata) => _buildConfirmationState(
            context,
            ref,
            isLandscape,
            backupFilePath,
            metadata,
          ),
      success:
          (message, filePath) =>
              _buildSuccessState(context, ref, isLandscape, message, filePath),
      error:
          (message, code, originalError) =>
              _buildErrorState(context, ref, isLandscape, message),
    );
  }

  Widget _buildIdleState(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create a complete backup of your games library and images, or restore from a previous backup.',
          style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
          maxLines: isLandscape ? 2 : null,
          overflow: isLandscape ? TextOverflow.ellipsis : null,
        ),
        SizedBox(height: isLandscape ? 12 : 16),
        _buildActionButtons(context, ref, isLandscape),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            onPressed:
                () => ref.read(backupStateProvider.notifier).startRestore(),
            icon: Icons.restore_outlined,
            label: 'Restore Backup',
            isLandscape: isLandscape,
          ),
        ),
        SizedBox(width: isLandscape ? 8 : 12),
        Expanded(
          child: _buildActionButton(
            onPressed:
                () => ref.read(backupStateProvider.notifier).startBackup(),
            icon: Icons.backup_outlined,
            label: 'Create Backup',
            isLandscape: isLandscape,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isLandscape,
  }) {
    return SizedBox(
      height: isLandscape ? 40 : 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isLandscape ? 16 : 18, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(
            fontSize: isLandscape ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLandscape ? 8 : 12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 12 : 16,
            vertical: isLandscape ? 8 : 12,
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.lightPurple;
            } else if (states.contains(WidgetState.hovered)) {
              return AppColors.secondaryPurple;
            }
            return AppColors.primaryPurple;
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    bool isLandscape,
    String message,
    String? statusMessage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: isLandscape ? 16 : 20,
              height: isLandscape ? 16 : 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple,
                ),
              ),
            ),
            SizedBox(width: isLandscape ? 8 : 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: isLandscape ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
        if (statusMessage != null) ...[
          SizedBox(height: isLandscape ? 4 : 8),
          Padding(
            padding: EdgeInsets.only(left: isLandscape ? 24 : 32),
            child: Text(
              statusMessage,
              style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressState(
    bool isLandscape,
    String title,
    double progress,
    String currentStep,
    String? statusMessage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isLandscape ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: isLandscape ? 8 : 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.divider,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
          minHeight: isLandscape ? 3 : 4,
        ),
        SizedBox(height: isLandscape ? 4 : 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                currentStep,
                style: TextStyle(
                  fontSize: isLandscape ? 11 : 12,
                  color: AppColors.primaryText.withValues(alpha: 0.8),
                ),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: isLandscape ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        if (statusMessage != null) ...[
          SizedBox(height: isLandscape ? 2 : 4),
          Text(
            statusMessage,
            style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmationState(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
    String backupFilePath,
    BackupMetadata metadata,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Restore',
          style: TextStyle(
            fontSize: isLandscape ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: isLandscape ? 6 : 8),
        Text(
          'This will replace all current data with:',
          style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
        ),
        SizedBox(height: isLandscape ? 4 : 6),
        _buildMetadataInfo(isLandscape, metadata),
        SizedBox(height: isLandscape ? 12 : 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                onPressed: () => ref.read(backupStateProvider.notifier).reset(),
                label: 'Cancel',
                isLandscape: isLandscape,
              ),
            ),
            SizedBox(width: isLandscape ? 8 : 12),
            Expanded(
              child: _buildActionButton(
                onPressed:
                    () => ref
                        .read(backupStateProvider.notifier)
                        .confirmRestore(backupFilePath),
                icon: Icons.restore_outlined,
                label: 'Restore',
                isLandscape: isLandscape,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetadataInfo(bool isLandscape, BackupMetadata metadata) {
    final textStyle = TextStyle(
      fontSize: isLandscape ? 11 : 12,
      color: AppColors.primaryText.withValues(alpha: 0.8),
    );

    return Container(
      padding: EdgeInsets.all(isLandscape ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.collapsibleSection,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Games:', style: textStyle),
              Text('${metadata.gameCount}', style: textStyle),
            ],
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Images:', style: textStyle),
              Text('${metadata.imageCount}', style: textStyle),
            ],
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Created:', style: textStyle),
              Text(
                '${metadata.createdAt.day}/${metadata.createdAt.month}/${metadata.createdAt.year}',
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
    String message,
    String? filePath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_outlined,
              size: isLandscape ? 18 : 20,
              color: AppColors.primaryPurple,
            ),
            SizedBox(width: isLandscape ? 8 : 12),
            Expanded(
              child: Text(
                'Success!',
                style: TextStyle(
                  fontSize: isLandscape ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isLandscape ? 4 : 8),
        Text(
          message,
          style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
        ),
        SizedBox(height: isLandscape ? 12 : 16),
        _buildSecondaryButton(
          onPressed:
              () => ref.read(backupStateProvider.notifier).dismissMessage(),
          label: 'OK',
          isLandscape: isLandscape,
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    bool isLandscape,
    String message,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.error_outline,
              size: isLandscape ? 18 : 20,
              color: Colors.red[600],
            ),
            SizedBox(width: isLandscape ? 8 : 12),
            Expanded(
              child: Text(
                'Error',
                style: TextStyle(
                  fontSize: isLandscape ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isLandscape ? 4 : 8),
        Text(
          message,
          style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
        ),
        SizedBox(height: isLandscape ? 12 : 16),
        _buildSecondaryButton(
          onPressed:
              () => ref.read(backupStateProvider.notifier).dismissMessage(),
          label: 'Dismiss',
          isLandscape: isLandscape,
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required VoidCallback onPressed,
    required String label,
    required bool isLandscape,
  }) {
    return SizedBox(
      height: isLandscape ? 36 : 44,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLandscape ? 8 : 12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 12 : 16,
            vertical: isLandscape ? 8 : 12,
          ),
        ).copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(
                color: AppColors.lightPurple.withValues(alpha: 0.5),
                width: 1,
              );
            } else if (states.contains(WidgetState.hovered)) {
              return BorderSide(
                color: AppColors.secondaryPurple.withValues(alpha: 0.4),
                width: 1,
              );
            }
            return BorderSide(
              color: AppColors.primaryPurple.withValues(alpha: 0.3),
              width: 1,
            );
          }),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isLandscape ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}
