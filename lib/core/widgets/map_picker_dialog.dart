import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/app_toast.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'custom_button.dart';

class MapPickerDialog extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerDialog({super.key, this.initialLocation});

  @override
  State<MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<MapPickerDialog> {
  late final MapController _mapController;
  LatLng? _selectedLocation;

  // Iraq Bounds
  final LatLngBounds _iraqBounds = LatLngBounds(
    const LatLng(29.0, 38.8), // South-West
    const LatLng(37.5, 48.6), // North-East
  );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'حدد الموقع على الخريطة',
                  style: AppFontStyle.regular20(context).copyWith(color: AppColors.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.initialLocation ?? const LatLng(33.3128, 44.3615),
                    initialZoom: 6.5,
                    onTap: (tapPosition, point) {
                      if (_iraqBounds.contains(point)) {
                        setState(() {
                          _selectedLocation = point;
                        });
                      } else {
                        ShowToast.showError(messageTitle: 'يرجى اختيار موقع داخل حدود العراق');
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.atoz.new_admin',
                    ),
                    MarkerLayer(
                      markers: [
                        if (_selectedLocation != null)
                          Marker(
                            point: _selectedLocation!,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'إلغاء',
                    borderColor: AppColors.primary,
                    backGroundColor: AppColors.white,
                    titleStyle: AppFontStyle.regular14(context).copyWith(color: AppColors.primary),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    title: 'تأكيد الموقع',
                    backGroundColor: AppColors.primary,
                    onTap: () {
                      if (_selectedLocation == null) {
                        ShowToast.showError(messageTitle: 'يرجى تحديد الموقع على الخريطة أولاً');
                        return;
                      }
                      Navigator.pop(context, _selectedLocation);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
