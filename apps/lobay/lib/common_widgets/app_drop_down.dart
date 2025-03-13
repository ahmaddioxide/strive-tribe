import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lobay/utilities/mixins/device_size_util.dart';
import 'package:lobay/utilities/theme_utils/app_colors.dart';

class AppDropDown extends StatefulWidget {
  final List<String> options;
  final String hint;
  final RxString selectedValue;

  const AppDropDown(
      {super.key,
      required this.options,
      required this.hint,
      required this.selectedValue});

  @override
  _AppDropDownState createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> with DeviceSizeUtil {
  late double width;
  late double height;

  @override
  void initState() {
    // TODO: implement initState
    width = getDeviceWidth();
    height = getDeviceHeight();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.061,
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<String>(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        borderRadius: BorderRadius.circular(10.0),
        elevation: 8,
        dropdownColor: AppColors.white,
        disabledHint: Text(widget.hint),
        hint: Text(widget.hint),
        value: widget.selectedValue.value,
        onChanged: (String? newValue) {
          setState(
            () {
              widget.selectedValue.value = newValue!;
            },
          );
        },
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }
}
