import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class FormPage extends StatelessWidget {
  final bool isEditing;

  FormPage({
    Key key,
    @required this.isEditing,
  })  : super(key: key ?? Key(isEditing ? 'editing' : 'creating'));

  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(isEditing ? "Edit Herd Record" : "New Herd Record"),
      ),
      body: FormKeyboardActions(
        child: _FormContent(
          isEditing: isEditing,
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  final bool isEditing;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormState> formKey;

  _FormContent({
    Key key,
    @required this.isEditing,
    @required this.formKey,
    @required this.scaffoldKey,
  });

  @override _FormContentState createState() => _FormContentState(
    nameTextEditingController: TextEditingController(text: null),
  );
}

class _FormContentState extends State<_FormContent> {
  final FocusNode focusNodeName = FocusNode();

  final TextEditingController nameTextEditingController;

  _FormContentState({
    @required this.nameTextEditingController,
  });

  GlobalKey<FormState> get _formKey => widget.formKey;
  GlobalKey<ScaffoldState> get _scaffoldKey => widget.scaffoldKey;

  String _name;

  @override
  void initState() {
    _name = '';

    // Configure keyboard actions
    FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(focusNode: focusNodeName),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(bottom: false,
                child: Align(alignment: Alignment.center,
                  child: Container(constraints: BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 16),
                        _nameField(), const SizedBox(height: 24),
                      ],
                    )
                  )
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      focusNode: focusNodeName,
      initialValue: _name,
      decoration: const InputDecoration(labelText: 'Name'),
    );
  }

  @override
  void dispose() {
    focusNodeName.dispose();
    nameTextEditingController.dispose();

    super.dispose();
  }
}
