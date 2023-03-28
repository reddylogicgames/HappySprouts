// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/abnahme/view_submissions_page_bloc.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

import 'abgaben_abnahme_gateway.dart';

class ViewSubmissionsPageBlocFactory extends BlocBase {
  ViewSubmissionsPageBlocFactory({
    @required this.gateway,
    @required this.nutzerId,
  });

  final AbgabenAbnahmeGateway gateway;
  final UserId nutzerId;

  ViewSubmissionsPageBloc create(String homeworkId) {
    var homeworkId0 = HomeworkId(homeworkId);
    final abgabeId = AbgabeId(AbgabezielId.homework(homeworkId0), nutzerId);

    return ViewSubmissionsPageBloc(
      homeworkId: homeworkId0,
      abgabedatumStream:
          gateway.streamAbgabezeitpunktFuerHausaufgabe(homeworkId0),
      abgegebeneAbgaben: gateway.streamAbgabenFuerHausaufgabe(homeworkId0),
      vonAbgabeBetroffendeNutzer: gateway.vonAbgabeBetroffendeNutzer(abgabeId),
    );
  }

  @override
  void dispose() {}
}
