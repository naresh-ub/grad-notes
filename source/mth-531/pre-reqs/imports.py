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
from utils.render_utils import render_local, render_scene_with_quality
from utils.manim_utils import arrays, graphs, grids, linkedlists, queues, stacks, trees
from manim import *

import matplotlib.pyplot as plt


