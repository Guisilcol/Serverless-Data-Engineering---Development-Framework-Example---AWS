import inquirer 

def separator() -> None:
    print("\n" + "-" * 50 + "\n")

def check_boxes(name: str, options: list[str]) -> list[str]:
    
    questions = [
        inquirer.Checkbox('options',
            message="Select the options",
            choices=options,
        ),
    ]
    
    try:
        answers = inquirer.prompt(questions, raise_keyboard_interrupt=True)
        return answers[name], None

    except KeyboardInterrupt:
        return None, Exception("Check boxes prompt was interrupted by user")

    except BaseException as e:
        return None, e

    

