import os


# render files in .helm/templates directory on a separate step because it has
# same template syntax as jinja2 (we use erb syntax for cookiecutter variables
# in these files)
def render_helm_files():
    for root, dirs, files in os.walk(".helm/templates"):
        for file in files:
                with open(os.path.join(root, file), "r") as f:
                    content = f.read()

                content = content.replace("<%= cookiecutter.project_slug | to_lower_camel %>", "{{ cookiecutter.project_slug | to_lower_camel }}")

                with open(os.path.join(root, file), "w") as f:
                    f.write(content)


render_helm_files()
