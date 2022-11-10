import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text(R.strings.addAccount.toUpperCase()),
    );
  }
}
