import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thumbnail_youtube/lib.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData theme({required bool dark}) {
  MaterialColor fgColor = dark ? textColorDark : textColorLight;
  MaterialColor bgColor = dark ? textColorLight : textColorDark;

  final TextStyle ts = GoogleFonts.inter(letterSpacing: 0.7.r, color: fgColor);
  Color colorFill = bgColor[dark ? 800 : 300]!;
  Color colorForePrimary = fgColor[!dark ? 800 : 300]!;
  Color colorFore = fgColor[!dark ? 700 : 400]!;

  //   Color appbarColor = textColorLight.shade700.transform(!dark);
  ColorScheme colorSchemeDark = ColorScheme.dark(
    //
    primary: primaryColor,
    error: errorColor,
    surface: bgColor,
    brightness: Brightness.dark,
    onPrimary: colorForePrimary,
    onSurface: colorFore,
  );
  ColorScheme colorSchemeLight = ColorScheme.light(
    //
    primary: primaryColorLight,
    error: errorColor,
    surface: bgColor,
    brightness: Brightness.light,
    onPrimary: colorForePrimary,
    onSurface: colorFore,
  );
  ColorScheme colorScheme = dark ? colorSchemeDark : colorSchemeLight;
  IconThemeData iconTheme = IconThemeData(
    color: fgColor,
    weight: 500,
    fill: 0.4,
    shadows: <Shadow>[BoxShadow(color: bgColor.withAlpha(128))],
    opticalSize: 64,
  );
  //   TextTheme textTheme = GoogleFonts.interTextTheme();
  TextTheme textTheme = TextTheme(
    // Body
    bodySmall /*$*****/ : ts.copyWith(fontSize: 09.spMin, fontWeight: FontWeight.bold, color: ts.color?.contrast(-30, dark)),
    bodyMedium
    /******/
    : ts.copyWith(
      fontSize: 11.spMin,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge /*$*****/ : ts.copyWith(fontSize: 18.spMin),
    // Labels   ***********************************************************************************
    labelSmall /*$****/ : ts.copyWith(fontSize: 11.spMin),
    labelMedium
    /*****/
    : ts.copyWith(
      fontSize: 14.spMin,
    ),
    labelLarge /*$****/ : ts.copyWith(fontSize: 18.spMin),
    // Labels    ***********************************************************************************
    displaySmall /*$**/ : ts.copyWith(fontSize: 16.spMin),
    displayMedium
    /***/
    : ts.copyWith(
      fontSize: 24.spMin,
    ),
    displayLarge /*$**/ : ts.copyWith(fontSize: 32.spMin),
    // Titles   ***********************************************************************************
    titleSmall /*$****/ : ts.copyWith(fontSize: 20.spMin),
    titleMedium
    /*****/
    : ts.copyWith(
      fontSize: 18.spMin,
    ),
    titleLarge /*$****/ : ts.copyWith(fontSize: 16.spMin),
    // Headlines   ***********************************************************************************
    headlineSmall /*$*/ : ts.copyWith(fontSize: 12.spMin),
    headlineMedium /**/ : ts.copyWith(fontSize: 14.spMin),
    headlineLarge /*$*/ : ts.copyWith(fontSize: 18.spMin),
  );
  double maxWidth = Platform.isAndroid || Platform.isIOS || Platform.isFuchsia ? double.maxFinite : 600.0;
  WidgetStateProp<double> elevationButton = WidgetStateProp<double>((Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) return 5.0;
    if (states.contains(WidgetState.disabled)) return 0.0;
    if (states.contains(WidgetState.pressed)) return 0.0;
    if (states.contains(WidgetState.selected)) return 0.0;
    return 3.0;
  });
  // Button
  WidgetStatePropertyAll<Size> maxSizeButton = WidgetStatePropertyAll<Size>(Size(maxWidth, 200));
  //
  WidgetStatePropertyAll<EdgeInsets> paddingButton = WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(12.0.r));
  //
  WidgetStateProp<RoundedRectangleBorder> shapeButton = WidgetStateProp<RoundedRectangleBorder>((Set<WidgetState> states) {
    bool enabled = !states.contains(WidgetState.disabled);
    bool hovered = states.contains(WidgetState.hovered);
    return RoundedRectangleBorder(
      side: (Set<WidgetState> states) {
        if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) return BorderSide.none;
        if (hovered && enabled) {
          return BorderSide.none;
        } else if (!enabled) {
          return BorderSide(color: Colors.grey.contrast(dark ? -20 : -40, dark), width: 1.0);
        } else {
          return BorderSide(color: dark ? Colors.white : colorScheme.primary, width: 2.0.r);
        }
      }(states),
      borderRadius: BorderRadius.circular(8.r),
    );
  });
  //
  WidgetStateProperty<Color> foreGroundButton = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    bool enabled = !states.contains(WidgetState.disabled);
    bool hovered = states.contains(WidgetState.hovered);
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) return !enabled ? colorFore : Colors.white;
    if (hovered && enabled) {
      return Colors.white;
    } else if (!enabled) {
      return fgColor.contrast(dark ? -20 : -40, dark);
    } else {
      return dark ? Colors.white : colorScheme.primary;
    }
  });
  //
  WidgetStateProperty<Color> bgFilledButton = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    bool enabled = !states.contains(WidgetState.disabled);
    bool hovered = states.contains(WidgetState.hovered);
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) return enabled ? colorScheme.primary : Color(0x819E9E9E);
    if (hovered && enabled) {
      return colorScheme.primary;
    } else if (!enabled) {
      return Colors.grey.contrast(dark ? 20 : 40, dark).withAlpha((0.3 * 255).toInt());
    } else {
      return bgColor;
    }
  });
  //
  FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStatePropertyAll<Color>(fgColor.withAlpha((.35 * 255).toInt())),
      backgroundColor: bgFilledButton,
      foregroundColor: foreGroundButton,
      textStyle: WidgetStatePropertyAll<TextStyle>(ts.copyWith(color: fgColor, fontSize: 18.spMin)),
      maximumSize: maxSizeButton,
      elevation: elevationButton,
      padding: paddingButton,
      shape: shapeButton,
      alignment: Alignment.center,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.comfortable,
    brightness: dark ? Brightness.dark : Brightness.light,

    adaptations: null,
    fontFamilyFallback: null,
    package: null,

    //COLORS
    cardColor: bgColor,
    scaffoldBackgroundColor: bgColor,
    colorScheme: colorScheme,
    colorSchemeSeed: null,
    hintColor: null,
    focusColor: null,
    hoverColor: null,
    splashColor: null,
    canvasColor: null,
    dividerColor: null,
    disabledColor: null,
    highlightColor: null,
    secondaryHeaderColor: null,
    unselectedWidgetColor: null,
    applyElevationOverlayColor: null,
    shadowColor: fgColor.withAlpha((.35 * 255).toInt()),
    // PALETTE START
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    primaryColorLight: primaryColorLight,
    primarySwatch: primaryColor,
    // PALETTE END
    //
    cardTheme: CardThemeData(color: bgColor, elevation: 8, shadowColor: fgColor.withAlpha((.35 * 255).toInt()), shape: Border()),
    // TEXT START
    textTheme: textTheme,
    iconTheme: iconTheme,
    primaryTextTheme: textTheme,
    primaryIconTheme: iconTheme,
    typography: Typography(platform: TargetPlatform.iOS),

    // TEXT END
    expansionTileTheme: ExpansionTileThemeData(
      textColor: fgColor,
      iconColor: fgColor,
      collapsedTextColor: fgColor.contrast(20, dark),
      collapsedIconColor: fgColor,
      backgroundColor: bgColor.contrast(20, dark),
      collapsedBackgroundColor: bgColor.contrast(10, dark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: bgColor.contrast(10, dark),
      iconColor: fgColor,
      style: ListTileStyle.list,
      subtitleTextStyle: TextStyle(color: fgColor, fontStyle: FontStyle.italic),
      titleTextStyle: TextStyle(color: fgColor),
    ),

    // BUTTONS
    filledButtonTheme: filledButtonThemeData,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    buttonTheme: ButtonThemeData(
      minWidth: 250,
      alignedDropdown: true,
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(12.r),
      shape: Border.all(),
      // foregroundColor: foreGroundButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: filledButtonThemeData.style),
    menuButtonTheme: MenuButtonThemeData(),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: filledButtonThemeData.style,
      selectedIcon: Icon(Icons.verified, color: Colors.white),
    ),
    toggleButtonsTheme: null,
    floatingActionButtonTheme: null,

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: fgColor),
        gapPadding: 10.r,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Color(0xff5EDE99)),
        gapPadding: 10.r,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: errorColor.shade200),
        gapPadding: 10.r,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: fgColor),
        gapPadding: 10.r,
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey),
        gapPadding: 10.r,
      ),
      suffixIconColor: fgColor,
      //   filled: true,
      constraints: BoxConstraints(maxWidth: maxWidth),
      //   fillColor: colorFill,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
      focusColor: errorColor.shade800,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: errorColor.shade800),
        gapPadding: 10.r,
      ),
      labelStyle: TextStyle(color: colorForePrimary, fontSize: 16.spMin),
      hintStyle: TextStyle(fontSize: 14.spMin, color: colorFore),
    ),
    timePickerTheme: TimePickerThemeData(elevation: 0),
    datePickerTheme: DatePickerThemeData(
      todayBackgroundColor: WidgetStatePropertyAll<Color>(primaryColor),
      dayStyle: TextStyle(fontSize: 11.spMin),
      yearStyle: TextStyle(fontSize: 13.spMin),
      weekdayStyle: TextStyle(fontSize: 13.spMin),
      confirmButtonStyle: ButtonStyle(textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 19.spMin))),
      headerHelpStyle: TextStyle(fontSize: 12.spMin),
      headerHeadlineStyle: TextStyle(fontSize: 12.spMin),
      cancelButtonStyle: ButtonStyle(textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 16.spMin))),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: ts.copyWith(fontSize: 13.r),
      inputDecorationTheme: InputDecorationTheme(filled: false),
    ),

    // Material
    appBarTheme: AppBarTheme(
      //   color: appbarColor,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(color: fgColor.contrast(50, dark), fontSize: 20.sw, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: fgColor, weight: 900, fill: 1, opticalSize: 96),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: textTheme.bodyMedium,
    ),
    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: fgColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(borderRadius: BorderRadius.circular(0)),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(elevation: 0),
    drawerTheme: DrawerThemeData(width: Platform.isAndroid || Platform.isIOS || Platform.isFuchsia ? 304.r : 400),

    // Messages && Dialogs
    badgeTheme: BadgeThemeData(
      backgroundColor: errorColor.shade800,
      smallSize: 12.r,
      padding: EdgeInsets.all(4.r),
      textColor: Colors.white,
      textStyle: TextStyle(fontSize: 14.spMin, color: Colors.white),
    ),
    dialogTheme: DialogThemeData(backgroundColor: Colors.transparent, elevation: 0, shape: RoundedRectangleBorder()),
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(color: fgColor, fontSize: 16.spMin),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colorFill,
        border: Border.all(color: fgColor.contrast(30, dark), width: 2),
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor.contrast((dark ? -1 : 1) * 20, dark),
      actionTextColor: fgColor,
      actionBackgroundColor: bgColor.contrast((dark ? -1 : 1) * 5, dark),
      closeIconColor: fgColor,
      width: (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) ? double.maxFinite : 400,
      showCloseIcon: true,
      contentTextStyle: TextStyle(color: fgColor, fontSize: 14.spMin),
    ),

    // OTHERS

    // buttonBarTheme: null,
    bannerTheme: MaterialBannerThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(),
    bottomSheetTheme: null,
    checkboxTheme: null,
    chipTheme: null,
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(applyThemeToAll: true),
    dataTableTheme: null,
    dividerTheme: null,
    extensions: null,
    materialTapTargetSize: null,
    menuBarTheme: null,
    menuTheme: null,
    navigationBarTheme: null,
    navigationDrawerTheme: null,
    navigationRailTheme: null,
    pageTransitionsTheme: null,
    platform: null,
    popupMenuTheme: null,
    progressIndicatorTheme: null,
    radioTheme: null,
    scrollbarTheme: null,
    searchBarTheme: null,
    searchViewTheme: null,
    sliderTheme: null,
    splashFactory: null,
    switchTheme: null,
    textSelectionTheme: null,
  );
}

class WidgetStateProp<T> extends WidgetStateProperty<T> {
  WidgetStateProp(this.resolveAs);
  final T Function(Set<WidgetState> states) resolveAs;
  @override
  T resolve(Set<WidgetState> states) => resolveAs(states);
}

//
