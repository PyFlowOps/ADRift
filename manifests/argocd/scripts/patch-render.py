import os
import yaml
from dotenv import load_dotenv

BASE = os.path.dirname(os.path.abspath(__file__))
MAIN = os.path.abspath(os.path.join(BASE, '..'))

# Let's ensure that the required environment variables are set
required_vars = ['AWS_ACCOUNT_ID', 'REGION', 'IMAGE_NAME']

if os.path.exists(os.path.join(MAIN, '.env')):
    # Load environment variables from .env file if it exists
    load_dotenv(os.path.join(MAIN, '.env'))

def prereq_check():
    """
    Check if the required environment variables are set.
    If not, print an error message and exit.
    """
    for var in required_vars:
        if not os.environ.get(var):
            print(f"Required environment variable '{var}' is not set.")
            exit(1)

if __name__ == "__main__":
    prereq_check() # Check prerequisites
    # Now we can safely import the rest of the modules 

    with open(os.path.join(MAIN, 'overlays', 'application-patch.yaml.template'), 'r') as file:
        adrift_application_data = yaml.safe_load(file)

    # We need to augment the argocd-image-updater annotation with the environment variables
    annotations: dict = adrift_application_data.get('metadata', {}).get('annotations', {})

    for k, v in annotations.items():
        if k == 'argocd-image-updater.argoproj.io/image-list':
            # Replace placeholders with environment variables
            annotations[k] = v.replace('<AWS_ACCOUNT_ID>', os.environ['AWS_ACCOUNT_ID']) \
                              .replace('<REGION>', os.environ['REGION']) \
                              .replace('<IMAGE_NAME>', os.environ['IMAGE_NAME'])
            
    # Write the updated annotations back to the file
    with open(os.path.join(MAIN, 'overlays', 'application-patch.yaml'), 'w') as file:
        yaml.safe_dump(adrift_application_data, file, default_flow_style=False)
