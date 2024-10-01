import sys
import os

# Get the current working directory (this should be your mth-531 folder)
current_dir = os.path.dirname(os.path.abspath(__file__))

# Assuming 'utils' is one level above 'mth-531'
utils_path = os.path.abspath(os.path.join(current_dir, '../../'))

# Add 'utils' directory to sys.path if it's not already added
if utils_path not in sys.path:
    sys.path.append(utils_path)

# Manim related
from utils.render_utils import render_manim
from manim import *

# try importing utils.constants if import failed, it's okay
try:
    from utils.constants import plotly_user, plotly_api_key
except:
    pass

# upload the plot to the cloud
# import chart_studio
# import chart_studio.plotly as py
# from imports import *
# chart_studio.tools.set_credentials_file(username=plotly_user, api_key=plotly_api_key)
# url = py.plot(fig, filename='sankey_energy_forecast', auto_open=False)
# print(f"Plot is available at: {url}")
