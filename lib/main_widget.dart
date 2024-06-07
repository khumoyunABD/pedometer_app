// import 'package:flutterflow_ui/flutterflow_ui.dart';

// // import '/flutter_flow/flutter_flow_theme.dart';
// // import '/flutter_flow/flutter_flow_util.dart';
// // import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:provider/provider.dart';

// import 'main_model.dart';
// export 'main_model.dart';

// class MainWidget extends StatefulWidget {
//   const MainWidget({super.key});

//   @override
//   State<MainWidget> createState() => _MainWidgetState();
// }

// class _MainWidgetState extends State<MainWidget> {
//   late MainModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => MainModel());
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _model.unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                 child: Container(
//                   width: double.infinity,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     color: FlutterFlowTheme.of(context).secondaryBackground,
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 3,
//                         color: Color(0x33000000),
//                         offset: Offset(
//                           0,
//                           1,
//                         ),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
//                     child: Text(
//                       'Welcome,',
//                       style:
//                           FlutterFlowTheme.of(context).headlineLarge.override(
//                                 fontFamily: 'Outfit',
//                                 letterSpacing: 0,
//                               ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
//                 child: Material(
//                   color: Colors.transparent,
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     height: 310,
//                     decoration: BoxDecoration(
//                       color: FlutterFlowTheme.of(context).secondaryBackground,
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: 3,
//                           color: Color(0x33000000),
//                           offset: Offset(
//                             0,
//                             1,
//                           ),
//                           spreadRadius: 0,
//                         )
//                       ],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Pedometer',
//                             style: FlutterFlowTheme.of(context)
//                                 .headlineSmall
//                                 .override(
//                                   fontFamily: 'Outfit',
//                                   letterSpacing: 0,
//                                 ),
//                           ),
//                           Padding(
//                             padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                             child: Text(
//                               'Track your steps and stay active.',
//                               style: FlutterFlowTheme.of(context)
//                                   .labelMedium
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     letterSpacing: 0,
//                                   ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                             child: Container(
//                               width: double.infinity,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: FlutterFlowTheme.of(context)
//                                     .secondaryBackground,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     24, 0, 24, 0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     Icon(
//                                       Icons.directions_walk_rounded,
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondary,
//                                       size: 32,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Steps Taken',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .labelMedium
//                                                 .override(
//                                                   fontFamily: 'Outfit',
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 8, 0, 0),
//                                             child: Text(
//                                               '10,000',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .displaySmall
//                                                       .override(
//                                                         fontFamily: 'Outfit',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                             child: Container(
//                               width: double.infinity,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: FlutterFlowTheme.of(context)
//                                     .secondaryBackground,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     24, 0, 24, 0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     Icon(
//                                       Icons.directions_run_rounded,
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondary,
//                                       size: 32,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Distance',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .labelMedium
//                                                 .override(
//                                                   fontFamily: 'Outfit',
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 8, 0, 0),
//                                             child: Text(
//                                               '5.2 km',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .displaySmall
//                                                       .override(
//                                                         fontFamily: 'Outfit',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                             child: Container(
//                               width: double.infinity,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: FlutterFlowTheme.of(context)
//                                     .secondaryBackground,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: FlutterFlowTheme.of(context).alternate,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     24, 0, 24, 0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     Icon(
//                                       Icons.timer_rounded,
//                                       color: FlutterFlowTheme.of(context)
//                                           .secondary,
//                                       size: 32,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Active Time',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .labelMedium
//                                                 .override(
//                                                   fontFamily: 'Outfit',
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     0, 8, 0, 0),
//                                             child: Text(
//                                               '1h 30m',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .displaySmall
//                                                       .override(
//                                                         fontFamily: 'Outfit',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
//                 child: Material(
//                   color: Colors.transparent,
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     height: 260,
//                     decoration: BoxDecoration(
//                       color: FlutterFlowTheme.of(context).secondaryBackground,
//                       boxShadow: [
//                         BoxShadow(
//                           blurRadius: 3,
//                           color: Color(0x33000000),
//                           offset: Offset(
//                             0,
//                             1,
//                           ),
//                           spreadRadius: 0,
//                         )
//                       ],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
//                             child: Text(
//                               'Appointments',
//                               style: FlutterFlowTheme.of(context)
//                                   .headlineSmall
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     letterSpacing: 0,
//                                   ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
//                             child: Text(
//                               'Your upcoming appointments are below.',
//                               style: FlutterFlowTheme.of(context)
//                                   .labelMedium
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     letterSpacing: 0,
//                                   ),
//                             ),
//                           ),
//                           Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 0, 16, 1),
//                                 child: Container(
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         blurRadius: 0,
//                                         color: FlutterFlowTheme.of(context)
//                                             .alternate,
//                                         offset: Offset(
//                                           0,
//                                           1,
//                                         ),
//                                         spreadRadius: 0,
//                                       )
//                                     ],
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         8, 12, 8, 12),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: [
//                                         Container(
//                                           width: 36,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                             color: FlutterFlowTheme.of(context)
//                                                 .primary,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           alignment: AlignmentDirectional(0, 0),
//                                           child: Text(
//                                             'A',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .bodyMedium
//                                                 .override(
//                                                   fontFamily:
//                                                       'Plus Jakarta Sans',
//                                                   color: Colors.white,
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     12, 0, 0, 0),
//                                             child: Text(
//                                               'List Item',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyLarge
//                                                       .override(
//                                                         fontFamily:
//                                                             'Plus Jakarta Sans',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           '5:30pm',
//                                           style: FlutterFlowTheme.of(context)
//                                               .labelMedium
//                                               .override(
//                                                 fontFamily: 'Outfit',
//                                                 letterSpacing: 0,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 0, 16, 1),
//                                 child: Container(
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         blurRadius: 0,
//                                         color: FlutterFlowTheme.of(context)
//                                             .alternate,
//                                         offset: Offset(
//                                           0,
//                                           1,
//                                         ),
//                                         spreadRadius: 0,
//                                       )
//                                     ],
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         8, 12, 8, 12),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: [
//                                         Container(
//                                           width: 36,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                             color: FlutterFlowTheme.of(context)
//                                                 .primary,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           alignment: AlignmentDirectional(0, 0),
//                                           child: Text(
//                                             'A',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .bodyMedium
//                                                 .override(
//                                                   fontFamily:
//                                                       'Plus Jakarta Sans',
//                                                   color: Colors.white,
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     12, 0, 0, 0),
//                                             child: Text(
//                                               'List Item',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyLarge
//                                                       .override(
//                                                         fontFamily:
//                                                             'Plus Jakarta Sans',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           '5:30pm',
//                                           style: FlutterFlowTheme.of(context)
//                                               .labelMedium
//                                               .override(
//                                                 fontFamily: 'Outfit',
//                                                 letterSpacing: 0,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsetsDirectional.fromSTEB(
//                                     16, 0, 16, 1),
//                                 child: Container(
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: FlutterFlowTheme.of(context)
//                                         .secondaryBackground,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         blurRadius: 0,
//                                         color: FlutterFlowTheme.of(context)
//                                             .alternate,
//                                         offset: Offset(
//                                           0,
//                                           1,
//                                         ),
//                                         spreadRadius: 0,
//                                       )
//                                     ],
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         8, 12, 8, 12),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: [
//                                         Container(
//                                           width: 36,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                             color: FlutterFlowTheme.of(context)
//                                                 .primary,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           alignment: AlignmentDirectional(0, 0),
//                                           child: Text(
//                                             'A',
//                                             style: FlutterFlowTheme.of(context)
//                                                 .bodyMedium
//                                                 .override(
//                                                   fontFamily:
//                                                       'Plus Jakarta Sans',
//                                                   color: Colors.white,
//                                                   letterSpacing: 0,
//                                                 ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding:
//                                                 EdgeInsetsDirectional.fromSTEB(
//                                                     12, 0, 0, 0),
//                                             child: Text(
//                                               'List Item',
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyLarge
//                                                       .override(
//                                                         fontFamily:
//                                                             'Plus Jakarta Sans',
//                                                         letterSpacing: 0,
//                                                       ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           '5:30pm',
//                                           style: FlutterFlowTheme.of(context)
//                                               .labelMedium
//                                               .override(
//                                                 fontFamily: 'Outfit',
//                                                 letterSpacing: 0,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
//                 child: Material(
//                   color: Colors.transparent,
//                   elevation: 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: FlutterFlowTheme.of(context).secondaryBackground,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                             child: Text(
//                               'Activity',
//                               style: FlutterFlowTheme.of(context)
//                                   .headlineSmall
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     letterSpacing: 0,
//                                   ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(12, 4, 0, 0),
//                             child: Text(
//                               'Your overall activity is below.',
//                               style: FlutterFlowTheme.of(context)
//                                   .labelMedium
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     letterSpacing: 0,
//                                   ),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                             child: Container(
//                               width: double.infinity,
//                               height: 260,
//                               decoration: BoxDecoration(
//                                 color: FlutterFlowTheme.of(context)
//                                     .primaryBackground,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               alignment: AlignmentDirectional(0, 0),
//                               child: Text(
//                                 'Remove this and place chart here.',
//                                 style: FlutterFlowTheme.of(context)
//                                     .bodyMedium
//                                     .override(
//                                       fontFamily: 'Plus Jakarta Sans',
//                                       letterSpacing: 0,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
