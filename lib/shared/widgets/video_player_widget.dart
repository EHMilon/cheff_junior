import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/themes/app_colors.dart';

/// A reusable video player widget using Chewie and video_player
/// Handles network video URLs with proper lifecycle management
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final double? height;
  final BorderRadius? borderRadius;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.height,
    this.borderRadius,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  /// Initialize the video player with the provided URL
  Future<void> _initializePlayer() async {
    try {
      // Validate URL
      if (widget.videoUrl.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Video URL is empty';
        });
        return;
      }

      // Create video player controller
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      // Initialize the controller
      await _videoPlayerController!.initialize();

      // Create Chewie controller with custom configuration
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        placeholder: widget.thumbnailUrl != null
            ? _buildThumbnailPlaceholder()
            : _buildDefaultPlaceholder(),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.grey300,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.grey300,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        showControls: true,
        showOptions: false,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
        errorBuilder: (context, errorMessage) => _buildErrorWidget(errorMessage),
      );

      // Enable wakelock to prevent screen from sleeping during playback
      _videoPlayerController!.addListener(_onVideoStateChanged);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load video: $e';
        });
      }
    }
  }

  /// Handle video state changes for wakelock management
  void _onVideoStateChanged() {
    if (_videoPlayerController == null) return;

    final isPlaying = _videoPlayerController!.value.isPlaying;
    if (isPlaying) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  /// Build thumbnail placeholder while video loads
  Widget _buildThumbnailPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
        image: DecorationImage(
          image: NetworkImage(widget.thumbnailUrl!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
          color: Colors.black.withValues(alpha: 0.3),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.w,
          ),
        ),
      ),
    );
  }

  /// Build default placeholder when no thumbnail
  Widget _buildDefaultPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
        color: AppColors.grey300,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3.w,
        ),
      ),
    );
  }

  /// Build error widget when video fails to load
  Widget _buildErrorWidget(String? errorMessage) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
        color: AppColors.grey300,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.primary,
              size: 40.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: AppColors.secondary.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_onVideoStateChanged);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error state
    if (_hasError) {
      return _buildErrorWidget(_errorMessage);
    }

    // Show loading state while initializing
    if (!_isInitialized || _chewieController == null) {
      return Container(
        height: widget.height ?? 179.h,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
          color: AppColors.grey300,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.w,
          ),
        ),
      );
    }

    // Show video player
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20.r),
      child: Container(
        height: widget.height ?? 179.h,
        color: Colors.black,
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }
}
