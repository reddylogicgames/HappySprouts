// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/blackboard/blackboard_dialog.dart';
import 'package:sharezone/blackboard/blackboard_item.dart';
import 'package:sharezone/blackboard/blackboard_view.dart';
import 'package:sharezone/blackboard/details/blackboard_item_read_by_users_list/blackboard_item_read_by_users_list_page.dart';
import 'package:sharezone/comments/comments_gateway.dart';
import 'package:sharezone/comments/widgets/comment_section_builder.dart';
import 'package:sharezone/filesharing/dialog/attachment_list.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone/widgets/material/bottom_action_bar.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../show_delete_blackboard_item_dialog.dart';
import 'blackboard_details_bloc.dart';

enum BlackboardPopOption { deleted, edited, added }

Color? getAppBarIconColor(bool hasPhoto) => hasPhoto ? Colors.white : null;

void onEdit(BuildContext context, BlackboardItem blackboardItem) {
  Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder:
          (context) =>
              BlackboardDialog(blackboardItem: blackboardItem, popTwice: true),
      settings: const RouteSettings(name: BlackboardDialog.tag),
    ),
  );
}

List<Widget> _actions(BlackboardView view) => [
  ReportIcon(item: ReportItemReference.blackboard(view.id)),
  if (view.hasPermissionToEdit) ...[
    _EditIcon(view: view),
    _DeleteIcon(view: view),
  ],
];

const _kFabHalfSize = 28.0;

class BlackboardDetails extends StatefulWidget {
  BlackboardDetails({super.key, required this.view}) : id = view.id;
  BlackboardDetails.loadId(this.id, {super.key})
    : view = BlackboardView.empty(id: id);

  static const tag = "blackboard-details-page";
  final BlackboardView view;
  final String id;

  @override
  State createState() => _BlackboardDetailsState();
}

class _BlackboardDetailsState extends State<BlackboardDetails> {
  late BlackboardDetailsBloc bloc;

  @override
  void initState() {
    super.initState();

    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = BlackboardDetailsBloc(
      api.blackboard,
      widget.id,
      api.uID,
      api.course,
    );

    if (!widget.view.isAuthor && !widget.view.isRead) markItemAsRead();
  }

  void markItemAsRead() => bloc.changeReadStatus(true);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<BlackboardView>(
        initialData: widget.view,
        stream: bloc.view,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Details"),
                leading: const CloseIconButton(),
              ),
              body: const Center(child: AccentColorCircularProgressIndicator()),
            );
          }

          final dimensions = Dimensions.fromMediaQuery(context);
          final view = snapshot.data ?? widget.view;
          return Scaffold(
            appBar:
                !view.hasPhoto
                    ? AppBar(
                      title: const Text("Details"),
                      centerTitle: dimensions.isDesktopModus,
                      leading: CloseIconButton(
                        color: getAppBarIconColor(view.hasPhoto),
                      ),
                      actions: _actions(view),
                    )
                    : null,
            body:
                view.hasPhoto
                    ? _PageWithPicture(view)
                    : SingleChildScrollView(child: _Body(view)),
            bottomNavigationBar:
                view.isAuthor
                    ? null
                    : _BottomBlackboardDetailsIsReadActionButton(
                      hasUserReadItem: view.isRead,
                    ),
          );
        },
      ),
    );
  }
}

class _BottomBlackboardDetailsIsReadActionButton extends StatelessWidget {
  const _BottomBlackboardDetailsIsReadActionButton({
    required this.hasUserReadItem,
  });

  final bool hasUserReadItem;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlackboardDetailsBloc>(context);
    return BottomActionBar(
      onTap: () {
        bloc.changeReadStatus(!hasUserReadItem);
        Navigator.pop(context);
      },
      title:
          hasUserReadItem ? "Als ungelesen markieren" : "Als gelesen markieren",
    );
  }
}

class _PageWithPicture extends StatelessWidget {
  const _PageWithPicture(this.view);

