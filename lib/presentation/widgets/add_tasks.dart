import "package:flutter/material.dart";

class AddTasks extends StatefulWidget {
  const AddTasks({
    super.key,
    required this.tasksController,
    required this.cancel,
    required this.add,
  });

  final TextEditingController tasksController;
  final void Function()? cancel;
  final void Function()? add;

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      // backgroundColor:Colors.transparent,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: widget.tasksController,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 18),
                  minLines: 1,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: "Enter...",
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    enabledBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                    focusedBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                    focusedErrorBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                    errorBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:widget.cancel,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap:widget.add,
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
