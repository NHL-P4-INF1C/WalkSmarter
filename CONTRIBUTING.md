## Flutter Code Conventions

1. **File Naming**: Use lowercase letters with underscores separating words for file names. For example, `my_widget.dart`.

   ```dart
   // Example file name: my_widget.dart
   ```

2. **Class Naming**: Use UpperCamelCase for class names. For example, `MyWidget`.

   ```dart
   class MyWidget {
     // class definition
   }
   ```

3. **Variable Naming**: Use lowerCamelCase for variable names. For example, `myVariable`.

   ```dart
   var myVariable = 10;
   ```

4. **Constant Naming**: Use `UPPERCASE_WITH_UNDERSCORES` for constant names. For example, `MY_CONSTANT`.

   ```dart
   const MY_CONSTANT = 42;
   ```

5. **Indentation**: Use 2 spaces for indentation.

   ```dart
   void main() {
     print('Indented with 2 spaces');
   }
   ```

6. **Brackets**: Use the K&R style for brackets placement.

   ```dart
   void main() {
       print('Brackets on their own lines');
   }
   ```

7. **Quotes**: Use double quotes for strings and single quotes for chars.

   ```dart
   var myString = "Hello, world!";
   var myChar = 'a';
   ```

8. **Comments**: Use `//` for single-line comments and `/* */` for multi-line comments.

   ```dart
   // Single-line comment

   /*
   Multi-line
   comment
   */
   ```

10. **Widget Declaration**: Organize widgets in a hierarchical manner. Use indentation to denote the widget tree structure.

    ```dart
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Widget Declaration Example'),
        ),
        body: Column(
          children: [
            Text('First Widget'),
            Text('Second Widget'),
          ],
        ),
      );
    }
    ```

11. **Widget Properties**: Group related properties together and order them alphabetically.

    ```dart
    Widget build(BuildContext context) {
      return Container(
        alignment: Alignment.center,
        color: Colors.blue,
        height: 100,
        width: 100,
      );
    }
    ```

12. **Widget Building**: Prefer composition over inheritance. Break down complex widgets into smaller, reusable components.

    ```dart
    class MyWidget extends StatelessWidget {
      @override
      Widget build(BuildContext context) 
      {
        return Container(
          child: Column(
            children: [
              SubWidget1(),
              SubWidget2(),
            ],
          ),
        );
      }
    }

    class SubWidget1 extends StatelessWidget {
      @override
      Widget build(BuildContext context) 
      {
        return Text('SubWidget1');
      }
    }

    class SubWidget2 extends StatelessWidget {
      @override
      Widget build(BuildContext context) 
      {
        return Text('SubWidget2');
      }
    }
    ```

13. **Error Handling**: Implement error handling using try-catch blocks where appropriate.

    ```dart
    try {
      // Code that might throw an error
    } 
    catch (e) {
      // Handle the error
    }
    ```

14. **Async/Await**: Prefer async/await syntax over using then() for handling asynchronous operations.

    ```dart
    Future<void> fetchData() async {
      try {
        var data = await fetchDataFromServer();
        // Handle data
      } 
      catch (e) {
        // Handle error
      }
    }
    ```
