//This page - Where Flutter Hooks+BloC come together.
//
//Why Hookwidget instead of StatefulWidget?
//StatefulWidgets needs:initState, dispose,setState,controller field.....
//HookWidget replaces all of that with single-line hook calls.
//
//Hooks used here:
// useTexteditingController()   ->replaces TextEditingController + dispose()
// useFocusNode()               ->replaces FocusNode + dispose()
// useEffect()                  ->replaces initState (fires LoadTodosEvent once)
// useState()                   ->replaces a bool field + setState()
// useBloc()                    ->replaces BlocProvider + dispose()

//----------------------------------------------------------------------------------
//useBloc() is a custom hook that wraps BlocProvider and dispose()s the bloc.
//The hook returns the bloc instance, which is then used to dispatch events.
//
//useEffect() is used to run side effects (e.g. fetch todos).
//
//useFocusNode() is used to manage focus.
//
//useTexteditingController() is used to manage text input.
//
//useState() is used to manage state.
//---------------------------------------------------------------------------------

import 'package:bloc_todo/features/presentation/bloc/todo_bloc.dart';
import 'package:bloc_todo/features/presentation/bloc/todo_event.dart';
import 'package:bloc_todo/features/presentation/bloc/todo_state.dart';
import 'package:bloc_todo/features/presentation/widgets/todo_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoPage extends HookWidget {
  //<-  HookWWidget, not StatefulWidget!
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    //--------------HOOKS---------------------
    // These replaces all of initState / dispose / setState boilderplate

    //Replaces: final _controller = TextEditingController();  + dispose()
    final controller = useTextEditingController();

    //Replaces: final _focusNode = FocusNode();  + dispose()
    final focusNode = useFocusNode();

    // Replaces:bool _showInput= false; + setState(...)
    final showInput = useState(false);

    //Replaces: initState() { bloc.add(LoadTodosEvent());}
    //The empty [] means "run once when widget mounts"
    useEffect(() {
      context.read<TodoBloc>().add(const LoadTodosEvent());
      return null;
    }, []);

    final bloc = context.read<TodoBloc>();

    //--------------HELPER: submit new todo---------------------
    void submitTodo() {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      bloc.add(AddTodoEvent(title: text));
      controller.clear();
      focusNode.unfocus();
      showInput.value = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Todoss',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        //Stats badge- read BLoc state inline
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Chip(
                    label: Text(
                      '${state.completedCount}/${state.totalCount}',
                      style: const TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),

      //----Body:BlocConsumer = BlocBuilder + BlocListener combined------------
      // BlocBuilder -> rebuilds UI on state change
      //BlocListener -> fires side effects (snackbar,navigation) on state change
      body: BlocConsumer<TodoBloc, TodoState>(
        //listener: side effects only - does NOT rebuild UI
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },

        //builder:UI reconstruction on every state change
        builder: (context, state) {
          return Column(
            //-add todo input bar (shown/hidden via hook state)---------------
            children: [
              //-----Add todo input bar (shown/hidden via hook state)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: showInput.value ? 80 : 0,
                child: showInput.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'What needs to be done?',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (_) => submitTodo(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: submitTodo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              //---todo list-------------------------------
              Expanded(
                child: switch (state) {
                  //loading state
                  TodoLoading() => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  ),

                  //Loaded state with todos
                  TodoLoaded(todos: final todos) when todos.isEmpty => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No todos yet!\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TodoLoaded(todos: final todos) => ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(
                        todo: todo,
                        onToggle: () => bloc.add(ToggleTodoEvent(id: todo.id)),
                        onDelete: () => bloc.add(DeleteTodoEvent(id: todo.id)),
                      );
                    },
                  ),

                  //Error state
                  TodoError(message: final msg) => Center(
                    child: Text(
                      'error:$msg',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                  //Initial/ fallback
                  _=>const SizedBox.shrink(),
                },
              ),
            ],
          );
        },
      ),

      //----FAB toggles the input bar------------------------------
      floatingActionButton:FloatingActionButton(onPressed: (){
        showInput.value=!showInput.value; //<-hook state, no setState needed
        if(!showInput.value){
          controller.clear();
          focusNode.unfocus();
        }
      },
      backgroundColor:const Color(0xFF4F46E5),
      child:Icon(
        showInput.value?Icons.close:Icons.add,
        key:ValueKey(showInput.value),
        color:Colors.white,
      ))
    );
  }
}
