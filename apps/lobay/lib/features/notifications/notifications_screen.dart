import 'package:flutter/material.dart';
                import 'package:lobay/features/notifications/widgets/notification_tile.dart';
                import 'package:lobay/utilities/mixins/device_size_util.dart';
                import 'package:lobay/utilities/text_utils/text_style_utils.dart';
                import 'package:lobay/utilities/theme_utils/app_colors.dart';

                class NotificationsScreen extends StatelessWidget with DeviceSizeUtil {
                  const NotificationsScreen({
                    super.key,
                  });

                  @override
                  Widget build(BuildContext context) {
                    final height = getDeviceHeight();
                    final width = getDeviceWidth();
                    return Scaffold(
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.06,
                              width: width,
                            ),
                            Text(
                              'Notifications',
                              style: TextUtils.getStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              'Stay updated with all games.',
                              style: TextUtils.getStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.grey,
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return const NotificationTile();
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemCount: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }