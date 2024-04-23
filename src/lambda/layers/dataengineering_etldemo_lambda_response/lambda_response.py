from typing import TypedDict

class LambdaResponse(TypedDict):
    """A class to represent a default response for a lambda function."""
    status_code: int
    body: str

def new_response(status_code: int, body: str) -> LambdaResponse:
    """
    Create a new response for a lambda function.
    
    Args:
        status_code: int: The status code of the response.
        body: str: The body of the response.
        
    Returns:
        LambdaResponse: The response object.
    """
    return LambdaResponse(status_code=status_code, body=body)