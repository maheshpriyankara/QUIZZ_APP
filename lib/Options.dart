import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final String option;
  final String? selectedOption;
  final Function(String) onTapOption;

  const Options({
    Key? key,
    required this.option,
    required this.selectedOption,
    required this.onTapOption,
  }) : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.selectedOption == widget.option;
  }

  @override
  void didUpdateWidget(covariant Options oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.selectedOption == widget.option;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 3, color: Color(0xffA42Fc1)),
            color: _isSelected ? Color(0xffA42Fc1) : Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
                widget.onTapOption(widget.option);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.option,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isSelected ? Colors.white : null,
                      ),
                    ),
                    Radio(
                      value: widget.option,
                      groupValue: widget.selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _isSelected = !_isSelected;
                        });
                        widget.onTapOption(widget.option);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