  static const double _appBarHeight = 250;
  double _getAppBarHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.3;
  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: _getAppBarHeight(context) - _kFabHalfSize,
          leading: CloseIconButton(color: getAppBarIconColor(view.hasPhoto)),
          elevation: 1,
          pinned: true,
          actions: _actions(view),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: view.id,
              child: Image.asset(
                view.pictureURL!,
                fit: BoxFit.cover,
                height: _appBarHeight,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _Body(view)),
      ],
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({this.view});

  final BlackboardView? view;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Eintrag löschen',
      icon: Icon(Icons.delete, color: getAppBarIconColor(view!.hasPhoto)),
      onPressed:
          () => showDeleteBlackboardItemDialog(context, view, popTwice: true),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({this.view});

  final BlackboardView? view;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Bearbeiten",
      icon: Icon(Icons.edit, color: getAppBarIconColor(view!.hasPhoto)),
      onPressed: () => onEdit(context, view!.item),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.view);

  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        top: false,
        left: true,
        right: true,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(
                12,
              ).add(const EdgeInsets.symmetric(horizontal: 8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _CourseChip(courseName: view.courseName),
                  _Title(title: view.title),
                  _InformationHeader(view),
                  const SizedBox(height: 16),
                  _Text(text: view.text),
                ],
              ),
            ),
            _AttachmentList(view: view),
            CommentSectionBuilder(
              itemId: view.id,
              commentOnType: CommentOnType.blackboard,
              courseID: view.courseID,
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseChip extends StatelessWidget {
  const _CourseChip({this.courseName});

  final String? courseName;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(courseName!));
  }
}

class _Title extends StatelessWidget {
  const _Title({this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SelectableText(
        title!,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).isDarkTheme ? null : Colors.black,
        ),
      ),
    );
  }
}

class _InformationHeader extends StatelessWidget {
  const _InformationHeader(this.view);

  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    final greyTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            "${view.createdOnText}   -   ${view.authorName}",
            style: greyTextStyle,
          ),
          view.hasPermissionToEdit ? _UserReadTile(view: view) : Container(),
        ],
      ),
    );
  }
}

class _UserReadTile extends StatefulWidget {
  const _UserReadTile({required this.view});

  final BlackboardView view;

  @override
  __UserReadTileState createState() => __UserReadTileState();
}

class __UserReadTileState extends State<_UserReadTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () => _navigateToBlackboardItemReadByUsersListPage(),
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Diese Information ist für dich als ${widget.view.isAuthor ? "Autor" : "Admin"} sichtbar.",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        "Gelesen von: ${widget.view.readPercent}%",
                        style: TextStyle(color: widget.view.readPercentColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rightArrow() {
    return GestureDetector(
      onTap: () {
        _navigateToBlackboardItemReadByUsersListPage();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              Theme.of(context).isDarkTheme
                  ? Colors.grey[400]
                  : Colors.grey[300],
        ),
        width: 30,
        height: 30,
        child: Icon(Icons.keyboard_arrow_right, color: Colors.grey[700]),
      ),
    );
  }

  void _navigateToBlackboardItemReadByUsersListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlackboardItemReadByUsersListPage(
              itemId: widget.view.id,
              courseId: CourseId(widget.view.courseID),
            ),
        settings: const RouteSettings(
          name: BlackboardItemReadByUsersListPage.tag,
        ),
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return Container();
    final theme = Theme.of(context);
    return MarkdownBody(
      data: text!,
      selectable: true,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(
        theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            bodyMedium: flowingText.copyWith(
              color:
                  Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ).copyWith(a: linkStyle(context, 15)),
      // styleSheet: MarkdownStyleSheet(
      //   // Schriftfarbe muss manuell festgelegt wwerden, weil ansonsten die Schriftfarbe
      //   // immer weiß ist. Ticket: https://github.com/flutter/flutter_markdown/issues/198

      //   p: flowingText.copyWith(
      //       color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black),
      //   a: linkStyle(context, 15),
      // ),
      onTapLink: (url, _, _) => launchURL(url, context: context),
    );
  }
}

class _AttachmentList extends StatelessWidget {
  const _AttachmentList({required this.view});

  final BlackboardView view;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    if (!view.hasAttachments) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DividerWithText(
            text: 'Anhänge: ${view.attachmentIDs.length}',
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          AttachmentStreamList(
            cloudFileStream: api.fileSharing.cloudFilesGateway
                .filesStreamAttachment(view.courseID, view.id),
            courseID: view.courseID,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
