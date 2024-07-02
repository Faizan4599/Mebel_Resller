import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/text_field.dart';
import '../../../constant/constant.dart';
import '../../../utils/common_colors.dart';
import '../bloc/get_quote_bloc.dart';

class GetQuoteUI extends StatelessWidget {
  GetQuoteUI({Key? key}) : super(key: key);
  final GetQuoteBloc _getQuoteBloc = GetQuoteBloc();
  final TextEditingController customerNameTxt = TextEditingController();
  final TextEditingController customerAddressTxt = TextEditingController();
  final TextEditingController customerPhoneTxt = TextEditingController();
  final TextEditingController customerTNCTxt = TextEditingController();
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    _getQuoteBloc.add(GetQuoteInitEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<GetQuoteBloc, GetQuoteState>(
              bloc: _getQuoteBloc,
              buildWhen: (previous, current) =>
                  current is GetQuoteTNCSuccessState,
              builder: (context, state) {
                if (state is GetQuoteTNCSuccessState) {
                  customerTNCTxt.text = state.tnc ?? "NA";
                }
                return userForm(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget userForm(BuildContext context) {
    final List<TextFieldConfig> textfields = [
      TextFieldConfig(
          title: "CUSTOMER NAME",
          controller: customerNameTxt,
          hintText: "Enter name",
          height: 50,
          maxline: 1),
      TextFieldConfig(
          title: "CUSTOMER ADDRESS",
          controller: customerAddressTxt,
          hintText: "Enter address",
          height: 50,
          maxline: 1),
      TextFieldConfig(
          title: "CUSTOMER PHONE",
          controller: customerPhoneTxt,
          hintText: "Enter phone number",
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
          height: 50,
          maxline: 1),
      TextFieldConfig(
        title: "TEARMS AND CONDITIONS",
        controller: customerTNCTxt,
        hintText: "Tearms & conditions",
        keyboardType: TextInputType.multiline,
        maxline: 10,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          ...textfields
              .map(
                (config) => _buildCustomFormField(context, config),
              )
              .toList(),
          Row(
            children: [
              Text(
                "GST Included",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              BlocBuilder<GetQuoteBloc, GetQuoteState>(
                bloc: _getQuoteBloc,
                buildWhen: (previous, current) =>
                    current is GetQuoteCheckBoxState,
                builder: (context, state) {
                  if (state is GetQuoteCheckBoxState) {
                    checkboxValue = state.checkboxVal;
                  }
                  return Checkbox(
                    value: checkboxValue,
                    onChanged: (value) {
                      _getQuoteBloc
                          .add(GetQuoteCheckBoxEvent(checkboxVal: value!));
                    },
                  );
                },
              )
            ],
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocListener<GetQuoteBloc, GetQuoteState>(
                bloc: _getQuoteBloc,
                listenWhen: (previous, current) =>
                    current is GetQuoteInsertQuotState ||
                    current is GetQuoteValidationErrorState ||
                    current is GetQuoteErrorState,
                listener: (context, state) {
                  if (state is GetQuoteInsertQuotState) {
                    Constant.showShortToast(state.message);
                  } else if (state is GetQuoteValidationErrorState) {
                    Constant.showShortToast(state.message);
                  } else if (state is GetQuoteErrorState) {
                    Constant.showShortToast(state.message.toString());
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    _getQuoteBloc.add(
                      GetQuoteGenrateQuoteEvent(
                          custName: customerNameTxt.text,
                          custAddress: customerAddressTxt.text,
                          custPhone: customerPhoneTxt.text,
                          tnc: customerTNCTxt.text,
                          is_gst_quote: checkboxValue),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: CommonColors.primary,
                  ),
                  child: const Text(
                    "Generate quote",
                    style: TextStyle(color: CommonColors.planeWhite),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFormField(BuildContext context, TextFieldConfig config) {
    return customTextfield(
        title: config.title,
        titleStyle: Theme.of(context).textTheme.labelLarge,
        txtHeight: config.height,
        txtWidth: Constant.screenWidth(context),
        txtStyle: Theme.of(context).textTheme.bodyMedium,
        keyboardType: config.keyboardType,
        inputFormatters: config.inputFormatters,
        cursorColor: CommonColors.primary,
        controller: config.controller,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CommonColors.primary, width: 2),
        ),
        hintText: config.hintText,
        hintStyle: TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        maxLines: config.maxline);
  }
}

class TextFieldConfig {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxline;
  final double? height;

  TextFieldConfig(
      {required this.title,
      required this.controller,
      required this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.maxline,
      this.height});
}
