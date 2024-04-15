import subprocess

def run(cmd: str | list[str]) -> tuple[str, None | Exception]:
    """
    Run a command in the terminal and return the output and error if any.
    
    Args:
        cmd (str): The command to run in the terminal.
    
    Returns:
        tuple[str, None | Exception]: The output and error if any.
    """
    try:
        if isinstance(cmd, str):
            cmd = cmd.split(' ')
            
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)

        val = result.stdout.strip()
        err = result.stderr.strip()

        if err:
            return None, Exception(err)

        return val, None
    
    except subprocess.CalledProcessError as e:
        stderr_value: str = e.stderr
        err = stderr_value.strip()
        
        return None, Exception(err)
    
    except Exception as e:
        return None, e