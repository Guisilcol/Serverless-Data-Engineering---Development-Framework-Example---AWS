import terminal
import gui

def check_if_machine_have_requirements() -> Exception | None :
    """
    Check if the machine have the requirements to run the deploy.
    
    Returns:
        None | Exception: None if the machine have the requirements, otherwise an Exception with the error message describing the problem.
    """
    _, err = terminal.run("git -h")
    
    if err:
        return Exception("Git is not installed")
    
    is_repo, err = terminal.run("git rev-parse --is-inside-work-tree")
    
    if err or is_repo.strip() != 'true': 
        return Exception("The current directory is not a git repository")
    
    return None

def main():
    err = check_if_machine_have_requirements()
    
    if err:
        print("The machine is not ready to run the deploy because not have the requirements: ", err)
        return


    commits, err = terminal.run(['git', 'log', '--merges', '--pretty=format:"%h-%Ws"', '--stat'])
    
    if err:
        print('An error occurred when running the git command to return the commits: ', err)
        return
    
    


if __name__ == '__main__':
    main()





